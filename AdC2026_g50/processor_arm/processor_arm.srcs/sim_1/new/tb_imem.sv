`timescale 1ns / 10ps
module tb_imem();
    logic [5:0]addr;
    logic [31:0]q;
    imem dut(addr,q);
    initial begin
    addr=6'h0;#10;
    addr=6'h1;#10;
    addr=6'h2;#10;
    addr=6'h3;#10;
    addr=6'h4;#10;
    addr=6'h5;#10;
    addr=6'h6;#10;
    addr=6'h7;#10;
    addr=6'h8;#10;
    addr=6'h9;#10;
    addr=6'hA;#10;
    addr=6'hB;#10;
    addr=6'hC;#10;
    addr=6'hD;#10;
    addr=6'hF;#10;
    addr=6'h10;#10;
    addr=6'h11;#10;
    addr=6'h12;#10;
    addr=6'h13;#10;
    addr=6'h14;#10;
    addr=6'h15;#10;
    addr=6'h16;#10;
    addr=6'h17;#10;
    addr=6'h18;#10;
    addr=6'h19;#10;
    addr=6'h1A;#10;
    addr=6'h1B;#10;
    addr=6'h1C;#10;
    addr=6'h1D;#10;
    addr=6'h1F;#10;
    addr=6'h20;#10;
    addr=6'h21;#10;
    addr=6'h22;#10;
    addr=6'h23;#10;
    addr=6'h24;#10;
    addr=6'h25;#10;
    addr=6'h26;#10;
    addr=6'h27;#10;
    addr=6'h28;#10;
    addr=6'h29;#10;
    addr=6'h2A;#10;
    addr=6'h2B;#10;
    addr=6'h2C;#10;
    addr=6'h2D;#10;
    addr=6'h2F;#10;
    addr=6'h30;#10;
    addr=6'h31;#10;
    end
endmodule

