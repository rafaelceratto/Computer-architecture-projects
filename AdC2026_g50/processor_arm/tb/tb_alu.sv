`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.08.2026 21:14:45
// Design Name: 
// Module Name: tb_alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_alu();
    logic [63:0] a;
    logic [63:0] b;
    logic [3:0] ALUControl;
    logic [63:0] result;
    logic zero;
    
    alu dut(.a(a), .b(b), .ALUControl(ALUControl), .result(result), .zero(zero));
    
    initial
        begin
            // CASO POSITIVO Y POSITIVO.
            a = 64'd10; b = 64'd5;
            ALUControl = 4'b0000; #10;
            ALUControl = 4'b0001; #10;
            ALUControl = 4'b0010; #10;
            ALUControl = 4'b0110; #10;
            ALUControl = 4'b0111; #10;
            
            // CASO NEGATIVO Y NEGATIVO
            a = -64'sd10; b = -64'sd5;
            ALUControl = 4'b0000; #10;
            ALUControl = 4'b0001; #10;
            ALUControl = 4'b0010; #10;
            ALUControl = 4'b0110; #10;
            ALUControl = 4'b0111; #10;
            
            // CASO POSITIVO Y NEGATIVO
            a = 64'd10; b = -64'sd5;
            ALUControl = 4'b0000; #10;
            ALUControl = 4'b0001; #10;
            ALUControl = 4'b0010; #10;
            ALUControl = 4'b0110; #10;
            ALUControl = 4'b0111; #10;
            
            // CASO DE PRUEBA DE OVERFLOW
            a = 64'h7FFF_FFFF_FFFF_FFFF; // max positivo de 64 bits
            b = 64'd1; 
            ALUControl = 4'b0010; #10; // suma que causa overflow
            
            // CASO DE VERIFICACION DE BANDERA ZERO
            a = 64'd10; b = 64'd10;
            ALUControl = 4'b0110; #10;
            if(zero !== 1'b1) $display("Error: zero debería ser 1");
            
            a = 64'd10; b = 64'd11;
            ALUControl = 4'b0110; #10;
            if(zero !== 1'b0) $display("Error: zero deberia ser 0");
            
            $finish;
        end
            
endmodule
