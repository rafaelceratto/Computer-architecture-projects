`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.08.2026 19:37:09
// Design Name: 
// Module Name: alu
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


module alu(
    input logic [63:0] a,
    input logic [63:0] b,
    input logic [3:0] ALUControl,
    output logic [63:0] result,
    output logic zero
);
    
    always_comb begin 
        case(ALUControl)
            4'b0000: result = a & b; 
            4'b0001: result = a | b;
            4'b0010: result = a + b;
            4'b0110: result = a - b; 
            4'b0111: result = b;
            default: result = 64'b0;
        endcase
    end
    
    assign zero = (result == 64'b0);
    
endmodule
   
    
    
    
