	.data
	.globl	_cred_pal1
_cred_pal1:
	.dc.w	512
	.dc.w	0
	.dc.w	512
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	238
	.globl	_cred_pal2
_cred_pal2:
	.dc.w	512
	.dc.w	0
	.dc.w	512
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	3276
	.globl	_cred_pal3
_cred_pal3:
	.dc.w	512
	.dc.w	0
	.dc.w	512
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	0
	.dc.w	224
	.data
	.text
	.globl	_show_credits
_show_credits:
	link	a6,#-10
	movem.l	d3/d4/d5/d6/d7,-(sp)
	move.l	#_cred_pal1,-(sp)
	clr.w	-(sp)
	jsr	_set_colors
	addq.w	#6,sp
	move.l	#_cred_pal3,-(sp)
	move.w	#3,-(sp)
	jsr	_set_colors
	addq.w	#6,sp
	move.w	#8192,-(sp)
	clr.w	-(sp)
	move.l	#451088,-(sp)
	jsr	_dma_vram_copy
	addq.w	#8,sp
	move.l	#_cred_pal2,-(sp)
	move.w	#1,-(sp)
	jsr	_set_colors
	addq.w	#6,sp
	move.l	#478528,-(sp)
	move.w	#4704,d0
	lsr.w	#5,d0
	move.w	d0,-(sp)
	move.w	#512,-(sp)
	jsr	_set_bkg_data
	addq.w	#8,sp
	move.w	#16896,-(sp)
	move.w	#49152,-(sp)
	move.l	#483232,-(sp)
	move.w	#8,-(sp)
	move.w	#21,-(sp)
	move.w	#1,-(sp)
	move.w	#10,-(sp)
	jsr	_set_bkg_tiles
	lea	16(sp),sp
	move.l	#__smaltitl_pal,-(sp)
	move.w	#2,-(sp)
	jsr	_set_colors
	addq.w	#6,sp
	move.w	_curr_language,d0
	lsl.w	#2,d0
	moveq.l	#0,d1
	move.w	d0,d1
	add.l	#__credits_caption,d1
	move.l	d1,a0
	move.l	(a0),-(sp)
	move.w	#49152,-(sp)
	move.w	#3,-(sp)
	move.w	#10,-(sp)
	move.w	_curr_language,d0
	lsl.w	#2,d0
	moveq.l	#0,d1
	move.w	d0,d1
	add.l	#__credits_caption,d1
	move.l	d1,a0
	move.l	(a0),-(sp)
	jsr	_strlen2
	addq.w	#4,sp
	moveq.l	#40,d1
	sub.w	d0,d1
	lsr.w	#1,d1
	move.w	d1,-(sp)
	jsr	_out_text
	lea	12(sp),sp
	clr.w	-(sp)
	move.w	#57344,-(sp)
	move.w	#64,-(sp)
	move.w	#40,-(sp)
	clr.w	-(sp)
	clr.w	-(sp)
	jsr	_fill_bkg_rect
	lea	12(sp),sp
	moveq.l	#28,d3
	moveq.l	#0,d4
	moveq.l	#0,d5
	moveq.l	#0,d6
	tst.w	_curr_language
	beq	L3
	move.l	#__credits_text_ptr_eng,d0
L4:
	move.l	d0,d7
L5:
	move.l	d7,a0
	tst.l	(a0)
	beq	L6
	jsr	_read_joypad1
	and.w	#128,d0
	bne	L6
	tst.w	d5
	bne	L7
	move.w	#1,-10(a6)
	move.l	d7,a0
	move.l	(a0),-8(a6)
	move.l	-8(a6),a0
	cmp.b	#12,(a0)
	bne	L8
	move.w	#0,-10(a6)
	addq.l	#1,-8(a6)
L8:
	clr.w	-(sp)
	move.w	#57344,-(sp)
	move.w	#1,-(sp)
	move.w	#40,-(sp)
	move.w	d3,-(sp)
	clr.w	-(sp)
	jsr	_fill_bkg_rect
	lea	12(sp),sp
	move.l	-8(a6),-(sp)
	move.w	#57344,-(sp)
	move.w	-10(a6),-(sp)
	move.w	d3,-(sp)
	move.w	#2,-(sp)
	jsr	_out_text
	lea	12(sp),sp
	addq.l	#4,d7
	addq.w	#1,d3
	and.w	#63,d3
	moveq.l	#32,d5
L7:
	tst.w	d6
	bne	L9
	subq.w	#1,d4
	move.w	d4,d0
	neg.w	d0
	move.w	d0,-(sp)
	clr.w	-(sp)
	jsr	_scrollv
	addq.w	#4,sp
	moveq.l	#4,d6
L9:
	subq.w	#1,d5
	subq.w	#1,d6
	jsr	_generate_sound
	jsr	_wait_sync
	bra	L5
L6:
	move.w	#224,d5
L10:
	tst.w	d5
	beq	L2
	jsr	_read_joypad1
	and.w	#128,d0
	bne	L2
	tst.w	d6
	bne	L12
	subq.w	#1,d4
	move.w	d4,d0
	neg.w	d0
	move.w	d0,-(sp)
	clr.w	-(sp)
	jsr	_scrollv
	addq.w	#4,sp
	moveq.l	#4,d6
	subq.w	#1,d5
L12:
	subq.w	#1,d6
	jsr	_generate_sound
	jsr	_wait_sync
	bra	L10
L2:
	movem.l	(sp)+,d3/d4/d5/d6/d7
	unlk	a6
	rts
L3:
	move.l	#__credits_text_ptr_prt,d0
	bra	L4
