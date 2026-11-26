`timescale 1ns / 1ps
module tb_signext();
    logic [31:0]a; 
    logic [63:0]y;
    signext dut(a,y);
    initial begin
        //ldur con inmediato signado positivo
        a=32'b1111_1000_0100_0000_0100_0000_0110_0001;#10;
        //ldur con inmediato signado negativo
        a=32'b1111_1000_0101_1111_1100_0000_0110_0001;#10;
        //stur con inmediato signado positivo
        a=32'b1111_1000_0000_0000_0100_0000_0110_0001;#10;
        //stur con inmediato signado negativo
        a=32'b1111_1000_0001_1111_1100_0000_0110_0001;#10;
        //cbz con inmediato signado positivo
        a=32'b1011_0100_0000_0000_0000_0010_0100_1010;#10;
        //cbz con inmediato signado negativo
        a=32'b1011_0100_1000_0000_0000_0010_0100_1010;#10;
        // MOVZ con inmediato de 16 bits (0xFFFF)
        //Posicion de inmediato de LSL=00 (0 a 15)
        a = 32'b1101_0010_1001_1111_1111_1111_1110_0000; #10;
        //Posicion de inmediato de LSL=01 (16 a 31)
        a = 32'b1101_0010_1011_1111_1111_1111_1110_0000; #10;
        //Posicion de inmediato de LSL=10 (32 a 47)
        a = 32'b1101_0010_1101_1111_1111_1111_1110_0000; #10;
        //Posicion de inmediato de LSL=11 (48 a 63)
        a = 32'b1101_0010_1111_1111_1111_1111_1110_0000; #10;
        //instruccion que no esta en la tabla
        a=32'b1011_0001_0000_0000_0000_1101_0101_0010;#10;
        end

endmodule