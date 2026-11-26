// MAINDEC

module maindec(input logic [10:0] Op,
                     output logic [1:0] ALUOp,
                     output logic Reg2Loc, ALUSrc, MemtoReg, RegWrite,
                                              MemRead, MemWrite, Branch);

  always_comb
    casez (Op)
      11'b111_1100_0010:
        {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b0_1111_0000; // LDUR
      11'b111_1100_0000:
        {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b1_1000_1000; // STUR
      11'b101_1010_0???:
        {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b1_0000_0101; // CBZ
      11'b100_0101_1000:
        {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b0_0010_0010; // ADD
      11'b110_0101_1000:
        {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b0_0010_0010; // SUB
      11'b100_0101_0000:
        {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b0_0010_0010; // AND
      11'b101_0101_0000:
        {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b0_0010_0010; // OR
      11'b110_1001_01??:
        {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b0_1010_0011; // MOVZ
      default:
        {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 9'b0;
    endcase

endmodule
