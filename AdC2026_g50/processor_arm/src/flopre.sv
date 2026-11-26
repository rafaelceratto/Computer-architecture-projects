`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2026 18:02:04
// Design Name: 
// Module Name: flopre
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


module flopre #(parameter N = 64)(
    input logic clk,
    input logic reset,
    input logic enable,
    input logic [N-1:0] d,
    output logic[N-1:0] q 

);
    always_ff @(posedge clk, posedge reset) begin
        if(reset)
            q <= '0; //Pone la salida en 0 solo si el reset es 1
        else if(enable) // si enable es 1
            q <= d; // Pone la salida en d
        end
endmodule
