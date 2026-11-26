`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/26/2026 11:26:07 AM
// Design Name: 
// Module Name: tb_fetch
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


module tb_fetch();
    logic PCSrc_F;
    logic clk;
    logic reset;
    logic [63 :0]PCbranch_F;
    logic  [63:0] imem_addr_F;
    
    fetch dut(.PCSrc_F(PCSrc_F), .clk(clk), .reset(reset), .PCbranch_F(PCbranch_F), .imem_addr_F(imem_addr_F));
    
    always
        begin
            clk = 1; #5; clk = 0; #5;
        end
    
    initial
        begin
            reset = 1; 
            PCbranch_F = 64'd10; 
            PCSrc_F = 0;
            
            
            repeat(5) @(posedge clk); 
            #1;
            if(imem_addr_F !== 0) begin $display ("Error: la salida reset debe ser 0");
            end
            
            reset = 0;
           
            repeat(5) begin 
            @(posedge clk); 
            #1;
            $display ("El valor del PC es: %0d", imem_addr_F);
            end
            
            PCSrc_F = 1;
            @(posedge clk); 
            #1;
            $display ("El valor que tomo el PC es: %0d", imem_addr_F);
            
            $finish;
            end
endmodule
