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
		fld ft0, 0(a2)        # ft0 = X[i]
		fld ft1, 0(a3)        # ft1 = Y[i]
		fmul.d ft0, fa0, ft0  # ft0 = alpha * X[i]
		fadd.d ft0, ft0, ft1  # ft0 = alpha * X[i] + Y[i]
		fsd ft0, 0(a4)        # Z[i] = ft0
		addi a2, a2, 8        # paso al siguiente elemento de X
		addi a3, a3, 8        # paso al siguiente elemento de Y
		addi a4, a4, 8        # paso al siguiente elemento de Z
		addi a0, a0, -1       # actualizo la iteracion
		bnez a0, loop         # repito mientras queden elementos

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
