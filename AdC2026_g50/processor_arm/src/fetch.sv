`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/26/2026 11:25:16 AM
// Design Name: 
// Module Name: fetch
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


module fetch #(parameter N = 64)
    (input logic PCSrc_F,
    input logic clk,
    input logic reset,
    input logic enable_F, // 1 = el PC avanza, 0 se congela
    input logic [N-1 :0] PCBranch_F,
    output logic  [N -1:0] imem_addr_F
);

    logic [N-1:0] conector_mux;
    logic [N-1: 0] salida_mux;
    
    mux2 #(64) conexion_mux (.d0(conector_mux), .d1(PCBranch_F), .s(PCSrc_F), .y(salida_mux));
    // paso de flopr a flopre
    //flopr #(64) conexion_flopr(.d(salida_mux), .clk(clk), .reset(reset), .q(imem_addr_F));
    flopre #(64) conexion_flopr(.d(salida_mux), .clk(clk), .reset(reset), .enable(enable_F), .q(imem_addr_F));
    adder #(64) conexion_adder (.a(imem_addr_F), .b(64'd4), .y(conector_mux));
    
    
endmodule
