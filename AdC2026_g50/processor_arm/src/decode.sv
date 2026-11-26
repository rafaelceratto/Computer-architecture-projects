// Etapa: DECODE

module decode #(parameter N = 64, parameter bit PIPELINE = 1)
					(input logic regWrite_D, reg2loc_D, clk,
					input logic [N-1:0] writeData3_D,
					input logic [31:0] instr_D,
					input logic [4:0] wa3_D = '0,
					input logic memRead_E = '0, // instrucción en EX es un LDUR
					input logic [4:0] wa3_E = '0, // destino de la instrucción en EX
					output logic [N-1:0] signImm_D, readData1_D, readData2_D,					
					output logic [4:0] ra2_D,
					output logic stall_D
					);

	logic [4:0] ra2;

	mux2 	#(5) 	ra2mux		(.d0(instr_D[20:16]), .d1(instr_D[4:0]), .s(reg2loc_D), .y(ra2));

	generate
		if (PIPELINE) begin : gen_pipeline
			regfile 		registers 	(.clk(clk), .we3(regWrite_D), .ra1(instr_D[9:5]), .ra2(ra2), .wa3(wa3_D),
											.wd3(writeData3_D), .rd1(readData1_D), .rd2(readData2_D));
		end else begin : gen_single
			regfile 		registers 	(.clk(clk), .we3(regWrite_D), .ra1(instr_D[9:5]), .ra2(ra2), .wa3(instr_D[4:0]),
											.wd3(writeData3_D), .rd1(readData1_D), .rd2(readData2_D));
		end
	endgenerate


	signext 		ext			(.a(instr_D), .y(signImm_D));
	
	assign ra2_D = ra2;
	
	hdu HDU (.memRead_E(memRead_E),
	         .wa3_E(wa3_E),
	         .ra1_D(instr_D[9:5]),
	         .ra2_D(ra2),
	         .stall(stall_D));
	
endmodule
