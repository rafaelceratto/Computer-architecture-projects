	.data
N:      .dword 4096     # Number of elements in the vectors
Alpha:  .dword 2        # scalar value

	.bss
	.align 6               # vectors aligned to a 64-byte cache line
X:      .zero 32768     # vector X(4096)*8
Y:      .zero 32768     # Vector Y(4096)*8
Z:      .zero 32768     # Vector Z(4096)*8

	.text
	.align 2
	.global main
	.type main, @function
main:
	li      a0, 0
	li      a1, 0
	call    m5_reset_stats

	ld      a0, N      # 4096
	la      a1, Alpha  #direccion de alpha 
	la      a2, X      #direccion de X
	la      a3, Y      #direccion de Y
	la      a4, Z      #direccion de Z

#---------------------- CODE HERE ------------------------------------

	ld t0, 0(a1)              # cargo en t0 el valor de alpha
	fcvt.d.l fa0, t0          # paso el entero a double usando la instruccion fcvt.d.l que convierte 
							  # un entero con signo de 64 bits, a un double en un registro de punto flotante.
	loop:
		#Aplico loop unrolling y reordenamiento de instrucciones
		#Traigo X[i..i+3]
		fld ft0,  0(a2)			
    	fld ft1,  8(a2)
    	fld ft2, 16(a2)
    	fld ft3, 24(a2)
		#Traigo Y[i..i+3]
		fld ft4,  0(a3)
    	fld ft5,  8(a3)
    	fld ft6, 16(a3)
    	fld ft7, 24(a3)
		#Calculo X[i..i+3]*alpha+Y[i..+3]
		fmul.d ft0, fa0, ft0
		fmul.d ft1, fa0, ft1
		fmul.d ft2, fa0, ft2
		fmul.d ft3, fa0, ft3

		fadd.d ft0, ft0, ft4
    	fadd.d ft1, ft1, ft5
    	fadd.d ft2, ft2, ft6
    	fadd.d ft3, ft3, ft7
		#Guardo en Z[i..i+3]
		fsd ft0,  0(a4)
    	fsd ft1,  8(a4)
    	fsd ft2, 16(a4)
    	fsd ft3, 24(a4)
		#actualizo contador(i+4) y paso a los siguiente elementos de X,Y y Z (24bytes = 4 doubles)
		addi a2, a2, 32
    	addi a3, a3, 32
    	addi a4, a4, 32
    	addi a0, a0, -4
    	bnez a0, loop
    
#---------------------- END CODE -------------------------------------

	li      a0, 0
	li      a1, 0
	call    m5_dump_stats

# Padding, so what the front end fetches past the call to m5_dump_stats
# before the stats are dumped is nops, and never the call to m5_exit.
	.rept   50
	nop
	.endr

	call    m5_exit
	.size   main, .-main
