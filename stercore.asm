;
; STERCORE
;

; Programming, graphics, sound and other digital atrocities by
; Jason


; A simple scrolling shoot 'em up with tile compressed backgrounds,
; coded for the CSS Crap Game Competition 2018 and released at
; C64CrapDebunk.Wordpress.com

; Notes: this source is formatted for the Pasmo cross assembler from
; http://pasmo.speccy.org/

; build.bat will call it with the appropriate command string to
; create an assembled file in a TAP image.


; Constants
cheat		equ $00		; set to $01 to disable player collisions

sprite_offset	equ $28
t_scrl_line	equ bitmap_ram+$10ff

; Constants - X positions for the starfield
star_1_x	equ $09
star_2_x	equ $03
star_3_x	equ $19
star_4_x	equ $10
star_5_x	equ $1c
star_6_x	equ $06
star_7_x	equ $0b
star_8_x	equ $19
star_9_x	equ $01
star_10_x	equ $1c

; Where to find the screen
bitmap_ram	equ $4000
attrib_ram	equ $5800

; Colour and luma effect work spaces
t_colour_work	equ $ff40
t_luma_work	equ $ff60


; Entry point for the code
		org $6000

; Set the border colour to black and lock it in place
code_start	ld a,$00
		out ($fe),a

		ld a,0
		call $229b


; Titles page entry point
titles_init	call screen_init

; Titles logo - line 1
		ld hl,t_logo_1		; text source
		ld (text_read),hl
		ld hl,bitmap_ram+$00a1	; screen destination
		ld (text_write),hl

		ld hl,attrib_ram+$0a1	; colour destination
		ld (text_col_write),hl
		ld a,$07		; text colour
		ld (text_colour),a

		ld a,$1e		; text length
		ld (text_length),a
		call text_render

; Titles logo - line 2
		ld hl,t_logo_2		; text source
		ld (text_read),hl
		ld hl,bitmap_ram+$00c1	; screen destination
		ld (text_write),hl

		ld hl,attrib_ram+$0c1	; colour destination
		ld (text_col_write),hl
		ld a,$07		; text colour
		ld (text_colour),a

		ld a,$1e		; text length
		ld (text_length),a
		call text_render

; Titles logo - line 3
		ld hl,t_logo_3		; text source
		ld (text_read),hl
		ld hl,bitmap_ram+$00e1	; screen destination
		ld (text_write),hl

		ld hl,attrib_ram+$0e1	; colour destination
		ld (text_col_write),hl
		ld a,$07		; text colour
		ld (text_colour),a

		ld a,$1e		; text length
		ld (text_length),a
		call text_render

; Titles credit text - line 1
		ld hl,t_credit_1		; text source
		ld (text_read),hl
		ld hl,bitmap_ram+$1063	; screen destination
		ld (text_write),hl

		ld hl,attrib_ram+$263	; colour destination
		ld (text_col_write),hl
		ld a,$46		; text colour
		ld (text_colour),a

		ld a,$1a		; text length
		ld (text_length),a
		call text_render

; Titles credit text - line 2
		ld hl,t_credit_2	; text source
		ld (text_read),hl
		ld hl,bitmap_ram+$1085	; screen destination
		ld (text_write),hl

		ld hl,attrib_ram+$285	; colour destination
		ld (text_col_write),hl
		ld a,$06		; text colour
		ld (text_colour),a

		ld a,$16		; text length
		ld (text_length),a
		call text_render

; Set up the scroller's colours
		ld hl,t_scrl_c_data
		ld de,attrib_ram+$2e1
		ld bc,$001e
		ldir

; Make sure the space key isn't being held down
		call space_debounce

; Call the Beepola music driver
		call music

; Reset the logo's colour effects
		call t_colour_reset
		call t_luma_reset

; Clear the logo's colour buffer
		ld hl,t_colour_work
		ld e,l
		ld d,h
		inc de
		ld (hl),$07
		ld bc,$1f
		ldir

; Clear the logo's luma buffer
		ld hl,t_luma_work
		ld e,l
		ld d,h
		inc de
		ld (hl),$00
		ld bc,$1f
		ldir

; Reset the scrolling message
		call t_scrl_reset
		ld a,$08
		ld (t_scrl_timer),a

		ld hl,t_char_buffer
		ld e,l
		ld d,h
		inc de
		ld (hl),$00
		ld bc,$07
		ldir

; Make sure the space key isn't being held down
		call space_debounce

; Titles menu item text - line 4
; (Rendered here because it doesn't need doing repeatedly)
		ld hl,t_menu_1	; text source
		ld (text_read),hl
		ld hl,bitmap_ram+$1008	; screen destination
		ld (text_write),hl

		ld hl,attrib_ram+$208	; colour destination
		ld (text_col_write),hl
		ld a,$10		; text colour
		ld (text_colour),a

		ld a,$10		; text length
		ld (text_length),a
		call text_render

; Titles menu item text - line 1
t_menu_redraw	ld hl,t_menu_2	; text source
		ld (text_read),hl
		ld hl,bitmap_ram+$0848	; screen destination
		ld (text_write),hl

		ld hl,attrib_ram+$148	; colour destination
		ld (text_col_write),hl

		ld b,$05		; text colour
		ld a,(ctrl_mode)
		cp $00
		jp nz,t_menu_skip_1
		ld b,$85		; text colour
t_menu_skip_1	ld a,b
		ld (text_colour),a

		ld a,$10		; text length
		ld (text_length),a
		call text_render

; Titles menu item text - line 2
		ld hl,t_menu_3	; text source
		ld (text_read),hl
		ld hl,bitmap_ram+$0888	; screen destination
		ld (text_write),hl

		ld hl,attrib_ram+$188	; colour destination
		ld (text_col_write),hl

		ld b,$04		; text colour
		ld a,(ctrl_mode)
		cp $01
		jp nz,t_menu_skip_2
		ld b,$84		; text colour
t_menu_skip_2	ld a,b
		ld (text_colour),a

		ld a,$10		; text length
		ld (text_length),a
		call text_render

; Titles menu item text - line 3
		ld hl,t_menu_4	; text source
		ld (text_read),hl
		ld hl,bitmap_ram+$08c8	; screen destination
		ld (text_write),hl
		ld a,$10		; text length
		ld (text_length),a

		ld hl,attrib_ram+$1c8	; colour destination
		ld (text_col_write),hl

		ld b,$03		; text colour
		ld a,(ctrl_mode)
		cp $02
		jp nz,t_menu_skip_3
		ld b,$83		; text colour
t_menu_skip_3	ld a,b
		ld (text_colour),a

		ld a,$10		; text length
		ld (text_length),a
		call text_render


; Titles page
titles_loop	halt

; Update the logo's colour wash effect
		ld hl,t_colour_work+$01	; set source
		ld de,t_colour_work+$00	; set destination
		ld bc,$001f		; set copy length
		ldir

		ld hl,(t_colour_count)	; load HL with current pulse position
t_colour_read	ld a,(hl)		; read text from HL's pos. into A
		cp $ff
		jp nz,t_cr_okay

		call t_colour_reset
		jp t_colour_read

t_cr_okay	ld (t_colour_work+$1f),a

		ld hl,(t_colour_count)
		inc hl
		ld (t_colour_count),hl

; Update the logo's luma wash effect
		ld hl,t_luma_work+$01	; set source
		ld de,t_luma_work+$00	; set destination
		ld bc,$001f		; set copy length
		ldir

		ld hl,(t_luma_count)	; load HL with current pulse position
t_luma_read	ld a,(hl)		; read text from HL's pos. into A
		cp $ff
		jp nz,t_lr_okay

		call t_luma_reset
		jp t_luma_read

t_lr_okay	ld (t_luma_work+$1f),a

		ld hl,(t_luma_count)
		inc hl
		ld (t_luma_count),hl

; Merge the logo's colour and luma data (reversing the latter as well)
		ld ix,t_colour_work	; colour table
		ld iy,t_luma_work+$1f	; luma table
		ld hl,attrib_ram+$0a1	; destination
		ld c,$1e

t_merge_loop	ld a,(ix)
		ld b,(iy)
		add a,b
		ld (hl),a

		inc hl
		inc ix
		dec iy
		dec c
		jp nz,t_merge_loop

; Copy the logo colours downwards for the other two lines
		ld hl,attrib_ram+$0a1	; set source
		ld de,attrib_ram+$0c1	; set destination
		ld bc,$0020		; set copy length
		ldir

		ld hl,attrib_ram+$0c1	; set source
		ld de,attrib_ram+$0e1	; set destination
		ld bc,$0020		; set copy length
		ldir

; Update the scrolling message
		call t_scroller
		call t_scroller

; Select keyboard mode if K is pressed
t_key_check_1	ld bc,$bffe
		in a,(c)
		and $04
		jp nz,t_key_check_2

		ld a,$00
		ld (ctrl_mode),a

		jp t_menu_redraw

; Select Sinclair joystick mode if S is pressed
t_key_check_2	ld bc,$fdfe
		in a,(c)
		and $02
		jp nz,t_key_check_3

		ld a,$01
		ld (ctrl_mode),a

		jp t_menu_redraw

; Select Kempston joystic mode if J is pressed
t_key_check_3	ld bc,$bffe
		in a,(c)
		and $08
		jp nz,t_key_check_4

		ld a,$02
		ld (ctrl_mode),a

		jp t_menu_redraw

; Start the game if space has been pressed
t_key_check_4	ld bc,$7ffe
		in a,(c)
		and $01
		jp nz,titles_loop


; Clear the bitmap
main_init	call screen_init

; Reset the background scroll engine
		call scroll_reset

; Reset player and bullet co-ordinates
		ld a,$1c
		ld (player_x),a
		ld a,$27
		ld (player_y),a

		ld a,$00
		ld (bullet_x),a
		ld a,$64
		ld (bullet_y),a

; Zero the score
		ld hl,player_score
		ld c,$05
		ld a,$00

score_reset	ld (hl),a
		inc hl

		dec c
		jp nz,score_reset

; Set the lives counter
		ld a,$03
		ld (player_lives),a

; Set the player shield
		ld a,$32
		ld (player_shield),a

; Reset the status bar
		call status_update


; Main game loop
main_loop	halt

; Call the various subroutines that process the game
		call sprite_clear

		call player_update
		call bullet_update

		call nasty_update

		call sprite_draw

		call scroll_update

		call bump_score
		call status_update

		call sfx_driver

; Check for the player's death flag
		ld a,(player_d_flag)
		cp $00
		jp z,no_death

; Conditional assembly, if cheat is $01 then skip the player collisions
if cheat=$01
		jp no_death
endif

; Set the player shield
		ld a,$32
		ld (player_shield),a

; Trigger the player explosion sound
		ld hl,$0200
		ld (sfx_pitch),hl
		ld hl,$0008
		ld (sfx_slide),hl

		ld a,$18
		ld (sfx_duration),a

; Decrease and check player's lives counter
		ld a,(player_lives)
		dec a
		ld (player_lives),a

		cp $00
		jp z,game_over_init

; Check to see if the end of map flag is set
no_death	ld a,(map_flag)
		cp $01
		jp z,main_loop


; Game completion
game_done_init	call status_update

; Completion text - line 1
		ld hl,completion_1	; text source
		ld (text_read),hl
		ld hl,bitmap_ram+$0866	; screen destination
		ld (text_write),hl

		ld hl,attrib_ram+$166	; colour destination
		ld (text_col_write),hl
		ld a,$84		; text colour
		ld (text_colour),a

		ld a,$14		; text length
		ld (text_length),a
		call text_render

; Completion text - line 2
		ld hl,completion_2	; text source
		ld (text_read),hl
		ld hl,bitmap_ram+$08aa	; screen destination
		ld (text_write),hl

		ld hl,attrib_ram+$1aa	; colour destination
		ld (text_col_write),hl
		ld a,$c4		; text colour
		ld (text_colour),a

		ld a,$0c		; text length
		ld (text_length),a
		call text_render

; Play the completion sound effect
		ld hl,$fffe
		ld (sfx_slide),hl

		ld hl,$0400
		ld (sfx_pitch),hl
		ld a,$c0
		ld (sfx_duration),a

		call sfx_sa_driver

		ld hl,$0350
		ld (sfx_pitch),hl
		ld a,$c0
		ld (sfx_duration),a

		call sfx_sa_driver

		ld hl,$0300
		ld (sfx_pitch),hl
		ld a,$f0
		ld (sfx_duration),a

		call sfx_sa_driver

; Prompt for a space press, then flip back to the titles
		call space_wait
		jp titles_init

; Game over
game_over_init	call status_update

; Game over text
		ld hl,game_over_text	; text source
		ld (text_read),hl
		ld hl,bitmap_ram+$088a	; screen destination
		ld (text_write),hl

		ld hl,attrib_ram+$18a	; colour destination
		ld (text_col_write),hl
		ld a,$c2		; text colour
		ld (text_colour),a

		ld a,$0c		; text length
		ld (text_length),a
		call text_render

; Play the game over sound effect
		ld hl,$0002
		ld (sfx_slide),hl

		ld hl,$0180
		ld (sfx_pitch),hl
		ld a,$b0
		ld (sfx_duration),a

		call sfx_sa_driver

		ld hl,$01c0
		ld (sfx_pitch),hl
		ld a,$b0
		ld (sfx_duration),a

		call sfx_sa_driver

		ld hl,$0200
		ld (sfx_pitch),hl
		ld a,$f0
		ld (sfx_duration),a

		call sfx_sa_driver

; Wait for a couple of seconds
		ld a,$96

game_over_loop	halt
		dec a
		cp $00
		jp nz,game_over_loop

		jp titles_init


; Titles colour pulse effect resets
t_colour_reset	ld hl,t_colour_data
		ld (t_colour_count),hl
		ret

t_luma_reset	ld hl,t_luma_data
		ld (t_luma_count),hl

		ret

; Scroller for the titles
t_scroller	ld ix,t_char_buffer

		ld hl,t_scrl_line+$000
		call t_mover

		ld hl,t_scrl_line+$100
		call t_mover

		ld hl,t_scrl_line+$200
		call t_mover

		ld hl,t_scrl_line+$300
		call t_mover

		ld hl,t_scrl_line+$400
		call t_mover

		ld hl,t_scrl_line+$500
		call t_mover

		ld hl,t_scrl_line+$600
		call t_mover

		ld hl,t_scrl_line+$700
		call t_mover

; Check to see if a new character is due
		ld a,(t_scrl_timer)
		dec a
		jp nz,t_no_new_char

; If so, read the scrolltext
		ld hl,(t_scrl_count)	; load HL with current text position
t_mread		ld a,(hl)		; read text from HL's pos. into A
		cp $ff
		jp nz,t_okay

		call t_scrl_reset
		jp t_mread

; Write the new character to the work buffer
t_okay		ld de,t_char_buffer	; point DE to the scroll buffer

		ld h,$00		; incoming char to hl and...
		ld l,a

		ccf
		sla l			; ...multiply hl by eight
		rl h
		sla l
		rl h
		sla l
		rl h

		ld bc,char_data	; add on the start of font
		add hl,bc
		ld bc,$08		; set copy length
		ldir			; copy definition

; Bump the text counter to the next character
		ld hl,(t_scrl_count)
		inc hl
		ld (t_scrl_count),hl

; Skip to here if a new character isn't needed
		ld a,$08
t_no_new_char	ld (t_scrl_timer),a
		ret

; Unrolled line scroll
t_mover		rl (ix)
		inc ix

		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl

		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl

		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl

		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)
		dec hl
		rl (hl)

		ret

; Scrolling message reset
t_scrl_reset		ld hl,t_scrl_text
		ld (t_scrl_count),hl
		ret


; Everything to do with updating the player
player_update

; See which control mode is enabled
		ld a,(ctrl_mode)
		cp $00
		call z,pu_kbd_read

		ld a,(ctrl_mode)
		cp $01
		call z,pu_sin_read

		ld a,(ctrl_mode)
		cp $02
		call z,pu_kem_read

; Player to nasty collision checks
; Populate B, C, D and E with offset versions of the player
; co-ordinates
		ld a,(player_y)
		scf
		sbc a,$02
		ld d,a
		add a,$07
		ld e,a

		ld a,(player_x)
		scf
		sbc a,$02
		ld b,a
		add a,$07
		ld c,a

; Reset the death flag
		ld a,$00
		ld (player_d_flag),a

; Enemy 1 to player collision check
		ld a,(enemy_1_x)
		cp b
		jp c,pu_e1_coll_skip

		cp c
		jp nc,pu_e1_coll_skip

		ld a,(enemy_1_y)
		cp d
		jp c,pu_e1_coll_skip

		cp e
		jp nc,pu_e1_coll_skip

; Enemy 1 has collided, so react accordingly
		ld a,$7f
		ld (enemy_1_x),a
		ld a,(enemy_1_y)
		add a,$10
		ld (enemy_1_y),a

; Flag that the player has collided
		ld a,(player_d_flag)
		add a,$01
		ld (player_d_flag),a

		jp pu_e4_coll_skip

; Enemy 2 to player collision check
pu_e1_coll_skip	ld a,(enemy_2_x)
		cp b
		jp c,pu_e2_coll_skip

		cp c
		jp nc,pu_e2_coll_skip

		ld a,(enemy_2_y)
		cp d
		jp c,pu_e2_coll_skip

		cp e
		jp nc,pu_e2_coll_skip

; Enemy 2 has collided, so react accordingly
		ld a,$7f
		ld (enemy_2_x),a
		ld a,(enemy_2_y)
		add a,$f0
		ld (enemy_2_y),a

; Flag that the player has collided
		ld a,(player_d_flag)
		add a,$01
		ld (player_d_flag),a

		jp pu_e4_coll_skip

; Enemy 3 to player collision check
pu_e2_coll_skip	ld a,(enemy_3_x)
		cp b
		jp c,pu_e3_coll_skip

		cp c
		jp nc,pu_e3_coll_skip

		ld a,(enemy_3_y)
		cp d
		jp c,pu_e3_coll_skip

		cp e
		jp nc,pu_e3_coll_skip

; Enemy 3 has collided, so react accordingly
		ld a,$7f
		ld (enemy_3_x),a
		ld a,(enemy_3_y)
		add a,$18
		ld (enemy_3_y),a

; Flag that the player has collided
		ld a,(player_d_flag)
		add a,$01
		ld (player_d_flag),a

		jp pu_e4_coll_skip

; Enemy 4 player collision check
pu_e3_coll_skip	ld a,(enemy_4_x)
		cp b
		jp c,pu_e4_coll_skip

		cp c
		jp nc,pu_e4_coll_skip

		ld a,(enemy_4_y)
		cp d
		jp c,pu_e4_coll_skip

		cp e
		jp nc,pu_e4_coll_skip

; Enemy 4 has collided, so react accordingly
		ld a,$7f
		ld (enemy_4_x),a
		ld a,(enemy_4_y)
		add a,$e8
		ld (enemy_4_y),a

; Flag that the player has collided
		ld a,(player_d_flag)
		add a,$01
		ld (player_d_flag),a

		jp pu_e4_coll_skip

; Update the player shield
pu_e4_coll_skip	ld a,(player_shield)
		cp $00
		jp z,pu_exit

; If shield is on, decrease it and zero the death flag
		dec a
		ld (player_shield),a

		ld a,$00
		ld (player_d_flag),a

pu_exit		ret


; Player controls - QAOPM
pu_kbd_read

pu_kbd_up	ld bc,$fbfe		; look for Q
		in a,(c)
		and $01
		call z,pu_move_up

pu_kbd_down	ld bc,$fdfe		; look for A
		in a,(c)
		and $01
		call z,pu_move_down

pu_kbd_left	ld bc,$dffe		; look for O
		in a,(c)
		and $02
		call z,pu_move_left

pu_kbd_right	ld bc,$dffe		; look for P
		in a,(c)
		and $01
		call z,pu_move_right

pu_kbd_fire	ld bc,$7ffe		; look for M
		in a,(c)
		and $04
		call z,pu_bullet_fire

		ret

; Player controls - Sinclair joystick
pu_sin_read	ld bc,$f7fe
		in a,(c)
		ld (ctrl_buffer),a

pu_sin_up	and $08			; look for up
		call z,pu_move_up

pu_sin_down	ld a,(ctrl_buffer)	; look for down
		and $04
		call z,pu_move_down

pu_sin_left	ld a,(ctrl_buffer)	; look for left
		and $01
		call z,pu_move_left

pu_sin_right	ld a,(ctrl_buffer)	; look for right
		and $02
		call z,pu_move_right

pu_sin_fire	ld a,(ctrl_buffer)	; look for fire
		and $10
		call z,pu_bullet_fire

		ret

; Player controls - Kempstom joystick
pu_kem_read	ld bc,$1f
		in a,(c)
		ld (ctrl_buffer),a

pu_kem_up	and $08			; look for up
		call nz,pu_move_up

pu_kem_down	ld a,(ctrl_buffer)	; look for down
		and $04
		call nz,pu_move_down

pu_kem_left	ld a,(ctrl_buffer)	; look for left
		and $02
		call nz,pu_move_left

pu_kem_right	ld a,(ctrl_buffer)	; look for right
		and $01
		call nz,pu_move_right

pu_kem_fire	ld a,(ctrl_buffer)	; look for fire
		and $10
		call nz,pu_bullet_fire

		ret

; Move the player up
pu_move_up	ld a,(player_y)
		ccf
		sbc a,$00
		cp $04
		jp nc,pu_up_okay

		ld a,$04
pu_up_okay	ld (player_y),a
		ret

; Move the player down
pu_move_down	ld a,(player_y)
		add a,$01
		cp $4f
		jp c,pu_down_okay

		ld a,$4f
pu_down_okay	ld (player_y),a
		ret

; Move the player left
pu_move_left	ld a,(player_x)
		ccf
		sbc a,$00
		cp $04
		jp nc,pu_left_okay

		ld a,$04
pu_left_okay	ld (player_x),a
		ret

; Move the player right
pu_move_right	ld a,(player_x)
		add a,$01
		cp $6f
		jp c,pu_right_okay

		ld a,$6f
pu_right_okay	ld (player_x),a
		ret

; Launch the player bullet (if it's not busy)
pu_bullet_fire	ld a,(bullet_y)
		cp $64
		jp nz,pu_bullet_out

; Set bullet X, Y and duration
		ld a,(player_x)
		ld (bullet_x),a
		ld a,(player_y)
		ld (bullet_y),a

		ld a,$0e
		ld (bullet_duration),a

; Set the SFX driver if it's not busy
		ld a,(sfx_duration)
		cp $00
		jp nz,pu_bullet_out

		ld hl,$0100
		ld (sfx_pitch),hl
		ld hl,$0008
		ld (sfx_slide),hl

		ld a,$02
		ld (sfx_duration),a

pu_bullet_out	ret


; Update the player bullet's position and check for right border
bullet_update	ld a,(bullet_x)
		add a,$04
		and $7f
		ld (bullet_x),a

		cp $7b
		jp nc,bu_remove

; Update the bullet's counter and check if it has expired
		ld a,(bullet_duration)
		scf
		sbc a,$00
		ld (bullet_duration),a

		cp $00
		jp z,bu_remove

		jp bu_okay

; Remove the bullet
bu_remove	ld a,$00
		ld (bullet_x),a
		ld a,$64
		ld (bullet_y),a

; Reset the score bonus
bu_okay		ld a,$00
		ld (score_bonus),a

; Bullet to nasty collision checks
		ld a,(bullet_y)
		cp $64
		jp z,bu_e4_coll_skip

; Populate B, C, D and E with offset versions of the bullet
; co-ordinates
		scf
		sbc a,$04
		ld d,a
		add a,$0b
		ld e,a

		ld a,(bullet_x)
		scf
		sbc a,$04
		ld b,a
		add a,$0b
		ld c,a

; Enemy 1 to bullet collision check
		ld a,(enemy_1_x)
		cp b
		jp c,bu_e1_coll_skip

		cp c
		jp nc,bu_e1_coll_skip

		ld a,(enemy_1_y)
		cp d
		jp c,bu_e1_coll_skip

		cp e
		jp nc,bu_e1_coll_skip

; Enemy 1 has been shot, so react accordingly
		ld a,$00
		ld (enemy_1_x),a

		ld a,$64
		ld (bullet_y),a

		ld a,(score_bonus)
		add a,$05
		ld (score_bonus),a

		jp bu_e4_coll_skip

; Enemy 2 to bullet collision check
bu_e1_coll_skip	ld a,(enemy_2_x)
		cp b
		jp c,bu_e2_coll_skip

		cp c
		jp nc,bu_e2_coll_skip

		ld a,(enemy_2_y)
		cp d
		jp c,bu_e2_coll_skip

		cp e
		jp nc,bu_e2_coll_skip

; Enemy 2 has been shot, so react accordingly
		ld a,$00
		ld (enemy_2_x),a

		ld a,$64
		ld (bullet_y),a

		ld a,(score_bonus)
		add a,$05
		ld (score_bonus),a

		jp bu_e4_coll_skip

; Enemy 3 to bullet collision check
bu_e2_coll_skip	ld a,(enemy_3_x)
		cp b
		jp c,bu_e3_coll_skip

		cp c
		jp nc,bu_e3_coll_skip

		ld a,(enemy_3_y)
		cp d
		jp c,bu_e3_coll_skip

		cp e
		jp nc,bu_e3_coll_skip

; Enemy 3 has been shot, so react accordingly
		ld a,$00
		ld (enemy_3_x),a

		ld a,$64
		ld (bullet_y),a

		ld a,(score_bonus)
		add a,$07
		ld (score_bonus),a

		jp bu_e4_coll_skip

; Enemy 4 to bullet collision check
bu_e3_coll_skip	ld a,(enemy_4_x)
		cp b
		jp c,bu_e4_coll_skip

		cp c
		jp nc,bu_e4_coll_skip

		ld a,(enemy_4_y)
		cp d
		jp c,bu_e4_coll_skip

		cp e
		jp nc,bu_e4_coll_skip

; Enemy 4 has been shot, so react accordingly
		ld a,$00
		ld (enemy_4_x),a

		ld a,$64
		ld (bullet_y),a

		ld a,(score_bonus)
		add a,$07
		ld (score_bonus),a

		jp bu_e4_coll_skip

; Jumped to if the bullet is inactive
bu_e4_coll_skip	ret


; Update enemy 1 position
nasty_update	ld hl,enemy_1_x
		dec (hl)
		ld hl,enemy_1_y
		inc (hl)

; Update enemy 2 position
		ld hl,enemy_2_x
		dec (hl)
		ld hl,enemy_2_y
		dec (hl)

; Update enemy 3 position
		ld hl,enemy_3_x
		dec (hl)
		dec (hl)
		ld hl,enemy_3_y
		inc (hl)

; Update enemy 4 position
		ld hl,enemy_4_x
		dec (hl)
		dec (hl)
		ld hl,enemy_4_y
		dec (hl)

; Nudge the sprites around in Y if they're at X $7e/7f
		ld a,(enemy_1_x)
		cp $7e
		jp c,nu_nudge_2

		ld a,(enemy_1_y)
		add a,$30
		ld (enemy_1_y),a

nu_nudge_2	ld a,(enemy_2_x)
		cp $7e
		jp c,nu_nudge_3

		ld a,(enemy_2_y)
		add a,$cd
		ld (enemy_2_y),a

nu_nudge_3	ld a,(enemy_3_x)
		cp $7e
		jp c,nu_nudge_4

		ld a,(enemy_3_y)
		add a,$1d
		ld (enemy_3_y),a

nu_nudge_4	ld a,(enemy_4_x)
		cp $7e
		jp c,nu_nudge_out

		ld a,(enemy_4_y)
		add a,$dd
		ld (enemy_4_y),a

nu_nudge_out

; Make sure none of the X or Y positions are over $7f
		ld a,(enemy_1_x)
		and #$7f
		ld (enemy_1_x),a
		ld a,(enemy_1_y)
		and #$7f
		ld (enemy_1_y),a

		ld a,(enemy_2_x)
		and #$7f
		ld (enemy_2_x),a
		ld a,(enemy_2_y)
		and #$7f
		ld (enemy_2_y),a

		ld a,(enemy_3_x)
		and #$7f
		ld (enemy_3_x),a
		ld a,(enemy_3_y)
		and #$7f
		ld (enemy_3_y),a

		ld a,(enemy_4_x)
		and #$7f
		ld (enemy_4_x),a
		ld a,(enemy_4_y)
		and #$7f
		ld (enemy_4_y),a

; Check to see if a nasty is exploding to trigger a sound
		ld a,(score_bonus)
		cp $00
		jp z,nu_exit

		ld hl,$0200
		ld (sfx_pitch),hl
		ld hl,$fff0
		ld (sfx_slide),hl

		ld a,$12
		ld (sfx_duration),a

nu_exit		ret


; In-game sound effect driver
sfx_driver	ld a,(sfx_duration)
		cp $00
		jp z,sfxd_off

		ccf
		sbc a,$00
		ld (sfx_duration),a

		ld hl,(sfx_pitch)	; pitch
		ld de,$0002		; duration
		call $03b5		; ROM beeper routine

		ld hl,(sfx_pitch)
		ld de,(sfx_slide)
		add hl,de
		ld (sfx_pitch),hl

sfxd_off	ret

; Stand-alone sound driver for game over/completion effects
sfx_sa_driver	ld hl,(sfx_pitch)	; pitch
		ld de,$0002		; duration
		call $03b5		; ROM beeper routine

		ld hl,(sfx_pitch)
		ld de,(sfx_slide)
		add hl,de
		ld (sfx_pitch),hl

		ld a,(sfx_duration)
		ccf
		sbc a,$01
		ld (sfx_duration),a

		cp $00
		jp nz,sfx_sa_driver

		ret


; Set up the screen
screen_init	ld hl,bitmap_ram
		ld e,l
		ld d,h
		inc de
		ld (hl),$00	; fill value
		ld bc,$17ff
		ldir

; Clear the status attribute RAM
		ld hl,attrib_ram
		ld e,l
		ld d,h
		inc de
		ld (hl),$0f	; fill value
		ld bc,$07f
		ldir

; Clear the playfield attribute RAM
		ld hl,attrib_ram+$080
		ld e,l
		ld d,h
		inc de
		ld (hl),$07	; fill value
		ld bc,$027f
		ldir

; Add masks down the sides of the screen
		ld a,$00
		ld (attrib_ram+$000),a
		ld (attrib_ram+$01f),a
		ld (attrib_ram+$020),a
		ld (attrib_ram+$03f),a
		ld (attrib_ram+$040),a
		ld (attrib_ram+$05f),a
		ld (attrib_ram+$060),a
		ld (attrib_ram+$07f),a

		ld (attrib_ram+$080),a
		ld (attrib_ram+$09f),a
		ld (attrib_ram+$0a0),a
		ld (attrib_ram+$0bf),a
		ld (attrib_ram+$0c0),a
		ld (attrib_ram+$0df),a
		ld (attrib_ram+$0e0),a
		ld (attrib_ram+$0ff),a

		ld (attrib_ram+$100),a
		ld (attrib_ram+$11f),a
		ld (attrib_ram+$120),a
		ld (attrib_ram+$13f),a
		ld (attrib_ram+$140),a
		ld (attrib_ram+$15f),a
		ld (attrib_ram+$160),a
		ld (attrib_ram+$17f),a

		ld (attrib_ram+$180),a
		ld (attrib_ram+$19f),a
		ld (attrib_ram+$1a0),a
		ld (attrib_ram+$1bf),a
		ld (attrib_ram+$1c0),a
		ld (attrib_ram+$1df),a
		ld (attrib_ram+$1e0),a
		ld (attrib_ram+$1ff),a

		ld (attrib_ram+$200),a
		ld (attrib_ram+$21f),a
		ld (attrib_ram+$220),a
		ld (attrib_ram+$23f),a
		ld (attrib_ram+$240),a
		ld (attrib_ram+$25f),a
		ld (attrib_ram+$260),a
		ld (attrib_ram+$27f),a

		ld (attrib_ram+$280),a
		ld (attrib_ram+$29f),a
		ld (attrib_ram+$2a0),a
		ld (attrib_ram+$2bf),a
		ld (attrib_ram+$2c0),a
		ld (attrib_ram+$2df),a
		ld (attrib_ram+$2e0),a
		ld (attrib_ram+$2ff),a

; Status text - score
		ld hl,status_text_1	; text source
		ld (text_read),hl
		ld hl,bitmap_ram+$0022	; screen destination
		ld (text_write),hl

		ld hl,attrib_ram+$022	; colour destination
		ld (text_col_write),hl
		ld a,$0b		; text colour
		ld (text_colour),a

		ld a,$05		; text length
		ld (text_length),a
		call text_render

; Status text - lives
		ld hl,status_text_3	; text source
		ld (text_read),hl
		ld hl,bitmap_ram+$0039	; screen destination
		ld (text_write),hl

		ld hl,attrib_ram+$039	; colour destination
		ld (text_col_write),hl
		ld a,$0b		; text colour
		ld (text_colour),a

		ld a,$05		; text length
		ld (text_length),a
		call text_render

; Status bar logo - line 1
		ld hl,status_logo_1	; text source
		ld (text_read),hl
		ld hl,bitmap_ram+$0028	; screen destination
		ld (text_write),hl

		ld hl,attrib_ram+$028	; colour destination
		ld (text_col_write),hl
		ld a,$0f		; text colour
		ld (text_colour),a

		ld a,$10		; text length
		ld (text_length),a
		call text_render

; Status bar logo - line 2
		ld hl,status_logo_2	; text source
		ld (text_read),hl
		ld hl,bitmap_ram+$0048	; screen destination
		ld (text_write),hl

		ld hl,attrib_ram+$048	; colour destination
		ld (text_col_write),hl
		ld a,$0d		; text colour
		ld (text_colour),a

		ld a,$10		; text length
		ld (text_length),a
		call text_render

; Update the status area (called from multiple places)
status_update

; Update the score counter before it's rendered
		ld hl,player_score
		ld de,status_text_2
		ld c,$05

su_score_upd	ld a,(hl)
		add a,$30
		ld (de),a

		inc hl
		inc de

		dec c
		jp nz,su_score_upd

; Update the lives counter before it's rendered
		ld a,(player_lives)
		add a,$30
		ld (status_text_4),a

; Plot the score counter onto the status bar
		ld hl,status_text_2	; text source
		ld (text_read),hl
		ld hl,bitmap_ram+$0042	; screen destination
		ld (text_write),hl

		ld hl,attrib_ram+$042	; colour destination
		ld (text_col_write),hl
		ld a,$0c		; text colour
		ld (text_colour),a

		ld a,$05		; text length
		ld (text_length),a
		call text_render

; Plot the lives counter onto the status bar
		ld hl,status_text_4	; text source
		ld (text_read),hl
		ld hl,bitmap_ram+$005d	; screen destination
		ld (text_write),hl

		ld hl,attrib_ram+$05d	; colour destination
		ld (text_col_write),hl
		ld a,$0c		; text colour
		ld (text_colour),a

		ld a,$01		; text length
		ld (text_length),a
		call text_render

		ret


; Write a line of text into the bitmap with attribute colours
text_render	ld hl,(text_read)	; load HL with current text position
tread		ld a,(hl)		; read text from HL's pos. into A

		ld h,$00		; incoming char to hl and...
		ld l,a

		ccf
		sla l			; ...multiply hl by eight
		rl h
		sla l
		rl h
		sla l
		rl h

		ld bc,char_data		; add on the start of font
		add hl,bc

; Copy the character
		ld de,(text_write)
		ld a,(hl)
		ld (de),a

		inc l
		inc d
		ld a,(hl)
		ld (de),a

		inc l
		inc d
		ld a,(hl)
		ld (de),a

		inc l
		inc d
		ld a,(hl)
		ld (de),a

		inc l
		inc d
		ld a,(hl)
		ld (de),a

		inc l
		inc d
		ld a,(hl)
		ld (de),a

		inc l
		inc d
		ld a,(hl)
		ld (de),a

		inc l
		inc d
		ld a,(hl)
		ld (de),a

; Render the colour
		ld a,(text_colour)
		ld hl,(text_col_write)
		ld (hl),a

; Bump everything to the next byte
		ld hl,(text_read)
		inc hl
		ld (text_read),hl

		ld hl,(text_write)
		inc hl
		ld (text_write),hl

		ld hl,(text_col_write)
		inc hl
		ld (text_col_write),hl

; Decrease the length counter and wrap if it's not zero
		ld a,(text_length)
		dec a
		ld (text_length),a

		cp $00
		jp nz,text_render

		ret


; Add to the player's score
bump_score	ld a,(score_bonus)
		cp $00
		jp z,bs_exit
		ld c,a

bs_outer_loop	ld b,$04
		ld hl,player_score+$03

bs_loop		ld a,(hl)
		add a,$01
		ld (hl),a

		cp $0a
		jp nz,bs_skip

		ld (hl),$00

		dec hl
		dec b
		ld a,b
		cp $00
		jp nz,bs_loop


bs_skip		dec c
		ld a,c
		cp $00
		jp nz,bs_outer_loop

bs_exit		ret


; Prompt for space to be pressed
space_wait	call space_debounce

; Display "Press Space" message
		ld hl,space_txt	; text source
		ld (text_read),hl
		ld hl,bitmap_ram+$10c3	; screen destination
		ld (text_write),hl

		ld hl,attrib_ram+$2c3	; colour destination
		ld (text_col_write),hl
		ld a,$18		; text colour
		ld (text_colour),a

		ld a,$1a		; text length
		ld (text_length),a
		call text_render

; Wait for space to be pressed
space_wait_2	ld bc,$7ffe
		in a,(c)
		and $01
		jp nz,space_wait_2

		ret


; Wait for space to be released
space_debounce	ld bc,$7ffe
		in a,(c)
		and $01
		jp z,space_debounce

		ret


; Bring in the background scroller
		include "includes/scroll_code.asm"

; Bring in the software sprite code and data
		include "includes/sprite_code.asm"


; High/low bytes for offsets to the start of each scanline within RAM
; (Uses a page of the ROM for vertical clipping)
screen_offset	defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00

		defb $40,$80,$41,$80,$42,$80,$43,$80
		defb $44,$80,$45,$80,$46,$80,$47,$80
		defb $40,$a0,$41,$a0,$42,$a0,$43,$a0
		defb $44,$a0,$45,$a0,$46,$a0,$47,$a0
		defb $40,$c0,$41,$c0,$42,$c0,$43,$c0
		defb $44,$c0,$45,$c0,$46,$c0,$47,$c0
		defb $40,$e0,$41,$e0,$42,$e0,$43,$e0
		defb $44,$e0,$45,$e0,$46,$e0,$47,$e0

		defb $48,$00,$49,$00,$4a,$00,$4b,$00
		defb $4c,$00,$4d,$00,$4e,$00,$4f,$00
		defb $48,$20,$49,$20,$4a,$20,$4b,$20
		defb $4c,$20,$4d,$20,$4e,$20,$4f,$20
		defb $48,$40,$49,$40,$4a,$40,$4b,$40
		defb $4c,$40,$4d,$40,$4e,$40,$4f,$40
		defb $48,$60,$49,$60,$4a,$60,$4b,$60
		defb $4c,$60,$4d,$60,$4e,$60,$4f,$60

		defb $48,$80,$49,$80,$4a,$80,$4b,$80
		defb $4c,$80,$4d,$80,$4e,$80,$4f,$80
		defb $48,$a0,$49,$a0,$4a,$a0,$4b,$a0
		defb $4c,$a0,$4d,$a0,$4e,$a0,$4f,$a0
		defb $48,$c0,$49,$c0,$4a,$c0,$4b,$c0
		defb $4c,$c0,$4d,$c0,$4e,$c0,$4f,$c0
		defb $48,$e0,$49,$e0,$4a,$e0,$4b,$e0
		defb $4c,$e0,$4d,$e0,$4e,$e0,$4f,$e0

		defb $50,$00,$51,$00,$52,$00,$53,$00
		defb $54,$00,$55,$00,$56,$00,$57,$00
		defb $50,$20,$51,$20,$52,$20,$53,$20
		defb $54,$20,$55,$20,$56,$20,$57,$20
		defb $50,$40,$51,$40,$52,$40,$53,$40
		defb $54,$40,$55,$40,$56,$40,$57,$40
		defb $50,$60,$51,$60,$52,$60,$53,$60
		defb $54,$60,$55,$60,$56,$60,$57,$60

		defb $50,$80,$51,$80,$52,$80,$53,$80
		defb $54,$80,$55,$80,$56,$80,$57,$80
		defb $50,$a0,$51,$a0,$52,$a0,$53,$a0
		defb $54,$a0,$55,$a0,$56,$a0,$57,$a0
		defb $50,$c0,$51,$c0,$52,$c0,$53,$c0
		defb $54,$c0,$55,$c0,$56,$c0,$57,$c0
		defb $50,$e0,$51,$e0,$52,$e0,$53,$e0
		defb $54,$e0,$55,$e0,$56,$e0,$57,$e0

		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00

		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00

; Run off (only needs to be X bytes where X is the object height)
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00

		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00
		defb $3f,$00,$3f,$00,$3f,$00,$3f,$00


; Current control mode and input buffer
; $00 is keyboard, $01 is Sinclar and $02 is Kempston
ctrl_mode	defb $00
ctrl_buffer	defb $00

; Labels for player status
player_score	defb $05,$03,$02,$08,$00
player_lives	defb $03
score_bonus	defb $00

player_shield	defb $00
player_d_flag	defb $00

; Player's on-screen position (second byte there for speed)
player_x	defb $00,$00
player_y	defb $00,$00

; Player bullet's on-screen position (second byte there for speed)
bullet_x	defb $00,$00
bullet_y	defb $00,$00
bullet_duration	defb $00

; Enemy on-screen positions (second byte there for speed)
enemy_1_x	defb $20,$00
enemy_1_y	defb $10,$00

enemy_2_x	defb $34,$00
enemy_2_y	defb $2b,$00

enemy_3_x	defb $5b,$00
enemy_3_y	defb $36,$00

enemy_4_x	defb $6f,$00
enemy_4_y	defb $48,$00

; Sprite render code workspace
render_x	defb $00,$00
render_y	defb $00,$00


; Labels for the background scroller
tile_count	defb $00
map_position	defb $00,$00
map_flag	defb $00

; Read positions for the current tiles
tile_buffer	defb $00,$00
		defb $00,$00
		defb $00,$00
		defb $00,$00
		defb $00,$00

; Columm buffer for the background scroller
column_buffer	defb $00,$00,$00,$00,$00,$00,$00,$00
		defb $00,$00,$00,$00,$00,$00,$00,$00
		defb $00,$00,$00,$00


; Sound effect labels
sfx_pitch	defb $00,$00
sfx_slide	defb $00,$00
sfx_duration	defb $00


; Labels for the text plotter
text_read	defb $00,$00
text_write	defb $00,$00

text_col_write	defb $00,$00
text_colour	defb $00

text_length	defb $00


; Status bar logo
status_logo_1	defb $00,$01,$02,$03,$04,$05,$06,$07
		defb $08,$09,$0a,$0b,$06,$07,$04,$05

status_logo_2	defb $10,$11,$12,$13,$14,$15,$16,$17
		defb $18,$19,$1a,$1b,$16,$17,$14,$15

; Status bar text
status_text_1	defb "Score"
status_text_2	defb "     "
status_text_3	defb "Lives"
status_text_4	defb " "


; Titles logo data
t_logo_1	defb $0e,$5c,$5c,$5d,$5b,$5e,$5d,$5d
		defb $0e,$5c,$5c,$0f,$0e,$5c,$5c,$0e
		defb $5c,$5c,$0f,$0e,$5c,$5c,$0f,$0e
		defb $5c,$5c,$0e,$5c,$5c,$0f

t_logo_2	defb $1e,$5c,$5c,$0f,$20,$7c,$20,$20
		defb $7e,$5c,$5c,$7f,$7c,$20,$20,$7c
		defb $20,$20,$20,$7c,$20,$20,$7c,$7c
		defb $20,$20,$7e,$5c,$5c,$7f

t_logo_3	defb $5f,$5c,$5c,$1f,$20,$7d,$20,$20
		defb $1e,$5c,$5c,$5f,$7d,$20,$20,$1e
		defb $5c,$5c,$1f,$1e,$5c,$5c,$1f,$7d
		defb $20,$20,$1e,$5c,$5c,$5f

; Titles logo colour effect counters
t_colour_count	defb $00,$00
t_luma_count	defb $00,$00

; Titles logo effect colour data
t_colour_data	defb $07,$07,$07,$06,$07,$06,$06,$06
		defb $05,$06,$05,$05,$05,$04,$05,$04
		defb $04,$04,$03,$04,$03,$03,$03,$02
		defb $03,$02,$02,$02,$01,$02,$01,$01
		defb $01,$02,$01,$02,$02,$02,$03,$02
		defb $03,$03,$03,$04,$03,$04,$04,$04
		defb $05,$04,$05,$05,$05,$06,$05,$06
		defb $06,$06,$07,$06,$ff

; Titles logo effect luma data
t_luma_data	defb $00,$00,$00,$00,$00,$00,$00,$00
		defb $00,$00,$00,$00,$00,$00,$00,$00
		defb $00,$00,$00,$00,$00,$00,$00,$00
		defb $00,$00,$00,$00,$00,$00,$00,$00
		defb $00,$00,$00,$00,$00,$00,$00,$00
		defb $00,$00,$00,$00,$00,$00,$00,$00
		defb $00,$00,$00,$00,$00,$00,$00,$00
		defb $00,$00,$00,$00,$00,$00,$00,$00

		defb $00,$00,$00,$00,$00,$00,$00,$00
		defb $00,$00,$00,$00,$00,$00,$00,$00
		defb $00,$00,$00,$00,$00,$00,$00,$00
		defb $00,$00,$00,$00,$00,$00,$00,$00
		defb $00,$00,$00,$00,$00,$00,$00,$00
		defb $00,$00,$00,$00,$40,$00,$00,$40
		defb $00,$40,$40,$00,$40,$40,$40,$40
		defb $00,$40,$40,$00,$40,$00,$40,$ff

; Titles text
t_menu_1	defb " Space    Start "
t_menu_2	defb " K    Q,A,O,P,M "
t_menu_3	defb " S     Sinclair "
t_menu_4	defb " J     Kempston "

t_credit_1	defb "A C64CD Studios Production"
t_credit_2	defb "For the CSSCGC in 2018"

; Titles scroller text
t_scrl_text	defb "Hello and welcome to"
		defb "        "

		defb "-=- STERCORE -=-"
		defb "        "

		defb "A scrolling shoot 'em up from the C64CD "
		defb "software mines which was released for the "
		defb "CSSCGC 2018"
		defb "        "

		defb "Programming, graphics, sound, general "
		defb "data wrangling and tea making by "
		defb "Jason"
		defb "        "

		defb "Launch your battered spaceship and fly "
		defb "headlong into a brightly coloured world "
		defb "filled with dumb enemies that need to "
		defb "be obliterated for... reasons?"
		defb "        "

		defb "It's a shoot 'em up, nobody really reads "
		defb "the instructions for these things so just "
		defb "start the game and go cause havoc already!"
		defb "        "

		defb "100 percent machine washable (apart from "
		defb "the bits that aren't) - this game is "
		defb "fully compatible with the ZX Spectrum "
		defb "Vega+"
		defb "        "

		defb "C64CD greetings blast out towards:  "
		defb "1001 Crew, "
		defb "Ash And Dave, "
		defb "Black Bag, "
		defb "Copy Service Stuttgart, "
		defb "Borderzone Dezign Team, "
		defb "Dynamic Duo, "

		defb "Four Horsemen Of The Apocalypse, "
		defb "Happy Demomaker, "
		defb "Harlow Cracking Service, "
		defb "High-tech Team, "
		defb "Ikari, "
		defb "Jewels, "

		defb "Kernal, "
		defb "Laxity, "
		defb "Mean Team, "
		defb "Paul, Shandor and Matt, "
		defb "Pulse Productions, "
		defb "Reset 86, "

		defb "Rob Hubbard, "
		defb "Scoop, "
		defb "Slipstream, "
		defb "Stoat And Tim, "
		defb "Tangent, "
		defb "Thalamus, "

		defb "The Commandos, "
		defb "The GPS, "
		defb "The Six Pack, "
		defb "We Music, "
		defb "Xess, "
		defb "Yak, "

		defb "and Yeti Factories."
		defb "      "

		defb "And of course the now traditional anti-greeting "
		defb "to C64hater because we might as well whilst "
		defb "here..."
		defb "        "

		defb "And that's everything sorted, so here we are "
		defb "signing off on 2018-12-13 - goodbye for now "
		defb "and enjoy shooting at things... .. .  ."
		defb "        "

		defb $ff		; end of text marker

; Titles scroller work buffer and counter
t_char_buffer	defb $00,$00,$00,$00,$00,$00,$00,$00
t_scrl_count	defb $00,$00
t_scrl_timer	defb $00

; Colours for the titles scroller
t_scrl_c_data	defb $0a,$0b,$0c,$0d,$0e,$0f,$0f,$0f
		defb $0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f
		defb $0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f
		defb $0f,$0e,$0d,$0c,$0b,$0a


; Press Space prompt text
space_txt	defb " Press Space To Continue! "


; Completion text
completion_1	defb " Mission Completed! "
completion_2	defb " Well Done! "


; Game over text
game_over_text	defb " Game Over! "


; Pull in the Beepola music
		org $8000
music		incbin "binary/music.raw"

; User defined character set
		org $8400
char_data	incbin "binary/characters.chr"


; Background tile data - this block must start on a page
; boundary
		org $8800
tile_data	incbin "binary/background.til"

; Background map data
level_data	incbin "binary/background.map"
		defb $ff,$00,$00,$00,$00	; end of data marker


; Binary data for the software sprites
player_data	incbin "binary/player_spr.raw"

enemy_1_data	incbin "binary/enemy_1_spr.raw"
enemy_2_data	incbin "binary/enemy_2_spr.raw"


; Set the start address of the assembled code
		end code_start
