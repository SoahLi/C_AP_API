	.file	"ap.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.globl	ap_table
	.bss
	.align	3
	.type	ap_table, @object
	.size	ap_table, 1024
ap_table:
	.zero	1024
	.globl	free_mask
	.section	.sdata,"aw"
	.align	3
	.type	free_mask, @object
	.size	free_mask, 8
free_mask:
	.dword	-1
	.text
	.align	1
	.globl	ap_reg
	.type	ap_reg, @function
ap_reg:
.LFB0:
	.cfi_startproc
	addi	sp,sp,-64
	.cfi_def_cfa_offset 64
	sd	ra,56(sp)
	sd	s0,48(sp)
	.cfi_offset 1, -8
	.cfi_offset 8, -16
	addi	s0,sp,64
	.cfi_def_cfa 8, 0
	sd	a0,-40(s0)
	sd	a1,-48(s0)
	mv	a5,a2
	sb	a5,-49(s0)
	ld	a5,-48(s0)
	beq	a5,zero,.L2
	ld	a5,-40(s0)
	bne	a5,zero,.L3
.L2:
	call	__errno_location
	mv	a4,a0
	li	a5,22
	sw	a5,0(a4)
	li	a5,-1
	j	.L8
.L3:
	ld	a1,-48(s0)
	ld	a0,-40(s0)
	call	acquire_ap_idx
	mv	a5,a0
	sw	a5,-20(s0)
	lw	a5,-20(s0)
	sext.w	a4,a5
	li	a5,-1
	bne	a4,a5,.L5
	call	__errno_location
	mv	a4,a0
	li	a5,12
	sw	a5,0(a4)
	li	a5,-1
	j	.L8
.L5:
	lbu	a5,-49(s0)
	mv	a0,a5
	call	parse_ap_flags
	mv	a5,a0
	sh	a5,-24(s0)
	lbu	a5,-23(s0)
	mv	a4,a5
	li	a5,1
	bgtu	a4,a5,.L6
	lbu	a5,-24(s0)
	mv	a4,a5
	li	a5,1
	bleu	a4,a5,.L7
.L6:
	call	__errno_location
	mv	a4,a0
	li	a5,22
	sw	a5,0(a4)
	li	a5,-1
	j	.L8
.L7:
	lbu	a1,-23(s0)
	lbu	a2,-24(s0)
	ld	a3,-40(s0)
	lw	a5,-20(s0)
	ld	a4,-48(s0)
	mv	a0,a5
	call	configure_ap
	li	a5,0
.L8:
	mv	a0,a5
	ld	ra,56(sp)
	.cfi_restore 1
	ld	s0,48(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 64
	addi	sp,sp,64
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE0:
	.size	ap_reg, .-ap_reg
	.align	1
	.globl	ap_ureg
	.type	ap_ureg, @function
ap_ureg:
.LFB1:
	.cfi_startproc
	addi	sp,sp,-48
	.cfi_def_cfa_offset 48
	sd	ra,40(sp)
	sd	s0,32(sp)
	.cfi_offset 1, -8
	.cfi_offset 8, -16
	addi	s0,sp,48
	.cfi_def_cfa 8, 0
	sd	a0,-40(s0)
	sd	a1,-48(s0)
	sw	zero,-20(s0)
	j	.L10
.L13:
	lui	a5,%hi(ap_table)
	addi	a4,a5,%lo(ap_table)
	lw	a5,-20(s0)
	slli	a5,a5,4
	add	a5,a4,a5
	ld	a5,0(a5)
	ld	a4,-40(s0)
	bne	a4,a5,.L11
	lui	a5,%hi(ap_table)
	addi	a4,a5,%lo(ap_table)
	lw	a5,-20(s0)
	slli	a5,a5,4
	add	a5,a4,a5
	ld	a5,8(a5)
	ld	a4,-48(s0)
	bne	a4,a5,.L11
	lui	a5,%hi(ap_table)
	addi	a4,a5,%lo(ap_table)
	lw	a5,-20(s0)
	slli	a5,a5,4
	add	a5,a4,a5
	sd	zero,0(a5)
	lui	a5,%hi(ap_table)
	addi	a4,a5,%lo(ap_table)
	lw	a5,-20(s0)
	slli	a5,a5,4
	add	a5,a4,a5
	sd	zero,8(a5)
	lw	a5,-20(s0)
	mv	a0,a5
	call	dealloc_slot
	lw	a5,-20(s0)
	li	a1,0
	mv	a0,a5
	call	ap_set_active
	j	.L12
.L11:
	lw	a5,-20(s0)
	addiw	a5,a5,1
	sw	a5,-20(s0)
.L10:
	lw	a5,-20(s0)
	sext.w	a4,a5
	li	a5,63
	ble	a4,a5,.L13
	nop
.L12:
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
.LFE1:
	.size	ap_ureg, .-ap_ureg
	.align	1
	.globl	acquire_ap_idx
	.type	acquire_ap_idx, @function
acquire_ap_idx:
.LFB2:
	.cfi_startproc
	addi	sp,sp,-48
	.cfi_def_cfa_offset 48
	sd	ra,40(sp)
	sd	s0,32(sp)
	.cfi_offset 1, -8
	.cfi_offset 8, -16
	addi	s0,sp,48
	.cfi_def_cfa 8, 0
	sd	a0,-40(s0)
	sd	a1,-48(s0)
	sw	zero,-20(s0)
	j	.L15
.L18:
	lui	a5,%hi(ap_table)
	addi	a4,a5,%lo(ap_table)
	lw	a5,-20(s0)
	slli	a5,a5,4
	add	a5,a4,a5
	ld	a5,0(a5)
	ld	a4,-40(s0)
	bne	a4,a5,.L16
	lui	a5,%hi(ap_table)
	addi	a4,a5,%lo(ap_table)
	lw	a5,-20(s0)
	slli	a5,a5,4
	add	a5,a4,a5
	ld	a5,8(a5)
	ld	a4,-48(s0)
	bne	a4,a5,.L16
	lw	a5,-20(s0)
	j	.L17
.L16:
	lw	a5,-20(s0)
	addiw	a5,a5,1
	sw	a5,-20(s0)
.L15:
	lw	a5,-20(s0)
	sext.w	a4,a5
	li	a5,63
	ble	a4,a5,.L18
	lui	a5,%hi(free_mask)
	ld	a5,%lo(free_mask)(a5)
	bne	a5,zero,.L19
	li	a5,-1
	j	.L17
.L19:
	call	alloc_slot
	mv	a5,a0
	sw	a5,-24(s0)
	lui	a5,%hi(ap_table)
	addi	a4,a5,%lo(ap_table)
	lw	a5,-24(s0)
	slli	a5,a5,4
	add	a5,a4,a5
	ld	a4,-40(s0)
	sd	a4,0(a5)
	lui	a5,%hi(ap_table)
	addi	a4,a5,%lo(ap_table)
	lw	a5,-24(s0)
	slli	a5,a5,4
	add	a5,a4,a5
	ld	a4,-48(s0)
	sd	a4,8(a5)
	lw	a5,-24(s0)
.L17:
	mv	a0,a5
	ld	ra,40(sp)
	.cfi_restore 1
	ld	s0,32(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 48
	addi	sp,sp,48
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE2:
	.size	acquire_ap_idx, .-acquire_ap_idx
	.align	1
	.globl	alloc_slot
	.type	alloc_slot, @function
alloc_slot:
.LFB3:
	.cfi_startproc
	addi	sp,sp,-32
	.cfi_def_cfa_offset 32
	sd	ra,24(sp)
	sd	s0,16(sp)
	.cfi_offset 1, -8
	.cfi_offset 8, -16
	addi	s0,sp,32
	.cfi_def_cfa 8, 0
	lui	a5,%hi(free_mask)
	ld	a5,%lo(free_mask)(a5)
	mv	a0,a5
	call	__ctzdi2
	mv	a5,a0
	sw	a5,-20(s0)
	lw	a5,-20(s0)
	mv	a4,a5
	li	a5,1
	sll	a5,a5,a4
	not	a4,a5
	lui	a5,%hi(free_mask)
	ld	a5,%lo(free_mask)(a5)
	and	a4,a4,a5
	lui	a5,%hi(free_mask)
	sd	a4,%lo(free_mask)(a5)
	lw	a5,-20(s0)
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
.LFE3:
	.size	alloc_slot, .-alloc_slot
	.align	1
	.globl	dealloc_slot
	.type	dealloc_slot, @function
dealloc_slot:
.LFB4:
	.cfi_startproc
	addi	sp,sp,-32
	.cfi_def_cfa_offset 32
	sd	ra,24(sp)
	sd	s0,16(sp)
	.cfi_offset 1, -8
	.cfi_offset 8, -16
	addi	s0,sp,32
	.cfi_def_cfa 8, 0
	mv	a5,a0
	sw	a5,-20(s0)
	lw	a5,-20(s0)
	mv	a4,a5
	li	a5,1
	sll	a4,a5,a4
	lui	a5,%hi(free_mask)
	ld	a5,%lo(free_mask)(a5)
	or	a4,a4,a5
	lui	a5,%hi(free_mask)
	sd	a4,%lo(free_mask)(a5)
	nop
	ld	ra,24(sp)
	.cfi_restore 1
	ld	s0,16(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 32
	addi	sp,sp,32
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE4:
	.size	dealloc_slot, .-dealloc_slot
	.align	1
	.globl	parse_ap_flags
	.type	parse_ap_flags, @function
parse_ap_flags:
.LFB5:
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
	lbu	a5,-33(s0)
	andi	a5,a5,1
	andi	a5,a5,0xff
	sb	a5,-32(s0)
	lbu	a5,-33(s0)
	sext.w	a5,a5
	andi	a5,a5,16
	sext.w	a5,a5
	srli	a5,a5,4
	andi	a5,a5,1
	xori	a5,a5,1
	andi	a5,a5,0xff
	sb	a5,-31(s0)
	lhu	a5,-32(s0)
	sh	a5,-24(s0)
	li	a5,0
	lbu	a4,-24(s0)
	andi	a4,a4,255
	andi	a5,a5,-256
	or	a5,a5,a4
	lbu	a4,-23(s0)
	andi	a4,a4,255
	slli	a4,a4,8
	li	a3,-65536
	addi	a3,a3,255
	and	a5,a5,a3
	or	a5,a5,a4
	mv	a0,a5
	ld	ra,40(sp)
	.cfi_restore 1
	ld	s0,32(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 48
	addi	sp,sp,48
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE5:
	.size	parse_ap_flags, .-parse_ap_flags
	.globl	__ctzdi2
	.ident	"GCC: (GNU) 16.1.0"
	.section	.note.GNU-stack,"",@progbits
