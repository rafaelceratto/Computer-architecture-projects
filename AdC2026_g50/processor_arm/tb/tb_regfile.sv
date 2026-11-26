`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/25/2026 07:00:18 PM
// Design Name: 
// Module Name: tb_regfile
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


module tb_regfile();
    logic clk,we3;
    logic [4:0] ra1;
    logic [4:0] ra2;
    logic [4:0] wa3;
    logic [63:0] wd3;
    logic [63:0] rd1;
    logic [63:0] rd2;
    
    regfile #(64) dut(.clk(clk),.ra1(ra1),.ra2(ra2),.wa3(wa3),.wd3(wd3),.we3(we3),.rd1(rd1),.rd2(rd2));
    
     always 
        begin        
            clk = 1 ; #5 ; clk = 0; #5;
        end
        
      initial 
        begin 
            @(negedge clk); //flanco desc
            
            for(int i = 0; i < 32 ; i++) begin
                ra1 = i;
                ra2 = i;
                @(negedge clk);//avanzo solo cuando es flanco desc
                
                if(i != 31) begin
                    if(rd1 != i) $display("Error en la salida rd1 para el registro numero %0d",i);
                    if(rd2 != i) $display("Error en la salida rd2 para el registro numero %0d",i);
                end    
                else begin
                    if(rd1 != 0) $display("Error en la salida rd1 para el registro numero %0d",i);
                    if(rd1 != 0) $display("Error en la salida rd1 para el registro numero %0d",i);
                end    
             end
            
           //caso donde se tiene que escribir 
           we3 = 1; 
           wd3 = 64'd20;
           wa3 = 5'd25;
           ra1 = 5'd25;
           
           @(posedge clk);
           #1;
           if(rd1 !== 64'd20) begin $display("Error en la salida rd1, no se escribio el registro");
           end
            
           //caso donde no escribe
           we3 = 0; 
           wd3 = 64'd28;
           wa3 = 5'd25;
           ra1 = 5'd25;
           
           @(posedge clk);
           #1;
           if(rd1 == 64'd28) begin $display("Error en la salida rd1, se sobreescribio el registro");
           end
            
           //escribir registro XZR
           we3 = 1; 
           wd3 = 64'd20;
           wa3 = 5'd31;
           ra1 = 5'd31;
           
           @(posedge clk);
           #1;
           if(rd1 !== 64'd0) begin $display("Error en la salida rd1, se escribio el registro XZR");
           end
          
         $finish;  
         end
endmodule
