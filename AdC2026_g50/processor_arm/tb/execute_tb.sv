// Testbench execute

module execute_tb();

  logic AluSrc;
  logic [3:0] AluControl;
  logic [63:0] PC_E;
  logic [63:0] signImm_E;
  logic [63:0] readData1_E;
  logic [63:0] readData2_E;
  logic [63:0] PCBranch_E;
  logic [63:0] aluResult_E;
  logic [63:0] writeData_E;
  logic zero_E;

  // instantiate dut
  execute dut(.AluSrc(AluSrc),
              .AluControl(AluControl),
              .PC_E(PC_E),
              .signImm_E(signImm_E),
              .readData1_E(readData1_E),
              .readData2_E(readData2_E),
              .PCBranch_E(PCBranch_E),
              .aluResult_E(aluResult_E),
              .writeData_E(writeData_E),
              .zero_E(zero_E)
              );

  // Apply inputs and check results one at a time
  initial begin
    // sl2 + adder
    AluSrc = 0; AluControl = 4'b0111;
    PC_E = 64'd1000; signImm_E = 64'd5;
    readData1_E = 64'd0; readData2_E = 64'd0; #10;
    if (PCBranch_E !== 64'd1020)
      $display("sl2 + adder - PCBranch_E - failed.");

    // mux (AluSrc <-- 0) + alu (add)
    AluSrc = 0; AluControl = 4'b0010;
    PC_E = 64'd1000; signImm_E = 64'd0;
    readData1_E = 64'd12; readData2_E = 64'd11; #10;
    if (aluResult_E !== 64'd23)
      $display("mux 0 + alu add  - aluResult_E - failed.");

    // mux (AluSrc <-- 1) + alu (add)
    AluSrc = 1; AluControl = 4'b0010;
    PC_E = 64'd1000; signImm_E = 64'd5;
    readData1_E = 64'd12; readData2_E = 64'd11; #10;
    if (aluResult_E !== 64'd17)
      $display("mux 1 + alu add - aluResult_E - failed.");

    // zero_E = 1
    AluSrc = 0; AluControl = 4'b0110;
    readData1_E = 64'd23; readData2_E = 64'd23; #10;
    if ({aluResult_E, zero_E} !== {64'd0, 1'b1})
      $display("sub equal - zero_E - failed.");

    // zero_E = 0
    AluSrc = 0; AluControl = 4'b0110;
    readData1_E = 64'd23; readData2_E = 64'd0; #10;
    if ({aluResult_E, zero_E} !== {64'd23, 1'b0})
      $display("sub unequal - zero_E - failed.");

    // alu (and)
    AluSrc = 0; AluControl = 4'b0000;
    readData1_E = 64'h0000_FFFF_00FF_FFFF;
    readData2_E = 64'hFFFF_0000_FF00_00FF; #10;
    if (aluResult_E !== 64'h0000_0000_0000_00FF)
      $display("and - failed.");

    // alu (or)
    AluSrc = 0; AluControl = 4'b0001;
    readData1_E = 64'h0000_FFFF_00FF_0000;
    readData2_E = 64'hFFFF_0000_FF00_00FF; #10;
    if (aluResult_E !== 64'hFFFF_FFFF_FFFF_00FF)
      $display("or - failed.");
        
    // writeData_E = readData2_E
    readData2_E = 64'hBABA_DCDC_FEFE_1234; #10;
    if (writeData_E !== 64'hBABA_DCDC_FEFE_1234)
      $display("writeData_E - failed.");
  end
  
endmodule
