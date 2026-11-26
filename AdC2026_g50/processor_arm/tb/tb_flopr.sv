`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2026 09:40:19 PM
// Design Name: 
// Module Name: tb_flopr
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


module tb_flopr();
    logic clk, reset;
    logic [63:0] d ;
    logic [63:0] q;

    flopr #(64) dut(.clk(clk), .reset(reset), .d(d), .q(q));

    always 
        begin        
            clk = 1 ; #5 ; clk = 0; #5;
        end
        
    initial
        begin
        
        reset = 1;
        
        d = 64'd1;
        #10;
        if(q !== 0) $display("Error en el caso 1: q != 0.");
        
        d = 64'd2;
        #10;
        if(q !== 0) $display("Error en el caso 2: q != 0.");
        
        d = 64'd3;
        #10;
        if(q !== 0) $display("Error en el caso 3: q != 0.");
        
        d = 64'd4;
        #10;
        if(q !== 0) $display("Error en el caso 4: q != 0.");

        d = 64'd5;
        #10;
        if(q !== 0) $display("Error en el caso 5: q != 0.");

        reset = 0;
        
         d = 64'd6;
        #10;
        if(q !== 6) $display("Error en el caso 1: q != d.");
        
        d = 64'd7;
        #10;
        if(q !== 7) $display("Error en el caso 2: q != d.");
        
        d = 64'd8;
        #10;
        if(q !== 8) $display("Error en el caso 3: q != d.");
        
        d = 64'd9;
        #10;
        if(q !== 9) $display("Error en el caso 4: q != d.");

        d = 64'd10;
        #10;
        if(q !== 10) $display("Error en el caso 5: q != d.");

        $finish;
        end

endmodule
