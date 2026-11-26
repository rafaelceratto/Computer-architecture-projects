//Extexsion de signo de 32 a 64 bits
module signext(input logic [31:0]a,output logic [63:0]y);
logic [10:0]opcode;
assign opcode={a[31:21]};
logic [63:0]DT_address;//ldur/stur
logic [63:0]COND_BR_address;//cbz
logic [63:0]sino;//sino no es ninguna de la instrucciones esperada
logic b ,c;
//valores bits inmediatos extendidos
assign DT_address={ {55{a[20]}},a[20:12]};
assign COND_BR_address={{45{a[23]}},a[23:5]};
assign sino=64'b0;
//comparo con opcode
//asigno y de acuerdo el resultado
assign b=(opcode==11'b111_1100_0010)||(opcode==11'b111_1100_0000);
assign c=opcode==?11'b101_1010_0???;
assign y=b?DT_address:(c?COND_BR_address:sino);

endmodule
