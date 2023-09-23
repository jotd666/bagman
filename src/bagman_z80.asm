;;; bagman (le bagnard)
;;;
;;; Z80
;;; disassembled by JOTD in 2010 (never too late for a good job!!)
;;;
;;; Original code (C) 1982 Valadon Automation, singlehandedly coded
;;; by Jacques Brisse
;;;
	;; 554C:	 0 no guard collision
;;; 131B 00 C3 27 13 no timer death
;; wp 6025,1,w :	 watchpoints

;;;  guard sees right:	$80, left $40, up $10, down $20

;;; todo:	 find the "guard stuck" monitoring routine that resets guard at the third screen:	block the guards at 3rd screen to see!
;;; gameplay_allowed_6054:	if 0, cannot do anything. pressing start sets to 1:	 unimportant for the game
;;; elevator_y_current_screen_6587:
;;; elevator_dir_current_screen_6010:	 direction shared by both elevators:	1 up, 0 down
;;; elevator_not_moving_6012:	 0 moving:	 characters cannot move, 1 not moving
;;; the elevator direction and elevator floor timer are shared by both elevators
;;; the master being the one of the current screen or the one from screen 2
;;; if player is on screen 1
;;; elevator not in player screen does not move until in player screen!!!
;;; this explains the strange elevator behavior. This is deliberate and allows
;;; for instance to fetch the bags of screen 2 while using the elevator from
;;; screen 3. By timing it wisely, one can avoid the "go down bug"
;;; also explains that the guards never wait for an elevator when not in player
;;; screen:	 they could wait forever since it's not moving!!!!

;;;  1A0B:	 A.I. for branch with player/guard screen different

;;; xy <-> logical address conversions (Python proto code)
;def xy2addr(x,y,current_screen):
; # current screen 1..3
;     rval = 0x4062 + 0x400 * (current_screen-1) + y//8 + ((0xE0-x)//8)*0x20
;     return rval
;def addr2xy(addr):
; # current screen 1..3
;     b = addr - 0x4000
;     current_screen = 1
;     while b < 0x400:
;	b-=0x400
;	current_screen+=1
;     b -= 0x62
;     y = (b % 0x20) * 8
;     x = 0xE0 - b // 4
;     return [x,y,current_screen]

;tables:
;2CD3:	guard elevator waiting point table
;5974:	guard path branch address table
;5A10:	guard screen 1 => screen 2 (3 bytes/entry)
;5A3D:	guard screen 2 => screen 1 (3 bytes/entry)
;5A76:	guard screen 2 => screen 3 (3 bytes/entry)
;5AAF:	guard screen 3 => screen 2 (there's a buggy/useless value in this table)
;address is a grid with a 8x8 resolution

	;; guard move clocks:	 5A4
	;; player move clocks 4E4

		;; debug part 1A20

;  from MAME drover
; memory map:
;
; 0000-5fff ROM
; 6000-67ff RAM
; 9000-93ff Video RAM
; 9800-9bff Color RAM
; 9800-981f Sprites (hidden portion of color RAM)
; 9c00-9fff ? (filled with 3f, not used otherwise)
; c000-ffff ROM (Super Bagman only)
;
; memory mapped ports:
;
; read:
; a000      PAL16r6 output. (RD4 line)
; a800      ? (read only in one place, not used) (RD5 line)
; b000      DSW (RD6 line)
; b800      watchdog reset (RD7 line)
;
; write:
; a000      interrupt enable
; a001      horizontal flip
; a002      vertical flip
; a003      video enable, not available on earlier hardware revision(s)
; a004      coin counter
; a007      ? /SCS line in the schems connected to AY8910 pin A4 or AA (schems are unreadable)
;
; a800-a805 these lines control the state machine driving TMS5110 (only bit 0 matters)
;           a800,a801,a802 - speech roms BIT select (000 bit 7, 001 bit 4, 010 bit 2)
;           a803 - 0 keeps the state machine in reset state; 1 starts speech
;           a804 - connected to speech rom 11 (QS) chip enable
;           a805 - connected to speech rom 12 (QT) chip enable
; b000      ?
; b800      ?


0000: C3 00 12      jp   $1200
0003: 04            inc  b
0004: 03            inc  bc
0005: 40            ld   b,b
0006: 64            ld   h,h
0007: 06 C0         ld   b,$C0
0009: 40            ld   b,b
000A: 41            ld   b,c
000B: 14            inc  d
000C: 9D            sbc  a,l
000D: 08            ex   af,af'
000E: 24            inc  h
000F: A0            and  b
0010: 42            ld   b,d
0011: 06 26         ld   b,$26
0013: 48            ld   c,b
0014: 18 00         jr   $0016
0016: 20 40         jr   nz,$0058
0018: 07            rlca
0019: 24            inc  h
001A: 0C            inc  c
001B: 50            ld   d,b
001C: 01 C0 04      ld   bc,$04C0
001F: 04            inc  b
0020: 41            ld   b,c
0021: 05            dec  b
0022: 01 00 CC      ld   bc,$CC00
0025: C1            pop  bc
0026: 60            ld   h,b
0027: C0            ret  nz
0028: 29            add  hl,hl
0029: 04            inc  b
002A: 1C            inc  e
002B: E1            pop  hl
002C: 08            ex   af,af'
002D: C0            ret  nz
002E: 01 41 04      ld   bc,$0441
0031: 50            ld   d,b
0032: 02            ld   (bc),a
0033: 40            ld   b,b
0034: 48            ld   c,b
0035: C0            ret  nz
0036: 42            ld   b,d
0037: 2B            dec  hl

;; interrupt handler
0038: F5            push af
0039: C5            push bc
003A: D5            push de
003B: E5            push hl
003C: DD E5         push ix
003E: FD E5         push iy
0040: D9            exx
0041: C5            push bc
0042: D5            push de
0043: E5            push hl
0044: 08            ex   af,af'
0045: F5            push af
0046: CD 47 3C      call $3C47
0049: AF            xor  a
004A: 32 00 A0      ld   (interrupt_control_A000),a
004D: F3            di
004E: CD 23 31      call $3123
0051: CD FA 38      call $38FA
0054: 3A 42 61      ld   a,(unknown_6142)
0057: 3C            inc  a
0058: 32 42 61      ld   (unknown_6142),a
005B: 3A 74 62      ld   a,(is_intermission_6274)
005E: FE 01         cp   $01
0060: 28 05         jr   z,$0067
0062: 3A ED 61      ld   a,(check_scenery_disabled_61ED)
0065: FE 00         cp   $00
0067: CC 7F 0F      call z,handle_ay_sound_0f7f
006A: 3A 6F 62      ld   a,(unknown_626F)
006D: FE 01         cp   $01
006F: CA 94 03      jp   z,$0394
0072: 3A 10 62      ld   a,(unknown_6210)
0075: FE 01         cp   $01
0077: 20 22         jr   nz,$009B
0079: 3A 54 60      ld   a,(gameplay_allowed_6054)
007C: FE 00         cp   $00
007E: 28 1B         jr   z,$009B
0080: 3A F2 61      ld   a,(unknown_61F2)
0083: FE 01         cp   $01
0085: 28 14         jr   z,$009B
0087: 3A ED 61      ld   a,(check_scenery_disabled_61ED)
008A: FE 01         cp   $01
008C: 28 0D         jr   z,$009B
008E: 3A 82 65      ld   a,(player_x_6582)
0091: FE E9         cp   $E9
0093: D2 94 03      jp   nc,$0394
0096: FE 0F         cp   $0F
0098: DA 94 03      jp   c,$0394
009B: 3A 00 B8      ld   a,(io_read_shit_B800)
* update sprite shadow ram
009E: 11 00 98      ld   de,$9800
00A1: 21 A0 65      ld   hl,sprite_shadow_ram_65A0
00A4: 01 20 00      ld   bc,$0020
00A7: ED B0         ldir
00A9: CD A4 34      call log_inserted_coins_34A4
00AC: CD 3E 35      call decrease_timer_353e
00AF: 3A 43 61      ld   a,(unknown_6143)
00B2: 3C            inc  a
00B3: 32 43 61      ld   (unknown_6143),a
00B6: CD D1 10      call speech_management_10D1
00B9: 3A 6D 62      ld   a,(unknown_626D)
00BC: 3C            inc  a
00BD: 32 6D 62      ld   (unknown_626D),a
00C0: FD 21 B8 65   ld   iy,previous_guard_1_struct_65B8

00C4: 3A 0D 60      ld   a,(player_screen_600D)
00C7: 47            ld   b,a
00C8: 3A 99 60      ld   a,(guard_1_screen_6099)
00CB: B8            cp   b
00CC: 28 05         jr   z,$00D3 ;  same screen:	 skip

	;; not the same screen between player and guard 1
00CE: CD CB 10      call set_previous_guard_y_255_10CB
00D1: 18 0B         jr   $00DE
	;; same screen guard 1 / player
00D3: DD 21 94 65   ld   ix,guard_1_struct_6594
00D7: FD 21 B8 65   ld   iy,previous_guard_1_struct_65B8
00DB: CD 01 10      call copy_4_bytes_ix_iy_1001

00DE: FD 21 BC 65   ld   iy,previous_guard_2_struct_65BC
00E2: 3A 0D 60      ld   a,(player_screen_600D)
00E5: 47            ld   b,a
00E6: 3A 9A 60      ld   a,(guard_2_screen_609A)
00E9: B8            cp   b
00EA: 28 05         jr   z,$00F1 ;  same screen:	 skip

00EC: CD CB 10      call set_previous_guard_y_255_10CB
00EF: 18 0B         jr   $00FC
	;;; same screen guard 2 / player
00F1: DD 21 98 65   ld   ix,guard_2_struct_6598
00F5: FD 21 BC 65   ld   iy,previous_guard_2_struct_65BC
00F9: CD 01 10      call copy_4_bytes_ix_iy_1001

00FC: 3A 53 60      ld   a,(unknown_6053)
00FF: FE 01         cp   $01
0101: CA 80 03      jp   z,$0380
0104: CD 72 04      call $0472
0107: 3A 51 61      ld   a,(unknown_6151)
010A: FE 01         cp   $01
010C: CA 80 03      jp   z,$0380
010F: CD 9A 5C      call $5C9A
0112: 3A 00 B8      ld   a,(io_read_shit_B800)
0115: CD F4 03      call $03F4
0118: CD 96 2C      call $2C96
011B: CD 4E 34      call $344E
011E: CD D4 3C      call $3CD4
0121: 3A 00 B8      ld   a,(io_read_shit_B800)
0124: 3A 71 62      ld   a,(unknown_6271)
0127: 32 72 62      ld   (unknown_6272),a
012A: 3A 0C 57      ld   a,($570C) ; ALADON AUTOMATION !!!!
012D: 32 71 62      ld   (unknown_6271),a
0130: CD FB 07      call $07FB
0133: 3A 2C 60      ld   a,(unknown_602C)
0136: FE 01         cp   $01
0138: 28 06         jr   z,$0140
013A: CD 84 07      call player_grip_handle_test_0784
013D: 3A 00 B8      ld   a,(io_read_shit_B800)
0140: CD D5 07      call $07D5
0143: AF            xor  a
0144: 32 2C 60      ld   (unknown_602C),a
0147: FD 21 56 61   ld   iy,unknown_6156
014B: DD 21 94 65   ld   ix,guard_1_struct_6594
014F: 11 48 61      ld   de,unknown_6148
0152: CD 03 04      call $0403
0155: FD 21 57 61   ld   iy,unknown_6157
0159: DD 21 98 65   ld   ix,guard_2_struct_6598
015D: 11 49 61      ld   de,unknown_6149
0160: CD 03 04      call $0403
0163: 2A 38 60      ld   hl,(guard_1_logical_address_6038)
0166: DD 21 EB 61   ld   ix,unknown_61EB
016A: FD 21 3A 60   ld   iy,unknown_603A
016E: DD 7E 00      ld   a,(ix+$00)
0171: DD A6 01      and  (ix+$01)
0174: 08            ex   af,af'
0175: 11 97 65      ld   de,guard_1_y_6597
0178: 3A 99 60      ld   a,(guard_1_screen_6099)
017B: 47            ld   b,a
017C: 3A EB 61      ld   a,(unknown_61EB)
017F: FE 00         cp   $00
0181: C4 0E 35      call nz,$350E
0184: 2A 78 60      ld   hl,(guard_2_screen_address_6078)
0187: DD 21 EC 61   ld   ix,unknown_61EC
018B: FD 21 7A 60   ld   iy,unknown_607A
018F: 11 9B 65      ld   de,guard_2_y_659B
0192: 3E 00         ld   a,$00
0194: 08            ex   af,af'
0195: 3A 9A 60      ld   a,(guard_2_screen_609A)
0198: 47            ld   b,a
0199: 3A EC 61      ld   a,(unknown_61EC)
019C: FE 00         cp   $00
019E: C4 0E 35      call nz,$350E
01A1: CD B1 03      call $03B1
01A4: 3A 00 B8      ld   a,(io_read_shit_B800)
01A7: 3A ED 61      ld   a,(check_scenery_disabled_61ED)
01AA: FE 00         cp   $00
01AC: CC 83 16      call z,$1683
01AF: CD 9D 10      call $109D
01B2: 3A 00 B8      ld   a,(io_read_shit_B800)
01B5: CD 84 1D      call wagon_player_collision_1D84
01B8: CD 84 06      call handle_player_walk_0684
01BB: CD F4 31      call $31F4
01BE: CD D5 06      call $06D5
01C1: 3A 00 B8      ld   a,(io_read_shit_B800)
01C4: CD B0 08      call compute_wagon_start_values_08b0
01C7: CD 30 08      call $0830
01CA: 3A 00 B8      ld   a,(io_read_shit_B800)
01CD: CD FF 10      call $10FF
01D0: 3A ED 61      ld   a,(check_scenery_disabled_61ED)
01D3: FE 00         cp   $00
01D5: CC F4 08      call z,$08F4
01D8: 3A 00 B8      ld   a,(io_read_shit_B800)
01DB: CD 3C 11      call handle_pick_hold_timer_113c
01DE: 3A 83 65      ld   a,(player_y_6583)
01E1: F5            push af
01E2: 3D            dec  a
01E3: 32 83 65      ld   (player_y_6583),a
01E6: CD 5E 55      call update_player_screen_address_from_xy_555E
01E9: F1            pop  af
01EA: 32 83 65      ld   (player_y_6583),a
01ED: 3A C7 61      ld   a,(holds_barrow_61C7)
01F0: FE 00         cp   $00
01F2: CC C7 0D      call z,$0DC7
01F5: 3A 4E 60      ld   a,(fatal_fall_height_reached_604E)
01F8: FE 00         cp   $00
01FA: 20 22         jr   nz,$021E
01FC: CD 5E 55      call update_player_screen_address_from_xy_555E
01FF: CD 65 3D      call $3D65
0202: 3A 14 60      ld   a,(unknown_6014)
0205: FE 01         cp   $01
0207: 20 07         jr   nz,$0210
0209: 3A 12 60      ld   a,(elevator_not_moving_6012)
020C: FE 01         cp   $01
020E: 20 0E         jr   nz,$021E
0210: FD 21 47 60   ld   iy,unknown_6047
0214: DD 21 80 65   ld   ix,player_struct_6580
0218: CD 6D 0B      call player_movement_0B6D
021B: 3A 00 B8      ld   a,(io_read_shit_B800)
021E: CD 10 10      call $1010
0221: CD 4B 10      call $104B
0224: 3E 01         ld   a,$01
0226: 32 8A 62      ld   (unknown_628A),a
0229: 3A 0D 60      ld   a,(player_screen_600D)
022C: 32 98 60      ld   (screen_index_param_6098),a
022F: 21 14 60      ld   hl,unknown_6014
0232: DD 21 80 65   ld   ix,player_struct_6580
0236: CD 27 0A      call $0A27
0239: 3A 00 B8      ld   a,(io_read_shit_B800)
023C: 3A F2 61      ld   a,(unknown_61F2)
023F: FE 00         cp   $00
0241: 20 20         jr   nz,$0263
0243: 3A 0D 60      ld   a,(player_screen_600D)
0246: 32 98 60      ld   (screen_index_param_6098),a
0249: 21 08 60      ld   hl,unknown_6008
024C: FD 21 4D 60   ld   iy,fall_height_604D
0250: DD 21 80 65   ld   ix,player_struct_6580
0254: 3A 14 60      ld   a,(unknown_6014)
0257: 4F            ld   c,a
0258: 3A 13 60      ld   a,(unknown_6013)
025B: 06 19         ld   b,$19
025D: CD 2E 0B      call $0B2E
0260: 3A 00 B8      ld   a,(io_read_shit_B800)
0263: 3A 0D 60      ld   a,(player_screen_600D)
0266: 32 98 60      ld   (screen_index_param_6098),a
0269: DD 21 80 65   ld   ix,player_struct_6580
026D: FD 21 14 60   ld   iy,unknown_6014
0271: CD 66 0A      call handle_elevators_0a66
0274: DD 21 80 65   ld   ix,player_struct_6580
0278: 21 14 60      ld   hl,unknown_6014
027B: CD A0 09      call $09A0
027E: 3A 56 61      ld   a,(unknown_6156)
0281: FE 00         cp   $00
0283: 20 35         jr   nz,$02BA
0285: 3A 11 62      ld   a,(unknown_6211)
0288: FE 00         cp   $00
028A: 20 11         jr   nz,$029D
028C: 3A 3B 60      ld   a,(guard_1_in_elevator_603B)
028F: FE 01         cp   $01
0291: 20 07         jr   nz,$029A
0293: 3A 12 60      ld   a,(elevator_not_moving_6012)
0296: FE 01         cp   $01
0298: 20 03         jr   nz,$029D
	;; routine actually moving the guards
;;;  theres some other routine monitoring the guard movements
;;;  if they don't move, then reset them to the center up of the neighbor screen
;;;  did not locate this routine yet but this is not really important

029A: CD 6F 11      call guard_1_movement_116F
029D: FD 21 57 60   ld   iy,unknown_6057
02A1: FD 22 93 60   ld   (guard_struct_pointer_6093),iy
02A5: 2A 38 60      ld   hl,(guard_1_logical_address_6038)
02A8: 22 44 60      ld   (unknown_6044),hl
02AB: 21 35 60      ld   hl,guard_1_ladder_frame_6035
02AE: FD 21 27 60   ld   iy,guard_1_direction_6027
02B2: 3A 37 60      ld   a,(unknown_6037)
02B5: FE 01         cp   $01
02B7: C4 AD 04      call nz,guard_ladder_movement_04AD
02BA: 3A 57 61      ld   a,(unknown_6157)
02BD: FE 00         cp   $00
02BF: 20 3B         jr   nz,$02FC
02C1: 3A 12 62      ld   a,(unknown_6212)
02C4: FE 00         cp   $00
02C6: 20 11         jr   nz,$02D9
02C8: 3A 7B 60      ld   a,(guard_2_in_elevator_607B)
02CB: FE 01         cp   $01
02CD: 20 07         jr   nz,$02D6
02CF: 3A 12 60      ld   a,(elevator_not_moving_6012)
02D2: FE 01         cp   $01
02D4: 20 03         jr   nz,$02D9
02D6: CD 9B 11      call guard_2_movement_119B
02D9: 2A 78 60      ld   hl,(guard_2_screen_address_6078)
02DC: 22 44 60      ld   (unknown_6044),hl
02DF: FD 21 97 60   ld   iy,unknown_6097
02E3: FD 22 93 60   ld   (guard_struct_pointer_6093),iy
02E7: 2A 78 60      ld   hl,(guard_2_screen_address_6078)
02EA: 22 44 60      ld   (unknown_6044),hl
02ED: 21 75 60      ld   hl,guard_2_ladder_frame_6075
02F0: FD 21 67 60   ld   iy,guard_2_direction_6067
02F4: 3A 77 60      ld   a,(unknown_6077)
02F7: FE 01         cp   $01
02F9: C4 AD 04      call nz,guard_ladder_movement_04AD
02FC: 3A 9A 60      ld   a,(guard_2_screen_609A)
02FF: 32 98 60      ld   (screen_index_param_6098),a
0302: 21 7B 60      ld   hl,guard_2_in_elevator_607B
0305: DD 21 98 65   ld   ix,guard_2_struct_6598
0309: CD 27 0A      call $0A27
030C: 3A 00 B8      ld   a,(io_read_shit_B800)
030F: 3A 97 60      ld   a,(unknown_6097)
0312: 3C            inc  a
0313: 32 97 60      ld   (unknown_6097),a
0316: FD 21 8F 60   ld   iy,unknown_608F
031A: 21 77 60      ld   hl,unknown_6077
031D: DD 21 98 65   ld   ix,guard_2_struct_6598
0321: 3A EC 61      ld   a,(unknown_61EC)
0324: FE 01         cp   $01
0326: 28 12         jr   z,$033A
0328: 3A 9A 60      ld   a,(guard_2_screen_609A)
032B: 32 98 60      ld   (screen_index_param_6098),a
032E: 3A 7B 60      ld   a,(guard_2_in_elevator_607B)
0331: 4F            ld   c,a
0332: 3A 7A 60      ld   a,(unknown_607A)
0335: 06 26         ld   b,$26
0337: CD 2E 0B      call $0B2E
033A: 3A 99 60      ld   a,(guard_1_screen_6099)
033D: 32 98 60      ld   (screen_index_param_6098),a
0340: 21 3B 60      ld   hl,guard_1_in_elevator_603B
0343: DD 21 94 65   ld   ix,guard_1_struct_6594
0347: CD 27 0A      call $0A27
034A: 3A 57 60      ld   a,(unknown_6057)
034D: 3C            inc  a
034E: 32 57 60      ld   (unknown_6057),a
0351: FD 21 4F 60   ld   iy,unknown_604F
0355: 21 37 60      ld   hl,unknown_6037
0358: DD 21 94 65   ld   ix,guard_1_struct_6594
035C: 3A EB 61      ld   a,(unknown_61EB)
035F: FE 01         cp   $01
0361: 28 12         jr   z,$0375
0363: 3A 99 60      ld   a,(guard_1_screen_6099)
0366: 32 98 60      ld   (screen_index_param_6098),a
0369: 3A 3B 60      ld   a,(guard_1_in_elevator_603B)
036C: 4F            ld   c,a
036D: 3A 3A 60      ld   a,(unknown_603A)
0370: 06 26         ld   b,$26
0372: CD 2E 0B      call $0B2E
0375: 3E 01         ld   a,$01
0377: 32 7F 62      ld   (unknown_627F),a
037A: CD C7 18      call $18C7
037D: 3A 00 B8      ld   a,(io_read_shit_B800)
0380: CD F9 3D      call $3DF9
0383: 3A F1 61      ld   a,(unknown_61F1)
0386: FE 00         cp   $00
0388: CC BC 0E      call z,$0EBC
038B: CD BE 39      call write_credits_and_lives_39be
038E: CD 0F 56      call write_scores_and_time_560f
0391: CD FD 39      call read_player_controls_39fd
0394: CD 66 3C      call $3C66
0397: 3A 00 B8      ld   a,(io_read_shit_B800)
039A: 3E 01         ld   a,$01
039C: 32 00 A0      ld   (interrupt_control_A000),a
039F: ED 56         im   1
03A1: F1            pop  af
03A2: 08            ex   af,af'
03A3: E1            pop  hl
03A4: D1            pop  de
03A5: C1            pop  bc
03A6: D9            exx
03A7: FD E1         pop  iy
03A9: DD E1         pop  ix
03AB: E1            pop  hl
03AC: D1            pop  de
03AD: C1            pop  bc
03AE: F1            pop  af
03AF: FB            ei
03B0: C9            ret

03B1: 3A 5E 61      ld   a,(unknown_615E)
03B4: FE 00         cp   $00
03B6: C8            ret  z
03B7: 3A 0D 60      ld   a,(player_screen_600D)
03BA: FE 01         cp   $01
03BC: 20 0D         jr   nz,$03CB
03BE: 3A 9F 65      ld   a,(unknown_659F)
03C1: FE 80         cp   $80
03C3: 38 06         jr   c,$03CB
03C5: 3A 9E 65      ld   a,(unknown_659E)
03C8: 3D            dec  a
03C9: 18 04         jr   $03CF
03CB: 3A 9E 65      ld   a,(unknown_659E)
03CE: 3C            inc  a
03CF: 32 9E 65      ld   (unknown_659E),a
03D2: DD 21 9C 65   ld   ix,unknown_659C
03D6: DD 35 03      dec  (ix+$03)
03D9: FD 21 5A 61   ld   iy,unknown_615A
03DD: 3A 0D 60      ld   a,(player_screen_600D)
03E0: 32 98 60      ld   (screen_index_param_6098),a
03E3: CD 8C 55      call compute_logical_address_from_xy_558c
03E6: 2A 5A 61      ld   hl,(unknown_615A)
03E9: DD 21 9C 65   ld   ix,unknown_659C
03ED: DD 34 03      inc  (ix+$03)
03F0: CD 0E 25      call $250E
03F3: C9            ret
03F4: 3A 59 61      ld   a,(unknown_6159)
03F7: FE 00         cp   $00
03F9: C8            ret  z
03FA: 3A 9F 65      ld   a,(unknown_659F)
03FD: 3C            inc  a
03FE: 3C            inc  a
03FF: 32 9F 65      ld   (unknown_659F),a
0402: C9            ret
0403: FD 7E 00      ld   a,(iy+$00)
0406: FE 00         cp   $00
0408: C8            ret  z
0409: 2A 54 61      ld   hl,(unknown_6154)
040C: 3A 53 61      ld   a,(unknown_6153)
040F: FE 07         cp   $07
0411: 20 11         jr   nz,$0424
0413: 7E            ld   a,(hl)
0414: FE FF         cp   $FF
0416: 28 14         jr   z,$042C
0418: DD 77 00      ld   (ix+$00),a
041B: 23            inc  hl
041C: 22 54 61      ld   (unknown_6154),hl
041F: AF            xor  a
0420: 32 53 61      ld   (unknown_6153),a
0423: C9            ret
0424: 3A 53 61      ld   a,(unknown_6153)
0427: 3C            inc  a
0428: 32 53 61      ld   (unknown_6153),a
042B: C9            ret
042C: 3E 31         ld   a,$31
042E: DD 77 00      ld   (ix+$00),a
0431: AF            xor  a
0432: FD 77 00      ld   (iy+$00),a
0435: 12            ld   (de),a
0436: C9            ret

0472: FD 21 51 61   ld   iy,unknown_6151
0476: DD 21 80 65   ld   ix,player_struct_6580
047A: 2A 54 61      ld   hl,(unknown_6154)
047D: FD 7E 00      ld   a,(iy+$00)
0480: FE 00         cp   $00
0482: C8            ret  z
0483: 3A 53 61      ld   a,(unknown_6153)
0486: FE 07         cp   $07
0488: 20 11         jr   nz,$049B
048A: 7E            ld   a,(hl)
048B: FE FF         cp   $FF
048D: 28 14         jr   z,$04A3
048F: DD 77 00      ld   (ix+$00),a
0492: 23            inc  hl
0493: 22 54 61      ld   (unknown_6154),hl
0496: AF            xor  a
0497: 32 53 61      ld   (unknown_6153),a
049A: C9            ret
049B: 3A 53 61      ld   a,(unknown_6153)
049E: 3C            inc  a
049F: 32 53 61      ld   (unknown_6153),a
04A2: C9            ret
04A3: 3E 01         ld   a,$01
04A5: 32 52 61      ld   (unknown_6152),a
04A8: C9            ret
04A9: 94            sub  h
04AA: 65            ld   h,l
04AB: 98            sbc  a,b
04AC: 65            ld   h,l

	;; in ix guard structure
	;; structure is as follows: (same struct for player)
	;; offset 0:	sprite frame gfx index (ex: 27/A7:	climbing)
	;; offset 1:	?
	;; offset 2:	x
	;; offset 3:	y

guard_ladder_movement_04AD:
04AD: FD 7E 00      ld   a,(iy+$00)
04B0: E6 10         and  $10
04B2: FE 10         cp   $10
04B4: 28 15         jr   z,$04CB
04B6: FD 7E 00      ld   a,(iy+$00)
04B9: E6 20         and  $20
04BB: FE 20         cp   $20
04BD: C0            ret  nz
	;; down
04BE: E5            push hl
04BF: 2A 44 60      ld   hl,(unknown_6044)
04C2: 7E            ld   a,(hl)
04C3: FE FF         cp   $FF
04C5: E1            pop  hl
04C6: C0            ret  nz
04C7: 06 00         ld   b,$00
04C9: 18 0C         jr   $04D7
	;; up
04CB: E5            push hl
04CC: 2A 44 60      ld   hl,(unknown_6044)
04CF: 2B            dec  hl
04D0: 7E            ld   a,(hl)
04D1: FE FF         cp   $FF
04D3: E1            pop  hl
04D4: C0            ret  nz
04D5: 06 80         ld   b,$80
04D7: 7E            ld   a,(hl)
04D8: FE 0B         cp   $0B
04DA: 20 05         jr   nz,$04E1
04DC: 3E 01         ld   a,$01
04DE: 77            ld   (hl),a
04DF: 18 02         jr   $04E3
04E1: 3C            inc  a
04E2: 77            ld   (hl),a
04E3: 7E            ld   a,(hl)

	;; move timer. 01 -> 0B for the guard climbing up/down
	;; note: difficulty/score does not affect up/down moves
04E4: FE 01         cp   $01
04E6: C8            ret  z
04E7: FE 03         cp   $03
04E9: C8            ret  z
04EA: FE 05         cp   $05
04EC: C8            ret  z
04ED: FE 08         cp   $08
04EF: C8            ret  z
04F0: FE 0A         cp   $0A
04F2: CC 23 05      call z,$0523
04F5: FE 02         cp   $02
04F7: CC 23 05      call z,$0523
04FA: FE 04         cp   $04
04FC: CC 23 05      call z,$0523
04FF: FE 07         cp   $07
0501: CC 23 05      call z,$0523
0504: FE 09         cp   $09
0506: CC 23 05      call z,$0523
0509: FE 06         cp   $06
050B: 20 09         jr   nz,$0516
050D: 3E 27         ld   a,$27
050F: DD 77 00      ld   (ix+$00),a ;  change sprite frame
0512: CD 23 05      call $0523
0515: C9            ret
0516: FE 0B         cp   $0B
0518: 20 08         jr   nz,$0522
051A: 3E A7         ld   a,$A7
051C: DD 77 00      ld   (ix+$00),a ;  change sprite frame
051F: CD 23 05      call $0523
0522: C9            ret

0523: F5            push af
0524: C5            push bc
0525: 3A F5 61      ld   a,(unknown_61F5)
0528: FE 00         cp   $00
052A: 20 14         jr   nz,$0540
052C: 3A CF 61      ld   a,(has_pick_61CF)
052F: FE 00         cp   $00
0531: 20 0D         jr   nz,$0540
0533: 3A F3 61      ld   a,(unknown_61F3)
0536: FE 00         cp   $00
0538: 20 06         jr   nz,$0540
053A: 21 15 3F      ld   hl,$3F15
053D: CD 18 20      call copy_to_61bd_2018
0540: C1            pop  bc
0541: F1            pop  af
0542: F5            push af
0543: 78            ld   a,b
0544: FE 80         cp   $80
0546: 20 14         jr   nz,$055C
0548: DD 7E 03      ld   a,(ix+$03)
054B: 3D            dec  a
054C: DD 77 03      ld   (ix+$03),a
054F: AF            xor  a
0550: FD 2A 93 60   ld   iy,(guard_struct_pointer_6093)
0554: FD 77 00      ld   (iy+$00),a
0557: CD 72 0F      call $0F72
055A: F1            pop  af
055B: C9            ret
055C: DD 7E 03      ld   a,(ix+$03)
055F: 3C            inc  a
0560: DD 77 03      ld   (ix+$03),a
0563: AF            xor  a
0564: FD 2A 93 60   ld   iy,(guard_struct_pointer_6093)
0568: FD 77 00      ld   (iy+$00),a
056B: CD 72 0F      call $0F72
056E: F1            pop  af
056F: C9            ret

	;;
	;; guard left/right movement routine
	;; no A.I. here:	 if direction = left, animates left, etc..
	;;
guard_walk_movement_0570:
	;; handle the right side
0570: FD 7E 00      ld   a,(iy+$00) ;  guard direction
0573: E6 80         and  $80
0575: FE 80         cp   $80	;  to right?
0577: 20 0F         jr   nz,$0588
	;; guard faces right
0579: E5            push hl
057A: 2A 44 60      ld   hl,(unknown_6044)
057D: CD FA 0C      call character_can_walk_right_0CFA
0580: E1            pop  hl
0581: 3A 0B 60      ld   a,(way_clear_flag_600B)
0584: FE 02         cp   $02
0586: 28 1A         jr   z,$05A2 ;  can walk right

	;; does not face right or cannot walk right. handle left side
0588: FD 7E 00      ld   a,(iy+$00)
058B: E6 40         and  $40
058D: FE 40         cp   $40	;  faces left?
058F: C0            ret  nz	; neither right or left: on ladder? quit

0590: E5            push hl
0591: 2A 44 60      ld   hl,(unknown_6044)
0594: CD 69 0D      call character_can_walk_left_0D69
0597: E1            pop  hl
0598: 3A 0B 60      ld   a,(way_clear_flag_600B)
059B: FE 02         cp   $02
059D: C0            ret  nz	;  cannot walk left:	 quit this routine
	;; walk left/animate
059E: 06 80         ld   b,$80
05A0: 28 02         jr   z,$05A4
	;; walk right/animate
05A2: 06 00         ld   b,$00
	;; animation/move counter for the guard
05A4: 7E            ld   a,(hl)
05A5: FE 0B         cp   $0B
05A7: 20 05         jr   nz,$05AE
	;; counter reaches 0B: reset to 01
05A9: 3E 01         ld   a,$01
05AB: 77            ld   (hl),a
05AC: 18 02         jr   $05B0

05AE: 3C            inc  a
05AF: 77            ld   (hl),a
05B0: 7E            ld   a,(hl)
05B1: FE 02         cp   $02
05B3: 28 2B         jr   z,guard_move_if_fast_enough_05E0
05B5: FE 05         cp   $05
05B7: 28 27         jr   z,guard_move_if_fast_enough_05E0
05B9: FE 09         cp   $09
05BB: 28 23         jr   z,guard_move_if_fast_enough_05E0
; $FF is never set and thus never used: must be a last minute change
; this is somehow confirmed by the fact that speeds 9 and 10 are strictly
; identical (same speed as player)
05BD: FE FF         cp   $FF
05BF: 28 1F         jr   z,guard_move_if_fast_enough_05E0
05C1: FE 04         cp   $04
05C3: CA E0 05      jp   z,guard_move_if_fast_enough_05E0


05C6: FE 06         cp   $06
05C8: CC 14 06      call z,guard_unconditional_move_0614
05CB: FE 08         cp   $08
05CD: CC 14 06      call z,guard_unconditional_move_0614
05D0: FE 0A         cp   $0A
05D2: CC 14 06      call z,guard_unconditional_move_0614
05D5: FE 01         cp   $01
05D7: 20 19         jr   nz,$05F2
	;; could move
05D9: 3E 31         ld   a,$31
05DB: B0            or   b
05DC: DD 77 00      ld   (ix+$00),a
05DF: C9            ret

guard_move_if_fast_enough_05E0:
05E0: F5            push af
05E1: C5            push bc
05E2: 47            ld   b,a
05E3: 3A 64 61      ld   a,(guard_speed_6164) ; 0 -> 10
05E6: B8            cp   b
05E7: 30 03         jr   nc,$05EC
	;; b > guard speed:	don't move
05E9: C1            pop  bc
05EA: F1            pop  af
05EB: C9            ret
05EC: C1            pop  bc
05ED: F1            pop  af
05EE: CD 14 06      call guard_unconditional_move_0614
05F1: C9            ret
05F2: FE 03         cp   $03
05F4: 20 07         jr   nz,$05FD
05F6: 3E 30         ld   a,$30
05F8: B0            or   b
05F9: DD 77 00      ld   (ix+$00),a
05FC: C9            ret
05FD: FE 07         cp   $07
05FF: 20 07         jr   nz,$0608
0601: 3E 2E         ld   a,$2E
0603: B0            or   b
0604: DD 77 00      ld   (ix+$00),a
0607: C9            ret
0608: FE FF         cp   $FF
060A: 20 07         jr   nz,$0613
060C: 3E 30         ld   a,$30
060E: B0            or   b
060F: DD 77 00      ld   (ix+$00),a
0612: C9            ret
0613: C9            ret

guard_unconditional_move_0614:
	;; actually move
0614: F5            push af
0615: C5            push bc
0616: 3A F5 61      ld   a,(unknown_61F5)
0619: FE 00         cp   $00
061B: 20 14         jr   nz,$0631
061D: 3A CF 61      ld   a,(has_pick_61CF)
0620: FE 00         cp   $00
0622: 20 0D         jr   nz,$0631
0624: 3A F3 61      ld   a,(unknown_61F3)
0627: FE 00         cp   $00
0629: 20 06         jr   nz,$0631
062B: 21 39 3F      ld   hl,$3F39
062E: CD 18 20      call copy_to_61bd_2018
0631: C1            pop  bc
0632: AF            xor  a
0633: FD 2A 93 60   ld   iy,(guard_struct_pointer_6093)
0637: FD 77 00      ld   (iy+$00),a
063A: 78            ld   a,b
063B: FE 80         cp   $80
063D: 28 19         jr   z,$0658
063F: DD 7E 02      ld   a,(ix+$02)
0642: 3C            inc  a
0643: DD 77 02      ld   (ix+$02),a
0646: FE F0         cp   $F0	;  F0 is the max screen X
0648: 20 0C         jr   nz,$0656
	;; set x to 1
064A: 3E 01         ld   a,$01
064C: DD 77 02      ld   (ix+$02),a
	;; increase screen index
064F: 3A 98 60      ld   a,(screen_index_param_6098)
0652: 3C            inc  a
0653: 32 98 60      ld   (screen_index_param_6098),a
0656: F1            pop  af
0657: C9            ret
0658: DD 7E 02      ld   a,(ix+$02)
065B: 3D            dec  a
065C: DD 77 02      ld   (ix+$02),a
065F: FE 01         cp   $01	;  1 is the min screen x
0661: 20 0C         jr   nz,$066F
	;; set x to $F0
0663: 3E F0         ld   a,$F0
0665: DD 77 02      ld   (ix+$02),a
	;; decrease screen index
0668: 3A 98 60      ld   a,(screen_index_param_6098)
066B: 3D            dec  a
066C: 32 98 60      ld   (screen_index_param_6098),a
066F: AF            xor  a
0670: FD 2A 93 60   ld   iy,(guard_struct_pointer_6093)
0674: FD 77 00      ld   (iy+$00),a
0677: F1            pop  af
0678: C9            ret
0679: AF            xor  a
067A: 32 1C 60      ld   (unknown_601C),a
067D: 32 1D 60      ld   (unknown_601D),a
0680: 32 1E 60      ld   (unknown_601E),a
0683: C9            ret

handle_player_walk_0684:
0684: 21 1C 60      ld   hl,unknown_601C
0687: DD 21 8A 65   ld   ix,wagon_data_658A
068B: FD 21 82 65   ld   iy,player_x_6582
068F: 11 04 00      ld   de,$0004
0692: 7E            ld   a,(hl)
0693: FE 01         cp   $01
0695: 28 0F         jr   z,$06A6
0697: 23            inc  hl
0698: DD 19         add  ix,de
069A: 7E            ld   a,(hl)
069B: FE 01         cp   $01
069D: 28 07         jr   z,$06A6
069F: 23            inc  hl
06A0: DD 19         add  ix,de
06A2: 7E            ld   a,(hl)
06A3: FE 01         cp   $01
06A5: C0            ret  nz
06A6: 3E 01         ld   a,$01
06A8: 32 30 60      ld   (unknown_6030),a
06AB: 3A 26 60      ld   a,(player_input_6026)
06AE: E6 08         and  $08
06B0: FE 08         cp   $08
06B2: CC C9 06      call z,$06C9
06B5: 3A 26 60      ld   a,(player_input_6026)
06B8: E6 10         and  $10
06BA: FE 10         cp   $10
06BC: CC CF 06      call z,$06CF
06BF: 3E 01         ld   a,$01
06C1: 32 29 60      ld   (player_in_wagon_flag_6029),a
06C4: 3D            dec  a
06C5: 32 2F 60      ld   (player_in_wagon_flag_13_602F),a
06C8: C9            ret
06C9: 3E 01         ld   a,$01
06CB: 32 2D 60      ld   (unknown_602D),a
06CE: C9            ret
06CF: 3E 01         ld   a,$01
06D1: 32 2E 60      ld   (unknown_602E),a
06D4: C9            ret
06D5: 3A 30 60      ld   a,(unknown_6030)
06D8: FE 01         cp   $01
06DA: C0            ret  nz
06DB: 3A 2D 60      ld   a,(unknown_602D)
06DE: FE 01         cp   $01
06E0: CC 10 07      call z,$0710
06E3: 3A 2E 60      ld   a,(unknown_602E)
06E6: FE 01         cp   $01
06E8: CC 20 07      call z,$0720
06EB: 3A 2F 60      ld   a,(player_in_wagon_flag_13_602F)
06EE: 3C            inc  a
06EF: FE 04         cp   $04
06F1: 28 04         jr   z,$06F7
06F3: 32 2F 60      ld   (player_in_wagon_flag_13_602F),a
06F6: C9            ret
	;;  kind of reset but called when???
06F7: AF            xor  a
06F8: 32 2D 60      ld   (unknown_602D),a
06FB: 32 2E 60      ld   (unknown_602E),a
06FE: 32 30 60      ld   (unknown_6030),a
0701: 32 29 60      ld   (player_in_wagon_flag_6029),a
0704: 32 25 60      ld   (player_death_flag_6025),a
0707: CD 79 06      call $0679
070A: 3E 20         ld   a,$20
070C: 32 80 65      ld   (player_struct_6580),a
070F: C9            ret
0710: CD 30 07      call $0730
0713: CD 70 07      call $0770
0716: FD 7E 00      ld   a,(iy+$00)
0719: 3D            dec  a
071A: 3D            dec  a
071B: 3D            dec  a
071C: FD 77 00      ld   (iy+$00),a
071F: C9            ret
0720: CD 30 07      call $0730
0723: CD 53 07      call $0753
0726: FD 7E 00      ld   a,(iy+$00)
0729: 3C            inc  a
072A: 3C            inc  a
072B: 3C            inc  a
072C: FD 77 00      ld   (iy+$00),a
072F: C9            ret
0730: 11 4F 07      ld   de,$074F
0733: 3A 2F 60      ld   a,(player_in_wagon_flag_13_602F)
0736: FE 04         cp   $04
0738: C8            ret  z
0739: 83            add  a,e
073A: 5F            ld   e,a
073B: 7A            ld   a,d
073C: CE 00         adc  a,$00
073E: 57            ld   d,a
073F: 1A            ld   a,(de)
0740: 47            ld   b,a
0741: 3A 80 65      ld   a,(player_struct_6580)
0744: E6 08         and  $08
0746: B0            or   b
0747: 32 80 65      ld   (player_struct_6580),a
074A: AF            xor  a
074B: 32 25 60      ld   (player_death_flag_6025),a
074E: C9            ret
074F: 1D            dec  e
0750: 1D            dec  e
0751: 1D            dec  e
0752: 1D            dec  e
0753: 06 20         ld   b,$20
0755: C5            push bc
0756: 2A 09 60      ld   hl,(player_logical_address_6009)
0759: CD FA 0C      call character_can_walk_right_0CFA
075C: 3A 0B 60      ld   a,(way_clear_flag_600B)
075F: FE 02         cp   $02
0761: 20 02         jr   nz,$0765
0763: C1            pop  bc
0764: C9            ret
0765: 3E 01         ld   a,$01
0767: 32 25 60      ld   (player_death_flag_6025),a
076A: 3D            dec  a
076B: 32 29 60      ld   (player_in_wagon_flag_6029),a
076E: C1            pop  bc
076F: C9            ret
0770: 06 20         ld   b,$20
0772: C5            push bc
0773: 2A 09 60      ld   hl,(player_logical_address_6009)
0776: CD 69 0D      call character_can_walk_left_0D69
0779: 3A 0B 60      ld   a,(way_clear_flag_600B)
077C: FE 02         cp   $02
077E: 20 E5         jr   nz,$0765
0780: C1            pop  bc
0781: 10 EF         djnz $0772
0783: C9            ret

player_grip_handle_test_0784:
0784: CD 5E 55      call update_player_screen_address_from_xy_555E
0787: 2A 09 60      ld   hl,(player_logical_address_6009)
078A: 2B            dec  hl
078B: 2B            dec  hl
078C: 2B            dec  hl
078D: 7E            ld   a,(hl)	; check what's above player head on screen
078E: FE DC         cp   $DC
0790: 28 03         jr   z,$0795
0792: FE 0B         cp   $0B
0794: C0            ret  nz
	;; handle detected ($DC or $OB)
0795: 3A 2A 60      ld   a,(player_gripping_handle_602A)
0798: FE 01         cp   $01
079A: C8            ret  z
079B: 3E 01         ld   a,$01
079D: 21 1E 60      ld   hl,unknown_601E
07A0: 01 03 00      ld   bc,$0003
07A3: ED B9         cpdr
07A5: C8            ret  z
07A6: 3A 26 60      ld   a,(player_input_6026)
07A9: E6 80         and  $80
07AB: FE 80         cp   $80
07AD: C0            ret  nz
	;; "fire" pressed while below the handle
07AE: 3A 54 60      ld   a,(gameplay_allowed_6054)
07B1: FE 00         cp   $00
07B3: 28 08         jr   z,player_grips_handle_07BD
07B5: 3A 50 60      ld   a,(player_move_direction_6050)
07B8: E6 80         and  $80
07BA: FE 80         cp   $80
07BC: C8            ret  z
player_grips_handle_07BD:
07BD: 3E 01         ld   a,$01
07BF: 32 28 60      ld   (player_controls_frozen_6028),a
07C2: 32 2A 60      ld   (player_gripping_handle_602A),a
07C5: 3D            dec  a
07C6: 32 2B 60      ld   (unknown_602B),a
07C9: 3E 01         ld   a,$01
07CB: 32 75 62      ld   (unknown_6275),a
07CE: 21 FD 3E      ld   hl,$3EFD
07D1: CD 18 20      call copy_to_61bd_2018
07D4: C9            ret
07D5: 3A 2A 60      ld   a,(player_gripping_handle_602A)
07D8: FE 01         cp   $01
07DA: C0            ret  nz
07DB: 11 F6 07      ld   de,l_07F6
07DE: 3A 2B 60      ld   a,(unknown_602B)
07E1: FE 05         cp   $05
07E3: C8            ret  z
07E4: 83            add  a,e
07E5: 5F            ld   e,a
07E6: 7A            ld   a,d
07E7: CE 00         adc  a,$00
07E9: 57            ld   d,a
07EA: 1A            ld   a,(de)
07EB: 32 80 65      ld   (player_struct_6580),a
07EE: 3A 2B 60      ld   a,(unknown_602B)
07F1: 3C            inc  a
07F2: 32 2B 60      ld   (unknown_602B),a
07F5: C9            ret
l_07F6:
	.byte	0x1C
	.byte	0x1C
	.byte	0x1C
	.byte	0x1C
	.byte	0x1B

07FB: 3A 2A 60      ld   a,(player_gripping_handle_602A)
07FE: FE 01         cp   $01
0800: C0            ret  nz
0801: 3A 26 60      ld   a,(player_input_6026)
0804: E6 80         and  $80
0806: FE 80         cp   $80
0808: C0            ret  nz
0809: 3A 54 60      ld   a,(gameplay_allowed_6054)
080C: FE 00         cp   $00
080E: 28 08         jr   z,$0818
0810: 3A 50 60      ld   a,(player_move_direction_6050)
0813: E6 80         and  $80
0815: FE 80         cp   $80
0817: C8            ret  z
0818: AF            xor  a
0819: 32 2A 60      ld   (player_gripping_handle_602A),a
081C: 32 28 60      ld   (player_controls_frozen_6028),a
081F: 32 29 60      ld   (player_in_wagon_flag_6029),a
0822: 32 2B 60      ld   (unknown_602B),a
0825: 3E 19         ld   a,$19
0827: 32 80 65      ld   (player_struct_6580),a
082A: 3E 01         ld   a,$01
082C: 32 2C 60      ld   (unknown_602C),a
082F: C9            ret
0830: 3A 2A 60      ld   a,(player_gripping_handle_602A)
0833: FE 01         cp   $01
0835: C8            ret  z
0836: 3A 25 60      ld   a,(player_death_flag_6025)
0839: FE 01         cp   $01
083B: C8            ret  z
083C: 3A 83 65      ld   a,(player_y_6583)
083F: 3C            inc  a
0840: DD 21 8A 65   ld   ix,wagon_data_658A
0844: FD 21 1C 60   ld   iy,unknown_601C
0848: 11 04 00      ld   de,$0004
084B: CD 5D 08      call $085D
084E: DD 19         add  ix,de
0850: FD 23         inc  iy
0852: CD 5D 08      call $085D
0855: DD 19         add  ix,de
0857: FD 23         inc  iy
0859: CD 5D 08      call $085D
085C: C9            ret
085D: DD BE 01      cp   (ix+$01)
0860: 20 47         jr   nz,$08A9
0862: F5            push af
0863: 06 08         ld   b,$08
0865: 3A 82 65      ld   a,(player_x_6582)
0868: D6 05         sub  $05
086A: 3C            inc  a
086B: F5            push af
086C: DD BE 00      cp   (ix+$00)
086F: 28 2F         jr   z,$08A0
0871: F1            pop  af
0872: 10 F6         djnz $086A
0874: 18 2D         jr   $08A3
0876: FD 7E 00      ld   a,(iy+$00)
0879: FE 00         cp   $00
087B: 20 17         jr   nz,$0894
087D: E5            push hl
087E: DD E5         push ix
0880: 21 00 01      ld   hl,$0100
0883: CD 90 5C      call add_to_score_5C90
0886: 21 03 3F      ld   hl,$3F03
0889: CD 18 20      call copy_to_61bd_2018
088C: 3E 01         ld   a,$01
088E: 32 75 62      ld   (unknown_6275),a
0891: DD E1         pop  ix
0893: E1            pop  hl
0894: 3E 01         ld   a,$01
0896: FD 77 00      ld   (iy+$00),a
0899: 3E 1A         ld   a,$1A
089B: 32 80 65      ld   (player_struct_6580),a
089E: F1            pop  af
089F: C9            ret
08A0: F1            pop  af
08A1: 18 D3         jr   $0876
08A3: AF            xor  a
08A4: FD 77 00      ld   (iy+$00),a
08A7: F1            pop  af
08A8: C9            ret
08A9: F5            push af
08AA: AF            xor  a
08AB: FD 77 00      ld   (iy+$00),a
08AE: F1            pop  af
08AF: C9            ret
	;; wagon start y values
compute_wagon_start_values_08b0:
08B0: DD 21 19 60   ld   ix,unknown_6019
08B4: FD 21 8B 65   ld   iy,unknown_658B
08B8: 3E E1         ld   a,$E1
08BA: 08            ex   af,af'
08BB: CD DF 08      call $08DF
08BE: DD 23         inc  ix
08C0: FD 23         inc  iy
08C2: FD 23         inc  iy
08C4: FD 23         inc  iy
08C6: FD 23         inc  iy
08C8: 3E 41         ld   a,$41
08CA: 08            ex   af,af'
08CB: CD DF 08      call $08DF
08CE: DD 23         inc  ix
08D0: FD 23         inc  iy
08D2: FD 23         inc  iy
08D4: FD 23         inc  iy
08D6: FD 23         inc  iy
08D8: 3E C9         ld   a,$C9
08DA: 08            ex   af,af'
08DB: CD DF 08      call $08DF
08DE: C9            ret
08DF: 3A 0D 60      ld   a,(player_screen_600D)
08E2: 3D            dec  a
08E3: DD BE 00      cp   (ix+$00)
08E6: C2 EE 08      jp   nz,$08EE
08E9: 08            ex   af,af'
08EA: FD 77 00      ld   (iy+$00),a
08ED: C9            ret
	;; not in current player screen: set coords to 255
08EE: 3E FF         ld   a,$FF
08F0: FD 77 00      ld   (iy+$00),a
08F3: C9            ret
	;; move wagons
08F4: DD 21 16 60   ld   ix,unknown_6016
08F8: FD 21 94 09   ld   iy,$0994
08FC: 21 8A 65      ld   hl,wagon_data_658A
08FF: CD 25 09      call $0925
0902: DD 23         inc  ix
0904: FD 23         inc  iy
0906: FD 23         inc  iy
0908: FD 23         inc  iy
090A: FD 23         inc  iy
090C: 23            inc  hl
090D: 23            inc  hl
090E: 23            inc  hl
090F: 23            inc  hl
0910: CD 25 09      call $0925
0913: DD 23         inc  ix
0915: FD 23         inc  iy
0917: FD 23         inc  iy
0919: FD 23         inc  iy
091B: FD 23         inc  iy
091D: 23            inc  hl
091E: 23            inc  hl
091F: 23            inc  hl
0920: 23            inc  hl
0921: CD 25 09      call $0925
0924: C9            ret
0925: DD 7E 00      ld   a,(ix+$00)
0928: FE 00         cp   $00
092A: C2 61 09      jp   nz,$0961
092D: 7E            ld   a,(hl)
092E: 3D            dec  a
092F: 77            ld   (hl),a
0930: F5            push af
0931: DD 7E 06      ld   a,(ix+$06)
0934: FE 00         cp   $00
0936: 28 07         jr   z,$093F
0938: 3A 82 65      ld   a,(player_x_6582)
093B: 3D            dec  a
093C: 32 82 65      ld   (player_x_6582),a
093F: F1            pop  af
0940: FD BE 02      cp   (iy+$02)
0943: CA 4C 09      jp   z,$094C
0946: FE 00         cp   $00
0948: CA 59 09      jp   z,$0959
094B: C9            ret
094C: DD 7E 03      ld   a,(ix+$03)
094F: FD BE 03      cp   (iy+$03)
0952: C0            ret  nz
0953: 3E 01         ld   a,$01
0955: DD 77 00      ld   (ix+$00),a
0958: C9            ret
0959: DD 7E 03      ld   a,(ix+$03)
095C: 3D            dec  a
095D: DD 77 03      ld   (ix+$03),a
0960: C9            ret
0961: 7E            ld   a,(hl)
0962: 3C            inc  a
0963: 77            ld   (hl),a
0964: F5            push af
0965: DD 7E 06      ld   a,(ix+$06)
0968: FE 00         cp   $00
096A: 28 07         jr   z,$0973
096C: 3A 82 65      ld   a,(player_x_6582)
096F: 3C            inc  a
0970: 32 82 65      ld   (player_x_6582),a
0973: F1            pop  af
0974: FD BE 00      cp   (iy+$00)
0977: CA 7F 09      jp   z,$097F
097A: FE FF         cp   $FF
097C: 28 0E         jr   z,$098C
097E: C9            ret
097F: DD 7E 03      ld   a,(ix+$03)
0982: FD BE 01      cp   (iy+$01)
0985: C0            ret  nz
0986: 3E 00         ld   a,$00
0988: DD 77 00      ld   (ix+$00),a
098B: C9            ret
098C: DD 7E 03      ld   a,(ix+$03)
098F: 3C            inc  a
0990: DD 77 03      ld   (ix+$03),a
0993: C9            ret


09A0: 3A 12 60		ld   a,($6012)                                      
09A3: FE 00         cp   $00
09A5: C8            ret  z
09A6: 3A 11 60      ld   a,(elevator_timer_current_screen_6011)
09A9: 3C            inc  a
09AA: 32 11 60      ld   (elevator_timer_current_screen_6011),a
09AD: FE 5F         cp   $5F	;  < $5F:	 don't move the elevator
09AF: C0            ret  nz
	;; move the elevator
09B0: AF            xor  a
09B1: 32 11 60      ld   (elevator_timer_current_screen_6011),a
09B4: 32 12 60      ld   (elevator_not_moving_6012),a
09B7: 3C            inc  a
09B8: 32 15 60      ld   (unknown_6015),a
09BB: 3A 0D 60      ld   a,(player_screen_600D)
09BE: FE 02         cp   $02
09C0: 28 06         jr   z,$09C8
09C2: FD 21 E8 09   ld   iy,$09E8
09C6: 18 04         jr   $09CC
09C8: FD 21 DF 09   ld   iy,$09DF
09CC: 06 09         ld   b,$09
09CE: DD 7E 02      ld   a,(ix+$02)
09D1: FD BE 00      cp   (iy+$00)
09D4: 28 1B         jr   z,$09F1
09D6: FD 23         inc  iy
09D8: 10 F4         djnz $09CE
09DA: AF            xor  a
09DB: 77            ld   (hl),a
09DC: 2B            dec  hl
09DD: 77            ld   (hl),a
09DE: C9            ret

	;; player entering in the elevator
09F1: 3A 87 65      ld   a,(elevator_y_current_screen_6587)
09F4: D6 00         sub  $00
09F6: DD BE 03      cp   (ix+$03)
09F9: 28 0E         jr   z,$0A09
09FB: D6 01         sub  $01
09FD: DD BE 03      cp   (ix+$03)
0A00: 28 07         jr   z,$0A09
0A02: C6 02         add  a,$02
0A04: DD BE 03      cp   (ix+$03)
0A07: 20 D1         jr   nz,$09DA
0A09: 3A 98 60      ld   a,(screen_index_param_6098)
0A0C: FE 01         cp   $01
0A0E: 28 CA         jr   z,$09DA
0A10: 3A 4E 60      ld   a,(fatal_fall_height_reached_604E)
0A13: FE 00         cp   $00
0A15: 28 0A         jr   z,$0A21
0A17: 7D            ld   a,l
0A18: FE 14         cp   $14
0A1A: 20 05         jr   nz,$0A21
0A1C: 3E 01         ld   a,$01
0A1E: 32 25 60      ld   (player_death_flag_6025),a
0A21: 3E 01         ld   a,$01
0A23: 77            ld   (hl),a
0A24: 2B            dec  hl
0A25: 77            ld   (hl),a
0A26: C9            ret

0A27: 3A 98 60      ld   a,(screen_index_param_6098)
0A2A: FE 02         cp   $02
0A2C: 20 06         jr   nz,$0A34
0A2E: FD 21 42 0A   ld   iy,$0A42
0A32: 18 04         jr   $0A38
0A34: FD 21 54 0A   ld   iy,$0A54
0A38: 06 12         ld   b,$12
0A3A: 7E            ld   a,(hl)
0A3B: F5            push af
0A3C: CD CE 09      call $09CE
0A3F: F1            pop  af
0A40: 77            ld   (hl),a
0A41: C9            ret

handle_elevators_0a66:
0A66: 3A 12 60      ld   a,(elevator_not_moving_6012)                                      
0A69: FE 00         cp   $00                                            
0A6B: C0            ret  nz
0A6C: 21 87 65      ld   hl,elevator_y_current_screen_6587
0A6F: 3A 10 60      ld   a,(elevator_dir_current_screen_6010)
0A72: FE 01         cp   $01
0A74: 20 71         jr   nz,$0AE7
0A76: 7E            ld   a,(hl)
0A77: FE 12         cp   $12
0A79: 38 62         jr   c,$0ADD
0A7B: 3A 15 60      ld   a,(unknown_6015)
0A7E: FE 01         cp   $01
0A80: CA AE 0A      jp   z,$0AAE
0A83: 3A 0D 60      ld   a,(player_screen_600D)
0A86: FE 03         cp   $03
0A88: CA 99 0A      jp   z,$0A99
0A8B: 7E            ld   a,(hl)
	;; screen 2:	2 stops besides max and min
0A8C: FE 42         cp   $42
0A8E: CA 28 0B      jp   z,$0B28
0A91: FE 6A         cp   $6A
0A93: CA 28 0B      jp   z,$0B28
0A96: C3 AE 0A      jp   $0AAE
	;; screen 3:	4 stops besides max and min
0A99: 7E            ld   a,(hl)
0A9A: FE AA         cp   $AA
0A9C: CA 28 0B      jp   z,$0B28
0A9F: FE 8A         cp   $8A
0AA1: CA 28 0B      jp   z,$0B28
0AA4: FE 72         cp   $72
0AA6: CA 28 0B      jp   z,$0B28
0AA9: FE 2A         cp   $2A
0AAB: CA 28 0B      jp   z,$0B28
0AAE: 35            dec  (hl)
0AAF: AF            xor  a
0AB0: 32 15 60      ld   (unknown_6015),a
0AB3: FD 7E 00      ld   a,(iy+$00)
0AB6: FE 01         cp   $01
0AB8: 20 07         jr   nz,$0AC1
0ABA: DD 7E 03      ld   a,(ix+$03)
0ABD: 3D            dec  a
0ABE: DD 77 03      ld   (ix+$03),a
0AC1: FD 7E 27      ld   a,(iy+$27)
0AC4: FE 01         cp   $01
0AC6: 20 07         jr   nz,$0ACF
0AC8: DD 7E 17      ld   a,(ix+$17)
0ACB: 3D            dec  a
0ACC: DD 77 17      ld   (ix+$17),a
0ACF: FD 7E 67      ld   a,(iy+$67)
0AD2: FE 01         cp   $01
0AD4: C0            ret  nz
0AD5: DD 7E 1B      ld   a,(ix+$1b)
0AD8: 3D            dec  a
0AD9: DD 77 1B      ld   (ix+$1b),a
0ADC: C9            ret
0ADD: 3E 00         ld   a,$00
0ADF: 32 10 60      ld   (elevator_dir_current_screen_6010),a
0AE2: 3C            inc  a
0AE3: 32 12 60      ld   (elevator_not_moving_6012),a
0AE6: C9            ret
0AE7: 3A 0D 60      ld   a,(player_screen_600D)
0AEA: FE 03         cp   $03
0AEC: 28 05         jr   z,$0AF3
0AEE: 7E            ld   a,(hl)
0AEF: FE 89         cp   $89
0AF1: 18 03         jr   $0AF6
0AF3: 7E            ld   a,(hl)
0AF4: FE C9         cp   $C9	;  max y for elevator of screen 3
0AF6: 30 2B         jr   nc,$0B23
0AF8: 34            inc  (hl)
0AF9: FD 7E 00      ld   a,(iy+$00)
0AFC: FE 01         cp   $01
0AFE: 20 07         jr   nz,$0B07
0B00: DD 7E 03      ld   a,(ix+$03)
0B03: 3C            inc  a
0B04: DD 77 03      ld   (ix+$03),a
0B07: FD 7E 27      ld   a,(iy+$27)
0B0A: FE 01         cp   $01
0B0C: 20 07         jr   nz,$0B15
0B0E: DD 7E 17      ld   a,(ix+$17)
0B11: 3C            inc  a
0B12: DD 77 17      ld   (ix+$17),a
0B15: FD 7E 67      ld   a,(iy+$67)
0B18: FE 01         cp   $01
0B1A: C0            ret  nz
0B1B: DD 7E 1B      ld   a,(ix+$1b)
0B1E: 3C            inc  a
0B1F: DD 77 1B      ld   (ix+$1b),a
0B22: C9            ret
0B23: 3E 01         ld   a,$01
0B25: 32 10 60      ld   (elevator_dir_current_screen_6010),a
0B28: 3E 01         ld   a,$01
0B2A: 32 12 60      ld   (elevator_not_moving_6012),a
0B2D: C9            ret
0B2E: FE 01         cp   $01
0B30: 28 2D         jr   z,$0B5F
0B32: 7E            ld   a,(hl)
0B33: FE 00         cp   $00
0B35: 28 28         jr   z,$0B5F
0B37: 79            ld   a,c
0B38: FE 00         cp   $00
0B3A: C0            ret  nz
0B3B: 78            ld   a,b
0B3C: DD 77 00      ld   (ix+$00),a
0B3F: DD 34 03      inc  (ix+$03)
0B42: FD 34 00      inc  (iy+$00)
0B45: 3A F5 61      ld   a,(unknown_61F5)
0B48: FE 00         cp   $00
0B4A: C0            ret  nz
0B4B: 3E 0D         ld   a,$0D
0B4D: 47            ld   b,a
0B4E: 3A 98 60      ld   a,(screen_index_param_6098)
0B51: B8            cp   b
0B52: C0            ret  nz
0B53: 3E 01         ld   a,$01
0B55: 32 F5 61      ld   (unknown_61F5),a
0B58: 21 45 3F      ld   hl,$3F45
0B5B: CD 18 20      call copy_to_61bd_2018
0B5E: C9            ret
0B5F: AF            xor  a
0B60: FD 77 00      ld   (iy+$00),a
0B63: C9            ret
cant_walk_in_current_direction_0b64:
0B64: F1            pop  af
0B65: AF            xor  a
0B66: 32 9B 60      ld   (unknown_609B),a
0B69: FD 77 00      ld   (iy+$00),a
0B6C: C9            ret

player_movement_0B6D:
0B6D: 3A 25 60      ld   a,(player_death_flag_6025)
0B70: FE 01         cp   $01
0B72: C8            ret  z	;  dead:	 out of there
0B73: 3A 28 60      ld   a,(player_controls_frozen_6028) ;  gripping handle or other case where cannot move: out of here
0B76: FE 01         cp   $01
0B78: CA 65 0B      jp   z,$0B65
0B7B: 3A 26 60      ld   a,(player_input_6026)
0B7E: E6 10         and  $10	;  right?
0B80: FE 10         cp   $10
0B82: 20 0D         jr   nz,$0B91
	;; try to move right
0B84: 2A 09 60      ld   hl,(player_logical_address_6009)
0B87: CD FA 0C      call character_can_walk_right_0CFA
0B8A: 3A 0B 60      ld   a,(way_clear_flag_600B)
0B8D: FE 02         cp   $02
0B8F: 28 1C         jr   z,$0BAD
0B91: 3A 26 60      ld   a,(player_input_6026)
0B94: E6 08         and  $08
0B96: FE 08         cp   $08	; left
0B98: C2 65 0B      jp   nz,$0B65
	;; try to move left
0B9B: 2A 09 60      ld   hl,(player_logical_address_6009)
0B9E: CD 69 0D      call character_can_walk_left_0D69
0BA1: 3A 0B 60      ld   a,(way_clear_flag_600B)
0BA4: FE 02         cp   $02
0BA6: C2 65 0B      jp   nz,$0B65
0BA9: 06 80         ld   b,$80
0BAB: 28 02         jr   z,$0BAF
0BAD: 06 00         ld   b,$00
0BAF: 3A 06 60      ld   a,(player_animation_frame_6006)
0BB2: FE 0B         cp   $0B
0BB4: 20 1A         jr   nz,animate_player_1_frame_0bd0
0BB6: 3E 01         ld   a,$01
0BB8: 32 06 60      ld   (player_animation_frame_6006),a
0BBB: C5            push bc
0BBC: CD FD 0F      call $0FFD
0BBF: E5            push hl
0BC0: DD E5         push ix
0BC2: D5            push de
0BC3: 21 10 00      ld   hl,$0010
0BC6: CD 90 5C      call add_to_score_5C90
0BC9: D1            pop  de
0BCA: DD E1         pop  ix
0BCC: E1            pop  hl
0BCD: C1            pop  bc
0BCE: 18 14         jr   $0BE4

animate_player_1_frame_0bd0:
0BD0: 3C            inc  a
0BD1: F5            push af
0BD2: 3A 58 61      ld   a,(has_bag_6158)
0BD5: FE 00         cp   $00
0BD7: 28 07         jr   z,$0BE0
0BD9: CD D9 0C      call $0CD9
0BDC: FE 00         cp   $00

0BDE: 28 39         jr   z,$0C19 ; skip animation because player has bag
0BE0: F1            pop  af
0BE1: 32 06 60      ld   (player_animation_frame_6006),a
0BE4: 3A 06 60      ld   a,(player_animation_frame_6006)
0BE7: 21 80 65      ld   hl,player_struct_6580
0BEA: FE 02         cp   $02
0BEC: CC 36 0C      call z,player_tries_to_move_laterally_0c36
0BEF: FE 05         cp   $05
0BF1: CC 36 0C      call z,player_tries_to_move_laterally_0c36
0BF4: FE 09         cp   $09
0BF6: CC 36 0C      call z,player_tries_to_move_laterally_0c36
0BF9: FE FF         cp   $FF
0BFB: C8            ret  z
0BFC: FE 04         cp   $04
0BFE: CC 36 0C      call z,player_tries_to_move_laterally_0c36
0C01: FE 06         cp   $06
0C03: CC 36 0C      call z,player_tries_to_move_laterally_0c36
0C06: FE 08         cp   $08
0C08: CC 36 0C      call z,player_tries_to_move_laterally_0c36
0C0B: FE 0A         cp   $0A
0C0D: CC 36 0C      call z,player_tries_to_move_laterally_0c36
0C10: FE 01         cp   $01
0C12: 20 07         jr   nz,$0C1B
0C14: 3E 20         ld   a,$20	;  player sprite index
0C16: B0            or   b
0C17: 77            ld   (hl),a
0C18: C9            ret

0C19: F1            pop  af
0C1A: C9            ret

	;; player lateral move

0C1B: FE 03         cp   $03
0C1D: 20 05         jr   nz,$0C24
0C1F: 3E 1F         ld   a,$1F
0C21: B0            or   b
0C22: 77            ld   (hl),a
0C23: C9            ret
0C24: FE 07         cp   $07
0C26: 20 05         jr   nz,$0C2D
0C28: 3E 1E         ld   a,$1E
0C2A: B0            or   b
0C2B: 77            ld   (hl),a
0C2C: C9            ret
0C2D: FE FF         cp   $FF
0C2F: 20 04         jr   nz,$0C35
0C31: 3E 80         ld   a,$80
0C33: 77            ld   (hl),a
0C34: C9            ret
0C35: C9            ret

player_tries_to_move_laterally_0c36:
0C36: F5            push af
0C37: 78            ld   a,b
0C38: FE 80         cp   $80
0C3A: 28 5A         jr   z,$0C96
0C3C: 2A 09 60      ld   hl,(player_logical_address_6009)
0C3F: CD FA 0C      call character_can_walk_right_0CFA
0C42: 3A 0B 60      ld   a,(way_clear_flag_600B)
0C45: FE 02         cp   $02
0C47: C2 64 0B      jp   nz,cant_walk_in_current_direction_0b64
0C4A: 3A 82 65      ld   a,(player_x_6582)
0C4D: 3C            inc  a
0C4E: 32 82 65      ld   (player_x_6582),a
0C51: 3A F3 61      ld   a,(unknown_61F3)
0C54: FE 00         cp   $00
0C56: 20 1A         jr   nz,$0C72
0C58: CD 7C 0C      call $0C7C
0C5B: 3A F3 61      ld   a,(unknown_61F3)
0C5E: FE 00         cp   $00
0C60: 20 10         jr   nz,$0C72
0C62: CD 89 0C      call $0C89
0C65: 3A F3 61      ld   a,(unknown_61F3)
0C68: FE 00         cp   $00
0C6A: 20 06         jr   nz,$0C72
0C6C: 21 33 3F      ld   hl,$3F33
0C6F: CD 18 20      call copy_to_61bd_2018
0C72: 3E 01         ld   a,$01
0C74: FD 77 00      ld   (iy+$00),a
0C77: 32 9B 60      ld   (unknown_609B),a
0C7A: F1            pop  af
0C7B: C9            ret
0C7C: 3A CF 61      ld   a,(has_pick_61CF)
0C7F: FE 00         cp   $00
0C81: C8            ret  z
0C82: 21 2D 3F      ld   hl,$3F2D
0C85: CD 18 20      call copy_to_61bd_2018
0C88: C9            ret
0C89: 3A C7 61      ld   a,(holds_barrow_61C7)
0C8C: FE 00         cp   $00
0C8E: C9            ret
0C8F: 21 3F 3F      ld   hl,$3F3F
0C92: CD 18 20      call copy_to_61bd_2018
0C95: C9            ret
0C96: 2A 09 60      ld   hl,(player_logical_address_6009)
0C99: CD 69 0D      call character_can_walk_left_0D69
0C9C: 3A 0B 60      ld   a,(way_clear_flag_600B)
0C9F: FE 02         cp   $02
0CA1: C2 64 0B      jp   nz,cant_walk_in_current_direction_0b64
0CA4: 3A 82 65      ld   a,(player_x_6582)
0CA7: 3D            dec  a
0CA8: 32 82 65      ld   (player_x_6582),a
0CAB: CD 17 25      call handle_player_destroying_wall_2517
0CAE: 3A F3 61      ld   a,(unknown_61F3)
0CB1: FE 00         cp   $00
0CB3: 20 1A         jr   nz,$0CCF
0CB5: CD 7C 0C      call $0C7C
0CB8: 3A F3 61      ld   a,(unknown_61F3)
0CBB: FE 00         cp   $00
0CBD: 20 10         jr   nz,$0CCF
0CBF: CD 89 0C      call $0C89
0CC2: 3A F3 61      ld   a,(unknown_61F3)
0CC5: FE 00         cp   $00
0CC7: 20 06         jr   nz,$0CCF
0CC9: 21 33 3F      ld   hl,$3F33
0CCC: CD 18 20      call copy_to_61bd_2018
0CCF: 3E 01         ld   a,$01
0CD1: FD 77 00      ld   (iy+$00),a
0CD4: 32 9B 60      ld   (unknown_609B),a
0CD7: F1            pop  af
0CD8: C9            ret

0CD9: C5            push bc
0CDA: 06 02         ld   b,$02
0CDC: 3A 7C 62      ld   a,(player_has_blue_bag_flag_627C)
0CDF: FE 00         cp   $00
0CE1: 28 02         jr   z,$0CE5
	;; player has blue bag
	;; toggle 615F value (related to player speed)
0CE3: 06 01         ld   b,$01
0CE5: 3A 5F 61      ld   a,(unknown_615F)
0CE8: B8            cp   b
0CE9: C1            pop  bc
0CEA: 38 07         jr   c,$0CF3
0CEC: AF            xor  a
0CED: 32 5F 61      ld   (unknown_615F),a
0CF0: 3E 00         ld   a,$00
0CF2: C9            ret
0CF3: 3C            inc  a
0CF4: 32 5F 61      ld   (unknown_615F),a
0CF7: 3E 01         ld   a,$01
0CF9: C9            ret

	;; character_can_walk_left_CFA
0CFA: 3A ED 61      ld   a,(check_scenery_disabled_61ED)
0CFD: FE 01         cp   $01
0CFF: 20 06         jr   nz,$0D07
0D01: 3E 02         ld   a,$02
0D03: 32 0B 60      ld   (way_clear_flag_600B),a
0D06: C9            ret

0D07: 3A F2 61      ld   a,(unknown_61F2)
0D0A: FE 01         cp   $01
0D0C: 28 F3         jr   z,$0D01
0D0E: CD 85 25      call check_breakable_wall_2585
0D11: 3A 0B 60      ld   a,(way_clear_flag_600B)
0D14: FE 02         cp   $02
0D16: C8            ret  z

0D17: 7D            ld   a,l
0D18: D6 21         sub  $21
0D1A: 6F            ld   l,a
0D1B: 7C            ld   a,h
0D1C: DE 00         sbc  a,$00
0D1E: 67            ld   h,a
0D1F: 7E            ld   a,(hl)
0D20: CD A2 0D      call check_against_space_tiles_0da2
0D23: 3A 0B 60      ld   a,(way_clear_flag_600B)
0D26: FE 02         cp   $02
0D28: C0            ret  nz
0D29: 2B            dec  hl
0D2A: 7E            ld   a,(hl)
0D2B: CD A2 0D      call check_against_space_tiles_0da2
0D2E: 23            inc  hl
0D2F: 23            inc  hl
0D30: CD 34 0D      call check_edge_tiles_0d34
0D33: C9            ret

check_edge_tiles_0d34:
0D34: 7E            ld   a,(hl)
0D35: E5            push hl
0D36: C5            push bc
0D37: 01 0D 00      ld   bc,$000D
; check edges tiles
0D3A: 21 45 0D      ld   hl,$0D45
0D3D: ED B1         cpir
0D3F: C1            pop  bc
0D40: E1            pop  hl
0D41: CA 52 0D      jp   z,$0D52
0D44: C9            ret


0D52: DD E5         push ix
0D54: CD 40 26      call $2640
0D57: DD E1         pop  ix
0D59: 78            ld   a,b
0D5A: FE 05         cp   $05
0D5C: D8            ret  c
0D5D: 3E 01         ld   a,$01
0D5F: 32 0B 60      ld   (way_clear_flag_600B),a
0D62: C9            ret
0D63: 3E 01         ld   a,$01
0D65: 32 0B 60      ld   (way_clear_flag_600B),a
0D68: C9            ret

character_can_walk_left_0D69:
0D69: 3A ED 61      ld   a,(check_scenery_disabled_61ED)
0D6C: FE 01         cp   $01
0D6E: 20 06         jr   nz,$0D76
0D70: 3E 02         ld   a,$02
0D72: 32 0B 60      ld   (way_clear_flag_600B),a
0D75: C9            ret
0D76: CD 69 25      call $2569
0D79: 3A 0B 60      ld   a,(way_clear_flag_600B)
0D7C: FE 02         cp   $02
0D7E: C8            ret  z
0D7F: 7D            ld   a,l
0D80: C6 1F         add  a,$1F
0D82: 6F            ld   l,a
0D83: 7C            ld   a,h
0D84: CE 00         adc  a,$00
0D86: 67            ld   h,a
0D87: 7E            ld   a,(hl)
0D88: CD A2 0D      call check_against_space_tiles_0da2
0D8B: 3A 0B 60      ld   a,(way_clear_flag_600B)
0D8E: FE 02         cp   $02
0D90: C0            ret  nz
0D91: 2B            dec  hl
0D92: 7E            ld   a,(hl)
0D93: CD A2 0D      call check_against_space_tiles_0da2
0D96: 23            inc  hl
0D97: 23            inc  hl
0D98: CD 34 0D      call check_edge_tiles_0d34
0D9B: C9            ret
0D9C: 3E 02         ld   a,$02
0D9E: 32 0B 60      ld   (way_clear_flag_600B),a
0DA1: C9            ret
check_against_space_tiles_0da2:
0DA2: 4F            ld   c,a
0DA3: 11 B1 0D      ld   de,$0DB1
0DA6: 06 16         ld   b,$16
0DA8: 1A            ld   a,(de)
0DA9: B9            cp   c
0DAA: 28 F0         jr   z,$0D9C
0DAC: 13            inc  de
0DAD: 10 F9         djnz $0DA8
0DAF: 18 B2         jr   $0D63

0DC7: 3A 9B 60      ld   a,(unknown_609B)
0DCA: FE 01         cp   $01
0DCC: C8            ret  z
0DCD: 3A 26 60      ld   a,(player_input_6026)
0DD0: E6 20         and  $20
0DD2: FE 20         cp   $20	; up
0DD4: 28 13         jr   z,$0DE9
0DD6: 3A 26 60      ld   a,(player_input_6026)
0DD9: E6 40         and  $40
0DDB: FE 40         cp   $40	; down
0DDD: C0            ret  nz
	;; climb down
0DDE: 2A 09 60      ld   hl,(player_logical_address_6009)
0DE1: 7E            ld   a,(hl)
0DE2: FE FF         cp   $FF
0DE4: C0            ret  nz
0DE5: 06 00         ld   b,$00
0DE7: 18 0A         jr   $0DF3
	;; climb up
0DE9: 2A 09 60      ld   hl,(player_logical_address_6009)
0DEC: 2B            dec  hl
0DED: 7E            ld   a,(hl)
0DEE: FE FF         cp   $FF
0DF0: C0            ret  nz
0DF1: 06 80         ld   b,$80
0DF3: 3A 07 60      ld   a,(player_climb_frame_counter_6007)
0DF6: FE 0B         cp   $0B
0DF8: 20 07         jr   nz,$0E01
0DFA: 3E 01         ld   a,$01
0DFC: 32 07 60      ld   (player_climb_frame_counter_6007),a
0DFF: 18 15         jr   $0E16
0E01: 3C            inc  a
0E02: F5            push af
0E03: 3A 58 61      ld   a,(has_bag_6158)
0E06: FE 00         cp   $00
0E08: 28 08         jr   z,$0E12
0E0A: CD D9 0C      call $0CD9	; drop 1 move out of 2 if blue bag, 1 out of 3 if yellow bag
0E0D: FE 00         cp   $00
0E0F: CA 19 0C      jp   z,$0C19
0E12: F1            pop  af
0E13: 32 07 60      ld   (player_climb_frame_counter_6007),a
0E16: 3A 07 60      ld   a,(player_climb_frame_counter_6007)
	;; vertical player movement
0E19: FE 01         cp   $01
0E1B: C8            ret  z
0E1C: FE 03         cp   $03
0E1E: CC 7F 0E      call z,$0E7F
0E21: FE 05         cp   $05
0E23: C8            ret  z
0E24: FE 08         cp   $08
0E26: CC 7F 0E      call z,$0E7F
0E29: FE 0A         cp   $0A
0E2B: C8            ret  z
0E2C: FE 02         cp   $02
0E2E: CC 7F 0E      call z,$0E7F
0E31: FE 04         cp   $04
0E33: CC 7F 0E      call z,$0E7F
0E36: FE 07         cp   $07
0E38: CC 7F 0E      call z,$0E7F
0E3B: FE 09         cp   $09
0E3D: CC 7F 0E      call z,$0E7F
0E40: FE 06         cp   $06
0E42: 20 0C         jr   nz,$0E50
0E44: 3E 12         ld   a,$12
0E46: 32 80 65      ld   (player_struct_6580),a
0E49: CD 7F 0E      call $0E7F
0E4C: CD 60 0E      call $0E60
0E4F: C9            ret
0E50: FE 0B         cp   $0B
0E52: 20 0B         jr   nz,$0E5F
0E54: 3E 92         ld   a,$92
0E56: 32 80 65      ld   (player_struct_6580),a
0E59: CD 7F 0E      call $0E7F
0E5C: CD 60 0E      call $0E60
0E5F: C9            ret
0E60: 3A F3 61      ld   a,(unknown_61F3)
0E63: FE 00         cp   $00
0E65: 20 06         jr   nz,$0E6D
0E67: 21 27 3F      ld   hl,$3F27
0E6A: CD 18 20      call copy_to_61bd_2018
0E6D: 3A 58 61      ld   a,(has_bag_6158)
0E70: FE 00         cp   $00
0E72: C8            ret  z
0E73: 3E 3F         ld   a,$3F
0E75: 32 9C 65      ld   (unknown_659C),a
0E78: 3A 82 65      ld   a,(player_x_6582)
0E7B: 32 9E 65      ld   (unknown_659E),a
0E7E: C9            ret
0E7F: F5            push af
0E80: AF            xor  a
0E81: 32 1C 60      ld   (unknown_601C),a
0E84: 32 1D 60      ld   (unknown_601D),a
0E87: 32 1E 60      ld   (unknown_601E),a
0E8A: 78            ld   a,b
0E8B: FE 80         cp   $80
0E8D: 20 13         jr   nz,$0EA2
0E8F: 3A 83 65      ld   a,(player_y_6583)
0E92: 3D            dec  a
0E93: 32 83 65      ld   (player_y_6583),a
0E96: DD 21 80 65   ld   ix,player_struct_6580
0E9A: CD 72 0F      call $0F72
0E9D: CD 60 0E      call $0E60
0EA0: F1            pop  af
0EA1: C9            ret
0EA2: 3A 83 65      ld   a,(player_y_6583)
0EA5: 3C            inc  a
0EA6: 32 83 65      ld   (player_y_6583),a
0EA9: DD 21 80 65   ld   ix,player_struct_6580
0EAD: CD 72 0F      call $0F72
0EB0: CD 60 0E      call $0E60
0EB3: F1            pop  af
0EB4: C9            ret
0EB5: F1            pop  af
0EB6: F2 F3 F4      jp   p,$F4F3
0EB9: F5            push af
0EBA: F6 F7         or   $F7
0EBC: 3A 0F 91      ld   a,($910F)
0EBF: FE 1E         cp   $1E
0EC1: 28 06         jr   z,$0EC9
0EC3: 3A 2F 91      ld   a,($912F)
0EC6: FE 1E         cp   $1E
0EC8: C0            ret  nz
0EC9: 3A 00 60      ld   a,(number_of_credits_6000)
0ECC: FE 00         cp   $00
0ECE: C8            ret  z
0ECF: 3A 54 60      ld   a,(gameplay_allowed_6054)
0ED2: FE 01         cp   $01
0ED4: C8            ret  z
0ED5: 3A 26 60      ld   a,(player_input_6026)
0ED8: E6 04         and  $04
0EDA: FE 04         cp   $04
0EDC: 28 1D         jr   z,$0EFB
0EDE: 3A 00 60      ld   a,(number_of_credits_6000)
0EE1: FE 02         cp   $02
0EE3: D8            ret  c
0EE4: 3A 51 60      ld   a,(unknown_6051)
0EE7: E6 04         and  $04
0EE9: FE 04         cp   $04
0EEB: C0            ret  nz
0EEC: 3A 00 60      ld   a,(number_of_credits_6000)
0EEF: 3D            dec  a
0EF0: 27            daa
0EF1: 32 00 60      ld   (number_of_credits_6000),a
0EF4: 3E 02         ld   a,$02
0EF6: 32 7D 61      ld   (unknown_617D),a
0EF9: 18 05         jr   $0F00
0EFB: 3E 01         ld   a,$01
0EFD: 32 7D 61      ld   (unknown_617D),a
0F00: AF            xor  a
0F01: 32 7C 61      ld   (current_player_617C),a
	;; remove 1 credit

0F04: 3A 00 60      ld   a,(number_of_credits_6000)
0F07: 3D            dec  a
0F08: 27            daa
0F09: 32 00 60      ld   (number_of_credits_6000),a
0F0C: 3E 0A         ld   a,$0A
0F0E: 32 7D 62      ld   (unknown_627D),a
0F11: 32 90 62      ld   (unknown_6290),a
0F14: CD 91 35      call $3591
0F17: 3E 01         ld   a,$01
0F19: 32 10 62      ld   (unknown_6210),a
0F1C: CD 94 1E      call init_new_game_1E94
0F1F: CD 57 29      call $2957

;; put one guard on screen 1
0F22: 3E 01         ld   a,$01
0F24: 32 9A 60      ld   (guard_2_screen_609A),a
0F27: AF            xor  a
0F28: 32 53 60      ld   (unknown_6053),a
0F2B: 32 55 60      ld   (unknown_6055),a
0F2E: 3C            inc  a
0F2F: 32 54 60      ld   (gameplay_allowed_6054),a
0F32: AF            xor  a
0F33: 21 76 61      ld   hl,player_1_score_6176
0F36: 06 06         ld   b,$06
0F38: 77            ld   (hl),a
0F39: 23            inc  hl
0F3A: 10 FC         djnz $0F38
0F3C: 3A 63 61      ld   a,(unknown_6163)
0F3F: E6 03         and  $03
0F41: C6 01         add  a,$01
0F43: 32 56 60      ld   (lives_6056),a
0F46: 3C            inc  a
0F47: 32 7E 61      ld   (unknown_617E),a
0F4A: 21 C2 91      ld   hl,$91C2
0F4D: 22 C4 61      ld   (barrow_start_screen_address_61C4),hl
0F50: 22 FA 61      ld   (unknown_screen_address_61FA),hl
0F53: 3E 01         ld   a,$01
0F55: 32 C6 61      ld   (unknown_61C6),a
0F58: 32 FC 61      ld   (unknown_61FC),a
0F5B: AF            xor  a
0F5C: 32 C7 61      ld   (holds_barrow_61C7),a
0F5F: 32 CF 61      ld   (has_pick_61CF),a
0F62: 32 14 60      ld   (unknown_6014),a
0F65: 32 1C 60      ld   (unknown_601C),a
0F68: 32 58 61      ld   (has_bag_6158),a
0F6B: CD 5B 35      call set_bags_coordinates_355b
0F6E: CD 67 35      call set_bags_coordinates_3567
0F71: C9            ret

0F72: DD 7E 02      ld   a,(ix+$02)
0F75: D6 01         sub  $01
0F77: E6 F8         and  $F8
0F79: C6 04         add  a,$04
0F7B: DD 77 02      ld   (ix+$02),a
0F7E: C9            ret

handle_ay_sound_0f7f:
0F7F: 2A 40 61      ld   hl,(unknown_pointer_6140)
0F82: 11 03 00      ld   de,$0003
0F85: 19            add  hl,de
0F86: 7E            ld   a,(hl)
0F87: FE FF         cp   $FF
0F89: C8            ret  z
0F8A: 7E            ld   a,(hl)
0F8B: 47            ld   b,a
0F8C: 3A 42 61      ld   a,(unknown_6142)
0F8F: B8            cp   b
0F90: C0            ret  nz
0F91: AF            xor  a
0F92: 32 42 61      ld   (unknown_6142),a
0F95: 2A 40 61      ld   hl,(unknown_pointer_6140)
0F98: 11 25 5B      ld   de,$5B25
0F9B: CD B2 0F      call $0FB2
0F9E: 3E 0F         ld   a,$0F
0FA0: D3 08         out  ($08),a
0FA2: 3E 01         ld   a,$01
0FA4: 32 07 A0      ld   ($A007),a
0FA7: 2A 40 61      ld   hl,(unknown_pointer_6140)
0FAA: 11 04 00      ld   de,$0004
0FAD: 19            add  hl,de
0FAE: 22 40 61      ld   (unknown_pointer_6140),hl
0FB1: C9            ret
0FB2: AF            xor  a
0FB3: 32 07 A0      ld   ($A007),a
0FB6: 3E 07         ld   a,$07
0FB8: D3 08         out  ($08),a
0FBA: 3E 38         ld   a,$38
0FBC: D3 09         out  ($09),a
0FBE: 0E 00         ld   c,$00
0FC0: D5            push de
0FC1: CD CC 0F      call $0FCC
0FC4: D1            pop  de
0FC5: EB            ex   de,hl
0FC6: 0E 08         ld   c,$08
0FC8: CD F0 0F      call $0FF0
0FCB: C9            ret
0FCC: 06 03         ld   b,$03
0FCE: 79            ld   a,c
0FCF: D3 08         out  ($08),a
0FD1: 7E            ld   a,(hl)
0FD2: CD DA 0F      call $0FDA
0FD5: 23            inc  hl
0FD6: 0C            inc  c
0FD7: 10 F5         djnz $0FCE
0FD9: C9            ret
0FDA: E5            push hl
0FDB: 87            add  a,a
0FDC: 26 00         ld   h,$00
0FDE: 6F            ld   l,a
0FDF: 11 8F 3E      ld   de,$3E8F
0FE2: 19            add  hl,de
0FE3: 7E            ld   a,(hl)
0FE4: D3 09         out  ($09),a
0FE6: 0C            inc  c
0FE7: 79            ld   a,c
0FE8: D3 08         out  ($08),a
0FEA: 23            inc  hl
0FEB: 7E            ld   a,(hl)
0FEC: D3 09         out  ($09),a
0FEE: E1            pop  hl
0FEF: C9            ret
0FF0: 06 06         ld   b,$06
0FF2: 79            ld   a,c
0FF3: D3 08         out  ($08),a
0FF5: 0C            inc  c
0FF6: 7E            ld   a,(hl)
0FF7: D3 09         out  ($09),a
0FF9: 23            inc  hl
0FFA: 10 F6         djnz $0FF2
0FFC: C9            ret
0FFD: 3A 43 61      ld   a,(unknown_6143)
1000: C9            ret

copy_4_bytes_ix_iy_1001:
1001: 06 04         ld   b,$04
1003: DD 7E 00      ld   a,(ix+$00)
1006: FD 77 00      ld   (iy+$00),a
1009: DD 23         inc  ix
100B: FD 23         inc  iy
100D: 10 F4         djnz $1003
100F: C9            ret

1010: 3A 58 61      ld   a,(has_bag_6158)
1013: FE 00         cp   $00
1015: C8            ret  z
1016: 3A 83 65      ld   a,(player_y_6583)
1019: D6 02         sub  $02
101B: 32 9F 65      ld   (unknown_659F),a
101E: 3A 80 65      ld   a,(player_struct_6580)
1021: E6 7F         and  $7F
1023: FE 12         cp   $12
1025: C8            ret  z
1026: 3A 80 65      ld   a,(player_struct_6580)
1029: E6 80         and  $80
102B: FE 80         cp   $80
102D: 20 0E         jr   nz,$103D
102F: 3A 82 65      ld   a,(player_x_6582)
1032: C6 08         add  a,$08
1034: 32 9E 65      ld   (unknown_659E),a
1037: 3E BF         ld   a,$BF
1039: 32 9C 65      ld   (unknown_659C),a
103C: C9            ret
103D: 3A 82 65      ld   a,(player_x_6582)
1040: D6 08         sub  $08
1042: 32 9E 65      ld   (unknown_659E),a
1045: 3E 3F         ld   a,$3F
1047: 32 9C 65      ld   (unknown_659C),a
104A: C9            ret
104B: 3A CF 61      ld   a,(has_pick_61CF)
104E: FE 00         cp   $00
1050: C8            ret  z
1051: 3A 80 65      ld   a,(player_struct_6580)
1054: E6 7F         and  $7F
1056: FE 1F         cp   $1F
1058: 06 37         ld   b,$37
105A: 28 0D         jr   z,$1069
105C: 3A 80 65      ld   a,(player_struct_6580)
105F: E6 7F         and  $7F
1061: FE 12         cp   $12
1063: 06 37         ld   b,$37
1065: 28 02         jr   z,$1069
1067: 06 38         ld   b,$38
1069: 3A 83 65      ld   a,(player_y_6583)
106C: 32 9F 65      ld   (unknown_659F),a
106F: 3A 80 65      ld   a,(player_struct_6580)
1072: E6 7F         and  $7F
1074: FE 12         cp   $12
1076: 28 16         jr   z,$108E
1078: 3A 80 65      ld   a,(player_struct_6580)
107B: E6 80         and  $80
107D: FE 80         cp   $80
107F: 28 0D         jr   z,$108E
1081: 3A 82 65      ld   a,(player_x_6582)
1084: C6 0C         add  a,$0C
1086: 32 9E 65      ld   (unknown_659E),a
1089: 78            ld   a,b
108A: 32 9C 65      ld   (unknown_659C),a
108D: C9            ret
108E: 3A 82 65      ld   a,(player_x_6582)
1091: D6 0C         sub  $0C
1093: 32 9E 65      ld   (unknown_659E),a
1096: 78            ld   a,b
1097: F6 80         or   $80
1099: 32 9C 65      ld   (unknown_659C),a
109C: C9            ret

109D: 3A 54 60      ld   a,(gameplay_allowed_6054)
10A0: FE 01         cp   $01
10A2: 28 0A         jr   z,object_pickup_test_10AE
10A4: 3A 50 60      ld   a,(player_move_direction_6050)
10A7: E6 80         and  $80
10A9: FE 80         cp   $80
10AB: 28 12         jr   z,$10BF
10AD: C9            ret

object_pickup_test_10AE:
10AE: 3A 26 60      ld   a,(player_input_6026)
10B1: E6 80         and  $80
10B3: FE 80         cp   $80
10B5: 20 0E         jr   nz,$10C5
;;; fire pressed
10B7: 3A 50 60      ld   a,(player_move_direction_6050)
10BA: E6 80         and  $80
10BC: FE 80         cp   $80	; just leaving the wagon handle
10BE: C8            ret  z	;  don't pick up anything!
	;;  actual pickup of an object
10BF: 3E 01         ld   a,$01
10C1: 32 60 61      ld   (pickup_flag_6160),a
10C4: C9            ret
10C5: 3E 00         ld   a,$00
10C7: 32 60 61      ld   (pickup_flag_6160),a
10CA: C9            ret

set_previous_guard_y_255_10CB:
10CB: 3E FF         ld   a,$FF
10CD: FD 77 03      ld   (iy+$03),a
10D0: C9            ret
speech_management_10D1:
10D1: 3A 10 62      ld   a,(unknown_6210)
10D4: FE 01         cp   $01
10D6: C0            ret  nz
10D7: 3A ED 61      ld   a,(check_scenery_disabled_61ED)
10DA: FE 01         cp   $01
10DC: C8            ret  z
10DD: 3A C0 61      ld   a,(unknown_61C0)
10E0: FE 01         cp   $01
10E2: 28 15         jr   z,$10F9
10E4: 21 BD 61      ld   hl,unknown_61BD
10E7: 11 00 A8      ld   de,$A800
10EA: 01 06 00      ld   bc,$0006
10ED: ED B0         ldir
10EF: AF            xor  a
10F0: 32 03 A8      ld   ($A803),a
10F3: 3E 01         ld   a,$01
10F5: 32 C0 61      ld   (unknown_61C0),a
10F8: C9            ret
10F9: 3E 01         ld   a,$01
10FB: 32 03 A8      ld   ($A803),a
10FE: C9            ret
10FF: 3A C7 61      ld   a,(holds_barrow_61C7)
1102: FE 00         cp   $00
1104: C8            ret  z
1105: 3A 82 65      ld   a,(player_x_6582)
1108: C6 0E         add  a,$0E
110A: 32 9E 65      ld   (unknown_659E),a
110D: 3A ED 61      ld   a,(check_scenery_disabled_61ED)
1110: FE 01         cp   $01
1112: 28 05         jr   z,$1119
1114: 3E 10         ld   a,$10
1116: 32 9F 65      ld   (unknown_659F),a
1119: 3A 83 65      ld   a,(player_y_6583)
111C: 47            ld   b,a
111D: 3A 9F 65      ld   a,(unknown_659F)
1120: B8            cp   b
1121: C8            ret  z
1122: C6 01         add  a,$01
1124: B8            cp   b
1125: C8            ret  z
1126: 01 C7 61      ld   bc,holds_barrow_61C7
1129: D9            exx
112A: FD 21 C4 61   ld   iy,barrow_start_screen_address_61C4
112E: 3E 28         ld   a,$28
1130: FD 77 05      ld   (iy+$05),a
1133: 3E EC         ld   a,$EC
1135: FD 77 06      ld   (iy+$06),a
1138: C4 BA 21      call nz,$21BA
113B: C9            ret
handle_pick_hold_timer_113c:
113C: 3A CF 61      ld   a,(has_pick_61CF)
113F: FE 00         cp   $00
1141: C8            ret  z
1142: 2A E0 61      ld   hl,(pickaxe_timer_duration_61E0)
1145: 7D            ld   a,l
1146: FE 00         cp   $00
1148: 20 06         jr   nz,$1150
114A: 7C            ld   a,h
114B: FE 00         cp   $00
114D: 20 01         jr   nz,$1150
114F: C9            ret
* increase pickaxe time until timeout
1150: 23            inc  hl
1151: 22 E0 61      ld   (pickaxe_timer_duration_61E0),hl
1154: 11 FF 01      ld   de,$01FF
1157: ED 52         sbc  hl,de
1159: C0            ret  nz
* lose pickaxe
115A: 21 00 00      ld   hl,$0000
115D: 22 E0 61      ld   (pickaxe_timer_duration_61E0),hl
1160: 3E 00         ld   a,$00
1162: DD 21 CC 61   ld   ix,unknown_61CC
1166: DD 77 03      ld   (ix+$03),a
1169: 3E FF         ld   a,$FF
116B: 32 9F 65      ld   (unknown_659F),a
116E: C9            ret

guard_1_movement_116F:
116F: 3A 99 60      ld   a,(guard_1_screen_6099)
1172: 32 98 60      ld   (screen_index_param_6098),a
1175: 2A 38 60      ld   hl,(guard_1_logical_address_6038)
1178: 22 44 60      ld   (unknown_6044),hl
117B: FD 21 57 60   ld   iy,unknown_6057
117F: FD 22 93 60   ld   (guard_struct_pointer_6093),iy
1183: DD 2A A9 04   ld   ix,($04A9)
1187: 21 34 60      ld   hl,unknown_6034
118A: FD 21 27 60   ld   iy,guard_1_direction_6027
118E: CD 70 05      call guard_walk_movement_0570
1191: 3A 00 B8      ld   a,(io_read_shit_B800)
1194: 3A 98 60      ld   a,(screen_index_param_6098)
1197: 32 99 60      ld   (guard_1_screen_6099),a
119A: C9            ret
guard_2_movement_119B:
119B: 3A 9A 60      ld   a,(guard_2_screen_609A)
119E: 32 98 60      ld   (screen_index_param_6098),a
11A1: 2A 78 60      ld   hl,(guard_2_screen_address_6078)
11A4: 22 44 60      ld   (unknown_6044),hl
11A7: FD 21 97 60   ld   iy,unknown_6097
11AB: FD 22 93 60   ld   (guard_struct_pointer_6093),iy
11AF: DD 2A AB 04   ld   ix,($04AB)
11B3: 21 74 60      ld   hl,unknown_6074
11B6: FD 21 67 60   ld   iy,guard_2_direction_6067
11BA: CD 70 05      call guard_walk_movement_0570
11BD: 3A 00 B8      ld   a,(io_read_shit_B800)
11C0: 3A 98 60      ld   a,(screen_index_param_6098)
11C3: 32 9A 60      ld   (guard_2_screen_609A),a
11C6: C9            ret

;; global init
1200: AF            xor  a
1201: 32 00 A0      ld   (interrupt_control_A000),a
1204: F3            di
1205: 3C            inc  a
1206: C3 80 24      jp   $2480

;;;  seems unreachable
1209: 21 00 05      ld   hl,$0500
120C: CD 38 2C      call $2C38
120F: 3E 01         ld   a,$01
1211: 32 01 A0      ld   ($A001),a
1214: 32 02 A0      ld   ($A002),a
1217: 3E 40         ld   a,$40
1219: 32 E8 61      ld   (time_61E8),a


121C: CD 00 37      call play_intro_3700
121F: CD 5B 35      call set_bags_coordinates_355b
1222: CD 67 35      call set_bags_coordinates_3567
1225: 21 3C 51      ld   hl,$513C
1228: 22 40 61      ld   (unknown_pointer_6140),hl
	;; reset guards and player
122B: F3            di
122C: 3A 00 B8      ld   a,(io_read_shit_B800)
122F: CD 94 1E      call init_new_game_1E94
1232: CD 57 29      call $2957
1235: AF            xor  a
1236: 32 25 60      ld   (player_death_flag_6025),a
1239: 3C            inc  a
123A: 32 9A 60      ld   (guard_2_screen_609A),a
123D: 3E 03         ld   a,$03
123F: 32 99 60      ld   (guard_1_screen_6099),a

;; game main loop

mainloop_1242:
1242: 3E 01         ld   a,$01
1244: ED 56         im   1
1246: 32 00 A0      ld   (interrupt_control_A000),a
1249: FB            ei
124A: 3A 00 A8      ld   a,($A800)
124D: CD CF 34      call $34CF	;  ???? something to do with credits handling
1250: CD A4 24      call $24A4  ;  ???? or is this this routine?


1253: DD 21 80 65   ld   ix,player_struct_6580
1257: FD 21 94 65   ld   iy,guard_1_struct_6594
125B: 11 04 00      ld   de,$0004


;; player in the same screen as the guard?
125E: 3A 0D 60      ld   a,(player_screen_600D)
1261: 47            ld   b,a
1262: 3A 99 60      ld   a,(guard_1_screen_6099)
1265: B8            cp   b
1266: 20 13         jr   nz,$127B
;; same screen:	attempt collision with first guard
1268: CD 37 55      call guard_collision_5537
126B: FE 00         cp   $00
126D: 28 0C         jr   z,$127B
126F: 3A 56 61      ld   a,(unknown_6156)
1272: FE 00         cp   $00
1274: 20 05         jr   nz,$127B
1276: 3E 01         ld   a,$01
1278: 32 25 60      ld   (player_death_flag_6025),a


127B: DD 21 80 65   ld   ix,player_struct_6580
127F: FD 21 98 65   ld   iy,guard_2_struct_6598
1283: 11 04 00      ld   de,$0004
1286: CD 53 16      call $1653	;  ???

;; player in the same screen as the second guard?
1289: 3A 0D 60      ld   a,(player_screen_600D)
128C: 47            ld   b,a
128D: 3A 9A 60      ld   a,(guard_2_screen_609A)
1290: B8            cp   b
1291: 20 13         jr   nz,$12A6
;; collision attempt with second guard
1293: CD 37 55      call guard_collision_5537    ; guard routine
1296: FE 00         cp   $00
1298: 28 0C         jr   z,$12A6	; no collision

;; hit by guard
129A: 3A 57 61      ld   a,(unknown_6157)
129D: FE 00         cp   $00
129F: 20 05         jr   nz,$12A6
12A1: 3E 01         ld   a,$01
12A3: 32 25 60      ld   (player_death_flag_6025),a


12A6: 3A 54 60      ld   a,(gameplay_allowed_6054)
12A9: FE 01         cp   $01
12AB: 28 63         jr   z,$1310
12AD: 3E 01         ld   a,$01
12AF: 32 01 A0      ld   ($A001),a
12B2: 32 02 A0      ld   ($A002),a
12B5: 3A 53 60      ld   a,(unknown_6053)
12B8: FE 01         cp   $01
12BA: 20 54         jr   nz,$1310
12BC: 3A 10 62      ld   a,(unknown_6210)
12BF: FE 01         cp   $01
12C1: 28 4D         jr   z,$1310
12C3: F3            di
12C4: 3A 55 60      ld   a,(unknown_6055)
12C7: FE 01         cp   $01
12C9: 28 1F         jr   z,$12EA
12CB: 3A 00 B8      ld   a,(io_read_shit_B800)
12CE: CD 2C 2A      call $2A2C	;  ???
12D1: CD EC 1D      call display_player_ids_and_credit_1dec
12D4: CD BE 39      call write_credits_and_lives_39be	;  ???
12D7: 21 3C 51      ld   hl,$513C
12DA: 22 40 61      ld   (unknown_pointer_6140),hl
12DD: 3E 01         ld   a,$01
12DF: 32 55 60      ld   (unknown_6055),a
12E2: 3A 54 60      ld   a,(gameplay_allowed_6054)
12E5: FE 01         cp   $01
12E7: CA 42 12      jp   z,mainloop_1242
12EA: 3A 10 62      ld   a,(unknown_6210)
12ED: FE 01         cp   $01
12EF: 28 1F         jr   z,$1310
12F1: 3A 00 60      ld   a,(number_of_credits_6000)
12F4: FE 01         cp   $01
12F6: 20 0C         jr   nz,$1304
12F8: 11 DF 56      ld   de,$56DF
12FB: 21 11 93      ld   hl,$9311
12FE: CD F9 30      call display_text_30F9	;  ???
1301: C3 42 12      jp   mainloop_1242
1304: 11 F2 56      ld   de,$56F2
1307: 21 11 93      ld   hl,$9311
130A: CD F9 30      call display_text_30F9	;  ???
130D: C3 42 12      jp   mainloop_1242

1310: CD 3F 1E      call $1E3F
1313: FE 01         cp   $01
1315: CA 2B 12      jp   z,$122B
1318: 3A E8 61      ld   a,(time_61E8)
131B: FE 00         cp   $00
131D: 20 08         jr   nz,$1327
131F: CD 70 1E      call $1E70
1322: FE 01         cp   $01
1324: CA 2B 12      jp   z,$122B
1327: CD 7A 1E      call $1E7A	;  ????
132A: 32 00 B8      ld   (io_read_shit_B800),a
132D: CD 30 1C      call $1C30	;  ????
1330: 3A A3 58      ld   a,($58A3)
1333: 32 73 62      ld   (unknown_6273),a
1336: 3A 00 B8      ld   a,(io_read_shit_B800)
1339: 3A 0D 60      ld   a,(player_screen_600D)
133C: 47            ld   b,a
133D: 3A 99 60      ld   a,(guard_1_screen_6099)
1340: B8            cp   b
1341: CC 38 1B      call z,$1B38
1344: FB            ei
1345: CD C9 1C      call $1CC9	;  ???
1348: 3A 0F 57      ld   a,($570F)
134B: 32 70 62      ld   (unknown_6270),a
134E: 3A 00 B8      ld   a,(io_read_shit_B800)
1351: 3A 00 B8      ld   a,(io_read_shit_B800)
1354: 3A 0D 60      ld   a,(player_screen_600D)
1357: 47            ld   b,a
1358: 3A 9A 60      ld   a,(guard_2_screen_609A)
135B: B8            cp   b
135C: CC 94 1C      call z,$1C94
135F: FB            ei
1360: CD B3 25      call $25B3
1363: 32 00 B0      ld   (dip_switch_B000),a
1366: 3A 99 60      ld   a,(guard_1_screen_6099)
1369: 32 98 60      ld   (screen_index_param_6098),a
136C: FD 21 94 65   ld   iy,guard_1_struct_6594
1370: FD 22 93 60   ld   (guard_struct_pointer_6093),iy
1374: DD 21 27 60   ld   ix,guard_1_direction_6027
1378: DD 22 95 60   ld   (guard_direction_pointer_6095),ix
137C: DD 21 35 60   ld   ix,guard_1_ladder_frame_6035
1380: FD 21 94 65   ld   iy,guard_1_struct_6594
1384: ED 5B 38 60   ld   de,(guard_1_logical_address_6038)
1388: ED 53 91 60   ld   (guard_logical_address_6091),de
138C: 3A 00 B8      ld   a,(io_read_shit_B800)
138F: CD D1 19      call analyse_guard_direction_change_19D1
1392: DD 21 3B 60   ld   ix,guard_1_in_elevator_603B
1396: 21 57 60      ld   hl,unknown_6057
1399: 11 48 61      ld   de,unknown_6148
139C: CD 08 19      call $1908
139F: 3A 48 61      ld   a,(unknown_6148)
13A2: FE 00         cp   $00
13A4: 20 2D         jr   nz,$13D3
13A6: 3A 57 60      ld   a,(unknown_6057)
13A9: FE F0         cp   $F0
13AB: D4 A3 31      call nc,$31A3
13AE: FE 10         cp   $10
13B0: FD 21 94 65   ld   iy,guard_1_struct_6594
13B4: FD 22 93 60   ld   (guard_struct_pointer_6093),iy
13B8: DD 21 27 60   ld   ix,guard_1_direction_6027
13BC: DD 22 95 60   ld   (guard_direction_pointer_6095),ix
13C0: FD 21 94 65   ld   iy,guard_1_struct_6594
13C4: ED 5B 38 60   ld   de,(guard_1_logical_address_6038)
13C8: ED 53 91 60   ld   (guard_logical_address_6091),de
13CC: DD 21 35 60   ld   ix,guard_1_ladder_frame_6035
13D0: D4 23 21      call nc,choose_guard_random_direction_2123	; change guard 2 direction
13D3: 3A 9A 60      ld   a,(guard_2_screen_609A)
13D6: 32 98 60      ld   (screen_index_param_6098),a
13D9: FD 21 98 65   ld   iy,guard_2_struct_6598
13DD: FD 22 93 60   ld   (guard_struct_pointer_6093),iy
13E1: DD 21 67 60   ld   ix,guard_2_direction_6067
13E5: DD 22 95 60   ld   (guard_direction_pointer_6095),ix
13E9: DD 21 75 60   ld   ix,guard_2_ladder_frame_6075
13ED: FD 21 98 65   ld   iy,guard_2_struct_6598
13F1: ED 5B 78 60   ld   de,(guard_2_screen_address_6078)
13F5: ED 53 91 60   ld   (guard_logical_address_6091),de
13F9: 3A 00 B8      ld   a,(io_read_shit_B800)
13FC: 3A 0C 57      ld   a,($570C)
13FF: 32 71 62      ld   (unknown_6271),a
1402: CD D1 19      call analyse_guard_direction_change_19D1
1405: DD 21 7B 60   ld   ix,guard_2_in_elevator_607B
1409: 21 97 60      ld   hl,unknown_6097
140C: 11 49 61      ld   de,unknown_6149
140F: CD 08 19      call $1908
1412: CD 53 16      call $1653
1415: 3A 49 61      ld   a,(unknown_6149)
1418: FE 00         cp   $00
141A: 20 2D         jr   nz,$1449
141C: 3A 97 60      ld   a,(unknown_6097)
141F: FE F0         cp   $F0
1421: D4 C1 31      call nc,$31C1
1424: FE 10         cp   $10
1426: FD 21 98 65   ld   iy,guard_2_struct_6598
142A: FD 22 93 60   ld   (guard_struct_pointer_6093),iy
142E: DD 21 67 60   ld   ix,guard_2_direction_6067
1432: DD 22 95 60   ld   (guard_direction_pointer_6095),ix
1436: FD 21 98 65   ld   iy,guard_2_struct_6598
143A: ED 5B 78 60   ld   de,(guard_2_screen_address_6078)
143E: ED 53 91 60   ld   (guard_logical_address_6091),de
1442: DD 21 75 60   ld   ix,guard_2_ladder_frame_6075
1446: D4 23 21      call nc,choose_guard_random_direction_2123	; change guard 1 direction
1449: FB            ei
144A: CD 75 55      call update_guard_2_screen_address_from_xy_5575
144D: 7E            ld   a,(hl)
144E: FE E0         cp   $E0
1450: CA 55 14      jp   z,$1455
1453: 18 05         jr   $145A
1455: 3E 01         ld   a,$01
1457: 32 77 60      ld   (unknown_6077),a
145A: CD 68 55      call update_guard_1_screen_address_from_xy_5568
145D: 7E            ld   a,(hl)
145E: FE E0         cp   $E0
1460: 28 02         jr   z,$1464
1462: 18 05         jr   $1469
1464: 3E 01         ld   a,$01
1466: 32 37 60      ld   (unknown_6037),a
1469: 2A 38 60      ld   hl,(guard_1_logical_address_6038)
146C: FD 21 37 60   ld   iy,unknown_6037
1470: DD 21 94 65   ld   ix,guard_1_struct_6594
1474: CD 05 26      call $2605
1477: 2A 38 60      ld   hl,(guard_1_logical_address_6038)
147A: DD 21 94 65   ld   ix,guard_1_struct_6594
147E: CD 0E 25      call $250E
1481: 2A 78 60      ld   hl,(guard_2_screen_address_6078)
1484: FD 21 77 60   ld   iy,unknown_6077
1488: DD 21 98 65   ld   ix,guard_2_struct_6598
148C: CD 05 26      call $2605
148F: 2A 78 60      ld   hl,(guard_2_screen_address_6078)
1492: DD 21 98 65   ld   ix,guard_2_struct_6598
1496: CD 0E 25      call $250E
1499: 3A 00 B8      ld   a,(io_read_shit_B800)
149C: CD 5E 55      call update_player_screen_address_from_xy_555E
149F: FB            ei
14A0: 7E            ld   a,(hl)
14A1: FE E0         cp   $E0
14A3: 28 0E         jr   z,$14B3
14A5: 3A 4E 60      ld   a,(fatal_fall_height_reached_604E)
14A8: FE 01         cp   $01
14AA: 28 0C         jr   z,$14B8
14AC: 3E 00         ld   a,$00
14AE: 32 08 60      ld   (unknown_6008),a
14B1: 18 05         jr   $14B8
14B3: 3E 01         ld   a,$01
14B5: 32 08 60      ld   (unknown_6008),a
14B8: 2A 09 60      ld   hl,(player_logical_address_6009)
14BB: FD 21 08 60   ld   iy,unknown_6008
14BF: DD 21 80 65   ld   ix,player_struct_6580
14C3: CD 05 26      call $2605
14C6: 2A 09 60      ld   hl,(player_logical_address_6009)
14C9: DD 21 80 65   ld   ix,player_struct_6580
14CD: CD 0E 25      call $250E
14D0: 3E 01         ld   a,$01
14D2: 32 6F 62      ld   (unknown_626F),a
14D5: 3A 00 B8      ld   a,(io_read_shit_B800)
14D8: CD 28 2C      call nasty_protection_2c28
14DB: CD 19 32      call $3219
14DE: 3E 00         ld   a,$00
14E0: 32 6F 62      ld   (unknown_626F),a
14E3: CD 84 1D      call wagon_player_collision_1D84
14E6: CD 73 1D      call $1D73
14E9: FE 01         cp   $01
14EB: CA 2B 12      jp   z,$122B

14EE: DD 21 3C 60   ld   ix,guard_2_sees_player_right_603C
14F2: 06 04         ld   b,$04
14F4: DD 7E 00      ld   a,(ix+$00)
14F7: FE 00         cp   $00
14F9: 20 2A         jr   nz,guard_2_sees_player_1525
14FB: DD 23         inc  ix
14FD: 10 F5         djnz $14F4
	;; guard 2 does not see player anywhere: do something special

14FF: 21 27 60      ld   hl,guard_1_direction_6027
1502: 22 95 60      ld   (guard_direction_pointer_6095),hl
1505: 21 44 61      ld   hl,unknown_6144
1508: 22 46 61      ld   (unknown_pointer_6146),hl
150B: 3A 99 60      ld   a,(guard_1_screen_6099)
150E: 32 98 60      ld   (screen_index_param_6098),a
1511: DD 21 80 65   ld   ix,player_struct_6580
1515: FD 21 94 65   ld   iy,guard_1_struct_6594
1519: ED 5B 38 60   ld   de,(guard_1_logical_address_6038)
151D: 21 3B 60      ld   hl,guard_1_in_elevator_603B
1520: CD FA 2A      call guard_wait_for_elevator_test_2AFA
1523: 18 04         jr   $1529
	;; guard_2_sees_player
	
guard_2_sees_player_1525:
1525: AF            xor  a
1526: 32 48 61      ld   (unknown_6148),a
1529: DD 21 7C 60   ld   ix,guard_1_sees_player_right_607C
152D: 06 04         ld   b,$04
152F: DD 7E 00      ld   a,(ix+$00)
1532: FE 00         cp   $00
1534: 20 2A         jr   nz,guard_1_sees_player_1560
1536: DD 23         inc  ix
1538: 10 F5         djnz $152F
	;; guard 1 does not see player anywhere
153A: 21 67 60      ld   hl,guard_2_direction_6067
153D: 22 95 60      ld   (guard_direction_pointer_6095),hl
1540: 21 45 61      ld   hl,unknown_6145
1543: 22 46 61      ld   (unknown_pointer_6146),hl
1546: 3A 9A 60      ld   a,(guard_2_screen_609A)
1549: 32 98 60      ld   (screen_index_param_6098),a
154C: DD 21 80 65   ld   ix,player_struct_6580
1550: FD 21 98 65   ld   iy,guard_2_struct_6598
1554: ED 5B 78 60   ld   de,(guard_2_screen_address_6078)
1558: 21 7B 60      ld   hl,guard_2_in_elevator_607B
155B: CD FA 2A      call guard_wait_for_elevator_test_2AFA
155E: 18 04         jr   $1564

guard_1_sees_player_1560:
1560: AF            xor  a
1561: 32 49 61      ld   (unknown_6149),a
1564: FB            ei
1565: CD DE 17      call $17DE
1568: CD 53 16      call $1653
156B: 3A CF 61      ld   a,(has_pick_61CF)
156E: FE 01         cp   $01
1570: 28 21         jr   z,$1593
1572: 3A 58 61      ld   a,(has_bag_6158)
1575: FE 01         cp   $01
1577: 28 1A         jr   z,$1593
1579: 01 C7 61      ld   bc,holds_barrow_61C7
157C: FD 21 C4 61   ld   iy,barrow_start_screen_address_61C4
1580: 3E 3A         ld   a,$3A
1582: FD 77 04      ld   (iy+$04),a
1585: 3E 28         ld   a,$28
1587: FD 77 05      ld   (iy+$05),a
158A: 3E EC         ld   a,$EC
158C: 32 CA 61      ld   (unknown_61CA),a
158F: F3            di
1590: CD 37 21      call $2137
1593: F3            di
1594: 06 04         ld   b,$04
1596: FD 21 D0 61   ld   iy,unknown_61D0
159A: 3A C7 61      ld   a,(holds_barrow_61C7)
159D: FE 01         cp   $01
159F: CA CF 15      jp   z,$15CF
15A2: C5            push bc
15A3: FD E5         push iy
15A5: 01 CF 61      ld   bc,has_pick_61CF
15A8: FD 21 CC 61   ld   iy,unknown_61CC
15AC: 3E 37         ld   a,$37
15AE: FD 77 04      ld   (iy+$04),a
15B1: 3E 20         ld   a,$20
15B3: FD 77 05      ld   (iy+$05),a
15B6: 3A 00 B8      ld   a,(io_read_shit_B800)
15B9: 3E E4         ld   a,$E4
15BB: 32 D2 61      ld   (unknown_61D2),a
15BE: CD 37 21      call $2137
15C1: FD E1         pop  iy
15C3: FD 23         inc  iy
15C5: FD 23         inc  iy
15C7: FD 23         inc  iy
15C9: CD B7 22      call $22B7
15CC: C1            pop  bc
15CD: 10 D3         djnz $15A2
15CF: FB            ei
15D0: 3A CF 61      ld   a,(has_pick_61CF)
15D3: FE 00         cp   $00
15D5: 28 4A         jr   z,$1621
	;; player has pick
15D7: 3A 99 60      ld   a,(guard_1_screen_6099)
15DA: 47            ld   b,a
15DB: 3A 70 62      ld   a,(unknown_6270)
15DE: B8            cp   b
15DF: 3A 0D 60      ld   a,(player_screen_600D)
15E2: B8            cp   b
15E3: 20 19         jr   nz,$15FE
15E5: DD 21 94 65   ld   ix,guard_1_struct_6594
15E9: FD 21 9C 65   ld   iy,unknown_659C
15ED: 0E 00         ld   c,$00
15EF: 06 06         ld   b,$06
15F1: CD D5 2A      call $2AD5
15F4: FE 01         cp   $01
15F6: 20 06         jr   nz,$15FE
15F8: CD 41 22      call $2241
15FB: CD 3D 31      call $313D
15FE: DD 21 98 65   ld   ix,guard_2_struct_6598
1602: FD 21 9C 65   ld   iy,unknown_659C
1606: 3A 9A 60      ld   a,(guard_2_screen_609A)
1609: 47            ld   b,a
160A: 3A 0D 60      ld   a,(player_screen_600D)
160D: B8            cp   b
160E: 20 11         jr   nz,$1621
1610: 0E 00         ld   c,$00
1612: 06 06         ld   b,$06
1614: CD D5 2A      call $2AD5
1617: FE 01         cp   $01
1619: 20 06         jr   nz,$1621
161B: CD 7C 22      call $227C
161E: CD 3D 31      call $313D
1621: DD 21 80 65   ld   ix,player_struct_6580
1625: FD 21 84 65   ld   iy,unknown_6584
1629: CD D1 2A      call guard_collision_with_pick_2AD1
162C: FE 01         cp   $01
162E: 20 11         jr   nz,$1641
1630: 3E 01         ld   a,$01
1632: 32 25 60      ld   (player_death_flag_6025),a
1635: AF            xor  a
1636: 32 29 60      ld   (player_in_wagon_flag_6029),a
1639: CD 73 1D      call $1D73
163C: FE 01         cp   $01
163E: CA 2B 12      jp   z,$122B
1641: FB            ei
1642: CD 4D 2C      call compute_guard_speed_from_dipsw_2C4D
1645: CD A1 3B      call $3BA1
1648: 3A ED 61      ld   a,(check_scenery_disabled_61ED)
164B: FE 00         cp   $00
164D: CC DC 22      call z,draw_bag_tiles_22dc
1650: C3 42 12      jp   mainloop_1242
1653: 3A ED 61      ld   a,(check_scenery_disabled_61ED)
1656: FE 00         cp   $00
1658: C0            ret  nz
1659: 3A 7F 62      ld   a,(unknown_627F)
165C: FE 01         cp   $01
165E: C0            ret  nz
165F: E5            push hl
1660: D5            push de
1661: F5            push af
1662: C5            push bc
1663: FD E5         push iy
1665: DD E5         push ix
1667: 3A 98 60      ld   a,(screen_index_param_6098)
166A: 32 80 62      ld   (unknown_6280),a
166D: CD BC 3B      call $3BBC
1670: AF            xor  a
1671: 32 7F 62      ld   (unknown_627F),a
1674: 3A 80 62      ld   a,(unknown_6280)
1677: 32 98 60      ld   (screen_index_param_6098),a
167A: DD E1         pop  ix
167C: FD E1         pop  iy
167E: C1            pop  bc
167F: F1            pop  af
1680: D1            pop  de
1681: E1            pop  hl
1682: C9            ret
1683: 3A 5E 61      ld   a,(unknown_615E)
1686: FE 00         cp   $00
1688: 20 06         jr   nz,$1690
168A: 3A 59 61      ld   a,(unknown_6159)
168D: FE 00         cp   $00
168F: C8            ret  z
1690: DD 21 9C 65   ld   ix,unknown_659C
1694: FD 21 5A 61   ld   iy,unknown_615A
1698: 3A 0D 60      ld   a,(player_screen_600D)
169B: 32 98 60      ld   (screen_index_param_6098),a
169E: DD 35 03      dec  (ix+$03)
16A1: CD 8C 55      call compute_logical_address_from_xy_558c
16A4: FB            ei
16A5: DD 21 9C 65   ld   ix,unknown_659C
16A9: DD 34 03      inc  (ix+$03)
16AC: FB            ei
16AD: 7E            ld   a,(hl)
16AE: E5            push hl
16AF: 21 24 5B      ld   hl,$5B24
16B2: 01 07 00      ld   bc,$0007
16B5: ED B9         cpdr
16B7: E1            pop  hl
16B8: C2 C5 16      jp   nz,$16C5
16BB: 3E 01         ld   a,$01
16BD: 32 5E 61      ld   (unknown_615E),a
16C0: AF            xor  a
16C1: 32 59 61      ld   (unknown_6159),a
16C4: C9            ret
16C5: AF            xor  a
16C6: 32 5E 61      ld   (unknown_615E),a
16C9: 3C            inc  a
16CA: 32 59 61      ld   (unknown_6159),a
16CD: DD 21 9C 65   ld   ix,unknown_659C
16D1: FD 21 5A 61   ld   iy,unknown_615A
16D5: 3A 0D 60      ld   a,(player_screen_600D)
16D8: 32 98 60      ld   (screen_index_param_6098),a
16DB: CD 8C 55      call compute_logical_address_from_xy_558c
16DE: FB            ei
16DF: 7E            ld   a,(hl)
16E0: E5            push hl
16E1: 21 D0 17      ld   hl,$17D0
16E4: 01 22 00      ld   bc,$0022
16E7: ED B9         cpdr
16E9: E1            pop  hl
16EA: C8            ret  z
16EB: AF            xor  a
16EC: 32 5E 61      ld   (unknown_615E),a
16EF: 32 59 61      ld   (unknown_6159),a
16F2: FD 2A 5C 61   ld   iy,(unknown_615C)
16F6: 3A 0D 60      ld   a,(player_screen_600D)
16F9: FD 77 02      ld   (iy+$02),a
16FC: FE 01         cp   $01
16FE: 20 05         jr   nz,$1705
1700: 7C            ld   a,h
1701: C6 50         add  a,$50
1703: 18 0C         jr   $1711
1705: FE 02         cp   $02
1707: 20 05         jr   nz,$170E
1709: 7C            ld   a,h
170A: C6 4C         add  a,$4C
170C: 18 03         jr   $1711
170E: 7C            ld   a,h
170F: C6 48         add  a,$48
1711: 67            ld   h,a
1712: AF            xor  a
1713: 7D            ld   a,l
1714: D6 22         sub  $22
1716: 6F            ld   l,a
1717: 7C            ld   a,h
1718: DE 00         sbc  a,$00
171A: 67            ld   h,a
171B: 7E            ld   a,(hl)
171C: FE D0         cp   $D0
171E: 28 10         jr   z,$1730
1720: EB            ex   de,hl
1721: 21 D0 17      ld   hl,$17D0
1724: 01 07 00      ld   bc,$0007
1727: ED B9         cpdr
1729: EB            ex   de,hl
172A: 28 04         jr   z,$1730
172C: 11 20 00      ld   de,$0020
172F: 19            add  hl,de
1730: F3            di
1731: FD 75 00      ld   (iy+$00),l
1734: 7D            ld   a,l
1735: FE C0         cp   $C0
1737: 20 02         jr   nz,$173B
1739: 3E 68         ld   a,$68		| will be overwritten just after
173B: FD 74 01      ld   (iy+$01),h
173E: 3A 0D 60      ld   a,(player_screen_600D)
1741: FD 77 02      ld   (iy+$02),a
1744: FB            ei
1745: 23            inc  hl
1746: 7E            ld   a,(hl)
1747: FE ED         cp   $ED
1749: 28 13         jr   z,$175E
174B: FE EF         cp   $EF
174D: 28 0F         jr   z,$175E
174F: 7D            ld   a,l
1750: C6 20         add  a,$20
1752: 6F            ld   l,a
1753: 7C            ld   a,h
1754: CE 00         adc  a,$00
1756: 67            ld   h,a
1757: 7E            ld   a,(hl)
1758: FE ED         cp   $ED
175A: 28 02         jr   z,$175E
175C: 18 42         jr   $17A0
175E: DD E5         push ix
1760: CD D5 17      call $17D5
1763: 3A 9D 65      ld   a,(unknown_659D)
1766: FE 24         cp   $24
1768: 20 0B         jr   nz,$1775
176A: 3E 20         ld   a,$20
176C: 32 9D 65      ld   (unknown_659D),a
176F: CD D5 17      call $17D5
1772: CD D5 17      call $17D5
1775: 21 1B 3F      ld   hl,$3F1B
1778: CD 18 20      call copy_to_61bd_2018
177B: CD EB 3D      call can_pick_bag_3DEB
177E: 20 0A         jr   nz,$178A
1780: 21 78 5B      ld   hl,$5B78
1783: 22 40 61      ld   (unknown_pointer_6140),hl
1786: AF            xor  a
1787: 32 42 61      ld   (unknown_6142),a
178A: DD E1         pop  ix
178C: F3            di
178D: AF            xor  a
178E: FD 77 00      ld   (iy+$00),a
1791: FD 77 01      ld   (iy+$01),a
1794: FD 77 02      ld   (iy+$02),a
1797: FB            ei
1798: 3E 40         ld   a,$40
179A: 32 E8 61      ld   (time_61E8),a
179D: CD 00 3B      call $3B00
17A0: AF            xor  a
17A1: DD 21 9C 65   ld   ix,unknown_659C
17A5: DD 77 02      ld   (ix+$02),a
17A8: 3E FF         ld   a,$FF
17AA: DD 77 03      ld   (ix+$03),a
17AD: C9            ret

17D5: 2A E7 61      ld   hl,(timer_high_prec_61E7)
17D8: 2E 00         ld   l,$00
17DA: CD 90 5C      call add_to_score_5C90
17DD: C9            ret
17DE: 3A 58 61      ld   a,(has_bag_6158)
17E1: FE 00         cp   $00
17E3: C2 5F 19      jp   nz,$195F
17E6: 3A CF 61      ld   a,(has_pick_61CF)
17E9: FE 01         cp   $01
17EB: C8            ret  z
17EC: 3A C7 61      ld   a,(holds_barrow_61C7)
17EF: FE 01         cp   $01
17F1: C8            ret  z
17F2: 3A 59 61      ld   a,(unknown_6159)
17F5: FE 01         cp   $01
17F7: C8            ret  z
17F8: 3A 5E 61      ld   a,(unknown_615E)
17FB: FE 01         cp   $01
17FD: C8            ret  z
17FE: FD 21 9C 60   ld   iy,bags_coordinates_609C
1802: 06 12         ld   b,$12
1804: 2A 09 60      ld   hl,(player_logical_address_6009)
1807: 3E 24         ld   a,$24
1809: 32 7B 62      ld   (unknown_627B),a
180C: FD 7E 02      ld   a,(iy+$02)
180F: C5            push bc
1810: 47            ld   b,a
1811: 3A 0D 60      ld   a,(player_screen_600D)
1814: B8            cp   b
1815: C1            pop  bc
1816: C2 30 18      jp   nz,$1830
1819: FD 56 01      ld   d,(iy+$01)
181C: FD 5E 00      ld   e,(iy+$00)
181F: 13            inc  de
1820: 13            inc  de
1821: CD 45 19      call compute_backbuffer_tile_address_1945
1824: AF            xor  a
1825: E5            push hl
1826: ED 52         sbc  hl,de
1828: E1            pop  hl
1829: 28 13         jr   z,$183E
182B: CD 85 35      call $3585
182E: 28 0E         jr   z,$183E
1830: FD 23         inc  iy
1832: FD 23         inc  iy
1834: FD 23         inc  iy
1836: 3E 20         ld   a,$20
1838: 32 7B 62      ld   (unknown_627B),a
183B: 10 CF         djnz $180C
183D: C9            ret
183E: CD A4 19      call test_pickup_flag_19A4
1841: 78            ld   a,b
1842: FE 00         cp   $00
1844: C8            ret  z
1845: 3A CF 61      ld   a,(has_pick_61CF)
1848: FE 00         cp   $00
184A: 28 1F         jr   z,$186B
184C: FD E5         push iy
184E: E5            push hl
184F: 01 CF 61      ld   bc,has_pick_61CF
1852: FD 21 CC 61   ld   iy,unknown_61CC
1856: 3E 38         ld   a,$38
1858: FD 77 04      ld   (iy+$04),a
185B: 3E 28         ld   a,$28
185D: FD 77 05      ld   (iy+$05),a
1860: 3E E4         ld   a,$E4
1862: 32 D2 61      ld   (unknown_61D2),a
1865: CD BA 21      call $21BA
1868: E1            pop  hl
1869: FD E1         pop  iy
186B: DD 21 80 65   ld   ix,player_struct_6580
186F: 3E 3F         ld   a,$3F
1871: DD 77 1C      ld   (ix+$1c),a
1874: 3A 7B 62      ld   a,(unknown_627B)
1877: DD 77 1D      ld   (ix+$1d),a
187A: DD 7E 03      ld   a,(ix+$03)
187D: DD 77 1F      ld   (ix+$1f),a
1880: DD 7E 02      ld   a,(ix+$02)
1883: D6 08         sub  $08
1885: DD 77 1E      ld   (ix+$1e),a
1888: CD EB 3D      call can_pick_bag_3DEB
188B: 20 0A         jr   nz,$1897
188D: 21 A8 5B      ld   hl,$5BA8
1890: 22 40 61      ld   (unknown_pointer_6140),hl
1893: AF            xor  a
1894: 32 42 61      ld   (unknown_6142),a
	;; pickup money bag
1897: 3E 01         ld   a,$01
1899: 32 58 61      ld   (has_bag_6158),a
189C: FD 22 5C 61   ld   (unknown_615C),iy
18A0: FD 66 01      ld   h,(iy+$01)
18A3: FD 6E 00      ld   l,(iy+$00)
18A6: 22 F6 61      ld   (dropped_bag_screen_address_61F6),hl
18A9: AF            xor  a
18AA: 32 7E 62      ld   (unknown_627E),a
18AD: F3            di
18AE: FD 77 00      ld   (iy+$00),a
18B1: FD 77 01      ld   (iy+$01),a
18B4: FD 77 02      ld   (iy+$02),a
18B7: FB            ei
18B8: 3A 7B 62      ld   a,(unknown_627B)
18BB: FE 24         cp   $24
18BD: 3E 00         ld   a,$00
18BF: 20 02         jr   nz,$18C3
18C1: 3E 01         ld   a,$01
18C3: 32 7C 62      ld   (player_has_blue_bag_flag_627C),a
18C6: C9            ret
18C7: 3A 7E 62      ld   a,(unknown_627E)
18CA: FE 07         cp   $07
18CC: D0            ret  nc
18CD: 2A F6 61      ld   hl,(dropped_bag_screen_address_61F6)
18D0: 7C            ld   a,h
18D1: FE 00         cp   $00
18D3: C8            ret  z
18D4: 7D            ld   a,l
18D5: E6 0F         and  $0F
18D7: FE 00         cp   $00
18D9: C8            ret  z
18DA: CD 2F 19      call $192F
18DD: CD 15 19      call $1915
18E0: 23            inc  hl
18E1: CD 2F 19      call $192F
18E4: CD 15 19      call $1915
18E7: 11 20 00      ld   de,$0020
18EA: 19            add  hl,de
18EB: CD 2F 19      call $192F
18EE: CD 15 19      call $1915
18F1: 2B            dec  hl
18F2: CD 2F 19      call $192F
18F5: CD 15 19      call $1915
18F8: 3A 7E 62      ld   a,(unknown_627E)
18FB: 3C            inc  a
18FC: 32 7E 62      ld   (unknown_627E),a
18FF: 3A 0D 60      ld   a,(player_screen_600D)
1902: FE 02         cp   $02
1904: CC E3 33      call z,$33E3
1907: C9            ret
1908: DD 7E 00      ld   a,(ix+$00)
190B: FE 01         cp   $01
190D: C8            ret  z
190E: 7E            ld   a,(hl)
190F: FE F0         cp   $F0
1911: D8            ret  c
1912: AF            xor  a
1913: 12            ld   (de),a
1914: C9            ret
1915: 06 1F         ld   b,$1F
1917: 7E            ld   a,(hl)
1918: FE 49         cp   $49
191A: 28 0A         jr   z,$1926
191C: FE 4A         cp   $4A
191E: 28 06         jr   z,$1926
1920: FE 4B         cp   $4B
1922: 28 02         jr   z,$1926
1924: 06 3F         ld   b,$3F
1926: E5            push hl
1927: 7C            ld   a,h
1928: C6 08         add  a,$08
192A: 67            ld   h,a
192B: 78            ld   a,b
192C: 77            ld   (hl),a
192D: E1            pop  hl
192E: C9            ret
192F: 7C            ld   a,h
1930: 57            ld   d,a
1931: 7D            ld   a,l
1932: 5F            ld   e,a
1933: CD 45 19      call compute_backbuffer_tile_address_1945
; copy tile data back to screen
1936: 1A            ld   a,(de)
1937: 77            ld   (hl),a
; loop until write succeeds...
; maybe video ram has issues?
1938: 1A            ld   a,(de)
1939: BE            cp   (hl)
193A: 20 FA         jr   nz,$1936
193C: E5            push hl
193D: 7C            ld   a,h
193E: C6 08         add  a,$08
1940: 67            ld   h,a
1941: AF            xor  a
1942: 77            ld   (hl),a
1943: E1            pop  hl
1944: C9            ret

compute_backbuffer_tile_address_1945:
1945: 3A 0D 60      ld   a,(player_screen_600D)
1948: FE 01         cp   $01
194A: 20 05         jr   nz,$1951
194C: 7A            ld   a,d
194D: D6 50         sub  $50
194F: 57            ld   d,a
1950: C9            ret
1951: FE 02         cp   $02
1953: 20 05         jr   nz,$195A
1955: 7A            ld   a,d
1956: D6 4C         sub  $4C
1958: 57            ld   d,a
1959: C9            ret
195A: 7A            ld   a,d
195B: D6 48         sub  $48
195D: 57            ld   d,a
195E: C9            ret

195F: 3A 9E 65      ld   a,(unknown_659E)
1962: FE E0         cp   $E0
1964: D0            ret  nc
1965: FE 18         cp   $18
1967: D8            ret  c
1968: CD A4 19      call test_pickup_flag_19A4
196B: 78            ld   a,b
196C: FE 00         cp   $00
196E: C8            ret  z
196F: DD 21 9C 65   ld   ix,unknown_659C
1973: FD 21 5A 61   ld   iy,unknown_615A
1977: 3A 0D 60      ld   a,(player_screen_600D)
197A: 32 98 60      ld   (screen_index_param_6098),a
197D: CD 8C 55      call compute_logical_address_from_xy_558c
1980: FB            ei
1981: 2B            dec  hl
1982: 7E            ld   a,(hl)
1983: E5            push hl
1984: CD B3 19      call $19B3
1987: E1            pop  hl
1988: C0            ret  nz
1989: 2B            dec  hl
198A: E5            push hl
198B: CD B3 19      call $19B3
198E: E1            pop  hl
198F: C0            ret  nz
1990: 11 21 00      ld   de,$0021
1993: 19            add  hl,de
1994: CD B3 19      call $19B3
1997: C0            ret  nz
1998: AF            xor  a
1999: 32 58 61      ld   (has_bag_6158),a
199C: 32 7C 62      ld   (player_has_blue_bag_flag_627C),a
199F: 3C            inc  a
19A0: 32 59 61      ld   (unknown_6159),a
19A3: C9            ret

test_pickup_flag_19A4:
19A4: 06 00         ld   b,$00
19A6: 3A 60 61      ld   a,(pickup_flag_6160)
19A9: FE 00         cp   $00
19AB: C8            ret  z
19AC: AF            xor  a
19AD: 32 60 61      ld   (pickup_flag_6160),a
19B0: 06 01         ld   b,$01
19B2: C9            ret
19B3: 21 D0 19      ld   hl,$19D0
19B6: 01 15 00      ld   bc,$0015
19B9: ED B9         cpdr
19BB: C9            ret
19BC: FF            rst  $38
19BD: F0            ret  p
19BE: F1            pop  af
19BF: F2 F3 F4      jp   p,$F4F3
19C2: F5            push af
19C3: F6 F7         or   $F7
19C5: EF            rst  $28
19C6: EE ED         xor  $ED
19C8: EC EB EA      call pe,$EAEB
19CB: DF            rst  $18
19CC: DE 4A         sbc  a,$4A
19CE: 49            ld   c,c
19CF: 4B            ld   c,e
19D0: E0            ret  po

	;; < $6095:	pointer on direction ($6027/$6067)
	;; < de:	guard screen address
	;; < $6098:	guard screen index
	;; < ix:	6035 or 6057 guard ????? what????
	;; < iy:	guard struct

analyse_guard_direction_change_19D1:
19D1: FD E5         push iy
19D3: FD 21 74 59   ld   iy,$5974 ; path "branch" address table
	;; loop to look for branches (ladders, etc)
19D7: FD 7E 00      ld   a,(iy+$00)
19DA: 67            ld   h,a
19DB: FD 7E 01      ld   a,(iy+$01)
19DE: 6F            ld   l,a
19DF: AF            xor  a
19E0: ED 52         sbc  hl,de	; get address distance between guard and
19E2: 28 17         jr   z,$19FB
19E4: FD 23         inc  iy
19E6: FD 23         inc  iy
19E8: FD 23         inc  iy
19EA: 3A 00 B8      ld   a,(io_read_shit_B800)
19ED: FD 7E 02      ld   a,(iy+$02)
19F0: FE FF         cp   $FF
19F2: 20 E3         jr   nz,$19D7
19F4: AF            xor  a
19F5: DD 77 11      ld   (ix+$11),a
19F8: FD E1         pop  iy
19FA: C9            ret

	;; branch found:	what do we decide??
19FB: DD E5         push ix
19FD: FD 22 4B 60   ld   (unknown_pointer_604B),iy
1A01: 3A 98 60      ld   a,(screen_index_param_6098) ; guard screen
1A04: 47            ld   b,a
1A05: 3A 0D 60      ld   a,(player_screen_600D)
1A08: B8            cp   b
1A09: 28 03         jr   z,$1A0E
	;; not same screen as player
1A0B: CD BD 1B      call $1BBD
	;; same screen as the player
1A0E: 06 08         ld   b,$08
1A10: DD 7E 11      ld   a,(ix+$11)
1A13: FE 01         cp   $01
1A15: CA 0B 1B      jp   z,$1B0B ;  bail out
	;; loop
1A18: DD 7E 07      ld   a,(ix+$07)
1A1B: FE 00         cp   $00
1A1D: C2 0B 1B      jp   nz,$1B0B ;  bail out
1A20: DD 23         inc  ix
1A22: 10 F4         djnz $1A18
1A24: DD E1         pop  ix
1A26: AF            xor  a
1A27: DD 77 15      ld   (ix+$15),a
1A2A: 3A 47 60      ld   a,(unknown_6047)
1A2D: FE 00         cp   $00
1A2F: CA 5C 1A      jp   z,$1A5C
1A32: 3A 82 65      ld   a,(player_x_6582)
1A35: 47            ld   b,a
1A36: FD E1         pop  iy
1A38: FD 7E 02      ld   a,(iy+$02) ;  guard x
1A3B: FD E5         push iy
1A3D: B8            cp   b
1A3E: F5            push af
1A3F: D4 10 1B      call nc,$1B10 ;  guard x < player x ?
1A42: F1            pop  af
1A43: DC 19 1B      call c,$1B19
1A46: 3A 83 65      ld   a,(player_y_6583)
1A49: 47            ld   b,a
1A4A: FD E1         pop  iy
1A4C: FD 7E 03      ld   a,(iy+$03)
1A4F: FD E5         push iy
1A51: B8            cp   b
1A52: F5            push af
1A53: DC 2B 1B      call c,$1B2B
1A56: F1            pop  af
1A57: D4 22 1B      call nc,$1B22
1A5A: 18 58         jr   $1AB4
1A5C: 3A 00 A0      ld   a,(vertical_beam_pos_A000)
1A5F: E5            push hl
1A60: 21 34 1B      ld   hl,direction_index_table_1B34
1A63: E6 03         and  $03	; random 0 1 2 3
1A65: 85            add  a,l
1A66: 6F            ld   l,a
1A67: 7C            ld   a,h
1A68: CE 00         adc  a,$00
1A6A: 67            ld   h,a
1A6B: 3A 00 B8      ld   a,(io_read_shit_B800)
1A6E: 7E            ld   a,(hl)	; turns to random 8 4 2 1 thanks to table @1B34
1A6F: C5            push bc
1A70: DD E5         push ix
1A72: DD 2A 95 60   ld   ix,(guard_direction_pointer_6095)
1A76: 47            ld   b,a	;  set 8 4 2 1 value to b
1A77: DD 7E 00      ld   a,(ix+$00) ; guard direction
	;; divide by 16
1A7A: CB 0F         rrc  a
1A7C: CB 0F         rrc  a
1A7E: CB 0F         rrc  a
1A80: CB 0F         rrc  a
	;; shift so guard current direction flag matches the 8 4 2 1 values computed by random
1A82: E6 0F         and  $0F
1A84: FE 01         cp   $01
1A86: 20 04         jr   nz,$1A8C
	;; a is "up"
1A88: 3E 02         ld   a,$02
1A8A: 18 16         jr   $1AA2
1A8C: FE 02         cp   $02
1A8E: 20 04         jr   nz,$1A94
1A90: 3E 01         ld   a,$01
1A92: 18 0E         jr   $1AA2
1A94: FE 04         cp   $04
1A96: 20 04         jr   nz,$1A9C
1A98: 3E 08         ld   a,$08
1A9A: 18 06         jr   $1AA2
1A9C: FE 08         cp   $08
1A9E: 20 02         jr   nz,$1AA2
1AA0: 3E 04         ld   a,$04
1AA2: B8            cp   b
1AA3: 20 07         jr   nz,$1AAC ; ok:	 random did not give the opposite
1AA5: DD E1         pop  ix
1AA7: C1            pop  bc
1AA8: E1            pop  hl
1AA9: C3 5C 1A      jp   $1A5C	; retry until random gives something else than the opposite
1AAC: DD E1         pop  ix
1AAE: 78            ld   a,b
1AAF: C1            pop  bc
1AB0: E1            pop  hl
1AB1: DD 77 15      ld   (ix+$15),a ;  save a
1AB4: AF            xor  a
1AB5: FD 2A 4B 60   ld   iy,(unknown_pointer_604B)
1AB9: FD 7E 02      ld   a,(iy+$02)
1ABC: CB 0F         rrc  a
1ABE: CB 0F         rrc  a
1AC0: CB 0F         rrc  a
1AC2: CB 0F         rrc  a
1AC4: 47            ld   b,a
1AC5: DD 7E 15      ld   a,(ix+$15) ;  restore a
1AC8: A0            and  b
1AC9: CB 0F         rrc  a
1ACB: 2A 91 60      ld   hl,(guard_logical_address_6091)
1ACE: 32 44 60      ld   (unknown_6044),a
1AD1: FD 21 94 65   ld   iy,guard_1_struct_6594
1AD5: FD 22 93 60   ld   (guard_struct_pointer_6093),iy
1AD9: 2A 95 60      ld   hl,(guard_direction_pointer_6095) ; contains guard direction pointer unknown_6027 or unknown_6067
1ADC: 30 05         jr   nc,$1AE3
1ADE: CD B3 1B      call set_guard_direction_up_1BB3
1AE1: 18 20         jr   $1B03
1AE3: CB 0F         rrc  a
1AE5: 30 05         jr   nc,$1AEC
1AE7: CD A9 1B      call set_guard_direction_down_1BA9
1AEA: 18 17         jr   $1B03
1AEC: CB 0F         rrc  a
1AEE: 30 05         jr   nc,$1AF5
1AF0: CD 8B 1B      call set_guard_direction_left_1B8B
1AF3: 18 07         jr   $1AFC
1AF5: CB 0F         rrc  a
1AF7: 30 0A         jr   nc,$1B03
1AF9: CD 6D 1B      call set_guard_direction_right_1B6D
1AFC: 3A 0B 60      ld   a,(way_clear_flag_600B)
1AFF: FE 02         cp   $02
1B01: 20 05         jr   nz,$1B08

1B03: 3E 01         ld   a,$01
1B05: DD 77 11      ld   (ix+$11),a
1B08: FD E1         pop  iy
1B0A: C9            ret
1B0B: DD E1         pop  ix
1B0D: FD E1         pop  iy
1B0F: C9            ret
1B10: DD 7E 15      ld   a,(ix+$15)
1B13: F6 04         or   $04
1B15: DD 77 15      ld   (ix+$15),a
1B18: C9            ret
1B19: DD 7E 15      ld   a,(ix+$15)
1B1C: F6 08         or   $08
1B1E: DD 77 15      ld   (ix+$15),a
1B21: C9            ret
1B22: DD 7E 15      ld   a,(ix+$15)
1B25: F6 01         or   $01
1B27: DD 77 15      ld   (ix+$15),a
1B2A: C9            ret
1B2B: DD 7E 15      ld   a,(ix+$15)
1B2E: F6 02         or   $02
1B30: DD 77 15      ld   (ix+$15),a
1B33: C9            ret

1B38: 2A 38 60      ld   hl,(guard_1_logical_address_6038)                                     
1B3B: 22 91 60      ld   (guard_logical_address_6091),hl
1B3E: FD 21 94 65   ld   iy,guard_1_struct_6594
1B42: FD 22 93 60   ld   (guard_struct_pointer_6093),iy
1B46: 21 27 60      ld   hl,guard_1_direction_6027
1B49: 22 95 60      ld   (guard_direction_pointer_6095),hl
1B4C: 3A 3C 60      ld   a,(guard_2_sees_player_right_603C)
1B4F: FE 00         cp   $00
1B51: C4 6D 1B      call nz,set_guard_direction_right_1B6D
1B54: 3A 3D 60      ld   a,(guard_2_sees_player_left_603D)
1B57: FE 00         cp   $00
1B59: C4 8B 1B      call nz,set_guard_direction_left_1B8B
1B5C: 3A 3E 60      ld   a,(guard_2_sees_player_up_603E)
1B5F: FE 00         cp   $00
1B61: C4 B3 1B      call nz,set_guard_direction_up_1BB3
1B64: 3A 3F 60      ld   a,(guard_2_sees_player_down_603F)
1B67: FE 00         cp   $00
1B69: C4 A9 1B      call nz,set_guard_direction_down_1BA9
1B6C: C9            ret


set_guard_direction_right_1B6D:
1B6D: 2A 91 60      ld   hl,(guard_logical_address_6091)
1B70: DD E5         push ix
1B72: DD 2A 93 60   ld   ix,(guard_struct_pointer_6093)
1B76: CD FA 0C      call character_can_walk_right_0CFA
1B79: DD E1         pop  ix
1B7B: 3A 0B 60      ld   a,(way_clear_flag_600B)
1B7E: FE 02         cp   $02
1B80: C0            ret  nz
1B81: E5            push hl
1B82: 2A 95 60      ld   hl,(guard_direction_pointer_6095)
1B85: AF            xor  a
1B86: CB FF         set  7,a	;  set direction to right
1B88: 77            ld   (hl),a
1B89: E1            pop  hl
1B8A: C9            ret

set_guard_direction_left_1B8B:
1B8B: 2A 91 60      ld   hl,(guard_logical_address_6091)
1B8E: DD E5         push ix
1B90: DD 2A 93 60   ld   ix,(guard_struct_pointer_6093)
1B94: CD 69 0D      call character_can_walk_left_0D69
1B97: DD E1         pop  ix
1B99: 3A 0B 60      ld   a,(way_clear_flag_600B)
1B9C: FE 02         cp   $02
1B9E: C0            ret  nz
1B9F: E5            push hl
1BA0: 2A 95 60      ld   hl,(guard_direction_pointer_6095)
1BA3: AF            xor  a
1BA4: CB F7         set  6,a	;  set direction to left
1BA6: 77            ld   (hl),a
1BA7: E1            pop  hl
1BA8: C9            ret

set_guard_direction_down_1ba9:
1BA9: AF            xor  a
1BAA: E5            push hl
1BAB: 2A 95 60      ld   hl,(guard_direction_pointer_6095)
1BAE: CB EF         set  5,a	; set direction to down
1BB0: 77            ld   (hl),a
1BB1: E1            pop  hl
1BB2: C9            ret

set_guard_direction_up_1BB3:
1BB3: AF            xor  a
1BB4: E5            push hl
1BB5: 2A 95 60      ld   hl,(guard_direction_pointer_6095)
1BB8: CB E7         set  4,a	;  set direction to up
1BBA: 77            ld   (hl),a
1BBB: E1            pop  hl
1BBC: C9            ret
	;; not the same screen as player:	 decide something?
	;; < b:	guard screen

1BBD: DD E5         push ix
1BBF: FD E5         push iy
1BC1: E5            push hl
1BC2: C5            push bc
1BC3: D5            push de
1BC4: 78            ld   a,b
1BC5: FE 01         cp   $01
1BC7: 20 06         jr   nz,$1BCF
	;; guard on first screen
	;;  address table for special locations of screen 1 which lead to screen 2 (up/down/left...)
	;; address (2 byte) + direction (1 byte). FF to end
1BC9: FD 21 10 5A   ld   iy,$5A10
1BCD: 18 1B         jr   $1BEA
1BCF: FE 02         cp   $02
1BD1: 20 13         jr   nz,$1BE6
	;; guard on middle screen
1BD3: 47            ld   b,a
1BD4: 3A 0D 60      ld   a,(player_screen_600D)
1BD7: B8            cp   b
1BD8: 30 06         jr   nc,$1BE0 ;  is it 1 or 3
1BDA: FD 21 3D 5A   ld   iy,$5A3D ;  address table for special locations of screen 2 which leads to screen 1
1BDE: 18 0A         jr   $1BEA
1BE0: FD 21 76 5A   ld   iy,$5A76 ;  address table for special locations of screen 2 which leads to screen 3
1BE4: 18 04         jr   $1BEA
	;; screen 3 to screen 2
1BE6: FD 21 AF 5A   ld   iy,$5AAF
	;; special locations loop where we do something
1BEA: D1            pop  de
1BEB: FD 7E 00      ld   a,(iy+$00)
1BEE: 67            ld   h,a
1BEF: FD 7E 01      ld   a,(iy+$01)
1BF2: 6F            ld   l,a
1BF3: AF            xor  a
1BF4: ED 52         sbc  hl,de
1BF6: 28 10         jr   z,$1C08
1BF8: FD 23         inc  iy
1BFA: FD 23         inc  iy
1BFC: FD 23         inc  iy
1BFE: FD 7E 02      ld   a,(iy+$02)
1C01: FE FF         cp   $FF
1C03: 20 E6         jr   nz,$1BEB

1C05: C3 26 1C      jp   $1C26	; special location not found:	do nothing
	;; special location found
1C08: FD 7E 02      ld   a,(iy+$02)
1C0B: FE 80         cp   $80
1C0D: 20 06         jr   nz,$1C15
1C0F: CD 6D 1B      call set_guard_direction_right_1B6D
1C12: C3 26 1C      jp   $1C26
1C15: FE 40         cp   $40
1C17: 20 06         jr   nz,$1C1F
1C19: CD 8B 1B      call set_guard_direction_left_1B8B
1C1C: C3 26 1C      jp   $1C26
1C1F: DD 2A 95 60   ld   ix,(guard_direction_pointer_6095)
1C23: DD 77 00      ld   (ix+$00),a ; don't change direction?
1C26: C1            pop  bc
1C27: E1            pop  hl
1C28: FD E1         pop  iy
1C2A: DD E1         pop  ix
1C2C: E1            pop  hl
1C2D: C3 0B 1B      jp   $1B0B
1C30: 3A 0D 60      ld   a,(player_screen_600D)
1C33: 47            ld   b,a
1C34: 3A 99 60      ld   a,(guard_1_screen_6099)
1C37: B8            cp   b
1C38: C0            ret  nz
1C39: DD 21 3D 60   ld   ix,guard_2_sees_player_left_603D
1C3D: 2A 38 60      ld   hl,(guard_1_logical_address_6038)
1C40: 01 E0 FF      ld   bc,$FFE0
1C43: 3A CF 61      ld   a,(has_pick_61CF)
1C46: FE 00         cp   $00
1C48: 3E 40         ld   a,$40
1C4A: 20 06         jr   nz,$1C52
1C4C: DD 21 3C 60   ld   ix,guard_2_sees_player_right_603C
1C50: 3E 80         ld   a,$80
1C52: 08            ex   af,af'
1C53: CD 33 1D      call is_way_clear_to_player_1D33
1C56: 2A 38 60      ld   hl,(guard_1_logical_address_6038)
1C59: DD 21 3C 60   ld   ix,guard_2_sees_player_right_603C
1C5D: 01 20 00      ld   bc,$0020
1C60: 3A CF 61      ld   a,(has_pick_61CF)
1C63: FE 00         cp   $00
1C65: 3E 80         ld   a,$80
1C67: 20 06         jr   nz,$1C6F
1C69: DD 21 3D 60   ld   ix,guard_2_sees_player_left_603D
1C6D: 3E 40         ld   a,$40
1C6F: 08            ex   af,af'
1C70: CD 33 1D      call is_way_clear_to_player_1D33
1C73: 2A 38 60      ld   hl,(guard_1_logical_address_6038)
1C76: 01 FF FF      ld   bc,$FFFF
1C79: 3E 10         ld   a,$10
1C7B: 08            ex   af,af'
1C7C: DD 21 3E 60   ld   ix,guard_2_sees_player_up_603E
1C80: CD 33 1D      call is_way_clear_to_player_1D33
1C83: 2A 38 60      ld   hl,(guard_1_logical_address_6038)
1C86: DD 21 3F 60   ld   ix,guard_2_sees_player_down_603F
1C8A: 01 01 00      ld   bc,$0001
1C8D: 3E 20         ld   a,$20
1C8F: 08            ex   af,af'
1C90: CD 33 1D      call is_way_clear_to_player_1D33
1C93: C9            ret

1C94: 2A 78 60      ld   hl,(guard_2_screen_address_6078)
1C97: 22 91 60      ld   (guard_logical_address_6091),hl
1C9A: FD 21 98 65   ld   iy,guard_2_struct_6598
1C9E: FD 22 93 60   ld   (guard_struct_pointer_6093),iy
1CA2: 21 67 60      ld   hl,guard_2_direction_6067
1CA5: 22 95 60      ld   (guard_direction_pointer_6095),hl
1CA8: 3A 7C 60      ld   a,(guard_1_sees_player_right_607C)
1CAB: FE 00         cp   $00
1CAD: C4 6D 1B      call nz,set_guard_direction_right_1B6D
1CB0: 3A 7D 60      ld   a,(guard_1_sees_player_left_607D)
1CB3: FE 00         cp   $00
1CB5: C4 8B 1B      call nz,set_guard_direction_left_1B8B
1CB8: 3A 7E 60      ld   a,(guard_1_sees_player_up_607E)
1CBB: FE 00         cp   $00
1CBD: C4 B3 1B      call nz,set_guard_direction_up_1BB3
1CC0: 3A 7F 60      ld   a,(guard_1_sees_player_down_607F)
1CC3: FE 00         cp   $00
1CC5: C4 A9 1B      call nz,set_guard_direction_down_1BA9
1CC8: C9            ret


1CC9: 3A 0D 60      ld   a,(player_screen_600D)
1CCC: 47            ld   b,a
1CCD: 3A 9A 60      ld   a,(guard_2_screen_609A)
1CD0: B8            cp   b
1CD1: C0            ret  nz

1CD2: DD 21 7D 60   ld   ix,guard_1_sees_player_left_607D
1CD6: 2A 78 60      ld   hl,(guard_2_screen_address_6078)
1CD9: 01 E0 FF      ld   bc,$FFE0

;; if player has pick reverts tests:	 if sees on the right, actually
;;  pretend he saw him on the left

1CDC: 3A CF 61      ld   a,(has_pick_61CF)
1CDF: FE 00         cp   $00
1CE1: 3E 40         ld   a,$40
1CE3: 20 06         jr   nz,$1CEB
1CE5: DD 21 7C 60   ld   ix,guard_1_sees_player_right_607C
1CE9: 3E 80         ld   a,$80
1CEB: 08            ex   af,af'
1CEC: CD 33 1D      call is_way_clear_to_player_1D33
1CEF: 2A 78 60      ld   hl,(guard_2_screen_address_6078)
1CF2: 01 20 00      ld   bc,$0020
1CF5: DD 21 7C 60   ld   ix,guard_1_sees_player_right_607C

;; if player has pick reverts tests:	 if sees on the left, actually
;;  pretend he saw him on the right

1CF9: 3A CF 61      ld   a,(has_pick_61CF)
1CFC: FE 00         cp   $00
1CFE: 3A B2 91      ld   a,($91B2)
1D01: 32 72 62      ld   (unknown_6272),a
1D04: 3E 80         ld   a,$80
1D06: 20 06         jr   nz,$1D0E
1D08: DD 21 7D 60   ld   ix,guard_1_sees_player_left_607D
1D0C: 3E 40         ld   a,$40
1D0E: 08            ex   af,af'
1D0F: CD 33 1D      call is_way_clear_to_player_1D33

	;; up and down (note that having the pick has no effect on those tests)
1D12: 2A 78 60      ld   hl,(guard_2_screen_address_6078)
1D15: 01 FF FF      ld   bc,$FFFF
1D18: 3E 10         ld   a,$10
1D1A: 08            ex   af,af'
1D1B: DD 21 7E 60   ld   ix,guard_1_sees_player_up_607E
1D1F: CD 33 1D      call is_way_clear_to_player_1D33
1D22: 2A 78 60      ld   hl,(guard_2_screen_address_6078)
1D25: DD 21 7F 60   ld   ix,guard_1_sees_player_down_607F
1D29: 01 01 00      ld   bc,$0001
1D2C: 3E 20         ld   a,$20
1D2E: 08            ex   af,af'
1D2F: CD 33 1D      call is_way_clear_to_player_1D33
1D32: C9            ret

;;; test if there's something blocking the view from guard to player
;;; works for all directions (up,down,left,right)
;;;
;;; params:
;;; a:	direction value to set if test works ($40:to left, $80:to right, $10:up, $20:down)
;;; ix: store a or 0 in (ix)
;;; hl: screen address
;;; bc: direction increment (1:	down, -1: up, 32: right, -32: left)

is_way_clear_to_player_1D33:
1D33: 2B            dec  hl
1D34: 2B            dec  hl
1D35: AF            xor  a
1D36: DD 77 00      ld   (ix+$00),a ; set "visible" flag to 0
1D39: ED 4A         adc  hl,bc
1D3B: 7E            ld   a,(hl)
1D3C: C5            push bc
1D3D: 06 08         ld   b,$08
	;; 8 tests
1D3F: FD 21 6B 1D   ld   iy,$1D6B
1D43: FD BE 00      cp   (iy+$00)
1D46: 28 06         jr   z,$1D4E
1D48: FD 23         inc  iy
1D4A: 10 F7         djnz $1D43

1D4C: C1            pop  bc
1D4D: C9            ret
1D4E: C1            pop  bc
1D4F: E5            push hl
1D50: ED 5B 09 60   ld   de,(player_logical_address_6009)
1D54: 1B            dec  de
1D55: 1B            dec  de
1D56: AF            xor  a
1D57: ED 52         sbc  hl,de
1D59: E1            pop  hl
1D5A: 28 0A         jr   z,$1D66
1D5C: E5            push hl
1D5D: 13            inc  de
1D5E: AF            xor  a
1D5F: ED 52         sbc  hl,de
1D61: E1            pop  hl
1D62: 28 02         jr   z,$1D66
1D64: 18 CF         jr   $1D35
1D66: 08            ex   af,af'
1D67: DD 77 00      ld   (ix+$00),a
1D6A: C9            ret


1D73: 3A 29 60      ld   a,(player_in_wagon_flag_6029)
1D76: FE 01         cp   $01
1D78: 28 08         jr   z,$1D82
1D7A: 3A 25 60      ld   a,(player_death_flag_6025)
1D7D: FE 01         cp   $01
1D7F: CA 50 1F      jp   z,$1F50
1D82: AF            xor  a
1D83: C9            ret

wagon_player_collision_1D84:
1D84: 3A 25 60      ld   a,(player_death_flag_6025)
1D87: FE 01         cp   $01
1D89: C8            ret  z		; return immediately if player dies
1D8A: 3A 29 60      ld   a,(player_in_wagon_flag_6029)
1D8D: FE 01         cp   $01
1D8F: C8            ret  z
1D90: DD 21 82 65   ld   ix,player_x_6582
1D94: FD 21 8A 65   ld   iy,wagon_data_658A
1D98: 21 22 60      ld   hl,unknown_6022
1D9B: 11 04 00      ld   de,$0004
1D9E: 3A 2A 60      ld   a,(player_gripping_handle_602A)
1DA1: FE 01         cp   $01
1DA3: C8            ret  z	;  no collision if gripping handle

; all 3 wagons
1DA4: CD B4 1D      call one_wagon_player_collision_1DB4
1DA7: 23            inc  hl
1DA8: FD 19         add  iy,de
1DAA: CD B4 1D      call one_wagon_player_collision_1DB4
1DAD: 23            inc  hl
1DAE: FD 19         add  iy,de
1DB0: CD B4 1D      call one_wagon_player_collision_1DB4
1DB3: C9            ret

one_wagon_player_collision_1DB4:
1DB4: DD 7E 01      ld   a,(ix+$01)
1DB7: 3C            inc  a
1DB8: FD BE 01      cp   (iy+$01)
1DBB: C0            ret  nz
1DBC: FD 7E 00      ld   a,(iy+$00)
1DBF: D6 0D         sub  $0D
1DC1: 47            ld   b,a
1DC2: C6 04         add  a,$04
1DC4: 4F            ld   c,a
;; collision with wagon arriving by the right
1DC5: CD DE 1D      call $1DDE
1DC8: 32 25 60      ld   (player_death_flag_6025),a
1DCB: FE 01         cp   $01
1DCD: C8            ret  z
1DCE: FD 7E 00      ld   a,(iy+$00)
1DD1: C6 0A         add  a,$0A
1DD3: 47            ld   b,a
1DD4: C6 04         add  a,$04
1DD6: 4F            ld   c,a
;; collision with wagon arriving by the left
1DD7: CD DE 1D      call $1DDE
1DDA: 32 25 60      ld   (player_death_flag_6025),a
1DDD: C9            ret

1DDE: DD 7E 00      ld   a,(ix+$00)
1DE1: B8            cp   b
1DE2: 38 06         jr   c,$1DEA
1DE4: B9            cp   c
1DE5: 30 03         jr   nc,$1DEA
;; collision with wagon
1DE7: 3E 01         ld   a,$01
1DE9: C9            ret
;; no collision
1DEA: AF            xor  a
1DEB: C9            ret

; display PLAYER 1
display_player_ids_and_credit_1dec:
1DEC: 11 80 56      ld   de,$5680
1DEF: 21 A0 93      ld   hl,$93A0
1DF2: CD F9 30      call display_text_30F9
; display PLAYER 1 again
1DF5: 11 80 56      ld   de,$5680
1DF8: 21 20 91      ld   hl,$9120
; display BONUS
1DFB: CD F9 30      call display_text_30F9
1DFE: 11 05 57      ld   de,$5705
1E01: 21 40 92      ld   hl,$9240
1E04: CD F9 30      call display_text_30F9
1E07: 3E 02         ld   a,$02
1E09: 21 40 90      ld   hl,$9040
1E0C: 77            ld   (hl),a
; display CREDIT followed by number of credits
1E0D: 11 89 56      ld   de,$5689
1E10: 21 9F 91      ld   hl,$919F
1E13: CD F9 30      call display_text_30F9
* credit digits seems useless: wrong and overwritten
* by the real value read from number_of_credits_6000
1E16: 3A 04 60      ld   a,(fake_credit_digit_6004)
1E19: 32 9F 90      ld   ($909F),a
1E1C: 3A 05 60      ld   a,(fake_credit_digit_6005)
1E1F: 32 BF 90      ld   ($90BF),a
* color all
1E22: CD 26 1E      call $1E26
1E25: C9            ret

1E26: 3E 02         ld   a,$02
1E28: 21 40 98      ld   hl,$9840
1E2B: CD 05 56      call write_attribute_on_line_5605
1E2E: 3E 08         ld   a,$08
1E30: 21 5F 98      ld   hl,$985F
1E33: CD 05 56      call write_attribute_on_line_5605
1E36: 3E 05         ld   a,$05
1E38: 21 41 98      ld   hl,$9841
1E3B: CD 05 56      call write_attribute_on_line_5605
1E3E: C9            ret

1E3F: 3A 4D 60      ld   a,(fall_height_604D)
1E42: FE 12         cp   $12
1E44: 38 1E         jr   c,$1E64
1E46: 3E 01         ld   a,$01
1E48: 32 4E 60      ld   (fatal_fall_height_reached_604E),a
1E4B: 2A 09 60      ld   hl,(player_logical_address_6009)
1E4E: 7E            ld   a,(hl)
1E4F: FE F8         cp   $F8
1E51: E5            push hl
1E52: 21 67 1E      ld   hl,$1E67
1E55: 01 02 00      ld   bc,$0002
1E58: ED B9         cpdr
1E5A: E1            pop  hl
1E5B: 20 0B         jr   nz,$1E68
1E5D: 3A 14 60      ld   a,(unknown_6014)
1E60: FE 01         cp   $01
1E62: 28 0C         jr   z,$1E70
1E64: AF            xor  a
1E65: C9            ret

1E68: 3A 83 65      ld   a,(player_y_6583)
1E6B: D6 02         sub  $02
1E6D: 32 83 65      ld   (player_y_6583),a
1E70: AF            xor  a
1E71: 32 08 60      ld   (unknown_6008),a
1E74: CD 50 1F      call $1F50
1E77: 3E 01         ld   a,$01
1E79: C9            ret

1E7A: 3A 54 60      ld   a,(gameplay_allowed_6054)
1E7D: FE 01         cp   $01
1E7F: 28 0C         jr   z,$1E8D
1E81: 3A 00 60      ld   a,(number_of_credits_6000)
1E84: FE 00         cp   $00
1E86: 28 06         jr   z,$1E8E
1E88: 3E 01         ld   a,$01
1E8A: 32 53 60      ld   (unknown_6053),a
1E8D: C9            ret
1E8E: 3E 00         ld   a,$00
1E90: 32 53 60      ld   (unknown_6053),a
1E93: C9            ret

init_new_game_1E94:
1E94: 3A 10 62      ld   a,(unknown_6210)
1E97: FE 01         cp   $01
1E99: 20 0F         jr   nz,$1EAA
1E9B: CD EB 3D      call can_pick_bag_3DEB
1E9E: 20 0A         jr   nz,$1EAA
1EA0: 21 00 50      ld   hl,$5000
1EA3: 22 40 61      ld   (unknown_pointer_6140),hl
1EA6: AF            xor  a
1EA7: 32 42 61      ld   (unknown_6142),a
1EAA: AF            xor  a
1EAB: 32 03 A0      ld   ($A003),a
1EAE: CD 4C 28      call display_maze_284c
1EB1: 3E 01         ld   a,$01
1EB3: 32 16 60      ld   (unknown_6016),a
1EB6: CD EC 1D      call display_player_ids_and_credit_1dec

	;; init player coordinates
1EB9: 3E 01         ld   a,$01
1EBB: 32 0D 60      ld   (player_screen_600D),a
1EBE: 32 03 A0      ld   ($A003),a
1EC1: 3E 20         ld   a,$20
1EC3: 21 80 65      ld   hl,player_struct_6580
1EC6: 77            ld   (hl),a
1EC7: 23            inc  hl
1EC8: 3E 08         ld   a,$08
1ECA: 77            ld   (hl),a
1ECB: 23            inc  hl
1ECC: 3E 29         ld   a,$29
1ECE: 77            ld   (hl),a
1ECF: 23            inc  hl
1ED0: 3E E0         ld   a,$E0
1ED2: 77            ld   (hl),a
1ED3: 32 29 60      ld   (player_in_wagon_flag_6029),a
1ED6: 3E 40         ld   a,$40
1ED8: 32 65 61      ld   (unknown_6165),a
1EDB: 3E C8         ld   a,$C8
1EDD: 32 66 61      ld   (unknown_6166),a

1EE0: 11 C7 61      ld   de,holds_barrow_61C7
1EE3: 21 38 1F      ld   hl,$1F38
1EE6: 01 18 00      ld   bc,$0018
1EE9: ED B0         ldir
1EEB: 3E 40         ld   a,$40
1EED: 32 E8 61      ld   (time_61E8),a
1EF0: 3E 01         ld   a,$01
1EF2: 32 86 62      ld   (extra_life_awarded_6286),a
1EF5: 32 19 60      ld   (unknown_6019),a
1EF8: 3E B0         ld   a,$B0
1EFA: 32 9A 65      ld   (guard_2_x_659A),a
1EFD: AF            xor  a
1EFE: 32 97 60      ld   (unknown_6097),a
1F01: 32 88 62      ld   (unknown_6288),a
1F04: 32 08 60      ld   (unknown_6008),a
1F07: 32 13 60      ld   (unknown_6013),a
1F0A: 32 29 60      ld   (player_in_wagon_flag_6029),a
1F0D: 32 2A 60      ld   (player_gripping_handle_602A),a
1F10: 32 4E 60      ld   (fatal_fall_height_reached_604E),a
1F13: 32 77 60      ld   (unknown_6077),a
1F16: 32 28 60      ld   (player_controls_frozen_6028),a
1F19: 32 E0 61      ld   (pickaxe_timer_duration_61E0),a
1F1C: 32 E1 61      ld   (unknown_61E1),a
1F1F: 32 14 60      ld   (unknown_6014),a
1F22: 32 13 60      ld   (unknown_6013),a
1F25: 3A C4 61      ld   a,(barrow_start_screen_address_61C4)
1F28: FE 00         cp   $00
1F2A: 28 05         jr   z,$1F31
1F2C: E6 02         and  $02
1F2E: FE 02         cp   $02
1F30: C8            ret  z
1F31: 21 C2 91      ld   hl,$91C2
1F34: 22 C4 61      ld   (barrow_start_screen_address_61C4),hl
1F37: C9            ret


1F50: 3E 01         ld   a,$01
1F52: 32 F1 61      ld   (unknown_61F1),a
1F55: CD 8C 3B      call check_remaining_bags_3BBC
1F58: 79            ld   a,c
1F59: FE 01         cp   $01
1F5B: CC 4F 35      call z,set_bags_coordinates_hard_level_354f
1F5E: 3A 7C 61      ld   a,(current_player_617C)
1F61: 32 6C 62      ld   (unknown_626C),a
1F64: 2A 09 60      ld   hl,(player_logical_address_6009)
1F67: FD 21 08 60   ld   iy,unknown_6008
1F6B: DD 21 80 65   ld   ix,player_struct_6580
1F6F: CD 05 26      call $2605
1F72: 3E 01         ld   a,$01
1F74: 32 51 61      ld   (unknown_6151),a
1F77: 32 00 A0      ld   (interrupt_control_A000),a
1F7A: 21 5E 04      ld   hl,$045E
1F7D: 22 54 61      ld   (unknown_6154),hl
1F80: 21 F7 3E      ld   hl,$3EF7
1F83: AF            xor  a
1F84: 32 52 61      ld   (unknown_6152),a
1F87: FB            ei
1F88: CD 18 20      call copy_to_61bd_2018
1F8B: 21 38 5B      ld   hl,$5B38
1F8E: 22 40 61      ld   (unknown_pointer_6140),hl
1F91: AF            xor  a
1F92: 32 42 61      ld   (unknown_6142),a
1F95: 3A 52 61      ld   a,(unknown_6152)
1F98: FE 01         cp   $01
1F9A: 20 F9         jr   nz,$1F95
1F9C: CD 26 20      call start_new_life_2026
1F9F: DD 21 9C 65   ld   ix,unknown_659C
1FA3: DD 77 00      ld   (ix+$00),a
1FA6: DD 77 01      ld   (ix+$01),a
1FA9: DD 77 02      ld   (ix+$02),a
1FAC: 3E FF         ld   a,$FF
1FAE: DD 77 03      ld   (ix+$03),a
1FB1: AF            xor  a
1FB2: 32 58 61      ld   (has_bag_6158),a
1FB5: 32 C7 61      ld   (holds_barrow_61C7),a
1FB8: 3A 7D 61      ld   a,(unknown_617D)
1FBB: FE 01         cp   $01
1FBD: 28 14         jr   z,$1FD3
1FBF: 3A 7C 61      ld   a,(current_player_617C)
1FC2: C6 01         add  a,$01
1FC4: E6 01         and  $01
1FC6: 32 7C 61      ld   (current_player_617C),a
1FC9: 3A 7D 61      ld   a,(unknown_617D)
1FCC: 47            ld   b,a
1FCD: FE 02         cp   $02
1FCF: 78            ld   a,b
1FD0: CC 70 2A      call z,$2A70
1FD3: 3A 56 60      ld   a,(lives_6056)
1FD6: FE 00         cp   $00
1FD8: 20 1B         jr   nz,$1FF5
1FDA: 3A 7C 61      ld   a,(current_player_617C)
1FDD: C6 01         add  a,$01
1FDF: E6 01         and  $01
1FE1: 32 7C 61      ld   (current_player_617C),a
1FE4: 3A 7D 61      ld   a,(unknown_617D)
1FE7: 47            ld   b,a
1FE8: FE 02         cp   $02
1FEA: 78            ld   a,b
1FEB: CC 70 2A      call z,$2A70
1FEE: 3A 56 60      ld   a,(lives_6056)
1FF1: FE 00         cp   $00
1FF3: 28 67         jr   z,$205C
1FF5: 3D            dec  a
1FF6: 32 56 60      ld   (lives_6056),a
1FF9: CD 91 35      call $3591
1FFC: AF            xor  a
1FFD: 32 08 60      ld   (unknown_6008),a
2000: 32 4E 60      ld   (fatal_fall_height_reached_604E),a
2003: 32 4D 60      ld   (fall_height_604D),a
2006: 32 8F 60      ld   (unknown_608F),a
2009: 32 77 60      ld   (unknown_6077),a
200C: 32 37 60      ld   (unknown_6037),a
200F: 32 4F 60      ld   (unknown_604F),a
2012: CD 57 29      call $2957
2015: 3E 01         ld   a,$01
2017: C9            ret

copy_to_61bd_2018:
2018: 11 BD 61      ld   de,unknown_61BD
201B: 01 06 00      ld   bc,$0006
201E: ED B0         ldir
2020: 3E 01         ld   a,$01
2022: 32 F3 61      ld   (unknown_61F3),a
2025: C9            ret

start_new_life_2026:
2026: DD 21 44 61   ld   ix,unknown_6144
202A: 3E 00         ld   a,$00
202C: 06 06         ld   b,$06
202E: CD 54 20      call memset_2054 ;  clear region 6144-6144+6
2031: AF            xor  a
; set everything player-related to 0
2032: 32 52 61      ld   (unknown_6152),a
2035: 32 51 61      ld   (unknown_6151),a
2038: 32 25 60      ld   (player_death_flag_6025),a
203B: 32 28 60      ld   (player_controls_frozen_6028),a
203E: 32 4E 60      ld   (fatal_fall_height_reached_604E),a
2041: 32 29 60      ld   (player_in_wagon_flag_6029),a
2044: 32 13 60      ld   (unknown_6013),a
2047: 32 4D 60      ld   (fall_height_604D),a
204A: 32 59 61      ld   (unknown_6159),a
204D: 32 5E 61      ld   (unknown_615E),a
2050: 32 C7 61      ld   (holds_barrow_61C7),a
2053: C9            ret

	;; < b number of bytes to set to a
memset_2054
2054: DD 77 00      ld   (ix+$00),a
2057: DD 23         inc  ix
2059: 10 F9         djnz $2054
205B: C9            ret

205C: 21 6E 92      ld   hl,$926E
205F: 11 A1 56      ld   de,$56A1
2062: CD F9 30      call display_text_30F9
2065: AF            xor  a
2066: 32 54 60      ld   (gameplay_allowed_6054),a
2069: 06 0A         ld   b,$0A
206B: 21 00 30      ld   hl,$3000
206E: 2B            dec  hl
206F: FB            ei
2070: 3E 01         ld   a,$01
2072: 32 53 60      ld   (unknown_6053),a
2075: 32 F1 61      ld   (unknown_61F1),a
2078: 7C            ld   a,h
2079: FE 00         cp   $00
207B: 20 F1         jr   nz,$206E
207D: 10 EC         djnz $206B
207F: CD 03 2D      call $2D03
2082: AF            xor  a
2083: 32 10 62      ld   (unknown_6210),a
2086: 3A 00 60      ld   a,(number_of_credits_6000)
2089: FE 00         cp   $00
208B: 20 3C         jr   nz,$20C9
208D: CD 03 21      call $2103
2090: 11 AC 56      ld   de,$56AC
2093: 21 5A 93      ld   hl,$935A
2096: CD F9 30      call display_text_30F9
2099: 11 E6 20      ld   de,$20E6
209C: 21 B5 93      ld   hl,$93B5
209F: CD D9 55      call display_text_55d9
20A2: 3E 0E         ld   a,$0E
20A4: 21 9A 98      ld   hl,$989A
20A7: CD 05 56      call write_attribute_on_line_5605
20AA: 3E 03         ld   a,$03
20AC: 21 55 98      ld   hl,$9855
20AF: CD 05 56      call write_attribute_on_line_5605
20B2: 3E 11         ld   a,$11
20B4: 32 B5 9B      ld   ($9BB5),a
20B7: CD 8D 2F      call $2F8D
20BA: 3A B5 91      ld   a,($91B5)
20BD: FE 1F         cp   $1F
20BF: 20 F9         jr   nz,$20BA
20C1: 3E 01         ld   a,$01
20C3: 32 00 A0      ld   (interrupt_control_A000),a
20C6: CD 34 2C      call $2C34
20C9: F3            di
20CA: CD 5B 35      call set_bags_coordinates_355b
20CD: CD 67 35      call set_bags_coordinates_3567
20D0: CD 63 2A      call $2A63
20D3: AF            xor  a
20D4: 32 53 60      ld   (unknown_6053),a
20D7: 32 F1 61      ld   (unknown_61F1),a
20DA: 3A 00 60      ld   a,(number_of_credits_6000)
20DD: FE 00         cp   $00
20DF: CC 00 37      call z,play_intro_3700
20E2: FB            ei
20E3: 3E 01         ld   a,$01
20E5: C9            ret

2103: 3E 00         ld   a,$00
2105: 32 03 A0      ld   ($A003),a
2108: CD 00 2A      call clear_screen_2a00
210B: 3E 30         ld   a,$30
210D: CD EC 29      call change_attribute_everywhere_29ec
2110: 06 01         ld   b,$01
2112: 21 80 65      ld   hl,player_struct_6580
2115: 3E 00         ld   a,$00
2117: CD F1 29      call $29F1
211A: CD EC 1D      call display_player_ids_and_credit_1dec
211D: 3E 01         ld   a,$01
211F: 32 03 A0      ld   ($A003),a
2122: C9            ret
;; put random direction (amongst $80,$40,$20,$10) in ($6095,ind)
choose_guard_random_direction_2123:
2123: 3A 00 A0      ld   a,(vertical_beam_pos_A000)   ; random 0-3 direction
2126: 21 70 59      ld   hl,direction_table_5970
2129: E6 03         and  $03
212B: 85            add  a,l
212C: 6F            ld   l,a
212D: 7C            ld   a,h
212E: CE 00         adc  a,$00
2130: 67            ld   h,a
2131: 7E            ld   a,(hl)
2132: 2A 95 60      ld   hl,(guard_direction_pointer_6095)
2135: 77            ld   (hl),a
2136: C9            ret

2137: 3A 59 61      ld   a,(unknown_6159)
213A: FE 01         cp   $01
213C: C8            ret  z
213D: 3A 5E 61      ld   a,(unknown_615E)
2140: FE 01         cp   $01
2142: C8            ret  z
2143: 0A            ld   a,(bc)
2144: D9            exx
2145: FE 00         cp   $00
2147: C2 A7 21      jp   nz,$21A7
214A: 2A 09 60      ld   hl,(player_logical_address_6009)
214D: 3A 0D 60      ld   a,(player_screen_600D)
2150: FD BE 02      cp   (iy+$02)
2153: C0            ret  nz
2154: FD 56 01      ld   d,(iy+$01)
2157: FD 5E 00      ld   e,(iy+$00)
215A: D5            push de
215B: 13            inc  de
215C: 13            inc  de
215D: CD 45 19      call compute_backbuffer_tile_address_1945
2160: E5            push hl
2161: AF            xor  a
2162: ED 52         sbc  hl,de
2164: E1            pop  hl
2165: 28 07         jr   z,$216E
2167: CD 85 35      call $3585
216A: 28 02         jr   z,$216E
216C: D1            pop  de
216D: C9            ret
216E: D1            pop  de
216F: CD A4 19      call test_pickup_flag_19A4
2172: 78            ld   a,b
2173: FE 00         cp   $00
2175: C8            ret  z
2176: 62            ld   h,d
2177: 6B            ld   l,e
2178: 22 F6 61      ld   (dropped_bag_screen_address_61F6),hl
217B: AF            xor  a
217C: 32 7E 62      ld   (unknown_627E),a
217F: DD 21 80 65   ld   ix,player_struct_6580
2183: FD 7E 04      ld   a,(iy+$04)
2186: DD 77 1C      ld   (ix+$1c),a
2189: FD 7E 05      ld   a,(iy+$05)
218C: DD 77 1D      ld   (ix+$1d),a
218F: AF            xor  a
2190: FD 77 00      ld   (iy+$00),a
2193: FD 77 01      ld   (iy+$01),a
2196: FD 7E 04      ld   a,(iy+$04)
2199: FE 37         cp   $37
219B: 20 05         jr   nz,$21A2
219D: 3E 01         ld   a,$01
219F: FD 77 14      ld   (iy+$14),a
21A2: 3E 01         ld   a,$01
21A4: D9            exx
21A5: 02            ld   (bc),a
21A6: C9            ret
21A7: FD 7E 00      ld   a,(iy+$00)
21AA: FE 00         cp   $00
21AC: C0            ret  nz
21AD: 3A 82 65      ld   a,(player_x_6582)
21B0: FE D0         cp   $D0
21B2: D0            ret  nc
21B3: CD A4 19      call test_pickup_flag_19A4
21B6: 78            ld   a,b
21B7: FE 00         cp   $00
21B9: C8            ret  z

21BA: DD 21 9C 65   ld   ix,unknown_659C
21BE: 3A 0D 60      ld   a,(player_screen_600D)
21C1: 32 98 60      ld   (screen_index_param_6098),a
21C4: CD 8C 55      call compute_logical_address_from_xy_558c
21C7: E5            push hl
21C8: 3A 0D 60      ld   a,(player_screen_600D)
21CB: FD 77 02      ld   (iy+$02),a
21CE: CD 2D 22      call convert_logical_to_screen_address_222d
21D1: 67            ld   h,a
21D2: AF            xor  a
21D3: 7D            ld   a,l
21D4: D6 22         sub  $22
21D6: 6F            ld   l,a
21D7: 7C            ld   a,h
21D8: DE 00         sbc  a,$00
21DA: 67            ld   h,a
21DB: FD 75 00      ld   (iy+$00),l
21DE: FD 74 01      ld   (iy+$01),h
21E1: 3A 0D 60      ld   a,(player_screen_600D)
21E4: FD 77 02      ld   (iy+$02),a
21E7: C5            push bc
21E8: CD 85 3C      call test_non_blocking_tiles_3c85
21EB: 78            ld   a,b
21EC: C1            pop  bc
21ED: FE 00         cp   $00
21EF: CA B7 3C      jp   z,$3CB7
21F2: E1            pop  hl
21F3: 7E            ld   a,(hl)
21F4: FE E0         cp   $E0
21F6: E5            push hl
21F7: CA B7 3C      jp   z,$3CB7
21FA: E1            pop  hl
21FB: E5            push hl
21FC: AF            xor  a
21FD: 7D            ld   a,l
21FE: D6 20         sub  $20
2200: 7C            ld   a,h
2201: DE 00         sbc  a,$00
2203: 67            ld   h,a
2204: E1            pop  hl
2205: 7E            ld   a,(hl)
2206: FE E0         cp   $E0
2208: C8            ret  z
2209: D9            exx
220A: 3A C7 61      ld   a,(holds_barrow_61C7)
220D: FE 01         cp   $01
220F: 20 05         jr   nz,$2216
2211: 3E 28         ld   a,$28
2213: 08            ex   af,af'
2214: 18 03         jr   $2219
2216: 3E 20         ld   a,$20
2218: 08            ex   af,af'
2219: AF            xor  a
221A: 02            ld   (bc),a
221B: FD 6E 00      ld   l,(iy+$00)
221E: FD 66 01      ld   h,(iy+$01)
2221: FD 7E 06      ld   a,(iy+$06)
2224: CD 17 34      call draw_wheelbarrow_tiles_3417
2227: 3E FF         ld   a,$FF
2229: 32 9F 65      ld   (unknown_659F),a
222C: C9            ret
convert_logical_to_screen_address_222d:
222D: FE 01         cp   $01
222F: 20 04         jr   nz,$2235
2231: 7C            ld   a,h
2232: C6 50         add  a,$50
2234: C9            ret
2235: FE 02         cp   $02
2237: 20 04         jr   nz,$223D
2239: 7C            ld   a,h
223A: C6 4C         add  a,$4C
223C: C9            ret
223D: 7C            ld   a,h
223E: C6 48         add  a,$48
2240: C9            ret
2241: FD 21 56 61   ld   iy,unknown_6156
2245: FD 7E 00      ld   a,(iy+$00)
2248: FE 01         cp   $01
224A: C8            ret  z
224B: 3A 99 60      ld   a,(guard_1_screen_6099)
224E: 32 98 60      ld   (screen_index_param_6098),a
2251: DD E5         push ix
2253: 21 00 05      ld   hl,$0500
2256: CD 90 5C      call add_to_score_5C90
2259: 21 09 3F      ld   hl,$3F09
225C: CD 18 20      call copy_to_61bd_2018
225F: DD E1         pop  ix
2261: CD BE 3D      call $3DBE
2264: AF            xor  a
2265: 32 57 60      ld   (unknown_6057),a
2268: 3E 21         ld   a,$21
226A: 32 94 65      ld   (guard_1_struct_6594),a
226D: 2A 38 60      ld   hl,(guard_1_logical_address_6038)
2270: FD 21 37 60   ld   iy,unknown_6037
2274: DD 21 94 65   ld   ix,guard_1_struct_6594
2278: CD 05 26      call $2605
227B: C9            ret
227C: FD 21 57 61   ld   iy,unknown_6157
2280: FD 7E 00      ld   a,(iy+$00)
2283: FE 01         cp   $01
2285: C8            ret  z
2286: 3A 9A 60      ld   a,(guard_2_screen_609A)
2289: 32 98 60      ld   (screen_index_param_6098),a
228C: DD E5         push ix
228E: 21 00 05      ld   hl,$0500
2291: CD 90 5C      call add_to_score_5C90
2294: 21 09 3F      ld   hl,$3F09
2297: CD 18 20      call copy_to_61bd_2018
229A: DD E1         pop  ix
229C: CD BE 3D      call $3DBE
229F: AF            xor  a
22A0: 32 97 60      ld   (unknown_6097),a
22A3: 3E 21         ld   a,$21
22A5: 32 98 65      ld   (guard_2_struct_6598),a
22A8: 2A 78 60      ld   hl,(guard_2_screen_address_6078)
22AB: FD 21 77 60   ld   iy,unknown_6077
22AF: DD 21 98 65   ld   ix,guard_2_struct_6598
22B3: CD 05 26      call $2605
22B6: C9            ret
22B7: C5            push bc
22B8: FD E5         push iy
22BA: DD E5         push ix
22BC: 06 03         ld   b,$03
22BE: DD 21 CC 61   ld   ix,unknown_61CC
22C2: DD 7E 00      ld   a,(ix+$00)
22C5: 08            ex   af,af'
22C6: FD 7E 00      ld   a,(iy+$00)
22C9: DD 77 00      ld   (ix+$00),a
22CC: 08            ex   af,af'
22CD: FD 77 00      ld   (iy+$00),a
22D0: DD 23         inc  ix
22D2: FD 23         inc  iy
22D4: 10 EC         djnz $22C2
22D6: DD E1         pop  ix
22D8: FD E1         pop  iy
22DA: C1            pop  bc
22DB: C9            ret
draw_bag_tiles_22dc:
22DC: DD 21 9C 60   ld   ix,bags_coordinates_609C
22E0: 3E 04         ld   a,$04
22E2: 32 7A 62      ld   (bag_color_color_attribute_627A),a
22E5: 06 13         ld   b,$13
22E7: DD E5         push ix
22E9: C5            push bc
22EA: CD 51 31      call draw_bag_3151
22ED: C1            pop  bc
22EE: DD E1         pop  ix
22F0: DD 23         inc  ix
22F2: DD 23         inc  ix
22F4: DD 23         inc  ix
22F6: 3E 01         ld   a,$01
22F8: 32 7A 62      ld   (bag_color_color_attribute_627A),a
22FB: 10 EA         djnz $22E7
22FD: 3A C7 61      ld   a,(holds_barrow_61C7)
2300: FE 01         cp   $01
2302: 28 1C         jr   z,$2320
2304: 3A 0D 60      ld   a,(player_screen_600D)
2307: 47            ld   b,a
2308: FD 21 C4 61   ld   iy,barrow_start_screen_address_61C4
230C: FD 7E 02      ld   a,(iy+$02)
230F: B8            cp   b
2310: 20 0E         jr   nz,$2320
2312: FD 6E 00      ld   l,(iy+$00)
2315: FD 66 01      ld   h,(iy+$01)
2318: 3E 28         ld   a,$28
231A: 08            ex   af,af'
231B: 3E EC         ld   a,$EC
231D: CD 17 34      call draw_wheelbarrow_tiles_3417
2320: 3A 0D 60      ld   a,(player_screen_600D)
2323: 47            ld   b,a
2324: FD 21 CC 61   ld   iy,unknown_61CC
2328: FD 7E 02      ld   a,(iy+$02)
232B: B8            cp   b
232C: 20 22         jr   nz,$2350
232E: FD 6E 00      ld   l,(iy+$00)
2331: FD 66 01      ld   h,(iy+$01)
2334: 7E            ld   a,(hl)
2335: CD 73 35      call is_background_tile_3573
2338: 20 16         jr   nz,$2350
233A: E5            push hl
233B: D5            push de
233C: 11 20 00      ld   de,$0020
233F: 19            add  hl,de
2340: 7E            ld   a,(hl)
2341: CD 73 35      call is_background_tile_3573
2344: D1            pop  de
2345: E1            pop  hl
2346: 20 08         jr   nz,$2350
2348: 3E 20         ld   a,$20
234A: 08            ex   af,af'
234B: 3E E4         ld   a,$E4
234D: CD 17 34      call draw_wheelbarrow_tiles_3417
2350: 06 04         ld   b,$04
2352: FD 21 D3 61   ld   iy,unknown_61D3
2356: 11 CC 61      ld   de,unknown_61CC
2359: C5            push bc
235A: FD E5         push iy
235C: D5            push de
235D: CD B7 22      call $22B7
2360: 1A            ld   a,(de)
2361: 6F            ld   l,a
2362: 13            inc  de
2363: 1A            ld   a,(de)
2364: 67            ld   h,a
2365: 1B            dec  de
2366: 3A 0D 60      ld   a,(player_screen_600D)
2369: FD E1         pop  iy
236B: FD BE 02      cp   (iy+$02)
236E: FD E5         push iy
2370: 20 1C         jr   nz,$238E
* read screen tile
2372: 7E            ld   a,(hl)
2373: CD 73 35      call is_background_tile_3573
2376: 20 16         jr   nz,$238E
2378: E5            push hl
2379: D5            push de
237A: 11 20 00      ld   de,$0020
237D: 19            add  hl,de
* read screen tile
237E: 7E            ld   a,(hl)
237F: CD 73 35      call is_background_tile_3573
2382: D1            pop  de
2383: E1            pop  hl
2384: 20 08         jr   nz,$238E
2386: 3E 20         ld   a,$20
2388: 08            ex   af,af'
2389: 3E E4         ld   a,$E4
238B: CD 17 34      call draw_wheelbarrow_tiles_3417
238E: D1            pop  de
238F: FD E1         pop  iy
2391: C1            pop  bc
2392: FD 23         inc  iy
2394: FD 23         inc  iy
2396: FD 23         inc  iy
2398: 10 BF         djnz $2359
239A: C9            ret
239B: 10 BF         djnz $235C
239D: C9            ret

2480: C3 CB 29      jp   $29CB
2483: C3 DC 29      jp   $29DC
2486: 31 F0 67      ld   sp,stack_top_67F0
2489: 3E 3F         ld   a,$3F
248B: CD EC 29      call change_attribute_everywhere_29ec
248E: CD 00 2A      call clear_screen_2a00
2491: 3E 01         ld   a,$01
2493: 32 03 A0      ld   ($A003),a
2496: 21 96 36      ld   hl,$3696
2499: 11 17 62      ld   de,unknown_6217
249C: 01 50 00      ld   bc,$0050
249F: ED B0         ldir
24A1: C3 1C 12      jp   $121C
24A4: 3A 10 62      ld   a,(unknown_6210)
24A7: FE 01         cp   $01
24A9: 20 3E         jr   nz,write_attribute_2_on_line_24E9
24AB: 3A 6D 62      ld   a,(unknown_626D)
24AE: FE 20         cp   $20
24B0: DC BD 24      call c,$24BD
24B3: FE 30         cp   $30
24B5: DC F2 24      call c,$24F2
24B8: AF            xor  a
24B9: 32 6D 62      ld   (unknown_626D),a
24BC: C9            ret
24BD: 3A 6E 62      ld   a,(unknown_626E)
24C0: FE 01         cp   $01
24C2: 28 13         jr   z,$24D7
24C4: CD 01 25      call get_XUP_screen_address_2501
24C7: 28 10         jr   z,$24D9
; display PLAYER1
24C9: 11 5A 57      ld   de,$575A
24CC: CD F9 30      call display_text_30F9
24CF: CD E9 24      call write_attribute_2_on_line_24E9
24D2: 3E 01         ld   a,$01
24D4: 32 6E 62      ld   (unknown_626E),a
24D7: F1            pop  af
24D8: C9            ret
; display PLAYER2
24D9: 11 63 57      ld   de,$5763
24DC: CD F9 30      call display_text_30F9
24DF: CD E9 24      call write_attribute_2_on_line_24E9
24E2: 3E 01         ld   a,$01
24E4: 32 6E 62      ld   (unknown_626E),a
24E7: F1            pop  af
24E8: C9            ret

24E9: 3E 02         ld   a,$02
24EB: 21 40 98      ld   hl,$9840
24EE: CD 05 56      call write_attribute_on_line_5605
24F1: C9            ret
24F2: CD 01 25      call get_XUP_screen_address_2501
24F5: 11 6C 57      ld   de,$576C
24F8: CD F9 30      call display_text_30F9
24FB: AF            xor  a
24FC: 32 6E 62      ld   (unknown_626E),a
24FF: F1            pop  af
2500: C9            ret

get_XUP_screen_address_2501:
2501: 3A 7C 61      ld   a,(current_player_617C)
2504: 21 A0 93      ld   hl,$93A0
2507: FE 01         cp   $01
2509: C0            ret  nz
250A: 21 20 91      ld   hl,$9120
250D: C9            ret

250E: 2B            dec  hl
250F: CD C8 25      call $25C8
2512: 23            inc  hl
2513: CD C8 25      call $25C8
2516: C9            ret

handle_player_destroying_wall_2517:
2517: 3A 0D 60      ld   a,(player_screen_600D)
251A: FE 02         cp   $02
251C: C0            ret  nz
251D: 3A 83 65      ld   a,(player_y_6583)
2520: FE C0         cp   $C0
2522: C0            ret  nz
2523: 3A 82 65      ld   a,(player_x_6582)
2526: FE 40         cp   $40
2528: C0            ret  nz
2529: 3A CF 61      ld   a,(has_pick_61CF)
252C: FE 00         cp   $00
252E: C8            ret  z
252F: 3A 9C 65      ld   a,(unknown_659C)
2532: FE B8         cp   $B8
2534: 28 03         jr   z,$2539
2536: FE B7         cp   $B7
2538: C0            ret  nz
2539: 3A 18 93      ld   a,($9318)
253C: FE E0         cp   $E0
253E: C8            ret  z
253F: FE E6         cp   $E6
2541: C8            ret  z
2542: FE E4         cp   $E4
2544: C8            ret  z
2545: FE D0         cp   $D0
2547: C8            ret  z
2548: 3A 18 93      ld   a,($9318)
254B: FE 02         cp   $02
254D: 28 0B         jr   z,$255A
254F: 3D            dec  a
2550: 3D            dec  a
2551: 32 18 93      ld   ($9318),a
2554: 3D            dec  a
2555: 32 19 93      ld   ($9319),a
2558: 18 08         jr   $2562
255A: 3E E0         ld   a,$E0
255C: 32 18 93      ld   ($9318),a
255F: 32 19 93      ld   ($9319),a
2562: 3A 18 93      ld   a,($9318)
2565: 32 7D 62      ld   (unknown_627D),a
2568: C9            ret

2569: C5            push bc
256A: E5            push hl
256B: D5            push de
256C: AF            xor  a
256D: 32 0B 60      ld   (way_clear_flag_600B),a
2570: 11 FA 46      ld   de,$46FA
2573: ED 52         sbc  hl,de
2575: 20 0A         jr   nz,$2581
2577: CD A1 25      call check_breakable_wall_present_25a1
257A: 28 05         jr   z,$2581
257C: 3E 02         ld   a,$02
257E: 32 0B 60      ld   (way_clear_flag_600B),a
2581: D1            pop  de
2582: E1            pop  hl
2583: C1            pop  bc
2584: C9            ret

check_breakable_wall_2585:
2585: C5            push bc
2586: E5            push hl
2587: D5            push de
2588: AF            xor  a
2589: 32 0B 60      ld   (way_clear_flag_600B),a
; logical address of the guard (the only place
; where wall needs to be checked is there)
258C: 11 3A 47      ld   de,$473A
258F: ED 52         sbc  hl,de
2591: 20 0A         jr   nz,$259D
2593: CD A1 25      call check_breakable_wall_present_25a1
2596: 28 05         jr   z,$259D
2598: 3E 02         ld   a,$02
259A: 32 0B 60      ld   (way_clear_flag_600B),a
259D: D1            pop  de
259E: E1            pop  hl
259F: C1            pop  bc
25A0: C9            ret

; all map walls are checked using ROM
; but this one needs to be checked in RAM
; as this wall can be broken
check_breakable_wall_present_25a1:
; address of the wall
25A1: 21 18 93      ld   hl,$9318
25A4: 7E            ld   a,(hl)
25A5: 21 AE 25      ld   hl,$25AE
25A8: 01 05 00      ld   bc,$0005
25AB: ED B1         cpir
25AD: C9            ret

25AE: 0A            ld   a,(bc)
25AF: 08            ex   af,af'
25B0: 06 04         ld   b,$04
25B2: 02            ld   (bc),a
25B3: 3A 0D 60      ld   a,(player_screen_600D)
25B6: FE 02         cp   $02
25B8: C0            ret  nz
25B9: 3A E8 61      ld   a,(time_61E8)
25BC: FE 20         cp   $20
25BE: C0            ret  nz
25BF: E5            push hl
25C0: 21 0F 57      ld   hl,$570F
25C3: 7E            ld   a,(hl)
25C4: FE 44         cp   $44
25C6: E1            pop  hl
25C7: C8            ret  z

25C8: 7E            ld   a,(hl)
25C9: FD 21 FC 25   ld   iy,$25FC
25CD: 11 EB 25      ld   de,$25EB
25D0: 4F            ld   c,a
25D1: 06 07         ld   b,$07
25D3: 1A            ld   a,(de)
25D4: B9            cp   c
25D5: 28 06         jr   z,$25DD
25D7: 13            inc  de
25D8: FD 23         inc  iy
25DA: 10 F7         djnz $25D3
25DC: C9            ret
25DD: DD 7E 03      ld   a,(ix+$03)
25E0: E6 F0         and  $F0
25E2: 47            ld   b,a
25E3: FD 7E 00      ld   a,(iy+$00)
25E6: B0            or   b
25E7: DD 77 03      ld   (ix+$03),a
25EA: C9            ret

2605: CD 40 26      call $2640
2608: 78            ld   a,b
2609: 32 0C 60      ld   (unknown_600C),a
260C: FE 00         cp   $00
260E: C8            ret  z
260F: FD 7E 00      ld   a,(iy+$00)
2612: FE 01         cp   $01
2614: C8            ret  z
2615: 7E            ld   a,(hl)
2616: 4F            ld   c,a
2617: 11 F4 25      ld   de,$25F4
261A: 06 08         ld   b,$08
261C: 1A            ld   a,(de)
261D: B9            cp   c
261E: C8            ret  z
261F: 13            inc  de
2620: 10 FA         djnz $261C
2622: 3A 0C 60      ld   a,(unknown_600C)
2625: FE 05         cp   $05
2627: 30 09         jr   nc,$2632
2629: 47            ld   b,a
262A: DD 7E 03      ld   a,(ix+$03)
262D: 90            sub  b
262E: DD 77 03      ld   (ix+$03),a
2631: C9            ret
2632: 2F            cpl
2633: E6 07         and  $07
2635: C6 01         add  a,$01
2637: 47            ld   b,a
2638: DD 7E 03      ld   a,(ix+$03)
263B: 80            add  a,b
263C: DD 77 03      ld   (ix+$03),a
263F: C9            ret
2640: DD 7E 03      ld   a,(ix+$03)
2643: CB 07         rlc  a
2645: CB 07         rlc  a
2647: CB 07         rlc  a
2649: CB 07         rlc  a
264B: CB 07         rlc  a
264D: 06 00         ld   b,$00
264F: CB 07         rlc  a
2651: CB 10         rl   b
2653: CB 07         rlc  a
2655: CB 10         rl   b
2657: CB 07         rlc  a
2659: CB 10         rl   b
265B: CD 23 29      call $2923
265E: C9            ret
265F: CD 16 2A      call $2A16
2662: 3E 3F         ld   a,$3F
2664: CD EC 29      call change_attribute_everywhere_29ec
2667: 3A 00 B8      ld   a,(io_read_shit_B800)
266A: 21 00 48      ld   hl,$4800
266D: 11 00 90      ld   de,$9000
2670: 01 00 04      ld   bc,$0400
2673: ED B0         ldir
2675: 21 44 9B      ld   hl,$9B44
2678: 06 04         ld   b,$04
267A: CD 7B 29      call write_line_of_zero_attributes_297b
267D: 21 24 99      ld   hl,$9924
2680: 06 0F         ld   b,$0F
2682: CD 7B 29      call write_line_of_zero_attributes_297b
2685: 21 44 98      ld   hl,$9844
2688: 06 04         ld   b,$04
268A: CD 7B 29      call write_line_of_zero_attributes_297b
268D: 21 71 98      ld   hl,$9871
2690: 06 03         ld   b,$03
2692: CD 7B 29      call write_line_of_zero_attributes_297b
2695: 21 31 99      ld   hl,$9931
2698: 06 04         ld   b,$04
269A: CD 7B 29      call write_line_of_zero_attributes_297b
269D: 21 50 9B      ld   hl,$9B50
26A0: 06 04         ld   b,$04
26A2: CD 7B 29      call write_line_of_zero_attributes_297b
26A5: 21 58 9B      ld   hl,$9B58
26A8: 06 04         ld   b,$04
26AA: CD 7B 29      call write_line_of_zero_attributes_297b
26AD: 21 18 9A      ld   hl,$9A18
26B0: 06 08         ld   b,$08
26B2: CD 7B 29      call write_line_of_zero_attributes_297b
26B5: 21 B4 99      ld   hl,$99B4
26B8: 06 0B         ld   b,$0B
26BA: CD 7B 29      call write_line_of_zero_attributes_297b
26BD: 21 D8 98      ld   hl,$98D8
26C0: 06 07         ld   b,$07
26C2: CD 7B 29      call write_line_of_zero_attributes_297b
26C5: 21 C8 98      ld   hl,$98C8
26C8: 06 0A         ld   b,$0A
26CA: CD 7B 29      call write_line_of_zero_attributes_297b
26CD: 21 9B 98      ld   hl,$989B
26D0: 06 1A         ld   b,$1A
26D2: CD 85 29      call write_line_of_2F_attributes_2985
26D5: 21 25 99      ld   hl,$9925
26D8: CD 89 29      call write_3_attributes_2989
26DB: 21 85 9A      ld   hl,$9A85
26DE: CD 89 29      call write_3_attributes_2989
26E1: 21 45 9B      ld   hl,$9B45
26E4: CD 89 29      call write_3_attributes_2989
26E7: 21 59 9B      ld   hl,$9B59
26EA: CD 89 29      call write_3_attributes_2989
26ED: 21 19 9A      ld   hl,$9A19
26F0: CD 89 29      call write_3_attributes_2989
26F3: 21 D9 9A      ld   hl,$9AD9
26F6: CD 89 29      call write_3_attributes_2989
26F9: 21 B5 9A      ld   hl,$9AB5
26FC: CD 89 29      call write_3_attributes_2989
26FF: 21 51 9B      ld   hl,$9B51
2702: CD 89 29      call write_3_attributes_2989
2705: 21 D9 98      ld   hl,$98D9
2708: CD 89 29      call write_3_attributes_2989
270B: 21 79 99      ld   hl,$9979
270E: CD 89 29      call write_3_attributes_2989
2711: 21 15 9A      ld   hl,$9A15
2714: CD 89 29      call write_3_attributes_2989
2717: 21 29 99      ld   hl,$9929
271A: CD 89 29      call write_3_attributes_2989
271D: 21 C9 99      ld   hl,$99C9
2720: CD 89 29      call write_3_attributes_2989
2723: 21 B8 9A      ld   hl,$9AB8
2726: 3E 3F         ld   a,$3F
2728: 77            ld   (hl),a
2729: 11 05 57      ld   de,$5705
272C: 21 40 92      ld   hl,$9240
272F: CD F9 30      call display_text_30F9
2732: 21 84 65      ld   hl,unknown_6584
2735: 3E 33         ld   a,$33
2737: 77            ld   (hl),a
2738: 23            inc  hl
2739: 3E 0C         ld   a,$0C
273B: 77            ld   (hl),a
273C: 23            inc  hl
273D: 3E 2F         ld   a,$2F
273F: 77            ld   (hl),a
2740: 23            inc  hl
2741: 3A 00 B8      ld   a,(io_read_shit_B800)
2744: 3A 66 61      ld   a,(unknown_6166)
2747: 77            ld   (hl),a
2748: CD 26 1E      call $1E26
274B: CD 10 31      call $3110
274E: CD EB 3D      call can_pick_bag_3DEB
2751: C0            ret  nz
2752: 21 00 52      ld   hl,$5200
2755: 22 40 61      ld   (unknown_pointer_6140),hl
2758: AF            xor  a
2759: 32 42 61      ld   (unknown_6142),a
275C: C9            ret
275D: CD 16 2A      call $2A16
2760: 3E 3F         ld   a,$3F
2762: CD EC 29      call change_attribute_everywhere_29ec
2765: 3A 00 B8      ld   a,(io_read_shit_B800)
2768: 21 00 44      ld   hl,$4400
276B: 11 00 90      ld   de,$9000
276E: 01 00 04      ld   bc,$0400
2771: ED B0         ldir
2773: 21 B0 99      ld   hl,$99B0
2776: 06 11         ld   b,$11
2778: CD 7B 29      call write_line_of_zero_attributes_297b
277B: 21 0B 9A      ld   hl,$9A0B
277E: 06 0A         ld   b,$0A
2780: CD 7B 29      call write_line_of_zero_attributes_297b
2783: 21 07 9B      ld   hl,$9B07
2786: 06 06         ld   b,$06
2788: CD 7B 29      call write_line_of_zero_attributes_297b
278B: 21 5B 99      ld   hl,$995B
278E: 06 08         ld   b,$08
2790: CD 7B 29      call write_line_of_zero_attributes_297b
2793: 21 BB 9A      ld   hl,$9ABB
2796: 06 09         ld   b,$09
2798: CD 7B 29      call write_line_of_zero_attributes_297b
279B: 21 A7 99      ld   hl,$99A7
279E: 06 08         ld   b,$08
27A0: CD 7B 29      call write_line_of_zero_attributes_297b
27A3: 21 44 98      ld   hl,$9844
27A6: 06 08         ld   b,$08
27A8: CD 7B 29      call write_line_of_zero_attributes_297b
27AB: 21 50 98      ld   hl,$9850
27AE: 06 09         ld   b,$09
27B0: CD 7B 29      call write_line_of_zero_attributes_297b
27B3: 21 58 98      ld   hl,$9858
27B6: 06 04         ld   b,$04
27B8: CD 7B 29      call write_line_of_zero_attributes_297b
27BB: 21 AA 99      ld   hl,$99AA
27BE: 06 0D         ld   b,$0D
27C0: CD 85 29      call write_line_of_2F_attributes_2985
27C3: 21 5B 98      ld   hl,$985B
27C6: 06 05         ld   b,$05
27C8: CD 85 29      call write_line_of_2F_attributes_2985
27CB: 21 9E 98      ld   hl,$989E
27CE: 06 1A         ld   b,$1A
27D0: CD 85 29      call write_line_of_2F_attributes_2985
27D3: 21 AA 9B      ld   hl,$9BAA
27D6: 3E 2F         ld   a,$2F
27D8: 77            ld   (hl),a
27D9: 21 31 99      ld   hl,$9931
27DC: CD 89 29      call write_3_attributes_2989
27DF: 21 C5 98      ld   hl,$98C5
27E2: CD 89 29      call write_3_attributes_2989
27E5: 21 FC 9A      ld   hl,$9AFC
27E8: CD 89 29      call write_3_attributes_2989
27EB: 21 28 9A      ld   hl,$9A28
27EE: CD 89 29      call write_3_attributes_2989
27F1: 21 D1 99      ld   hl,$99D1
27F4: CD 89 29      call write_3_attributes_2989
27F7: 21 5C 99      ld   hl,$995C
27FA: CD 89 29      call write_3_attributes_2989
27FD: 21 1C 9A      ld   hl,$9A1C
2800: CD 89 29      call write_3_attributes_2989
2803: 21 EC 9A      ld   hl,$9AEC
2806: CD 89 29      call write_3_attributes_2989
2809: 21 08 9B      ld   hl,$9B08
280C: CD 89 29      call write_3_attributes_2989
280F: 21 91 9B      ld   hl,$9B91
2812: CD 89 29      call write_3_attributes_2989
2815: 21 FB 99      ld   hl,$99FB
2818: 3E 3F         ld   a,$3F
281A: 77            ld   (hl),a
281B: 21 07 9A      ld   hl,$9A07
281E: 77            ld   (hl),a
281F: 21 98 98      ld   hl,$9898
2822: 77            ld   (hl),a
2823: 3A 00 B8      ld   a,(io_read_shit_B800)
2826: 11 05 57      ld   de,$5705
2829: 21 40 92      ld   hl,$9240
282C: CD F9 30      call display_text_30F9
282F: 21 84 65      ld   hl,unknown_6584
2832: 3E 33         ld   a,$33
2834: 77            ld   (hl),a
2835: 3E 04         ld   a,$04
2837: 23            inc  hl
2838: 77            ld   (hl),a
2839: 3E 97         ld   a,$97
283B: 23            inc  hl
283C: 77            ld   (hl),a
283D: 3A 65 61      ld   a,(unknown_6165)
2840: 23            inc  hl
2841: 77            ld   (hl),a
2842: 3A 00 B8      ld   a,(io_read_shit_B800)
2845: CD 26 1E      call $1E26
2848: CD 10 31      call $3110
284B: C9            ret

display_maze_284c:
284C: CD 16 2A      call $2A16
284F: 3E 3F         ld   a,$3F
2851: CD EC 29      call change_attribute_everywhere_29ec
2854: 3A 00 B8      ld   a,(io_read_shit_B800)
2857: 21 00 40      ld   hl,$4000
285A: 11 00 90      ld   de,$9000
285D: 01 00 04      ld   bc,$0400
2860: ED B0         ldir
2862: 21 07 99      ld   hl,$9907
2865: 06 0E         ld   b,$0E
2867: CD 7B 29      call write_line_of_zero_attributes_297b
286A: 21 17 99      ld   hl,$9917
286D: 06 0E         ld   b,$0E
286F: CD 7B 29      call write_line_of_zero_attributes_297b
2872: 21 5B 98      ld   hl,$985B
2875: 06 14         ld   b,$14
2877: CD 7B 29      call write_line_of_zero_attributes_297b
287A: 21 47 98      ld   hl,$9847
287D: 06 03         ld   b,$03
287F: CD 7B 29      call write_line_of_zero_attributes_297b
2882: 21 50 98      ld   hl,$9850
2885: 06 03         ld   b,$03
2887: CD 7B 29      call write_line_of_zero_attributes_297b
288A: 21 3B 9B      ld   hl,$9B3B
288D: 06 03         ld   b,$03
288F: CD 7B 29      call write_line_of_zero_attributes_297b
2892: 21 4A 9B      ld   hl,$9B4A
2895: 06 03         ld   b,$03
2897: CD 7B 29      call write_line_of_zero_attributes_297b
289A: 21 4A 98      ld   hl,$984A
289D: 06 03         ld   b,$03
289F: CD 85 29      call write_line_of_2F_attributes_2985
28A2: 21 0A 99      ld   hl,$990A
28A5: 06 0E         ld   b,$0E
28A7: CD 85 29      call write_line_of_2F_attributes_2985
28AA: 21 5E 98      ld   hl,$985E
28AD: 06 1A         ld   b,$1A
28AF: CD 85 29      call write_line_of_2F_attributes_2985
28B2: 21 68 9A      ld   hl,$9A68
28B5: CD 89 29      call write_3_attributes_2989
28B8: 21 68 99      ld   hl,$9968
28BB: CD 89 29      call write_3_attributes_2989
28BE: 21 18 99      ld   hl,$9918
28C1: CD 89 29      call write_3_attributes_2989
28C4: 21 98 99      ld   hl,$9998
28C7: CD 89 29      call write_3_attributes_2989
28CA: 21 78 9A      ld   hl,$9A78
28CD: CD 89 29      call write_3_attributes_2989
28D0: 21 9C 98      ld   hl,$989C
28D3: CD 89 29      call write_3_attributes_2989
28D6: 21 9C 9A      ld   hl,$9A9C
28D9: CD 89 29      call write_3_attributes_2989
28DC: 21 71 98      ld   hl,$9871
28DF: CD 89 29      call write_3_attributes_2989
28E2: 21 3C 9B      ld   hl,$9B3C
28E5: CD 89 29      call write_3_attributes_2989
28E8: 3E 3F         ld   a,$3F
28EA: 21 7B 9A      ld   hl,$9A7B
28ED: 77            ld   (hl),a
28EE: 21 DB 98      ld   hl,$98DB
28F1: 77            ld   (hl),a
28F2: 21 27 9A      ld   hl,$9A27
28F5: 77            ld   (hl),a
28F6: 21 67 98      ld   hl,$9867
28F9: 77            ld   (hl),a
28FA: AF            xor  a
28FB: 21 84 65      ld   hl,unknown_6584
28FE: 77            ld   (hl),a
28FF: 23            inc  hl
2900: 77            ld   (hl),a
2901: 23            inc  hl
2902: 77            ld   (hl),a
2903: 23            inc  hl
2904: 77            ld   (hl),a
2905: 3A 00 B8      ld   a,(io_read_shit_B800)
2908: CD 26 1E      call $1E26
290B: CD 10 31      call $3110
290E: 3A 10 62      ld   a,(unknown_6210)
2911: FE 00         cp   $00
2913: C8            ret  z
2914: CD EB 3D      call can_pick_bag_3DEB
2917: C0            ret  nz
2918: 21 00 50      ld   hl,$5000
291B: 22 40 61      ld   (unknown_pointer_6140),hl
291E: AF            xor  a
291F: 32 42 61      ld   (unknown_6142),a
2922: C9            ret
2923: 3A 0D 60      ld   a,(player_screen_600D)
2926: FE 03         cp   $03
2928: C0            ret  nz
2929: 3A 97 65      ld   a,(guard_1_y_6597)
292C: FE 28         cp   $28
292E: C0            ret  nz
292F: DD E5         push ix
2931: E5            push hl
2932: D5            push de
2933: DD 21 0C 57   ld   ix,$570C
2937: DD 7E 00      ld   a,(ix+$00)
293A: 21 94 29      ld   hl,$2994
293D: BE            cp   (hl)
293E: C4 46 29      call nz,$2946
2941: D1            pop  de
2942: E1            pop  hl
2943: DD E1         pop  ix
2945: C9            ret
2946: 11 A9 29      ld   de,$29A9
2949: 21 E2 92      ld   hl,$92E2
294C: C5            push bc
294D: F5            push af
294E: 3E 07         ld   a,$07
2950: 08            ex   af,af'
2951: CD F0 55      call write_text_55f0
2954: F1            pop  af
2955: C1            pop  bc
2956: C9            ret

2957: 3E 01         ld   a,$01
2959: 32 1A 60      ld   (unknown_601A),a
295C: 32 1B 60      ld   (unknown_601B),a		; third wagon screen index (0,1,2)
295F: 3E 80         ld   a,$80
2961: 32 27 60      ld   (guard_1_direction_6027),a
2964: 3E 40         ld   a,$40
2966: 32 67 60      ld   (guard_2_direction_6067),a ;  $40:	to left, $80:	 to right, $10:	 up, $20:	down
2969: 21 95 29      ld   hl,$2995
296C: 3A 00 B8      ld   a,(io_read_shit_B800)
296F: 11 88 65      ld   de,unknown_6588
2972: 01 14 00      ld   bc,$0014
2975: ED B0         ldir
2977: CD E0 1E      call $1EE0
297A: C9            ret

write_line_of_zero_attributes_297b:
297B: 3E 1F         ld   a,$1F
297D: 11 20 00      ld   de,$0020
2980: 77            ld   (hl),a
2981: 19            add  hl,de
2982: 10 FC         djnz $2980
2984: C9            ret
write_line_of_2F_attributes_2985:
2985: 3E 2F         ld   a,$2F
2987: 18 F4         jr   $297D

write_3_attributes_2989:
2989: 11 20 00      ld   de,$0020
298C: 3E 1F         ld   a,$1F
298E: 77            ld   (hl),a
298F: 19            add  hl,de
2990: 77            ld   (hl),a
2991: 23            inc  hl
2992: 77            ld   (hl),a
2993: C9            ret

2994: 41            ld   b,c
2995: 35            dec  (hl)
2996: 04            inc  b
2997: 5F            ld   e,a
2998: 00            nop
2999: 35            dec  (hl)
299A: 04            inc  b
299B: 5F            ld   e,a
299C: 00            nop
299D: 35            dec  (hl)
299E: 04            inc  b
299F: D8            ret  c
29A0: 00            nop
29A1: 20 0C         jr   nz,$29AF
29A3: D0            ret  nc
29A4: 10 20         djnz $29C6
29A6: 0C            inc  c
29A7: D0            ret  nc
29A8: 10 26         djnz $29D0
29AA: 11 1C 11      ld   de,$111C
29AD: 14            inc  d
29AE: 1F            rra
29AF: 1E 10         ld   e,$10
29B1: 11 25 24      ld   de,$2425
29B4: 1F            rra
29B5: 1D            dec  e
29B6: 11 24 19      ld   de,$1924
29B9: 1F            rra
29BA: 1E 3F         ld   e,$3F

write_text_29bc:
29BC: C5            push bc
29BD: 01 E0 FF      ld   bc,$FFE0
29C0: 77            ld   (hl),a
29C1: 09            add  hl,bc
29C2: C1            pop  bc
29C3: 10 F7         djnz write_text_29bc
29C5: C9            ret
29C6: 77            ld   (hl),a
29C7: 23            inc  hl
29C8: 10 FC         djnz $29C6
29CA: C9            ret
29CB: 06 08         ld   b,$08
29CD: 21 00 60      ld   hl,number_of_credits_6000
29D0: AF            xor  a
29D1: 4F            ld   c,a
29D2: 77            ld   (hl),a
29D3: 23            inc  hl
29D4: 0D            dec  c
29D5: 20 FB         jr   nz,$29D2
29D7: 10 F8         djnz $29D1
29D9: C3 83 24      jp   $2483
29DC: 06 08         ld   b,$08
29DE: 21 00 60      ld   hl,number_of_credits_6000
29E1: 4F            ld   c,a
29E2: 77            ld   (hl),a
29E3: 23            inc  hl
29E4: 0D            dec  c
29E5: 20 FB         jr   nz,$29E2
29E7: 10 F8         djnz $29E1
29E9: C3 86 24      jp   $2486

change_attribute_everywhere_29ec:
; 8 is too much as it writes beyond $9C00
29EC: 06 08         ld   b,$08
29EE: 21 00 98      ld   hl,$9800
29F1: 0E 00         ld   c,$00
29F3: 77            ld   (hl),a
29F4: 23            inc  hl
29F5: F5            push af
29F6: 3A 00 B8      ld   a,(io_read_shit_B800)
29F9: F1            pop  af
29FA: 0D            dec  c
29FB: 20 F6         jr   nz,$29F3
29FD: 10 F2         djnz $29F1
29FF: C9            ret


clear_screen_2a00:
2A00: 06 04         ld   b,$04
2A02: 3E E0         ld   a,$E0
2A04: 21 00 90      ld   hl,$9000
2A07: 0E 00         ld   c,$00
2A09: 77            ld   (hl),a
2A0A: 23            inc  hl
2A0B: F5            push af
2A0C: 3A 00 B8      ld   a,(io_read_shit_B800)
2A0F: F1            pop  af
2A10: 0D            dec  c
2A11: 20 F6         jr   nz,$2A09
2A13: 10 F2         djnz $2A07
2A15: C9            ret
2A16: 3E E0         ld   a,$E0
2A18: 3E E0         ld   a,$E0
2A1A: 21 E4 93      ld   hl,$93E4
2A1D: 06 1B         ld   b,$1B
2A1F: E5            push hl
2A20: C5            push bc
2A21: 06 20         ld   b,$20
2A23: CD BC 29      call write_text_29bc
2A26: C1            pop  bc
2A27: E1            pop  hl
2A28: 23            inc  hl
2A29: 10 F4         djnz $2A1F
2A2B: C9            ret
2A2C: 3E 00         ld   a,$00
2A2E: 32 03 A0      ld   ($A003),a
2A31: 06 04         ld   b,$04
2A33: 3E E0         ld   a,$E0
2A35: 21 00 90      ld   hl,$9000
2A38: CD 07 2A      call $2A07
2A3B: 3E 3F         ld   a,$3F
2A3D: CD EC 29      call change_attribute_everywhere_29ec
2A40: 3A 8C 62      ld   a,(unknown_628C)
2A43: FE 01         cp   $01
2A45: 28 09         jr   z,$2A50
2A47: 11 C3 56      ld   de,$56C3
2A4A: 21 AF 93      ld   hl,$93AF
2A4D: CD F9 30      call display_text_30F9
2A50: 06 01         ld   b,$01
2A52: 21 80 65      ld   hl,player_struct_6580
2A55: 3E 00         ld   a,$00
2A57: CD F1 29      call $29F1
2A5A: CD 10 31      call $3110
2A5D: 3E 01         ld   a,$01
2A5F: 32 03 A0      ld   ($A003),a
2A62: C9            ret
2A63: DD 21 76 61   ld   ix,player_1_score_6176
2A67: 06 07         ld   b,$07
2A69: AF            xor  a
2A6A: 00            nop
2A6B: DD 23         inc  ix
2A6D: 10 FB         djnz $2A6A
2A6F: C9            ret
2A70: 3A 63 61      ld   a,(unknown_6163)
2A73: E6 80         and  $80
2A75: FE 00         cp   $00
2A77: 28 0C         jr   z,$2A85
2A79: 3A 7C 61      ld   a,(current_player_617C)
2A7C: 2F            cpl
2A7D: E6 01         and  $01
2A7F: 32 01 A0      ld   ($A001),a
2A82: 32 02 A0      ld   ($A002),a
2A85: DD 21 9C 60   ld   ix,bags_coordinates_609C
2A89: FD 21 7F 61   ld   iy,bags_coordinates_617F
2A8D: 06 36         ld   b,$36
2A8F: CD BC 2A      call $2ABC
2A92: DD 21 C4 61   ld   ix,barrow_start_screen_address_61C4
2A96: FD 21 FA 61   ld   iy,unknown_screen_address_61FA
2A9A: 06 03         ld   b,$03
2A9C: CD BC 2A      call $2ABC
2A9F: 3A 56 60      ld   a,(lives_6056)
2AA2: F5            push af
2AA3: 3A 7E 61      ld   a,(unknown_617E)
2AA6: 32 56 60      ld   (lives_6056),a
2AA9: F1            pop  af
2AAA: 32 7E 61      ld   (unknown_617E),a
2AAD: 3A 90 62      ld   a,(unknown_6290)
2AB0: F5            push af
2AB1: 3A 7D 62      ld   a,(unknown_627D)
2AB4: 32 90 62      ld   (unknown_6290),a
2AB7: F1            pop  af
2AB8: 32 7D 62      ld   (unknown_627D),a
2ABB: C9            ret
2ABC: DD 7E 00      ld   a,(ix+$00)
2ABF: F5            push af
2AC0: FD 7E 00      ld   a,(iy+$00)
2AC3: DD 77 00      ld   (ix+$00),a
2AC6: F1            pop  af
2AC7: FD 77 00      ld   (iy+$00),a
2ACA: DD 23         inc  ix
2ACC: FD 23         inc  iy
2ACE: 10 EC         djnz $2ABC
2AD0: C9            ret


guard_collision_with_pick_2AD1:
2AD1: 0E 0B         ld   c,$0B
2AD3: 06 07         ld   b,$07
2AD5: DD 7E 03      ld   a,(ix+$03) ;  guard_x_struct + 3 = guard y
2AD8: C6 03         add  a,$03
2ADA: 91            sub  c
2ADB: FD BE 03      cp   (iy+$03)
2ADE: 28 06         jr   z,$2AE6
2AE0: 0C            inc  c
2AE1: 10 F2         djnz $2AD5
2AE3: 3E 00         ld   a,$00
2AE5: C9            ret
2AE6: DD 7E 02      ld   a,(ix+$02)
2AE9: C6 08         add  a,$08
2AEB: FD BE 02      cp   (iy+$02)
2AEE: 38 F3         jr   c,$2AE3
2AF0: D6 0F         sub  $0F
2AF2: FD BE 02      cp   (iy+$02)
2AF5: 30 EC         jr   nc,$2AE3
2AF7: 3E 01         ld   a,$01
2AF9: C9            ret

;;; guard does not know where player is (not visible)
;;; check if guard must wait for the elevator

	;; params:
;;;  screen_index_param_6098:	current guard screen
;;;  ix:	player struct
;;;  iy:	current guard struct
;;;  de:	current guard screen address
;;;  hl:	address to store bool flag "guard is in the elevator" (603B/607B)

guard_wait_for_elevator_test_2AFA:
2AFA: 3A 98 60      ld   a,(screen_index_param_6098)
2AFD: 47            ld   b,a
2AFE: 3A 0D 60      ld   a,(player_screen_600D)
2B01: B8            cp   b
2B02: C2 1E 2C      jp   nz,$2C1E ; not same screen as the player

	;; same screen as the player:	 check if on an elevator waiting zone

2B05: E5            push hl		; save hl
2B06: FD E5         push iy		; save il
2B08: FD 21 D3 2C   ld   iy,elevator_waiting_point_table_2CD3 ;  table ends with FF
2B0C: FD 7E 00      ld   a,(iy+$00)
2B0F: 67            ld   h,a
2B10: FD 7E 01      ld   a,(iy+$01)
2B13: 6F            ld   l,a
2B14: AF            xor  a
2B15: ED 52         sbc  hl,de
2B17: 28 18         jr   z,$2B31 ;  facing an elevator waiting point
2B19: FD 23         inc  iy
2B1B: FD 23         inc  iy
2B1D: FD 23         inc  iy
2B1F: FD 7E 02      ld   a,(iy+$02)
2B22: FE FF         cp   $FF
2B24: 20 E6         jr   nz,$2B0C
;;; not over an elevator waiting point
2B26: 2A 46 61      ld   hl,(unknown_pointer_6146)
2B29: AF            xor  a
2B2A: 77            ld   (hl),a	; not in elevator either
2B2B: FD E1         pop  iy
2B2D: E1            pop  hl
2B2E: C3 84 2B      jp   $2B84

	;; guard facing the elevator waiting point

2B31: 3E 01         ld   a,$01
2B33: 2A 46 61      ld   hl,(unknown_pointer_6146)
2B36: 7E            ld   a,(hl)
2B37: FE 00         cp   $00
2B39: C2 2B 2B      jp   nz,$2B2B
2B3C: CD D1 2B      call get_elevator_exit_y_2BD1
2B3F: FD E1         pop  iy
2B41: 47            ld   b,a
2B42: FD 7E 03      ld   a,(iy+$03)
2B45: B8            cp   b
2B46: CA C6 2B      jp   z,$2BC6
2B49: 2A 46 61      ld   hl,(unknown_pointer_6146)
2B4C: 23            inc  hl
2B4D: 23            inc  hl
2B4E: 23            inc  hl
2B4F: 23            inc  hl
2B50: 3E 01         ld   a,$01
2B52: 77            ld   (hl),a
2B53: E1            pop  hl
2B54: D5            push de
2B55: 11 1C 00      ld   de,$001C
2B58: 19            add  hl,de
2B59: D1            pop  de
2B5A: AF            xor  a
2B5B: 77            ld   (hl),a
2B5C: DD 7E 07      ld   a,(ix+$07) ; elevator y for current screen
2B5F: 3D            dec  a
2B60: FD BE 03      cp   (iy+$03)
2B63: 28 0C         jr   z,$2B71
2B65: 3D            dec  a
2B66: FD BE 03      cp   (iy+$03)
2B69: 28 06         jr   z,$2B71
2B6B: 2A 95 60      ld   hl,(guard_direction_pointer_6095)
2B6E: AF            xor  a
2B6F: 77            ld   (hl),a
2B70: C9            ret
2B71: DD 7E 06      ld   a,(ix+$06)
2B74: 2A 95 60      ld   hl,(guard_direction_pointer_6095)
2B77: FD BE 02      cp   (iy+$02)
2B7A: 30 04         jr   nc,$2B80
2B7C: 3E 40         ld   a,$40
2B7E: 77            ld   (hl),a
2B7F: C9            ret
2B80: 3E 80         ld   a,$80
2B82: 77            ld   (hl),a
2B83: C9            ret
2B84: 7E            ld   a,(hl)
2B85: FE 01         cp   $01
2B87: 28 09         jr   z,$2B92
2B89: 2A 46 61      ld   hl,(unknown_pointer_6146)
2B8C: 23            inc  hl
2B8D: 23            inc  hl
2B8E: 23            inc  hl
2B8F: 23            inc  hl
2B90: 77            ld   (hl),a
2B91: C9            ret
2B92: 2A 46 61      ld   hl,(unknown_pointer_6146)
2B95: 3E 01         ld   a,$01
2B97: 77            ld   (hl),a
2B98: CD D1 2B      call get_elevator_exit_y_2BD1
2B9B: 47            ld   b,a
2B9C: FD 7E 03      ld   a,(iy+$03)
2B9F: B8            cp   b
2BA0: 28 25         jr   z,$2BC7
2BA2: 23            inc  hl
2BA3: 23            inc  hl
2BA4: 23            inc  hl
2BA5: 23            inc  hl
2BA6: 3E 01         ld   a,$01
2BA8: 77            ld   (hl),a
2BA9: 3A 98 60      ld   a,(screen_index_param_6098)
2BAC: FE 02         cp   $02
2BAE: 20 07         jr   nz,$2BB7
2BB0: 3E 98         ld   a,$98
2BB2: FD 77 02      ld   (iy+$02),a
2BB5: 18 09         jr   $2BC0
2BB7: FE 03         cp   $03
2BB9: 20 05         jr   nz,$2BC0
2BBB: 3E 30         ld   a,$30
2BBD: FD 77 02      ld   (iy+$02),a
2BC0: 2A 95 60      ld   hl,(guard_direction_pointer_6095)
2BC3: AF            xor  a
2BC4: 77            ld   (hl),a
2BC5: C9            ret
2BC6: E1            pop  hl
2BC7: 2A 46 61      ld   hl,(unknown_pointer_6146)
2BCA: 23            inc  hl
2BCB: 23            inc  hl
2BCC: 23            inc  hl
2BCD: 23            inc  hl
2BCE: AF            xor  a
2BCF: 77            ld   (hl),a
2BD0: C9            ret
	;; called when guard is waiting or in the stopped elevator
	;; guard/elevator routine.
get_elevator_exit_y_2BD1:
2BD1: 3A 98 60      ld   a,(screen_index_param_6098)
2BD4: FE 03         cp   $03
2BD6: 28 16         jr   z,$2BEE
2BD8: FE 02         cp   $02
2BDA: C0            ret  nz
	;; 2nd screen:	get exit y
2BDB: DD 7E 03      ld   a,(ix+$03) ; player y
2BDE: FE 80         cp   $80
2BE0: 3E 88         ld   a,$88	;  exits at the bottom if player y > $80
2BE2: D0            ret  nc
2BE3: DD 7E 02      ld   a,(ix+$02) ; player x
2BE6: FE 98         cp   $98
2BE8: 3E 40         ld   a,$40	;  exits at the wagon exit if player in the upper-left quarter x < $98
2BEA: D8            ret  c
2BEB: 3E 69         ld   a,$69	;  exits at the 2nd floor (2 bags, lead to screen 3)
2BED: C9            ret
	;; 3rd screen
2BEE: DD 7E 02      ld   a,(ix+$02) ; player x
2BF1: FE 28         cp   $28
	;; b:	 guard direction??
2BF3: 06 40         ld   b,$40
2BF5: 38 02         jr   c,$2BF9 ;  jump if player x < $28
2BF7: 06 80         ld   b,$80
2BF9: DD 7E 03      ld   a,(ix+$03) ; player y
2BFC: FE 78         cp   $78
2BFE: 3E 29         ld   a,$29
2C00: 38 15         jr   c,$2C17 ;  exits at y=$29 (below the top exit) if player y < $78
2C02: DD 7E 03      ld   a,(ix+$03)
2C05: FE A0         cp   $A0
2C07: 3E 71         ld   a,$71
2C09: 38 0C         jr   c,$2C17 ;  exits at y=$71 (slope exit) if player y < $A0
2C0B: DD 7E 03      ld   a,(ix+$03)
2C0E: FE C0         cp   $C0
2C10: 3E A9         ld   a,$A9
2C12: 38 03         jr   c,$2C17 ;  exits at y=$A9 (pickaxe exit) if player y < $C0
2C14: 3E C8         ld   a,$C8	; exits at the bottom else
2C16: C9            ret
2C17: E5            push hl
2C18: 2A 95 60      ld   hl,(guard_direction_pointer_6095)
2C1B: 70            ld   (hl),b
2C1C: E1            pop  hl
2C1D: C9            ret

;;; not the same screen as the player:	different behaviour
;;; don't wait for the elevator, just jump in the hole and die

2C1E: 2A 46 61      ld   hl,(unknown_pointer_6146)
2C21: 23            inc  hl
2C22: 23            inc  hl
2C23: 23            inc  hl
2C24: 23            inc  hl
2C25: AF            xor  a
2C26: 77            ld   (hl),a
2C27: C9            ret

	;; check for "VALADON AUTOMATION" (bootleg credits check)
	;; if score > 60000, 0 credits and hacked copyright then seriously
	;; lockup the game (not visible immediately)

nasty_protection_2c28:
2C28: 3A 78 61      ld   a,(score_ten_thousands_player_1_6178)
2C2B: FE 06         cp   $06
2C2D: C0            ret  nz
2C2E: 3A A3 58      ld   a,($58A3)
2C31: FE 4C         cp   $4C	; "L" of VALLADON
2C33: C8            ret  z
2C34: 21 00 05      ld   hl,$0500
2C37: FB            ei
2C38: 06 FF         ld   b,$FF
2C3A: 3A 00 60      ld   a,(number_of_credits_6000)
2C3D: FE 00         cp   $00
2C3F: C0            ret  nz
	;; random huge slowdown when 0 credits remaining
2C40: 3A 00 B8      ld   a,(io_read_shit_B800)
2C43: FB            ei
2C44: 10 F4         djnz $2C3A
2C46: 2B            dec  hl
2C47: 7C            ld   a,h
2C48: FE 00         cp   $00
2C4A: C8            ret  z
2C4B: 18 EB         jr   $2C38


compute_guard_speed_from_dipsw_2C4D:
2C4D: 3A ED 61      ld   a,(check_scenery_disabled_61ED)
2C50: FE 01         cp   $01
2C52: 3E 00         ld   a,$00
2C54: 28 22         jr   z,$2C78
2C56: 3A 78 61      ld   a,(score_ten_thousands_player_1_6178)
2C59: 47            ld   b,a
2C5A: 3A 7C 61      ld   a,(current_player_617C)
2C5D: FE 01         cp   $01
2C5F: 20 04         jr   nz,$2C65
2C61: 3A 7B 61      ld   a,(score_ten_thousands_player_2_617B)
2C64: 47            ld   b,a
2C65: 3A 00 B0      ld   a,(dip_switch_B000)
2C68: CB 1F         rr   a
2C6A: CB 1F         rr   a
2C6C: CB 1F         rr   a
2C6E: 2F            cpl
2C6F: E6 03         and  $03
2C71: 80            add  a,b	; difficulty level
2C72: 06 00         ld   b,$00
2C74: CD 7C 2C      call compute_guard_speed_2C7C
2C77: 78            ld   a,b
2C78: 32 64 61      ld   (guard_speed_6164),a
2C7B: C9            ret

	;; depending on score & difficulty level, return guard speed in b
	;; easy:	0->10000 :	0
	;; easy:	10000->20000 :	2
	;; easy:	20000-30000:	4
	;; easy:	30000->40000 :	5
	;; easy:	after 40000 :	 9
	;; easy:	after 50000 :	 10
	;; medium:	0->10000 :	2
	;; medium:	10000->20000:	 4
	;; medium:	20000->30000 :	5
	;; medium:	30000->40000 :	9
	;; medium:	after 40000:	10

compute_guard_speed_2C7C:
2C7C: FE 01         cp   $01
2C7E: D8            ret  c
2C7F: 06 02         ld   b,$02
2C81: FE 02         cp   $02
2C83: D8            ret  c
2C84: 06 04         ld   b,$04
2C86: FE 03         cp   $03
2C88: D8            ret  c
2C89: 06 05         ld   b,$05
2C8B: FE 04         cp   $04
2C8D: D8            ret  c
2C8E: 06 09         ld   b,$09
2C90: FE 05         cp   $05
2C92: D8            ret  c
2C93: 06 0A         ld   b,$0A
2C95: C9            ret

2C96: DD 21 94 65   ld   ix,guard_1_struct_6594
2C9A: FD 21 9C 65   ld   iy,unknown_659C
2C9E: CD D1 2A      call guard_collision_with_pick_2AD1
2CA1: FE 01         cp   $01
2CA3: 20 0F         jr   nz,$2CB4
2CA5: 3A 58 61      ld   a,(has_bag_6158)
2CA8: FE 01         cp   $01
2CAA: 28 08         jr   z,$2CB4
2CAC: 3E 01         ld   a,$01
2CAE: 32 37 60      ld   (unknown_6037),a
2CB1: 32 08 62      ld   (unknown_6208),a
2CB4: DD 21 98 65   ld   ix,guard_2_struct_6598
2CB8: FD 21 9C 65   ld   iy,unknown_659C
2CBC: CD D1 2A      call guard_collision_with_pick_2AD1
2CBF: FE 01         cp   $01
2CC1: 20 0F         jr   nz,$2CD2
2CC3: 3A 58 61      ld   a,(has_bag_6158)
2CC6: FE 01         cp   $01
2CC8: 28 08         jr   z,$2CD2
2CCA: 3E 01         ld   a,$01
2CCC: 32 77 60      ld   (unknown_6077),a
2CCF: 32 09 62      ld   (unknown_6209),a
2CD2: C9            ret


2D03: 3A 10 62      ld   a,(unknown_6210)
2D06: FE 01         cp   $01
2D08: C0            ret  nz
2D09: FD 21 76 61   ld   iy,player_1_score_6176
2D0D: CD D8 2D      call $2DD8
2D10: 78            ld   a,b
2D11: FE 05         cp   $05
2D13: 38 0B         jr   c,$2D20
2D15: FD 21 79 61   ld   iy,player_2_score_6179
2D19: CD D8 2D      call $2DD8
2D1C: 78            ld   a,b
2D1D: FE 05         cp   $05
2D1F: D0            ret  nc
2D20: CD 03 21      call $2103
2D23: CD FB 2F      call high_score_entry_2ffb
2D26: 3A 6C 62      ld   a,(unknown_626C)
2D29: FE 01         cp   $01
2D2B: CC 70 2A      call z,$2A70
2D2E: CD 8D 2F      call $2F8D
2D31: 3E 01         ld   a,$01
2D33: 32 01 A0      ld   ($A001),a
2D36: 32 02 A0      ld   ($A002),a
2D39: FD 21 76 61   ld   iy,player_1_score_6176
2D3D: CD D8 2D      call $2DD8
2D40: 78            ld   a,b
2D41: FE 05         cp   $05
2D43: D2 71 2D      jp   nc,$2D71
2D46: DD 23         inc  ix
2D48: DD 23         inc  ix
2D4A: DD 23         inc  ix
2D4C: D5            push de
2D4D: 11 F0 FF      ld   de,$FFF0
2D50: DD 19         add  ix,de
2D52: D1            pop  de
2D53: DD E5         push ix
2D55: 23            inc  hl
2D56: 23            inc  hl
2D57: E5            push hl
2D58: CD 04 2E      call $2E04
2D5B: 3E 60         ld   a,$60
2D5D: 32 E8 61      ld   (time_61E8),a
2D60: E1            pop  hl
2D61: CD 8D 2F      call $2F8D
2D64: DD E1         pop  ix
2D66: 3E 01         ld   a,$01
2D68: 32 79 62      ld   (unknown_6279),a
2D6B: CD 58 2E      call $2E58
2D6E: CD 8D 2F      call $2F8D
2D71: 3A 7D 61      ld   a,(unknown_617D)
2D74: FE 01         cp   $01
2D76: 28 5B         jr   z,$2DD3
2D78: 3A 00 B0      ld   a,(dip_switch_B000)
2D7B: E6 80         and  $80
2D7D: FE 80         cp   $80
2D7F: 28 08         jr   z,$2D89
2D81: 3E 00         ld   a,$00
2D83: 32 01 A0      ld   ($A001),a
2D86: 32 02 A0      ld   ($A002),a
2D89: 3A 26 60      ld   a,(player_input_6026)
2D8C: E6 80         and  $80
2D8E: FE 80         cp   $80
2D90: 28 F7         jr   z,$2D89
2D92: FD 21 79 61   ld   iy,player_2_score_6179
2D96: CD D8 2D      call $2DD8
2D99: 78            ld   a,b
2D9A: FE 05         cp   $05
2D9C: 30 35         jr   nc,$2DD3
2D9E: CD 8D 2F      call $2F8D
2DA1: DD 23         inc  ix
2DA3: DD 23         inc  ix
2DA5: DD 23         inc  ix
2DA7: D5            push de
2DA8: 11 F0 FF      ld   de,$FFF0
2DAB: DD 19         add  ix,de
2DAD: D1            pop  de
2DAE: DD E5         push ix
2DB0: 23            inc  hl
2DB1: 23            inc  hl
2DB2: E5            push hl
2DB3: CD 04 2E      call $2E04
2DB6: 3E 60         ld   a,$60
2DB8: 32 E8 61      ld   (time_61E8),a
2DBB: E1            pop  hl
2DBC: CD 8D 2F      call $2F8D
2DBF: DD E1         pop  ix
2DC1: 3E 00         ld   a,$00
2DC3: 32 79 62      ld   (unknown_6279),a
2DC6: CD 19 2F      call busy_wait_2f19
2DC9: CD 19 2F      call busy_wait_2f19
2DCC: CD 19 2F      call busy_wait_2f19
2DCF: CD 58 2E      call $2E58
2DD2: C9            ret
2DD3: AF            xor  a
2DD4: 32 67 62      ld   (unknown_6267),a
2DD7: C9            ret
2DD8: DD 21 17 62   ld   ix,unknown_6217
2DDC: 11 10 00      ld   de,$0010
2DDF: 21 0F 92      ld   hl,$920F
2DE2: 06 05         ld   b,$05
2DE4: FD 7E 02      ld   a,(iy+$02)
2DE7: DD BE 02      cp   (ix+$02)
2DEA: D8            ret  c
2DEB: 20 10         jr   nz,$2DFD
2DED: FD 7E 01      ld   a,(iy+$01)
2DF0: DD BE 01      cp   (ix+$01)
2DF3: D8            ret  c
2DF4: 20 07         jr   nz,$2DFD
2DF6: FD 7E 00      ld   a,(iy+$00)
2DF9: DD BE 00      cp   (ix+$00)
2DFC: D8            ret  c
2DFD: DD 19         add  ix,de
2DFF: 2B            dec  hl
2E00: 2B            dec  hl
2E01: 10 E1         djnz $2DE4
2E03: C9            ret
2E04: C5            push bc
2E05: DD 21 17 62   ld   ix,unknown_6217
2E09: 78            ld   a,b
2E0A: FE 04         cp   $04
2E0C: 30 11         jr   nc,$2E1F
2E0E: C5            push bc
2E0F: 06 10         ld   b,$10
2E11: DD 7E 10      ld   a,(ix+$10)
2E14: DD 77 00      ld   (ix+$00),a
2E17: DD 23         inc  ix
2E19: 10 F6         djnz $2E11
2E1B: C1            pop  bc
2E1C: 04            inc  b
2E1D: 18 EA         jr   $2E09
2E1F: C1            pop  bc
2E20: DD 21 17 62   ld   ix,unknown_6217
2E24: 78            ld   a,b
2E25: FE 04         cp   $04
2E27: 30 05         jr   nc,$2E2E
2E29: DD 19         add  ix,de
2E2B: 04            inc  b
2E2C: 18 F6         jr   $2E24
2E2E: FD 7E 00      ld   a,(iy+$00)
2E31: DD 77 00      ld   (ix+$00),a
2E34: FD 7E 01      ld   a,(iy+$01)
2E37: DD 77 01      ld   (ix+$01),a
2E3A: FD 7E 02      ld   a,(iy+$02)
2E3D: DD 77 02      ld   (ix+$02),a
2E40: C5            push bc
2E41: 06 0D         ld   b,$0D
2E43: DD E5         push ix
2E45: DD 23         inc  ix
2E47: DD 23         inc  ix
2E49: DD 23         inc  ix
2E4B: 3E 10         ld   a,$10
2E4D: DD 77 00      ld   (ix+$00),a
2E50: DD 23         inc  ix
2E52: 10 F9         djnz $2E4D
2E54: DD E1         pop  ix
2E56: C1            pop  bc
2E57: C9            ret
2E58: 06 11         ld   b,$11
2E5A: 3E 00         ld   a,$00
2E5C: 32 78 62      ld   (unknown_6278),a
2E5F: 3A 79 62      ld   a,(unknown_6279)
2E62: FE 01         cp   $01
2E64: 20 05         jr   nz,$2E6B
2E66: CD 9C 30      call $309C
2E69: 18 0C         jr   $2E77
2E6B: 3A 00 B0      ld   a,(dip_switch_B000)
2E6E: E6 80         and  $80
2E70: FE 80         cp   $80
2E72: 28 F2         jr   z,$2E66
2E74: CD B8 30      call $30B8
2E77: 3A 78 62      ld   a,(unknown_6278)
2E7A: E6 10         and  $10
2E7C: FE 10         cp   $10
2E7E: CC B2 2E      call z,$2EB2
2E81: 3A 78 62      ld   a,(unknown_6278)
2E84: E6 08         and  $08
2E86: FE 08         cp   $08
2E88: CC C1 2E      call z,$2EC1
2E8B: 3A 78 62      ld   a,(unknown_6278)
2E8E: E6 40         and  $40
2E90: FE 40         cp   $40
2E92: CC D0 2E      call z,$2ED0
2E95: 3A 78 62      ld   a,(unknown_6278)
2E98: E6 20         and  $20
2E9A: FE 20         cp   $20
2E9C: CC EE 2E      call z,$2EEE
2E9F: 3A 78 62      ld   a,(unknown_6278)
2EA2: E6 80         and  $80
2EA4: FE 80         cp   $80
2EA6: C8            ret  z
2EA7: 3A E8 61      ld   a,(time_61E8)
2EAA: FE 00         cp   $00
2EAC: C8            ret  z
2EAD: CD 0A 2F      call $2F0A
2EB0: 18 AD         jr   $2E5F
2EB2: 78            ld   a,b
2EB3: FE 29         cp   $29
2EB5: 20 02         jr   nz,$2EB9
2EB7: 06 10         ld   b,$10
2EB9: 04            inc  b
2EBA: CD 0A 2F      call $2F0A
2EBD: CD 19 2F      call busy_wait_2f19
2EC0: C9            ret
2EC1: 78            ld   a,b
2EC2: FE 10         cp   $10
2EC4: 20 02         jr   nz,$2EC8
2EC6: 06 2A         ld   b,$2A
2EC8: 05            dec  b
2EC9: CD 0A 2F      call $2F0A
2ECC: CD 19 2F      call busy_wait_2f19
2ECF: C9            ret
2ED0: 7D            ld   a,l
2ED1: E6 F0         and  $F0
2ED3: FE 00         cp   $00
2ED5: 20 04         jr   nz,$2EDB
2ED7: 7C            ld   a,h
2ED8: FE 92         cp   $92
2EDA: C8            ret  z
2EDB: 06 10         ld   b,$10
2EDD: CD 0A 2F      call $2F0A
2EE0: 11 20 00      ld   de,$0020
2EE3: 19            add  hl,de
2EE4: DD 2B         dec  ix
2EE6: 46            ld   b,(hl)
2EE7: CD 0A 2F      call $2F0A
2EEA: CD 19 2F      call busy_wait_2f19
2EED: C9            ret
2EEE: 7D            ld   a,l
2EEF: E6 F0         and  $F0
2EF1: FE 80         cp   $80
2EF3: 20 04         jr   nz,$2EF9
2EF5: 7C            ld   a,h
2EF6: FE 90         cp   $90
2EF8: C8            ret  z
2EF9: 11 20 00      ld   de,$0020
2EFC: AF            xor  a
2EFD: ED 52         sbc  hl,de
2EFF: DD 23         inc  ix
2F01: 06 11         ld   b,$11
2F03: CD 0A 2F      call $2F0A
2F06: CD 19 2F      call busy_wait_2f19
2F09: C9            ret
2F0A: 78            ld   a,b
2F0B: DD 77 00      ld   (ix+$00),a
2F0E: 77            ld   (hl),a
2F0F: E5            push hl
2F10: 7C            ld   a,h
2F11: C6 08         add  a,$08
2F13: 67            ld   h,a
2F14: 3E 04         ld   a,$04
2F16: 77            ld   (hl),a
2F17: E1            pop  hl
2F18: C9            ret
busy_wait_2f19:
2F19: C5            push bc
2F1A: F5            push af
2F1B: E5            push hl
2F1C: 06 70         ld   b,$70
2F1E: 21 00 03      ld   hl,$0300
2F21: 2B            dec  hl
2F22: 7C            ld   a,h
2F23: FE 00         cp   $00
2F25: 20 FA         jr   nz,$2F21
2F27: 10 F5         djnz $2F1E
2F29: E1            pop  hl
2F2A: F1            pop  af
2F2B: C1            pop  bc
2F2C: C9            ret
2F2D: 21 25 93      ld   hl,$9325
2F30: 11 4F 57      ld   de,$574F
2F33: CD F9 30      call display_text_30F9
2F36: 21 05 92      ld   hl,$9205
2F39: 11 55 57      ld   de,$5755
2F3C: CD F9 30      call display_text_30F9
2F3F: 21 E3 92      ld   hl,$92E3
2F42: 11 90 56      ld   de,$5690
2F45: CD F9 30      call display_text_30F9
2F48: 21 83 98      ld   hl,$9883
2F4B: 3E 0E         ld   a,$0E
2F4D: CD 05 56      call write_attribute_on_line_5605
2F50: 11 00 4D      ld   de,$4D00
2F53: 21 82 93      ld   hl,$9382
2F56: 3E 12         ld   a,$12
2F58: 08            ex   af,af'
2F59: CD F0 55      call write_text_55f0
2F5C: 11 1B 4D      ld   de,$4D1B
2F5F: 21 90 93      ld   hl,$9390
2F62: 3E 12         ld   a,$12
2F64: 08            ex   af,af'
2F65: CD F0 55      call write_text_55f0
2F68: 06 0D         ld   b,$0D
2F6A: 3E 8B         ld   a,$8B
2F6C: 21 83 93      ld   hl,$9383
2F6F: CD 7D 2F      call $2F7D
2F72: 3E 8E         ld   a,$8E
2F74: 06 0D         ld   b,$0D
2F76: 21 63 90      ld   hl,$9063
2F79: CD 7D 2F      call $2F7D
2F7C: C9            ret
2F7D: 77            ld   (hl),a
2F7E: E5            push hl
2F7F: F5            push af
2F80: 7C            ld   a,h
2F81: C6 08         add  a,$08
2F83: 67            ld   h,a
2F84: 3E 10         ld   a,$10
2F86: 77            ld   (hl),a
2F87: F1            pop  af
2F88: E1            pop  hl
2F89: 23            inc  hl
2F8A: 10 F1         djnz $2F7D
2F8C: C9            ret
2F8D: DD E5         push ix
2F8F: C5            push bc
2F90: E5            push hl
2F91: D5            push de
2F92: CD 2D 2F      call $2F2D
2F95: 11 20 00      ld   de,$0020
2F98: 21 8F 92      ld   hl,$928F
2F9B: DD 21 17 62   ld   ix,unknown_6217
2F9F: 06 05         ld   b,$05
2FA1: C5            push bc
2FA2: E5            push hl
2FA3: 06 03         ld   b,$03
2FA5: DD 7E 00      ld   a,(ix+$00)
2FA8: E6 0F         and  $0F
2FAA: CD 0E 2F      call $2F0E
2FAD: DD 7E 00      ld   a,(ix+$00)
2FB0: 0F            rrca
2FB1: 0F            rrca
2FB2: 0F            rrca
2FB3: 0F            rrca
2FB4: E6 0F         and  $0F
2FB6: 11 20 00      ld   de,$0020
2FB9: 19            add  hl,de
2FBA: CD 0E 2F      call $2F0E
2FBD: DD 23         inc  ix
2FBF: 19            add  hl,de
2FC0: 10 E3         djnz $2FA5
2FC2: E1            pop  hl
2FC3: 2B            dec  hl
2FC4: 2B            dec  hl
2FC5: C1            pop  bc
2FC6: 11 0D 00      ld   de,$000D
2FC9: DD 19         add  ix,de
2FCB: 10 D4         djnz $2FA1
2FCD: 11 20 00      ld   de,$0020
2FD0: DD 21 17 62   ld   ix,unknown_6217
2FD4: 21 0F 92      ld   hl,$920F
2FD7: 06 05         ld   b,$05
2FD9: C5            push bc
2FDA: E5            push hl
2FDB: DD 23         inc  ix
2FDD: DD 23         inc  ix
2FDF: DD 23         inc  ix
2FE1: 06 0D         ld   b,$0D
2FE3: DD 7E 00      ld   a,(ix+$00)
2FE6: CD 0E 2F      call $2F0E
2FE9: DD 23         inc  ix
2FEB: ED 52         sbc  hl,de
2FED: 10 F4         djnz $2FE3
2FEF: E1            pop  hl
2FF0: 2B            dec  hl
2FF1: 2B            dec  hl
2FF2: C1            pop  bc
2FF3: 10 E4         djnz $2FD9
2FF5: D1            pop  de
2FF6: E1            pop  hl
2FF7: C1            pop  bc
2FF8: DD E1         pop  ix
2FFA: C9            ret
high_score_entry_2ffb:
2FFB: 3E 01         ld   a,$01
2FFD: 32 67 62      ld   (unknown_6267),a
3000: 21 72 93      ld   hl,$9372
3003: 11 1E 57      ld   de,$571E
3006: CD F9 30      call display_text_30F9
3009: 21 73 93      ld   hl,$9373
300C: 11 37 57      ld   de,$5737
300F: CD F9 30      call display_text_30F9
3012: 21 7D 93      ld   hl,$937D
3015: 11 75 57      ld   de,$5775
3018: CD F9 30      call display_text_30F9
301B: 11 00 4D      ld   de,$4D00
301E: 21 91 93      ld   hl,$9391
3021: 3E 12         ld   a,$12
3023: 08            ex   af,af'
3024: CD F0 55      call write_text_55f0
3027: 11 1B 4D      ld   de,$4D1B
302A: 21 9E 93      ld   hl,$939E
302D: 3E 12         ld   a,$12
302F: 08            ex   af,af'
3030: CD F0 55      call write_text_55f0
3033: 06 0C         ld   b,$0C
3035: 21 92 93      ld   hl,$9392
3038: 3E 8B         ld   a,$8B
303A: CD 7D 2F      call $2F7D
303D: 06 0C         ld   b,$0C
303F: 3E 8E         ld   a,$8E
3041: 21 72 90      ld   hl,$9072
3044: CD 7D 2F      call $2F7D
3047: 11 36 4D      ld   de,$4D36
304A: 21 75 92      ld   hl,$9275
304D: CD DB 30      call $30DB
3050: 11 4A 4D      ld   de,$4D4A
3053: 21 B8 91      ld   hl,$91B8
3056: CD DB 30      call $30DB
3059: 11 5E 4D      ld   de,$4D5E
305C: 21 9B 92      ld   hl,$929B
305F: CD DB 30      call $30DB
3062: 11 72 4D      ld   de,$4D72
3065: 21 F8 92      ld   hl,$92F8
3068: CD DB 30      call $30DB
306B: 11 86 4D      ld   de,$4D86
306E: 21 58 92      ld   hl,$9258
3071: CD D4 30      call $30D4
3074: 11 8C 4D      ld   de,$4D8C
3077: 21 16 92      ld   hl,$9216
307A: CD D4 30      call $30D4
307D: 11 8E 4D      ld   de,$4D8E
3080: 21 17 92      ld   hl,$9217
3083: CD D4 30      call $30D4
3086: 11 90 4D      ld   de,$4D90
3089: 21 19 92      ld   hl,$9219
308C: CD D4 30      call $30D4
308F: 11 92 4D      ld   de,$4D92
3092: 21 1A 92      ld   hl,$921A
3095: CD D4 30      call $30D4
3098: CD 2D 2F      call $2F2D
309B: C9            ret
309C: AF            xor  a
309D: 32 07 A0      ld   ($A007),a
30A0: 3E 07         ld   a,$07
30A2: D3 08         out  ($08),a
30A4: 3E 38         ld   a,$38
30A6: D3 09         out  ($09),a
30A8: 3E 0E         ld   a,$0E
30AA: D3 08         out  ($08),a
30AC: DB 0C         in   a,($0C)
30AE: 2F            cpl
30AF: 32 78 62      ld   (unknown_6278),a
30B2: 3E 01         ld   a,$01
30B4: 32 07 A0      ld   ($A007),a
30B7: C9            ret
30B8: AF            xor  a
30B9: 32 07 A0      ld   ($A007),a
30BC: 3E 07         ld   a,$07
30BE: D3 08         out  ($08),a
30C0: 3E 38         ld   a,$38
30C2: D3 09         out  ($09),a
30C4: 3E 0F         ld   a,$0F
30C6: D3 08         out  ($08),a
30C8: DB 0C         in   a,($0C)
30CA: 2F            cpl
30CB: 32 78 62      ld   (unknown_6278),a
30CE: 3E 01         ld   a,$01
30D0: 32 07 A0      ld   ($A007),a
30D3: C9            ret
30D4: 3E 14         ld   a,$14
30D6: 08            ex   af,af'
30D7: CD F0 55      call write_text_55f0
30DA: C9            ret
30DB: 3E 18         ld   a,$18
30DD: 08            ex   af,af'
30DE: CD E5 30      call $30E5
30E1: CD F0 55      call write_text_55f0
30E4: C9            ret

30E5: F5            push af
30E6: 3A 00 B0      ld   a,(dip_switch_B000)
30E9: E6 20         and  $20
30EB: FE 20         cp   $20
30ED: 20 08         jr   nz,$30F7
30EF: E5            push hl
30F0: EB            ex   de,hl
30F1: 11 0A 00      ld   de,$000A
30F4: 19            add  hl,de
30F5: EB            ex   de,hl
30F6: E1            pop  hl
30F7: F1            pop  af
30F8: C9            ret

display_text_30F9:
30F9: F5            push af
* cabinet upright/cocktail
30FA: 3A 00 B0      ld   a,(dip_switch_B000)
30FD: E6 20         and  $20
30FF: FE 20         cp   $20
3101: 28 08         jr   z,$310B
3103: E5            push hl
3104: EB            ex   de,hl
3105: 11 96 01      ld   de,$0196
3108: 19            add  hl,de
3109: EB            ex   de,hl
310A: E1            pop  hl
310B: F1            pop  af
310C: CD D9 55      call display_text_55d9
310F: C9            ret
3110: 11 5A 57      ld   de,$575A
3113: 21 A0 93      ld   hl,$93A0
3116: CD F9 30      call display_text_30F9
3119: 11 63 57      ld   de,$5763
311C: 21 20 91      ld   hl,$9120
311F: CD F9 30      call display_text_30F9
3122: C9            ret
3123: 3A 26 60      ld   a,(player_input_6026)
3126: FE A5         cp   $A5
3128: C0            ret  nz	;  strange mode????
3129: 11 62 36      ld   de,$3662
312C: 21 A2 93      ld   hl,$93A2
312F: CD F0 55      call write_text_55f0
3132: 11 7F 36      ld   de,$367F
3135: 21 A3 93      ld   hl,$93A3
3138: CD F0 55      call write_text_55f0
313B: 18 E6         jr   $3123
313D: DD 21 CC 61   ld   ix,unknown_61CC
3141: AF            xor  a
3142: DD 77 03      ld   (ix+$03),a
3145: 32 E0 61      ld   (pickaxe_timer_duration_61E0),a
3148: 32 E1 61      ld   (unknown_61E1),a
314B: 3E FF         ld   a,$FF
314D: 32 9F 65      ld   (unknown_659F),a
3150: C9            ret

draw_bag_3151:
3151: DD 7E 00      ld   a,(ix+$00)
3154: 6F            ld   l,a
3155: DD 7E 01      ld   a,(ix+$01)
3158: 67            ld   h,a
3159: 3A 0D 60      ld   a,(player_screen_600D)
315C: 47            ld   b,a
315D: DD 7E 02      ld   a,(ix+$02)
3160: B8            cp   b
3161: C0            ret  nz
3162: 3E D0         ld   a,$D0
3164: 77            ld   (hl),a
3165: E5            push hl
3166: CD 97 31      call set_bag_color_attribute_3197
3169: E1            pop  hl
316A: 23            inc  hl
* read screen tile
316B: 7E            ld   a,(hl)
316C: FE ED         cp   $ED
316E: 28 0C         jr   z,$317C
3170: FE EF         cp   $EF
3172: 28 08         jr   z,$317C
3174: 3E D1         ld   a,$D1
3176: 77            ld   (hl),a
3177: E5            push hl
3178: CD 97 31      call set_bag_color_attribute_3197
317B: E1            pop  hl
317C: 11 20 00      ld   de,$0020
317F: 19            add  hl,de
* read screen tile
3180: 7E            ld   a,(hl)
3181: FE D1         cp   $D1
3183: C8            ret  z
3184: FE 67         cp   $67
3186: C8            ret  z
3187: FE 27         cp   $27
3189: C8            ret  z
318A: FE ED         cp   $ED
318C: C8            ret  z
318D: FE EF         cp   $EF
318F: C8            ret  z
3190: 3E D3         ld   a,$D3
3192: 77            ld   (hl),a
3193: CD 97 31      call set_bag_color_attribute_3197
3196: C9            ret
set_bag_color_attribute_3197:
3197: 7C            ld   a,h
3198: FE 00         cp   $00
319A: C8            ret  z
319B: C6 08         add  a,$08
319D: 67            ld   h,a
319E: 3A 7A 62      ld   a,(bag_color_color_attribute_627A)
31A1: 77            ld   (hl),a
31A2: C9            ret
31A3: DD 21 94 65   ld   ix,guard_1_struct_6594
31A7: 3A 3B 60      ld   a,(guard_1_in_elevator_603B)
31AA: FE 01         cp   $01
31AC: C8            ret  z
31AD: 3A 56 61      ld   a,(unknown_6156)
31B0: FE 01         cp   $01
31B2: C8            ret  z
31B3: 3A 11 62      ld   a,(unknown_6211)
31B6: FE 01         cp   $01
31B8: C8            ret  z
31B9: CD DF 31      call reset_guard_position_31DF
31BC: 78            ld   a,b
31BD: 32 99 60      ld   (guard_1_screen_6099),a
31C0: C9            ret
31C1: DD 21 98 65   ld   ix,guard_2_struct_6598
31C5: 3A 7B 60      ld   a,(guard_2_in_elevator_607B)
31C8: FE 01         cp   $01
31CA: C8            ret  z
31CB: 3A 57 61      ld   a,(unknown_6157)
31CE: FE 01         cp   $01
31D0: C8            ret  z
31D1: 3A 12 62      ld   a,(unknown_6212)
31D4: FE 01         cp   $01
31D6: C8            ret  z
31D7: CD DF 31      call reset_guard_position_31DF
31DA: 78            ld   a,b
31DB: 32 9A 60      ld   (guard_2_screen_609A),a
31DE: C9            ret

reset_guard_position_31DF:
31DF: 3E 80         ld   a,$80
31E1: DD 77 02      ld   (ix+$02),a
31E4: 3E 10         ld   a,$10
31E6: DD 77 03      ld   (ix+$03),a
31E9: 06 03         ld   b,$03
31EB: 3A 0D 60      ld   a,(player_screen_600D)
31EE: FE 03         cp   $03
31F0: C0            ret  nz
31F1: 06 02         ld   b,$02
31F3: C9            ret

31F4: 3A F3 61      ld   a,(unknown_61F3)
31F7: FE 00         cp   $00
31F9: C8            ret  z
31FA: 3C            inc  a
31FB: C5            push bc
31FC: 47            ld   b,a
31FD: 3A 75 62      ld   a,(unknown_6275)
3200: FE 01         cp   $01
3202: 78            ld   a,b
3203: C1            pop  bc
3204: 20 06         jr   nz,$320C
3206: FE 30         cp   $30
3208: 20 0B         jr   nz,$3215
320A: 18 02         jr   $320E
320C: FE 17         cp   $17
320E: 20 05         jr   nz,$3215
3210: 3E 00         ld   a,$00
3212: 32 75 62      ld   (unknown_6275),a
3215: 32 F3 61      ld   (unknown_61F3),a
3218: C9            ret
3219: 3A 82 65      ld   a,(player_x_6582)
321C: FE E8         cp   $E8
321E: 3E 00         ld   a,$00
3220: 32 85 62      ld   (unknown_6285),a
3223: D4 43 32      call nc,$3243
3226: 3A 82 65      ld   a,(player_x_6582)
3229: FE 10         cp   $10
322B: DC 84 32      call c,$3284
322E: 3E 00         ld   a,$00
3230: 32 6F 62      ld   (unknown_626F),a
3233: CD FF 10      call $10FF
3236: F3            di
3237: AF            xor  a
3238: 32 00 A0      ld   (interrupt_control_A000),a
323B: FB            ei
323C: 3E 01         ld   a,$01
323E: 32 00 A0      ld   (interrupt_control_A000),a
3241: 00            nop
3242: C9            ret
3243: CD 74 33      call $3374
3246: 3A 0D 60      ld   a,(player_screen_600D)
3249: FE 01         cp   $01
324B: 20 14         jr   nz,$3261
324D: CD 5D 27      call $275D
3250: 3E 11         ld   a,$11
3252: 32 82 65      ld   (player_x_6582),a
3255: CD E3 33      call $33E3
3258: CD DC 22      call draw_bag_tiles_22dc
325B: CD B1 33      call $33B1
325E: C3 CE 32      jp   $32CE
3261: 3A 0D 60      ld   a,(player_screen_600D)
3264: FE 02         cp   $02
3266: 20 19         jr   nz,$3281
3268: 3A 87 65      ld   a,(elevator_y_current_screen_6587)
326B: 32 65 61      ld   (unknown_6165),a
326E: CD 5F 26      call $265F
3271: 3E 03         ld   a,$03
3273: 32 0D 60      ld   (player_screen_600D),a
3276: CD DC 22      call draw_bag_tiles_22dc
3279: 3E 11         ld   a,$11
327B: 32 82 65      ld   (player_x_6582),a
327E: CD B1 33      call $33B1
3281: C3 CE 32      jp   $32CE
3284: 3E 01         ld   a,$01
3286: 32 85 62      ld   (unknown_6285),a
3289: CD 74 33      call $3374
328C: 3A 0D 60      ld   a,(player_screen_600D)
328F: FE 01         cp   $01
3291: C8            ret  z
3292: FE 02         cp   $02
3294: 20 16         jr   nz,$32AC
3296: CD 4C 28      call display_maze_284c
3299: 3E 01         ld   a,$01
329B: 32 0D 60      ld   (player_screen_600D),a
329E: CD DC 22      call draw_bag_tiles_22dc
32A1: 3E E3         ld   a,$E3
32A3: 32 82 65      ld   (player_x_6582),a
32A6: CD B1 33      call $33B1
32A9: C3 CE 32      jp   $32CE
32AC: FE 03         cp   $03
32AE: C0            ret  nz
32AF: 3A 87 65      ld   a,(elevator_y_current_screen_6587)
32B2: 32 66 61      ld   (unknown_6166),a
32B5: DD 21 42 44   ld   ix,$4442
; bogus write, not read anywhere
32B9: DD 22 81 62   ld   (unknown_6281),ix
32BD: CD 5D 27      call $275D
32C0: 3E E3         ld   a,$E3
32C2: 32 82 65      ld   (player_x_6582),a
32C5: CD E3 33      call $33E3
32C8: CD DC 22      call draw_bag_tiles_22dc
32CB: CD B1 33      call $33B1
32CE: 3E 01         ld   a,$01
32D0: 32 03 A0      ld   ($A003),a
32D3: DD 21 94 65   ld   ix,guard_1_struct_6594
32D7: FD 21 80 65   ld   iy,player_struct_6580
32DB: FD 7E 03      ld   a,(iy+$03)
32DE: DD BE 03      cp   (ix+$03)
32E1: C2 FA 32      jp   nz,$32FA
32E4: DD 7E 02      ld   a,(ix+$02)
32E7: FE CD         cp   $CD
32E9: 38 05         jr   c,$32F0
32EB: CD 4E 36      call $364E
32EE: 18 0A         jr   $32FA
32F0: DD 7E 02      ld   a,(ix+$02)
32F3: FE 26         cp   $26
32F5: 30 03         jr   nc,$32FA
32F7: CD 4E 36      call $364E
32FA: DD 21 98 65   ld   ix,guard_2_struct_6598
32FE: FD 21 80 65   ld   iy,player_struct_6580
3302: FD 7E 03      ld   a,(iy+$03)
3305: DD BE 03      cp   (ix+$03)
3308: C2 21 33      jp   nz,$3321
330B: DD 7E 02      ld   a,(ix+$02)
330E: FE E0         cp   $E0
3310: 38 05         jr   c,$3317
3312: CD 58 36      call $3658
3315: 18 0A         jr   $3321
3317: DD 7E 02      ld   a,(ix+$02)
331A: FE 10         cp   $10
331C: 30 03         jr   nc,$3321
331E: CD 58 36      call $3658
3321: 3A 1C 60      ld   a,(unknown_601C)
3324: FE 01         cp   $01
3326: C8            ret  z
3327: 3A 1D 60      ld   a,(unknown_601D)
332A: FE 01         cp   $01
332C: C8            ret  z
332D: 3A 1E 60      ld   a,(unknown_601E)
3330: FE 01         cp   $01
3332: C8            ret  z
3333: 21 83 65      ld   hl,player_y_6583
3336: DD 21 8C 65   ld   ix,unknown_658C
333A: 7E            ld   a,(hl)
333B: FE 40         cp   $40
333D: 20 05         jr   nz,$3344
333F: CD 69 33      call $3369
3342: 18 17         jr   $335B
3344: DD 21 88 65   ld   ix,unknown_6588
3348: FE E0         cp   $E0
334A: 20 05         jr   nz,$3351
334C: CD 69 33      call $3369
334F: 18 0A         jr   $335B
3351: DD 21 90 65   ld   ix,unknown_6590
3355: FE C8         cp   $C8
3357: C0            ret  nz
3358: CD 69 33      call $3369
335B: 06 30         ld   b,$30
335D: C5            push bc
335E: CD F4 08      call $08F4
3361: C1            pop  bc
3362: 10 F9         djnz $335D
3364: AF            xor  a
3365: 32 25 60      ld   (player_death_flag_6025),a
3368: C9            ret
3369: DD 7E 02      ld   a,(ix+$02)
336C: FE D8         cp   $D8
336E: D0            ret  nc
336F: FE 18         cp   $18
3371: D8            ret  c
; this is probably incorrect, as instructions above return
; but below we pop the stack first which results in a crash
3372: F1            pop  af
3373: C9            ret
3374: AF            xor  a
3375: 32 03 A0      ld   ($A003),a
3378: 3A C7 61      ld   a,(holds_barrow_61C7)
337B: FE 00         cp   $00
337D: CC 25 1F      call z,$1F25
3380: 3A 59 61      ld   a,(unknown_6159)
3383: FE 00         cp   $00
3385: 28 0C         jr   z,$3393
3387: 3A 9F 65      ld   a,(unknown_659F)
338A: 3C            inc  a
338B: 32 9F 65      ld   (unknown_659F),a
338E: CD 83 16      call $1683
3391: 18 E1         jr   $3374
3393: 3A 3B 60      ld   a,(guard_1_in_elevator_603B)
3396: FE 01         cp   $01
3398: 20 08         jr   nz,$33A2
339A: 3E 01         ld   a,$01
339C: 32 EB 61      ld   (unknown_61EB),a
339F: 32 3A 60      ld   (unknown_603A),a
33A2: 3A 7B 60      ld   a,(guard_2_in_elevator_607B)
33A5: FE 01         cp   $01
33A7: C0            ret  nz
33A8: 3E 01         ld   a,$01
33AA: 32 EC 61      ld   (unknown_61EC),a
33AD: 32 7A 60      ld   (unknown_607A),a
33B0: C9            ret
33B1: DD 21 19 60   ld   ix,unknown_6019
33B5: 21 82 65      ld   hl,player_x_6582
33B8: FD 21 8A 65   ld   iy,wagon_data_658A
33BC: 11 04 00      ld   de,$0004
33BF: CD D1 33      call $33D1
33C2: DD 23         inc  ix
33C4: FD 19         add  iy,de
33C6: CD D1 33      call $33D1
33C9: DD 23         inc  ix
33CB: FD 19         add  iy,de
33CD: CD D1 33      call $33D1
33D0: C9            ret
33D1: DD 7E 03      ld   a,(ix+$03)
33D4: FE 00         cp   $00
33D6: C8            ret  z
33D7: 7E            ld   a,(hl)
33D8: FD 77 00      ld   (iy+$00),a
33DB: 3A 0D 60      ld   a,(player_screen_600D)
33DE: 3D            dec  a
33DF: DD 77 00      ld   (ix+$00),a
33E2: C9            ret
33E3: 3A 7D 62      ld   a,(unknown_627D)
33E6: 32 18 93      ld   ($9318),a
33E9: FE E0         cp   $E0
33EB: 28 01         jr   z,$33EE
33ED: 3D            dec  a
33EE: 32 19 93      ld   ($9319),a
33F1: 3E 02         ld   a,$02
33F3: 32 0D 60      ld   (player_screen_600D),a
33F6: 3E 53         ld   a,$53
33F8: E5            push hl
33F9: D5            push de
33FA: C5            push bc
33FB: 21 B6 93      ld   hl,$93B6
33FE: 11 E0 FF      ld   de,$FFE0
3401: 06 06         ld   b,$06
3403: 77            ld   (hl),a
3404: 3D            dec  a
3405: F5            push af
3406: E5            push hl
3407: 7C            ld   a,h
3408: C6 08         add  a,$08
340A: 67            ld   h,a
340B: 3E 1F         ld   a,$1F
340D: 77            ld   (hl),a
340E: E1            pop  hl
340F: F1            pop  af
3410: 19            add  hl,de
3411: 10 F0         djnz $3403
3413: C1            pop  bc
3414: D1            pop  de
3415: E1            pop  hl
3416: C9            ret

draw_wheelbarrow_tiles_3417:
* check code in case screen MSB address is null
3417: C5            push bc
3418: 47            ld   b,a
3419: 7C            ld   a,h
341A: FE 00         cp   $00
341C: 78            ld   a,b
341D: C1            pop  bc
341E: C8            ret  z
341F: F5            push af
* read screen tile
3420: 7E            ld   a,(hl)
3421: FE D0         cp   $D0		| if bag top don't draw tile
3423: 28 06         jr   z,$342B
3425: F1            pop  af
3426: CD 41 34      call $3441
3429: 18 01         jr   $342C
342B: F1            pop  af
342C: 23            inc  hl
342D: 3C            inc  a
342E: CD 41 34      call $3441
3431: D5            push de
3432: 11 1F 00      ld   de,$001F
3435: 19            add  hl,de
3436: D1            pop  de
3437: 3C            inc  a
3438: CD 41 34      call $3441
343B: 23            inc  hl
343C: 3C            inc  a
343D: CD 41 34      call $3441
3440: C9            ret
3441: 77            ld   (hl),a
3442: E5            push hl
3443: F5            push af
3444: 7C            ld   a,h
3445: C6 08         add  a,$08
3447: 67            ld   h,a
3448: 08            ex   af,af'
3449: 77            ld   (hl),a
344A: 08            ex   af,af'
344B: F1            pop  af
344C: E1            pop  hl
344D: C9            ret
344E: 3A 5E 61      ld   a,(unknown_615E)
3451: FE 01         cp   $01
3453: C0            ret  nz
3454: DD 21 94 65   ld   ix,guard_1_struct_6594
3458: CD 6D 34      call $346D
345B: FE 01         cp   $01
345D: CC 41 22      call z,$2241
3460: DD 21 98 65   ld   ix,guard_2_struct_6598
3464: CD 6D 34      call $346D
3467: FE 01         cp   $01
3469: CC 7C 22      call z,$227C
346C: C9            ret
346D: FD 21 9C 65   ld   iy,unknown_659C
3471: FD 7E 02      ld   a,(iy+$02)
3474: DD BE 02      cp   (ix+$02)
3477: 28 06         jr   z,$347F
3479: 3C            inc  a
347A: DD BE 02      cp   (ix+$02)
347D: 20 1F         jr   nz,$349E
347F: FD 7E 03      ld   a,(iy+$03)
3482: 3C            inc  a
3483: 3C            inc  a
3484: DD BE 03      cp   (ix+$03)
3487: 28 18         jr   z,$34A1
3489: 3D            dec  a
348A: DD BE 03      cp   (ix+$03)
348D: 28 12         jr   z,$34A1
348F: 3D            dec  a
3490: DD BE 03      cp   (ix+$03)
3493: 28 0C         jr   z,$34A1
3495: 3D            dec  a
3496: DD BE 03      cp   (ix+$03)
3499: 28 06         jr   z,$34A1
349B: 3D            dec  a
349C: 28 03         jr   z,$34A1
349E: 3E 00         ld   a,$00
34A0: C9            ret
34A1: 3E 01         ld   a,$01
34A3: C9            ret

* pulses A004 to 1 when coin is inserted
* not useful for game per se, only to compute
* machine rentability
log_inserted_coins_34A4:
34A4: 21 04 A0      ld   hl,$A004
34A7: FD 21 E5 61   ld   iy,unknown_61E5
34AB: FD 7E 00      ld   a,(iy+$00)
34AE: FE 00         cp   $00
34B0: 28 16         jr   z,$34C8
34B2: FD 34 01      inc  (iy+$01)
34B5: FD 7E 01      ld   a,(iy+$01)
34B8: FE 10         cp   $10
34BA: 38 0C         jr   c,$34C8
34BC: FE 20         cp   $20
34BE: 38 0B         jr   c,$34CB
34C0: FD 35 00      dec  (iy+$00)
34C3: AF            xor  a
34C4: FD 77 01      ld   (iy+$01),a
34C7: C9            ret
34C8: AF            xor  a
34C9: 77            ld   (hl),a
34CA: C9            ret
34CB: 3E 01         ld   a,$01
34CD: 77            ld   (hl),a
34CE: C9            ret
; sync on vertical blank
34CF: 3A 00 A0      ld   a,(vertical_beam_pos_A000)
34D2: E6 3F         and  $3F
34D4: 47            ld   b,a
34D5: 00            nop
34D6: 10 FD         djnz $34D5
	;; extra life test depending on dip switch: 30000 or 40000
34D8: 3A 00 B0      ld   a,(dip_switch_B000)
34DB: E6 40         and  $40
34DD: FE 40         cp   $40
34DF: 3E 03         ld   a,$03		; 30000 points
34E1: 28 02         jr   z,$34E5
34E3: 3E 04         ld   a,$04		; 40000 points
34E5: 47            ld   b,a
34E6: 3A 7C 61      ld   a,(current_player_617C)
34E9: FE 01         cp   $01
34EB: 3A 78 61      ld   a,(score_ten_thousands_player_1_6178)
34EE: 20 03         jr   nz,$34F3
34F0: 3A 7B 61      ld   a,(score_ten_thousands_player_2_617B)
34F3: B8            cp   b
34F4: 30 05         jr   nc,$34FB
34F6: AF            xor  a
34F7: 32 86 62      ld   (extra_life_awarded_6286),a
34FA: C9            ret
34FB: 3A 86 62      ld   a,(extra_life_awarded_6286)
34FE: FE 00         cp   $00
3500: C0            ret  nz
3501: 3A 56 60      ld   a,(lives_6056)
3504: 3C            inc  a
3505: 32 56 60      ld   (lives_6056),a
3508: 3E 01         ld   a,$01
350A: 32 86 62      ld   (extra_life_awarded_6286),a
350D: C9            ret
350E: 7E            ld   a,(hl)
350F: FE E0         cp   $E0
3511: 20 23         jr   nz,$3536
3513: 3A 0D 60      ld   a,(player_screen_600D)
3516: B8            cp   b
3517: 28 1D         jr   z,$3536
3519: 78            ld   a,b
351A: FE 02         cp   $02
351C: 01 65 61      ld   bc,unknown_6165
351F: 28 05         jr   z,$3526
3521: FE 03         cp   $03
3523: 01 66 61      ld   bc,unknown_6166
3526: 0A            ld   a,(bc)
3527: FE 10         cp   $10
3529: D8            ret  c
352A: 08            ex   af,af'
352B: FE 00         cp   $00
352D: 20 03         jr   nz,$3532
352F: 0A            ld   a,(bc)
3530: 3D            dec  a
3531: 02            ld   (bc),a
3532: 1A            ld   a,(de)
3533: 3D            dec  a
3534: 12            ld   (de),a
3535: C9            ret
3536: AF            xor  a
3537: DD 77 00      ld   (ix+$00),a
353A: FD 77 00      ld   (iy+$00),a
353D: C9            ret
decrease_timer_353e:
353E: 21 E7 61      ld   hl,timer_high_prec_61E7
3541: 7E            ld   a,(hl)
3542: D6 01         sub  $01
3544: 27            daa
3545: 77            ld   (hl),a
3546: F5            push af
3547: 23            inc  hl
3548: F1            pop  af
3549: 7E            ld   a,(hl)
354A: DE 00         sbc  a,$00
354C: 27            daa
354D: 77            ld   (hl),a
354E: C9            ret

set_bags_coordinates_hard_level_354f:
354F: 11 9C 60      ld   de,bags_coordinates_609C
3552: 21 54 5C      ld   hl,$5C54
3555: 01 3A 00      ld   bc,$003A
3558: ED B0         ldir
355A: C9            ret

set_bags_coordinates_355b:
355B: 11 9C 60      ld   de,bags_coordinates_609C
355E: 21 E8 5A      ld   hl,$5AE8
3561: 01 3A 00      ld   bc,$003A
3564: ED B0         ldir
3566: C9            ret

set_bags_coordinates_3567:
3567: 11 7F 61      ld   de,bags_coordinates_617F
356A: 21 E8 5A      ld   hl,$5AE8
356D: 01 3A 00      ld   bc,$003A
3570: ED B0         ldir
3572: C9            ret

* check if tile can be walked into
is_background_tile_3573:
3573: FE E0         cp   $E0	| blank
3575: C8            ret  z
3576: FE 4B         cp   $4B	| pillar, etc...
3578: C8            ret  z
3579: FE 4A         cp   $4A
357B: C8            ret  z
357C: FE 49         cp   $49
357E: C8            ret  z
357F: FE E4         cp   $E4
3581: C8            ret  z
3582: FE E6         cp   $E6
3584: C9            ret
3585: E5            push hl
3586: C5            push bc
3587: 01 E0 FF      ld   bc,$FFE0
358A: 09            add  hl,bc
358B: AF            xor  a
358C: ED 52         sbc  hl,de
358E: C1            pop  bc
358F: E1            pop  hl
3590: C9            ret
3591: 3A 7D 61      ld   a,(unknown_617D)
3594: FE 01         cp   $01
3596: C8            ret  z
3597: 3E 01         ld   a,$01
3599: 32 53 60      ld   (unknown_6053),a
359C: 32 8C 62      ld   (unknown_628C),a
359F: CD 2C 2A      call $2A2C
35A2: 11 5A 57      ld   de,$575A
35A5: 21 74 92      ld   hl,$9274
35A8: CD F9 30      call display_text_30F9
35AB: 11 89 56      ld   de,$5689
35AE: 21 9F 91      ld   hl,$919F
35B1: CD F9 30      call display_text_30F9
35B4: 3A 7C 61      ld   a,(current_player_617C)
35B7: 3C            inc  a
35B8: 32 94 91      ld   ($9194),a
35BB: 3E 08         ld   a,$08
35BD: 21 7F 98      ld   hl,$987F
35C0: CD 05 56      call write_attribute_on_line_5605
35C3: 3E 00         ld   a,$00
35C5: 32 5F 98      ld   ($985F),a
35C8: 3E 05         ld   a,$05
35CA: 21 41 98      ld   hl,$9841
35CD: CD 05 56      call write_attribute_on_line_5605
35D0: 3E 02         ld   a,$02
35D2: 21 40 98      ld   hl,$9840
35D5: CD 05 56      call write_attribute_on_line_5605
35D8: 21 93 92      ld   hl,$9293
35DB: 11 38 36      ld   de,$3638
35DE: 3E 1F         ld   a,$1F
35E0: 08            ex   af,af'
35E1: CD F0 55      call write_text_55f0
35E4: 21 95 92      ld   hl,$9295
35E7: 11 43 36      ld   de,$3643
35EA: 3E 1F         ld   a,$1F
35EC: 08            ex   af,af'
35ED: CD F0 55      call write_text_55f0
35F0: 3E 8E         ld   a,$8E
35F2: 32 74 91      ld   ($9174),a
35F5: 3E 8B         ld   a,$8B
35F7: 32 94 92      ld   ($9294),a
35FA: 3E 1F         ld   a,$1F
35FC: 32 74 99      ld   ($9974),a
35FF: 32 94 9A      ld   ($9A94),a
3602: CD BE 39      call write_credits_and_lives_39be
3605: 3E 00         ld   a,$00
3607: 32 03 98      ld   ($9803),a
360A: 32 07 98      ld   ($9807),a
360D: 32 0B 98      ld   ($980B),a
3610: 32 0F 98      ld   ($980F),a
3613: 32 13 98      ld   ($9813),a
3616: 32 17 98      ld   ($9817),a
3619: 32 1B 98      ld   ($981B),a
361C: 32 1F 98      ld   ($981F),a
361F: 06 06         ld   b,$06
3621: 21 00 00      ld   hl,$0000
3624: 2B            dec  hl
3625: 3A 00 B8      ld   a,(io_read_shit_B800)
3628: 7C            ld   a,h
3629: FE 00         cp   $00
362B: 20 F7         jr   nz,$3624
362D: 10 F2         djnz $3621
362F: 3E 00         ld   a,$00
3631: 32 53 60      ld   (unknown_6053),a
3634: 32 8C 62      ld   (unknown_628C),a
3637: C9            ret



	;; routine to perform several guard moves, sometimes at screen boundary
	;; no more info
364E: 06 60         ld   b,$60
3650: C5            push bc
3651: CD 6F 11      call guard_1_movement_116F
3654: C1            pop  bc
3655: 10 F9         djnz $3650
3657: C9            ret
3658: 06 60         ld   b,$60
365A: C5            push bc
365B: CD 9B 11      call guard_2_movement_119B
365E: C1            pop  bc
365F: 10 F9         djnz $365A
3661: C9            ret

* shows title, guard chases bagman, bagman fights back
play_intro_3700:
3700: 3E 00         ld   a,$00
3702: 32 03 A0      ld   ($A003),a
3705: CD 00 2A      call clear_screen_2a00
3708: 3E 3F         ld   a,$3F
370A: CD EC 29      call change_attribute_everywhere_29ec
370D: CD EC 1D      call display_player_ids_and_credit_1dec
3710: 3E 01         ld   a,$01
3712: 32 0D 60      ld   (player_screen_600D),a
3715: 32 03 A0      ld   ($A003),a
3718: 32 98 60      ld   (screen_index_param_6098),a
371B: 32 99 60      ld   (guard_1_screen_6099),a
371E: 32 9A 60      ld   (guard_2_screen_609A),a
3721: AF            xor  a
3722: 32 08 60      ld   (unknown_6008),a
3725: 32 37 60      ld   (unknown_6037),a
3728: 32 4E 60      ld   (fatal_fall_height_reached_604E),a
372B: 32 77 60      ld   (unknown_6077),a
372E: 32 87 65      ld   (elevator_y_current_screen_6587),a
3731: 32 9A 65      ld   (guard_2_x_659A),a
3734: 32 9B 65      ld   (guard_2_y_659B),a
3737: 32 59 61      ld   (unknown_6159),a
373A: 32 CF 61      ld   (has_pick_61CF),a
373D: 32 E0 61      ld   (pickaxe_timer_duration_61E0),a
3740: 32 E1 61      ld   (unknown_61E1),a
3743: 3E 01         ld   a,$01
3745: 32 ED 61      ld   (check_scenery_disabled_61ED),a
3748: CD 4D 2C      call compute_guard_speed_from_dipsw_2C4D
374B: 21 1A 90      ld   hl,$901A
374E: 11 20 00      ld   de,$0020
3751: 3E F0         ld   a,$F0
3753: 06 20         ld   b,$20
3755: 77            ld   (hl),a
3756: E5            push hl
3757: F5            push af
3758: 7C            ld   a,h
3759: C6 08         add  a,$08
375B: 67            ld   h,a
375C: 3E 04         ld   a,$04
375E: 77            ld   (hl),a
375F: F1            pop  af
3760: E1            pop  hl
3761: 19            add  hl,de
3762: 10 F1         djnz $3755
3764: CD D7 38      call check_if_credit_inserted_38d7
3767: 3E 01         ld   a,$01
3769: 32 54 60      ld   (gameplay_allowed_6054),a
376C: 11 80 65      ld   de,player_struct_6580
376F: 21 EE 38      ld   hl,$38EE
3772: 01 04 00      ld   bc,$0004
3775: ED B0         ldir
3777: 11 9C 65      ld   de,unknown_659C
377A: 21 F2 38      ld   hl,$38F2
377D: 01 04 00      ld   bc,$0004
3780: ED B0         ldir
3782: 3A 74 62      ld   a,(is_intermission_6274)
3785: FE 01         cp   $01
3787: CA 00 38      jp   z,$3800
; draw V=A logo + PRESENTE
378A: 11 00 4C      ld   de,$4C00
378D: 21 86 92      ld   hl,$9286
3790: 3E 16         ld   a,$16
3792: 08            ex   af,af'
3793: CD F0 55      call write_text_55f0
3796: 11 0B 4C      ld   de,$4C0B
3799: 21 87 92      ld   hl,$9287
379C: 3E 16         ld   a,$16
379E: 08            ex   af,af'
379F: CD F0 55      call write_text_55f0
37A2: 11 16 4C      ld   de,$4C16
37A5: 21 88 92      ld   hl,$9288
37A8: 3E 16         ld   a,$16
37AA: 08            ex   af,af'
37AB: CD F0 55      call write_text_55f0
37AE: 11 21 4C      ld   de,$4C21
37B1: 21 6B 92      ld   hl,$926B
37B4: 3E 13         ld   a,$13
37B6: 08            ex   af,af'
37B7: CD F0 55      call write_text_55f0
37BA: 3A 00 B0      ld   a,(dip_switch_B000)
37BD: E6 20         and  $20
37BF: FE 20         cp   $20
37C1: 20 0A         jr   nz,$37CD
; english: change last "E" of "PRESENTE" by "S"
37C3: 3E E1         ld   a,$E1
37C5: 32 8B 91      ld   ($918B),a
37C8: 3E 13         ld   a,$13
37CA: 32 8B 99      ld   ($998B),a
37CD: 11 2A 4C      ld   de,$4C2A
37D0: 21 8E 93      ld   hl,$938E
37D3: 3E 17         ld   a,$17
37D5: 08            ex   af,af'
37D6: CD F0 55      call write_text_55f0
37D9: 11 45 4C      ld   de,$4C45
37DC: 21 8F 93      ld   hl,$938F
37DF: 3E 17         ld   a,$17
37E1: 08            ex   af,af'
37E2: CD F0 55      call write_text_55f0
37E5: 11 60 4C      ld   de,$4C60
37E8: 21 90 93      ld   hl,$9390
37EB: 3E 17         ld   a,$17
37ED: 08            ex   af,af'
37EE: CD F0 55      call write_text_55f0
37F1: 11 7B 4C      ld   de,$4C7B
37F4: 21 52 92      ld   hl,$9252
37F7: 3E 12         ld   a,$12
37F9: 08            ex   af,af'
37FA: CD F0 55      call write_text_55f0
37FD: ED 56         im   1
37FF: FF            rst  $38
3800: 3A 26 60      ld   a,(player_input_6026)
3803: F6 08         or   $08
3805: FB            ei
3806: 32 26 60      ld   (player_input_6026),a
3809: 3E 01         ld   a,$01
380B: 32 C7 61      ld   (holds_barrow_61C7),a
380E: CD D7 38      call check_if_credit_inserted_38d7
3811: 3A 74 62      ld   a,(is_intermission_6274)
3814: FE 01         cp   $01
3816: 28 08         jr   z,$3820
3818: 3E 01         ld   a,$01
* flip & mirror screen: now upright
381A: 32 01 A0      ld   ($A001),a
381D: 32 02 A0      ld   ($A002),a
3820: 3A 82 65      ld   a,(player_x_6582)
3823: FE 20         cp   $20
3825: 20 D9         jr   nz,$3800
3827: 3A 26 60      ld   a,(player_input_6026)
382A: F6 10         or   $10
382C: 32 26 60      ld   (player_input_6026),a
382F: CD D7 38      call check_if_credit_inserted_38d7
3832: 3A 82 65      ld   a,(player_x_6582)
3835: FE 20         cp   $20
3837: 20 EE         jr   nz,$3827
3839: 11 94 65      ld   de,guard_1_struct_6594
383C: 21 F6 38      ld   hl,$38F6
383F: 01 04 00      ld   bc,$0004
3842: ED B0         ldir
3844: 3A 26 60      ld   a,(player_input_6026)
3847: F6 10         or   $10
3849: 32 26 60      ld   (player_input_6026),a
384C: 3E 80         ld   a,$80
384E: 32 27 60      ld   (guard_1_direction_6027),a
3851: CD D7 38      call check_if_credit_inserted_38d7
3854: 3A 82 65      ld   a,(player_x_6582)
3857: FE F0         cp   $F0
3859: 20 E9         jr   nz,$3844
385B: CD D7 38      call check_if_credit_inserted_38d7
385E: 3A 96 65      ld   a,(guard_1_x_6596)
3861: FE D0         cp   $D0
3863: 20 F6         jr   nz,$385B
3865: 3E 00         ld   a,$00
3867: 32 C7 61      ld   (holds_barrow_61C7),a
386A: 3E 01         ld   a,$01
386C: 32 CF 61      ld   (has_pick_61CF),a
386F: 3E 37         ld   a,$37
3871: 32 9C 65      ld   (unknown_659C),a
3874: 3A 26 60      ld   a,(player_input_6026)
3877: F6 08         or   $08
3879: 32 26 60      ld   (player_input_6026),a
387C: 3E 40         ld   a,$40
387E: 32 27 60      ld   (guard_1_direction_6027),a
3881: CD D7 38      call check_if_credit_inserted_38d7
3884: 3A 82 65      ld   a,(player_x_6582)
3887: FE 10         cp   $10
3889: 38 39         jr   c,$38C4
388B: 3A 74 62      ld   a,(is_intermission_6274)
388E: FE 01         cp   $01
3890: 28 07         jr   z,$3899
3892: 3A 48 92      ld   a,($9248)
3895: FE F6         cp   $F6
3897: 20 2B         jr   nz,$38C4
3899: 3A 82 65      ld   a,(player_x_6582)
389C: FE 03         cp   $03
389E: DD 21 94 65   ld   ix,guard_1_struct_6594
38A2: FD 21 9C 65   ld   iy,unknown_659C
38A6: 0E 00         ld   c,$00
38A8: 06 06         ld   b,$06
38AA: CD D5 2A      call $2AD5
38AD: FE 01         cp   $01
38AF: 20 C3         jr   nz,$3874
38B1: CD 41 22      call $2241
38B4: 06 03         ld   b,$03
38B6: 21 00 50      ld   hl,$5000
38B9: 2B            dec  hl
38BA: CD D7 38      call check_if_credit_inserted_38d7
38BD: 7C            ld   a,h
38BE: FE 00         cp   $00
38C0: 20 F7         jr   nz,$38B9
38C2: 10 F2         djnz $38B6
38C4: 3E 00         ld   a,$00
38C6: C3 69 5E      jp   $5E69
38C9: 06 01         ld   b,$01
38CB: 21 80 65      ld   hl,player_struct_6580
38CE: 3E 00         ld   a,$00
38D0: 32 54 60      ld   (gameplay_allowed_6054),a
38D3: CD F1 29      call $29F1
38D6: C9            ret

check_if_credit_inserted_38d7:
38D7: 3A 00 60      ld   a,(number_of_credits_6000)
38DA: FE 00         cp   $00
38DC: C8            ret  z
; a credit was inserted
38DD: 3A 74 62      ld   a,(is_intermission_6274)
38E0: FE 01         cp   $01
38E2: C8            ret  z  ; credit inserted during intermission does nothing
; but if we're displaying intro, then exit intro
38E3: 3E 00         ld   a,$00
38E5: 32 ED 61      ld   (check_scenery_disabled_61ED),a
38E8: 3A 00 B8      ld   a,(io_read_shit_B800)
38EB: E1            pop  hl
38EC: 18 D6         jr   $38C4
38EE: 20 08         jr   nz,$38F8
38F0: F0            ret  p
38F1: C0            ret  nz
38F2: 3A 28 E5      ld   a,($E528)
38F5: C0            ret  nz
38F6: 31 0C 00      ld   sp,$000C
38F9: C0            ret  nz
38FA: CD 07 39      call $3907
38FD: CD 24 39      call $3924
3900: CD 41 39      call $3941
3903: CD 5E 39      call $395E
3906: C9            ret
3907: 3A 26 60      ld   a,(player_input_6026)
390A: E6 01         and  $01
390C: 47            ld   b,a
390D: 3A 50 60      ld   a,(player_move_direction_6050)
3910: E6 01         and  $01
3912: B8            cp   b
3913: C8            ret  z
3914: 3A 50 60      ld   a,(player_move_direction_6050)
3917: E6 01         and  $01
3919: FE 01         cp   $01
391B: C0            ret  nz
391C: 3E 01         ld   a,$01
391E: 0E 01         ld   c,$01
3920: CD 7B 39      call $397B
3923: C9            ret
3924: 3A 26 60      ld   a,(player_input_6026)
3927: E6 02         and  $02
3929: 47            ld   b,a
392A: 3A 50 60      ld   a,(player_move_direction_6050)
392D: E6 02         and  $02
392F: B8            cp   b
3930: C8            ret  z
3931: 3A 50 60      ld   a,(player_move_direction_6050)
3934: E6 02         and  $02
3936: FE 02         cp   $02
3938: C0            ret  nz
3939: 3E 02         ld   a,$02
393B: 0E 02         ld   c,$02
393D: CD 7B 39      call $397B
3940: C9            ret
3941: 3A 51 60      ld   a,(unknown_6051)
3944: E6 01         and  $01
3946: 47            ld   b,a
3947: 3A 52 60      ld   a,(unknown_6052)
394A: E6 01         and  $01
394C: B8            cp   b
394D: C8            ret  z
394E: 3A 52 60      ld   a,(unknown_6052)
3951: E6 01         and  $01
3953: FE 01         cp   $01
3955: C0            ret  nz
3956: 3E 06         ld   a,$06
3958: 0E 05         ld   c,$05
395A: CD 7B 39      call $397B
395D: C9            ret
395E: 3A 51 60      ld   a,(unknown_6051)
3961: E6 02         and  $02
3963: 47            ld   b,a
3964: 3A 52 60      ld   a,(unknown_6052)
3967: E6 02         and  $02
3969: B8            cp   b
396A: C8            ret  z
396B: 3A 52 60      ld   a,(unknown_6052)
396E: E6 02         and  $02
3970: FE 02         cp   $02
3972: C0            ret  nz
3973: 3E 0E         ld   a,$0E
3975: 0E 0A         ld   c,$0A
3977: CD 7B 39      call $397B
397A: C9            ret
397B: F5            push af
397C: CD F6 39      call $39F6
397F: F1            pop  af
3980: 47            ld   b,a
3981: 3A 63 61      ld   a,(unknown_6163)
3984: E6 04         and  $04
3986: FE 04         cp   $04
3988: 78            ld   a,b
3989: 28 01         jr   z,$398C
398B: 87            add  a,a
398C: 21 E4 61      ld   hl,unknown_61E4
398F: 86            add  a,(hl)
3990: 77            ld   (hl),a
3991: FE 02         cp   $02
3993: D4 97 39      call nc,$3997
3996: C9            ret
3997: 21 E4 61      ld   hl,unknown_61E4
399A: 7E            ld   a,(hl)
399B: FE 02         cp   $02
399D: D8            ret  c
399E: 3A 00 60      ld   a,(number_of_credits_6000)
39A1: FE 90         cp   $90
39A3: C8            ret  z
39A4: C6 01         add  a,$01
39A6: 27            daa
39A7: 32 00 60      ld   (number_of_credits_6000),a
39AA: 21 E4 61      ld   hl,unknown_61E4
39AD: 35            dec  (hl)
39AE: 35            dec  (hl)
39AF: 21 68 5B      ld   hl,$5B68
39B2: 22 40 61      ld   (unknown_pointer_6140),hl
39B5: AF            xor  a
39B6: 32 42 61      ld   (unknown_6142),a
39B9: CD BE 39      call write_credits_and_lives_39be
39BC: 18 D9         jr   $3997

write_credits_and_lives_39be:
39BE: 3A 00 60      ld   a,(number_of_credits_6000)
39C1: E6 0F         and  $0F
39C3: 32 9F 90      ld   ($909F),a
39C6: 3A 00 60      ld   a,(number_of_credits_6000)
39C9: CB 0F         rrc  a
39CB: CB 0F         rrc  a
39CD: CB 0F         rrc  a
39CF: CB 0F         rrc  a
39D1: E6 0F         and  $0F
39D3: 32 BF 90      ld   ($90BF),a
39D6: 3E E0         ld   a,$E0
39D8: 06 07         ld   b,$07
39DA: 21 9F 93      ld   hl,$939F
39DD: CD BC 29      call write_text_29bc
39E0: 3A 56 60      ld   a,(lives_6056)
39E3: FE 00         cp   $00
39E5: C8            ret  z
39E6: 21 9F 93      ld   hl,$939F
39E9: 47            ld   b,a
39EA: 3E CA         ld   a,$CA
39EC: CD BC 29      call write_text_29bc
39EF: C9            ret

39F6: 79            ld   a,c                                            
39F7: 21 E5 61      ld   hl,unknown_61E5
39FA: 86            add  a,(hl)
39FB: 77            ld   (hl),a
39FC: C9            ret

read_player_controls_39fd:
39FD: 3A 26 60      ld   a,(player_input_6026)
3A00: 32 50 60      ld   (player_move_direction_6050),a
3A03: AF            xor  a
3A04: 32 07 A0      ld   ($A007),a
3A07: 3E 07         ld   a,$07
3A09: D3 08         out  ($08),a
3A0B: 3E 38         ld   a,$38
3A0D: D3 09         out  ($09),a
3A0F: 3E 0E         ld   a,$0E
3A11: D3 08         out  ($08),a
3A13: DB 0C         in   a,($0C)
3A15: 2F            cpl
3A16: CD 3F 3A      call $3A3F
3A19: CD 54 3A      call $3A54
3A1C: 32 26 60      ld   (player_input_6026),a
3A1F: 3A 51 60      ld   a,(unknown_6051)
3A22: 32 52 60      ld   (unknown_6052),a
3A25: 3E 0F         ld   a,$0F
3A27: D3 08         out  ($08),a
3A29: DB 0C         in   a,($0C)
3A2B: 2F            cpl
3A2C: CD 3F 3A      call $3A3F
3A2F: 32 51 60      ld   (unknown_6051),a
3A32: 3A 00 B0      ld   a,(dip_switch_B000)
3A35: 2F            cpl
3A36: 32 63 61      ld   (unknown_6163),a
3A39: 3E 01         ld   a,$01
3A3B: 32 07 A0      ld   ($A007),a
3A3E: C9            ret
3A3F: F5            push af
3A40: 3A ED 61      ld   a,(check_scenery_disabled_61ED)
3A43: FE 01         cp   $01
3A45: 28 09         jr   z,$3A50
3A47: 3A F2 61      ld   a,(unknown_61F2)
3A4A: FE 01         cp   $01
3A4C: 28 02         jr   z,$3A50
3A4E: F1            pop  af
3A4F: C9            ret
3A50: F1            pop  af
3A51: E6 07         and  $07
3A53: C9            ret
3A54: 47            ld   b,a
3A55: 3A 00 B0      ld   a,(dip_switch_B000)
3A58: 2F            cpl
3A59: CB 07         rlc  a
3A5B: E6 01         and  $01
3A5D: 4F            ld   c,a
3A5E: 3A 7C 61      ld   a,(current_player_617C)
3A61: A1            and  c
3A62: 32 FD 61      ld   (unknown_61FD),a
3A65: FE 01         cp   $01
3A67: 28 02         jr   z,$3A6B
3A69: 78            ld   a,b
3A6A: C9            ret

3A6B: 3A 51 60      ld   a,(unknown_6051)
3A6E: E6 F8         and  $F8
3A70: 4F            ld   c,a
3A71: 78            ld   a,b
3A72: E6 07         and  $07
3A74: B1            or   c
3A75: C9            ret

3B00: CD 8C 3B      call check_remaining_bags_3BBC
3B03: 79            ld   a,c
3B04: FE 00         cp   $00
3B06: C8            ret  z
; level completed
3B07: 01 C7 61      ld   bc,holds_barrow_61C7
3B0A: D9            exx
3B0B: FD 21 C4 61   ld   iy,barrow_start_screen_address_61C4
3B0F: 3E 3A         ld   a,$3A
3B11: FD 77 04      ld   (iy+$04),a
3B14: 3E 28         ld   a,$28
3B16: FD 77 05      ld   (iy+$05),a
3B19: 3E EC         ld   a,$EC
3B1B: 32 CA 61      ld   (unknown_61CA),a
3B1E: FD 56 01      ld   d,(iy+$01)
3B21: FD 5E 00      ld   e,(iy+$00)
3B24: CD 76 21      call $2176
3B27: 21 1B 3F      ld   hl,$3F1B
3B2A: CD 18 20      call copy_to_61bd_2018
; add one life for level completed
3B2D: 3A 56 60      ld   a,(lives_6056)
3B30: 3C            inc  a
3B31: 32 56 60      ld   (lives_6056),a
3B34: 3A 26 60      ld   a,(player_input_6026)
3B37: F6 10         or   $10
3B39: 32 26 60      ld   (player_input_6026),a
3B3C: AF            xor  a
3B3D: 32 96 65      ld   (guard_1_x_6596),a
3B40: 32 9A 65      ld   (guard_2_x_659A),a
3B43: 3E 01         ld   a,$01
3B45: 32 00 A0      ld   (interrupt_control_A000),a
3B48: 32 F2 61      ld   (unknown_61F2),a
3B4B: FB            ei
3B4C: CD 53 16      call $1653
3B4F: 3A 82 65      ld   a,(player_x_6582)
3B52: FE F0         cp   $F0
3B54: 20 DE         jr   nz,$3B34
3B56: AF            xor  a
3B57: 32 F2 61      ld   (unknown_61F2),a
3B5A: 32 C7 61      ld   (holds_barrow_61C7),a
3B5D: F3            di
3B5E: 06 40         ld   b,$40
3B60: 21 80 65      ld   hl,player_struct_6580
3B63: 3E 00         ld   a,$00
3B65: 77            ld   (hl),a
3B66: 23            inc  hl
3B67: 10 FC         djnz $3B65
3B69: 21 00 52      ld   hl,$5200
3B6C: 22 40 61      ld   (unknown_pointer_6140),hl
3B6F: AF            xor  a
3B70: 32 42 61      ld   (unknown_6142),a
3B73: 3E 01         ld   a,$01
3B75: 32 74 62      ld   (is_intermission_6274),a
3B78: CD 00 37      call play_intro_3700
3B7B: AF            xor  a
3B7C: 32 74 62      ld   (is_intermission_6274),a
3B7F: 3C            inc  a
3B80: 32 54 60      ld   (gameplay_allowed_6054),a
3B83: CD 4F 35      call set_bags_coordinates_hard_level_354f
3B86: 31 F0 67      ld   sp,stack_top_67F0
3B89: C3 2B 12      jp   $122B

; < return c=0 if still bags, c=1 otherwise (level completed)
check_remaining_bags_3BBC:
3B8C: 0E 00         ld   c,$00
3B8E: FD 21 9C 60   ld   iy,bags_coordinates_609C
3B92: 06 36         ld   b,$36
3B94: FD 7E 00      ld   a,(iy+$00)
3B97: FE 00         cp   $00
3B99: C0            ret  nz
3B9A: FD 23         inc  iy
3B9C: 10 F6         djnz $3B94
3B9E: C3 60 5E      jp   $5E60

3BA1: 21 F4 61      ld   hl,unknown_61F4
3BA4: 7E            ld   a,(hl)
3BA5: 47            ld   b,a
3BA6: 3A E8 61      ld   a,(time_61E8)
3BA9: B8            cp   b
3BAA: C8            ret  z
3BAB: FE 05         cp   $05
3BAD: D0            ret  nc
3BAE: 21 94 5B      ld   hl,$5B94
3BB1: 22 40 61      ld   (unknown_pointer_6140),hl
3BB4: 32 F4 61      ld   (unknown_61F4),a
3BB7: AF            xor  a
3BB8: 32 42 61      ld   (unknown_6142),a
3BBB: C9            ret
3BBC: 3A 0D 60      ld   a,(player_screen_600D)
3BBF: 32 98 60      ld   (screen_index_param_6098),a
3BC2: FD 21 61 61   ld   iy,unknown_6161
3BC6: DD 21 84 65   ld   ix,unknown_6584
3BCA: CD 8C 55      call compute_logical_address_from_xy_558c
3BCD: 3A 0D 60      ld   a,(player_screen_600D)
3BD0: FE 01         cp   $01
3BD2: C8            ret  z
3BD3: DD 7E 03      ld   a,(ix+$03)
3BD6: FE 11         cp   $11
3BD8: D8            ret  c
3BD9: 3A 0D 60      ld   a,(player_screen_600D)
3BDC: FE 02         cp   $02
3BDE: 20 0D         jr   nz,$3BED
3BE0: 11 DE 4B      ld   de,$4BDE
3BE3: AF            xor  a
3BE4: ED 5A         adc  hl,de
3BE6: 11 62 91      ld   de,$9162
3BE9: 06 0F         ld   b,$0F
3BEB: 18 0B         jr   $3BF8
3BED: 11 DE 47      ld   de,$47DE
3BF0: AF            xor  a
3BF1: ED 5A         adc  hl,de
3BF3: 11 02 93      ld   de,$9302
3BF6: 06 17         ld   b,$17
3BF8: 3E FB         ld   a,$FB
3BFA: E5            push hl
3BFB: AF            xor  a
3BFC: ED 52         sbc  hl,de
3BFE: E1            pop  hl
3BFF: 28 09         jr   z,$3C0A
3C01: 3E FB         ld   a,$FB
3C03: CD 2C 3C      call $3C2C
3C06: 13            inc  de
3C07: 10 EF         djnz $3BF8
3C09: C9            ret
3C0A: DD 7E 03      ld   a,(ix+$03)
3C0D: E6 07         and  $07
3C0F: 47            ld   b,a
3C10: 3E F3         ld   a,$F3
3C12: 80            add  a,b
3C13: CD 2C 3C      call $3C2C
3C16: 06 03         ld   b,$03
3C18: 13            inc  de
3C19: C5            push bc
3C1A: 1A            ld   a,(de)
3C1B: 01 08 00      ld   bc,$0008
3C1E: 21 3F 3C      ld   hl,$3C3F
3C21: ED B1         cpir
3C23: 3E F3         ld   a,$F3
3C25: CC 2C 3C      call z,$3C2C
3C28: C1            pop  bc
3C29: 10 ED         djnz $3C18
3C2B: C9            ret
3C2C: 12            ld   (de),a
3C2D: C5            push bc
3C2E: 47            ld   b,a
3C2F: 1A            ld   a,(de)
3C30: B8            cp   b
3C31: 78            ld   a,b
3C32: C1            pop  bc
3C33: 20 F7         jr   nz,$3C2C
3C35: D5            push de
3C36: 7A            ld   a,d
3C37: C6 08         add  a,$08
3C39: 57            ld   d,a
3C3A: 3E 20         ld   a,$20
3C3C: 12            ld   (de),a
3C3D: D1            pop  de
3C3E: C9            ret
3C3F: FB            ei
3C40: FA F9 F8      jp   m,$F8F9
3C43: F7            rst  $30
3C44: F6 F5         or   $F5

3C47: 2A 91 60		ld   hl,(guard_logical_address_6091)
3C4A: 22 FF 61      ld   (unknown_61FF),hl
3C4D: 2A 93 60      ld   hl,(guard_struct_pointer_6093)
3C50: 22 01 62      ld   (unknown_pointer_6201),hl
3C53: 2A 95 60      ld   hl,(guard_direction_pointer_6095)
3C56: 22 03 62      ld   (unknown_pointer_6203),hl
3C59: 3A 0B 60      ld   a,(way_clear_flag_600B)
3C5C: 32 05 62      ld   (unknown_6205),a
3C5F: 3A 98 60      ld   a,(screen_index_param_6098)
3C62: 32 F9 61      ld   (unknown_61F9),a
3C65: C9            ret

3C66: 2A FF 61      ld   hl,(unknown_61FF)
3C69: 22 91 60      ld   (guard_logical_address_6091),hl
3C6C: 2A 01 62      ld   hl,(unknown_pointer_6201)
3C6F: 22 93 60      ld   (guard_struct_pointer_6093),hl
3C72: 2A 03 62      ld   hl,(unknown_pointer_6203)
3C75: 22 95 60      ld   (guard_direction_pointer_6095),hl
3C78: 3A 05 62      ld   a,(unknown_6205)
3C7B: 32 0B 60      ld   (way_clear_flag_600B),a
3C7E: 3A F9 61      ld   a,(unknown_61F9)
3C81: 32 98 60      ld   (screen_index_param_6098),a
3C84: C9            ret

3C85: F5            push af
3C86: D5            push de
3C87: E5            push hl
3C88: 06 00         ld   b,$00
3C8A: CD AA 3C      call $3CAA
3C8D: 20 17         jr   nz,$3CA6
3C8F: 23            inc  hl
3C90: CD AA 3C      call $3CAA
3C93: 20 11         jr   nz,$3CA6
3C95: 11 1F 00      ld   de,$001F
3C98: 19            add  hl,de
3C99: CD AA 3C      call $3CAA
3C9C: 20 08         jr   nz,$3CA6
3C9E: 23            inc  hl
3C9F: CD AA 3C      call $3CAA
3CA2: 20 02         jr   nz,$3CA6
3CA4: 06 01         ld   b,$01
3CA6: E1            pop  hl
3CA7: D1            pop  de
3CA8: F1            pop  af
3CA9: C9            ret

3CAA: 7E            ld   a,(hl)
3CAB: FE E0         cp   $E0
3CAD: C8            ret  z
3CAE: FE 49         cp   $49
3CB0: C8            ret  z
3CB1: FE 4A         cp   $4A
3CB3: C8            ret  z
3CB4: FE 4B         cp   $4B
3CB6: C9            ret
3CB7: AF            xor  a
3CB8: FD 77 00      ld   (iy+$00),a
3CBB: FD 77 01      ld   (iy+$01),a
3CBE: E1            pop  hl
3CBF: C9            ret
3CC0: DD 21 CC 61   ld   ix,unknown_61CC
3CC4: AF            xor  a
3CC5: DD 77 00      ld   (ix+$00),a
3CC8: DD 77 01      ld   (ix+$01),a
3CCB: DD 77 03      ld   (ix+$03),a
3CCE: 3E FF         ld   a,$FF
3CD0: 32 9F 65      ld   (unknown_659F),a
3CD3: C9            ret
3CD4: CD 75 55      call update_guard_2_screen_address_from_xy_5575
3CD7: CD 7A 3D      call $3D7A
3CDA: 28 12         jr   z,$3CEE
3CDC: AF            xor  a
3CDD: 32 77 60      ld   (unknown_6077),a
3CE0: 3A 09 62      ld   a,(unknown_6209)
3CE3: FE 01         cp   $01
3CE5: 20 07         jr   nz,$3CEE
3CE7: CD 7C 22      call $227C
3CEA: AF            xor  a
3CEB: 32 09 62      ld   (unknown_6209),a
3CEE: DD 21 8F 60   ld   ix,unknown_608F
3CF2: FD 21 57 61   ld   iy,unknown_6157
3CF6: 21 98 65      ld   hl,guard_2_struct_6598
3CF9: 22 15 62      ld   (guard_struct_pointer_6215),hl
3CFC: 2A 78 60      ld   hl,(guard_2_screen_address_6078)
3CFF: 11 7B 60      ld   de,guard_2_in_elevator_607B
3D02: 3A 9A 60      ld   a,(guard_2_screen_609A)
3D05: 32 98 60      ld   (screen_index_param_6098),a
3D08: 01 12 62      ld   bc,unknown_6212
3D0B: CD 49 3D      call $3D49
3D0E: CD 68 55      call update_guard_1_screen_address_from_xy_5568
3D11: CD 7A 3D      call $3D7A
3D14: 28 12         jr   z,$3D28
3D16: AF            xor  a
3D17: 32 37 60      ld   (unknown_6037),a
3D1A: 3A 08 62      ld   a,(unknown_6208)
3D1D: FE 01         cp   $01
3D1F: 20 07         jr   nz,$3D28
3D21: CD 41 22      call $2241
3D24: AF            xor  a
3D25: 32 08 62      ld   (unknown_6208),a
3D28: DD 21 4F 60   ld   ix,unknown_604F
3D2C: FD 21 56 61   ld   iy,unknown_6156
3D30: 21 94 65      ld   hl,guard_1_struct_6594
3D33: 22 15 62      ld   (guard_struct_pointer_6215),hl
3D36: 2A 38 60      ld   hl,(guard_1_logical_address_6038)
3D39: 11 3B 60      ld   de,guard_1_in_elevator_603B
3D3C: 3A 99 60      ld   a,(guard_1_screen_6099)
3D3F: 32 98 60      ld   (screen_index_param_6098),a
3D42: 01 11 62      ld   bc,unknown_6211
3D45: CD 49 3D      call $3D49
3D48: C9            ret

3D49: DD 7E 00      ld   a,(ix+$00)
3D4C: FE 12         cp   $12
3D4E: 38 0E         jr   c,$3D5E
3D50: CD 7A 3D      call $3D7A
3D53: 20 63         jr   nz,$3DB8
3D55: 1A            ld   a,(de)
3D56: FE 01         cp   $01
3D58: 28 5E         jr   z,$3DB8
3D5A: 3E 01         ld   a,$01
3D5C: 02            ld   (bc),a
3D5D: C9            ret
3D5E: 0A            ld   a,(bc)
3D5F: FE 01         cp   $01
3D61: 28 5B         jr   z,$3DBE
3D63: AF            xor  a
3D64: C9            ret
3D65: 7E            ld   a,(hl)
3D66: E5            push hl
3D67: C5            push bc
3D68: 01 02 00      ld   bc,$0002
3D6B: 21 78 3D      ld   hl,$3D78
3D6E: ED B1         cpir
3D70: C1            pop  bc
3D71: E1            pop  hl
3D72: C8            ret  z
3D73: AF            xor  a
3D74: 32 08 60      ld   (unknown_6008),a
3D77: C9            ret

3D7A: 7E            ld   a,(hl)
3D7B: E5            push hl
3D7C: C5            push bc
3D7D: 01 30 00      ld   bc,$0030
3D80: 21 88 3D      ld   hl,$3D88
3D83: ED B1         cpir
3D85: C1            pop  bc
3D86: E1            pop  hl
3D87: C9            ret


3DB8: 2A 15 62      ld   hl,(guard_struct_pointer_6215)
3DBB: 3E 22         ld   a,$22
3DBD: 77            ld   (hl),a
* sometimes called with BC=0, will do nothing useful!
3DBE: AF            xor  a
3DBF: 02            ld   (bc),a
3DC0: 3E 01         ld   a,$01
3DC2: FD 77 00      ld   (iy+$00),a
3DC5: EB            ex   de,hl
3DC6: 11 04 00      ld   de,$0004
3DC9: AF            xor  a
3DCA: ED 52         sbc  hl,de
3DCC: 77            ld   (hl),a
3DCD: 21 37 04      ld   hl,$0437
3DD0: 22 54 61      ld   (unknown_6154),hl
3DD3: AF            xor  a
3DD4: 32 F5 61      ld   (unknown_61F5),a
3DD7: 3A 98 60      ld   a,(screen_index_param_6098)
3DDA: 47            ld   b,a
3DDB: 3A 0D 60      ld   a,(player_screen_600D)
3DDE: B8            cp   b
3DDF: C0            ret  nz
3DE0: 21 4B 3F      ld   hl,$3F4B
3DE3: CD 18 20      call copy_to_61bd_2018
3DE6: AF            xor  a
3DE7: 32 53 61      ld   (unknown_6153),a
3DEA: C9            ret
	;; test if can pick bag
can_pick_bag_3DEB:
3DEB: DD E5         push ix
3DED: DD 2A 40 61   ld   ix,(unknown_pointer_6140)
3DF1: DD 7E 03      ld   a,(ix+$03)
3DF4: DD E1         pop  ix
3DF6: FE FF         cp   $FF
3DF8: C9            ret

3DF9: 3A 00 B8      ld   a,(io_read_shit_B800)
3DFC: DD 21 80 65   ld   ix,player_struct_6580
3E00: FD 21 A8 65   ld   iy,unknown_65A8
3E04: CD 01 10      call copy_4_bytes_ix_iy_1001
3E07: DD 21 84 65   ld   ix,unknown_6584
3E0B: FD 21 A4 65   ld   iy,unknown_65A4
3E0F: CD 01 10      call copy_4_bytes_ix_iy_1001
3E12: DD 21 88 65   ld   ix,unknown_6588
3E16: FD 21 AC 65   ld   iy,unknown_65AC
3E1A: CD 01 10      call copy_4_bytes_ix_iy_1001
3E1D: DD 21 8C 65   ld   ix,unknown_658C
3E21: FD 21 B0 65   ld   iy,unknown_65B0
3E25: CD 01 10      call copy_4_bytes_ix_iy_1001
3E28: DD 21 90 65   ld   ix,unknown_6590
3E2C: FD 21 B4 65   ld   iy,unknown_65B4
3E30: CD 01 10      call copy_4_bytes_ix_iy_1001
3E33: DD 21 9C 65   ld   ix,unknown_659C
3E37: FD 21 A0 65   ld   iy,sprite_shadow_ram_65A0
3E3B: CD 01 10      call copy_4_bytes_ix_iy_1001
3E3E: AF            xor  a
3E3F: 32 5F 98      ld   ($985F),a
3E42: 3A 00 B0      ld   a,(dip_switch_B000)
3E45: 2F            cpl
3E46: E6 80         and  $80
3E48: CB 07         rlc  a
3E4A: 06 01         ld   b,$01
3E4C: FE 00         cp   $00
3E4E: 28 07         jr   z,$3E57
3E50: 47            ld   b,a
3E51: 3A 7C 61      ld   a,(current_player_617C)
3E54: 2F            cpl
3E55: A0            and  b
3E56: 47            ld   b,a
3E57: 48            ld   c,b
3E58: 06 08         ld   b,$08
3E5A: 11 04 00      ld   de,$0004
3E5D: 21 A3 65      ld   hl,unknown_65A3
3E60: 7E            ld   a,(hl)
3E61: FE 00         cp   $00
3E63: 28 02         jr   z,$3E67
3E65: 81            add  a,c
3E66: 77            ld   (hl),a
3E67: 19            add  hl,de
3E68: 10 F6         djnz $3E60
3E6A: 21 AF 65      ld   hl,unknown_65AF
3E6D: 06 03         ld   b,$03
3E6F: 35            dec  (hl)
3E70: 19            add  hl,de
3E71: 10 FC         djnz $3E6F
3E73: 79            ld   a,c
3E74: FE 00         cp   $00
3E76: 20 16         jr   nz,$3E8E
3E78: 3A 0D 60      ld   a,(player_screen_600D)
3E7B: FE 01         cp   $01
3E7D: 28 0F         jr   z,$3E8E
3E7F: 3A ED 61      ld   a,(check_scenery_disabled_61ED)
3E82: FE 01         cp   $01
3E84: 28 08         jr   z,$3E8E
3E86: 3A A6 65      ld   a,(unknown_65A6)
3E89: 3C            inc  a
3E8A: 3C            inc  a
3E8B: 32 A6 65      ld   (unknown_65A6),a
3E8E: C9            ret


	;; internal actual add to score routine
	;; score is stored from 6176 to 6178 for player 1
	;; 6179 to 617B for player 2
5500: 3A ED 61      ld   a,(check_scenery_disabled_61ED)
5503: FE 01         cp   $01
5505: C8            ret  z
5506: 3A 7C 61      ld   a,(current_player_617C)
5509: FE 00         cp   $00
550B: C2 31 55      jp   nz,$5531
550E: DD 21 76 61   ld   ix,player_1_score_6176
5512: AF            xor  a
5513: 7D            ld   a,l
5514: 47            ld   b,a
5515: DD 7E 00      ld   a,(ix+$00)
5518: 80            add  a,b
5519: 27            daa
551A: DD 77 00      ld   (ix+$00),a
551D: 7C            ld   a,h
551E: 47            ld   b,a
551F: DD 7E 01      ld   a,(ix+$01)
5522: 88            adc  a,b
5523: 27            daa
5524: DD 77 01      ld   (ix+$01),a
5527: DD 7E 02      ld   a,(ix+$02)
552A: CE 00         adc  a,$00
552C: 27            daa
552D: DD 77 02      ld   (ix+$02),a
5530: C9            ret



5531: DD 21 79 61   ld   ix,player_2_score_6179
5535: 18 DB         jr   $5512

;; < in:	 ix:	 player "structure"
;; <             iy:	 guard "structure"
guard_collision_5537:
5537: FD 7E 02      ld   a,(iy+$02) ;  guard x
553A: 47            ld   b,a
553B: DD 7E 02      ld   a,(ix+$02) ;  player x
553E: CD 4E 55      call within_bounds_554E
5541: FD 7E 03      ld   a,(iy+$03)  ; guard y
5544: 47            ld   b,a
5545: DD 7E 03      ld   a,(ix+$03) ;  player y
5548: CD 4E 55      call within_bounds_554E
554B: 3E 01         ld   a,$01	; set flag to 1: collision with guard
554D: C9            ret

;; check if a+11 > b and a-8 < b (kind of square collision if applied to both x and y)
;; in:	 a,b: values to compare
;; out:	 if both conditions are OK, returns, else pops the stack and exits from 5537
within_bounds_554E:
554E: 4F            ld   c,a
554F: C6 0B         add  a,$0B
5551: B8            cp   b
5552: 38 07         jr   c,$555B
5554: 79            ld   a,c
5555: D6 08         sub  $08
5557: B8            cp   b
5558: 30 01         jr   nc,$555B
555A: C9            ret
;;; okay:	return from guard_collision_5537 directly (pop)
555B: F1            pop  af
555C: AF            xor  a
555D: C9            ret

;;; the screen addresses are global for all 3 screens
;;; those are the addresses the game uses for collisions with walls and ladders
;;; the display address is probably different and somewhere else but related
;;; (clipping those routines cause havoc to character display)

update_player_screen_address_from_xy_555E:
555E: DD 21 80 65   ld   ix,player_struct_6580
5562: FD 21 09 60   ld   iy,player_logical_address_6009
5566: 18 1A         jr   compute_player_logical_address_from_xy_5582

update_guard_1_screen_address_from_xy_5568:
5568: DD 21 94 65   ld   ix,guard_1_struct_6594
556C: FD 21 38 60   ld   iy,guard_1_logical_address_6038
5570: 3A 99 60      ld   a,(guard_1_screen_6099)
5573: 18 10         jr   $5585

update_guard_2_screen_address_from_xy_5575:
5575: DD 21 98 65   ld   ix,guard_2_struct_6598
5579: FD 21 78 60   ld   iy,guard_2_screen_address_6078
557D: 3A 9A 60      ld   a,(guard_2_screen_609A)
5580: 18 03         jr   $5585

compute_player_logical_address_from_xy_5582:
5582: 3A 0D 60      ld   a,(player_screen_600D)
5585: 32 98 60      ld   (screen_index_param_6098),a
5588: CD 8C 55      call compute_logical_address_from_xy_558c
558B: C9            ret

;; compute logical address from x,y:	rounded by 8
; < ix: character structure
; < iy: where to update
compute_logical_address_from_xy_558c:
558C: CD AC 55      call $55AC
558F: CD 9A 55      call $559A
5592: FD 75 00      ld   (iy+$00),l
5595: FD 74 01      ld   (iy+$01),h
5598: C9            ret
5599: C9            ret

559A: DD 7E 03      ld   a,(ix+$03) ;  character y value
559D: C6 10         add  a,$10
559F: CB 3F         srl  a
55A1: CB 3F         srl  a
55A3: CB 3F         srl  a
55A5: 85            add  a,l
55A6: 6F            ld   l,a
55A7: 7C            ld   a,h
55A8: CE 00         adc  a,$00
55AA: 67            ld   h,a
55AB: C9            ret

55AC: DD 7E 02      ld   a,(ix+$02) ;  character x value
55AF: C6 07         add  a,$07
55B1: 2F            cpl
55B2: CB 3F         srl  a
55B4: C3 CD 5B      jp   $5BCD
* seems unreached
55B7: 00            nop
	;; multiply $20 * a and add it to $4000
get_screen_base_logical_address_55b8:
55B8: 47            ld   b,a
55B9: 11 20 00      ld   de,$0020
55BC: 21 00 40      ld   hl,$4000
55BF: 19            add  hl,de
55C0: 10 FD         djnz $55BF

add_current_screen_logical_address_offset_55c2:
55C2: 3A 98 60      ld   a,(screen_index_param_6098)
55C5: FE 01         cp   $01
55C7: C8            ret  z
55C8: FE 02         cp   $02
55CA: 20 05         jr   nz,$55D1
55CC: 7C            ld   a,h
55CD: C6 04         add  a,$04	;  screen 2:	add $400
55CF: 67            ld   h,a
55D0: C9            ret
55D1: FE 03         cp   $03	;  screen 3:	 add $800
55D3: C0            ret  nz
55D4: 7C            ld   a,h
55D5: C6 08         add  a,$08
55D7: 67            ld   h,a
55D8: C9            ret

; display ASCII text on line until code 0x3F is reached
; < de: pointer on text
; < hl: start address of screen

display_text_55d9:
55D9: 01 E0 FF      ld   bc,$FFE0
55DC: 1A            ld   a,(de)
55DD: FE 3F         cp   $3F
55DF: C8            ret  z		; end of string
55E0: D6 30         sub  $30
55E2: 77            ld   (hl),a
55E3: E5            push hl
55E4: 7C            ld   a,h
55E5: C6 08         add  a,$08
55E7: 67            ld   h,a
55E8: 3E 00         ld   a,$00
55EA: 77            ld   (hl),a
55EB: E1            pop  hl
55EC: 13            inc  de
55ED: 09            add  hl,bc
55EE: 18 E9         jr   display_text_55d9
write_text_55f0:
55F0: 01 E0 FF      ld   bc,$FFE0
55F3: 1A            ld   a,(de)
55F4: FE 3F         cp   $3F
55F6: C8            ret  z
55F7: 77            ld   (hl),a
55F8: E5            push hl
55F9: 7C            ld   a,h
55FA: C6 08         add  a,$08
55FC: 67            ld   h,a
55FD: 08            ex   af,af'
55FE: 77            ld   (hl),a
55FF: 08            ex   af,af'
5600: E1            pop  hl
5601: 13            inc  de
5602: 09            add  hl,bc
5603: 18 EB         jr   write_text_55f0

write_attribute_on_line_5605:
5605: 11 20 00      ld   de,$0020
5608: 06 1C         ld   b,$1C
560A: 77            ld   (hl),a
560B: 19            add  hl,de
560C: 10 FC         djnz $560A
560E: C9            ret

write_scores_and_time_560f:
560F: DD 21 76 61   ld   ix,player_1_score_6176
5613: 21 E1 92      ld   hl,$92E1
5616: CD 3C 56      call write_numeric_value_563C
5619: DD 21 79 61   ld   ix,player_2_score_6179
561D: 21 61 90      ld   hl,$9061
5620: CD 3C 56      call write_numeric_value_563C
5623: DD 21 E8 61   ld   ix,time_61E8
5627: 21 01 92      ld   hl,$9201
562A: 06 01         ld   b,$01
562C: CD 41 56      call $5641
562F: DD 21 E9 61   ld   ix,unknown_61E9
5633: 21 C1 91      ld   hl,$91C1
5636: 06 01         ld   b,$01
5638: CD 41 56      call $5641
563B: C9            ret

write_numeric_value_563C:
563C: 06 03         ld   b,$03
563E: 11 20 00      ld   de,$0020
5641: DD 7E 00      ld   a,(ix+$00)
5644: CD 4D 56      call write_byte_value_563C
5647: DD 23         inc  ix
5649: 19            add  hl,de
564A: 10 F5         djnz $5641
564C: C9            ret

write_byte_value_563C:
564D: F5            push af
564E: E6 0F         and  $0F
5650: 77            ld   (hl),a
5651: 19            add  hl,de
5652: F1            pop  af
5653: CB 0F         rrc  a
5655: CB 0F         rrc  a
5657: CB 0F         rrc  a
5659: CB 0F         rrc  a
565B: E6 0F         and  $0F
565D: 77            ld   (hl),a
565E: C9            ret

565F: ED 52         sbc  hl,de
5661: 06 11         ld   b,$11
5663: CD 6A 56      call $566A
5666: CD 75 56      call $5675
5669: C9            ret

5BCD: CB 3F  		srl  a                                              
5BCF: CB 3F  		srl  a                                              
5BD1: FE 00  		cp   $00                                            
5BD3: CA C2 55  	jp   z,add_current_screen_logical_address_offset_55c2                                        
5BD6: C3 B8 55  	jp   get_screen_base_logical_address_55b8                                          
                                              

	;; in:	 hl contains 16 bit hex value of the points to add
	;; $100 for 100 points, $500 for 500 etc...
add_to_score_5C90:
5C90: 3A 54 60      ld   a,(gameplay_allowed_6054)
5C93: FE 00         cp   $00
5C95: C8            ret  z
5C96: CD 00 55      call $5500
5C99: C9            ret

5C9A: C3 46 5E      jp   $5E46
5C9D: FE 01         cp   $01
5C9F: C8            ret  z
5CA0: DD 21 44 5D   ld   ix,$5D44
5CA4: FD 21 80 65   ld   iy,player_struct_6580
5CA8: 11 04 00      ld   de,$0004
5CAB: 3A 88 62      ld   a,(unknown_6288)
5CAE: FE 00         cp   $00
5CB0: CC 2A 5D      call z,$5D2A
5CB3: 3A 88 62      ld   a,(unknown_6288)
5CB6: FE 00         cp   $00
5CB8: 28 05         jr   z,$5CBF
5CBA: DD 19         add  ix,de
5CBC: 3D            dec  a
5CBD: 18 F7         jr   $5CB6
5CBF: DD 7E 03      ld   a,(ix+$03)
5CC2: FE FF         cp   $FF
5CC4: 28 3C         jr   z,$5D02
5CC6: FE FE         cp   $FE
5CC8: CA 1C 5D      jp   z,$5D1C
5CCB: 47            ld   b,a
5CCC: 3A 26 60      ld   a,(player_input_6026)
5CCF: E6 07         and  $07
5CD1: B0            or   b
5CD2: 32 26 60      ld   (player_input_6026),a
5CD5: FD 7E 02      ld   a,(iy+$02)
5CD8: DD BE 00      cp   (ix+$00)
5CDB: C0            ret  nz
5CDC: FD 7E 03      ld   a,(iy+$03)
5CDF: DD BE 01      cp   (ix+$01)
5CE2: C0            ret  nz
5CE3: 3A 0D 60      ld   a,(player_screen_600D)
5CE6: DD BE 02      cp   (ix+$02)
5CE9: C0            ret  nz
5CEA: 3A 88 62      ld   a,(unknown_6288)
5CED: 3C            inc  a
5CEE: 32 88 62      ld   (unknown_6288),a
5CF1: 3A 26 60      ld   a,(player_input_6026)
5CF4: E6 80         and  $80
5CF6: FE 80         cp   $80
5CF8: C8            ret  z
5CF9: 3A 26 60      ld   a,(player_input_6026)
5CFC: E6 07         and  $07
5CFE: 32 26 60      ld   (player_input_6026),a
5D01: C9            ret

5D02: 3E 10         ld   a,$10
5D04: 32 97 65      ld   (guard_1_y_6597),a
5D07: 32 9B 65      ld   (guard_2_y_659B),a
5D0A: 3E D0         ld   a,$D0
5D0C: 32 96 65      ld   (guard_1_x_6596),a
5D0F: 3E E0         ld   a,$E0
5D11: C3 38 5E      jp   $5E38
5D14: 3A 87 65      ld   a,(elevator_y_current_screen_6587)
5D17: FE 11         cp   $11	;  max height for elevator
5D19: C0            ret  nz
5D1A: 18 CE         jr   $5CEA
5D1C: 3A 8A 65      ld   a,(wagon_data_658A)
5D1F: FE 7F         cp   $7F
5D21: C0            ret  nz
5D22: 3A 19 60      ld   a,(unknown_6019)
5D25: FE 01         cp   $01
5D27: C0            ret  nz
5D28: 18 C0         jr   $5CEA
5D2A: 21 C2 91      ld   hl,$91C2
5D2D: 22 C4 61      ld   (barrow_start_screen_address_61C4),hl
5D30: 22 FA 61      ld   (unknown_screen_address_61FA),hl
5D33: 3E 01         ld   a,$01
5D35: 32 C6 61      ld   (unknown_61C6),a
5D38: 32 FC 61      ld   (unknown_61FC),a
5D3B: 3E 03         ld   a,$03
5D3D: 32 99 60      ld   (guard_1_screen_6099),a
5D40: 32 9A 60      ld   (guard_2_screen_609A),a
5D43: C9            ret


5E38: 32 9A 65      ld   (guard_2_x_659A),a
	;; make guards start at 3rd screen
5E3B: 3E 03         ld   a,$03
5E3D: 32 99 60      ld   (guard_1_screen_6099),a
5E40: 32 9A 60      ld   (guard_2_screen_609A),a
5E43: C3 14 5D      jp   $5D14
5E46: 3A 54 60      ld   a,(gameplay_allowed_6054)
5E49: FE 01         cp   $01
5E4B: C8            ret  z
5E4C: 3A 26 60      ld   a,(player_input_6026)
5E4F: E6 07         and  $07
5E51: 32 26 60      ld   (player_input_6026),a
5E54: C3 A0 5C      jp   $5CA0


5E60: 3E 0A         ld   a,$0A
5E62: 32 7D 62      ld   (unknown_627D),a
5E65: 0E 01         ld   c,$01
5E67: C9            ret

5E68: FF            rst  $38
5E69: 32 ED 61      ld   (check_scenery_disabled_61ED),a
5E6C: 3E 0A         ld   a,$0A
5E6E: 32 7D 62      ld   (unknown_627D),a
5E71: C3 C9 38      jp   $38C9
direction_table_5970:
	dc.b	$80,$40,$20,$10

