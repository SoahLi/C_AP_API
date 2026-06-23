	.file	"example.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	3
.LC0:
	.string	"AP handler called for address: 0x%02x\n"
	.align	3
.LC1:
	.string	"Redirecting execution to: 0x%02x\n"
	.text
	.align	1
	.globl	my_fn_handler
	.type	my_fn_handler, @function
my_fn_handler:
.LFB0:
	.cfi_startproc
	addi	sp,sp,-48
	.cfi_def_cfa_offset 48
	sd	ra,40(sp)
	sd	s0,32(sp)
	.cfi_offset 1, -8
	.cfi_offset 8, -16
	addi	s0,sp,48
	.cfi_def_cfa 8, 0
	mv	a5,a0
	sb	a5,-33(s0)
	li	a5,-17
	sb	a5,-17(s0)
	lbu	a5,-33(s0)
	sext.w	a5,a5
	mv	a1,a5
	lui	a5,%hi(.LC0)
	addi	a0,a5,%lo(.LC0)
	call	printf
	lbu	a5,-17(s0)
	sext.w	a5,a5
	mv	a1,a5
	lui	a5,%hi(.LC1)
	addi	a0,a5,%lo(.LC1)
	call	printf
	lbu	a5,-17(s0)
	mv	a0,a5
	call	ap_sret
	li	a5,0
#APP
# 14 "example.c" 1
	apret a5, 0
# 0 "" 2
#NO_APP
	nop
	ld	ra,40(sp)
	.cfi_restore 1
	ld	s0,32(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 48
	addi	sp,sp,48
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE0:
	.size	my_fn_handler, .-my_fn_handler
	.section	.rodata
	.align	3
.LC2:
	.string	"Invalid arguments provided to ap_reg."
	.align	3
.LC3:
	.string	"No more AP entries available."
	.align	3
.LC4:
	.string	"An unknown error occurred: %d\n"
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	addi	sp,sp,-32
	.cfi_def_cfa_offset 32
	sd	ra,24(sp)
	sd	s0,16(sp)
	.cfi_offset 1, -8
	.cfi_offset 8, -16
	addi	s0,sp,32
	.cfi_def_cfa 8, 0
	li	a5,305418240
	addi	a5,a5,1656
	sd	a5,-24(s0)
	li	a5,1
	sb	a5,-25(s0)
	lbu	a5,-25(s0)
	mv	a2,a5
	lui	a5,%hi(my_fn_handler)
	addi	a1,a5,%lo(my_fn_handler)
	ld	a0,-24(s0)
	call	ap_reg
	mv	a5,a0
	mv	a4,a5
	li	a5,-1
	bne	a4,a5,.L3
	call	__errno_location
	mv	a5,a0
	lw	a5,0(a5)
	li	a4,12
	beq	a5,a4,.L4
	li	a4,22
	bne	a5,a4,.L5
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2)
	call	puts
	j	.L3
.L4:
	lui	a5,%hi(.LC3)
	addi	a0,a5,%lo(.LC3)
	call	puts
	j	.L3
.L5:
	call	__errno_location
	mv	a5,a0
	lw	a5,0(a5)
	mv	a1,a5
	lui	a5,%hi(.LC4)
	addi	a0,a5,%lo(.LC4)
	call	printf
.L3:
	lui	a5,%hi(my_fn_handler)
	addi	a1,a5,%lo(my_fn_handler)
	ld	a0,-24(s0)
	call	ap_ureg
	li	a5,0
	mv	a0,a5
	ld	ra,24(sp)
	.cfi_restore 1
	ld	s0,16(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 32
	addi	sp,sp,32
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident	"GCC: (GNU) 16.1.0"
	.section	.note.GNU-stack,"",@progbits
