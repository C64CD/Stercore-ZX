;
; STERCORE BACKGROUND SCROLL CODE
;

; Scroll the playfield attribute RAM using LDIR
scroll_update	ld hl,attrib_ram+$082
		ld de,attrib_ram+$081
		ld bc,$001d
		ldir
		ld a,(column_buffer+$00)
		ld (attrib_ram+$09e),a

		ld hl,attrib_ram+$0a2
		ld de,attrib_ram+$0a1
		ld bc,$001d
		ldir
		ld a,(column_buffer+$01)
		ld (attrib_ram+$0be),a

		ld hl,attrib_ram+$0c2
		ld de,attrib_ram+$0c1
		ld bc,$001d
		ldir
		ld a,(column_buffer+$02)
		ld (attrib_ram+$0de),a

		ld hl,attrib_ram+$0e2
		ld de,attrib_ram+$0e1
		ld bc,$001d
		ldir
		ld a,(column_buffer+$03)
		ld (attrib_ram+$0fe),a

		ld hl,attrib_ram+$102
		ld de,attrib_ram+$101
		ld bc,$001d
		ldir
		ld a,(column_buffer+$04)
		ld (attrib_ram+$11e),a

		ld hl,attrib_ram+$122
		ld de,attrib_ram+$121
		ld bc,$001d
		ldir
		ld a,(column_buffer+$05)
		ld (attrib_ram+$13e),a

		ld hl,attrib_ram+$142
		ld de,attrib_ram+$141
		ld bc,$001d
		ldir
		ld a,(column_buffer+$06)
		ld (attrib_ram+$15e),a

		ld hl,attrib_ram+$162
		ld de,attrib_ram+$161
		ld bc,$001d
		ldir
		ld a,(column_buffer+$07)
		ld (attrib_ram+$17e),a

		ld hl,attrib_ram+$182
		ld de,attrib_ram+$181
		ld bc,$001d
		ldir
		ld a,(column_buffer+$08)
		ld (attrib_ram+$19e),a

		ld hl,attrib_ram+$1a2
		ld de,attrib_ram+$1a1
		ld bc,$001d
		ldir
		ld a,(column_buffer+$09)
		ld (attrib_ram+$1be),a

		ld hl,attrib_ram+$1c2
		ld de,attrib_ram+$1c1
		ld bc,$001d
		ldir
		ld a,(column_buffer+$0a)
		ld (attrib_ram+$1de),a

		ld hl,attrib_ram+$1e2
		ld de,attrib_ram+$1e1
		ld bc,$001d
		ldir
		ld a,(column_buffer+$0b)
		ld (attrib_ram+$1fe),a

		ld hl,attrib_ram+$202
		ld de,attrib_ram+$201
		ld bc,$001d
		ldir
		ld a,(column_buffer+$0c)
		ld (attrib_ram+$21e),a

		ld hl,attrib_ram+$222
		ld de,attrib_ram+$221
		ld bc,$001d
		ldir
		ld a,(column_buffer+$0d)
		ld (attrib_ram+$23e),a

		ld hl,attrib_ram+$242
		ld de,attrib_ram+$241
		ld bc,$001d
		ldir
		ld a,(column_buffer+$0e)
		ld (attrib_ram+$25e),a

		ld hl,attrib_ram+$262
		ld de,attrib_ram+$261
		ld bc,$001d
		ldir
		ld a,(column_buffer+$0f)
		ld (attrib_ram+$27e),a

		ld hl,attrib_ram+$282
		ld de,attrib_ram+$281
		ld bc,$001d
		ldir
		ld a,(column_buffer+$10)
		ld (attrib_ram+$29e),a

		ld hl,attrib_ram+$2a2
		ld de,attrib_ram+$2a1
		ld bc,$001d
		ldir
		ld a,(column_buffer+$11)
		ld (attrib_ram+$2be),a

		ld hl,attrib_ram+$2c2
		ld de,attrib_ram+$2c1
		ld bc,$001d
		ldir
		ld a,(column_buffer+$12)
		ld (attrib_ram+$2de),a

		ld hl,attrib_ram+$2e2
		ld de,attrib_ram+$2e1
		ld bc,$001d
		ldir
		ld a,(column_buffer+$13)
		ld (attrib_ram+$2fe),a

; Draw a column in from the current tiles
su_column_draw	ld ix,column_buffer

		ld hl,(tile_buffer+$00)		; read location
		ld bc,$0004			; read step
		ld de,$0001			; write step
		call su_tile_draw

		ld hl,(tile_buffer+$02)		; read location
		call su_tile_draw

		ld hl,(tile_buffer+$04)		; read location
		call su_tile_draw

		ld hl,(tile_buffer+$06)		; read location
		call su_tile_draw

		ld hl,(tile_buffer+$08)		; read location
		call su_tile_draw

; Update the tile reader
		ld hl,(tile_buffer+$00)
		inc hl
		ld (tile_buffer+$00),hl

		ld hl,(tile_buffer+$02)
		inc hl
		ld (tile_buffer+$02),hl

		ld hl,(tile_buffer+$04)
		inc hl
		ld (tile_buffer+$04),hl

		ld hl,(tile_buffer+$06)
		inc hl
		ld (tile_buffer+$06),hl

		ld hl,(tile_buffer+$08)
		inc hl
		ld (tile_buffer+$08),hl

; Count how far into the tile we've got
		ld a,(tile_count)
		inc a
		ld (tile_count),a
		cp $04
		jp nz,su_cd_exit

; Read the next column of tiles
		ld de,(map_position)		; tile row $00
		ld a,(de)

		cp $ff
		jp nz,su_no_end

; $ff found, so clear map_flag to signal the end has been reached
		ld a,$00
		ld (map_flag),a

; Carry on with unpacking the column of tiles
su_no_end	ld l,a
		ld h,$00
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		ld a,h
		ld b,h
		add a,high tile_data
		ld h,a

		ld (tile_buffer+$00),hl

		inc de
		ld (map_position),de

		ld de,(map_position)		; tile row $01
		ld a,(de)
		ld l,a
		ld h,$00
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		ld a,h
		ld b,h
		add a,high tile_data
		ld h,a
		ld (tile_buffer+$02),hl

		inc de
		ld (map_position),de

		ld de,(map_position)		; tile row $02
		ld a,(de)
		ld l,a
		ld h,$00
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		ld a,h
		ld b,h
		add a,high tile_data
		ld h,a
		ld (tile_buffer+$04),hl

		inc de
		ld (map_position),de

		ld de,(map_position)		; tile row $03
		ld a,(de)
		ld l,a
		ld h,$00
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		ld a,h
		ld b,h
		add a,high tile_data
		ld h,a
		ld (tile_buffer+$06),hl

		inc de
		ld (map_position),de

		ld de,(map_position)		; tile row $04
		ld a,(de)
		ld l,a
		ld h,$00
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		ld a,h
		ld b,h
		add a,high tile_data
		ld h,a
		ld (tile_buffer+$08),hl

		inc de
		ld (map_position),de

; Reset the tile count
		ld a,$00
		ld (tile_count),a

su_cd_exit	ret

; Subroutine to draw a column from a tile to the specified
; part of the screen
su_tile_draw	ld a,(hl)
		ld (ix),a
		add hl,bc
		add ix,de

		ld a,(hl)
		ld (ix),a
		add hl,bc
		add ix,de

		ld a,(hl)
		ld (ix),a
		add hl,bc
		add ix,de

		ld a,(hl)
		ld (ix),a
		add ix,de

		ret

; Reset the map readers to the start of their data
scroll_reset	ld hl,level_data
		ld (map_position),hl

		ld hl,tile_data
		ld (tile_buffer+$00),hl
		ld (tile_buffer+$02),hl
		ld (tile_buffer+$04),hl
		ld (tile_buffer+$06),hl
		ld (tile_buffer+$08),hl

		ld a,$00
		ld (tile_count),a

		ld a,$01
		ld (map_flag),a

; Fetch the first column of data
		call su_column_draw

		ret
