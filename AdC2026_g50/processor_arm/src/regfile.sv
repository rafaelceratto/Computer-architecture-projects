`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/25/2026 05:51:05 PM
// Design Name: 
// Module Name: regfile
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


module regfile#(parameter N = 64) (
    input logic clk,
    input logic we3,
    input logic [4:0] ra1,
    input logic [4:0] ra2,
    input logic [4:0] wa3,
    input logic [N-1:0] wd3,
    output logic [N-1:0] rd1,
    output logic [N-1:0] rd2
);
    logic [N-1:0] bank_reg [0:31];
    
    initial begin
        for(int i = 0 ; i < 31; i++) begin
            bank_reg[i] = i;
        end
        bank_reg[31] = '0; //XZR
    end
    
    always_ff @(posedge clk) begin //escritura sincrona
        if(we3 && (wa3 != 5'd31)) begin//chequeo que we3 este en 1 y wa3 no se escriba en XZR
            bank_reg[wa3] <= wd3;
        end
    end
    
    assign rd1 = (ra1 == 5'd31) ? '0 :
                (we3 && (ra1 == wa3)) ? wd3 : 
                 bank_reg[ra1]; 
    assign rd2 = (ra2 == 5'd31) ? '0 : 
                 (we3 && (ra2 == wa3)) ? wd3 : 
                 bank_reg[ra2];
    
    
endmodule
