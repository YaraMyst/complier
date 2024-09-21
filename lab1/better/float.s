	.file	"flo5.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	3
.LC0:
	.string	"Please enter 5 floating-point numbers:"
	.align	3
.LC1:
	.string	"Enter number %d: "
	.align	3
.LC2:
	.string	"%f"
	.align	3
.LC3:
	.string	"The sum of the 5 floating-point numbers is: %.2f\n"
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sd	ra,40(sp)
	sd	s0,32(sp)
	addi	s0,sp,48
	sw	zero,-20(s0)
	lui	a5,%hi(.LC0)
	addi	a0,a5,%lo(.LC0)
	call	puts
	sw	zero,-24(s0)
	j	.L2
.L3:
	lw	a5,-24(s0)
	addiw	a5,a5,1
	sext.w	a5,a5
	mv	a1,a5
	lui	a5,%hi(.LC1)
	addi	a0,a5,%lo(.LC1)
	call	printf
	addi	a4,s0,-48
	lw	a5,-24(s0)
	slli	a5,a5,2
	add	a5,a4,a5
	mv	a1,a5
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2)
	call	__isoc99_scanf
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a5,a5,-16
	add	a5,a5,s0
	flw	fa5,-32(a5)
	flw	fa4,-20(s0)
	fadd.s	fa5,fa4,fa5
	fsw	fa5,-20(s0)
	lw	a5,-24(s0)
	addiw	a5,a5,1
	sw	a5,-24(s0)
.L2:
	lw	a5,-24(s0)
	sext.w	a4,a5
	li	a5,4
	ble	a4,a5,.L3
	flw	fa5,-20(s0)
	fcvt.d.s	fa5,fa5
	fmv.x.d	a1,fa5
	lui	a5,%hi(.LC3)
	addi	a0,a5,%lo(.LC3)
	call	printf
	li	a5,0
	mv	a0,a5
	ld	ra,40(sp)
	ld	s0,32(sp)
	addi	sp,sp,48
	jr	ra
	.size	main, .-main
	.ident	"GCC: () 12.2.0"
	.section	.note.GNU-stack,"",@progbits
