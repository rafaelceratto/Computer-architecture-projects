`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2026 18:18:23
// Design Name: 
// Module Name: forwarding_unit
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


module forwarding_unit(
    input logic [4:0] ra1_E, ra2_E,
    input logic [4:0] wa3_M, wa3_W,
    input logic regWrite_M, regWrite_W,
    output logic [1:0] forwardA, forwardB
);

always_comb begin    
    if((regWrite_M) && (wa3_M != 5'd31) && (wa3_M == ra1_E))
       forwardA = 2'b10; 
    else if(regWrite_W && wa3_W != 5'd31 && wa3_W == ra1_E)
       forwardA = 2'b01;
    else   
       forwardA = 2'b00;
end

always_comb begin    
    if((regWrite_M) && (wa3_M != 5'd31) && (wa3_M == ra2_E))
       forwardB = 2'b10; 
    else if(regWrite_W && wa3_W != 5'd31 && wa3_W == ra2_E)
       forwardB = 2'b01;
    else   
       forwardB = 2'b00;
end

endmodule
