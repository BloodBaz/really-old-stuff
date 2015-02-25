
;==============================================================
; WLA-DX banking setup
;==============================================================
.memorymap
	defaultslot     0
	; rom area
	slotsize        $4000
	slot            0       $0000
	slot            1       $4000
	slot            2       $8000
	; ram area
	slotsize        $2000
	slot            3       $C000
	slot            4       $E000
.endme

.rombankmap
	bankstotal 2
	banksize $4000
	banks 2
.endro

;==============================================================
; SDSC tag and SMS rom header
;==============================================================
.sdsctag 0.0,"ZX Basic program","Generated by zxb2wla 0.03 alpha","Haroldo"
.smstag


.include "..\lib\wla\boot.inc"


;==============================================================
; Includes
;==============================================================
.include "..\lib\wla\Useful functions.inc"
.include "..\lib\wla\BBC Micro font.inc"
.include "..\lib\wla\sprite.inc"



.section "ZX Basic code" free
zb__START_PROGRAM:
    zb__LABEL0:
	call zb_ReadJoypad1
	ld (zb_joy), a
	ld hl, 4
	push hl
	ld a, (zb_joy)
	ld l, a
	ld h, 0
	call zb_AndW
	ld a, h
	or l
	jp z, zb__LABEL2
	ld hl, (zb_padSpdX)
	ld de, -32
	add hl, de
	ld (zb_padSpdX), hl
	push hl
	ld de, 64512
	pop hl
	or a
	sbc hl, de
	add hl, hl
	jp nc, zb__LABEL5
	ld hl, 64512
	ld (zb_padSpdX), hl
zb__LABEL5:
	jp zb__LABEL3
zb__LABEL2:
	ld hl, 8
	push hl
	ld a, (zb_joy)
	ld l, a
	ld h, 0
	call zb_AndW
	ld a, h
	or l
	jp z, zb__LABEL6
	ld hl, (zb_padSpdX)
	ld de, 32
	add hl, de
	ld (zb_padSpdX), hl
	push hl
	ld hl, 1024
	pop de
	or a
	sbc hl, de
	add hl, hl
	jp nc, zb__LABEL9
	ld hl, 1024
	ld (zb_padSpdX), hl
zb__LABEL9:
	jp zb__LABEL7
zb__LABEL6:
	ld hl, (zb_padSpdX)
	push hl
	ld de, 0
	pop hl
	or a
	sbc hl, de
	add hl, hl
	jp nc, zb__LABEL12
	ld hl, (zb_padSpdX)
	call zb__NEGHL
	ld (zb_padSpdX), hl
	jp zb__LABEL13
zb__LABEL12:
	ld hl, 0
	ld (zb_padSpdX), hl
zb__LABEL13:
zb__LABEL11:
zb__LABEL7:
zb__LABEL3:
	ld hl, (zb_padX)
	push hl
	ld hl, (zb_padSpdX)
	ex de, hl
	pop hl
	add hl, de
	ld (zb_padX), hl
	push hl
	ld de, 0
	pop hl
	or a
	sbc hl, de
	add hl, hl
	jp nc, zb__LABEL14
	ld hl, 0
	ld (zb_padX), hl
	jp zb__LABEL15
zb__LABEL14:
	ld hl, (zb_padX)
	push hl
	ld hl, 13824
	pop de
	or a
	sbc hl, de
	add hl, hl
	jp nc, zb__LABEL17
	ld hl, 13824
	ld (zb_padX), hl
zb__LABEL17:
zb__LABEL15:
	ld a, 3
	push af
	ld a, 128
	push af
	ld hl, (zb_padX)
	ld b, 6
zb__LABEL18:
	sra h
	rr l
	djnz zb__LABEL18
	ld a, l
	push af
	xor a
	call zb_SetSprite
	call zb_WaitForVBlankNoInt
	call zb_UpdateSprites
	jp zb__LABEL0
zb__LABEL1:
zb_UpdateSprites:
;#line 1
		jp UpdateSprites
;#line 2
zb_UpdateSprites__leave:
	ret
zb_WaitForVBlankNoInt:
;#line 8
		jp WaitForVBlankNoInt
;#line 9
zb_WaitForVBlankNoInt__leave:
	ret
zb_SetSprite:
;#line 15
		exx
		pop hl
		exx
		ld d, 0
		ld e, a
		pop bc
		ld hl, hw_sprites_y
		add hl, de
		pop af
		ld (hl), a
		ld hl, hw_sprites_xc
		add hl, de
		add hl, de
		ld (hl), b
		inc hl
		pop af
		ld (hl), a
		exx
		push hl
		exx
;#line 35
zb_SetSprite__leave:
	ret
zb_ReadJoypad1:
;#line 52
		in	a, ($dc)
		cpl
;#line 54
zb_ReadJoypad1__leave:
	ret
zb_ReadJoypad2:
;#line 59
		in	a, ($dc)
		cpl
		rla
		rla
		rla
		and	$03
		ld	l, a
		in	a, ($dd)
		cpl
		add	a, a
		add	a, a
		or	l
;#line 71
zb_ReadJoypad2__leave:
	ret
zb_AndW:
;#line 76
		pop bc
		pop de
		ld a, l
		and e
		ld l, a
		ld a, h
		and d
		ld h, a
		push bc
;#line 85
zb_AndW__leave:
	ret
;#line 1 "neg16.asm"
	; Negates HL value (16 bit)
zb__ABS16:
		bit 7, h
		ret z

zb__NEGHL:
		ld a, l			; HL = -HL
		cpl
		ld l, a
		ld a, h
		cpl
		ld h, a
		inc hl
		ret

;#line 213 "test.zxb"

    ret
.ends

.section "ZXB variable init values" free
ZXBASIC_USER_DATA_VALUES:
    ; zb_padX
	.db 00, 00
; zb_joy
	.db 00
; zb_padSpdX
	.db 00, 00    
ZXBASIC_USER_DATA_VALUES_END:
.ends


.ramsection "ZXBasic Variables" slot 3
ZXBASIC_USER_DATA ds 0
    	zb_padX ds 2
	zb_joy ds 1
	zb_padSpdX ds 2
ZXBASIC_USER_DATA_END ds 0    
.ends


