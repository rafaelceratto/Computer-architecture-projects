// DATAPATH

module datapath #(parameter N = 64, parameter bit PIPELINE = 1)
					(input logic reset, clk,
					input logic reg2loc,
					input logic AluSrc,
					input logic [3:0] AluControl,
					input logic	Branch,
					input logic memRead,
					input logic memWrite,
					input logic regWrite,
					input logic memtoReg,
					input logic [31:0] IM_readData,
					input logic [N-1:0] DM_readData,
					output logic [N-1:0] IM_addr, DM_addr, DM_writeData,
					output logic DM_writeEnable, DM_readEnable,
                    output logic stall ); 

	generate
	if (PIPELINE) begin : gen_pipeline

		logic PCSrc;
		logic [N-1:0] PCBranch_E, aluResult_E, writeData_E, writeData3;
		logic [N-1:0] signImm_D, readData1_D, readData2_D;
		logic zero_E;
		logic [95:0] qIF_ID;
		logic [280:0] qID_EX;
		logic [202:0] qEX_MEM;
		logic [134:0] qMEM_WB;
		logic [4:0] ra2_D; // registro que lee el operando B (Rm o Rt), para el forwarding
		logic [1:0] forwardA_E, forwardB_E; // salidas de forwarding unit
        logic [N-1:0] srcA_E, srcB_E; // operandos ya "adelantados" que van a la ALU
        logic stall_D; // la HDU pide frenar el pipeline
        logic [9:0] ctrl_D; // señales de control que entran al ID/EX (en 0 si hay stall)

		fetch 	#(64) 	FETCH 	(.PCSrc_F(PCSrc),
										.clk(clk),
										.reset(reset),
										.PCBranch_F(qEX_MEM[197:134]),
										.imem_addr_F(IM_addr),
										.enable_F(~stall_D));


		flopre 	#(96)		IF_ID 	(.clk(clk),
										.reset(reset),
										.d({IM_addr, IM_readData}),
										.q(qIF_ID),
										.enable(~stall_D));


		decode 	#(.N(64), .PIPELINE(1)) 	DECODE 	(.regWrite_D(qMEM_WB[134]),
										.reg2loc_D(reg2loc),
										.clk(clk),
										.writeData3_D(writeData3),
										.instr_D(qIF_ID[31:0]),
										.signImm_D(signImm_D),
										.readData1_D(readData1_D),
										.readData2_D(readData2_D),
										.wa3_D(qMEM_WB[4:0]),
										.ra2_D(ra2_D),
										.memRead_E(qID_EX[264]),
										.wa3_E(qID_EX[4:0]),
										.stall_D(stall_D));
        
        mux2 #(10) bubble (.d0({AluSrc, AluControl, Branch, memRead, memWrite, regWrite, memtoReg}),
                           .d1(10'b0),
                           .s(stall_D),
                           .y(ctrl_D));
        
        // ID/EX: [280:276] = ra1 (Rn), [275:271] = ra2 (Rm/Rt) -> usados por la forwarding unit
		flopr 	#(281)	ID_EX 	(.clk(clk),
										.reset(reset),
										.d({qIF_ID[9:5], ra2_D, ctrl_D, qIF_ID[95:32], signImm_D, readData1_D, readData2_D, qIF_ID[4:0]}),
										.q(qID_EX));


		execute 	#(64) 	EXECUTE 	(.AluSrc(qID_EX[270]),
										.AluControl(qID_EX[269:266]),
										.PC_E(qID_EX[260:197]),
										.signImm_E(qID_EX[196:133]),
										.readData1_E(srcA_E), // operando a ya adelantado
										.readData2_E(srcB_E), // operando b ya adelantado
										.PCBranch_E(PCBranch_E),
										.aluResult_E(aluResult_E),
										.writeData_E(writeData_E),
										.zero_E(zero_E));


		flopr 	#(203)	EX_MEM 	(.clk(clk),
										.reset(reset),
										.d({qID_EX[265:261], PCBranch_E, zero_E, aluResult_E, writeData_E, qID_EX[4:0]}),
										.q(qEX_MEM));
        
        // forwarding unit que detecta si la instruccion en EX lee un registro que escribe la de MEM o WB
        forwarding_unit FU (.ra1_E(qID_EX[280:276]),
                            .ra2_E(qID_EX[275:271]),
                            .wa3_M(qEX_MEM[4:0]),
                            .wa3_W(qMEM_WB[4:0]),
                            .regWrite_M(qEX_MEM[199]),
                            .regWrite_W(qMEM_WB[134]),
                            .forwardA(forwardA_E),
                            .forwardB(forwardB_E));
                            
        // muxes de forwarding: 00 = valor del regfile, 01 = dato de WB, 10 = resultado de la ALU en MEM
        mux3 #(64) muxA (.d0(qID_EX[132:69]), .d1(writeData3), .d2(qEX_MEM[132:69]), .s(forwardA_E), .y(srcA_E));
        mux3 #(64) muxB (.d0(qID_EX[68:5]), .d1(writeData3), .d2(qEX_MEM[132:69]), .s(forwardB_E), .y(srcB_E));
                       
                       
		memory				MEMORY	(.Branch_M(qEX_MEM[202]),
										.zero_M(qEX_MEM[133]),
										.PCSrc_M(PCSrc));

		// Salida de señales a Data Memory
		assign DM_writeData = qEX_MEM[68:5];
		assign DM_addr = qEX_MEM[132:69];

		// Salida de señales de control:
		assign DM_writeEnable = qEX_MEM[200];
		assign DM_readEnable = qEX_MEM[201];
		
		assign stall = stall_D;

		flopr 	#(135)	MEM_WB 	(.clk(clk),
										.reset(reset),
										.d({qEX_MEM[199:198], qEX_MEM[132:69],	DM_readData, qEX_MEM[4:0]}),
										.q(qMEM_WB));


		writeback #(64) 	WRITEBACK (.aluResult_W(qMEM_WB[132:69]),
										.DM_readData_W(qMEM_WB[68:5]),
										.memtoReg(qMEM_WB[133]),
										.writeData3_W(writeData3));

	end else begin : gen_single

		logic PCSrc;
		logic [N-1:0] PCBranch, writeData_E, writeData3;
		logic [N-1:0] signImm, readData1, readData2;
		logic zero;


		fetch 	#(64) 	FETCH 	(.PCSrc_F(PCSrc),
										.clk(clk),
										.reset(reset),
										.PCBranch_F(PCBranch),
										.imem_addr_F(IM_addr),
										.enable_F(1'b1));



		decode 	#(.N(64), .PIPELINE(0)) 	DECODE 	(.regWrite_D(regWrite),
										.reg2loc_D(reg2loc),
										.clk(clk),
										.writeData3_D(writeData3),
										.instr_D(IM_readData),
										.signImm_D(signImm),
										.readData1_D(readData1),
										.readData2_D(readData2));



		execute 	#(64) 	EXECUTE 	(.AluSrc(AluSrc),
										.AluControl(AluControl),
										.PC_E(IM_addr),
										.signImm_E(signImm),
										.readData1_E(readData1),
										.readData2_E(readData2),
										.PCBranch_E(PCBranch),
										.aluResult_E(DM_addr),
										.writeData_E(DM_writeData),
										.zero_E(zero));



		memory				MEMORY	(.Branch_M(Branch),
										.zero_M(zero),
										.PCSrc_M(PCSrc));



		writeback #(64) 	WRITEBACK (.aluResult_W(DM_addr),
										.DM_readData_W(DM_readData),
										.memtoReg(memtoReg),
										.writeData3_W(writeData3));

		// Salida de señales de control:
		assign DM_writeEnable = memWrite;
		assign DM_readEnable = memRead;
		// Sin pipeline nunca hay stall
		assign stall = 1'b0;

	end
	endgenerate

endmodule
