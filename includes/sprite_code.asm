;
; STERCORE SPRITE MANAGEMENT CODE
;

; Clear all of the sprites from the playfield
sprite_clear

; Clear the static starfield
		ld a,$00
		ld (bitmap_ram+$00a1+star_1_x),a
		ld (bitmap_ram+$00e1+star_2_x),a
		ld (bitmap_ram+$0821+star_3_x),a
		ld (bitmap_ram+$0861+star_4_x),a
		ld (bitmap_ram+$08a1+star_5_x),a
		ld (bitmap_ram+$08e1+star_6_x),a
		ld (bitmap_ram+$1021+star_7_x),a
		ld (bitmap_ram+$1061+star_8_x),a
		ld (bitmap_ram+$10a1+star_9_x),a
		ld (bitmap_ram+$10e1+star_10_x),a

; Clear the player sprite
; Work out start position in screen_offset
		ld d,$00
		ld a,(player_y)
		sla a
		ld e,a
		sla e
		rl d

; Point IX at screen_offset and add the start position
		ld ix,screen_offset	; screen memory select
		add ix,de		; add Y offset
		ld bc,(player_x)	; X offset
		sra c
		sra c

		call clear_sprite

; Clear the player bullet sprite
; Work out start position in screen_offset
		ld d,$00
		ld a,(bullet_y)
		sla a
		ld e,a
		sla e
		rl d

; Point IX at screen_offset and add the start position
		ld ix,screen_offset	; screen memory select
		add ix,de		; add Y offset
		ld bc,(bullet_x)	; X offset
		sra c
		sra c

; Update scanline $00
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld a,$00
		ld (hl),a

; Update scanline $09
		ld de,$0010
		add ix,de

		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld a,$00
		ld (hl),a

; Clear enemy 1 sprite
		ld a,(enemy_1_x)
		cp $7c
		jp c,e1_clip_x_clr
		ld a,$7c
e1_clip_x_clr	ld (render_x),a

		ld a,(enemy_1_y)
		cp $54
		jp c,e1_clip_y_clr
		ld a,$54
e1_clip_y_clr	ld (render_y),a

; Work out start position in screen_offset
		ld d,$00
		ld a,(render_y)
		sla a
		ld e,a
		sla e
		rl d

; Point IX at screen_offset and add the start position
		ld ix,screen_offset	; screen memory select
		add ix,de		; add Y offset
		ld bc,(render_x)	; X offset
		sra c
		sra c

		call clear_sprite

; Clear enemy 2 sprite
		ld a,(enemy_2_x)
		cp $7c
		jp c,e2_clip_x_clr
		ld a,$7c
e2_clip_x_clr	ld (render_x),a

		ld a,(enemy_2_y)
		cp $54
		jp c,e2_clip_y_clr
		ld a,$54
e2_clip_y_clr	ld (render_y),a

; Work out start position in screen_offset
		ld d,$00
		ld a,(render_y)
		sla a
		ld e,a
		sla e
		rl d

; Point IX at screen_offset and add the start position
		ld ix,screen_offset	; screen memory select
		add ix,de		; add Y offset
		ld bc,(render_x)	; X offset
		sra c
		sra c

		call clear_sprite

; Clear enemy 3 sprite
		ld a,(enemy_3_x)
		cp $7c
		jp c,e3_clip_x_clr
		ld a,$7c
e3_clip_x_clr	ld (render_x),a

		ld a,(enemy_3_y)
		cp $54
		jp c,e3_clip_y_clr
		ld a,$54
e3_clip_y_clr	ld (render_y),a

; Work out start position in screen_offset
		ld d,$00
		ld a,(render_y)
		sla a
		ld e,a
		sla e
		rl d

; Point IX at screen_offset and add the start position
		ld ix,screen_offset	; screen memory select
		add ix,de		; add Y offset
		ld bc,(render_x)	; X offset
		sra c
		sra c

		call clear_sprite

; Clear enemy 4 sprite
		ld a,(enemy_4_x)
		cp $7c
		jp c,e4_clip_x_clr
		ld a,$7c
e4_clip_x_clr	ld (render_x),a

		ld a,(enemy_4_y)
		cp $54
		jp c,e4_clip_y_clr
		ld a,$54
e4_clip_y_clr	ld (render_y),a

; Work out start position in screen_offset
		ld d,$00
		ld a,(render_y)
		sla a
		ld e,a
		sla e
		rl d

; Point IX at screen_offset and add the start position
		ld ix,screen_offset	; screen memory select
		add ix,de		; add Y offset
		ld bc,(render_x)	; X offset
		sra c
		sra c

		call clear_sprite

		ret


; Draw all of the sprites into the playfield
sprite_draw

; Draw the static starfield (skip of the attribute cell isn't $07
		ld a,(attrib_ram+$0a2+star_1_x)
		cp $07
		jp nz,sd_star_skip_1
		ld a,$08
		ld (bitmap_ram+$00a1+star_1_x),a

sd_star_skip_1

		ld a,(attrib_ram+$0e2+star_2_x)
		cp $07
		jp nz,sd_star_skip_2
		ld a,$08
		ld (bitmap_ram+$00e1+star_2_x),a

sd_star_skip_2

		ld a,(attrib_ram+$122+star_3_x)
		cp $07
		jp nz,sd_star_skip_3
		ld a,$08
		ld (bitmap_ram+$0821+star_3_x),a

sd_star_skip_3

		ld a,(attrib_ram+$162+star_4_x)
		cp $07
		jp nz,sd_star_skip_4
		ld a,$08
		ld (bitmap_ram+$0861+star_4_x),a

sd_star_skip_4

		ld a,(attrib_ram+$1a2+star_5_x)
		cp $07
		jp nz,sd_star_skip_5
		ld a,$08
		ld (bitmap_ram+$08a1+star_5_x),a

sd_star_skip_5

		ld a,(attrib_ram+$1e2+star_6_x)
		cp $07
		jp nz,sd_star_skip_6
		ld a,$08
		ld (bitmap_ram+$08e1+star_6_x),a

sd_star_skip_6

		ld a,(attrib_ram+$222+star_7_x)
		cp $07
		jp nz,sd_star_skip_7
		ld a,$08
		ld (bitmap_ram+$1021+star_7_x),a

sd_star_skip_7

		ld a,(attrib_ram+$262+star_8_x)
		cp $07
		jp nz,sd_star_skip_8
		ld a,$08
		ld (bitmap_ram+$1061+star_8_x),a

sd_star_skip_8

		ld a,(attrib_ram+$2a2+star_9_x)
		cp $07
		jp nz,sd_star_skip_9
		ld a,$08
		ld (bitmap_ram+$10a1+star_9_x),a

sd_star_skip_9

		ld a,(attrib_ram+$2e2+star_10_x)
		cp $07
		jp nz,sd_star_skip_10
		ld a,$08
		ld (bitmap_ram+$10e1+star_10_x),a

sd_star_skip_10

; Draw the player sprite
; (Skip if the lowest bit of player_shield is set to make the ship flash)
		ld a,(player_shield)
		and $01
		jp nz,shield_skip

; Set IY to the start of sprite data
		ld a,(player_x)
		and $03
		ld c,a
		ld b,$00

		ld iy,player_data
		add iy,bc

; Work out start position in screen_offset
		ld d,$00
		ld a,(player_y)
		sla a
		ld e,a
		sla e
		rl d

; Point IX at screen_offset and add the start position
		ld ix,screen_offset	; screen memory select
		add ix,de		; add Y offset
		ld bc,(player_x)	; X offset
		sra c
		sra c

		call draw_sprite

; Draw the player bullet sprite
; Work out start position in screen_offset
shield_skip	ld d,$00
		ld a,(bullet_y)
		sla a
		ld e,a
		sla e
		rl d

; Point IX at screen_offset and add the start position
		ld ix,screen_offset	; screen memory select
		add ix,de		; add Y offset
		ld bc,(bullet_x)	; X offset
		sra c
		sra c

; Update scanline $00
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld a,$97
		ld (hl),a

; Update scanline $09
		ld de,$0010
		add ix,de

		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld a,$97
		ld (hl),a

; Draw enemy 1 sprite
		ld a,(enemy_1_x)
		cp $7c
		jp c,e1_clip_x_rndr
		ld a,$7c
e1_clip_x_rndr	ld (render_x),a

		ld a,(enemy_1_y)
		cp $54
		jp c,e1_clip_y_rndr
		ld a,$54
e1_clip_y_rndr	ld (render_y),a

; Set IY to the start of sprite data
		ld a,(render_x)
		and $03
		ld c,a
		ld b,$00

		ld iy,enemy_2_data
		add iy,bc

; Work out start position in screen_offset
		ld d,$00
		ld a,(render_y)
		sla a
		ld e,a
		sla e
		rl d

; Point IX at screen_offset and add the start position
		ld ix,screen_offset	; screen memory select
		add ix,de		; add Y offset
		ld bc,(render_x)	; X offset
		sra c
		sra c

		call draw_sprite

; Draw enemy 2 sprite
		ld a,(enemy_2_x)
		cp $7c
		jp c,e2_clip_x_rndr
		ld a,$7c
e2_clip_x_rndr	ld (render_x),a

		ld a,(enemy_2_y)
		cp $54
		jp c,e2_clip_y_rndr
		ld a,$54
e2_clip_y_rndr	ld (render_y),a

; Set IY to the start of sprite data
		ld a,(render_x)
		and $03
		ld c,a
		ld b,$00

		ld iy,enemy_2_data
		add iy,bc

; Work out start position in screen_offset
		ld d,$00
		ld a,(render_y)
		sla a
		ld e,a
		sla e
		rl d

; Point IX at screen_offset and add the start position
		ld ix,screen_offset	; screen memory select
		add ix,de		; add Y offset
		ld bc,(render_x)	; X offset
		sra c
		sra c

		call draw_sprite

; Draw enemy 3 sprite
		ld a,(enemy_3_x)
		cp $7c
		jp c,e3_clip_x_rndr
		ld a,$7c
e3_clip_x_rndr	ld (render_x),a

		ld a,(enemy_3_y)
		cp $54
		jp c,e3_clip_y_rndr
		ld a,$54
e3_clip_y_rndr	ld (render_y),a

; Set IY to the start of sprite data
		ld a,(render_x)
		and $03
		ld c,a
		ld b,$00

		ld iy,enemy_1_data
		add iy,bc

; Work out start position in screen_offset
		ld d,$00
		ld a,(render_y)
		sla a
		ld e,a
		sla e
		rl d

; Point IX at screen_offset and add the start position
		ld ix,screen_offset	; screen memory select
		add ix,de		; add Y offset
		ld bc,(render_x)	; X offset
		sra c
		sra c

		call draw_sprite

; Draw enemy 4 sprite
		ld a,(enemy_4_x)
		cp $7c
		jp c,e4_clip_x_rndr
		ld a,$7c
e4_clip_x_rndr	ld (render_x),a

		ld a,(enemy_4_y)
		cp $54
		jp c,e4_clip_y_rndr
		ld a,$54
e4_clip_y_rndr	ld (render_y),a

; Set IY to the start of sprite data
		ld a,(render_x)
		and $03
		ld c,a
		ld b,$00

		ld iy,enemy_1_data
		add iy,bc

; Work out start position in screen_offset
		ld d,$00
		ld a,(render_y)
		sla a
		ld e,a
		sla e
		rl d

; Point IX at screen_offset and add the start position
		ld ix,screen_offset	; screen memory select
		add ix,de		; add Y offset
		ld bc,(render_x)	; X offset
		sra c
		sra c

		call draw_sprite

		ret


; Sprite rendering subroutine
; HL used for selecting from screen_offset, IX counting through
; that table - BC ix X offset (byte), IY points at sprite data
draw_sprite

; Update scanline $00
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld a,(hl)
		or (iy+$00)
		ld (hl),a

		inc hl
		ld a,(hl)
		or (iy+$00+sprite_offset)
		ld (hl),a

; Update scanline $01
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld a,(hl)
		or (iy+$04)
		ld (hl),a

		inc hl
		ld a,(hl)
		or (iy+$04+sprite_offset)
		ld (hl),a

; Update scanline $02
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld a,(hl)
		or (iy+$08)
		ld (hl),a

		inc hl
		ld a,(hl)
		or (iy+$08+sprite_offset)
		ld (hl),a

; Update scanline $03
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld a,(hl)
		or (iy+$0c)
		ld (hl),a

		inc hl
		ld a,(hl)
		or (iy+$0c+sprite_offset)
		ld (hl),a

; Update scanline $04
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld a,(hl)
		or (iy+$10)
		ld (hl),a

		inc hl
		ld a,(hl)
		or (iy+$10+sprite_offset)
		ld (hl),a

; Update scanline $05
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld a,(hl)
		or (iy+$14)
		ld (hl),a

		inc hl
		ld a,(hl)
		or (iy+$14+sprite_offset)
		ld (hl),a

; Update scanline $06
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld a,(hl)
		or (iy+$18)
		ld (hl),a

		inc hl
		ld a,(hl)
		or (iy+$18+sprite_offset)
		ld (hl),a

; Update scanline $07
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld a,(hl)
		or (iy+$1c)
		ld (hl),a

		inc hl
		ld a,(hl)
		or (iy+$1c+sprite_offset)
		ld (hl),a

; Update scanline $08
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld a,(hl)
		or (iy+$20)
		ld (hl),a

		inc hl
		ld a,(hl)
		or (iy+$20+sprite_offset)
		ld (hl),a

; Update scanline $09
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld a,(hl)
		or (iy+$24)
		ld (hl),a

		inc hl
		ld a,(hl)
		or (iy+$24+sprite_offset)
		ld (hl),a

		ret


; Sprite clearing subroutine
; HL used for selecting from screen_offset, IX counting through
; that table - BC ix X offset (byte), A is zeroed and written
; to memory
clear_sprite	ld a,$00

; Update scanline $00
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld (hl),a
		inc hl
		ld (hl),a

; Update scanline $01
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld (hl),a
		inc hl
		ld (hl),a

; Update scanline $02
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld (hl),a
		inc hl
		ld (hl),a

; Update scanline $03
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld (hl),a
		inc hl
		ld (hl),a

; Update scanline $04
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld (hl),a
		inc hl
		ld (hl),a

; Update scanline $05
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld (hl),a
		inc hl
		ld (hl),a

; Update scanline $06
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld (hl),a
		inc hl
		ld (hl),a

; Update scanline $07
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld (hl),a
		inc hl
		ld (hl),a

; Update scanline $08
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld (hl),a
		inc hl
		ld (hl),a

; Update scanline $09
		ld h,(ix)
		inc ix
		ld l,(ix)
		inc ix
		add hl,bc

		ld (hl),a
		inc hl
		ld (hl),a

		ret
