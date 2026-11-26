//Extexsion de signo de 32 a 64 bits
module signext(input logic [31:0]a,output logic [63:0]y);
    logic [10:0]opcode;
    logic [63:0]DT_address;
    logic [63:0]COND_BR_address;
    logic [63:0]MOVZ_imm;
    logic [63:0]sino;
    logic c, b, d;
    //tomo el opcode de la instruccion de entrada
    assign opcode={a[31:21]};
    //tomo los bits correspondiente y extiendo su signo 
    assign DT_address={ {55{a[20]}},a[20:12]};
    assign COND_BR_address={{45{a[23]}},a[23:5]};
    //Agrego como MOVZ toma los bits y extiende signo dependiendo del LSL
    assign MOVZ_imm = (a[22:21] == 2'b00) ? {48'b0, a[20:5]} :
                      (a[22:21] == 2'b01) ? {32'b0, a[20:5], 16'b0} :
                      (a[22:21] == 2'b10) ? {16'b0, a[20:5], 32'b0} :
                                            {a[20:5], 48'b0};
    //caso en que no sea una instruccion con valor inmediato
    assign sino=64'b0;
    //compruebo si opcode corresponde a ldur, stur, cbz o movz
    assign b=(opcode==11'b111_1100_0010)||(opcode==11'b111_1100_0000);
    assign c=opcode==?11'b101_1010_0???;
    assign d=opcode==?11'b110_100_101_??;
    //asigno a la salida los valores inmediato correspondiente o cero si no son las instrucciones correspondientes
  assign y=b?DT_address:(c?COND_BR_address:(d?MOVZ_imm:sino));
endmodule