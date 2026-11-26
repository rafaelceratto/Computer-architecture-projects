`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2026 15:23:00
// Design Name: 
// Module Name: hdu
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


module hdu(
    input logic memRead_E,
    input logic [4:0] wa3_E,
    input logic [4:0] ra1_D, ra2_D,
    output logic stall
);

    always_comb begin
        if (memRead_E &&(wa3_E == ra1_D || wa3_E == ra2_D))
            stall = 1'b1;
        else
            stall = 1'b0;
    end

endmodule
