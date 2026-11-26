// Testbench maindec

module maindec_tb();

  logic [10:0] Op;
  logic [1:0] ALUOp;
  logic Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;

  // instantiate dut
  maindec dut(.Op(Op),
              .ALUOp(ALUOp),
              .Reg2Loc(Reg2Loc),
              .ALUSrc(ALUSrc),
              .MemtoReg(MemtoReg),
              .RegWrite(RegWrite),
              .MemRead(MemRead),
              .MemWrite(MemWrite),
              .Branch(Branch));

  /* appli inputs and check results
     one at a time */
  initial begin
    // LDUR
    Op = 11'b111_1100_0010; #10;
    if ({Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} !== 9'b0_1111_0000)
      $display("111_1100_0010 - LDUR - failed.");

    // STUR
    Op = 11'b111_1100_0000; #10;
    if ({Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} !== 9'b1_1000_1000)
      $display("111_1100_0000 - STUR - failed.");

    // CBZ
    Op = 11'b101_1010_0000; #10;
    if ({Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} !== 9'b1_0000_0101)
      $display("101_1010_0000 - CBZ - failed.");
    Op = 11'b101_1010_0101; #10;
    if ({Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} !== 9'b1_0000_0101)
      $display("101_1010_0101 - CBZ - failed.");
    Op = 11'b101_1010_0100; #10;
    if ({Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} !== 9'b1_0000_0101)
      $display("101_1010_0100 - CBZ - failed.");

    // ADD
    Op = 11'b100_0101_1000; #10;
    if ({Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} !== 9'b0_0010_0010)
      $display("100_0101_1000 - ADD - failed.");

    // SUB
    Op = 11'b110_0101_1000; #10;
    if ({Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} !== 9'b0_0010_0010)
      $display("110_0101_1000 - SUB - failed.");

    // AND
    Op = 11'b100_0101_0000; #10;
    if ({Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} !== 9'b0_0010_0010)
      $display("100_0101_0000 - AND - failed.");

    // OR
    Op = 11'b101_0101_0000; #10;
    if ({Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} !== 9'b0_0010_0010)
      $display("101_0101_0000 - OR - failed.");
      // MOVZ
    Op = 11'b110_1001_0100; #10;
    if ({Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} !== 9'b0_1010_0011)
      $display("110_1001_0100 - MOVZ - failed.");
    Op = 11'b110_1001_0100; #10;
    if ({Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} !== 9'b0_1010_0011)
      $display("110_1001_0101 - MOVZ - failed.");
    Op = 11'b110_1001_0100; #10;
    if ({Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} !== 9'b0_1010_0011)
      $display("110_1001_0110 - MOVZ - failed.");
    Op = 11'b110_1001_0100; #10;
    if ({Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} !== 9'b0_1010_0011)
      $display("110_1001_0111 - MOVZ - failed.");
  end
  
endmodule
