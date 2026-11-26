`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2026 18:58:15
// Design Name: 
// Module Name: tb_forwarding_unit
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


module tb_forwarding_unit();
    logic [4:0] ra1_E, ra2_E, wa3_M, wa3_W;
    logic       regWrite_M, regWrite_W;
    logic [1:0] forwardA, forwardB;
    
    forwarding_unit dut(.ra1_E(ra1_E), .ra2_E(ra2_E), .wa3_M(wa3_M), .wa3_W(wa3_W), .regWrite_M(regWrite_M), .regWrite_W(regWrite_W), .forwardA(forwardA), .forwardB(forwardB));
    
    initial begin
        // Caso 1: sin hazard -> A = 00, B = 00
        ra1_E = 5'd1; ra2_E = 5'd2;
        wa3_M = 5'd5; regWrite_M = 1;
        wa3_W = 5'd6; regWrite_W = 1;
        #10;
        if (forwardA !== 2'b00 || forwardB !== 2'b00) $display("FALLO caso 1: A=%b B=%b", forwardA, forwardB);
        else $display("OK caso 1");
        
        // Caso 2: hazard con MEM, A = 10, B = 00
        ra1_E = 5'd3; ra2_E = 5'd2;
        wa3_M = 5'd3; regWrite_M = 1;
        wa3_W = 5'd6; regWrite_W = 1;
        #10;
        if (forwardA !== 2'b10 || forwardB !== 2'b00) $display("FALLO caso 2: A=%b B=%b", forwardA, forwardB);
        else $display("OK caso 2");
        
        // Caso 3: hazard con WB, A=00, B=01
        ra1_E = 5'd2; ra2_E = 5'd3;
        wa3_M = 5'd5; regWrite_M = 1;
        wa3_W = 5'd3; regWrite_W = 1;
        #10;
        if (forwardA !== 2'b00 || forwardB !== 2'b01) $display("FALLO caso 3: A=%b B=%b", forwardA, forwardB);
        else $display("OK caso 3");
        
        // Caso 4: MEM y WB escriben el mismo registro que leen A y B, A = 10, B = 10
        ra1_E = 5'd3; ra2_E = 5'd3;
        wa3_M = 5'd3; regWrite_M = 1;
        wa3_W = 5'd3; regWrite_W = 1;
        #10;
        if (forwardA !== 2'b10 || forwardB !== 2'b10) $display("FALLO caso 4: A=%b B=%b", forwardA, forwardB);
        else $display("OK caso 4");
        
         // Caso 5: MEM escribe XZR y A lee XZR -> no se adelanta, A=00; B lee X3 y nadie lo escribe, B=00
        ra1_E = 5'd31; ra2_E = 5'd3;
        wa3_M = 5'd31; regWrite_M = 1;
        wa3_W = 5'd6; regWrite_W = 1;
        #10;
        if (forwardA !== 2'b00 || forwardB !== 2'b00) $display("FALLO caso 5: A=%b B=%b", forwardA, forwardB);
        else $display("OK caso 5");
        $stop;
    end
        
endmodule
