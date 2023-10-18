0000: C3 A8 EC    jp   $ECA8

;; interrupt handler
0038: F3		  di                                                  
0039: F5          push af
003A: C5          push bc
003B: D5          push de
003C: E5          push hl
003D: DD E5       push ix
003F: FD E5       push iy
0041: D9          exx
0042: C5          push bc
0043: D5          push de
0044: E5          push hl
0045: 08          ex   af,af'
0046: F5          push af
0047: CD 2E D3    call $D32E
004A: AF          xor  a
004B: 32 00 A0    ld   (interrupt_control_A000),a
004E: CD 91 CA    call $CA91
0051: CD 65 15    call $1565
0054: 3A 8C 62    ld   a,(unknown_628C)
0057: FE 01       cp   $01
0059: CC 89 16    call z,$1689
005C: 3A 42 61    ld   a,(ay_sound_start_6142)
005F: 3C          inc  a
0060: 32 42 61    ld   (ay_sound_start_6142),a
0063: 3A 32 63    ld   a,(unknown_6332)
0066: FE 01       cp   $01
0068: CC 9E 11    call z,$119E
006B: 3A 32 63    ld   a,(unknown_6332)
006E: FE 01       cp   $01
0070: CA 12 05    jp   z,$0512
0073: 3A 74 62    ld   a,(is_intermission_6274)
0076: FE 01       cp   $01
0078: 28 05       jr   z,$007F
007A: 3A ED 61    ld   a,(check_scenery_disabled_61ED)
007D: FE 00       cp   $00
007F: CC E8 0F    call z,$0FE8
0082: 3A 6F 62    ld   a,(unknown_626F)
0085: FE 01       cp   $01
0087: CA 15 05    jp   z,$0515
008A: 3A 10 62    ld   a,(must_play_music_6210)
008D: FE 01       cp   $01
008F: 20 22       jr   nz,$00B3
0091: 3A 54 60    ld   a,(gameplay_allowed_6054)
0094: FE 00       cp   $00
0096: 28 1B       jr   z,$00B3
0098: 3A F2 61    ld   a,(player_controls_blocked_61F2)
009B: FE 01       cp   $01
009D: 28 14       jr   z,$00B3
009F: 3A ED 61    ld   a,(check_scenery_disabled_61ED)
00A2: FE 01       cp   $01
00A4: 28 0D       jr   z,$00B3
00A6: 3A 82 65    ld   a,(player_x_6582)
00A9: FE E9       cp   $E9
00AB: D2 15 05    jp   nc,$0515
00AE: FE 0F       cp   $0F
00B0: DA 15 05    jp   c,$0515
00B3: 3A 00 B8    ld   a,($B800)
00B6: 21 A0 65    ld   hl,barrow_sprite_shadow_ram_65A0
00B9: 11 00 98    ld   de,$9800
00BC: 01 20 00    ld   bc,$0020
00BF: ED B0       ldir
00C1: CD 09 CF    call $CF09
00C4: 3A C1 62    ld   a,(unknown_62C1)
00C7: FE 00       cp   $00
00C9: 28 04       jr   z,$00CF
00CB: 3D          dec  a
00CC: 32 C1 62    ld   (unknown_62C1),a
00CF: CD A7 CF    call $CFA7
00D2: 3A 51 63    ld   a,(unknown_6351)
00D5: FE 01       cp   $01
00D7: CC E7 DB    call z,$DBE7
00DA: 3A 43 61    ld   a,(unknown_6143)
00DD: 3C          inc  a
00DE: 32 43 61    ld   (unknown_6143),a
00E1: CD 92 11    call speech_management_1192
00E4: 3A 6D 62    ld   a,(flash_counter_626D)
00E7: 3C          inc  a
00E8: 32 6D 62    ld   (flash_counter_626D),a
00EB: FD 21 B8 65 ld   iy,previous_guard_1_struct_65B8
00EF: 3A 0D 60    ld   a,(player_screen_600D)
00F2: 47          ld   b,a
00F3: 3A 99 60    ld   a,(guard_1_screen_6099)
00F6: B8          cp   b
00F7: 28 05       jr   z,$00FE
00F9: CD 8C 11    call set_previous_guard_y_255_118C
00FC: 18 0B       jr   $0109
00FE: DD 21 94 65 ld   ix,guard_1_struct_6594
0102: FD 21 B8 65 ld   iy,previous_guard_1_struct_65B8
0106: CD D7 D6    call $D6D7
0109: FD 21 BC 65 ld   iy,previous_guard_2_struct_65BC
010D: 3A 0D 60    ld   a,(player_screen_600D)
0110: 47          ld   b,a
0111: 3A 9A 60    ld   a,(guard_2_screen_609A)
0114: B8          cp   b
0115: 28 05       jr   z,$011C
0117: CD 8C 11    call set_previous_guard_y_255_118C
011A: 18 0B       jr   $0127
011C: DD 21 98 65 ld   ix,guard_2_struct_6598
0120: FD 21 BC 65 ld   iy,previous_guard_2_struct_65BC
0124: CD D7 D6    call $D6D7
0127: 3A 43 63    ld   a,(unknown_6343)
012A: FE 01       cp   $01
012C: 28 0B       jr   z,$0139
012E: 3A 53 60    ld   a,(game_locked_6053)
0131: FE 01       cp   $01
0133: CA EA 04    jp   z,$04EA
0136: CD 80 05    call $0580
0139: 3A 51 61    ld   a,(game_locked_6151)
013C: FE 01       cp   $01
013E: CA EA 04    jp   z,$04EA
0141: CD 31 17    call $1731
0144: 3A 00 B8    ld   a,($B800)
0147: 3A AC 62    ld   a,(unknown_62AC)
014A: 3C          inc  a
014B: 32 AC 62    ld   (unknown_62AC),a
014E: CD AE FE    call $FEAE
0151: CD D3 E9    call $E9D3
0154: CD 6F E7    call $E76F
0157: CD 16 E6    call $E616
015A: CD 38 05    call $0538
015D: CD 37 C6    call $C637
0160: CD B3 CE    call $CEB3
0163: CD C4 D3    call $D3C4
0166: 3A 00 B8    ld   a,($B800)
0169: 3A 71 62    ld   a,(unknown_6271)
016C: 32 72 62    ld   (unknown_6272),a
016F: 3A 0C 57    ld   a,($570C)
0172: 32 71 62    ld   (unknown_6271),a
0175: FD 21 56 61 ld   iy,unknown_6156
0179: DD 21 94 65 ld   ix,guard_1_struct_6594
017D: 11 48 61    ld   de,unknown_6148
0180: CD 4C 05    call $054C
0183: FD 21 57 61 ld   iy,unknown_6157
0187: DD 21 98 65 ld   ix,guard_2_struct_6598
018B: 11 49 61    ld   de,unknown_6149
018E: CD 4C 05    call $054C
0191: 2A 38 60    ld   hl,(guard_1_logical_address_6038)
0194: DD 21 EB 61 ld   ix,unknown_61EB
0198: FD 21 3A 60 ld   iy,unknown_603A
019C: DD 7E 00    ld   a,(ix+$00)
019F: DD A6 01    and  (ix+$01)
01A2: 08          ex   af,af'
01A3: 11 97 65    ld   de,guard_1_y_6597
01A6: 3A 99 60    ld   a,(guard_1_screen_6099)
01A9: 47          ld   b,a
01AA: 3A EB 61    ld   a,(unknown_61EB)
01AD: FE 00       cp   $00
01AF: C4 77 CF    call nz,$CF77
01B2: 2A 78 60    ld   hl,(guard_2_logical_address_6078)
01B5: DD 21 EC 61 ld   ix,unknown_61EC
01B9: FD 21 7A 60 ld   iy,unknown_607A
01BD: 11 9B 65    ld   de,guard_2_y_659B
01C0: 3E 00       ld   a,$00
01C2: 08          ex   af,af'
01C3: 3A 9A 60    ld   a,(guard_2_screen_609A)
01C6: 47          ld   b,a
01C7: 3A EC 61    ld   a,(unknown_61EC)
01CA: FE 00       cp   $00
01CC: C4 77 CF    call nz,$CF77
01CF: 3A ED 61    ld   a,(check_scenery_disabled_61ED)
01D2: FE 00       cp   $00
01D4: CC 99 F1    call z,$F199
01D7: CD 5E 11    call handle_player_object_pickup_115E
01DA: CD E8 08    call $08E8
01DD: 3A 2C 60    ld   a,(unknown_602C)
01E0: FE 01       cp   $01
01E2: 28 06       jr   z,$01EA
01E4: CD 84 08    call $0884
01E7: 3A 00 B8    ld   a,($B800)
01EA: CD C2 08    call $08C2
01ED: AF          xor  a
01EE: 32 2C 60    ld   (unknown_602C),a
01F1: 3A 00 B8    ld   a,($B800)
01F4: CD 3E F8    call wagon_player_collision_F83E
01F7: CD 92 07    call $0792
01FA: CD C6 CB    call $CBC6
01FD: CD D5 07    call $07D5
0200: CD 82 09    call $0982
0203: CD 10 09    call $0910
0206: 3A 00 B8    ld   a,($B800)
0209: CD 9F D5    call $D59F
020C: CD D6 D5    call $D5D6
020F: 3A ED 61    ld   a,(check_scenery_disabled_61ED)
0212: FE 00       cp   $00
0214: CC A6 09    call z,$09A6
0217: 3A 00 B8    ld   a,($B800)
021A: CD 8A DA    call $DA8A
021D: 3A 26 60    ld   a,(player_input_6026)
0220: E6 60       and  $60
0222: FE 00       cp   $00
0224: 28 17       jr   z,$023D
0226: 3A 83 65    ld   a,(player_y_6583)
0229: F5          push af
022A: 3D          dec  a
022B: 32 83 65    ld   (player_y_6583),a
022E: CD A7 EA    call $EAA7
0231: F1          pop  af
0232: 32 83 65    ld   (player_y_6583),a
0235: 3A C7 61    ld   a,(holds_barrow_61C7)
0238: FE 00       cp   $00
023A: CC 14 0E    call z,$0E14
023D: CD A7 EA    call $EAA7
0240: 3A 4E 60    ld   a,(fatal_fall_height_reached_604E)
0243: FE 00       cp   $00
0245: 20 57       jr   nz,$029E
0247: CD 64 D4    call $D464
024A: 3A 14 60    ld   a,(unknown_6014)
024D: FE 01       cp   $01
024F: 28 0E       jr   z,$025F
0251: 3A E5 62    ld   a,(unknown_62E5)
0254: FE 01       cp   $01
0256: 28 07       jr   z,$025F
0258: 3A 08 60    ld   a,(unknown_6008)
025B: FE 01       cp   $01
025D: 28 3F       jr   z,$029E
025F: 3A BD 62    ld   a,(unknown_62BD)
0262: FE 00       cp   $00
0264: 20 38       jr   nz,$029E
0266: 3A D2 62    ld   a,(unknown_62D2)
0269: FE 01       cp   $01
026B: 28 31       jr   z,$029E
026D: 3A 95 62    ld   a,(unknown_6295)
0270: FE 00       cp   $00
0272: 20 2A       jr   nz,$029E
0274: 3A B0 62    ld   a,(unknown_62B0)
0277: FE 01       cp   $01
0279: 28 07       jr   z,$0282
027B: 3A AF 62    ld   a,(unknown_62AF)
027E: FE 01       cp   $01
0280: 28 1C       jr   z,$029E
0282: 3A 14 60    ld   a,(unknown_6014)
0285: FE 01       cp   $01
0287: 20 07       jr   nz,$0290
0289: 3A 12 60    ld   a,(elevator_not_moving_6012)
028C: FE 01       cp   $01
028E: 20 0E       jr   nz,$029E
0290: FD 21 47 60 ld   iy,player_just_moved_flag_6047
0294: DD 21 80 65 ld   ix,player_struct_6580
0298: CD C6 0B    call player_movement_0BC6
029B: 3A 00 B8    ld   a,($B800)
029E: CD C6 10    call handle_player_object_carry_10C6
02A1: CD 0C 11    call $110C
02A4: 3E 01       ld   a,$01
02A6: 32 8A 62    ld   (unknown_628A),a
02A9: 3A 0D 60    ld   a,(player_screen_600D)
02AC: 32 98 60    ld   (current_guard_screen_index_6098),a
02AF: 21 14 60    ld   hl,unknown_6014
02B2: DD 21 80 65 ld   ix,player_struct_6580
02B6: CD B1 0A    call $0AB1
02B9: 3A 00 B8    ld   a,($B800)
02BC: 3A F2 61    ld   a,(player_controls_blocked_61F2)
02BF: FE 00       cp   $00
02C1: 20 60       jr   nz,$0323
02C3: 3A D2 62    ld   a,(unknown_62D2)
02C6: FE 01       cp   $01
02C8: 28 59       jr   z,$0323
02CA: 3A E5 62    ld   a,(unknown_62E5)
02CD: FE 01       cp   $01
02CF: 28 52       jr   z,$0323
02D1: 3A BD 62    ld   a,(unknown_62BD)
02D4: FE 01       cp   $01
02D6: 28 4B       jr   z,$0323
02D8: 3A AF 62    ld   a,(unknown_62AF)
02DB: FE 01       cp   $01
02DD: 28 44       jr   z,$0323
02DF: 3A 0D 60    ld   a,(player_screen_600D)
02E2: 32 98 60    ld   (current_guard_screen_index_6098),a
02E5: 21 08 60    ld   hl,unknown_6008
02E8: 7E          ld   a,(hl)
02E9: FE 00       cp   $00
02EB: 28 1F       jr   z,$030C
02ED: 3A 0D 60    ld   a,(player_screen_600D)
02F0: FE 04       cp   $04
02F2: 20 18       jr   nz,$030C
02F4: 3A 13 60    ld   a,(unknown_6013)
02F7: FE 01       cp   $01
02F9: 28 11       jr   z,$030C
02FB: 3A 14 60    ld   a,(unknown_6014)
02FE: FE 01       cp   $01
0300: 28 0A       jr   z,$030C
0302: 3A C7 61    ld   a,(holds_barrow_61C7)
0305: FE 01       cp   $01
0307: E5          push hl
0308: CC 4B D6    call z,$D64B
030B: E1          pop  hl
030C: FD 21 4D 60 ld   iy,fall_height_604D
0310: DD 21 80 65 ld   ix,player_struct_6580
0314: 3A 14 60    ld   a,(unknown_6014)
0317: 4F          ld   c,a
0318: 3A 13 60    ld   a,(unknown_6013)
031B: 06 19       ld   b,$19
031D: CD 82 0B    call $0B82
0320: 3A 00 B8    ld   a,($B800)
0323: 3A 0D 60    ld   a,(player_screen_600D)
0326: 32 98 60    ld   (current_guard_screen_index_6098),a
0329: DD 21 80 65 ld   ix,player_struct_6580
032D: FD 21 14 60 ld   iy,unknown_6014
0331: CD DB 0A    call handle_elevators_0ADB
0334: DD 21 80 65 ld   ix,player_struct_6580
0338: 21 14 60    ld   hl,unknown_6014
033B: CD 40 0A    call $0A40
033E: 3A 56 61    ld   a,(unknown_6156)
0341: FE 00       cp   $00
0343: 20 63       jr   nz,$03A8
0345: 3A D6 62    ld   a,(unknown_62D6)
0348: FE 01       cp   $01
034A: 28 3B       jr   z,$0387
034C: 3A 11 62    ld   a,(unknown_6211)
034F: FE 00       cp   $00
0351: 20 34       jr   nz,$0387
0353: 3A C4 62    ld   a,(unknown_62C4)
0356: FE 00       cp   $00
0358: 20 2D       jr   nz,$0387
035A: 3A 9D 62    ld   a,(unknown_629D)
035D: FE 00       cp   $00
035F: 20 26       jr   nz,$0387
0361: 3A B6 62    ld   a,(unknown_62B6)
0364: FE 01       cp   $01
0366: 28 0E       jr   z,$0376
0368: 3A B5 62    ld   a,(unknown_62B5)
036B: FE 01       cp   $01
036D: 28 18       jr   z,$0387
036F: 3A 48 61    ld   a,(unknown_6148)
0372: FE 01       cp   $01
0374: 28 11       jr   z,$0387
0376: 3A 3B 60    ld   a,(guard_1_in_elevator_603B)
0379: FE 01       cp   $01
037B: 20 07       jr   nz,$0384
037D: 3A 12 60    ld   a,(elevator_not_moving_6012)
0380: FE 01       cp   $01
0382: 20 03       jr   nz,$0387
0384: CD C0 11    call guard_1_walk_movement_11C0
0387: FD 21 57 60 ld   iy,guard_1_not_moving_timeout_counter_6057
038B: FD 22 93 60 ld   (guard_struct_pointer_6093),iy
038F: 2A 38 60    ld   hl,(guard_1_logical_address_6038)
0392: 22 44 60    ld   (stored_logical_address_6044),hl
0395: 21 35 60    ld   hl,guard_1_ladder_frame_6035
0398: FD 21 27 60 ld   iy,guard_1_direction_6027
039C: DD 21 94 65 ld   ix,guard_1_struct_6594
03A0: 3A 37 60    ld   a,(guard_1_in_elevator_6037)
03A3: FE 01       cp   $01
03A5: C4 BB 05    call nz,$05BB
03A8: 3A 57 61    ld   a,(unknown_6157)
03AB: FE 00       cp   $00
03AD: 20 69       jr   nz,$0418
03AF: 3A 12 62    ld   a,(unknown_6212)
03B2: FE 00       cp   $00
03B4: 20 3B       jr   nz,$03F1
03B6: 3A DA 62    ld   a,(unknown_62DA)
03B9: FE 01       cp   $01
03BB: 28 34       jr   z,$03F1
03BD: 3A CB 62    ld   a,(unknown_62CB)
03C0: FE 00       cp   $00
03C2: 20 2D       jr   nz,$03F1
03C4: 3A A5 62    ld   a,(unknown_62A5)
03C7: FE 00       cp   $00
03C9: 20 26       jr   nz,$03F1
03CB: 3A BA 62    ld   a,(unknown_62BA)
03CE: FE 01       cp   $01
03D0: 28 0E       jr   z,$03E0
03D2: 3A B9 62    ld   a,(unknown_62B9)
03D5: FE 01       cp   $01
03D7: 28 18       jr   z,$03F1
03D9: 3A 49 61    ld   a,(unknown_6149)
03DC: FE 01       cp   $01
03DE: 28 11       jr   z,$03F1
03E0: 3A 7B 60    ld   a,(guard_2_in_elevator_607B)
03E3: FE 01       cp   $01
03E5: 20 07       jr   nz,$03EE
03E7: 3A 12 60    ld   a,(elevator_not_moving_6012)
03EA: FE 01       cp   $01
03EC: 20 03       jr   nz,$03F1
03EE: CD EC 11    call guard_2_walk_movement_11EC
03F1: 2A 78 60    ld   hl,(guard_2_logical_address_6078)
03F4: 22 44 60    ld   (stored_logical_address_6044),hl
03F7: FD 21 97 60 ld   iy,guard_2_not_moving_timeout_counter_6097
03FB: FD 22 93 60 ld   (guard_struct_pointer_6093),iy
03FF: 2A 78 60    ld   hl,(guard_2_logical_address_6078)
0402: 22 44 60    ld   (stored_logical_address_6044),hl
0405: 21 75 60    ld   hl,guard_2_ladder_frame_6075
0408: FD 21 67 60 ld   iy,guard_2_direction_6067
040C: DD 21 98 65 ld   ix,guard_2_struct_6598
0410: 3A 77 60    ld   a,(guard_2_in_elevator_6077)
0413: FE 01       cp   $01
0415: C4 BB 05    call nz,$05BB
0418: 3A 9A 60    ld   a,(guard_2_screen_609A)
041B: 32 98 60    ld   (current_guard_screen_index_6098),a
041E: 21 7B 60    ld   hl,guard_2_in_elevator_607B
0421: DD 21 98 65 ld   ix,guard_2_struct_6598
0425: CD B1 0A    call $0AB1
0428: 3A 00 B8    ld   a,($B800)
042B: 3A 97 60    ld   a,(guard_2_not_moving_timeout_counter_6097)
042E: 3C          inc  a
042F: 32 97 60    ld   (guard_2_not_moving_timeout_counter_6097),a
0432: FD 21 8F 60 ld   iy,unknown_608F
0436: 21 77 60    ld   hl,guard_2_in_elevator_6077
0439: DD 21 98 65 ld   ix,guard_2_struct_6598
043D: 3A EC 61    ld   a,(unknown_61EC)
0440: FE 01       cp   $01
0442: 28 27       jr   z,$046B
0444: 3A DA 62    ld   a,(unknown_62DA)
0447: FE 01       cp   $01
0449: 28 20       jr   z,$046B
044B: 3A CB 62    ld   a,(unknown_62CB)
044E: FE 00       cp   $00
0450: 20 19       jr   nz,$046B
0452: 3A ED 62    ld   a,(unknown_62ED)
0455: FE 01       cp   $01
0457: 28 12       jr   z,$046B
0459: 3A 9A 60    ld   a,(guard_2_screen_609A)
045C: 32 98 60    ld   (current_guard_screen_index_6098),a
045F: 3A 7B 60    ld   a,(guard_2_in_elevator_607B)
0462: 4F          ld   c,a
0463: 3A 7A 60    ld   a,(unknown_607A)
0466: 06 26       ld   b,$26
0468: CD 82 0B    call $0B82
046B: 3A 99 60    ld   a,(guard_1_screen_6099)
046E: 32 98 60    ld   (current_guard_screen_index_6098),a
0471: 21 3B 60    ld   hl,guard_1_in_elevator_603B
0474: DD 21 94 65 ld   ix,guard_1_struct_6594
0478: CD B1 0A    call $0AB1
047B: 3A 57 60    ld   a,(guard_1_not_moving_timeout_counter_6057)
047E: 3C          inc  a
047F: 32 57 60    ld   (guard_1_not_moving_timeout_counter_6057),a
0482: FD 21 4F 60 ld   iy,unknown_604F
0486: 21 37 60    ld   hl,guard_1_in_elevator_6037
0489: DD 21 94 65 ld   ix,guard_1_struct_6594
048D: 3A EB 61    ld   a,(unknown_61EB)
0490: FE 01       cp   $01
0492: 28 27       jr   z,$04BB
0494: 3A D6 62    ld   a,(unknown_62D6)
0497: FE 01       cp   $01
0499: 28 20       jr   z,$04BB
049B: 3A C4 62    ld   a,(unknown_62C4)
049E: FE 00       cp   $00
04A0: 20 19       jr   nz,$04BB
04A2: 3A E9 62    ld   a,(unknown_62E9)
04A5: FE 01       cp   $01
04A7: 28 12       jr   z,$04BB
04A9: 3A 99 60    ld   a,(guard_1_screen_6099)
04AC: 32 98 60    ld   (current_guard_screen_index_6098),a
04AF: 3A 3B 60    ld   a,(guard_1_in_elevator_603B)
04B2: 4F          ld   c,a
04B3: 3A 3A 60    ld   a,(unknown_603A)
04B6: 06 26       ld   b,$26
04B8: CD 82 0B    call $0B82
04BB: CD E0 E3    call $E3E0
04BE: CD 6D E3    call $E36D
04C1: CD 89 E3    call $E389
04C4: CD 30 E6    call $E630
04C7: CD B4 E1    call $E1B4
04CA: CD C0 E1    call $E1C0
04CD: CD CC E1    call $E1CC
04D0: CD 69 E8    call $E869
04D3: CD 3C E0    call $E03C
04D6: CD 42 DF    call $DF42
04D9: CD 13 DD    call $DD13
04DC: CD 0C D6    call $D60C
04DF: 3E 01       ld   a,$01
04E1: 32 7F 62    ld   (unknown_627F),a
04E4: CD ED F3    call $F3ED
04E7: 3A 00 B8    ld   a,($B800)
04EA: CD 11 D5    call $D511
04ED: 3A F1 61    ld   a,(unknown_61F1)
04F0: FE 00       cp   $00
04F2: CC 15 0F    call z,start_a_game_0F15
04F5: 3A ED 61    ld   a,(check_scenery_disabled_61ED)
04F8: FE 01       cp   $01
04FA: CD 61 E8    call $E861
04FD: 3A 5B 63    ld   a,(unknown_635B)
0500: 3C          inc  a
0501: 32 5B 63    ld   (unknown_635B),a
0504: FE 0A       cp   $0A
0506: 38 0A       jr   c,$0512
0508: AF          xor  a
0509: 32 5B 63    ld   (unknown_635B),a
050C: CD 2E 16    call $162E
050F: CD 0F 56    call $560F
0512: CD 89 16    call $1689
0515: CD 4D D3    call $D34D
0518: 3A 56 63    ld   a,(unknown_6356)
051B: FE 00       cp   $00
051D: C0          ret  nz
051E: 3A 00 B8    ld   a,($B800)
0521: 3E 01       ld   a,$01
0523: 32 00 A0    ld   (interrupt_control_A000),a
0526: ED 56       im   1
0528: F1          pop  af
0529: 08          ex   af,af'
052A: E1          pop  hl
052B: D1          pop  de
052C: C1          pop  bc
052D: D9          exx
052E: FD E1       pop  iy
0530: DD E1       pop  ix
0532: E1          pop  hl
0533: D1          pop  de
0534: C1          pop  bc
0535: F1          pop  af
0536: FB          ei
0537: C9          ret
0538: 3A 59 61    ld   a,(bag_falling_6159)
053B: 47          ld   b,a
053C: 3A 34 63    ld   a,(unknown_6334)
053F: B0          or   b
0540: FE 00       cp   $00
0542: C8          ret  z
0543: 3A 9F 65    ld   a,(sprite_object_y_659F)
0546: 3C          inc  a
0547: 3C          inc  a
0548: 32 9F 65    ld   (sprite_object_y_659F),a
054B: C9          ret
054C: FD 7E 00    ld   a,(iy+$00)
054F: FE 00       cp   $00
0551: C8          ret  z
0552: 2A 54 61    ld   hl,(unknown_6154)
0555: 3A 53 61    ld   a,(unknown_6153)
0558: FE 07       cp   $07
055A: 20 11       jr   nz,$056D
055C: 7E          ld   a,(hl)
055D: FE FF       cp   $FF
055F: 28 14       jr   z,$0575
0561: DD 77 00    ld   (ix+$00),a
0564: 23          inc  hl
0565: 22 54 61    ld   (unknown_6154),hl
0568: AF          xor  a
0569: 32 53 61    ld   (unknown_6153),a
056C: C9          ret
056D: 3A 53 61    ld   a,(unknown_6153)
0570: 3C          inc  a
0571: 32 53 61    ld   (unknown_6153),a
0574: C9          ret
0575: 3E 31       ld   a,$31
0577: DD 77 00    ld   (ix+$00),a
057A: AF          xor  a
057B: FD 77 00    ld   (iy+$00),a
057E: 12          ld   (de),a
057F: C9          ret
0580: FD 21 51 61 ld   iy,game_locked_6151
0584: DD 21 80 65 ld   ix,player_struct_6580
0588: 2A 54 61    ld   hl,(unknown_6154)
058B: FD 7E 00    ld   a,(iy+$00)
058E: FE 00       cp   $00
0590: C8          ret  z
0591: 3A 53 61    ld   a,(unknown_6153)
0594: FE 07       cp   $07
0596: 20 11       jr   nz,$05A9
0598: 7E          ld   a,(hl)
0599: FE FF       cp   $FF
059B: 28 14       jr   z,$05B1
059D: DD 77 00    ld   (ix+$00),a
05A0: 23          inc  hl
05A1: 22 54 61    ld   (unknown_6154),hl
05A4: AF          xor  a
05A5: 32 53 61    ld   (unknown_6153),a
05A8: C9          ret
05A9: 3A 53 61    ld   a,(unknown_6153)
05AC: 3C          inc  a
05AD: 32 53 61    ld   (unknown_6153),a
05B0: C9          ret
05B1: 3E 01       ld   a,$01
05B3: 32 52 61    ld   (wait_flag_6152),a
05B6: C9          ret
05B7: 94          sub  h
05B8: 65          ld   h,l
05B9: 98          sbc  a,b
05BA: 65          ld   h,l
05BB: FD 7E 00    ld   a,(iy+$00)
05BE: E6 10       and  $10
05C0: FE 10       cp   $10
05C2: 28 15       jr   z,$05D9
05C4: FD 7E 00    ld   a,(iy+$00)
05C7: E6 20       and  $20
05C9: FE 20       cp   $20
05CB: C0          ret  nz
05CC: E5          push hl
05CD: 2A 44 60    ld   hl,(stored_logical_address_6044)
05D0: 7E          ld   a,(hl)
05D1: FE FF       cp   $FF
05D3: E1          pop  hl
05D4: C0          ret  nz
05D5: 06 00       ld   b,$00
05D7: 18 0C       jr   $05E5
05D9: E5          push hl
05DA: 2A 44 60    ld   hl,(stored_logical_address_6044)
05DD: 2B          dec  hl
05DE: 7E          ld   a,(hl)
05DF: FE FF       cp   $FF
05E1: E1          pop  hl
05E2: C0          ret  nz
05E3: 06 80       ld   b,$80
05E5: 7E          ld   a,(hl)
05E6: FE 0B       cp   $0B
05E8: 20 05       jr   nz,$05EF
05EA: 3E 01       ld   a,$01
05EC: 77          ld   (hl),a
05ED: 18 02       jr   $05F1
05EF: 3C          inc  a
05F0: 77          ld   (hl),a
05F1: 7E          ld   a,(hl)
05F2: FE 01       cp   $01
05F4: C8          ret  z
05F5: FE 03       cp   $03
05F7: C8          ret  z
05F8: FE 05       cp   $05
05FA: C8          ret  z
05FB: FE 08       cp   $08
05FD: C8          ret  z
05FE: FE 0A       cp   $0A
0600: CC 31 06    call z,$0631
0603: FE 02       cp   $02
0605: CC 31 06    call z,$0631
0608: FE 04       cp   $04
060A: CC 31 06    call z,$0631
060D: FE 07       cp   $07
060F: CC 31 06    call z,$0631
0612: FE 09       cp   $09
0614: CC 31 06    call z,$0631
0617: FE 06       cp   $06
0619: 20 09       jr   nz,$0624
061B: 3E 27       ld   a,$27
061D: DD 77 00    ld   (ix+$00),a
0620: CD 31 06    call $0631
0623: C9          ret
0624: FE 0B       cp   $0B
0626: 20 08       jr   nz,$0630
0628: 3E A7       ld   a,$A7
062A: DD 77 00    ld   (ix+$00),a
062D: CD 31 06    call $0631
0630: C9          ret
0631: F5          push af
0632: C5          push bc
0633: 3A F5 61    ld   a,(unknown_61F5)
0636: FE 00       cp   $00
0638: 20 14       jr   nz,$064E
063A: 3A CF 61    ld   a,(has_pick_61CF)
063D: FE 00       cp   $00
063F: 20 0D       jr   nz,$064E
0641: 3A F3 61    ld   a,(unknown_61F3)
0644: FE 00       cp   $00
0646: 20 06       jr   nz,$064E
0648: 21 7B D9    ld   hl,$D97B
064B: CD 84 EC    call play_sample_EC84
064E: C1          pop  bc
064F: F1          pop  af
0650: F5          push af
0651: 78          ld   a,b
0652: FE 80       cp   $80
0654: 20 14       jr   nz,$066A
0656: DD 7E 03    ld   a,(ix+$03)
0659: 3D          dec  a
065A: DD 77 03    ld   (ix+$03),a
065D: AF          xor  a
065E: FD 2A 93 60 ld   iy,(guard_struct_pointer_6093)
0662: FD 77 00    ld   (iy+$00),a
0665: CD C9 0F    call align_character_x_0fc9
0668: F1          pop  af
0669: C9          ret
066A: DD 7E 03    ld   a,(ix+$03)
066D: 3C          inc  a
066E: DD 77 03    ld   (ix+$03),a
0671: AF          xor  a
0672: FD 2A 93 60 ld   iy,(guard_struct_pointer_6093)
0676: FD 77 00    ld   (iy+$00),a
0679: CD C9 0F    call align_character_x_0fc9
067C: F1          pop  af
067D: C9          ret
	;;
	;; guard left/right movement routine
	;; no A.I. here:	 if direction = left, animates left, etc..
	;;
guard_walk_movement_067E:
067E: FD 7E 00    ld   a,(iy+$00) ;  guard direction
0681: E6 80       and  $80
0683: FE 80       cp   $80
0685: 20 0F       jr   nz,$0696
	;; guard faces right
0687: E5          push hl
0688: 2A 44 60    ld   hl,(stored_logical_address_6044)
068B: CD 71 0D    call character_can_walk_right_0D71
068E: E1          pop  hl
068F: 3A 0B 60    ld   a,(way_clear_flag_600B)
0692: FE 02       cp   $02
0694: 28 1A       jr   z,$06B0
	;; does not face right or cannot walk right. handle left side
0696: FD 7E 00    ld   a,(iy+$00)
0699: E6 40       and  $40
069B: FE 40       cp   $40	;  faces left?
069D: C0          ret  nz	; neither right or left: on ladder? quit
069E: E5          push hl
069F: 2A 44 60    ld   hl,(stored_logical_address_6044)
06A2: CD CC 0D    call character_can_walk_left_0DCC
06A5: E1          pop  hl
06A6: 3A 0B 60    ld   a,(way_clear_flag_600B)
06A9: FE 02       cp   $02
06AB: C0          ret  nz
06AC: 06 80       ld   b,$80
06AE: 28 02       jr   z,$06B2
06B0: 06 00       ld   b,$00
06B2: 7E          ld   a,(hl)
06B3: FE 0B       cp   $0B
06B5: 20 05       jr   nz,$06BC
06B7: 3E 01       ld   a,$01
06B9: 77          ld   (hl),a
06BA: 18 02       jr   $06BE
06BC: 3C          inc  a
06BD: 77          ld   (hl),a
06BE: 7E          ld   a,(hl)
06BF: FE 02       cp   $02
06C1: 28 2B       jr   z,guard_move_if_fast_enough_06EE
06C3: FE 05       cp   $05
06C5: 28 27       jr   z,guard_move_if_fast_enough_06EE
06C7: FE 09       cp   $09
06C9: 28 23       jr   z,guard_move_if_fast_enough_06EE
06CB: FE FF       cp   $FF
06CD: 28 1F       jr   z,guard_move_if_fast_enough_06EE
06CF: FE 04       cp   $04
06D1: CA EE 06    jp   z,guard_move_if_fast_enough_06EE
06D4: FE 06       cp   $06
06D6: CC 22 07    call z,guard_unconditional_move_0722
06D9: FE 08       cp   $08
06DB: CC 22 07    call z,guard_unconditional_move_0722
06DE: FE 0A       cp   $0A
06E0: CC 22 07    call z,guard_unconditional_move_0722
06E3: FE 01       cp   $01
06E5: 20 19       jr   nz,$0700
06E7: 3E 31       ld   a,$31
06E9: B0          or   b
06EA: C3 17 FF    jp   $FF17
06ED: C9          ret
guard_move_if_fast_enough_06EE:
06EE: F5          push af
06EF: C5          push bc
06F0: 47          ld   b,a
06F1: 3A 64 61    ld   a,(guard_speed_6164)
06F4: B8          cp   b
06F5: 30 03       jr   nc,$06FA
	;; b > guard speed:	don't move
06F7: C1          pop  bc
06F8: F1          pop  af
06F9: C9          ret
06FA: C1          pop  bc
06FB: F1          pop  af
06FC: CD 22 07    call guard_unconditional_move_0722
06FF: C9          ret
0700: FE 03       cp   $03
0702: 20 07       jr   nz,$070B
0704: 3E 30       ld   a,$30
0706: B0          or   b
0707: C3 17 FF    jp   $FF17
070A: C9          ret
070B: FE 07       cp   $07
070D: 20 07       jr   nz,$0716
070F: 3E 2E       ld   a,$2E
0711: B0          or   b
0712: C3 27 FF    jp   $FF27
0715: C9          ret
0716: FE FF       cp   $FF
0718: 20 07       jr   nz,$0721
071A: 3E 30       ld   a,$30
071C: B0          or   b
071D: C3 2F FF    jp   $FF2F
0720: C9          ret
0721: C9          ret
guard_unconditional_move_0722:
	;; actually move
0722: F5          push af
0723: C5          push bc
0724: 3A F5 61    ld   a,(unknown_61F5)
0727: FE 00       cp   $00
0729: 20 14       jr   nz,$073F
072B: 3A CF 61    ld   a,(has_pick_61CF)
072E: FE 00       cp   $00
0730: 20 0D       jr   nz,$073F
0732: 3A F3 61    ld   a,(unknown_61F3)
0735: FE 00       cp   $00
0737: 20 06       jr   nz,$073F
0739: 21 9F D9    ld   hl,$D99F
* guard walking sound
073C: CD 84 EC    call play_sample_EC84
073F: C1          pop  bc
0740: AF          xor  a
0741: FD 2A 93 60 ld   iy,(guard_struct_pointer_6093)
0745: FD 77 00    ld   (iy+$00),a
0748: 78          ld   a,b
0749: FE 80       cp   $80
074B: 28 19       jr   z,$0766
074D: DD 7E 02    ld   a,(ix+$02)
0750: 3C          inc  a
0751: DD 77 02    ld   (ix+$02),a
0754: FE F0       cp   $F0	;  F0 is the max screen X
0756: 20 0C       jr   nz,$0764
0758: 3E 01       ld   a,$01
075A: DD 77 02    ld   (ix+$02),a
	;; increase screen index
075D: 3A 98 60    ld   a,(current_guard_screen_index_6098)
0760: 3C          inc  a
0761: 32 98 60    ld   (current_guard_screen_index_6098),a
0764: F1          pop  af
0765: C9          ret
0766: DD 7E 02    ld   a,(ix+$02)
0769: 3D          dec  a
076A: DD 77 02    ld   (ix+$02),a
076D: FE 01       cp   $01	;  1 is the min screen x
076F: 20 0C       jr   nz,$077D
	;; set x to $F0
0771: 3E F0       ld   a,$F0
0773: DD 77 02    ld   (ix+$02),a
	;; decrease screen index
0776: 3A 98 60    ld   a,(current_guard_screen_index_6098)
0779: 3D          dec  a
077A: 32 98 60    ld   (current_guard_screen_index_6098),a
077D: AF          xor  a
077E: FD 2A 93 60 ld   iy,(guard_struct_pointer_6093)
0782: FD 77 00    ld   (iy+$00),a
0785: F1          pop  af
0786: C9          ret
0787: AF          xor  a
0788: 32 1C 60    ld   (player_in_wagon_1_601C),a
078B: 32 1D 60    ld   (player_in_wagon_2_601D),a
078E: 32 1E 60    ld   (player_in_wagon_3_601E),a
0791: C9          ret
0792: 21 1C 60    ld   hl,player_in_wagon_1_601C
0795: DD 21 8A 65 ld   ix,wagon_data_658A
0799: FD 21 82 65 ld   iy,player_x_6582
079D: 11 04 00    ld   de,$0004
07A0: 7E          ld   a,(hl)
07A1: FE 01       cp   $01
07A3: 28 01       jr   z,$07A6
07A5: C9          ret
07A6: 3E 01       ld   a,$01
07A8: 32 30 60    ld   (unknown_6030),a
07AB: 3A 26 60    ld   a,(player_input_6026)
07AE: E6 08       and  $08
07B0: FE 08       cp   $08
07B2: CC C9 07    call z,$07C9
07B5: 3A 26 60    ld   a,(player_input_6026)
07B8: E6 10       and  $10
07BA: FE 10       cp   $10
07BC: CC CF 07    call z,$07CF
07BF: 3E 01       ld   a,$01
07C1: 32 29 60    ld   (player_in_wagon_flag_6029),a
07C4: 3D          dec  a
07C5: 32 2F 60    ld   (player_in_wagon_flag_13_602F),a
07C8: C9          ret
07C9: 3E 01       ld   a,$01
07CB: 32 2D 60    ld   (unknown_602D),a
07CE: C9          ret
07CF: 3E 01       ld   a,$01
07D1: 32 2E 60    ld   (unknown_602E),a
07D4: C9          ret
07D5: 3A 30 60    ld   a,(unknown_6030)
07D8: FE 01       cp   $01
07DA: C0          ret  nz
07DB: 3A 2D 60    ld   a,(unknown_602D)
07DE: FE 01       cp   $01
07E0: CC 10 08    call z,$0810
07E3: 3A 2E 60    ld   a,(unknown_602E)
07E6: FE 01       cp   $01
07E8: CC 20 08    call z,$0820
07EB: 3A 2F 60    ld   a,(player_in_wagon_flag_13_602F)
07EE: 3C          inc  a
07EF: FE 04       cp   $04
07F1: 28 04       jr   z,$07F7
07F3: 32 2F 60    ld   (player_in_wagon_flag_13_602F),a
07F6: C9          ret
	;;  kind of reset but called when???
07F7: AF          xor  a
07F8: 32 2D 60    ld   (unknown_602D),a
07FB: 32 2E 60    ld   (unknown_602E),a
07FE: 32 30 60    ld   (unknown_6030),a
0801: 32 29 60    ld   (player_in_wagon_flag_6029),a
0804: 32 25 60    ld   (player_death_flag_6025),a
0807: CD 87 07    call $0787
080A: 3E 20       ld   a,$20
080C: 32 80 65    ld   (player_struct_6580),a
080F: C9          ret
0810: CD 30 08    call $0830
0813: CD 70 08    call $0870
0816: FD 7E 00    ld   a,(iy+$00)
0819: 3D          dec  a
081A: 3D          dec  a
081B: 3D          dec  a
081C: FD 77 00    ld   (iy+$00),a
081F: C9          ret
0820: CD 30 08    call $0830
0823: CD 53 08    call $0853
0826: FD 7E 00    ld   a,(iy+$00)
0829: 3C          inc  a
082A: 3C          inc  a
082B: 3C          inc  a
082C: FD 77 00    ld   (iy+$00),a
082F: C9          ret
0830: 11 4F 08    ld   de,$084F
0833: 3A 2F 60    ld   a,(player_in_wagon_flag_13_602F)
0836: FE 04       cp   $04
0838: C8          ret  z
0839: 83          add  a,e
083A: 5F          ld   e,a
083B: 7A          ld   a,d
083C: CE 00       adc  a,$00
083E: 57          ld   d,a
083F: 1A          ld   a,(de)
0840: 47          ld   b,a
0841: 3A 80 65    ld   a,(player_struct_6580)
0844: E6 08       and  $08
0846: B0          or   b
0847: 32 80 65    ld   (player_struct_6580),a
084A: AF          xor  a
084B: 32 25 60    ld   (player_death_flag_6025),a
084E: C9          ret
084F: 1D          dec  e
0850: 1D          dec  e
0851: 1D          dec  e
0852: 1D          dec  e
0853: 06 20       ld   b,$20
0855: C5          push bc
0856: 2A 09 60    ld   hl,(player_logical_address_6009)
0859: CD 71 0D    call character_can_walk_right_0D71
085C: 3A 0B 60    ld   a,(way_clear_flag_600B)
085F: FE 02       cp   $02
0861: 20 02       jr   nz,$0865
0863: C1          pop  bc
0864: C9          ret
0865: 3E 01       ld   a,$01
0867: 32 25 60    ld   (player_death_flag_6025),a
086A: 3D          dec  a
086B: 32 29 60    ld   (player_in_wagon_flag_6029),a
086E: C1          pop  bc
086F: C9          ret
0870: 06 20       ld   b,$20
0872: C5          push bc
0873: 2A 09 60    ld   hl,(player_logical_address_6009)
0876: CD CC 0D    call character_can_walk_left_0DCC
0879: 3A 0B 60    ld   a,(way_clear_flag_600B)
087C: FE 02       cp   $02
087E: 20 E5       jr   nz,$0865
0880: C1          pop  bc
0881: 10 EF       djnz $0872
0883: C9          ret
player_grip_handle_test_0884
0884: 2A 09 60    ld   hl,(player_logical_address_6009)
0887: 2B          dec  hl
0888: 2B          dec  hl
0889: 2B          dec  hl
088A: 7E          ld   a,(hl)	; check what's above player head on screen
088B: FE DC       cp   $DC
088D: 28 03       jr   z,$0892
088F: FE 0B       cp   $0B
0891: C0          ret  nz
0892: 3A 2A 60    ld   a,(player_gripping_handle_602A)
0895: FE 01       cp   $01
0897: C8          ret  z
0898: 3E 01       ld   a,$01
089A: 21 1E 60    ld   hl,player_in_wagon_3_601E
089D: 01 03 00    ld   bc,$0003
08A0: ED B9       cpdr
08A2: C8          ret  z
08A3: CD E3 F4    call test_pickup_flag_F4E3
08A6: 78          ld   a,b
08A7: FE 01       cp   $01
08A9: C0          ret  nz
08AA: 3E 01       ld   a,$01
08AC: 32 28 60    ld   (player_controls_frozen_6028),a
08AF: 32 2A 60    ld   (player_gripping_handle_602A),a
08B2: 3D          dec  a
08B3: 32 2B 60    ld   (unknown_602B),a
08B6: 3E 01       ld   a,$01
08B8: 32 75 62    ld   (unknown_6275),a
08BB: 21 63 D9    ld   hl,$D963
08BE: CD 84 EC    call play_sample_EC84
08C1: C9          ret
08C2: 3A 2A 60    ld   a,(player_gripping_handle_602A)
08C5: FE 01       cp   $01
08C7: C0          ret  nz
08C8: 11 E3 08    ld   de,l_08E3
08CB: 3A 2B 60    ld   a,(unknown_602B)
08CE: FE 05       cp   $05
08D0: C8          ret  z
08D1: 83          add  a,e
08D2: 5F          ld   e,a
08D3: 7A          ld   a,d
08D4: CE 00       adc  a,$00
08D6: 57          ld   d,a
08D7: 1A          ld   a,(de)
08D8: 32 80 65    ld   (player_struct_6580),a
08DB: 3A 2B 60    ld   a,(unknown_602B)
08DE: 3C          inc  a
08DF: 32 2B 60    ld   (unknown_602B),a
08E2: C9          ret
l_08E3:
	.byte	0x1C
	.byte	0x1C
	.byte	0x1C
	.byte	0x1C
	.byte	0x1B

08E8: 3A 2A 60    ld   a,(player_gripping_handle_602A)
08EB: FE 01       cp   $01
08ED: C0          ret  nz
08EE: CD E3 F4    call test_pickup_flag_F4E3
08F1: 78          ld   a,b
08F2: FE 00       cp   $00
08F4: C8          ret  z
08F5: AF          xor  a
08F6: 32 2A 60    ld   (player_gripping_handle_602A),a
08F9: 32 28 60    ld   (player_controls_frozen_6028),a
08FC: 32 29 60    ld   (player_in_wagon_flag_6029),a
08FF: 32 2B 60    ld   (unknown_602B),a
0902: 32 60 61    ld   (pickup_flag_6160),a
0905: 3E 19       ld   a,$19
0907: 32 80 65    ld   (player_struct_6580),a
090A: 3E 01       ld   a,$01
090C: 32 2C 60    ld   (unknown_602C),a
090F: C9          ret
0910: 3A 2A 60    ld   a,(player_gripping_handle_602A)
0913: FE 01       cp   $01
0915: C8          ret  z
0916: 3A 25 60    ld   a,(player_death_flag_6025)
0919: FE 01       cp   $01
091B: C8          ret  z
091C: 3A 83 65    ld   a,(player_y_6583)
091F: 3C          inc  a
0920: DD 21 8A 65 ld   ix,wagon_data_658A
0924: FD 21 1C 60 ld   iy,player_in_wagon_1_601C
0928: 11 04 00    ld   de,$0004
092B: CD 2F 09    call $092F
092E: C9          ret
092F: DD BE 01    cp   (ix+$01)
0932: 20 47       jr   nz,$097B
0934: F5          push af
0935: 06 08       ld   b,$08
0937: 3A 82 65    ld   a,(player_x_6582)
093A: D6 05       sub  $05
093C: 3C          inc  a
093D: F5          push af
093E: DD BE 00    cp   (ix+$00)
0941: 28 2F       jr   z,$0972
0943: F1          pop  af
0944: 10 F6       djnz $093C
0946: 18 2D       jr   $0975
0948: FD 7E 00    ld   a,(iy+$00)
094B: FE 00       cp   $00
094D: 20 17       jr   nz,$0966
094F: E5          push hl
0950: DD E5       push ix
0952: 21 00 01    ld   hl,$0100
0955: CD 90 5C    call add_to_score_5C90
0958: 21 69 D9    ld   hl,$D969
095B: CD 84 EC    call play_sample_EC84
095E: 3E 01       ld   a,$01
0960: 32 75 62    ld   (unknown_6275),a
0963: DD E1       pop  ix
0965: E1          pop  hl
0966: 3E 01       ld   a,$01
0968: FD 77 00    ld   (iy+$00),a
096B: 3E 1A       ld   a,$1A
096D: 32 80 65    ld   (player_struct_6580),a
0970: F1          pop  af
0971: C9          ret
0972: F1          pop  af
0973: 18 D3       jr   $0948
0975: AF          xor  a
0976: FD 77 00    ld   (iy+$00),a
0979: F1          pop  af
097A: C9          ret
097B: F5          push af
097C: AF          xor  a
097D: FD 77 00    ld   (iy+$00),a
0980: F1          pop  af
0981: C9          ret
compute_wagon_start_values_0982:
0982: DD 21 19 60 ld   ix,unknown_6019
0986: FD 21 8B 65 ld   iy,unknown_658B
098A: 3E C1       ld   a,$C1
098C: 08          ex   af,af'
098D: CD 91 09    call $0991
0990: C9          ret
0991: 3A 0D 60    ld   a,(player_screen_600D)
0994: 3D          dec  a
0995: DD BE 00    cp   (ix+$00)
0998: C2 A0 09    jp   nz,$09A0
099B: 08          ex   af,af'
099C: FD 77 00    ld   (iy+$00),a
099F: C9          ret
	;; not in current player screen: set coords to 255
09A0: 3E FF       ld   a,$FF
09A2: FD 77 00    ld   (iy+$00),a
09A5: C9          ret
09A6: DD 21 16 60 ld   ix,wagon_direction_array_6016
09AA: FD 21 3C 0A ld   iy,$0A3C
09AE: 21 8A 65    ld   hl,wagon_data_658A
09B1: CD B5 09    call $09B5
09B4: C9          ret
09B5: DD 7E 00    ld   a,(ix+$00)
09B8: FE 00       cp   $00
09BA: C2 FD 09    jp   nz,$09FD
09BD: 7E          ld   a,(hl)
09BE: 3D          dec  a
09BF: 77          ld   (hl),a
09C0: F5          push af
09C1: DD 7E 06    ld   a,(ix+$06)
09C4: FE 00       cp   $00
09C6: 28 13       jr   z,$09DB
09C8: 3A 82 65    ld   a,(player_x_6582)
09CB: 3D          dec  a
09CC: 32 82 65    ld   (player_x_6582),a
09CF: 3A 95 62    ld   a,(unknown_6295)
09D2: FE 00       cp   $00
09D4: 20 05       jr   nz,$09DB
09D6: 3E 1A       ld   a,$1A
09D8: 32 80 65    ld   (player_struct_6580),a
09DB: F1          pop  af
09DC: FD BE 02    cp   (iy+$02)
09DF: CA E8 09    jp   z,$09E8
09E2: FE 00       cp   $00
09E4: CA F5 09    jp   z,$09F5
09E7: C9          ret
09E8: DD 7E 03    ld   a,(ix+$03)
09EB: FD BE 03    cp   (iy+$03)
09EE: C0          ret  nz
09EF: 3E 01       ld   a,$01
09F1: DD 77 00    ld   (ix+$00),a
09F4: C9          ret
09F5: DD 7E 03    ld   a,(ix+$03)
09F8: 3D          dec  a
09F9: DD 77 03    ld   (ix+$03),a
09FC: C9          ret
09FD: 7E          ld   a,(hl)
09FE: 3C          inc  a
09FF: 77          ld   (hl),a
0A00: F5          push af
0A01: DD 7E 06    ld   a,(ix+$06)
0A04: FE 00       cp   $00
0A06: 28 13       jr   z,$0A1B
0A08: 3A 82 65    ld   a,(player_x_6582)
0A0B: 3C          inc  a
0A0C: 32 82 65    ld   (player_x_6582),a
0A0F: 3A 95 62    ld   a,(unknown_6295)
0A12: FE 00       cp   $00
0A14: 20 05       jr   nz,$0A1B
0A16: 3E 1A       ld   a,$1A
0A18: 32 80 65    ld   (player_struct_6580),a
0A1B: F1          pop  af
0A1C: FD BE 00    cp   (iy+$00)
0A1F: CA 27 0A    jp   z,$0A27
0A22: FE FF       cp   $FF
0A24: 28 0E       jr   z,$0A34
0A26: C9          ret
0A27: DD 7E 03    ld   a,(ix+$03)
0A2A: FD BE 01    cp   (iy+$01)
0A2D: C0          ret  nz
0A2E: 3E 00       ld   a,$00
0A30: DD 77 00    ld   (ix+$00),a
0A33: C9          ret
0A34: DD 7E 03    ld   a,(ix+$03)
0A37: 3C          inc  a
0A38: DD 77 03    ld   (ix+$03),a
0A3B: C9          ret
0A3C: B0          or   b
0A3D: 03          inc  bc
0A3E: 20 02       jr   nz,$0A42
0A40: 3A 12 60    ld   a,(elevator_not_moving_6012)
0A43: FE 00       cp   $00
0A45: C8          ret  z
0A46: 3A 11 60    ld   a,(elevator_timer_current_screen_6011)
0A49: 3C          inc  a
0A4A: 32 11 60    ld   (elevator_timer_current_screen_6011),a
0A4D: FE 5F       cp   $5F	;  < $5F:	 don't move the elevator
0A4F: C0          ret  nz
0A50: AF          xor  a
0A51: 32 11 60    ld   (elevator_timer_current_screen_6011),a
0A54: 32 12 60    ld   (elevator_not_moving_6012),a
0A57: 3C          inc  a
0A58: 32 15 60    ld   (unknown_6015),a
0A5B: FD 21 72 0A ld   iy,$0A72
0A5F: 06 09       ld   b,$09
0A61: DD 7E 02    ld   a,(ix+$02)
0A64: FD BE 00    cp   (iy+$00)
0A67: 28 12       jr   z,$0A7B
0A69: FD 23       inc  iy
0A6B: 10 F4       djnz $0A61
0A6D: AF          xor  a
0A6E: 77          ld   (hl),a
0A6F: 2B          dec  hl
0A70: 77          ld   (hl),a
0A71: C9          ret
0A72: C4 C5 C6    call nz,$C6C5
0A75: C7          rst  $00
0A76: C8          ret  z
0A77: C9          ret
0A78: CA CB CC    jp   z,$CCCB

	;; player entering in the elevator

0A7B: 3A 87 65    ld   a,(elevator_y_current_screen_6587)
0A7E: D6 00       sub  $00
0A80: DD BE 03    cp   (ix+$03)
0A83: 28 0E       jr   z,$0A93
0A85: D6 01       sub  $01
0A87: DD BE 03    cp   (ix+$03)
0A8A: 28 07       jr   z,$0A93
0A8C: C6 02       add  a,$02
0A8E: DD BE 03    cp   (ix+$03)
0A91: 20 DA       jr   nz,$0A6D
0A93: 3A 98 60    ld   a,(current_guard_screen_index_6098)
0A96: FE 04       cp   $04
0A98: 20 D3       jr   nz,$0A6D
0A9A: 3A 4E 60    ld   a,(fatal_fall_height_reached_604E)
0A9D: FE 00       cp   $00
0A9F: 28 0A       jr   z,$0AAB
0AA1: 7D          ld   a,l
0AA2: FE 14       cp   $14
0AA4: 20 05       jr   nz,$0AAB
0AA6: 3E 01       ld   a,$01
0AA8: 32 25 60    ld   (player_death_flag_6025),a
0AAB: 3E 01       ld   a,$01
0AAD: 77          ld   (hl),a
0AAE: 2B          dec  hl
0AAF: 77          ld   (hl),a
0AB0: C9          ret
0AB1: 3A 98 60    ld   a,(current_guard_screen_index_6098)
0AB4: FE 04       cp   $04
0AB6: 20 0E       jr   nz,$0AC6
0AB8: FD 21 C9 0A ld   iy,$0AC9
0ABC: 06 12       ld   b,$12
0ABE: 7E          ld   a,(hl)
0ABF: F5          push af
0AC0: CD 61 0A    call $0A61
0AC3: F1          pop  af
0AC4: 77          ld   (hl),a
0AC5: C9          ret
0AC6: AF          xor  a
0AC7: 77          ld   (hl),a
0AC8: C9          ret
0AC9: B8          cp   b
0ACA: B9          cp   c
0ACB: BA          cp   d
0ACC: BB          cp   e
0ACD: BC          cp   h
0ACE: BD          cp   l
0ACF: BE          cp   (hl)
0AD0: BF          cp   a
0AD1: C0          ret  nz
0AD2: C1          pop  bc
0AD3: C2 C3 C4    jp   nz,$C4C3
0AD6: C5          push bc
0AD7: C6 C7       add  a,$C7
0AD9: C8          ret  z
0ADA: C9          ret

; < ix: player struct (6580)
; < iy: unknown_6014
handle_elevators_0ADB:
0ADB: 3A 12 60    ld   a,(elevator_not_moving_6012)
0ADE: FE 00       cp   $00
0AE0: C0          ret  nz
0AE1: 21 87 65    ld   hl,elevator_y_current_screen_6587
0AE4: 3A 10 60    ld   a,(elevator_dir_current_screen_6010)
0AE7: FE 01       cp   $01
0AE9: 20 59       jr   nz,$0B44
0AEB: 7E          ld   a,(hl)
0AEC: FE 1A       cp   $1A
0AEE: 38 4A       jr   c,$0B3A
0AF0: 3A 15 60    ld   a,(unknown_6015)
0AF3: FE 01       cp   $01
0AF5: CA 03 0B    jp   z,$0B03
0AF8: 7E          ld   a,(hl)
0AF9: FE 72       cp   $72
0AFB: CA 7C 0B    jp   z,$0B7C
0AFE: FE C2       cp   $C2
0B00: CA 7C 0B    jp   z,$0B7C
0B03: 35          dec  (hl)
0B04: AF          xor  a
0B05: 32 15 60    ld   (unknown_6015),a
0B08: FD 7E 00    ld   a,(iy+$00)
0B0B: FE 01       cp   $01
0B0D: 20 0F       jr   nz,$0B1E
0B0F: DD 7E 03    ld   a,(ix+$03)
0B12: 3D          dec  a
0B13: DD 77 03    ld   (ix+$03),a
0B16: 3A C7 61    ld   a,(holds_barrow_61C7)
0B19: FE 01       cp   $01
0B1B: CC 9E EB    call z,$EB9E
0B1E: FD 7E 27    ld   a,(iy+$27)
0B21: FE 01       cp   $01
0B23: 20 07       jr   nz,$0B2C
; elevator lifts guard 1 (bad programming practice, offsetting
; guard struct from player struct!!)
0B25: DD 7E 17    ld   a,(ix+$17)
0B28: 3D          dec  a
0B29: DD 77 17    ld   (ix+$17),a
0B2C: FD 7E 67    ld   a,(iy+$67)
0B2F: FE 01       cp   $01
0B31: C0          ret  nz
; elevator lifts guard 2
0B32: DD 7E 1B    ld   a,(ix+$1b)
0B35: 3D          dec  a
0B36: DD 77 1B    ld   (ix+$1b),a
0B39: C9          ret
0B3A: 3E 00       ld   a,$00
0B3C: 32 10 60    ld   (elevator_dir_current_screen_6010),a
0B3F: 3C          inc  a
0B40: 32 12 60    ld   (elevator_not_moving_6012),a
0B43: C9          ret
0B44: 7E          ld   a,(hl)
0B45: FE E1       cp   $E1
0B47: 30 2E       jr   nc,$0B77
0B49: 34          inc  (hl)
0B4A: FD 7E 00    ld   a,(iy+$00)
0B4D: FE 01       cp   $01
0B4F: 20 0A       jr   nz,$0B5B
0B51: DD 7E 03    ld   a,(ix+$03)
0B54: 3C          inc  a
0B55: DD 77 03    ld   (ix+$03),a
0B58: CD 9E EB    call $EB9E
0B5B: FD 7E 27    ld   a,(iy+$27)
0B5E: FE 01       cp   $01
0B60: 20 07       jr   nz,$0B69
0B62: DD 7E 17    ld   a,(ix+$17)
0B65: 3C          inc  a
0B66: DD 77 17    ld   (ix+$17),a
0B69: FD 7E 67    ld   a,(iy+$67)
0B6C: FE 01       cp   $01
0B6E: C0          ret  nz
0B6F: DD 7E 1B    ld   a,(ix+$1b)
0B72: 3C          inc  a
0B73: DD 77 1B    ld   (ix+$1b),a
0B76: C9          ret
0B77: 3E 01       ld   a,$01
0B79: 32 10 60    ld   (elevator_dir_current_screen_6010),a
0B7C: 3E 01       ld   a,$01
0B7E: 32 12 60    ld   (elevator_not_moving_6012),a
0B81: C9          ret
0B82: FE 01       cp   $01
0B84: 28 32       jr   z,$0BB8
0B86: 7E          ld   a,(hl)
0B87: FE 00       cp   $00
0B89: 28 2D       jr   z,$0BB8
0B8B: 79          ld   a,c
0B8C: FE 00       cp   $00
0B8E: C0          ret  nz
0B8F: DD 7E 00    ld   a,(ix+$00)
0B92: E6 80       and  $80
0B94: B0          or   b
0B95: DD 77 00    ld   (ix+$00),a
0B98: DD 34 03    inc  (ix+$03)
0B9B: FD 34 00    inc  (iy+$00)
0B9E: 3A F5 61    ld   a,(unknown_61F5)
0BA1: FE 00       cp   $00
0BA3: C0          ret  nz
0BA4: 3E 0D       ld   a,$0D
0BA6: 47          ld   b,a
0BA7: 3A 98 60    ld   a,(current_guard_screen_index_6098)
0BAA: B8          cp   b
0BAB: C0          ret  nz
0BAC: 3E 01       ld   a,$01
0BAE: 32 F5 61    ld   (unknown_61F5),a
0BB1: 21 AB D9    ld   hl,$D9AB
0BB4: CD 84 EC    call play_sample_EC84
0BB7: C9          ret
0BB8: AF          xor  a
0BB9: FD 77 00    ld   (iy+$00),a
0BBC: C9          ret
cant_walk_in_current_direction_0BBD:
0BBD: F1          pop  af
0BBE: AF          xor  a
0BBF: 32 9B 60    ld   (unknown_609B),a
0BC2: FD 77 00    ld   (iy+$00),a
0BC5: C9          ret
player_movement_0BC6:
0BC6: 3A 25 60    ld   a,(player_death_flag_6025)
0BC9: FE 01       cp   $01
0BCB: C8          ret  z
0BCC: 3A 28 60    ld   a,(player_controls_frozen_6028)
0BCF: FE 01       cp   $01
0BD1: CA BE 0B    jp   z,$0BBE
0BD4: 3A D3 62    ld   a,(unknown_62D3)
0BD7: FE 00       cp   $00
0BD9: 28 06       jr   z,$0BE1
0BDB: 3D          dec  a
0BDC: 32 D3 62    ld   (unknown_62D3),a
0BDF: 18 09       jr   $0BEA
0BE1: 3A 26 60    ld   a,(player_input_6026)
0BE4: E6 10       and  $10
0BE6: FE 10       cp   $10
0BE8: 20 12       jr   nz,$0BFC
0BEA: 2A 09 60    ld   hl,(player_logical_address_6009)
0BED: CD 1C D1    call $D11C
0BF0: 28 0A       jr   z,$0BFC
0BF2: CD 71 0D    call character_can_walk_right_0D71
0BF5: 3A 0B 60    ld   a,(way_clear_flag_600B)
0BF8: FE 02       cp   $02
0BFA: 28 1C       jr   z,$0C18
0BFC: 3A 26 60    ld   a,(player_input_6026)
0BFF: E6 08       and  $08
0C01: FE 08       cp   $08
0C03: C2 BE 0B    jp   nz,$0BBE
	;; try to move left
0C06: 2A 09 60    ld   hl,(player_logical_address_6009)
0C09: CD CC 0D    call character_can_walk_left_0DCC
0C0C: 3A 0B 60    ld   a,(way_clear_flag_600B)
0C0F: FE 02       cp   $02
0C11: C2 BE 0B    jp   nz,$0BBE
0C14: 06 80       ld   b,$80
0C16: 28 02       jr   z,$0C1A
0C18: 06 00       ld   b,$00
0C1A: 3A C1 62    ld   a,(unknown_62C1)
0C1D: FE 16       cp   $16
0C1F: 30 05       jr   nc,$0C26
0C21: 3C          inc  a
0C22: 3C          inc  a
0C23: 32 C1 62    ld   (unknown_62C1),a
0C26: 3A 06 60    ld   a,(player_animation_frame_6006)
0C29: FE 0B       cp   $0B
0C2B: 20 1A       jr   nz,animate_player_1_frame_0C47
0C2D: 3E 01       ld   a,$01
0C2F: 32 06 60    ld   (player_animation_frame_6006),a
0C32: C5          push bc
0C33: CD C2 10    call $10C2
0C36: E5          push hl
0C37: DD E5       push ix
0C39: D5          push de
0C3A: 21 10 00    ld   hl,$0010
0C3D: CD 90 5C    call add_to_score_5C90
0C40: D1          pop  de
0C41: DD E1       pop  ix
0C43: E1          pop  hl
0C44: C1          pop  bc
0C45: 18 14       jr   $0C5B
animate_player_1_frame_0C47:
0C47: 3C          inc  a
0C48: F5          push af
0C49: 3A 58 61    ld   a,(has_bag_6158)
0C4C: FE 00       cp   $00
0C4E: 28 07       jr   z,$0C57
0C50: CD 50 0D    call $0D50
0C53: FE 00       cp   $00
0C55: 28 39       jr   z,$0C90  ; skip animation because player has bag
0C57: F1          pop  af
0C58: 32 06 60    ld   (player_animation_frame_6006),a
0C5B: 3A 06 60    ld   a,(player_animation_frame_6006)
0C5E: 21 80 65    ld   hl,player_struct_6580
0C61: FE 02       cp   $02
0C63: CC AD 0C    call z,player_tries_to_move_laterally_0CAD
0C66: FE 05       cp   $05
0C68: CC AD 0C    call z,player_tries_to_move_laterally_0CAD
0C6B: FE 09       cp   $09
0C6D: CC AD 0C    call z,player_tries_to_move_laterally_0CAD
0C70: FE FF       cp   $FF
0C72: C8          ret  z
0C73: FE 04       cp   $04
0C75: CC AD 0C    call z,player_tries_to_move_laterally_0CAD
0C78: FE 06       cp   $06
0C7A: CC AD 0C    call z,player_tries_to_move_laterally_0CAD
0C7D: FE 08       cp   $08
0C7F: CC AD 0C    call z,player_tries_to_move_laterally_0CAD
0C82: FE 0A       cp   $0A
0C84: CC AD 0C    call z,player_tries_to_move_laterally_0CAD
0C87: FE 01       cp   $01
0C89: 20 07       jr   nz,$0C92
0C8B: 3E 20       ld   a,$20	;  player sprite index
0C8D: B0          or   b
0C8E: 77          ld   (hl),a
0C8F: C9          ret
0C90: F1          pop  af
0C91: C9          ret
	;; player lateral move
0C92: FE 03       cp   $03
0C94: 20 05       jr   nz,$0C9B
0C96: 3E 1F       ld   a,$1F
0C98: B0          or   b
0C99: 77          ld   (hl),a
0C9A: C9          ret
0C9B: FE 07       cp   $07
0C9D: 20 05       jr   nz,$0CA4
0C9F: 3E 1E       ld   a,$1E
0CA1: B0          or   b
0CA2: 77          ld   (hl),a
0CA3: C9          ret
0CA4: FE FF       cp   $FF
0CA6: 20 04       jr   nz,$0CAC
0CA8: 3E 80       ld   a,$80
0CAA: 77          ld   (hl),a
0CAB: C9          ret
0CAC: C9          ret
player_tries_to_move_laterally_0CAD:
0CAD: F5          push af
0CAE: 78          ld   a,b
0CAF: FE 80       cp   $80
0CB1: 28 5A       jr   z,$0D0D
0CB3: 2A 09 60    ld   hl,(player_logical_address_6009)
0CB6: CD 71 0D    call character_can_walk_right_0D71
0CB9: 3A 0B 60    ld   a,(way_clear_flag_600B)
0CBC: FE 02       cp   $02
0CBE: C2 BD 0B    jp   nz,cant_walk_in_current_direction_0BBD
0CC1: 3A 82 65    ld   a,(player_x_6582)
0CC4: 3C          inc  a
0CC5: 32 82 65    ld   (player_x_6582),a
0CC8: 3A F3 61    ld   a,(unknown_61F3)
0CCB: FE 00       cp   $00
0CCD: 20 1A       jr   nz,$0CE9
0CCF: CD F3 0C    call $0CF3
0CD2: 3A F3 61    ld   a,(unknown_61F3)
0CD5: FE 00       cp   $00
0CD7: 20 10       jr   nz,$0CE9
0CD9: CD 00 0D    call $0D00
0CDC: 3A F3 61    ld   a,(unknown_61F3)
0CDF: FE 00       cp   $00
0CE1: 20 06       jr   nz,$0CE9
0CE3: 21 99 D9    ld   hl,$D999
0CE6: CD 84 EC    call play_sample_EC84
0CE9: 3E 01       ld   a,$01
0CEB: FD 77 00    ld   (iy+$00),a
0CEE: 32 9B 60    ld   (unknown_609B),a
0CF1: F1          pop  af
0CF2: C9          ret
0CF3: 3A CF 61    ld   a,(has_pick_61CF)
0CF6: FE 00       cp   $00
0CF8: C8          ret  z
0CF9: 21 93 D9    ld   hl,$D993
0CFC: CD 84 EC    call play_sample_EC84
0CFF: C9          ret
0D00: 3A C7 61    ld   a,(holds_barrow_61C7)
0D03: FE 00       cp   $00
0D05: C9          ret
0D06: 21 A5 D9    ld   hl,$D9A5
0D09: CD 84 EC    call play_sample_EC84
0D0C: C9          ret
0D0D: 2A 09 60    ld   hl,(player_logical_address_6009)
0D10: CD CC 0D    call character_can_walk_left_0DCC
0D13: 3A 0B 60    ld   a,(way_clear_flag_600B)
0D16: FE 02       cp   $02
0D18: C2 BD 0B    jp   nz,cant_walk_in_current_direction_0BBD
0D1B: 3A 82 65    ld   a,(player_x_6582)
0D1E: 3D          dec  a
0D1F: 32 82 65    ld   (player_x_6582),a
0D22: CD 55 EA    call handle_player_destroying_wall_EA55
0D25: 3A F3 61    ld   a,(unknown_61F3)
0D28: FE 00       cp   $00
0D2A: 20 1A       jr   nz,$0D46
0D2C: CD F3 0C    call $0CF3
0D2F: 3A F3 61    ld   a,(unknown_61F3)
0D32: FE 00       cp   $00
0D34: 20 10       jr   nz,$0D46
0D36: CD 00 0D    call $0D00
0D39: 3A F3 61    ld   a,(unknown_61F3)
0D3C: FE 00       cp   $00
0D3E: 20 06       jr   nz,$0D46
0D40: 21 99 D9    ld   hl,$D999
0D43: CD 84 EC    call play_sample_EC84
0D46: 3E 01       ld   a,$01
0D48: FD 77 00    ld   (iy+$00),a
0D4B: 32 9B 60    ld   (unknown_609B),a
0D4E: F1          pop  af
0D4F: C9          ret
0D50: C5          push bc
0D51: 06 02       ld   b,$02
0D53: 3A 7C 62    ld   a,(player_has_blue_bag_flag_627C)
0D56: FE 00       cp   $00
0D58: 28 02       jr   z,$0D5C
0D5A: 06 01       ld   b,$01
0D5C: 3A 5F 61    ld   a,(unknown_615F)
0D5F: B8          cp   b
0D60: C1          pop  bc
0D61: 38 07       jr   c,$0D6A
0D63: AF          xor  a
0D64: 32 5F 61    ld   (unknown_615F),a
0D67: 3E 00       ld   a,$00
0D69: C9          ret
0D6A: 3C          inc  a
0D6B: 32 5F 61    ld   (unknown_615F),a
0D6E: 3E 01       ld   a,$01
0D70: C9          ret

character_can_walk_right_0D71:
0D71: 3A ED 61    ld   a,(check_scenery_disabled_61ED)
0D74: FE 01       cp   $01
0D76: 20 06       jr   nz,$0D7E
0D78: 3E 02       ld   a,$02
0D7A: 32 0B 60    ld   (way_clear_flag_600B),a
0D7D: C9          ret
0D7E: 3A F2 61    ld   a,(player_controls_blocked_61F2)
0D81: FE 01       cp   $01
0D83: 28 F3       jr   z,$0D78
0D85: CD C0 C0    call check_breakable_wall_C0C0
0D88: 3A 0B 60    ld   a,(way_clear_flag_600B)
0D8B: FE 02       cp   $02
0D8D: C8          ret  z
0D8E: 7D          ld   a,l
0D8F: D6 21       sub  $21
0D91: 6F          ld   l,a
0D92: 7C          ld   a,h
0D93: DE 00       sbc  a,$00
0D95: 67          ld   h,a
0D96: 7E          ld   a,(hl)
0D97: CD 05 0E    call check_against_space_tiles_0E05
0D9A: 3A 0B 60    ld   a,(way_clear_flag_600B)
0D9D: FE 02       cp   $02
0D9F: C0          ret  nz
0DA0: 2B          dec  hl
0DA1: 7E          ld   a,(hl)
0DA2: CD 05 0E    call check_against_space_tiles_0E05
0DA5: 23          inc  hl
0DA6: 23          inc  hl
0DA7: CD AB 0D    call check_edge_tiles_0DAB
0DAA: C9          ret
check_edge_tiles_0DAB:
0DAB: 7E          ld   a,(hl)
0DAC: FE FB       cp   $FB
0DAE: 28 05       jr   z,$0DB5
0DB0: FE FA       cp   $FA
0DB2: 28 01       jr   z,$0DB5
0DB4: C9          ret
0DB5: DD E5       push ix
0DB7: CD 6D C1    call $C16D
0DBA: DD E1       pop  ix
0DBC: 78          ld   a,b
0DBD: FE 05       cp   $05
0DBF: D8          ret  c
0DC0: 3E 01       ld   a,$01
0DC2: 32 0B 60    ld   (way_clear_flag_600B),a
0DC5: C9          ret
0DC6: 3E 01       ld   a,$01
0DC8: 32 0B 60    ld   (way_clear_flag_600B),a
0DCB: C9          ret

character_can_walk_left_0DCC:
0DCC: 3A ED 61    ld   a,(check_scenery_disabled_61ED)
0DCF: FE 01       cp   $01
0DD1: 20 06       jr   nz,$0DD9
0DD3: 3E 02       ld   a,$02
0DD5: 32 0B 60    ld   (way_clear_flag_600B),a
0DD8: C9          ret
0DD9: CD A4 C0    call $C0A4
0DDC: 3A 0B 60    ld   a,(way_clear_flag_600B)
0DDF: FE 02       cp   $02
0DE1: C8          ret  z
0DE2: 7D          ld   a,l
0DE3: C6 1F       add  a,$1F
0DE5: 6F          ld   l,a
0DE6: 7C          ld   a,h
0DE7: CE 00       adc  a,$00
0DE9: 67          ld   h,a
0DEA: 7E          ld   a,(hl)
0DEB: CD 05 0E    call check_against_space_tiles_0E05
0DEE: 3A 0B 60    ld   a,(way_clear_flag_600B)
0DF1: FE 02       cp   $02
0DF3: C0          ret  nz
0DF4: 2B          dec  hl
0DF5: 7E          ld   a,(hl)
0DF6: CD 05 0E    call check_against_space_tiles_0E05
0DF9: 23          inc  hl
0DFA: 23          inc  hl
0DFB: CD AB 0D    call check_edge_tiles_0DAB
0DFE: C9          ret
0DFF: 3E 02       ld   a,$02
0E01: 32 0B 60    ld   (way_clear_flag_600B),a
0E04: C9          ret

check_against_space_tiles_0E05:
0E05: 4F          ld   c,a
0E06: 11 A7 1B    ld   de,$1BA7
0E09: 06 24       ld   b,$24
0E0B: 1A          ld   a,(de)
0E0C: B9          cp   c
0E0D: 28 F0       jr   z,$0DFF
0E0F: 13          inc  de
0E10: 10 F9       djnz $0E0B
0E12: 18 B2       jr   $0DC6
0E14: 3A 9B 60    ld   a,(unknown_609B)
0E17: FE 01       cp   $01
0E19: C8          ret  z
0E1A: 3A 26 60    ld   a,(player_input_6026)
0E1D: E6 20       and  $20
0E1F: FE 20       cp   $20
0E21: 28 13       jr   z,$0E36
0E23: 3A 26 60    ld   a,(player_input_6026)
0E26: E6 40       and  $40
0E28: FE 40       cp   $40
0E2A: C0          ret  nz
can_player_climb_down_0E2B:
0E2B: 2A 09 60    ld   hl,(player_logical_address_6009)
0E2E: 7E          ld   a,(hl)
0E2F: FE FF       cp   $FF
0E31: C0          ret  nz
0E32: 06 00       ld   b,$00
0E34: 18 0A       jr   $0E40
can_player_climb_up_0E36:
0E36: 2A 09 60    ld   hl,(player_logical_address_6009)
0E39: 2B          dec  hl
0E3A: 7E          ld   a,(hl)
	; ladder tile on the left is 0xFF, way simpler than testing walk
0E3B: FE FF       cp   $FF
0E3D: C0          ret  nz
0E3E: 06 80       ld   b,$80
0E40: 3A 07 60    ld   a,(player_climb_frame_counter_6007)
0E43: FE 0B       cp   $0B
0E45: 20 07       jr   nz,$0E4E
0E47: 3E 01       ld   a,$01
0E49: 32 07 60    ld   (player_climb_frame_counter_6007),a
0E4C: 18 15       jr   $0E63
0E4E: 3C          inc  a
0E4F: F5          push af
0E50: 3A 58 61    ld   a,(has_bag_6158)
0E53: FE 00       cp   $00
0E55: 28 08       jr   z,$0E5F
0E57: CD 50 0D    call $0D50	; drop 1 move out of 2 if blue bag, 1 out of 3 if yellow bag
0E5A: FE 00       cp   $00
0E5C: CA 90 0C    jp   z,$0C90
0E5F: F1          pop  af
0E60: 32 07 60    ld   (player_climb_frame_counter_6007),a
0E63: 3A 07 60    ld   a,(player_climb_frame_counter_6007)
	;; vertical player movement
0E66: FE 01       cp   $01
0E68: C8          ret  z
0E69: FE 03       cp   $03
0E6B: CC DF 0E    call z,$0EDF
0E6E: FE 05       cp   $05
0E70: C8          ret  z
0E71: FE 08       cp   $08
0E73: CC DF 0E    call z,$0EDF
0E76: FE 0A       cp   $0A
0E78: C8          ret  z
0E79: FE 02       cp   $02
0E7B: CC DF 0E    call z,$0EDF
0E7E: FE 04       cp   $04
0E80: CC DF 0E    call z,$0EDF
0E83: FE 07       cp   $07
0E85: CC DF 0E    call z,$0EDF
0E88: FE 09       cp   $09
0E8A: CC DF 0E    call z,$0EDF
0E8D: FE 06       cp   $06
0E8F: 20 0C       jr   nz,$0E9D
0E91: 3E 12       ld   a,$12
0E93: 32 80 65    ld   (player_struct_6580),a
0E96: CD DF 0E    call $0EDF
0E99: CD AD 0E    call $0EAD
0E9C: C9          ret
0E9D: FE 0B       cp   $0B
0E9F: 20 0B       jr   nz,$0EAC
0EA1: 3E 92       ld   a,$92
0EA3: 32 80 65    ld   (player_struct_6580),a
0EA6: CD DF 0E    call $0EDF
0EA9: CD AD 0E    call $0EAD
0EAC: C9          ret
0EAD: 3A F3 61    ld   a,(unknown_61F3)
0EB0: FE 00       cp   $00
0EB2: 20 06       jr   nz,$0EBA
0EB4: 21 8D D9    ld   hl,$D98D
0EB7: CD 84 EC    call play_sample_EC84
0EBA: 3A 58 61    ld   a,(has_bag_6158)
0EBD: FE 00       cp   $00
0EBF: C8          ret  z
0EC0: 3A 41 63    ld   a,(unknown_6341)
0EC3: FE 01       cp   $01
0EC5: 28 0C       jr   z,$0ED3
0EC7: 3E 3F       ld   a,$3F
0EC9: 32 9C 65    ld   (object_held_struct_659C),a
0ECC: 3A 82 65    ld   a,(player_x_6582)
0ECF: 32 9E 65    ld   (sprite_object_x_659E),a
0ED2: C9          ret
0ED3: 3E 31       ld   a,$31
0ED5: 32 9C 65    ld   (object_held_struct_659C),a
0ED8: 3A 82 65    ld   a,(player_x_6582)
0EDB: 32 9E 65    ld   (sprite_object_x_659E),a
0EDE: C9          ret
0EDF: F5          push af
0EE0: AF          xor  a
0EE1: 32 1C 60    ld   (player_in_wagon_1_601C),a
0EE4: 32 1D 60    ld   (player_in_wagon_2_601D),a
0EE7: 32 1E 60    ld   (player_in_wagon_3_601E),a
0EEA: 78          ld   a,b
0EEB: FE 80       cp   $80
0EED: 20 13       jr   nz,$0F02
0EEF: 3A 83 65    ld   a,(player_y_6583)
0EF2: 3D          dec  a
0EF3: 32 83 65    ld   (player_y_6583),a
0EF6: DD 21 80 65 ld   ix,player_struct_6580
0EFA: CD C9 0F    call align_character_x_0fc9
0EFD: CD AD 0E    call $0EAD
0F00: F1          pop  af
0F01: C9          ret
0F02: 3A 83 65    ld   a,(player_y_6583)
0F05: 3C          inc  a
0F06: 32 83 65    ld   (player_y_6583),a
0F09: DD 21 80 65 ld   ix,player_struct_6580
0F0D: CD C9 0F    call align_character_x_0fc9
0F10: CD AD 0E    call $0EAD
0F13: F1          pop  af
0F14: C9          ret
start_a_game_0F15:
0F15: 3A 0F 91    ld   a,($910F)
0F18: FE 1E       cp   $1E
0F1A: 28 06       jr   z,$0F22
0F1C: 3A 2F 91    ld   a,($912F)
0F1F: FE 1E       cp   $1E
0F21: C0          ret  nz
0F22: 3A 00 60    ld   a,(number_of_credits_6000)
0F25: FE 00       cp   $00
0F27: C8          ret  z
0F28: 3A 54 60    ld   a,(gameplay_allowed_6054)
0F2B: FE 01       cp   $01
0F2D: C8          ret  z
0F2E: 3A 26 60    ld   a,(player_input_6026)
0F31: E6 04       and  $04
0F33: FE 04       cp   $04
0F35: 28 1D       jr   z,$0F54
0F37: 3A 00 60    ld   a,(number_of_credits_6000)
0F3A: FE 02       cp   $02
0F3C: D8          ret  c
0F3D: 3A 51 60    ld   a,(coin_start_inputs_6051)
0F40: E6 04       and  $04
0F42: FE 04       cp   $04
0F44: C0          ret  nz
0F45: 3A 00 60    ld   a,(number_of_credits_6000)
0F48: 3D          dec  a
0F49: 27          daa
0F4A: 32 00 60    ld   (number_of_credits_6000),a
0F4D: 3E 02       ld   a,$02
0F4F: 32 7D 61    ld   (unknown_617D),a
0F52: 18 05       jr   $0F59
0F54: 3E 01       ld   a,$01
0F56: 32 7D 61    ld   (unknown_617D),a
0F59: AF          xor  a
0F5A: 32 7C 61    ld   (current_player_617C),a
0F5D: 3A 00 60    ld   a,(number_of_credits_6000)
0F60: 3D          dec  a
0F61: 27          daa
0F62: 32 00 60    ld   (number_of_credits_6000),a
0F65: 3E 0A       ld   a,$0A
0F67: 32 7D 62    ld   (unknown_627D),a
0F6A: 32 90 62    ld   (unknown_6290),a
0F6D: CD 17 D0    call $D017
0F70: 3E 01       ld   a,$01
0F72: 32 10 62    ld   (must_play_music_6210),a
0F75: CD 51 F9    call init_new_game_F951
0F78: CD 14 C3    call init_guard_directions_and_wagons_C314
;; put one guard on screen 1
0F7B: 3E 01       ld   a,$01
0F7D: 32 9A 60    ld   (guard_2_screen_609A),a
0F80: AF          xor  a
0F81: 32 53 60    ld   (game_locked_6053),a
0F84: 32 55 60    ld   (unknown_6055),a
0F87: 3C          inc  a
0F88: 32 54 60    ld   (gameplay_allowed_6054),a
0F8B: AF          xor  a
0F8C: 21 76 61    ld   hl,player_1_score_6176
0F8F: 06 06       ld   b,$06
0F91: 77          ld   (hl),a
0F92: 23          inc  hl
0F93: 10 FC       djnz $0F91
0F95: 3A 63 61    ld   a,(flipped_dip_switches_copy_6163)
0F98: E6 03       and  $03
0F9A: C6 01       add  a,$01
0F9C: 32 56 60    ld   (lives_6056),a
0F9F: 3C          inc  a
0FA0: 32 7E 61    ld   (unknown_617E),a
0FA3: 21 C3 91    ld   hl,$91C3
0FA6: 22 C4 61    ld   (barrow_screen_params_61C4),hl
0FA9: 22 FA 61    ld   (unknown_screen_address_61FA),hl
0FAC: 3E 01       ld   a,$01
0FAE: 32 C6 61    ld   (barrow_screen_61C6),a
0FB1: 32 FC 61    ld   (unknown_61FC),a
0FB4: CD C9 D7    call $D7C9
0FB7: CD DB CF    call set_bags_coordinates_easy_level_CFDB
0FBA: CD E7 CF    call set_bags_coordinates_CFE7
0FBD: AF          xor  a
0FBE: 32 53 63    ld   (unknown_6353),a
0FC1: CD F7 D0    call $D0F7
0FC4: AF          xor  a
0FC5: 32 48 63    ld   (unknown_6348),a
0FC8: C9          ret

align_character_x_0fc9:
0FC9: DD 7E 02    ld   a,(ix+$02)
0FCC: D6 01       sub  $01
0FCE: E6 F8       and  $F8
0FD0: C6 04       add  a,$04
0FD2: DD 77 02    ld   (ix+$02),a
0FD5: C9          ret

0FD6: E1          pop  hl
0FD7: 3A 51 61    ld   a,(game_locked_6151)
0FDA: FE 01       cp   $01
0FDC: 28 04       jr   z,$0FE2
0FDE: AF          xor  a
0FDF: 32 48 63    ld   (unknown_6348),a
0FE2: 3E 38       ld   a,$38
0FE4: 32 4D 63    ld   (unknown_634D),a
0FE7: C9          ret
0FE8: 3A 4D 63    ld   a,(unknown_634D)
0FEB: FE 38       cp   $38
0FED: 28 05       jr   z,handle_ay_sound_0ff4
0FEF: 2A 4E 63    ld   hl,(unknown_634E)
0FF2: 18 03       jr   $0FF7

handle_ay_sound_0ff4:
0FF4: 2A 40 61    ld   hl,(ay_sound_pointer_6140)
0FF7: 11 03 00    ld   de,$0003
0FFA: E5          push hl
0FFB: 19          add  hl,de
0FFC: 7E          ld   a,(hl)
0FFD: FE FF       cp   $FF
0FFF: 28 D5       jr   z,$0FD6
1001: 7E          ld   a,(hl)
1002: E1          pop  hl
1003: 47          ld   b,a
1004: 3A 42 61    ld   a,(ay_sound_start_6142)
1007: B8          cp   b
1008: C0          ret  nz
1009: AF          xor  a
100A: 32 42 61    ld   (ay_sound_start_6142),a
100D: 11 B5 23    ld   de,$23B5
1010: 3A 48 63    ld   a,(unknown_6348)
1013: FE 00       cp   $00
1015: 28 14       jr   z,$102B
1017: 11 BF 23    ld   de,$23BF
101A: 3A 48 63    ld   a,(unknown_6348)
101D: FE 01       cp   $01
101F: 28 0A       jr   z,$102B
1021: 11 C9 23    ld   de,$23C9
1024: FE 02       cp   $02
1026: 28 03       jr   z,$102B
1028: 11 D3 23    ld   de,$23D3
102B: CD 58 10    call $1058
102E: 3E 0F       ld   a,$0F
1030: D3 08       out  ($08),a
1032: 3E 01       ld   a,$01
1034: 32 07 A0    ld   ($A007),a
1037: 2A 40 61    ld   hl,(ay_sound_pointer_6140)
103A: 11 03 00    ld   de,$0003
103D: 19          add  hl,de
103E: 7E          ld   a,(hl)
103F: FE FF       cp   $FF
1041: 28 0A       jr   z,$104D
1043: 2A 40 61    ld   hl,(ay_sound_pointer_6140)
1046: 11 04 00    ld   de,$0004
1049: 19          add  hl,de
104A: 22 40 61    ld   (ay_sound_pointer_6140),hl
104D: 2A 4E 63    ld   hl,(unknown_634E)
1050: 11 04 00    ld   de,$0004
1053: 19          add  hl,de
1054: 22 4E 63    ld   (unknown_634E),hl
1057: C9          ret
1058: 7E          ld   a,(hl)
1059: FE FE       cp   $FE
105B: C8          ret  z
105C: AF          xor  a
105D: 32 07 A0    ld   ($A007),a
1060: 3E 07       ld   a,$07
1062: D3 08       out  ($08),a
1064: C5          push bc
1065: 06 38       ld   b,$38
1067: 3A 48 63    ld   a,(unknown_6348)
106A: FE 02       cp   $02
106C: 38 08       jr   c,$1076
106E: 06 01       ld   b,$01
1070: FE 02       cp   $02
1072: 28 02       jr   z,$1076
1074: 06 07       ld   b,$07
1076: 78          ld   a,b
1077: C1          pop  bc
1078: D3 09       out  ($09),a
107A: 0E 00       ld   c,$00
107C: D5          push de
107D: CD 88 10    call $1088
1080: D1          pop  de
1081: EB          ex   de,hl
1082: 0E 08       ld   c,$08
1084: CD B5 10    call $10B5
1087: C9          ret
1088: 06 03       ld   b,$03
108A: 79          ld   a,c
108B: D3 08       out  ($08),a
108D: 7E          ld   a,(hl)
108E: CD 9F 10    call $109F
1091: 23          inc  hl
1092: 0C          inc  c
1093: 10 F5       djnz $108A
1095: 3E 06       ld   a,$06
1097: D3 08       out  ($08),a
1099: 3A 4C 63    ld   a,(unknown_634C)
109C: D3 09       out  ($09),a
109E: C9          ret
109F: E5          push hl
10A0: 87          add  a,a
10A1: 26 00       ld   h,$00
10A3: 6F          ld   l,a
10A4: 11 F5 D8    ld   de,$D8F5
10A7: 19          add  hl,de
10A8: 7E          ld   a,(hl)
10A9: D3 09       out  ($09),a
10AB: 0C          inc  c
10AC: 79          ld   a,c
10AD: D3 08       out  ($08),a
10AF: 23          inc  hl
10B0: 7E          ld   a,(hl)
10B1: D3 09       out  ($09),a
10B3: E1          pop  hl
10B4: C9          ret

10B5: 06 06       ld   b,$06
10B7: 79          ld   a,c
10B8: D3 08       out  ($08),a
10BA: 0C          inc  c
10BB: 7E          ld   a,(hl)
10BC: D3 09       out  ($09),a
10BE: 23          inc  hl
10BF: 10 F6       djnz $10B7
10C1: C9          ret

10C2: 3A 43 61    ld   a,(unknown_6143)
10C5: C9          ret

handle_player_object_carry_10C6:
10C6: 3A 58 61    ld   a,(has_bag_6158)
10C9: FE 00       cp   $00
10CB: C8          ret  z
10CC: 3A 41 63    ld   a,(unknown_6341)
10CF: FE 01       cp   $01
10D1: 20 04       jr   nz,$10D7
10D3: CD 37 EC    call $EC37
10D6: C9          ret
10D7: 3A 83 65    ld   a,(player_y_6583)
10DA: D6 02       sub  $02
10DC: 32 9F 65    ld   (sprite_object_y_659F),a
10DF: 3A 80 65    ld   a,(player_struct_6580)
10E2: E6 7F       and  $7F
10E4: FE 12       cp   $12
10E6: C8          ret  z
10E7: 3A 80 65    ld   a,(player_struct_6580)
10EA: E6 80       and  $80
10EC: FE 80       cp   $80
10EE: 20 0E       jr   nz,$10FE
10F0: 3A 82 65    ld   a,(player_x_6582)
10F3: C6 08       add  a,$08
10F5: 32 9E 65    ld   (sprite_object_x_659E),a
10F8: 3E BF       ld   a,$BF
10FA: 32 9C 65    ld   (object_held_struct_659C),a
10FD: C9          ret
10FE: 3A 82 65    ld   a,(player_x_6582)
1101: D6 08       sub  $08
1103: 32 9E 65    ld   (sprite_object_x_659E),a
1106: 3E 3F       ld   a,$3F
1108: 32 9C 65    ld   (object_held_struct_659C),a
110B: C9          ret
110C: 3A CF 61    ld   a,(has_pick_61CF)
110F: FE 00       cp   $00
1111: C8          ret  z
1112: 3A 80 65    ld   a,(player_struct_6580)
1115: E6 7F       and  $7F
1117: FE 1F       cp   $1F
1119: 06 37       ld   b,$37
111B: 28 0D       jr   z,$112A
111D: 3A 80 65    ld   a,(player_struct_6580)
1120: E6 7F       and  $7F
1122: FE 12       cp   $12
1124: 06 37       ld   b,$37
1126: 28 02       jr   z,$112A
1128: 06 38       ld   b,$38
112A: 3A 83 65    ld   a,(player_y_6583)
112D: 32 9F 65    ld   (sprite_object_y_659F),a
1130: 3A 80 65    ld   a,(player_struct_6580)
1133: E6 7F       and  $7F
1135: FE 12       cp   $12
1137: 28 16       jr   z,$114F
1139: 3A 80 65    ld   a,(player_struct_6580)
113C: E6 80       and  $80
113E: FE 80       cp   $80
1140: 28 0D       jr   z,$114F
1142: 3A 82 65    ld   a,(player_x_6582)
1145: C6 0C       add  a,$0C
1147: 32 9E 65    ld   (sprite_object_x_659E),a
114A: 78          ld   a,b
114B: 32 9C 65    ld   (object_held_struct_659C),a
114E: C9          ret
114F: 3A 82 65    ld   a,(player_x_6582)
1152: D6 0C       sub  $0C
1154: 32 9E 65    ld   (sprite_object_x_659E),a
1157: 78          ld   a,b
1158: F6 80       or   $80
115A: 32 9C 65    ld   (object_held_struct_659C),a
115D: C9          ret

handle_player_object_pickup_115E:
115E: 3A 54 60    ld   a,(gameplay_allowed_6054)
1161: FE 01       cp   $01
1163: 28 0A       jr   z,$116F
1165: 3A 50 60    ld   a,(player_previous_input_6050)
1168: E6 80       and  $80
116A: FE 80       cp   $80
116C: 28 12       jr   z,$1180
116E: C9          ret

object_pickup_test_116F:
116F: 3A 26 60    ld   a,(player_input_6026)
1172: E6 80       and  $80
1174: FE 80       cp   $80
1176: 20 0E       jr   nz,$1186
;;; fire pressed
1178: 3A 50 60    ld   a,(player_previous_input_6050)
117B: E6 80       and  $80
117D: FE 80       cp   $80	; just leaving the wagon handle
117F: C8          ret  z	;  don't pick up anything!
	;;  actual pickup of an object
1180: 3E 01       ld   a,$01
1182: 32 60 61    ld   (pickup_flag_6160),a
1185: C9          ret
1186: 3E 00       ld   a,$00
1188: 32 60 61    ld   (pickup_flag_6160),a
118B: C9          ret

set_previous_guard_y_255_118C:
118C: 3E FF       ld   a,$FF
118E: FD 77 03    ld   (iy+$03),a
1191: C9          ret

speech_management_1192:
1192: 3A 10 62    ld   a,(must_play_music_6210)
1195: FE 01       cp   $01
1197: C0          ret  nz
1198: 3A ED 61    ld   a,(check_scenery_disabled_61ED)
119B: FE 01       cp   $01
119D: C8          ret  z
119E: 3A C0 61    ld   a,(unknown_61C0)
11A1: FE 01       cp   $01
11A3: 28 15       jr   z,$11BA
11A5: 21 BD 61    ld   hl,unknown_61BD
11A8: 11 00 A8    ld   de,$A800
11AB: 01 06 00    ld   bc,$0006
11AE: ED B0       ldir
11B0: AF          xor  a
11B1: 32 03 A8    ld   ($A803),a
11B4: 3E 01       ld   a,$01
11B6: 32 C0 61    ld   (unknown_61C0),a
11B9: C9          ret
11BA: 3E 01       ld   a,$01
11BC: 32 03 A8    ld   ($A803),a
11BF: C9          ret
guard_1_walk_movement_11C0:
11C0: 3A 99 60    ld   a,(guard_1_screen_6099)
11C3: 32 98 60    ld   (current_guard_screen_index_6098),a
11C6: 2A 38 60    ld   hl,(guard_1_logical_address_6038)
11C9: 22 44 60    ld   (stored_logical_address_6044),hl
11CC: FD 21 57 60 ld   iy,guard_1_not_moving_timeout_counter_6057
11D0: FD 22 93 60 ld   (guard_struct_pointer_6093),iy
11D4: DD 2A B7 05 ld   ix,($05B7)
11D8: 21 34 60    ld   hl,unknown_6034
11DB: FD 21 27 60 ld   iy,guard_1_direction_6027
11DF: CD 7E 06    call guard_walk_movement_067E
11E2: 3A 00 B8    ld   a,(io_read_shit_B800)    ; kick watchdog
11E5: 3A 98 60    ld   a,(current_guard_screen_index_6098)
11E8: 32 99 60    ld   (guard_1_screen_6099),a
11EB: C9          ret
guard_2_walk_movement_11EC:
11EC: 3A 9A 60    ld   a,(guard_2_screen_609A)
11EF: 32 98 60    ld   (current_guard_screen_index_6098),a
11F2: 2A 78 60    ld   hl,(guard_2_logical_address_6078)
11F5: 22 44 60    ld   (stored_logical_address_6044),hl
11F8: FD 21 97 60 ld   iy,guard_2_not_moving_timeout_counter_6097
11FC: FD 22 93 60 ld   (guard_struct_pointer_6093),iy
1200: DD 2A B9 05 ld   ix,($05B9)
1204: 21 74 60    ld   hl,unknown_6074
1207: FD 21 67 60 ld   iy,guard_2_direction_6067
120B: CD 7E 06    call guard_walk_movement_067E
120E: 3A 00 B8    ld   a,(io_read_shit_B800)
1211: 3A 98 60    ld   a,(current_guard_screen_index_6098)
1214: 32 9A 60    ld   (guard_2_screen_609A),a
1217: C9          ret

play_intro_1218:
1218: F3          di
1219: 3E 00       ld   a,$00
121B: 32 03 A0    ld   ($A003),a
121E: CD B7 C3    call clear_screen_C3B7
1221: 3E 3F       ld   a,$3F
1223: CD A3 C3    call change_attribute_everywhere_C3A3
1226: CD A4 F8    call display_player_ids_and_credit_F8A4
1229: 3E 01       ld   a,$01
122B: 32 0D 60    ld   (player_screen_600D),a
122E: 32 03 A0    ld   ($A003),a
1231: 32 98 60    ld   (current_guard_screen_index_6098),a
1234: 32 99 60    ld   (guard_1_screen_6099),a
1237: 32 9A 60    ld   (guard_2_screen_609A),a
123A: AF          xor  a
123B: 32 08 60    ld   (unknown_6008),a
123E: 32 37 60    ld   (guard_1_in_elevator_6037),a
1241: 32 4E 60    ld   (fatal_fall_height_reached_604E),a
1244: 32 77 60    ld   (guard_2_in_elevator_6077),a
1247: 32 87 65    ld   (elevator_y_current_screen_6587),a
124A: 32 9A 65    ld   (guard_2_x_659A),a
124D: 32 9B 65    ld   (guard_2_y_659B),a
1250: 32 59 61    ld   (bag_falling_6159),a
1253: 32 CF 61    ld   (has_pick_61CF),a
1256: 32 E0 61    ld   (pickaxe_timer_duration_61E0),a
1259: 32 E1 61    ld   (unknown_61E1),a
125C: 3E 01       ld   a,$01
125E: 32 ED 61    ld   (check_scenery_disabled_61ED),a
1261: CD EE C5    call compute_guard_speed_from_dipsw_C5EE
1264: 21 1D 90    ld   hl,$901D
1267: 11 20 00    ld   de,$0020
126A: 3E F0       ld   a,$F0
126C: 06 20       ld   b,$20
126E: 77          ld   (hl),a
126F: E5          push hl
1270: F5          push af
1271: 7C          ld   a,h
1272: C6 08       add  a,$08
1274: 67          ld   h,a
1275: 3E 04       ld   a,$04
1277: 77          ld   (hl),a
1278: F1          pop  af
1279: E1          pop  hl
127A: 19          add  hl,de
127B: 10 F1       djnz $126E
127D: 21 00 00    ld   hl,$0000
1280: 22 F6 61    ld   (picked_up_object_screen_address_61F6),hl
1283: CD 42 15    call $1542
1286: 3E 01       ld   a,$01
1288: 32 54 60    ld   (gameplay_allowed_6054),a
128B: 11 80 65    ld   de,player_struct_6580
128E: 21 59 15    ld   hl,$1559
1291: 01 04 00    ld   bc,$0004
1294: ED B0       ldir
1296: 11 94 65    ld   de,guard_1_struct_6594
1299: 21 61 15    ld   hl,$1561
129C: 01 04 00    ld   bc,$0004
129F: ED B0       ldir
12A1: 3A 74 62    ld   a,(is_intermission_6274)
12A4: FE 01       cp   $01
12A6: C8          ret  z
12A7: 11 00 4C    ld   de,$4C00
12AA: 21 A5 91    ld   hl,$91A5
12AD: 3E 16       ld   a,$16
12AF: 08          ex   af,af'
12B0: CD F0 55    call $55F0
12B3: 11 0B 4C    ld   de,$4C0B
12B6: 21 A6 91    ld   hl,$91A6
12B9: 3E 16       ld   a,$16
12BB: 08          ex   af,af'
12BC: CD F0 55    call $55F0
12BF: 11 16 4C    ld   de,$4C16
12C2: 21 A7 91    ld   hl,$91A7
12C5: 3E 16       ld   a,$16
12C7: 08          ex   af,af'
12C8: CD F0 55    call $55F0
12CB: 11 21 4C    ld   de,$4C21
12CE: 21 AA 91    ld   hl,$91AA
12D1: 3E 13       ld   a,$13
12D3: 08          ex   af,af'
12D4: CD F0 55    call $55F0
12D7: 3A 00 B0    ld   a,($B000)
12DA: E6 20       and  $20
12DC: FE 20       cp   $20
12DE: 20 0A       jr   nz,$12EA
12E0: 3E E1       ld   a,$E1
12E2: 32 CA 90    ld   ($90CA),a
12E5: 3E 13       ld   a,$13
12E7: 32 CA 98    ld   ($98CA),a
12EA: 21 6B 93    ld   hl,$936B
12ED: 0E 1A       ld   c,$1A
12EF: CD DD 23    call $23DD
12F2: FB          ei
12F3: ED 56       im   1
12F5: FF          rst  $38
12F6: 06 02       ld   b,$02
12F8: 11 00 40    ld   de,$4000
12FB: CD 42 15    call $1542
12FE: 1B          dec  de
12FF: 7A          ld   a,d
1300: FE 00       cp   $00
1302: 20 F7       jr   nz,$12FB
1304: 3A 00 B0    ld   a,($B000)
1307: E6 40       and  $40
1309: FE 40       cp   $40
130B: 20 11       jr   nz,$131E
130D: E5          push hl
130E: 21 00 38    ld   hl,$3800
1311: 22 40 61    ld   (ay_sound_pointer_6140),hl
1314: AF          xor  a
1315: 32 42 61    ld   (ay_sound_start_6142),a
1318: 3E 01       ld   a,$01
131A: 32 4A 63    ld   (unknown_634A),a
131D: E1          pop  hl
131E: 10 D8       djnz $12F8
1320: 06 05       ld   b,$05
1322: DD 21 5B 92 ld   ix,$925B
1326: DD 36 00 18 ld   (ix+$00),$18
132A: DD 36 01 17 ld   (ix+$01),$17
132E: DD 36 20 19 ld   (ix+$20),$19
1332: DD 36 21 16 ld   (ix+$21),$16
1336: DD 36 40 1A ld   (ix+$40),$1A
133A: DD 36 41 15 ld   (ix+$41),$15
133E: 11 00 06    ld   de,$0600
1341: CD 42 15    call $1542
1344: 1B          dec  de
1345: 7A          ld   a,d
1346: FE 00       cp   $00
1348: 20 F7       jr   nz,$1341
134A: DD 36 00 B7 ld   (ix+$00),$B7
134E: DD 36 01 1C ld   (ix+$01),$1C
1352: DD 36 20 B6 ld   (ix+$20),$B6
1356: DD 36 21 1B ld   (ix+$21),$1B
135A: DD 36 40 B2 ld   (ix+$40),$B2
135E: DD 36 41 B5 ld   (ix+$41),$B5
1362: 11 00 06    ld   de,$0600
1365: CD 42 15    call $1542
1368: 1B          dec  de
1369: 7A          ld   a,d
136A: FE 00       cp   $00
136C: 20 F7       jr   nz,$1365
136E: 10 B2       djnz $1322
1370: 11 00 40    ld   de,$4000
1373: CD 42 15    call $1542
1376: 1B          dec  de
1377: 7A          ld   a,d
1378: FE 00       cp   $00
137A: 20 F7       jr   nz,$1373
137C: DD 21 6E 92 ld   ix,$926E
1380: DD 36 00 16 ld   (ix+$00),$16
1384: DD 36 01 21 ld   (ix+$01),$21
1388: DD 36 1F 0E ld   (ix+$1f),$0E
138C: DD 36 20 15 ld   (ix+$20),$15
1390: DD 36 21 20 ld   (ix+$21),$20
1394: DD 36 40 14 ld   (ix+$40),$14
1398: DD 36 41 1F ld   (ix+$41),$1F
139C: DD 36 61 1E ld   (ix+$61),$1E
13A0: 11 00 14    ld   de,$1400
13A3: CD 42 15    call $1542
13A6: 1B          dec  de
13A7: 7A          ld   a,d
13A8: FE 00       cp   $00
13AA: 20 F7       jr   nz,$13A3
13AC: DD 21 6E 92 ld   ix,$926E
13B0: DD 36 00 00 ld   (ix+$00),$00
13B4: DD 36 01 B2 ld   (ix+$01),$B2
13B8: DD 36 1F 6A ld   (ix+$1f),$6A
13BC: DD 36 20 6B ld   (ix+$20),$6B
13C0: DD 36 21 AD ld   (ix+$21),$AD
13C4: DD 36 40 6C ld   (ix+$40),$6C
13C8: DD 36 41 9B ld   (ix+$41),$9B
13CC: DD 36 61 72 ld   (ix+$61),$72
13D0: 11 00 40    ld   de,$4000
13D3: CD 42 15    call $1542
13D6: 1B          dec  de
13D7: 7A          ld   a,d
13D8: FE 00       cp   $00
13DA: 20 F7       jr   nz,$13D3
13DC: DD 21 6E 92 ld   ix,$926E
13E0: DD 36 00 16 ld   (ix+$00),$16
13E4: DD 36 01 21 ld   (ix+$01),$21
13E8: DD 36 1F 0E ld   (ix+$1f),$0E
13EC: DD 36 20 15 ld   (ix+$20),$15
13F0: DD 36 21 20 ld   (ix+$21),$20
13F4: DD 36 40 14 ld   (ix+$40),$14
13F8: DD 36 41 1F ld   (ix+$41),$1F
13FC: DD 36 61 1E ld   (ix+$61),$1E
1400: DD 21 4D 92 ld   ix,$924D
1404: DD 36 00 10 ld   (ix+$00),$10
1408: 06 08       ld   b,$08
140A: DD 21 91 91 ld   ix,$9191
140E: DD 36 40 B8 ld   (ix+$40),$B8
1412: 11 00 07    ld   de,$0700
1415: CD 42 15    call $1542
1418: 1B          dec  de
1419: 7A          ld   a,d
141A: FE 00       cp   $00
141C: 20 F7       jr   nz,$1415
141E: DD 36 00 BD ld   (ix+$00),$BD
1422: DD 36 20 BA ld   (ix+$20),$BA
1426: 11 00 07    ld   de,$0700
1429: CD 42 15    call $1542
142C: 1B          dec  de
142D: 7A          ld   a,d
142E: FE 00       cp   $00
1430: 20 F7       jr   nz,$1429
1432: DD 36 40 43 ld   (ix+$40),$43
1436: 11 00 07    ld   de,$0700
1439: CD 42 15    call $1542
143C: 1B          dec  de
143D: 7A          ld   a,d
143E: FE 00       cp   $00
1440: 20 F7       jr   nz,$1439
1442: DD 36 00 45 ld   (ix+$00),$45
1446: DD 36 20 44 ld   (ix+$20),$44
144A: DD 36 40 43 ld   (ix+$40),$43
144E: 11 00 07    ld   de,$0700
1451: CD 42 15    call $1542
1454: 1B          dec  de
1455: 7A          ld   a,d
1456: FE 00       cp   $00
1458: 20 F7       jr   nz,$1451
145A: 10 B2       djnz $140E
145C: 11 00 20    ld   de,$2000
145F: CD 42 15    call $1542
1462: 1B          dec  de
1463: 7A          ld   a,d
1464: FE 00       cp   $00
1466: 20 F7       jr   nz,$145F
1468: DD 21 6E 92 ld   ix,$926E
146C: DD 36 00 00 ld   (ix+$00),$00
1470: DD 36 01 B2 ld   (ix+$01),$B2
1474: DD 36 1F 6A ld   (ix+$1f),$6A
1478: DD 36 20 6B ld   (ix+$20),$6B
147C: DD 36 21 AD ld   (ix+$21),$AD
1480: DD 36 40 6C ld   (ix+$40),$6C
1484: DD 36 41 9B ld   (ix+$41),$9B
1488: DD 36 61 72 ld   (ix+$61),$72
148C: DD 21 4D 92 ld   ix,$924D
1490: DD 36 00 62 ld   (ix+$00),$62
1494: 21 6B 93    ld   hl,$936B
1497: 0E 1A       ld   c,$1A
1499: CD DD 23    call $23DD
149C: 3E 30       ld   a,$30
149E: 32 94 65    ld   (guard_1_struct_6594),a
14A1: 3E 0C       ld   a,$0C
14A3: 32 95 65    ld   (unknown_6595),a
14A6: 3E 00       ld   a,$00
14A8: 32 96 65    ld   (guard_1_x_6596),a
14AB: 3E D8       ld   a,$D8
14AD: 32 97 65    ld   (guard_1_y_6597),a
14B0: 3E 80       ld   a,$80
14B2: 32 27 60    ld   (guard_1_direction_6027),a
14B5: 11 00 20    ld   de,$2000
14B8: CD 42 15    call $1542
14BB: 1B          dec  de
14BC: 7A          ld   a,d
14BD: FE 00       cp   $00
14BF: 20 F7       jr   nz,$14B8
14C1: 21 6B 93    ld   hl,$936B
14C4: 0E 19       ld   c,$19
14C6: F3          di
14C7: E5          push hl
14C8: C5          push bc
14C9: CD DD 23    call $23DD
14CC: C1          pop  bc
14CD: E1          pop  hl
14CE: FB          ei
14CF: ED 56       im   1
14D1: FF          rst  $38
14D2: 11 00 08    ld   de,$0800
14D5: CD 42 15    call $1542
14D8: 1B          dec  de
14D9: 7A          ld   a,d
14DA: FE 00       cp   $00
14DC: 20 F7       jr   nz,$14D5
14DE: 11 E0 FF    ld   de,$FFE0
14E1: 19          add  hl,de
14E2: 0D          dec  c
14E3: 79          ld   a,c
14E4: FE FF       cp   $FF
14E6: 20 DE       jr   nz,$14C6
14E8: AF          xor  a
14E9: 32 27 60    ld   (guard_1_direction_6027),a
14EC: 3E 2C       ld   a,$2C
14EE: 32 94 65    ld   (guard_1_struct_6594),a
14F1: 11 00 40    ld   de,$4000
14F4: CD 42 15    call $1542
14F7: 1B          dec  de
14F8: 7A          ld   a,d
14F9: FE 00       cp   $00
14FB: 20 F7       jr   nz,$14F4
14FD: 3E 00       ld   a,$00
14FF: 32 ED 61    ld   (check_scenery_disabled_61ED),a
1502: 06 01       ld   b,$01
1504: 21 80 65    ld   hl,player_struct_6580
1507: 3E 00       ld   a,$00
1509: 32 54 60    ld   (gameplay_allowed_6054),a
150C: 3A 00 60    ld   a,(number_of_credits_6000)
150F: FE 00       cp   $00
1511: C0          ret  nz
1512: 3E 00       ld   a,$00
1514: CD A8 C3    call $C3A8
1517: 3E 01       ld   a,$01
1519: 32 32 63    ld   (unknown_6332),a
151C: 3E 00       ld   a,$00
151E: 32 03 A0    ld   ($A003),a
1521: CD B7 C3    call clear_screen_C3B7
1524: 3E 04       ld   a,$04
1526: CD A3 C3    call change_attribute_everywhere_C3A3
1529: DD 21 A1 1F ld   ix,$1FA1
152D: 3A 00 B0    ld   a,($B000)
1530: E6 20       and  $20
1532: FE 20       cp   $20
1534: 20 04       jr   nz,$153A
1536: DD 21 A5 1D ld   ix,$1DA5
153A: CD 2A D8    call $D82A
153D: AF          xor  a
153E: 32 32 63    ld   (unknown_6332),a
1541: C9          ret
1542: 3A 00 60    ld   a,(number_of_credits_6000)
1545: FE 00       cp   $00
1547: C8          ret  z
1548: 3A 74 62    ld   a,(is_intermission_6274)
154B: FE 01       cp   $01
154D: C8          ret  z
154E: 3E 00       ld   a,$00
1550: 32 ED 61    ld   (check_scenery_disabled_61ED),a
1553: 3A 00 B8    ld   a,(io_read_shit_B800)
1556: E1          pop  hl
1557: 18 A4       jr   $14FD
1559: 00          nop
155A: 00          nop
155B: 00          nop
155C: 00          nop
155D: 00          nop
155E: 00          nop
155F: 00          nop
1560: 00          nop
1561: 00          nop
1562: 00          nop
1563: 00          nop
1564: 00          nop
1565: CD 72 15    call $1572
1568: CD 8F 15    call $158F
156B: CD AC 15    call $15AC
156E: CD C9 15    call $15C9
1571: C9          ret
1572: 3A 26 60    ld   a,(player_input_6026)
1575: E6 01       and  $01
1577: 47          ld   b,a
1578: 3A 50 60    ld   a,(player_previous_input_6050)
157B: E6 01       and  $01
157D: B8          cp   b
157E: C8          ret  z
157F: 3A 50 60    ld   a,(player_previous_input_6050)
1582: E6 01       and  $01
1584: FE 01       cp   $01
1586: C0          ret  nz
1587: 3E 01       ld   a,$01
1589: 0E 01       ld   c,$01
158B: CD E6 15    call $15E6
158E: C9          ret
158F: 3A 26 60    ld   a,(player_input_6026)
1592: E6 02       and  $02
1594: 47          ld   b,a
1595: 3A 50 60    ld   a,(player_previous_input_6050)
1598: E6 02       and  $02
159A: B8          cp   b
159B: C8          ret  z
159C: 3A 50 60    ld   a,(player_previous_input_6050)
159F: E6 02       and  $02
15A1: FE 02       cp   $02
15A3: C0          ret  nz
15A4: 3E 02       ld   a,$02
15A6: 0E 02       ld   c,$02
15A8: CD E6 15    call $15E6
15AB: C9          ret
15AC: 3A 51 60    ld   a,(coin_start_inputs_6051)
15AF: E6 01       and  $01
15B1: 47          ld   b,a
15B2: 3A 52 60    ld   a,(coin_start_prev_inputs_6052)
15B5: E6 01       and  $01
15B7: B8          cp   b
15B8: C8          ret  z
15B9: 3A 52 60    ld   a,(coin_start_prev_inputs_6052)
15BC: E6 01       and  $01
15BE: FE 01       cp   $01
15C0: C0          ret  nz
15C1: 3E 06       ld   a,$06
15C3: 0E 05       ld   c,$05
15C5: CD E6 15    call $15E6
15C8: C9          ret
15C9: 3A 51 60    ld   a,(coin_start_inputs_6051)
15CC: E6 02       and  $02
15CE: 47          ld   b,a
15CF: 3A 52 60    ld   a,(coin_start_prev_inputs_6052)
15D2: E6 02       and  $02
15D4: B8          cp   b
15D5: C8          ret  z
15D6: 3A 52 60    ld   a,(coin_start_prev_inputs_6052)
15D9: E6 02       and  $02
15DB: FE 02       cp   $02
15DD: C0          ret  nz
15DE: 3E 0E       ld   a,$0E
15E0: 0E 0A       ld   c,$0A
15E2: CD E6 15    call $15E6
15E5: C9          ret
15E6: F5          push af
15E7: CD 82 16    call $1682
15EA: F1          pop  af
15EB: 47          ld   b,a
15EC: 3A 63 61    ld   a,(flipped_dip_switches_copy_6163)
15EF: E6 04       and  $04
15F1: FE 04       cp   $04
15F3: 78          ld   a,b
15F4: 28 01       jr   z,$15F7
15F6: 87          add  a,a
15F7: 21 E4 61    ld   hl,unknown_61E4
15FA: 86          add  a,(hl)
15FB: 77          ld   (hl),a
15FC: FE 02       cp   $02
15FE: D4 02 16    call nc,$1602
1601: C9          ret
1602: 21 E4 61    ld   hl,unknown_61E4
1605: 7E          ld   a,(hl)
1606: FE 02       cp   $02
1608: D8          ret  c
1609: 3A 00 60    ld   a,(number_of_credits_6000)
160C: FE 90       cp   $90
160E: C8          ret  z
160F: C6 01       add  a,$01
1611: 27          daa
1612: 32 00 60    ld   (number_of_credits_6000),a
1615: 21 E4 61    ld   hl,unknown_61E4
1618: 35          dec  (hl)
1619: 35          dec  (hl)
161A: CD D9 D4    call can_pick_bag_D4D9
161D: 20 0A       jr   nz,$1629
161F: 21 68 5B    ld   hl,$5B68
1622: 22 40 61    ld   (ay_sound_pointer_6140),hl
1625: AF          xor  a
1626: 32 42 61    ld   (ay_sound_start_6142),a
1629: CD 2E 16    call $162E
162C: 18 D4       jr   $1602
162E: 3A 00 60    ld   a,(number_of_credits_6000)
1631: E6 0F       and  $0F
1633: 32 9F 90    ld   ($909F),a
1636: 3A 00 60    ld   a,(number_of_credits_6000)
1639: CB 0F       rrc  a
163B: CB 0F       rrc  a
163D: CB 0F       rrc  a
163F: CB 0F       rrc  a
1641: E6 0F       and  $0F
1643: 32 BF 90    ld   ($90BF),a
1646: 3E E0       ld   a,$E0
1648: 06 06       ld   b,$06
164A: 21 BF 93    ld   hl,$93BF
164D: CD 73 C3    call $C373
1650: 3A 56 60    ld   a,(lives_6056)
1653: FE 00       cp   $00
1655: 28 09       jr   z,$1660
1657: 21 BF 93    ld   hl,$93BF
165A: 47          ld   b,a
165B: 3E CA       ld   a,$CA
165D: CD 73 C3    call $C373
1660: 3A 10 62    ld   a,(must_play_music_6210)
1663: FE 01       cp   $01
1665: C0          ret  nz
1666: 3E 11       ld   a,$11
1668: 32 DF 92    ld   ($92DF),a
166B: 3E 13       ld   a,$13
166D: 32 BF 92    ld   ($92BF),a
1670: 3E 24       ld   a,$24
1672: 32 9F 92    ld   ($929F),a
1675: 3A D3 60    ld   a,(unknown_60D3)
1678: 32 5F 92    ld   ($925F),a
167B: C9          ret
167C: 01 01 01    ld   bc,$0101
167F: 00          nop
1680: 01 00 79    ld   bc,$7900
1683: 21 E5 61    ld   hl,unknown_61E5
1686: 86          add  a,(hl)
1687: 77          ld   (hl),a
1688: C9          ret
1689: 3A 26 60    ld   a,(player_input_6026)
168C: 32 50 60    ld   (player_previous_input_6050),a
168F: AF          xor  a
1690: 32 07 A0    ld   ($A007),a
1693: CD D9 16    call $16D9
1696: 47          ld   b,a
1697: CD D9 16    call $16D9
169A: B8          cp   b
169B: 28 05       jr   z,$16A2
169D: 32 60 63    ld   (unknown_6360),a
16A0: 18 F1       jr   $1693
16A2: 2F          cpl
16A3: CD F0 16    call $16F0
16A6: CD 05 17    call $1705
16A9: 32 26 60    ld   (player_input_6026),a
16AC: 3A 51 60    ld   a,(coin_start_inputs_6051)
16AF: 32 52 60    ld   (coin_start_prev_inputs_6052),a
16B2: CD E9 16    call $16E9
16B5: 47          ld   b,a
16B6: CD E9 16    call $16E9
16B9: B8          cp   b
16BA: 28 05       jr   z,$16C1
16BC: 32 60 63    ld   (unknown_6360),a
16BF: 18 F1       jr   $16B2
16C1: 2F          cpl
16C2: CD F0 16    call $16F0
16C5: 32 51 60    ld   (coin_start_inputs_6051),a
16C8: 3A 00 B0    ld   a,($B000)
16CB: 2F          cpl
16CC: 32 63 61    ld   (flipped_dip_switches_copy_6163),a
16CF: 3E 01       ld   a,$01
16D1: 32 07 A0    ld   ($A007),a
16D4: 3E 63       ld   a,$63
16D6: D3 56       out  ($56),a
16D8: C9          ret
16D9: 3E 07       ld   a,$07
16DB: D3 08       out  ($08),a
16DD: 3A 4D 63    ld   a,(unknown_634D)
16E0: D3 09       out  ($09),a
16E2: 3E 0E       ld   a,$0E
16E4: D3 08       out  ($08),a
16E6: DB 0C       in   a,($0C)
16E8: C9          ret
16E9: 3E 0F       ld   a,$0F
16EB: D3 08       out  ($08),a
16ED: DB 0C       in   a,($0C)
16EF: C9          ret
16F0: F5          push af
16F1: 3A ED 61    ld   a,(check_scenery_disabled_61ED)
16F4: FE 01       cp   $01
16F6: 28 09       jr   z,$1701
16F8: 3A F2 61    ld   a,(player_controls_blocked_61F2)
16FB: FE 01       cp   $01
16FD: 28 02       jr   z,$1701
16FF: F1          pop  af
1700: C9          ret
1701: F1          pop  af
1702: E6 03       and  $03
1704: C9          ret
1705: 47          ld   b,a
1706: 3A 00 B0    ld   a,($B000)
1709: 2F          cpl
170A: CB 07       rlc  a
170C: E6 01       and  $01
170E: 4F          ld   c,a
170F: 3A 7C 61    ld   a,(current_player_617C)
1712: A1          and  c
1713: 32 FD 61    ld   (unknown_61FD),a
1716: FE 01       cp   $01
1718: 28 02       jr   z,$171C
171A: 78          ld   a,b
171B: C9          ret
171C: 3A 51 60    ld   a,(coin_start_inputs_6051)
171F: E6 F8       and  $F8
1721: 4F          ld   c,a
1722: 78          ld   a,b
1723: E6 07       and  $07
1725: B1          or   c
1726: C9          ret
1727: 3A 54 60    ld   a,(gameplay_allowed_6054)
172A: FE 00       cp   $00
172C: C8          ret  z
172D: CD 00 55    call $5500
1730: C9          ret
1731: 3A 54 60    ld   a,(gameplay_allowed_6054)
1734: FE 01       cp   $01
1736: C8          ret  z
1737: 3A 26 60    ld   a,(player_input_6026)
173A: E6 03       and  $03
173C: 32 26 60    ld   (player_input_6026),a
173F: DD 21 20 18 ld   ix,$1820
1743: 3A 41 63    ld   a,(unknown_6341)
1746: FE 01       cp   $01
1748: 28 04       jr   z,$174E
174A: DD 21 48 18 ld   ix,$1848
174E: FD 21 80 65 ld   iy,player_struct_6580
1752: 11 04 00    ld   de,$0004
1755: 3A 88 62    ld   a,(unknown_6288)
1758: FE 00       cp   $00
175A: CC F1 17    call z,$17F1
175D: 3A 88 62    ld   a,(unknown_6288)
1760: FE 00       cp   $00
1762: 28 05       jr   z,$1769
1764: DD 19       add  ix,de
1766: 3D          dec  a
1767: 18 F7       jr   $1760
1769: 3A 5D 63    ld   a,(unknown_635D)
176C: FE 01       cp   $01
176E: 28 53       jr   z,$17C3
1770: DD 7E 03    ld   a,(ix+$03)
1773: FE FF       cp   $FF
1775: 28 52       jr   z,$17C9
1777: FE FE       cp   $FE
1779: CA E3 17    jp   z,$17E3
177C: E6 80       and  $80
177E: FE 80       cp   $80
1780: CC BD 17    call z,$17BD
1783: DD 7E 03    ld   a,(ix+$03)
1786: 47          ld   b,a
1787: 3A 26 60    ld   a,(player_input_6026)
178A: E6 07       and  $07
178C: B0          or   b
178D: 32 26 60    ld   (player_input_6026),a
1790: FD 7E 02    ld   a,(iy+$02)
1793: DD BE 00    cp   (ix+$00)
1796: C0          ret  nz
1797: FD 7E 03    ld   a,(iy+$03)
179A: DD BE 01    cp   (ix+$01)
179D: C0          ret  nz
179E: 3A 0D 60    ld   a,(player_screen_600D)
17A1: DD BE 02    cp   (ix+$02)
17A4: C0          ret  nz
17A5: 3A 88 62    ld   a,(unknown_6288)
17A8: 3C          inc  a
17A9: 32 88 62    ld   (unknown_6288),a
17AC: 3A 26 60    ld   a,(player_input_6026)
17AF: E6 80       and  $80
17B1: FE 80       cp   $80
17B3: C8          ret  z
17B4: 3A 26 60    ld   a,(player_input_6026)
17B7: E6 07       and  $07
17B9: 32 26 60    ld   (player_input_6026),a
17BC: C9          ret
17BD: 3E 01       ld   a,$01
17BF: 32 5D 63    ld   (unknown_635D),a
17C2: C9          ret
17C3: AF          xor  a
17C4: 32 5D 63    ld   (unknown_635D),a
17C7: 18 DC       jr   $17A5
17C9: 3E 10       ld   a,$10
17CB: 32 97 65    ld   (guard_1_y_6597),a
17CE: 32 9B 65    ld   (guard_2_y_659B),a
17D1: 3E D0       ld   a,$D0
17D3: 32 96 65    ld   (guard_1_x_6596),a
17D6: 3E E0       ld   a,$E0
17D8: 32 9A 65    ld   (guard_2_x_659A),a
17DB: 3A 87 65    ld   a,(elevator_y_current_screen_6587)
17DE: FE 11       cp   $11
17E0: C0          ret  nz
17E1: 18 C2       jr   $17A5
17E3: 3A 8A 65    ld   a,(wagon_data_658A)
17E6: FE 60       cp   $60
17E8: C0          ret  nz
17E9: 3A 19 60    ld   a,(unknown_6019)
17EC: FE 02       cp   $02
17EE: C0          ret  nz
17EF: 18 B4       jr   $17A5
17F1: 21 C3 91    ld   hl,$91C3
17F4: 22 C4 61    ld   (barrow_screen_params_61C4),hl
17F7: 22 FA 61    ld   (unknown_screen_address_61FA),hl
17FA: 3E 01       ld   a,$01
17FC: 32 C6 61    ld   (barrow_screen_61C6),a
17FF: 32 FC 61    ld   (unknown_61FC),a
1802: 3E 05       ld   a,$05
1804: 32 99 60    ld   (guard_1_screen_6099),a
1807: 32 9A 60    ld   (guard_2_screen_609A),a
180A: 3E 20       ld   a,$20
180C: 32 96 65    ld   (guard_1_x_6596),a
180F: 32 9A 65    ld   (guard_2_x_659A),a
1812: 3E A0       ld   a,$A0
1814: 32 97 65    ld   (guard_1_y_6597),a
1817: 32 9B 65    ld   (guard_2_y_659B),a
181A: 3E 0C       ld   a,$0C
181C: 32 7D 62    ld   (unknown_627D),a
181F: C9          ret

1919: FD 21 4E 22 ld   iy,$224E
191D: FE 34       cp   $34
191F: D8          ret  c
1920: FD 21 5D 22 ld   iy,$225D
1924: FE 38       cp   $38
1926: D8          ret  c
1927: FD 21 E8 21 ld   iy,$21E8
192B: FE 44       cp   $44
192D: D8          ret  c
192E: FD 21 09 22 ld   iy,$2209
1932: FE 48       cp   $48
1934: D8          ret  c
1935: FD 21 30 22 ld   iy,$2230
1939: C9          ret

guide_guard_on_hidden_screen_193A:
193A: DD E5       push ix
193C: FD E5       push iy
193E: E5          push hl
193F: C5          push bc
1940: D5          push de
1941: 78          ld   a,b
1942: FE 01       cp   $01
1944: 20 06       jr   nz,$194C
1946: FD 21 75 22 ld   iy,$2275
194A: 18 49       jr   $1995
194C: FE 02       cp   $02
194E: 20 13       jr   nz,$1963
1950: 47          ld   b,a
1951: 3A 0D 60    ld   a,(player_screen_600D)
1954: B8          cp   b
1955: 30 06       jr   nc,$195D
1957: FD 21 93 22 ld   iy,$2293
195B: 18 38       jr   $1995
195D: FD 21 BA 22 ld   iy,$22BA
1961: 18 32       jr   $1995
1963: FE 03       cp   $03
1965: 20 13       jr   nz,$197A
1967: 47          ld   b,a
1968: 3A 0D 60    ld   a,(player_screen_600D)
196B: B8          cp   b
196C: 30 06       jr   nc,$1974
196E: FD 21 E1 22 ld   iy,$22E1
1972: 18 21       jr   $1995
1974: FD 21 FF 22 ld   iy,$22FF
1978: 18 1B       jr   $1995
197A: FE 04       cp   $04
197C: 20 13       jr   nz,$1991
197E: 47          ld   b,a
197F: 3A 0D 60    ld   a,(player_screen_600D)
1982: B8          cp   b
1983: 30 06       jr   nc,$198B
1985: FD 21 1D 23 ld   iy,$231D
1989: 18 0A       jr   $1995
198B: FD 21 2C 23 ld   iy,$232C
198F: 18 04       jr   $1995
1991: FD 21 3B 23 ld   iy,$233B
1995: D1          pop  de
1996: FD 7E 00    ld   a,(iy+$00)
1999: 67          ld   h,a
199A: FD 7E 01    ld   a,(iy+$01)
199D: 6F          ld   l,a
199E: AF          xor  a
199F: ED 52       sbc  hl,de
19A1: 28 10       jr   z,$19B3
19A3: FD 23       inc  iy
19A5: FD 23       inc  iy
19A7: FD 23       inc  iy
19A9: FD 7E 02    ld   a,(iy+$02)
19AC: FE FF       cp   $FF
19AE: 20 E6       jr   nz,$1996
19B0: C3 D1 19    jp   $19D1
19B3: FD 7E 02    ld   a,(iy+$02)
19B6: FE 80       cp   $80
19B8: 20 06       jr   nz,$19C0
19BA: CD A2 F6    call set_guard_direction_right_F6A2
19BD: C3 D1 19    jp   $19D1
19C0: FE 40       cp   $40
19C2: 20 06       jr   nz,$19CA
19C4: CD C0 F6    call set_guard_direction_left_F6C0
19C7: C3 D1 19    jp   $19D1
19CA: DD 2A 95 60 ld   ix,(guard_direction_pointer_6095)
19CE: DD 77 00    ld   (ix+$00),a
19D1: C1          pop  bc
19D2: E1          pop  hl
19D3: FD E1       pop  iy
19D5: DD E1       pop  ix
19D7: E1          pop  hl
19D8: C3 44 F6    jp   $F644

23DD: 3E 01       ld   a,$01
23DF: CD E2 D8    call $D8E2
23E2: 06 12       ld   b,$12
23E4: E5          push hl
23E5: D1          pop  de
23E6: 7A          ld   a,d
23E7: C6 08       add  a,$08
23E9: 57          ld   d,a
23EA: 3E 2C       ld   a,$2C
23EC: E5          push hl
23ED: 12          ld   (de),a
23EE: 36 E0       ld   (hl),$E0
23F0: 13          inc  de
23F1: 23          inc  hl
23F2: 10 F9       djnz $23ED
23F4: E1          pop  hl
23F5: DD 21 4E 25 ld   ix,$254E
23F9: 11 E0 FF    ld   de,$FFE0
23FC: 19          add  hl,de
23FD: 3E 2C       ld   a,$2C
23FF: 08          ex   af,af'
2400: CD 0F 25    call $250F
2403: DD 21 57 25 ld   ix,$2557
2407: CD 0F 25    call $250F
240A: DD 21 61 25 ld   ix,$2561
240E: CD 0F 25    call $250F
2411: DD 21 6B 25 ld   ix,$256B
2415: CD 0F 25    call $250F
2418: DD 21 77 25 ld   ix,$2577
241C: CD 0F 25    call $250F
241F: DD 21 86 25 ld   ix,$2586
2423: CD 0F 25    call $250F
2426: DD 21 97 25 ld   ix,$2597
242A: CD 0F 25    call $250F
242D: 3E 28       ld   a,$28
242F: 08          ex   af,af'
2430: DD 21 A8 25 ld   ix,$25A8
2434: CD 0F 25    call $250F
2437: DD 21 B9 25 ld   ix,$25B9
243B: CD 0F 25    call $250F
243E: DD 21 CA 25 ld   ix,$25CA
2442: CD 0F 25    call $250F
2445: DD 21 DB 25 ld   ix,$25DB
2449: CD 0F 25    call $250F
244C: DD 21 F0 25 ld   ix,$25F0
2450: CD 0F 25    call $250F
2453: DD 21 05 26 ld   ix,$2605
2457: CD 0F 25    call $250F
245A: DD 21 1A 26 ld   ix,$261A
245E: CD 0F 25    call $250F
2461: 3E 18       ld   a,$18
2463: 08          ex   af,af'
2464: DD 21 2F 26 ld   ix,$262F
2468: CD 0F 25    call $250F
246B: 3E 1C       ld   a,$1C
246D: 08          ex   af,af'
246E: FD 21 33 25 ld   iy,$2533
2472: 06 00       ld   b,$00
2474: FD 09       add  iy,bc
2476: FD 7E 00    ld   a,(iy+$00)
2479: FE 00       cp   $00
247B: 28 1A       jr   z,$2497
247D: FE 01       cp   $01
247F: 28 2C       jr   z,$24AD
2481: FE 02       cp   $02
2483: 28 3E       jr   z,$24C3
2485: FE 03       cp   $03
2487: 28 50       jr   z,$24D9
2489: FE 10       cp   $10
248B: 28 62       jr   z,$24EF
248D: FE 11       cp   $11
248F: 28 66       jr   z,$24F7
2491: FE 12       cp   $12
2493: 28 6A       jr   z,$24FF
2495: 18 70       jr   $2507
2497: DD 21 44 26 ld   ix,$2644
249B: CD 0F 25    call $250F
249E: DD 21 59 26 ld   ix,$2659
24A2: CD 0F 25    call $250F
24A5: DD 21 63 26 ld   ix,$2663
24A9: CD 0F 25    call $250F
24AC: C9          ret
24AD: DD 21 82 26 ld   ix,$2682
24B1: CD 0F 25    call $250F
24B4: DD 21 97 26 ld   ix,$2697
24B8: CD 0F 25    call $250F
24BB: DD 21 A3 26 ld   ix,$26A3
24BF: CD 0F 25    call $250F
24C2: C9          ret
24C3: DD 21 C2 26 ld   ix,$26C2
24C7: CD 0F 25    call $250F
24CA: DD 21 D7 26 ld   ix,$26D7
24CE: CD 0F 25    call $250F
24D1: DD 21 E2 26 ld   ix,$26E2
24D5: CD 0F 25    call $250F
24D8: C9          ret
24D9: DD 21 02 27 ld   ix,$2702
24DD: CD 0F 25    call $250F
24E0: DD 21 17 27 ld   ix,$2717
24E4: CD 0F 25    call $250F
24E7: DD 21 21 27 ld   ix,$2721
24EB: CD 0F 25    call $250F
24EE: C9          ret
24EF: DD 21 6D 26 ld   ix,$266D
24F3: CD 0F 25    call $250F
24F6: C9          ret
24F7: DD 21 AD 26 ld   ix,$26AD
24FB: CD 0F 25    call $250F
24FE: C9          ret
24FF: DD 21 ED 26 ld   ix,$26ED
2503: CD 0F 25    call $250F
2506: C9          ret
2507: DD 21 2B 27 ld   ix,$272B
250B: CD 0F 25    call $250F
250E: C9          ret
250F: E5          push hl
2510: DD 7E 00    ld   a,(ix+$00)
2513: DD 23       inc  ix
2515: B9          cp   c
2516: 41          ld   b,c
2517: 30 01       jr   nc,$251A
2519: 47          ld   b,a
251A: 78          ld   a,b
251B: FE 00       cp   $00
251D: C8          ret  z
251E: DD 7E 00    ld   a,(ix+$00)
2521: 77          ld   (hl),a
2522: E5          push hl
2523: 7C          ld   a,h
2524: C6 08       add  a,$08
2526: 67          ld   h,a
2527: 08          ex   af,af'
2528: 77          ld   (hl),a
2529: 08          ex   af,af'
252A: E1          pop  hl
252B: 19          add  hl,de
252C: DD 23       inc  ix
252E: 10 EA       djnz $251A
2530: E1          pop  hl
2531: 23          inc  hl
2532: C9          ret



5500: 3A ED 61    ld   a,(check_scenery_disabled_61ED)
5503: FE 01       cp   $01
5505: C8          ret  z
5506: 3A 7C 61    ld   a,(current_player_617C)
5509: FE 00       cp   $00
550B: C2 31 55    jp   nz,$5531
550E: DD 21 76 61 ld   ix,player_1_score_6176
5512: AF          xor  a
5513: 7D          ld   a,l
5514: 47          ld   b,a
5515: DD 7E 00    ld   a,(ix+$00)
5518: 80          add  a,b
5519: 27          daa
551A: DD 77 00    ld   (ix+$00),a
551D: 7C          ld   a,h
551E: 47          ld   b,a
551F: DD 7E 01    ld   a,(ix+$01)
5522: 88          adc  a,b
5523: 27          daa
5524: DD 77 01    ld   (ix+$01),a
5527: DD 7E 02    ld   a,(ix+$02)
552A: CE 00       adc  a,$00
552C: 27          daa
552D: DD 77 02    ld   (ix+$02),a
5530: C9          ret
5531: DD 21 79 61 ld   ix,player_2_score_6179
5535: 18 DB       jr   $5512
5537: FD 7E 02    ld   a,(iy+$02)
553A: 47          ld   b,a
553B: DD 7E 02    ld   a,(ix+$02)
553E: CD 4E 55    call $554E
5541: FD 7E 03    ld   a,(iy+$03)
5544: 47          ld   b,a
5545: DD 7E 03    ld   a,(ix+$03)
5548: CD 4E 55    call $554E
554B: 3E 01       ld   a,$01
554D: C9          ret
554E: 4F          ld   c,a
554F: C6 0B       add  a,$0B
5551: B8          cp   b
5552: 38 07       jr   c,$555B
5554: 79          ld   a,c
5555: D6 08       sub  $08
5557: B8          cp   b
5558: 30 01       jr   nc,$555B
555A: C9          ret
555B: F1          pop  af
555C: AF          xor  a
555D: C9          ret
555E: DD 21 80 65 ld   ix,player_struct_6580
5562: FD 21 09 60 ld   iy,player_logical_address_6009
5566: 18 1A       jr   $5582
5568: DD 21 94 65 ld   ix,guard_1_struct_6594
556C: FD 21 38 60 ld   iy,guard_1_logical_address_6038
5570: 3A 99 60    ld   a,(guard_1_screen_6099)
5573: 18 10       jr   $5585
5575: DD 21 98 65 ld   ix,guard_2_struct_6598
5579: FD 21 78 60 ld   iy,guard_2_logical_address_6078
557D: 3A 9A 60    ld   a,(guard_2_screen_609A)
5580: 18 03       jr   $5585
5582: 3A 0D 60    ld   a,(player_screen_600D)
5585: 32 98 60    ld   (current_guard_screen_index_6098),a
5588: CD 8C 55    call $558C
558B: C9          ret
558C: CD AC 55    call $55AC
558F: CD 9A 55    call $559A
5592: FD 75 00    ld   (iy+$00),l
5595: FD 74 01    ld   (iy+$01),h
5598: C9          ret
5599: C9          ret
559A: DD 7E 03    ld   a,(ix+$03)
559D: C6 10       add  a,$10
559F: CB 3F       srl  a
55A1: CB 3F       srl  a
55A3: CB 3F       srl  a
55A5: 85          add  a,l
55A6: 6F          ld   l,a
55A7: 7C          ld   a,h
55A8: CE 00       adc  a,$00
55AA: 67          ld   h,a
55AB: C9          ret
55AC: DD 7E 02    ld   a,(ix+$02)
55AF: C6 07       add  a,$07
55B1: 2F          cpl
55B2: CB 3F       srl  a
55B4: C3 CD 5B    jp   $5BCD
55B7: 00          nop
55B8: 47          ld   b,a
55B9: 11 20 00    ld   de,$0020
55BC: 21 00 40    ld   hl,$4000
55BF: 19          add  hl,de
55C0: 10 FD       djnz $55BF
55C2: 3A 98 60    ld   a,(current_guard_screen_index_6098)
55C5: FE 01       cp   $01
55C7: C8          ret  z
55C8: FE 02       cp   $02
55CA: 20 05       jr   nz,$55D1
55CC: 7C          ld   a,h
55CD: C6 04       add  a,$04
55CF: 67          ld   h,a
55D0: C9          ret
55D1: FE 03       cp   $03
55D3: C0          ret  nz
55D4: 7C          ld   a,h
55D5: C6 08       add  a,$08
55D7: 67          ld   h,a
55D8: C9          ret
55D9: 01 E0 FF    ld   bc,$FFE0
55DC: 1A          ld   a,(de)
55DD: FE 3F       cp   $3F
55DF: C8          ret  z
55E0: D6 30       sub  $30
55E2: 77          ld   (hl),a
55E3: E5          push hl
55E4: 7C          ld   a,h
55E5: C6 08       add  a,$08
55E7: 67          ld   h,a
55E8: 3E 00       ld   a,$00
55EA: 77          ld   (hl),a
55EB: E1          pop  hl
55EC: 13          inc  de
55ED: 09          add  hl,bc
55EE: 18 E9       jr   $55D9
55F0: 01 E0 FF    ld   bc,$FFE0
55F3: 1A          ld   a,(de)
55F4: FE 3F       cp   $3F
55F6: C8          ret  z
55F7: 77          ld   (hl),a
55F8: E5          push hl
55F9: 7C          ld   a,h
55FA: C6 08       add  a,$08
55FC: 67          ld   h,a
55FD: 08          ex   af,af'
55FE: 77          ld   (hl),a
55FF: 08          ex   af,af'
5600: E1          pop  hl
5601: 13          inc  de
5602: 09          add  hl,bc
5603: 18 EB       jr   $55F0

write_attribute_on_line_5605:
5605: 11 20 00    ld   de,$0020
5608: 06 1C       ld   b,$1C
560A: 77          ld   (hl),a
560B: 19          add  hl,de
560C: 10 FC       djnz $560A
560E: C9          ret
560F: DD 21 76 61 ld   ix,player_1_score_6176
5613: 21 E1 92    ld   hl,$92E1
5616: CD 3C 56    call $563C
5619: DD 21 79 61 ld   ix,player_2_score_6179
561D: 21 61 90    ld   hl,$9061
5620: CD 3C 56    call $563C
5623: DD 21 E8 61 ld   ix,time_61E8
5627: 21 01 92    ld   hl,$9201
562A: 06 01       ld   b,$01
562C: CD 41 56    call $5641
562F: DD 21 E9 61 ld   ix,unknown_61E9
5633: 21 C1 91    ld   hl,$91C1
5636: 06 01       ld   b,$01
5638: CD 41 56    call $5641
563B: C9          ret
563C: 06 03       ld   b,$03
563E: 11 20 00    ld   de,$0020
5641: DD 7E 00    ld   a,(ix+$00)
5644: CD 4D 56    call $564D
5647: DD 23       inc  ix
5649: 19          add  hl,de
564A: 10 F5       djnz $5641
564C: C9          ret
564D: F5          push af
564E: E6 0F       and  $0F
5650: 77          ld   (hl),a
5651: 19          add  hl,de
5652: F1          pop  af
5653: CB 0F       rrc  a
5655: CB 0F       rrc  a
5657: CB 0F       rrc  a
5659: CB 0F       rrc  a
565B: E6 0F       and  $0F
565D: 77          ld   (hl),a
565E: C9          ret
565F: ED 52       sbc  hl,de
5661: 06 11       ld   b,$11
5663: CD 6A 56    call $566A
5666: CD 75 56    call $5675
5669: C9          ret

5BC1: 8B          adc  a,e
5BC2: C4 82 65    call nz,player_x_6582
5BC5: 96          sub  (hl)
5BC6: 01 9E 65    ld   bc,sprite_object_x_659E
5BC9: 8B          adc  a,e
5BCA: B4          or   h
5BCB: 8D          adc  a,l
5BCC: B0          or   b
5BCD: CB 3F       srl  a
5BCF: CB 3F       srl  a
5BD1: FE 00       cp   $00
5BD3: CA C2 55    jp   z,$55C2
5BD6: C3 B8 55    jp   $55B8
5BD9: 20 00       jr   nz,$5BDB
5BDB: 00          nop
5BDC: 02          ld   (bc),a
5BDD: 00          nop
5BDE: 00          nop
5BDF: 00          nop
5BE0: 08          ex   af,af'
5BE1: 1B          dec  de
5BE2: 00          nop
5BE3: 00          nop
5BE4: 0F          rrca
5BE5: 1B          dec  de
5BE6: 00          nop
5BE7: 00          nop
5BE8: 08          ex   af,af'
5BE9: 1B          dec  de
5BEA: 00          nop
5BEB: 00          nop
5BEC: 08          ex   af,af'
5BED: 1C          inc  e
5BEE: 00          nop
5BEF: 00          nop
5BF0: 08          ex   af,af'
5BF1: 00          nop
5BF2: 00          nop
5BF3: 00          nop
5BF4: 08          ex   af,af'
5BF5: 1B          dec  de
5BF6: 00          nop
5BF7: 00          nop
5BF8: 08          ex   af,af'
5BF9: 00          nop
5BFA: 00          nop
5BFB: 00          nop
5BFC: 08          ex   af,af'
5BFD: 1F          rra
5BFE: 00          nop
5BFF: 00          nop
5C00: 20 20       jr   nz,$5C22
5C02: 00          nop
5C03: 00          nop
5C04: 0F          rrca
5C05: 00          nop
5C06: 00          nop
5C07: 00          nop
5C08: 08          ex   af,af'
5C09: 00          nop
5C0A: 00          nop
5C0B: 00          nop
5C0C: FF          rst  $38
5C0D: FF          rst  $38
5C0E: 08          ex   af,af'
5C0F: 00          nop
5C10: 3A F5 61    ld   a,(unknown_61F5)
5C13: FE 00       cp   $00
5C15: C2 68 05    jp   nz,$0568
5C18: 3A CF 61    ld   a,(has_pick_61CF)
5C1B: FE 00       cp   $00
5C1D: C2 68 05    jp   nz,$0568
5C20: C3 5B 05    jp   $055B
5C23: 26 3A       ld   h,$3A
5C25: F5          push af
5C26: 61          ld   h,c
5C27: FE 00       cp   $00
5C29: C2 52 06    jp   nz,$0652
5C2C: 3A CF 61    ld   a,(has_pick_61CF)
5C2F: FE 00       cp   $00
5C31: C2 52 06    jp   nz,$0652
5C34: C3 45 06    jp   $0645
5C37: 05          dec  b
5C38: 50          ld   d,b
5C39: 50          ld   d,b
5C3A: 49          ld   c,c
5C3B: 60          ld   h,b
5C3C: 46          ld   b,(hl)
5C3D: 44          ld   b,h
5C3E: 0C          inc  c
5C3F: 04          inc  b
5C40: 3A 59 61    ld   a,(bag_falling_6159)
5C43: FE 01       cp   $01
5C45: C8          ret  z
5C46: 3A 5E 61    ld   a,(bag_sliding_615E)
5C49: FE 01       cp   $01
5C4B: C8          ret  z
5C4C: 0A          ld   a,(bc)
5C4D: D9          exx
5C4E: FE 00       cp   $00
5C50: C3 AE 23    jp   $23AE
5C53: FF          rst  $38
5C54: 58          ld   e,b
5C55: 93          sub  e
5C56: 02          ld   (bc),a
5C57: A8          xor  b
5C58: 91          sub  c
5C59: 01 12 91    ld   bc,$9112
5C5C: 01 98 90    ld   bc,$9098
5C5F: 01 DC 91    ld   bc,$91DC
5C62: 01 36 93    ld   bc,$9336
5C65: 01 71 90    ld   bc,$9071
5C68: 01 4C 92    ld   bc,$924C
5C6B: 02          ld   (bc),a
5C6C: CA 90 02    jp   z,$0290
5C6F: C5          push bc
5C70: 90          sub  b
5C71: 02          ld   (bc),a
5C72: 91          sub  c
5C73: 90          sub  b
5C74: 02          ld   (bc),a
5C75: 9C          sbc  a,h
5C76: 90          sub  b
5C77: 02          ld   (bc),a
5C78: 71          ld   (hl),c
5C79: 93          sub  e
5C7A: 03          inc  bc
5C7B: 85          add  a,l
5C7C: 92          sub  d
5C7D: 03          inc  bc
5C7E: C9          ret

add_to_score_5C90:
5C90: 3A 54 60    ld   a,(gameplay_allowed_6054)
5C93: FE 00       cp   $00
5C95: C8          ret  z
5C96: CD 00 55    call $5500
5C99: C9          ret
5C9A: C3 46 5E    jp   $5E46
5C9D: FE 01       cp   $01
5C9F: C8          ret  z
5CA0: DD 21 44 5D ld   ix,$5D44
5CA4: FD 21 80 65 ld   iy,player_struct_6580
5CA8: 11 04 00    ld   de,$0004
5CAB: 3A 88 62    ld   a,(unknown_6288)
5CAE: FE 00       cp   $00
5CB0: CC 2A 5D    call z,$5D2A
5CB3: 3A 88 62    ld   a,(unknown_6288)
5CB6: FE 00       cp   $00
5CB8: 28 05       jr   z,$5CBF
5CBA: DD 19       add  ix,de
5CBC: 3D          dec  a
5CBD: 18 F7       jr   $5CB6
5CBF: DD 7E 03    ld   a,(ix+$03)
5CC2: FE FF       cp   $FF
5CC4: 28 3C       jr   z,$5D02
5CC6: FE FE       cp   $FE
5CC8: CA 1C 5D    jp   z,$5D1C
5CCB: 47          ld   b,a
5CCC: 3A 26 60    ld   a,(player_input_6026)
5CCF: E6 07       and  $07
5CD1: B0          or   b
5CD2: 32 26 60    ld   (player_input_6026),a
5CD5: FD 7E 02    ld   a,(iy+$02)
5CD8: DD BE 00    cp   (ix+$00)
5CDB: C0          ret  nz
5CDC: FD 7E 03    ld   a,(iy+$03)
5CDF: DD BE 01    cp   (ix+$01)
5CE2: C0          ret  nz
5CE3: 3A 0D 60    ld   a,(player_screen_600D)
5CE6: DD BE 02    cp   (ix+$02)
5CE9: C0          ret  nz
5CEA: 3A 88 62    ld   a,(unknown_6288)
5CED: 3C          inc  a
5CEE: 32 88 62    ld   (unknown_6288),a
5CF1: 3A 26 60    ld   a,(player_input_6026)
5CF4: E6 80       and  $80
5CF6: FE 80       cp   $80
5CF8: C8          ret  z
5CF9: 3A 26 60    ld   a,(player_input_6026)
5CFC: E6 07       and  $07
5CFE: 32 26 60    ld   (player_input_6026),a
5D01: C9          ret
5D02: 3E 10       ld   a,$10
5D04: 32 97 65    ld   (guard_1_y_6597),a
5D07: 32 9B 65    ld   (guard_2_y_659B),a
5D0A: 3E D0       ld   a,$D0
5D0C: 32 96 65    ld   (guard_1_x_6596),a
5D0F: 3E E0       ld   a,$E0
5D11: C3 38 5E    jp   $5E38
5D14: 3A 87 65    ld   a,(elevator_y_current_screen_6587)
5D17: FE 11       cp   $11
5D19: C0          ret  nz
5D1A: 18 CE       jr   $5CEA
5D1C: 3A 8A 65    ld   a,(wagon_data_658A)
5D1F: FE 7F       cp   $7F
5D21: C0          ret  nz
5D22: 3A 19 60    ld   a,(unknown_6019)
5D25: FE 01       cp   $01
5D27: C0          ret  nz
5D28: 18 C0       jr   $5CEA
5D2A: 21 C2 91    ld   hl,$91C2
5D2D: 22 C4 61    ld   (barrow_screen_params_61C4),hl
5D30: 22 FA 61    ld   (unknown_screen_address_61FA),hl
5D33: 3E 01       ld   a,$01
5D35: 32 C6 61    ld   (barrow_screen_61C6),a
5D38: 32 FC 61    ld   (unknown_61FC),a
5D3B: 3E 03       ld   a,$03
5D3D: 32 99 60    ld   (guard_1_screen_6099),a
5D40: 32 9A 60    ld   (guard_2_screen_609A),a
5D43: C9          ret

C000: C3 82 C3    jp   $C382
C003: C3 93 C3    jp   $C393
C006: 31 F0 67    ld   sp,stack_top_67F0
C009: 3E 3F       ld   a,$3F
C00B: CD A3 C3    call change_attribute_everywhere_C3A3
C00E: CD B7 C3    call clear_screen_C3B7
C011: 3E 01       ld   a,$01
C013: 32 03 A0    ld   ($A003),a
C016: 21 8C 1A    ld   hl,$1A8C
C019: 11 17 62    ld   de,high_score_table_6217
C01C: 01 50 00    ld   bc,$0050
C01F: ED B0       ldir
C021: 21 68 5B    ld   hl,$5B68
C024: 22 40 61    ld   (ay_sound_pointer_6140),hl
C027: AF          xor  a
C028: 32 42 61    ld   (ay_sound_start_6142),a
C02B: C3 C1 EC    jp   $ECC1
C02E: 3A 10 62    ld   a,(must_play_music_6210)
C031: FE 01       cp   $01
C033: 20 3E       jr   nz,$C073
C035: 3A 6D 62    ld   a,(flash_counter_626D)
C038: FE 20       cp   $20
C03A: DC 47 C0    call c,$C047
C03D: FE 30       cp   $30
C03F: DC 7C C0    call c,$C07C
C042: AF          xor  a
C043: 32 6D 62    ld   (flash_counter_626D),a
C046: C9          ret
C047: 3A 6E 62    ld   a,(unknown_626E)
C04A: FE 01       cp   $01
C04C: 28 13       jr   z,$C061
C04E: CD 8B C0    call $C08B
C051: 28 10       jr   z,$C063
C053: 11 5A 57    ld   de,$575A
C056: CD 67 CA    call display_localized_text_CA67
C059: CD 73 C0    call $C073
C05C: 3E 01       ld   a,$01
C05E: 32 6E 62    ld   (unknown_626E),a
C061: F1          pop  af
C062: C9          ret
C063: 11 63 57    ld   de,$5763
C066: CD 67 CA    call display_localized_text_CA67
C069: CD 73 C0    call $C073
C06C: 3E 01       ld   a,$01
C06E: 32 6E 62    ld   (unknown_626E),a
C071: F1          pop  af
C072: C9          ret
C073: 3E 02       ld   a,$02
C075: 21 40 98    ld   hl,$9840
C078: CD 05 56    call write_attribute_on_line_5605
C07B: C9          ret
C07C: CD 8B C0    call $C08B
C07F: 11 6C 57    ld   de,$576C
C082: CD 67 CA    call display_localized_text_CA67
C085: AF          xor  a
C086: 32 6E 62    ld   (unknown_626E),a
C089: F1          pop  af
C08A: C9          ret
C08B: 3A 7C 61    ld   a,(current_player_617C)
C08E: 21 A0 93    ld   hl,$93A0
C091: FE 01       cp   $01
C093: C0          ret  nz
C094: 21 20 91    ld   hl,$9120
C097: C9          ret
C098: 2B          dec  hl
C099: F3          di
C09A: CD F3 C0    call $C0F3
C09D: 23          inc  hl
C09E: CD F3 C0    call $C0F3
C0A1: 0A          ld   a,(bc)
C0A2: FB          ei
C0A3: C9          ret

C0A4: C5          push bc
C0A5: E5          push hl
C0A6: D5          push de
C0A7: AF          xor  a
C0A8: 32 0B 60    ld   (way_clear_flag_600B),a
C0AB: 11 D5 35    ld   de,$35D5
C0AE: ED 52       sbc  hl,de
C0B0: 20 0A       jr   nz,$C0BC
C0B2: CD DF C0    call $C0DF
C0B5: 28 05       jr   z,$C0BC
C0B7: 3E 02       ld   a,$02
C0B9: 32 0B 60    ld   (way_clear_flag_600B),a
C0BC: D1          pop  de
C0BD: E1          pop  hl
C0BE: C1          pop  bc
C0BF: C9          ret

check_breakable_wall_C0C0:
C0C0: C5          push bc
C0C1: E5          push hl
C0C2: D5          push de
C0C3: AF          xor  a
C0C4: 32 0B 60    ld   (way_clear_flag_600B),a
C0C7: 11 15 36    ld   de,$3615
C0CA: ED 52       sbc  hl,de
C0CC: 20 0A       jr   nz,$C0D8
C0CE: CD DF C0    call $C0DF
C0D1: 28 05       jr   z,$C0D8
C0D3: 3E 02       ld   a,$02
C0D5: 32 0B 60    ld   (way_clear_flag_600B),a
C0D8: D1          pop  de
C0D9: E1          pop  hl
C0DA: C1          pop  bc
C0DB: C9          ret
C0DC: D1          pop  de
C0DD: 18 F9       jr   $C0D8
C0DF: 3A 0D 60    ld   a,(player_screen_600D)
C0E2: FE 05       cp   $05
C0E4: 20 F6       jr   nz,$C0DC
C0E6: 21 F3 91    ld   hl,$91F3
C0E9: 7E          ld   a,(hl)
C0EA: 21 DB 19    ld   hl,$19DB
C0ED: 01 05 00    ld   bc,$0005
C0F0: ED B1       cpir
C0F2: C9          ret
C0F3: 7E          ld   a,(hl)
C0F4: FE 51       cp   $51
C0F6: 28 15       jr   z,$C10D
C0F8: FD 21 12 1A ld   iy,$1A12
C0FC: 11 E0 19    ld   de,$19E0
C0FF: C5          push bc
C100: 4F          ld   c,a
C101: 06 08       ld   b,$08
C103: 1A          ld   a,(de)
C104: B9          cp   c
C105: 28 14       jr   z,$C11B
C107: 13          inc  de
C108: FD 23       inc  iy
C10A: 10 F7       djnz $C103
C10C: C1          pop  bc
C10D: 03          inc  bc
C10E: 0A          ld   a,(bc)
C10F: 3C          inc  a
C110: 02          ld   (bc),a
C111: 0B          dec  bc
C112: FE 03       cp   $03
C114: D8          ret  c
C115: AF          xor  a
C116: 03          inc  bc
C117: 02          ld   (bc),a
C118: 0B          dec  bc
C119: 02          ld   (bc),a
C11A: C9          ret
C11B: C1          pop  bc
C11C: FD 7E 00    ld   a,(iy+$00)
C11F: DD 77 03    ld   (ix+$03),a
C122: 3E 01       ld   a,$01
C124: 02          ld   (bc),a
C125: 03          inc  bc
C126: AF          xor  a
C127: 02          ld   (bc),a
C128: 0B          dec  bc
C129: C9          ret
C12A: 7E          ld   a,(hl)
C12B: FE FF       cp   $FF
C12D: C8          ret  z
C12E: CD 6D C1    call $C16D
C131: 78          ld   a,b
C132: 32 0C 60    ld   (unknown_600C),a
C135: FE 00       cp   $00
C137: C8          ret  z
C138: FD 7E 00    ld   a,(iy+$00)
C13B: FE 01       cp   $01
C13D: C8          ret  z
C13E: 7E          ld   a,(hl)
C13F: FE 51       cp   $51
C141: 28 0C       jr   z,$C14F
C143: 4F          ld   c,a
C144: 11 E8 19    ld   de,$19E8
C147: 06 30       ld   b,$30
C149: 1A          ld   a,(de)
C14A: B9          cp   c
C14B: C8          ret  z
C14C: 13          inc  de
C14D: 10 FA       djnz $C149
C14F: 3A 0C 60    ld   a,(unknown_600C)
C152: FE 05       cp   $05
C154: 30 09       jr   nc,$C15F
C156: 47          ld   b,a
C157: DD 7E 03    ld   a,(ix+$03)
C15A: 90          sub  b
C15B: DD 77 03    ld   (ix+$03),a
C15E: C9          ret
C15F: 2F          cpl
C160: E6 07       and  $07
C162: C6 01       add  a,$01
C164: 47          ld   b,a
C165: DD 7E 03    ld   a,(ix+$03)
C168: 80          add  a,b
C169: DD 77 03    ld   (ix+$03),a
C16C: C9          ret
C16D: DD 7E 03    ld   a,(ix+$03)
C170: CB 07       rlc  a
C172: CB 07       rlc  a
C174: CB 07       rlc  a
C176: CB 07       rlc  a
C178: CB 07       rlc  a
C17A: 06 00       ld   b,$00
C17C: CB 07       rlc  a
C17E: CB 10       rl   b
C180: CB 07       rlc  a
C182: CB 10       rl   b
C184: CB 07       rlc  a
C186: CB 10       rl   b
C188: C9          ret
C189: CD CD C3    call $C3CD
C18C: 3E 3F       ld   a,$3F
C18E: CD A3 C3    call change_attribute_everywhere_C3A3
C191: 3A 00 B8    ld   a,(io_read_shit_B800)
C194: 21 00 34    ld   hl,$3400
C197: 11 00 90    ld   de,$9000
C19A: 01 00 04    ld   bc,$0400
C19D: ED B0       ldir
C19F: 21 82 98    ld   hl,$9882
C1A2: 06 06       ld   b,$06
C1A4: CD 61 C3    call $C361
C1A7: CD 4D CE    call switch_to_screen_5_CE4D
C1AA: CD DD D0    call $D0DD
C1AD: CD 0E C3    call $C30E
C1B0: 3A 00 B8    ld   a,(io_read_shit_B800)
C1B3: CD DE F8    call $F8DE
C1B6: CD 7E CA    call $CA7E
C1B9: CD F3 D0    call $D0F3
C1BC: 3E 63       ld   a,$63
C1BE: D3 58       out  ($58),a
C1C0: C9          ret
C1C1: CD CD C3    call $C3CD
C1C4: 3E 3F       ld   a,$3F
C1C6: CD A3 C3    call change_attribute_everywhere_C3A3
C1C9: 3A 00 B8    ld   a,(io_read_shit_B800)
C1CC: 21 00 30    ld   hl,$3000
C1CF: 11 00 90    ld   de,$9000
C1D2: 01 00 04    ld   bc,$0400
C1D5: ED B0       ldir
C1D7: 21 02 93    ld   hl,$9302
C1DA: CD 38 C3    call $C338
C1DD: 21 62 98    ld   hl,$9862
C1E0: 06 0E       ld   b,$0E
C1E2: CD 61 C3    call $C361
C1E5: 21 1A 99    ld   hl,$991A
C1E8: 06 16       ld   b,$16
C1EA: CD 6E C3    call $C36E
C1ED: 3E 3F       ld   a,$3F
C1EF: 32 57 9B    ld   ($9B57),a
C1F2: CD DD D0    call $D0DD
C1F5: 21 84 65    ld   hl,elevator_struct_6584
C1F8: 3E 33       ld   a,$33
C1FA: 77          ld   (hl),a
C1FB: 23          inc  hl
C1FC: 3E 04       ld   a,$04
C1FE: 77          ld   (hl),a
C1FF: 23          inc  hl
C200: 3E BF       ld   a,$BF
C202: 77          ld   (hl),a
C203: 23          inc  hl
C204: 3A 00 B8    ld   a,(io_read_shit_B800)
C207: CD DE F8    call $F8DE
C20A: CD 7E CA    call $CA7E
C20D: C9          ret
C20E: CD CD C3    call $C3CD
C211: 3E 3F       ld   a,$3F
C213: CD A3 C3    call change_attribute_everywhere_C3A3
C216: 3A 00 B8    ld   a,(io_read_shit_B800)
C219: 21 00 48    ld   hl,$4800
C21C: 11 00 90    ld   de,$9000
C21F: 01 00 04    ld   bc,$0400
C222: ED B0       ldir
C224: 21 62 93    ld   hl,$9362
C227: CD 38 C3    call $C338
C22A: 21 42 98    ld   hl,$9842
C22D: 06 0F       ld   b,$0F
C22F: CD 61 C3    call $C361
C232: 21 FA 98    ld   hl,$98FA
C235: 06 16       ld   b,$16
C237: CD 6E C3    call $C36E
C23A: 21 5A 98    ld   hl,$985A
C23D: 06 02       ld   b,$02
C23F: CD 6E C3    call $C36E
C242: 3E 3F       ld   a,$3F
C244: 32 77 9A    ld   ($9A77),a
C247: CD DD D0    call $D0DD
C24A: 3A 00 B8    ld   a,(io_read_shit_B800)
C24D: 3A 00 B0    ld   a,($B000)
C250: E6 20       and  $20
C252: FE 20       cp   $20
C254: 20 0F       jr   nz,$C265
C256: 21 32 92    ld   hl,$9232
C259: 3E 34       ld   a,$34
C25B: 06 06       ld   b,$06
C25D: 77          ld   (hl),a
C25E: 11 20 00    ld   de,$0020
C261: 19          add  hl,de
C262: 3C          inc  a
C263: 10 F8       djnz $C25D
C265: CD 0E C3    call $C30E
C268: CD DE F8    call $F8DE
C26B: CD 7E CA    call $CA7E
C26E: CD F3 D0    call $D0F3
C271: C9          ret
C272: CD CD C3    call $C3CD
C275: 3E 3F       ld   a,$3F
C277: CD A3 C3    call change_attribute_everywhere_C3A3
C27A: 3A 00 B8    ld   a,(io_read_shit_B800)
C27D: 21 00 44    ld   hl,$4400
C280: 11 00 90    ld   de,$9000
C283: 01 00 04    ld   bc,$0400
C286: ED B0       ldir
C288: 21 82 91    ld   hl,$9182
C28B: CD 38 C3    call $C338
C28E: 21 82 98    ld   hl,$9882
C291: 06 07       ld   b,$07
C293: CD 61 C3    call $C361
C296: 21 A2 9A    ld   hl,$9AA2
C299: 06 09       ld   b,$09
C29B: CD 61 C3    call $C361
C29E: 3E BE       ld   a,$BE
C2A0: 32 0E 93    ld   ($930E),a
C2A3: 3C          inc  a
C2A4: 32 0F 93    ld   ($930F),a
C2A7: 3E 24       ld   a,$24
C2A9: 21 2C 9B    ld   hl,$9B2C
C2AC: 11 1E 00    ld   de,$001E
C2AF: 06 03       ld   b,$03
C2B1: 77          ld   (hl),a
C2B2: 23          inc  hl
C2B3: 77          ld   (hl),a
C2B4: 23          inc  hl
C2B5: 77          ld   (hl),a
C2B6: 19          add  hl,de
C2B7: 10 F8       djnz $C2B1
C2B9: CD DD D0    call $D0DD
C2BC: 3A 00 B8    ld   a,(io_read_shit_B800)
C2BF: CD 0E C3    call $C30E
C2C2: CD DE F8    call $F8DE
C2C5: CD 7E CA    call $CA7E
C2C8: C9          ret

display_maze_C2C9:
C2C9: CD CD C3    call $C3CD
C2CC: 3E 3F       ld   a,$3F
C2CE: CD A3 C3    call change_attribute_everywhere_C3A3
C2D1: 3A 00 B8    ld   a,(io_read_shit_B800)
C2D4: 21 00 40    ld   hl,$4000
C2D7: 11 00 90    ld   de,$9000
C2DA: 01 00 04    ld   bc,$0400
C2DD: ED B0       ldir
C2DF: 21 82 91    ld   hl,$9182
C2E2: CD 38 C3    call $C338
C2E5: 21 42 98    ld   hl,$9842
C2E8: 06 07       ld   b,$07
C2EA: CD 61 C3    call $C361
C2ED: 21 C2 9A    ld   hl,$9AC2
C2F0: 06 07       ld   b,$07
C2F2: CD 61 C3    call $C361
C2F5: CD DD D0    call $D0DD
C2F8: 3A 00 B8    ld   a,(io_read_shit_B800)
C2FB: CD 0E C3    call $C30E
C2FE: CD DE F8    call $F8DE
C301: CD 7E CA    call $CA7E
C304: 3A 10 62    ld   a,(must_play_music_6210)
C307: FE 00       cp   $00
C309: C8          ret  z
C30A: CD F3 D0    call $D0F3
C30D: C9          ret
C30E: 21 86 65    ld   hl,unknown_6586
C311: AF          xor  a
C312: 77          ld   (hl),a
C313: C9          ret

init_guard_directions_and_wagons_C314:
C314: 3E 01       ld   a,$01
C316: 32 1A 60    ld   (unknown_601A),a
C319: 32 1B 60    ld   (unknown_601B),a
C31C: 3E 80       ld   a,$80
C31E: 32 27 60    ld   (guard_1_direction_6027),a
C321: 3E 40       ld   a,$40
C323: 32 67 60    ld   (guard_2_direction_6067),a
C326: 21 1B 1A    ld   hl,$1A1B
C329: 3A 00 B8    ld   a,(io_read_shit_B800)
C32C: 11 88 65    ld   de,wagon_1_struct_6588
C32F: 01 14 00    ld   bc,$0014
C332: ED B0       ldir
C334: CD A3 F9    call $F9A3
C337: C9          ret
C338: 3E 55       ld   a,$55
C33A: 77          ld   (hl),a
C33B: 23          inc  hl
C33C: 3E 51       ld   a,$51
C33E: 77          ld   (hl),a
C33F: 23          inc  hl
C340: 3E 57       ld   a,$57
C342: 77          ld   (hl),a
C343: 11 1F 00    ld   de,$001F
C346: 19          add  hl,de
C347: 3E 52       ld   a,$52
C349: 77          ld   (hl),a
C34A: 2B          dec  hl
C34B: 3E 56       ld   a,$56
C34D: 77          ld   (hl),a
C34E: 7C          ld   a,h
C34F: C6 08       add  a,$08
C351: 67          ld   h,a
C352: 3E 32       ld   a,$32
C354: 77          ld   (hl),a
C355: 23          inc  hl
C356: 77          ld   (hl),a
C357: 11 E1 FF    ld   de,$FFE1
C35A: 19          add  hl,de
C35B: 77          ld   (hl),a
C35C: 2B          dec  hl
C35D: 77          ld   (hl),a
C35E: 2B          dec  hl
C35F: 77          ld   (hl),a
C360: C9          ret
C361: 3E 38       ld   a,$38
C363: 18 01       jr   $C366
C365: C9          ret
C366: 11 20 00    ld   de,$0020
C369: 77          ld   (hl),a
C36A: 19          add  hl,de
C36B: 10 FC       djnz $C369
C36D: C9          ret
C36E: 3E 2F       ld   a,$2F
C370: 18 F4       jr   $C366
C372: C9          ret
C373: C5          push bc
C374: 01 E0 FF    ld   bc,$FFE0
C377: 77          ld   (hl),a
C378: 09          add  hl,bc
C379: C1          pop  bc
C37A: 10 F7       djnz $C373
C37C: C9          ret
C37D: 77          ld   (hl),a
C37E: 23          inc  hl
C37F: 10 FC       djnz $C37D
C381: C9          ret
C382: 06 08       ld   b,$08
C384: 21 00 60    ld   hl,number_of_credits_6000
C387: AF          xor  a
C388: 4F          ld   c,a
C389: 77          ld   (hl),a
C38A: 23          inc  hl
C38B: 0D          dec  c
C38C: 20 FB       jr   nz,$C389
C38E: 10 F8       djnz $C388
C390: C3 03 C0    jp   $C003
C393: 06 08       ld   b,$08
C395: 21 00 60    ld   hl,number_of_credits_6000
C398: 4F          ld   c,a
C399: 77          ld   (hl),a
C39A: 23          inc  hl
C39B: 0D          dec  c
C39C: 20 FB       jr   nz,$C399
C39E: 10 F8       djnz $C398
C3A0: C3 06 C0    jp   $C006

change_attribute_everywhere_C3A3:
C3A3: 06 08       ld   b,$08
C3A5: 21 00 98    ld   hl,$9800
C3A8: 0E 00       ld   c,$00
C3AA: 77          ld   (hl),a
C3AB: 23          inc  hl
C3AC: F5          push af
C3AD: 3A 00 B8    ld   a,(io_read_shit_B800)
C3B0: F1          pop  af
C3B1: 0D          dec  c
C3B2: 20 F6       jr   nz,$C3AA
C3B4: 10 F2       djnz $C3A8
C3B6: C9          ret

clear_screen_C3B7:
C3B7: 06 04       ld   b,$04
C3B9: 3E E0       ld   a,$E0
C3BB: 21 00 90    ld   hl,$9000
C3BE: 0E 00       ld   c,$00
C3C0: 77          ld   (hl),a
C3C1: 23          inc  hl
C3C2: F5          push af
C3C3: 3A 00 B8    ld   a,(io_read_shit_B800)
C3C6: F1          pop  af
C3C7: 0D          dec  c
C3C8: 20 F6       jr   nz,$C3C0
C3CA: 10 F2       djnz $C3BE
C3CC: C9          ret
C3CD: 3E E0       ld   a,$E0
C3CF: 3E E0       ld   a,$E0
C3D1: 21 E4 93    ld   hl,$93E4
C3D4: 06 1B       ld   b,$1B
C3D6: E5          push hl
C3D7: C5          push bc
C3D8: 06 20       ld   b,$20
C3DA: CD 73 C3    call $C373
C3DD: C1          pop  bc
C3DE: E1          pop  hl
C3DF: 23          inc  hl
C3E0: 10 F4       djnz $C3D6
C3E2: C9          ret
C3E3: 3E 00       ld   a,$00
C3E5: 32 03 A0    ld   ($A003),a
C3E8: 06 04       ld   b,$04
C3EA: 3E E0       ld   a,$E0
C3EC: 21 00 90    ld   hl,$9000
C3EF: CD BE C3    call $C3BE
C3F2: 3E 3F       ld   a,$3F
C3F4: CD A3 C3    call change_attribute_everywhere_C3A3
C3F7: 3A 8C 62    ld   a,(unknown_628C)
C3FA: FE 01       cp   $01
C3FC: 28 09       jr   z,$C407
C3FE: 11 C3 56    ld   de,$56C3
C401: 21 AF 93    ld   hl,$93AF
C404: CD 67 CA    call display_localized_text_CA67
C407: 06 01       ld   b,$01
C409: 21 80 65    ld   hl,player_struct_6580
C40C: 3E 00       ld   a,$00
C40E: CD A8 C3    call $C3A8
C411: CD 7E CA    call $CA7E
C414: 3E 01       ld   a,$01
C416: 32 03 A0    ld   ($A003),a
C419: C9          ret
C41A: DD 21 76 61 ld   ix,player_1_score_6176
C41E: 06 07       ld   b,$07
C420: AF          xor  a
C421: 00          nop
C422: DD 23       inc  ix
C424: 10 FB       djnz $C421
C426: C9          ret
C427: 3A 63 61    ld   a,(flipped_dip_switches_copy_6163)
C42A: E6 80       and  $80
C42C: FE 00       cp   $00
C42E: 28 09       jr   z,$C439
C430: 3A 7C 61    ld   a,(current_player_617C)
C433: 2F          cpl
C434: E6 01       and  $01
C436: CD E2 D8    call $D8E2
C439: DD 21 9C 60 ld   ix,bags_coordinates_609C
C43D: FD 21 7F 61 ld   iy,bags_coordinates_617F
C441: 06 3B       ld   b,$3B
C443: CD 7E C4    call $C47E
C446: DD 21 C4 61 ld   ix,barrow_screen_params_61C4
C44A: FD 21 FA 61 ld   iy,unknown_screen_address_61FA
C44E: 06 03       ld   b,$03
C450: CD 7E C4    call $C47E
C453: 3A 56 60    ld   a,(lives_6056)
C456: F5          push af
C457: 3A 7E 61    ld   a,(unknown_617E)
C45A: 32 56 60    ld   (lives_6056),a
C45D: F1          pop  af
C45E: 32 7E 61    ld   (unknown_617E),a
C461: 3A 90 62    ld   a,(unknown_6290)
C464: F5          push af
C465: 3A 7D 62    ld   a,(unknown_627D)
C468: 32 90 62    ld   (unknown_6290),a
C46B: F1          pop  af
C46C: 32 7D 62    ld   (unknown_627D),a
C46F: 3A 41 63    ld   a,(unknown_6341)
C472: F5          push af
C473: 3A 40 63    ld   a,(unknown_6340)
C476: 32 41 63    ld   (unknown_6341),a
C479: F1          pop  af
C47A: 32 40 63    ld   (unknown_6340),a
C47D: C9          ret
C47E: DD 7E 00    ld   a,(ix+$00)
C481: F5          push af
C482: FD 7E 00    ld   a,(iy+$00)
C485: DD 77 00    ld   (ix+$00),a
C488: F1          pop  af
C489: FD 77 00    ld   (iy+$00),a
C48C: DD 23       inc  ix
C48E: FD 23       inc  iy
C490: 10 EC       djnz $C47E
C492: C9          ret

guard_collision_with_pick_C493:
C493: 0E 0B       ld   c,$0B
C495: 06 07       ld   b,$07
C497: DD 7E 03    ld   a,(ix+$03)
C49A: C6 03       add  a,$03
C49C: 91          sub  c
C49D: FD BE 03    cp   (iy+$03)
C4A0: 28 06       jr   z,$C4A8
C4A2: 0C          inc  c
C4A3: 10 F2       djnz $C497
C4A5: 3E 00       ld   a,$00
C4A7: C9          ret
C4A8: DD 7E 02    ld   a,(ix+$02)
C4AB: C6 08       add  a,$08
C4AD: FD BE 02    cp   (iy+$02)
C4B0: 38 F3       jr   c,$C4A5
C4B2: D6 0F       sub  $0F
C4B4: FD BE 02    cp   (iy+$02)
C4B7: 30 EC       jr   nc,$C4A5
C4B9: 3E 01       ld   a,$01
C4BB: C9          ret

guard_wait_for_elevator_test_C4BC:
C4BC: 3A 98 60    ld   a,(current_guard_screen_index_6098)
C4BF: FE 05       cp   $05
C4C1: CA B7 D9    jp   z,$D9B7
C4C4: 47          ld   b,a
C4C5: 3A 0D 60    ld   a,(player_screen_600D)
C4C8: B8          cp   b
C4C9: C2 CB C5    jp   nz,$C5CB
C4CC: E5          push hl
C4CD: FD E5       push iy
C4CF: FD 21 D1 1B ld   iy,$1BD1
C4D3: FD 7E 00    ld   a,(iy+$00)
C4D6: 67          ld   h,a
C4D7: FD 7E 01    ld   a,(iy+$01)
C4DA: 6F          ld   l,a
C4DB: AF          xor  a
C4DC: ED 52       sbc  hl,de
C4DE: 28 18       jr   z,$C4F8
C4E0: FD 23       inc  iy
C4E2: FD 23       inc  iy
C4E4: FD 23       inc  iy
C4E6: FD 7E 02    ld   a,(iy+$02)
C4E9: FE FF       cp   $FF
C4EB: 20 E6       jr   nz,$C4D3
C4ED: 2A 46 61    ld   hl,(unknown_pointer_6146)
C4F0: AF          xor  a
C4F1: 77          ld   (hl),a
C4F2: FD E1       pop  iy
C4F4: E1          pop  hl
C4F5: C3 5A C5    jp   $C55A
C4F8: 3E 01       ld   a,$01
C4FA: 2A 46 61    ld   hl,(unknown_pointer_6146)
C4FD: 7E          ld   a,(hl)
C4FE: FE 00       cp   $00
C500: C2 F2 C4    jp   nz,$C4F2
C503: CD 97 C5    call $C597
C506: FD E1       pop  iy
C508: 47          ld   b,a
C509: FD 7E 03    ld   a,(iy+$03)
C50C: B8          cp   b
C50D: CA 8C C5    jp   z,$C58C
C510: 2A 46 61    ld   hl,(unknown_pointer_6146)
C513: 23          inc  hl
C514: 23          inc  hl
C515: 23          inc  hl
C516: 23          inc  hl
C517: 3E 01       ld   a,$01
C519: 77          ld   (hl),a
C51A: E1          pop  hl
C51B: D5          push de
C51C: 11 1C 00    ld   de,$001C
C51F: 19          add  hl,de
C520: D1          pop  de
C521: AF          xor  a
C522: 77          ld   (hl),a
C523: DD 7E 07    ld   a,(ix+$07)
C526: 3D          dec  a
C527: FD BE 03    cp   (iy+$03)
C52A: 28 0C       jr   z,$C538
C52C: 3D          dec  a
C52D: FD BE 03    cp   (iy+$03)
C530: 28 06       jr   z,$C538
C532: 2A 95 60    ld   hl,(guard_direction_pointer_6095)
C535: AF          xor  a
C536: 77          ld   (hl),a
C537: C9          ret
C538: 3A 98 60    ld   a,(current_guard_screen_index_6098)
C53B: FE 05       cp   $05
C53D: C8          ret  z
C53E: 2A 46 61    ld   hl,(unknown_pointer_6146)
C541: 23          inc  hl
C542: 23          inc  hl
C543: 23          inc  hl
C544: 23          inc  hl
C545: AF          xor  a
C546: 77          ld   (hl),a
C547: DD 7E 06    ld   a,(ix+$06)
C54A: 2A 95 60    ld   hl,(guard_direction_pointer_6095)
C54D: FD BE 02    cp   (iy+$02)
C550: 30 04       jr   nc,$C556
C552: 3E 40       ld   a,$40
C554: 77          ld   (hl),a
C555: C9          ret
C556: 3E 80       ld   a,$80
C558: 77          ld   (hl),a
C559: C9          ret
C55A: 7E          ld   a,(hl)
C55B: FE 01       cp   $01
C55D: 28 09       jr   z,$C568
C55F: 2A 46 61    ld   hl,(unknown_pointer_6146)
C562: 23          inc  hl
C563: 23          inc  hl
C564: 23          inc  hl
C565: 23          inc  hl
C566: 77          ld   (hl),a
C567: C9          ret
C568: 2A 46 61    ld   hl,(unknown_pointer_6146)
C56B: 3E 01       ld   a,$01
C56D: 77          ld   (hl),a
C56E: CD 97 C5    call $C597
C571: 47          ld   b,a
C572: FD 7E 03    ld   a,(iy+$03)
C575: B8          cp   b
C576: 28 15       jr   z,$C58D
C578: 23          inc  hl
C579: 23          inc  hl
C57A: 23          inc  hl
C57B: 23          inc  hl
C57C: 3E 01       ld   a,$01
C57E: 77          ld   (hl),a
C57F: 3E C0       ld   a,$C0
C581: FD 77 02    ld   (iy+$02),a
C584: 18 00       jr   $C586
C586: 2A 95 60    ld   hl,(guard_direction_pointer_6095)
C589: AF          xor  a
C58A: 77          ld   (hl),a
C58B: C9          ret
C58C: E1          pop  hl
C58D: 2A 46 61    ld   hl,(unknown_pointer_6146)
C590: 23          inc  hl
C591: 23          inc  hl
C592: 23          inc  hl
C593: 23          inc  hl
C594: AF          xor  a
C595: 77          ld   (hl),a
C596: C9          ret
C597: 3A 99 99    ld   a,($9999)
C59A: 3A 98 60    ld   a,(current_guard_screen_index_6098)
C59D: FE 04       cp   $04
C59F: 28 03       jr   z,$C5A4
C5A1: FE 05       cp   $05
C5A3: C8          ret  z
C5A4: DD 7E 02    ld   a,(ix+$02)
C5A7: FE C0       cp   $C0
C5A9: 06 80       ld   b,$80
C5AB: 30 02       jr   nc,$C5AF
C5AD: 06 40       ld   b,$40
C5AF: DD 7E 03    ld   a,(ix+$03)
C5B2: FE 68       cp   $68
C5B4: 3E 18       ld   a,$18
C5B6: 38 0C       jr   c,$C5C4
C5B8: DD 7E 03    ld   a,(ix+$03)
C5BB: FE C0       cp   $C0
C5BD: 3E 71       ld   a,$71
C5BF: 38 03       jr   c,$C5C4
C5C1: 3E E1       ld   a,$E1
C5C3: C9          ret
C5C4: E5          push hl
C5C5: 2A 95 60    ld   hl,(guard_direction_pointer_6095)
C5C8: 70          ld   (hl),b
C5C9: E1          pop  hl
C5CA: C9          ret
C5CB: 2A 46 61    ld   hl,(unknown_pointer_6146)
C5CE: 23          inc  hl
C5CF: 23          inc  hl
C5D0: 23          inc  hl
C5D1: 23          inc  hl
C5D2: AF          xor  a
C5D3: 77          ld   (hl),a
C5D4: C9          ret
C5D5: 21 00 05    ld   hl,$0500
C5D8: FB          ei
C5D9: 06 FF       ld   b,$FF
C5DB: 3A 00 60    ld   a,(number_of_credits_6000)
C5DE: FE 00       cp   $00
C5E0: C0          ret  nz
C5E1: 3A 00 B8    ld   a,(io_read_shit_B800)
C5E4: FB          ei
C5E5: 10 F4       djnz $C5DB
C5E7: 2B          dec  hl
C5E8: 7C          ld   a,h
C5E9: FE 00       cp   $00
C5EB: C8          ret  z
C5EC: 18 EB       jr   $C5D9

compute_guard_speed_from_dipsw_C5EE:
C5EE: 3A ED 61    ld   a,(check_scenery_disabled_61ED)
C5F1: FE 01       cp   $01
C5F3: 3E 00       ld   a,$00
C5F5: 28 22       jr   z,$C619
C5F7: 3A 78 61    ld   a,(score_ten_thousands_player_1_6178)
C5FA: 47          ld   b,a
C5FB: 3A 7C 61    ld   a,(current_player_617C)
C5FE: FE 01       cp   $01
C600: 20 04       jr   nz,$C606
C602: 3A 7B 61    ld   a,(score_ten_thousands_player_2_617B)
C605: 47          ld   b,a
C606: 3A 00 B0    ld   a,($B000)
C609: CB 1F       rr   a
C60B: CB 1F       rr   a
C60D: CB 1F       rr   a
C60F: 2F          cpl
C610: E6 03       and  $03
C612: 80          add  a,b
C613: 06 00       ld   b,$00
C615: CD 1D C6    call $C61D
C618: 78          ld   a,b
C619: 32 64 61    ld   (guard_speed_6164),a
C61C: C9          ret
C61D: FE 01       cp   $01
C61F: D8          ret  c
C620: 06 02       ld   b,$02
C622: FE 02       cp   $02
C624: D8          ret  c
C625: 06 04       ld   b,$04
C627: FE 03       cp   $03
C629: D8          ret  c
C62A: 06 05       ld   b,$05
C62C: FE 04       cp   $04
C62E: D8          ret  c
C62F: 06 09       ld   b,$09
C631: FE 05       cp   $05
C633: D8          ret  c
C634: C3 00 FF    jp   $FF00
C637: DD 21 94 65 ld   ix,guard_1_struct_6594
C63B: FD 21 9C 65 ld   iy,object_held_struct_659C
C63F: CD 93 C4    call guard_collision_with_pick_C493
C642: FE 01       cp   $01
C644: 20 0F       jr   nz,$C655
C646: 3A 58 61    ld   a,(has_bag_6158)
C649: FE 01       cp   $01
C64B: 28 08       jr   z,$C655
C64D: 3E 01       ld   a,$01
C64F: 32 37 60    ld   (guard_1_in_elevator_6037),a
C652: 32 08 62    ld   (unknown_6208),a
C655: DD 21 98 65 ld   ix,guard_2_struct_6598
C659: FD 21 9C 65 ld   iy,object_held_struct_659C
C65D: CD 93 C4    call guard_collision_with_pick_C493
C660: FE 01       cp   $01
C662: 20 0F       jr   nz,$C673
C664: 3A 58 61    ld   a,(has_bag_6158)
C667: FE 01       cp   $01
C669: 28 08       jr   z,$C673
C66B: 3E 01       ld   a,$01
C66D: 32 77 60    ld   (guard_2_in_elevator_6077),a
C670: 32 09 62    ld   (unknown_6209),a
C673: C9          ret
C674: 3A 10 62    ld   a,(must_play_music_6210)
C677: FE 01       cp   $01
C679: C0          ret  nz
C67A: FD 21 76 61 ld   iy,player_1_score_6176
C67E: CD 46 C7    call $C746
C681: 78          ld   a,b
C682: FE 05       cp   $05
C684: 38 0B       jr   c,$C691
C686: FD 21 79 61 ld   iy,player_2_score_6179
C68A: CD 46 C7    call $C746
C68D: 78          ld   a,b
C68E: FE 05       cp   $05
C690: D0          ret  nc
C691: CD 98 FB    call prepare_cleared_screen_FB98
C694: CD 69 C9    call $C969
C697: 3A 6C 62    ld   a,(unknown_626C)
C69A: FE 01       cp   $01
C69C: CC 27 C4    call z,$C427
C69F: CD FB C8    call $C8FB
C6A2: 3E 01       ld   a,$01
C6A4: CD E2 D8    call $D8E2
C6A7: FD 21 76 61 ld   iy,player_1_score_6176
C6AB: CD 46 C7    call $C746
C6AE: 78          ld   a,b
C6AF: FE 05       cp   $05
C6B1: D2 DF C6    jp   nc,$C6DF
C6B4: DD 23       inc  ix
C6B6: DD 23       inc  ix
C6B8: DD 23       inc  ix
C6BA: D5          push de
C6BB: 11 F0 FF    ld   de,$FFF0
C6BE: DD 19       add  ix,de
C6C0: D1          pop  de
C6C1: DD E5       push ix
C6C3: 23          inc  hl
C6C4: 23          inc  hl
C6C5: E5          push hl
C6C6: CD 72 C7    call $C772
C6C9: 3E 60       ld   a,$60
C6CB: 32 E8 61    ld   (time_61E8),a
C6CE: E1          pop  hl
C6CF: CD FB C8    call $C8FB
C6D2: DD E1       pop  ix
C6D4: 3E 01       ld   a,$01
C6D6: 32 79 62    ld   (unknown_6279),a
C6D9: CD C6 C7    call $C7C6
C6DC: CD FB C8    call $C8FB
C6DF: 3A 7D 61    ld   a,(unknown_617D)
C6E2: FE 01       cp   $01
C6E4: 28 58       jr   z,$C73E
C6E6: 3A 00 B0    ld   a,($B000)
C6E9: E6 80       and  $80
C6EB: FE 80       cp   $80
C6ED: 28 05       jr   z,$C6F4
C6EF: 3E 00       ld   a,$00
C6F1: CD E2 D8    call $D8E2
C6F4: 3A 26 60    ld   a,(player_input_6026)
C6F7: E6 80       and  $80
C6F9: FE 80       cp   $80
C6FB: 28 F7       jr   z,$C6F4
C6FD: FD 21 79 61 ld   iy,player_2_score_6179
C701: CD 46 C7    call $C746
C704: 78          ld   a,b
C705: FE 05       cp   $05
C707: 30 35       jr   nc,$C73E
C709: CD FB C8    call $C8FB
C70C: DD 23       inc  ix
C70E: DD 23       inc  ix
C710: DD 23       inc  ix
C712: D5          push de
C713: 11 F0 FF    ld   de,$FFF0
C716: DD 19       add  ix,de
C718: D1          pop  de
C719: DD E5       push ix
C71B: 23          inc  hl
C71C: 23          inc  hl
C71D: E5          push hl
C71E: CD 72 C7    call $C772
C721: 3E 60       ld   a,$60
C723: 32 E8 61    ld   (time_61E8),a
C726: E1          pop  hl
C727: CD FB C8    call $C8FB
C72A: DD E1       pop  ix
C72C: 3E 00       ld   a,$00
C72E: 32 79 62    ld   (unknown_6279),a
C731: CD 87 C8    call $C887
C734: CD 87 C8    call $C887
C737: CD 87 C8    call $C887
C73A: CD C6 C7    call $C7C6
C73D: C9          ret
C73E: AF          xor  a
C73F: 32 67 62    ld   (unknown_6267),a
C742: 32 03 A0    ld   ($A003),a
C745: C9          ret
C746: DD 21 17 62 ld   ix,high_score_table_6217
C74A: 11 10 00    ld   de,$0010
C74D: 21 0F 92    ld   hl,$920F
C750: 06 05       ld   b,$05
C752: FD 7E 02    ld   a,(iy+$02)
C755: DD BE 02    cp   (ix+$02)
C758: D8          ret  c
C759: 20 10       jr   nz,$C76B
C75B: FD 7E 01    ld   a,(iy+$01)
C75E: DD BE 01    cp   (ix+$01)
C761: D8          ret  c
C762: 20 07       jr   nz,$C76B
C764: FD 7E 00    ld   a,(iy+$00)
C767: DD BE 00    cp   (ix+$00)
C76A: D8          ret  c
C76B: DD 19       add  ix,de
C76D: 2B          dec  hl
C76E: 2B          dec  hl
C76F: 10 E1       djnz $C752
C771: C9          ret
C772: C5          push bc
C773: DD 21 17 62 ld   ix,high_score_table_6217
C777: 78          ld   a,b
C778: FE 04       cp   $04
C77A: 30 11       jr   nc,$C78D
C77C: C5          push bc
C77D: 06 10       ld   b,$10
C77F: DD 7E 10    ld   a,(ix+$10)
C782: DD 77 00    ld   (ix+$00),a
C785: DD 23       inc  ix
C787: 10 F6       djnz $C77F
C789: C1          pop  bc
C78A: 04          inc  b
C78B: 18 EA       jr   $C777
C78D: C1          pop  bc
C78E: DD 21 17 62 ld   ix,high_score_table_6217
C792: 78          ld   a,b
C793: FE 04       cp   $04
C795: 30 05       jr   nc,$C79C
C797: DD 19       add  ix,de
C799: 04          inc  b
C79A: 18 F6       jr   $C792
C79C: FD 7E 00    ld   a,(iy+$00)
C79F: DD 77 00    ld   (ix+$00),a
C7A2: FD 7E 01    ld   a,(iy+$01)
C7A5: DD 77 01    ld   (ix+$01),a
C7A8: FD 7E 02    ld   a,(iy+$02)
C7AB: DD 77 02    ld   (ix+$02),a
C7AE: C5          push bc
C7AF: 06 0D       ld   b,$0D
C7B1: DD E5       push ix
C7B3: DD 23       inc  ix
C7B5: DD 23       inc  ix
C7B7: DD 23       inc  ix
C7B9: 3E 10       ld   a,$10
C7BB: DD 77 00    ld   (ix+$00),a
C7BE: DD 23       inc  ix
C7C0: 10 F9       djnz $C7BB
C7C2: DD E1       pop  ix
C7C4: C1          pop  bc
C7C5: C9          ret
C7C6: 06 11       ld   b,$11
C7C8: 3E 00       ld   a,$00
C7CA: 32 78 62    ld   (high_score_joystick_input_6278),a
C7CD: 3A 79 62    ld   a,(unknown_6279)
C7D0: FE 01       cp   $01
C7D2: 20 05       jr   nz,$C7D9
C7D4: CD 0A CA    call $CA0A
C7D7: 18 0C       jr   $C7E5
C7D9: 3A 00 B0    ld   a,($B000)
C7DC: E6 80       and  $80
C7DE: FE 80       cp   $80
C7E0: 28 F2       jr   z,$C7D4
C7E2: CD 26 CA    call $CA26
C7E5: 3A 78 62    ld   a,(high_score_joystick_input_6278)
C7E8: E6 10       and  $10
C7EA: FE 10       cp   $10
C7EC: CC 20 C8    call z,$C820
C7EF: 3A 78 62    ld   a,(high_score_joystick_input_6278)
C7F2: E6 08       and  $08
C7F4: FE 08       cp   $08
C7F6: CC 2F C8    call z,$C82F
C7F9: 3A 78 62    ld   a,(high_score_joystick_input_6278)
C7FC: E6 40       and  $40
C7FE: FE 40       cp   $40
C800: CC 3E C8    call z,$C83E
C803: 3A 78 62    ld   a,(high_score_joystick_input_6278)
C806: E6 20       and  $20
C808: FE 20       cp   $20
C80A: CC 5C C8    call z,$C85C
C80D: 3A 78 62    ld   a,(high_score_joystick_input_6278)
C810: E6 80       and  $80
C812: FE 80       cp   $80
C814: C8          ret  z
C815: 3A E8 61    ld   a,(time_61E8)
C818: FE 00       cp   $00
C81A: C8          ret  z
C81B: CD 78 C8    call $C878
C81E: 18 AD       jr   $C7CD
C820: 78          ld   a,b
C821: FE 2A       cp   $2A
C823: 20 02       jr   nz,$C827
C825: 06 10       ld   b,$10
C827: 04          inc  b
C828: CD 78 C8    call $C878
C82B: CD 87 C8    call $C887
C82E: C9          ret
C82F: 78          ld   a,b
C830: FE 10       cp   $10
C832: 20 02       jr   nz,$C836
C834: 06 2B       ld   b,$2B
C836: 05          dec  b
C837: CD 78 C8    call $C878
C83A: CD 87 C8    call $C887
C83D: C9          ret
C83E: 7D          ld   a,l
C83F: E6 F0       and  $F0
C841: FE 00       cp   $00
C843: 20 04       jr   nz,$C849
C845: 7C          ld   a,h
C846: FE 92       cp   $92
C848: C8          ret  z
C849: 06 10       ld   b,$10
C84B: CD 78 C8    call $C878
C84E: 11 20 00    ld   de,$0020
C851: 19          add  hl,de
C852: DD 2B       dec  ix
C854: 46          ld   b,(hl)
C855: CD 78 C8    call $C878
C858: CD 87 C8    call $C887
C85B: C9          ret
C85C: 7D          ld   a,l
C85D: E6 F0       and  $F0
C85F: FE C0       cp   $C0
C861: 20 04       jr   nz,$C867
C863: 7C          ld   a,h
C864: FE 91       cp   $91
C866: C8          ret  z
C867: 11 20 00    ld   de,$0020
C86A: AF          xor  a
C86B: ED 52       sbc  hl,de
C86D: DD 23       inc  ix
C86F: 06 11       ld   b,$11
C871: CD 78 C8    call $C878
C874: CD 87 C8    call $C887
C877: C9          ret
C878: 78          ld   a,b
C879: DD 77 00    ld   (ix+$00),a
C87C: 77          ld   (hl),a
C87D: E5          push hl
C87E: 7C          ld   a,h
C87F: C6 08       add  a,$08
C881: 67          ld   h,a
C882: 3E 04       ld   a,$04
C884: 77          ld   (hl),a
C885: E1          pop  hl
C886: C9          ret
C887: C5          push bc
C888: F5          push af
C889: E5          push hl
C88A: 06 70       ld   b,$70
C88C: 21 00 03    ld   hl,$0300
C88F: 2B          dec  hl
C890: 7C          ld   a,h
C891: FE 00       cp   $00
C893: 20 FA       jr   nz,$C88F
C895: 10 F5       djnz $C88C
C897: E1          pop  hl
C898: F1          pop  af
C899: C1          pop  bc
C89A: C9          ret
C89B: 21 25 93    ld   hl,$9325
C89E: 11 4F 57    ld   de,$574F
C8A1: CD 67 CA    call display_localized_text_CA67
C8A4: 21 05 92    ld   hl,$9205
C8A7: 11 55 57    ld   de,$5755
C8AA: CD 67 CA    call display_localized_text_CA67
C8AD: 21 E3 92    ld   hl,$92E3
C8B0: 11 90 56    ld   de,$5690
C8B3: CD 67 CA    call display_localized_text_CA67
C8B6: 21 83 98    ld   hl,$9883
C8B9: 3E 0E       ld   a,$0E
C8BB: CD 05 56    call write_attribute_on_line_5605
C8BE: 11 00 4D    ld   de,$4D00
C8C1: 21 82 93    ld   hl,$9382
C8C4: 3E 12       ld   a,$12
C8C6: 08          ex   af,af'
C8C7: CD F0 55    call $55F0
C8CA: 11 1B 4D    ld   de,$4D1B
C8CD: 21 90 93    ld   hl,$9390
C8D0: 3E 12       ld   a,$12
C8D2: 08          ex   af,af'
C8D3: CD F0 55    call $55F0
C8D6: 06 0D       ld   b,$0D
C8D8: 3E 8B       ld   a,$8B
C8DA: 21 83 93    ld   hl,$9383
C8DD: CD EB C8    call $C8EB
C8E0: 3E 8E       ld   a,$8E
C8E2: 06 0D       ld   b,$0D
C8E4: 21 63 90    ld   hl,$9063
C8E7: CD EB C8    call $C8EB
C8EA: C9          ret
C8EB: 77          ld   (hl),a
C8EC: E5          push hl
C8ED: F5          push af
C8EE: 7C          ld   a,h
C8EF: C6 08       add  a,$08
C8F1: 67          ld   h,a
C8F2: 3E 10       ld   a,$10
C8F4: 77          ld   (hl),a
C8F5: F1          pop  af
C8F6: E1          pop  hl
C8F7: 23          inc  hl
C8F8: 10 F1       djnz $C8EB
C8FA: C9          ret
C8FB: DD E5       push ix
C8FD: C5          push bc
C8FE: E5          push hl
C8FF: D5          push de
C900: CD 9B C8    call $C89B
C903: 11 20 00    ld   de,$0020
C906: 21 8F 92    ld   hl,$928F
C909: DD 21 17 62 ld   ix,high_score_table_6217
C90D: 06 05       ld   b,$05
C90F: C5          push bc
C910: E5          push hl
C911: 06 03       ld   b,$03
C913: DD 7E 00    ld   a,(ix+$00)
C916: E6 0F       and  $0F
C918: CD 7C C8    call $C87C
C91B: DD 7E 00    ld   a,(ix+$00)
C91E: 0F          rrca
C91F: 0F          rrca
C920: 0F          rrca
C921: 0F          rrca
C922: E6 0F       and  $0F
C924: 11 20 00    ld   de,$0020
C927: 19          add  hl,de
C928: CD 7C C8    call $C87C
C92B: DD 23       inc  ix
C92D: 19          add  hl,de
C92E: 10 E3       djnz $C913
C930: E1          pop  hl
C931: 2B          dec  hl
C932: 2B          dec  hl
C933: C1          pop  bc
C934: 11 0D 00    ld   de,$000D
C937: DD 19       add  ix,de
C939: 10 D4       djnz $C90F
C93B: 11 20 00    ld   de,$0020
C93E: DD 21 17 62 ld   ix,high_score_table_6217
C942: 21 0F 92    ld   hl,$920F
C945: 06 05       ld   b,$05
C947: C5          push bc
C948: E5          push hl
C949: DD 23       inc  ix
C94B: DD 23       inc  ix
C94D: DD 23       inc  ix
C94F: 06 0D       ld   b,$0D
C951: DD 7E 00    ld   a,(ix+$00)
C954: CD 7C C8    call $C87C
C957: DD 23       inc  ix
C959: ED 52       sbc  hl,de
C95B: 10 F4       djnz $C951
C95D: E1          pop  hl
C95E: 2B          dec  hl
C95F: 2B          dec  hl
C960: C1          pop  bc
C961: 10 E4       djnz $C947
C963: D1          pop  de
C964: E1          pop  hl
C965: C1          pop  bc
C966: DD E1       pop  ix
C968: C9          ret
C969: 3E 01       ld   a,$01
C96B: 32 67 62    ld   (unknown_6267),a
C96E: 21 72 93    ld   hl,$9372
C971: 11 1E 57    ld   de,$571E
C974: CD 67 CA    call display_localized_text_CA67
C977: 21 73 93    ld   hl,$9373
C97A: 11 37 57    ld   de,$5737
C97D: CD 67 CA    call display_localized_text_CA67
C980: 21 7D 93    ld   hl,$937D
C983: 11 75 57    ld   de,$5775
C986: CD 67 CA    call display_localized_text_CA67
C989: 11 00 4D    ld   de,$4D00
C98C: 21 91 93    ld   hl,$9391
C98F: 3E 12       ld   a,$12
C991: 08          ex   af,af'
C992: CD F0 55    call $55F0
C995: 11 1B 4D    ld   de,$4D1B
C998: 21 9E 93    ld   hl,$939E
C99B: 3E 12       ld   a,$12
C99D: 08          ex   af,af'
C99E: CD F0 55    call $55F0
C9A1: 06 0C       ld   b,$0C
C9A3: 21 92 93    ld   hl,$9392
C9A6: 3E 8B       ld   a,$8B
C9A8: CD EB C8    call $C8EB
C9AB: 06 0C       ld   b,$0C
C9AD: 3E 8E       ld   a,$8E
C9AF: 21 72 90    ld   hl,$9072
C9B2: CD EB C8    call $C8EB
C9B5: 11 36 4D    ld   de,$4D36
C9B8: 21 75 92    ld   hl,$9275
C9BB: CD 49 CA    call $CA49
C9BE: 11 4A 4D    ld   de,$4D4A
C9C1: 21 B8 91    ld   hl,$91B8
C9C4: CD 49 CA    call $CA49
C9C7: 11 5E 4D    ld   de,$4D5E
C9CA: 21 9B 92    ld   hl,$929B
C9CD: CD 49 CA    call $CA49
C9D0: 11 72 4D    ld   de,$4D72
C9D3: 21 F8 92    ld   hl,$92F8
C9D6: CD 49 CA    call $CA49
C9D9: 11 86 4D    ld   de,$4D86
C9DC: 21 58 92    ld   hl,$9258
C9DF: CD 42 CA    call $CA42
C9E2: 11 8C 4D    ld   de,$4D8C
C9E5: 21 16 92    ld   hl,$9216
C9E8: CD 42 CA    call $CA42
C9EB: 11 8E 4D    ld   de,$4D8E
C9EE: 21 17 92    ld   hl,$9217
C9F1: CD 42 CA    call $CA42
C9F4: 11 90 4D    ld   de,$4D90
C9F7: 21 19 92    ld   hl,$9219
C9FA: CD 42 CA    call $CA42
C9FD: 11 92 4D    ld   de,$4D92
CA00: 21 1A 92    ld   hl,$921A
CA03: CD 42 CA    call $CA42
CA06: CD 9B C8    call $C89B
CA09: C9          ret
CA0A: AF          xor  a
CA0B: 32 07 A0    ld   ($A007),a
CA0E: 3E 07       ld   a,$07
CA10: D3 08       out  ($08),a
CA12: 3E 38       ld   a,$38
CA14: D3 09       out  ($09),a
CA16: 3E 0E       ld   a,$0E
CA18: D3 08       out  ($08),a
CA1A: DB 0C       in   a,($0C)
CA1C: 2F          cpl
CA1D: 32 78 62    ld   (high_score_joystick_input_6278),a
CA20: 3E 01       ld   a,$01
CA22: 32 07 A0    ld   ($A007),a
CA25: C9          ret
CA26: AF          xor  a
CA27: 32 07 A0    ld   ($A007),a
CA2A: 3E 07       ld   a,$07
CA2C: D3 08       out  ($08),a
CA2E: 3E 38       ld   a,$38
CA30: D3 09       out  ($09),a
CA32: 3E 0F       ld   a,$0F
CA34: D3 08       out  ($08),a
CA36: DB 0C       in   a,($0C)
CA38: 2F          cpl
CA39: 32 78 62    ld   (high_score_joystick_input_6278),a
CA3C: 3E 01       ld   a,$01
CA3E: 32 07 A0    ld   ($A007),a
CA41: C9          ret
CA42: 3E 14       ld   a,$14
CA44: 08          ex   af,af'
CA45: CD F0 55    call $55F0
CA48: C9          ret
CA49: 3E 18       ld   a,$18
CA4B: 08          ex   af,af'
CA4C: CD 53 CA    call $CA53
CA4F: CD F0 55    call $55F0
CA52: C9          ret
CA53: F5          push af
CA54: 3A 00 B0    ld   a,($B000)
CA57: E6 20       and  $20
CA59: FE 20       cp   $20
CA5B: 20 08       jr   nz,$CA65
CA5D: E5          push hl
CA5E: EB          ex   de,hl
CA5F: 11 0A 00    ld   de,$000A
CA62: 19          add  hl,de
CA63: EB          ex   de,hl
CA64: E1          pop  hl
CA65: F1          pop  af
CA66: C9          ret

display_localized_text_CA67:
CA67: F5          push af
CA68: 3A 00 B0    ld   a,($B000)
CA6B: E6 20       and  $20
CA6D: FE 20       cp   $20
CA6F: 28 08       jr   z,$CA79
CA71: E5          push hl
CA72: EB          ex   de,hl
CA73: 11 96 01    ld   de,$0196
CA76: 19          add  hl,de
CA77: EB          ex   de,hl
CA78: E1          pop  hl
CA79: F1          pop  af
CA7A: CD D9 55    call $55D9
CA7D: C9          ret
CA7E: 11 5A 57    ld   de,$575A
CA81: 21 A0 93    ld   hl,$93A0
CA84: CD 67 CA    call display_localized_text_CA67
CA87: 11 63 57    ld   de,$5763
CA8A: 21 20 91    ld   hl,$9120
CA8D: CD 67 CA    call display_localized_text_CA67
CA90: C9          ret
CA91: 3A 26 60    ld   a,(player_input_6026)
CA94: FE A5       cp   $A5
CA96: C0          ret  nz
CA97: 11 58 1A    ld   de,$1A58
CA9A: 21 A2 93    ld   hl,$93A2
CA9D: CD F0 55    call $55F0
CAA0: 11 75 1A    ld   de,$1A75
CAA3: 21 A3 93    ld   hl,$93A3
CAA6: CD F0 55    call $55F0
CAA9: 3E 00       ld   a,$00
CAAB: 18 E4       jr   $CA91
CAAD: DD 21 CC 61 ld   ix,current_pickaxe_screen_params_61CC
CAB1: AF          xor  a
CAB2: DD 77 03    ld   (ix+$03),a
CAB5: 32 E0 61    ld   (pickaxe_timer_duration_61E0),a
CAB8: 32 E1 61    ld   (unknown_61E1),a
CABB: 3E FF       ld   a,$FF
CABD: 32 9F 65    ld   (sprite_object_y_659F),a
CAC0: C9          ret
CAC1: DD 7E 00    ld   a,(ix+$00)
CAC4: 6F          ld   l,a
CAC5: DD 7E 01    ld   a,(ix+$01)
CAC8: 67          ld   h,a
CAC9: 3A 0D 60    ld   a,(player_screen_600D)
CACC: 47          ld   b,a
CACD: DD 7E 02    ld   a,(ix+$02)
CAD0: B8          cp   b
CAD1: C0          ret  nz
CAD2: 3A 41 63    ld   a,(unknown_6341)
CAD5: FE 01       cp   $01
CAD7: 28 47       jr   z,$CB20
CAD9: 3E D0       ld   a,$D0
CADB: 77          ld   (hl),a
CADC: E5          push hl
CADD: CD 14 CB    call $CB14
CAE0: E1          pop  hl
CAE1: 23          inc  hl
CAE2: 7E          ld   a,(hl)
CAE3: FE ED       cp   $ED
CAE5: 28 0C       jr   z,$CAF3
CAE7: FE EF       cp   $EF
CAE9: 28 08       jr   z,$CAF3
CAEB: 3E D1       ld   a,$D1
CAED: 77          ld   (hl),a
CAEE: E5          push hl
CAEF: CD 14 CB    call $CB14
CAF2: E1          pop  hl
CAF3: 11 20 00    ld   de,$0020
CAF6: 19          add  hl,de
CAF7: 7E          ld   a,(hl)
CAF8: FE D1       cp   $D1
CAFA: C8          ret  z
CAFB: FE 67       cp   $67
CAFD: C8          ret  z
CAFE: FE 27       cp   $27
CB00: C8          ret  z
CB01: FE ED       cp   $ED
CB03: C8          ret  z
CB04: FE EF       cp   $EF
CB06: C8          ret  z
CB07: FE DB       cp   $DB
CB09: C8          ret  z
CB0A: FE FD       cp   $FD
CB0C: C8          ret  z
CB0D: 3E D3       ld   a,$D3
CB0F: 77          ld   (hl),a
CB10: CD 14 CB    call $CB14
CB13: C9          ret
CB14: 7C          ld   a,h
CB15: FE 00       cp   $00
CB17: C8          ret  z
CB18: C6 08       add  a,$08
CB1A: 67          ld   h,a
CB1B: 3A 7A 62    ld   a,(bag_color_color_attribute_627A)
CB1E: 77          ld   (hl),a
CB1F: C9          ret
CB20: 23          inc  hl
CB21: 7E          ld   a,(hl)
CB22: FE ED       cp   $ED
CB24: 28 0C       jr   z,$CB32
CB26: FE EF       cp   $EF
CB28: 28 08       jr   z,$CB32
CB2A: 3E C5       ld   a,$C5
CB2C: 77          ld   (hl),a
CB2D: E5          push hl
CB2E: CD 4D CB    call $CB4D
CB31: E1          pop  hl
CB32: 11 20 00    ld   de,$0020
CB35: 19          add  hl,de
CB36: 7E          ld   a,(hl)
CB37: FE D1       cp   $D1
CB39: C8          ret  z
CB3A: FE 67       cp   $67
CB3C: C8          ret  z
CB3D: FE 27       cp   $27
CB3F: C8          ret  z
CB40: FE ED       cp   $ED
CB42: C8          ret  z
CB43: FE EF       cp   $EF
CB45: C8          ret  z
CB46: 3E C7       ld   a,$C7
CB48: 77          ld   (hl),a
CB49: CD 4D CB    call $CB4D
CB4C: C9          ret
CB4D: 7C          ld   a,h
CB4E: FE 00       cp   $00
CB50: C8          ret  z
CB51: C6 08       add  a,$08
CB53: 67          ld   h,a
CB54: 3E 24       ld   a,$24
CB56: 77          ld   (hl),a
CB57: C9          ret
CB58: DD 21 94 65 ld   ix,guard_1_struct_6594
CB5C: 3A 3B 60    ld   a,(guard_1_in_elevator_603B)
CB5F: FE 01       cp   $01
CB61: C8          ret  z
CB62: 3A 56 61    ld   a,(unknown_6156)
CB65: FE 01       cp   $01
CB67: C8          ret  z
CB68: 3A 11 62    ld   a,(unknown_6211)
CB6B: FE 01       cp   $01
CB6D: C8          ret  z
CB6E: CD A2 CB    call $CBA2
CB71: 78          ld   a,b
CB72: 32 99 60    ld   (guard_1_screen_6099),a
CB75: AF          xor  a
CB76: 32 B5 62    ld   (unknown_62B5),a
CB79: 32 B6 62    ld   (unknown_62B6),a
CB7C: C9          ret
CB7D: DD 21 98 65 ld   ix,guard_2_struct_6598
CB81: 3A 7B 60    ld   a,(guard_2_in_elevator_607B)
CB84: FE 01       cp   $01
CB86: C8          ret  z
CB87: 3A 57 61    ld   a,(unknown_6157)
CB8A: FE 01       cp   $01
CB8C: C8          ret  z
CB8D: 3A 12 62    ld   a,(unknown_6212)
CB90: FE 01       cp   $01
CB92: C8          ret  z
CB93: CD A2 CB    call $CBA2
CB96: 78          ld   a,b
CB97: 32 9A 60    ld   (guard_2_screen_609A),a
CB9A: AF          xor  a
CB9B: 32 B9 62    ld   (unknown_62B9),a
CB9E: 32 BA 62    ld   (unknown_62BA),a
CBA1: C9          ret
CBA2: 3E 80       ld   a,$80
CBA4: DD 77 02    ld   (ix+$02),a
CBA7: 3E 10       ld   a,$10
CBA9: DD 77 03    ld   (ix+$03),a
CBAC: 06 03       ld   b,$03
CBAE: 3A 0D 60    ld   a,(player_screen_600D)
CBB1: FE 05       cp   $05
CBB3: C8          ret  z
CBB4: 06 02       ld   b,$02
CBB6: FE 04       cp   $04
CBB8: C8          ret  z
CBB9: 06 01       ld   b,$01
CBBB: FE 03       cp   $03
CBBD: C8          ret  z
CBBE: 06 04       ld   b,$04
CBC0: FE 02       cp   $02
CBC2: C8          ret  z
CBC3: 06 03       ld   b,$03
CBC5: C9          ret
CBC6: 3A F3 61    ld   a,(unknown_61F3)
CBC9: FE 00       cp   $00
CBCB: C8          ret  z
CBCC: 3C          inc  a
CBCD: C5          push bc
CBCE: 47          ld   b,a
CBCF: 3A 75 62    ld   a,(unknown_6275)
CBD2: FE 01       cp   $01
CBD4: 78          ld   a,b
CBD5: C1          pop  bc
CBD6: 20 06       jr   nz,$CBDE
CBD8: FE 30       cp   $30
CBDA: 20 0B       jr   nz,$CBE7
CBDC: 18 02       jr   $CBE0
CBDE: FE 17       cp   $17
CBE0: 20 05       jr   nz,$CBE7
CBE2: 3E 00       ld   a,$00
CBE4: 32 75 62    ld   (unknown_6275),a
CBE7: 32 F3 61    ld   (unknown_61F3),a
CBEA: C9          ret
CBEB: 3A 82 65    ld   a,(player_x_6582)
CBEE: FE E8       cp   $E8
CBF0: 3E 00       ld   a,$00
CBF2: 32 85 62    ld   (unknown_6285),a
CBF5: D4 15 CC    call nc,$CC15
CBF8: 3A 82 65    ld   a,(player_x_6582)
CBFB: FE 10       cp   $10
CBFD: DC 8D CC    call c,$CC8D
CC00: 3E 00       ld   a,$00
CC02: 32 6F 62    ld   (unknown_626F),a
CC05: CD 9F D5    call $D59F
CC08: F3          di
CC09: AF          xor  a
CC0A: 32 00 A0    ld   (interrupt_control_A000),a
CC0D: FB          ei
CC0E: 3E 01       ld   a,$01
CC10: 32 00 A0    ld   (interrupt_control_A000),a
CC13: 00          nop
CC14: C9          ret
CC15: CD CC CD    call $CDCC
CC18: 3A 0D 60    ld   a,(player_screen_600D)
CC1B: FE 01       cp   $01
CC1D: 20 16       jr   nz,$CC35
CC1F: CD 72 C2    call $C272
CC22: 3E 02       ld   a,$02
CC24: 32 0D 60    ld   (player_screen_600D),a
CC27: 3E 11       ld   a,$11
CC29: 32 82 65    ld   (player_x_6582),a
CC2C: CD 72 FD    call draw_object_tiles_FD72
CC2F: CD 1B CE    call $CE1B
CC32: C3 1A CD    jp   $CD1A
CC35: 3A 0D 60    ld   a,(player_screen_600D)
CC38: FE 02       cp   $02
CC3A: 20 16       jr   nz,$CC52
CC3C: CD 0E C2    call $C20E
CC3F: 3E 03       ld   a,$03
CC41: 32 0D 60    ld   (player_screen_600D),a
CC44: CD 72 FD    call draw_object_tiles_FD72
CC47: 3E 11       ld   a,$11
CC49: 32 82 65    ld   (player_x_6582),a
CC4C: CD 1B CE    call $CE1B
CC4F: C3 1A CD    jp   $CD1A
CC52: 3A 0D 60    ld   a,(player_screen_600D)
CC55: FE 03       cp   $03
CC57: 20 16       jr   nz,$CC6F
CC59: CD C1 C1    call $C1C1
CC5C: 3E 04       ld   a,$04
CC5E: 32 0D 60    ld   (player_screen_600D),a
CC61: CD 72 FD    call draw_object_tiles_FD72
CC64: 3E 11       ld   a,$11
CC66: 32 82 65    ld   (player_x_6582),a
CC69: CD 1B CE    call $CE1B
CC6C: C3 1A CD    jp   $CD1A
CC6F: 3A 0D 60    ld   a,(player_screen_600D)
CC72: FE 04       cp   $04
CC74: 20 16       jr   nz,$CC8C
CC76: CD 89 C1    call $C189
CC79: 3E 05       ld   a,$05
CC7B: 32 0D 60    ld   (player_screen_600D),a
CC7E: CD 72 FD    call draw_object_tiles_FD72
CC81: 3E 11       ld   a,$11
CC83: 32 82 65    ld   (player_x_6582),a
CC86: CD 1B CE    call $CE1B
CC89: C3 1A CD    jp   $CD1A
CC8C: C9          ret
CC8D: 3E 01       ld   a,$01
CC8F: 32 85 62    ld   (unknown_6285),a
CC92: CD CC CD    call $CDCC
CC95: 3A 0D 60    ld   a,(player_screen_600D)
CC98: FE 01       cp   $01
CC9A: C8          ret  z
CC9B: FE 02       cp   $02
CC9D: 20 16       jr   nz,$CCB5
CC9F: CD C9 C2    call display_maze_C2C9
CCA2: 3E 01       ld   a,$01
CCA4: 32 0D 60    ld   (player_screen_600D),a
CCA7: CD 72 FD    call draw_object_tiles_FD72
CCAA: 3E E3       ld   a,$E3
CCAC: 32 82 65    ld   (player_x_6582),a
CCAF: CD 1B CE    call $CE1B
CCB2: C3 1F CD    jp   $CD1F
CCB5: FE 03       cp   $03
CCB7: 20 1E       jr   nz,$CCD7
CCB9: DD 21 42 44 ld   ix,$4442
CCBD: DD 22 81 62 ld   (unknown_6281),ix
CCC1: CD 72 C2    call $C272
CCC4: 3E 02       ld   a,$02
CCC6: 32 0D 60    ld   (player_screen_600D),a
CCC9: 3E E3       ld   a,$E3
CCCB: 32 82 65    ld   (player_x_6582),a
CCCE: CD 72 FD    call draw_object_tiles_FD72
CCD1: CD 1B CE    call $CE1B
CCD4: C3 1F CD    jp   $CD1F
CCD7: FE 04       cp   $04
CCD9: 20 1E       jr   nz,$CCF9
CCDB: DD 21 42 44 ld   ix,$4442
CCDF: DD 22 81 62 ld   (unknown_6281),ix
CCE3: CD 0E C2    call $C20E
CCE6: 3E 03       ld   a,$03
CCE8: 32 0D 60    ld   (player_screen_600D),a
CCEB: 3E E3       ld   a,$E3
CCED: 32 82 65    ld   (player_x_6582),a
CCF0: CD 72 FD    call draw_object_tiles_FD72
CCF3: CD 1B CE    call $CE1B
CCF6: C3 1F CD    jp   $CD1F
CCF9: FE 05       cp   $05
CCFB: C0          ret  nz
CCFC: DD 21 42 44 ld   ix,$4442
CD00: DD 22 81 62 ld   (unknown_6281),ix
CD04: CD C1 C1    call $C1C1
CD07: 3E 04       ld   a,$04
CD09: 32 0D 60    ld   (player_screen_600D),a
CD0C: 3E E3       ld   a,$E3
CD0E: 32 82 65    ld   (player_x_6582),a
CD11: CD 72 FD    call draw_object_tiles_FD72
CD14: CD 1B CE    call $CE1B
CD17: C3 1F CD    jp   $CD1F
CD1A: 11 28 E8    ld   de,$E828
CD1D: 18 03       jr   $CD22
CD1F: 11 18 C8    ld   de,$C818
CD22: 3A 58 63    ld   a,(unknown_6358)
CD25: FE 00       cp   $00
CD27: C4 C9 C2    call nz,display_maze_C2C9
CD2A: 3E 01       ld   a,$01
CD2C: 32 03 A0    ld   ($A003),a
CD2F: DD 21 94 65 ld   ix,guard_1_struct_6594
CD33: FD 21 80 65 ld   iy,player_struct_6580
CD37: FD 7E 03    ld   a,(iy+$03)
CD3A: DD BE 03    cp   (ix+$03)
CD3D: C2 54 CD    jp   nz,$CD54
CD40: DD 7E 02    ld   a,(ix+$02)
CD43: BA          cp   d
CD44: 38 05       jr   c,$CD4B
CD46: CD C5 D0    call $D0C5
CD49: 18 09       jr   $CD54
CD4B: DD 7E 02    ld   a,(ix+$02)
CD4E: BB          cp   e
CD4F: 30 03       jr   nc,$CD54
CD51: CD C5 D0    call $D0C5
CD54: DD 21 98 65 ld   ix,guard_2_struct_6598
CD58: FD 21 80 65 ld   iy,player_struct_6580
CD5C: FD 7E 03    ld   a,(iy+$03)
CD5F: DD BE 03    cp   (ix+$03)
CD62: C2 79 CD    jp   nz,$CD79
CD65: DD 7E 02    ld   a,(ix+$02)
CD68: BA          cp   d
CD69: 38 05       jr   c,$CD70
CD6B: CD D1 D0    call $D0D1
CD6E: 18 09       jr   $CD79
CD70: DD 7E 02    ld   a,(ix+$02)
CD73: BB          cp   e
CD74: 30 03       jr   nc,$CD79
CD76: CD D1 D0    call $D0D1
CD79: 3A 1C 60    ld   a,(player_in_wagon_1_601C)
CD7C: FE 01       cp   $01
CD7E: C8          ret  z
CD7F: 3A 1D 60    ld   a,(player_in_wagon_2_601D)
CD82: FE 01       cp   $01
CD84: C8          ret  z
CD85: 3A 1E 60    ld   a,(player_in_wagon_3_601E)
CD88: FE 01       cp   $01
CD8A: C8          ret  z
CD8B: 21 83 65    ld   hl,player_y_6583
CD8E: DD 21 8C 65 ld   ix,wagon_2_shadow_sprite_658C
CD92: 7E          ld   a,(hl)
CD93: FE 40       cp   $40
CD95: 20 05       jr   nz,$CD9C
CD97: CD C1 CD    call $CDC1
CD9A: 18 17       jr   $CDB3
CD9C: DD 21 88 65 ld   ix,wagon_1_struct_6588
CDA0: FE E0       cp   $E0
CDA2: 20 05       jr   nz,$CDA9
CDA4: CD C1 CD    call $CDC1
CDA7: 18 0A       jr   $CDB3
CDA9: DD 21 90 65 ld   ix,wagon_3_shadow_sprite_6590
CDAD: FE C8       cp   $C8
CDAF: C0          ret  nz
CDB0: CD C1 CD    call $CDC1
CDB3: 06 30       ld   b,$30
CDB5: C5          push bc
CDB6: CD A6 09    call $09A6
CDB9: C1          pop  bc
CDBA: 10 F9       djnz $CDB5
CDBC: AF          xor  a
CDBD: 32 25 60    ld   (player_death_flag_6025),a
CDC0: C9          ret
CDC1: DD 7E 02    ld   a,(ix+$02)
CDC4: FE D8       cp   $D8
CDC6: D0          ret  nc
CDC7: FE 18       cp   $18
CDC9: D8          ret  c
CDCA: F1          pop  af
CDCB: C9          ret
CDCC: AF          xor  a
CDCD: 32 03 A0    ld   ($A003),a
CDD0: 32 8F 65    ld   (unknown_658F),a
CDD3: 32 97 62    ld   (unknown_6297),a
CDD6: 32 F5 62    ld   (unknown_62F5),a
CDD9: 32 FA 62    ld   (unknown_62FA),a
CDDC: 32 23 63    ld   (unknown_6323),a
CDDF: 32 24 63    ld   (unknown_6324),a
CDE2: 3A C7 61    ld   a,(holds_barrow_61C7)
CDE5: FE 00       cp   $00
CDE7: CC CC F9    call z,$F9CC
CDEA: 3A 59 61    ld   a,(bag_falling_6159)
CDED: FE 00       cp   $00
CDEF: 28 0C       jr   z,$CDFD
CDF1: 3A 9F 65    ld   a,(sprite_object_y_659F)
CDF4: 3C          inc  a
CDF5: 32 9F 65    ld   (sprite_object_y_659F),a
CDF8: CD 99 F1    call $F199
CDFB: 18 CF       jr   $CDCC
CDFD: 3A 3B 60    ld   a,(guard_1_in_elevator_603B)
CE00: FE 01       cp   $01
CE02: 20 08       jr   nz,$CE0C
CE04: 3E 01       ld   a,$01
CE06: 32 EB 61    ld   (unknown_61EB),a
CE09: 32 3A 60    ld   (unknown_603A),a
CE0C: 3A 7B 60    ld   a,(guard_2_in_elevator_607B)
CE0F: FE 01       cp   $01
CE11: C0          ret  nz
CE12: 3E 01       ld   a,$01
CE14: 32 EC 61    ld   (unknown_61EC),a
CE17: 32 7A 60    ld   (unknown_607A),a
CE1A: C9          ret
CE1B: DD 21 19 60 ld   ix,unknown_6019
CE1F: 21 82 65    ld   hl,player_x_6582
CE22: FD 21 8A 65 ld   iy,wagon_data_658A
CE26: 11 04 00    ld   de,$0004
CE29: CD 3B CE    call $CE3B
CE2C: DD 23       inc  ix
CE2E: FD 19       add  iy,de
CE30: CD 3B CE    call $CE3B
CE33: DD 23       inc  ix
CE35: FD 19       add  iy,de
CE37: CD 3B CE    call $CE3B
CE3A: C9          ret
CE3B: DD 7E 03    ld   a,(ix+$03)
CE3E: FE 00       cp   $00
CE40: C8          ret  z
CE41: 7E          ld   a,(hl)
CE42: FD 77 00    ld   (iy+$00),a
CE45: 3A 0D 60    ld   a,(player_screen_600D)
CE48: 3D          dec  a
CE49: DD 77 00    ld   (ix+$00),a
CE4C: C9          ret

switch_to_screen_5_CE4D:
CE4D: 3A 7D 62    ld   a,(unknown_627D)
CE50: 32 F3 91    ld   ($91F3),a
CE53: FE E0       cp   $E0
CE55: 28 01       jr   z,$CE58
CE57: 3D          dec  a
CE58: 32 F4 91    ld   ($91F4),a
CE5B: 3E 53       ld   a,$53
CE5D: E5          push hl
CE5E: D5          push de
CE5F: C5          push bc
CE60: 21 B1 93    ld   hl,$93B1
CE63: 11 E0 FF    ld   de,$FFE0
CE66: 06 06       ld   b,$06
CE68: 77          ld   (hl),a
CE69: 3D          dec  a
CE6A: F5          push af
CE6B: E5          push hl
CE6C: 7C          ld   a,h
CE6D: C6 08       add  a,$08
CE6F: 67          ld   h,a
CE70: 3E 1F       ld   a,$1F
CE72: 77          ld   (hl),a
CE73: E1          pop  hl
CE74: F1          pop  af
CE75: 19          add  hl,de
CE76: 10 F0       djnz $CE68
CE78: C1          pop  bc
CE79: D1          pop  de
CE7A: E1          pop  hl
CE7B: C9          ret

draw_object_tiles_CE7C:
CE7C: C5          push bc
CE7D: 47          ld   b,a
CE7E: 7C          ld   a,h
CE7F: FE 00       cp   $00
CE81: 78          ld   a,b
CE82: C1          pop  bc
CE83: C8          ret  z
CE84: F5          push af
CE85: 7E          ld   a,(hl)
CE86: FE D0       cp   $D0
CE88: 28 06       jr   z,$CE90
CE8A: F1          pop  af
CE8B: CD A6 CE    call $CEA6
CE8E: 18 01       jr   $CE91
CE90: F1          pop  af
CE91: 23          inc  hl
CE92: 3C          inc  a
CE93: CD A6 CE    call $CEA6
CE96: D5          push de
CE97: 11 1F 00    ld   de,$001F
CE9A: 19          add  hl,de
CE9B: D1          pop  de
CE9C: 3C          inc  a
CE9D: CD A6 CE    call $CEA6
CEA0: 23          inc  hl
CEA1: 3C          inc  a
CEA2: CD A6 CE    call $CEA6
CEA5: C9          ret
CEA6: 77          ld   (hl),a
CEA7: E5          push hl
CEA8: F5          push af
CEA9: 7C          ld   a,h
CEAA: C6 08       add  a,$08
CEAC: 67          ld   h,a
CEAD: 08          ex   af,af'
CEAE: 77          ld   (hl),a
CEAF: 08          ex   af,af'
CEB0: F1          pop  af
CEB1: E1          pop  hl
CEB2: C9          ret
CEB3: 3A 5E 61    ld   a,(bag_sliding_615E)
CEB6: FE 01       cp   $01
CEB8: C0          ret  nz
CEB9: DD 21 94 65 ld   ix,guard_1_struct_6594
CEBD: CD D2 CE    call $CED2
CEC0: FE 01       cp   $01
CEC2: CC F4 FC    call z,$FCF4
CEC5: DD 21 98 65 ld   ix,guard_2_struct_6598
CEC9: CD D2 CE    call $CED2
CECC: FE 01       cp   $01
CECE: CC 33 FD    call z,$FD33
CED1: C9          ret
CED2: FD 21 9C 65 ld   iy,object_held_struct_659C
CED6: FD 7E 02    ld   a,(iy+$02)
CED9: DD BE 02    cp   (ix+$02)
CEDC: 28 06       jr   z,$CEE4
CEDE: 3C          inc  a
CEDF: DD BE 02    cp   (ix+$02)
CEE2: 20 1F       jr   nz,$CF03
CEE4: FD 7E 03    ld   a,(iy+$03)
CEE7: 3C          inc  a
CEE8: 3C          inc  a
CEE9: DD BE 03    cp   (ix+$03)
CEEC: 28 18       jr   z,$CF06
CEEE: 3D          dec  a
CEEF: DD BE 03    cp   (ix+$03)
CEF2: 28 12       jr   z,$CF06
CEF4: 3D          dec  a
CEF5: DD BE 03    cp   (ix+$03)
CEF8: 28 0C       jr   z,$CF06
CEFA: 3D          dec  a
CEFB: DD BE 03    cp   (ix+$03)
CEFE: 28 06       jr   z,$CF06
CF00: 3D          dec  a
CF01: 28 03       jr   z,$CF06
CF03: 3E 00       ld   a,$00
CF05: C9          ret
CF06: 3E 01       ld   a,$01
CF08: C9          ret
CF09: 21 04 A0    ld   hl,$A004
CF0C: FD 21 E5 61 ld   iy,unknown_61E5
CF10: FD 7E 00    ld   a,(iy+$00)
CF13: FE 00       cp   $00
CF15: 28 16       jr   z,$CF2D
CF17: FD 34 01    inc  (iy+$01)
CF1A: FD 7E 01    ld   a,(iy+$01)
CF1D: FE 10       cp   $10
CF1F: 38 0C       jr   c,$CF2D
CF21: FE 20       cp   $20
CF23: 38 0B       jr   c,$CF30
CF25: FD 35 00    dec  (iy+$00)
CF28: AF          xor  a
CF29: FD 77 01    ld   (iy+$01),a
CF2C: C9          ret
CF2D: AF          xor  a
CF2E: 77          ld   (hl),a
CF2F: C9          ret
CF30: 3E 01       ld   a,$01
CF32: 77          ld   (hl),a
CF33: C9          ret
CF34: 3A 00 A0    ld   a,(interrupt_control_A000)
CF37: E6 3F       and  $3F
CF39: 47          ld   b,a
CF3A: 00          nop
CF3B: 10 FD       djnz $CF3A
CF3D: 3A 56 63    ld   a,(unknown_6356)
CF40: C9          ret
CF41: 3A 00 B0    ld   a,($B000)
CF44: E6 40       and  $40
CF46: FE 40       cp   $40
CF48: 3E 03       ld   a,$03
CF4A: 28 02       jr   z,$CF4E
CF4C: 3E 04       ld   a,$04
CF4E: 47          ld   b,a
CF4F: 3A 7C 61    ld   a,(current_player_617C)
CF52: FE 01       cp   $01
CF54: 3A 78 61    ld   a,(score_ten_thousands_player_1_6178)
CF57: 20 03       jr   nz,$CF5C
CF59: 3A 7B 61    ld   a,(score_ten_thousands_player_2_617B)
CF5C: B8          cp   b
CF5D: 30 05       jr   nc,$CF64
CF5F: AF          xor  a
CF60: 32 86 62    ld   (extra_life_awarded_6286),a
CF63: C9          ret
CF64: 3A 86 62    ld   a,(extra_life_awarded_6286)
CF67: FE 00       cp   $00
CF69: C0          ret  nz
CF6A: 3A 56 60    ld   a,(lives_6056)
CF6D: 3C          inc  a
CF6E: 32 56 60    ld   (lives_6056),a
CF71: 3E 01       ld   a,$01
CF73: 32 86 62    ld   (extra_life_awarded_6286),a
CF76: C9          ret
CF77: 7E          ld   a,(hl)
CF78: FE E0       cp   $E0
CF7A: 20 23       jr   nz,$CF9F
CF7C: 3A 0D 60    ld   a,(player_screen_600D)
CF7F: B8          cp   b
CF80: 28 1D       jr   z,$CF9F
CF82: 78          ld   a,b
CF83: FE 02       cp   $02
CF85: 01 65 61    ld   bc,unknown_6165
CF88: 28 05       jr   z,$CF8F
CF8A: FE 03       cp   $03
CF8C: 01 66 61    ld   bc,unknown_6166
CF8F: 0A          ld   a,(bc)
CF90: FE 10       cp   $10
CF92: D8          ret  c
CF93: 08          ex   af,af'
CF94: FE 00       cp   $00
CF96: 20 03       jr   nz,$CF9B
CF98: 0A          ld   a,(bc)
CF99: 3D          dec  a
CF9A: 02          ld   (bc),a
CF9B: 1A          ld   a,(de)
CF9C: 3D          dec  a
CF9D: 12          ld   (de),a
CF9E: C9          ret
CF9F: AF          xor  a
CFA0: DD 77 00    ld   (ix+$00),a
CFA3: FD 77 00    ld   (iy+$00),a
CFA6: C9          ret
CFA7: 21 E7 61    ld   hl,timer_high_prec_61E7
CFAA: 7E          ld   a,(hl)
CFAB: D6 01       sub  $01
CFAD: 27          daa
CFAE: 77          ld   (hl),a
CFAF: CB 19       rr   c
CFB1: 23          inc  hl
CFB2: 7E          ld   a,(hl)
CFB3: FE 00       cp   $00
CFB5: C8          ret  z
CFB6: CB 11       rl   c
CFB8: DE 00       sbc  a,$00
CFBA: 27          daa
CFBB: 77          ld   (hl),a
CFBC: C9          ret

set_bags_coordinates_hard_level_CFBD:
CFBD: 3A D3 60    ld   a,(unknown_60D3)
CFC0: 3C          inc  a
CFC1: 32 D3 60    ld   (unknown_60D3),a
CFC4: AF          xor  a
CFC5: 32 41 63    ld   (unknown_6341),a
CFC8: 11 9C 60    ld   de,bags_coordinates_609C
CFCB: 21 15 1B    ld   hl,$1B15
CFCE: FE 02       cp   $02
CFD0: 20 03       jr   nz,$CFD5
CFD2: 21 4E 1B    ld   hl,$1B4E
CFD5: 01 36 00    ld   bc,$0036
CFD8: ED B0       ldir
CFDA: C9          ret

set_bags_coordinates_easy_level_CFDB:
CFDB: 11 9C 60    ld   de,bags_coordinates_609C
CFDE: 21 DC 1A    ld   hl,$1ADC
CFE1: 01 36 00    ld   bc,$0036
CFE4: ED B0       ldir
CFE6: C9          ret

set_bags_coordinates_CFE7:
CFE7: 11 7F 61    ld   de,bags_coordinates_617F
CFEA: 21 DC 1A    ld   hl,$1ADC
CFED: 01 36 00    ld   bc,$0036
CFF0: ED B0       ldir
CFF2: C9          ret

is_background_tile_for_object_drop_CFF3:
CFF3: FE E0       cp   $E0
CFF5: C8          ret  z
CFF6: FE 4B       cp   $4B
CFF8: C8          ret  z
CFF9: FE 4A       cp   $4A
CFFB: C8          ret  z
CFFC: FE 49       cp   $49
CFFE: C8          ret  z
CFFF: FE E4       cp   $E4
D001: C8          ret  z
D002: FE E6       cp   $E6
D004: C8          ret  z
D005: FE D4       cp   $D4
D007: C8          ret  z
D008: FE D6       cp   $D6
D00A: C9          ret
D00B: E5          push hl
D00C: C5          push bc
D00D: 01 E0 FF    ld   bc,$FFE0
D010: 09          add  hl,bc
D011: AF          xor  a
D012: ED 52       sbc  hl,de
D014: C1          pop  bc
D015: E1          pop  hl
D016: C9          ret
D017: 3A 7D 61    ld   a,(unknown_617D)
D01A: FE 01       cp   $01
D01C: C8          ret  z
D01D: 3E 01       ld   a,$01
D01F: 32 53 60    ld   (game_locked_6053),a
D022: 32 8C 62    ld   (unknown_628C),a
D025: CD E3 C3    call $C3E3
D028: 11 5A 57    ld   de,$575A
D02B: 21 74 92    ld   hl,$9274
D02E: CD 67 CA    call display_localized_text_CA67
D031: 11 89 56    ld   de,$5689
D034: 21 9F 91    ld   hl,$919F
D037: CD 67 CA    call display_localized_text_CA67
D03A: 3A 7C 61    ld   a,(current_player_617C)
D03D: 3C          inc  a
D03E: 32 94 91    ld   ($9194),a
D041: 3E 08       ld   a,$08
D043: 21 7F 98    ld   hl,$987F
D046: CD 05 56    call write_attribute_on_line_5605
D049: 3E 00       ld   a,$00
D04B: 32 5F 98    ld   ($985F),a
D04E: 3E 05       ld   a,$05
D050: 21 41 98    ld   hl,$9841
D053: CD 05 56    call write_attribute_on_line_5605
D056: 3E 02       ld   a,$02
D058: 21 40 98    ld   hl,$9840
D05B: CD 05 56    call write_attribute_on_line_5605
D05E: 21 93 92    ld   hl,$9293
D061: 11 42 1A    ld   de,$1A42
D064: 3E 1F       ld   a,$1F
D066: 08          ex   af,af'
D067: CD F0 55    call $55F0
D06A: 21 95 92    ld   hl,$9295
D06D: 11 4D 1A    ld   de,$1A4D
D070: 3E 1F       ld   a,$1F
D072: 08          ex   af,af'
D073: CD F0 55    call $55F0
D076: 3E 8E       ld   a,$8E
D078: 32 74 91    ld   ($9174),a
D07B: 3E 8B       ld   a,$8B
D07D: 32 94 92    ld   ($9294),a
D080: 3E 1F       ld   a,$1F
D082: 32 74 99    ld   ($9974),a
D085: 32 94 9A    ld   ($9A94),a
D088: CD 2E 16    call $162E
D08B: 3E 00       ld   a,$00
D08D: 32 03 98    ld   ($9803),a
D090: 32 07 98    ld   ($9807),a
D093: 32 0B 98    ld   ($980B),a
D096: 32 0F 98    ld   ($980F),a
D099: 32 13 98    ld   ($9813),a
D09C: 32 17 98    ld   ($9817),a
D09F: 32 1B 98    ld   ($981B),a
D0A2: 32 1F 98    ld   ($981F),a
D0A5: 21 30 01    ld   hl,$0130
D0A8: 06 80       ld   b,$80
D0AA: 3A 00 B8    ld   a,(io_read_shit_B800)
D0AD: C5          push bc
D0AE: E5          push hl
D0AF: CD 2E 16    call $162E
D0B2: E1          pop  hl
D0B3: C1          pop  bc
D0B4: 10 F4       djnz $D0AA
D0B6: 2B          dec  hl
D0B7: 7C          ld   a,h
D0B8: FE 00       cp   $00
D0BA: 20 EC       jr   nz,$D0A8
D0BC: 3E 00       ld   a,$00
D0BE: 32 53 60    ld   (game_locked_6053),a
D0C1: 32 8C 62    ld   (unknown_628C),a
D0C4: C9          ret
D0C5: D5          push de
D0C6: 06 60       ld   b,$60
D0C8: C5          push bc
D0C9: CD C0 11    call guard_1_walk_movement_11C0
D0CC: C1          pop  bc
D0CD: 10 F9       djnz $D0C8
D0CF: D1          pop  de
D0D0: C9          ret
D0D1: D5          push de
D0D2: 06 60       ld   b,$60
D0D4: C5          push bc
D0D5: CD EC 11    call guard_2_walk_movement_11EC
D0D8: C1          pop  bc
D0D9: 10 F9       djnz $D0D4
D0DB: D1          pop  de
D0DC: C9          ret
D0DD: 11 89 56    ld   de,$5689
D0E0: 21 9F 91    ld   hl,$919F
D0E3: CD 67 CA    call display_localized_text_CA67
D0E6: 3A 00 B8    ld   a,(io_read_shit_B800)
D0E9: 11 05 57    ld   de,$5705
D0EC: 21 40 92    ld   hl,$9240
D0EF: CD 67 CA    call display_localized_text_CA67
D0F2: C9          ret
D0F3: CD D9 D4    call can_pick_bag_D4D9
D0F6: C0          ret  nz
D0F7: 3A 53 63    ld   a,(unknown_6353)
D0FA: 3C          inc  a
D0FB: FE 03       cp   $03
D0FD: 38 01       jr   c,$D100
D0FF: AF          xor  a
D100: 32 53 63    ld   (unknown_6353),a
D103: 21 68 3B    ld   hl,$3B68
D106: FE 01       cp   $01
D108: 28 0A       jr   z,$D114
D10A: 21 00 38    ld   hl,$3800
D10D: FE 02       cp   $02
D10F: 28 03       jr   z,$D114
D111: 21 00 50    ld   hl,$5000
D114: 22 40 61    ld   (ay_sound_pointer_6140),hl
D117: AF          xor  a
D118: 32 42 61    ld   (ay_sound_start_6142),a
D11B: C9          ret
D11C: 3A 0D 60    ld   a,(player_screen_600D)
D11F: FE 05       cp   $05
D121: C0          ret  nz
D122: 3A C7 61    ld   a,(holds_barrow_61C7)
D125: FE 01       cp   $01
D127: C0          ret  nz
D128: 3A 82 65    ld   a,(player_x_6582)
D12B: FE B3       cp   $B3
D12D: C0          ret  nz
D12E: C9          ret

check_if_level_completed_D12F:
D12F: CD 69 D2    call check_remaining_bags_D269
D132: 79          ld   a,c
D133: FE 00       cp   $00
D135: C8          ret  z
D136: 3A 41 63    ld   a,(unknown_6341)
D139: FE 01       cp   $01
D13B: CA D0 D1    jp   z,$D1D0
D13E: 3E 00       ld   a,$00
D140: 32 03 A0    ld   ($A003),a
D143: CD B7 C3    call clear_screen_C3B7
D146: 3E 04       ld   a,$04
D148: CD A3 C3    call change_attribute_everywhere_C3A3
D14B: 3E 01       ld   a,$01
D14D: 32 32 63    ld   (unknown_6332),a
D150: 32 42 63    ld   (unknown_6342),a
D153: DD 21 13 1C ld   ix,$1C13
D157: 3A 00 B0    ld   a,($B000)
D15A: E6 20       and  $20
D15C: FE 20       cp   $20
D15E: 20 04       jr   nz,$D164
D160: DD 21 6A 1C ld   ix,$1C6A
D164: CD 2A D8    call $D82A
D167: AF          xor  a
D168: 32 32 63    ld   (unknown_6332),a
D16B: 32 42 63    ld   (unknown_6342),a
D16E: F3          di
D16F: 3E 01       ld   a,$01
D171: 32 41 63    ld   (unknown_6341),a
D174: CD 51 F9    call init_new_game_F951
D177: CD 14 C3    call init_guard_directions_and_wagons_C314
D17A: CD BF DF    call $DFBF
D17D: 2A C4 61    ld   hl,(barrow_screen_params_61C4)
D180: E5          push hl
D181: 21 00 00    ld   hl,$0000
D184: 22 C4 61    ld   (barrow_screen_params_61C4),hl
D187: E1          pop  hl
D188: 23          inc  hl
D189: 3E E0       ld   a,$E0
D18B: 77          ld   (hl),a
D18C: 11 20 00    ld   de,$0020
D18F: 19          add  hl,de
D190: 77          ld   (hl),a
D191: DD 21 B5 D1 ld   ix,$D1B5
D195: 11 03 00    ld   de,$0003
D198: 3A 00 A0    ld   a,(interrupt_control_A000)
D19B: E6 07       and  $07
D19D: 3C          inc  a
D19E: 47          ld   b,a
D19F: DD 19       add  ix,de
D1A1: 10 FC       djnz $D19F
D1A3: DD 7E 00    ld   a,(ix+$00)
D1A6: 6F          ld   l,a
D1A7: DD 7E 01    ld   a,(ix+$01)
D1AA: 67          ld   h,a
D1AB: DD 7E 02    ld   a,(ix+$02)
D1AE: 22 9F 60    ld   (unknown_609F),hl
D1B1: 32 A1 60    ld   (unknown_60A1),a
D1B4: C9          ret
D1B5: 00          nop
D1B6: 00          nop
D1B7: 00          nop
D1B8: 23          inc  hl
D1B9: 91          sub  c
D1BA: 01 03 92    ld   bc,$9203
D1BD: 02          ld   (bc),a
D1BE: A3          and  e
D1BF: 92          sub  d
D1C0: 03          inc  bc
D1C1: 7C          ld   a,h
D1C2: 92          sub  d
D1C3: 03          inc  bc
D1C4: 03          inc  bc
D1C5: 91          sub  c
D1C6: 03          inc  bc
D1C7: F0          ret  p
D1C8: 90          sub  b
D1C9: 03          inc  bc
D1CA: D3 92       out  ($92),a
D1CC: 01 3C 92    ld   bc,$923C
D1CF: 02          ld   (bc),a
D1D0: 3A 43 63    ld   a,(unknown_6343)
D1D3: FE 01       cp   $01
D1D5: 28 1C       jr   z,$D1F3
D1D7: AF          xor  a
D1D8: 32 88 62    ld   (unknown_6288),a
D1DB: 32 54 60    ld   (gameplay_allowed_6054),a
D1DE: 3E E0       ld   a,$E0
D1E0: 32 0E 93    ld   ($930E),a
D1E3: 32 0F 93    ld   ($930F),a
D1E6: 3E 01       ld   a,$01
D1E8: 32 43 63    ld   (unknown_6343),a
D1EB: 32 41 63    ld   (unknown_6341),a
D1EE: 3E E0       ld   a,$E0
D1F0: 32 8E 93    ld   ($938E),a
D1F3: 3E 05       ld   a,$05
D1F5: 32 99 60    ld   (guard_1_screen_6099),a
D1F8: 32 9A 69    ld   (unknown_699A),a
D1FB: 3A 82 65    ld   a,(player_x_6582)
D1FE: FE 10       cp   $10
D200: C0          ret  nz
D201: 3A 83 65    ld   a,(player_y_6583)
D204: FE 18       cp   $18
D206: C0          ret  nz
D207: 3E 00       ld   a,$00
D209: 32 43 63    ld   (unknown_6343),a
D20C: 32 53 60    ld   (game_locked_6053),a
D20F: 3E 01       ld   a,$01
D211: 32 41 63    ld   (unknown_6341),a
D214: 32 03 A0    ld   ($A003),a
D217: 32 32 63    ld   (unknown_6332),a
D21A: 32 42 63    ld   (unknown_6342),a
D21D: CD B7 C3    call clear_screen_C3B7
D220: 3E 04       ld   a,$04
D222: CD A3 C3    call change_attribute_everywhere_C3A3
D225: DD 21 AE 1C ld   ix,$1CAE
D229: 3A 00 B0    ld   a,($B000)
D22C: E6 20       and  $20
D22E: FE 20       cp   $20
D230: 20 04       jr   nz,$D236
D232: DD 21 25 1D ld   ix,$1D25
D236: CD 2A D8    call $D82A
D239: AF          xor  a
D23A: 32 32 63    ld   (unknown_6332),a
D23D: 32 42 63    ld   (unknown_6342),a
D240: 32 41 63    ld   (unknown_6341),a
D243: 3E 01       ld   a,$01
D245: 32 54 60    ld   (gameplay_allowed_6054),a
D248: 3A 56 60    ld   a,(lives_6056)
D24B: 3C          inc  a
D24C: 32 56 60    ld   (lives_6056),a
D24F: F3          di
D250: 06 40       ld   b,$40
D252: 21 80 65    ld   hl,player_struct_6580
D255: 3E 00       ld   a,$00
D257: 77          ld   (hl),a
D258: 23          inc  hl
D259: 10 FC       djnz $D257
D25B: 3E 01       ld   a,$01
D25D: 32 54 60    ld   (gameplay_allowed_6054),a
D260: CD BD CF    call set_bags_coordinates_hard_level_CFBD
D263: 31 F0 67    ld   sp,stack_top_67F0
D266: C3 DC EC    jp   $ECDC

check_remaining_bags_D269:
D269: 0E 00       ld   c,$00
D26B: FD 21 9C 60 ld   iy,bags_coordinates_609C
D26F: 06 36       ld   b,$36
D271: FD 7E 00    ld   a,(iy+$00)
D274: FE 00       cp   $00
D276: C0          ret  nz
D277: FD 23       inc  iy
D279: 10 F6       djnz $D271
D27B: 0E 01       ld   c,$01
D27D: C9          ret
D27E: 21 F4 61    ld   hl,unknown_61F4
D281: 7E          ld   a,(hl)
D282: 47          ld   b,a
D283: 3A E8 61    ld   a,(time_61E8)
D286: B8          cp   b
D287: C8          ret  z
D288: FE 05       cp   $05
D28A: D0          ret  nc
D28B: 21 94 5B    ld   hl,$5B94
D28E: 22 40 61    ld   (ay_sound_pointer_6140),hl
D291: 32 F4 61    ld   (unknown_61F4),a
D294: AF          xor  a
D295: 32 42 61    ld   (ay_sound_start_6142),a
D298: C9          ret
D299: C9          ret
D29A: 3A 0D 60    ld   a,(player_screen_600D)
D29D: 32 98 60    ld   (current_guard_screen_index_6098),a
D2A0: FD 21 61 61 ld   iy,unknown_6161
D2A4: DD 21 84 65 ld   ix,elevator_struct_6584
D2A8: CD EF EA    call compute_logical_address_from_xy_EAEF
D2AB: 3A 0D 60    ld   a,(player_screen_600D)
D2AE: FE 04       cp   $04
D2B0: 28 04       jr   z,$D2B6
D2B2: C9          ret
D2B3: FE 05       cp   $05
D2B5: C0          ret  nz
D2B6: DD 7E 03    ld   a,(ix+$03)
D2B9: FE 11       cp   $11
D2BB: D8          ret  c
D2BC: 3A 0D 60    ld   a,(player_screen_600D)
D2BF: FE 04       cp   $04
D2C1: 20 11       jr   nz,$D2D4
D2C3: 11 DE 30    ld   de,$30DE
D2C6: AF          xor  a
D2C7: ED 5A       adc  hl,de
D2C9: 7C          ld   a,h
D2CA: C6 2F       add  a,$2F
D2CC: 67          ld   h,a
D2CD: 11 C3 90    ld   de,$90C3
D2D0: 06 1A       ld   b,$1A
D2D2: 18 0B       jr   $D2DF
D2D4: 11 FE 34    ld   de,$34FE
D2D7: AF          xor  a
D2D8: ED 5A       adc  hl,de
D2DA: 11 E4 90    ld   de,$90E4
D2DD: 06 1A       ld   b,$1A
D2DF: 3E FB       ld   a,$FB
D2E1: E5          push hl
D2E2: AF          xor  a
D2E3: ED 52       sbc  hl,de
D2E5: E1          pop  hl
D2E6: 28 09       jr   z,$D2F1
D2E8: 3E FB       ld   a,$FB
D2EA: CD 13 D3    call $D313
D2ED: 13          inc  de
D2EE: 10 EF       djnz $D2DF
D2F0: C9          ret
D2F1: DD 7E 03    ld   a,(ix+$03)
D2F4: E6 07       and  $07
D2F6: 47          ld   b,a
D2F7: 3E F3       ld   a,$F3
D2F9: 80          add  a,b
D2FA: CD 13 D3    call $D313
D2FD: 06 03       ld   b,$03
D2FF: 13          inc  de
D300: C5          push bc
D301: 1A          ld   a,(de)
D302: 01 08 00    ld   bc,$0008
D305: 21 26 D3    ld   hl,$D326
D308: ED B1       cpir
D30A: 3E F3       ld   a,$F3
D30C: CC 13 D3    call z,$D313
D30F: C1          pop  bc
D310: 10 ED       djnz $D2FF
D312: C9          ret
D313: 12          ld   (de),a
D314: C5          push bc
D315: 47          ld   b,a
D316: 1A          ld   a,(de)
D317: B8          cp   b
D318: 78          ld   a,b
D319: C1          pop  bc
D31A: 20 F7       jr   nz,$D313
D31C: D5          push de
D31D: 7A          ld   a,d
D31E: C6 08       add  a,$08
D320: 57          ld   d,a
D321: 3E 20       ld   a,$20
D323: 12          ld   (de),a
D324: D1          pop  de
D325: C9          ret
D326: FB          ei
D327: FA F9 F8    jp   m,$F8F9
D32A: F7          rst  $30
D32B: F6 F5       or   $F5
D32D: F4 2A 91    call p,$912A
D330: 60          ld   h,b
D331: 22 FF 61    ld   (unknown_61FF),hl
D334: 2A 93 60    ld   hl,(guard_struct_pointer_6093)
D337: 22 01 62    ld   (unknown_pointer_6201),hl
D33A: 2A 95 60    ld   hl,(guard_direction_pointer_6095)
D33D: 22 03 62    ld   (unknown_pointer_6203),hl
D340: 3A 0B 60    ld   a,(way_clear_flag_600B)
D343: 32 05 62    ld   (unknown_6205),a
D346: 3A 98 60    ld   a,(current_guard_screen_index_6098)
D349: 32 F9 61    ld   (unknown_61F9),a
D34C: C9          ret
D34D: 2A FF 61    ld   hl,(unknown_61FF)
D350: 22 91 60    ld   (guard_logical_address_6091),hl
D353: 2A 01 62    ld   hl,(unknown_pointer_6201)
D356: 22 93 60    ld   (guard_struct_pointer_6093),hl
D359: 2A 03 62    ld   hl,(unknown_pointer_6203)
D35C: 22 95 60    ld   (guard_direction_pointer_6095),hl
D35F: 3A 05 62    ld   a,(unknown_6205)
D362: 32 0B 60    ld   (way_clear_flag_600B),a
D365: 3A F9 61    ld   a,(unknown_61F9)
D368: 32 98 60    ld   (current_guard_screen_index_6098),a
D36B: C9          ret

test_non_blocking_tiles_D36C:
D36C: F5          push af
D36D: D5          push de
D36E: E5          push hl
D36F: 06 00       ld   b,$00
D371: CD 91 D3    call $D391
D374: 20 17       jr   nz,$D38D
D376: 23          inc  hl
D377: CD 91 D3    call $D391
D37A: 20 11       jr   nz,$D38D
D37C: 11 1F 00    ld   de,$001F
D37F: 19          add  hl,de
D380: CD 91 D3    call $D391
D383: 20 08       jr   nz,$D38D
D385: 23          inc  hl
D386: CD 91 D3    call $D391
D389: 20 02       jr   nz,$D38D
D38B: 06 01       ld   b,$01
D38D: E1          pop  hl
D38E: D1          pop  de
D38F: F1          pop  af
D390: C9          ret
D391: 7E          ld   a,(hl)
D392: FE E0       cp   $E0
D394: C8          ret  z
D395: FE 49       cp   $49
D397: C8          ret  z
D398: FE 4A       cp   $4A
D39A: C8          ret  z
D39B: FE 4B       cp   $4B
D39D: C8          ret  z
D39E: FE 51       cp   $51
D3A0: C8          ret  z
D3A1: FE 52       cp   $52
D3A3: C8          ret  z
D3A4: FE 57       cp   $57
D3A6: C9          ret
D3A7: AF          xor  a
D3A8: FD 77 00    ld   (iy+$00),a
D3AB: FD 77 01    ld   (iy+$01),a
D3AE: E1          pop  hl
D3AF: C9          ret
D3B0: DD 21 CC 61 ld   ix,current_pickaxe_screen_params_61CC
D3B4: AF          xor  a
D3B5: DD 77 00    ld   (ix+$00),a
D3B8: DD 77 01    ld   (ix+$01),a
D3BB: DD 77 03    ld   (ix+$03),a
D3BE: 3E FF       ld   a,$FF
D3C0: 32 9F 65    ld   (sprite_object_y_659F),a
D3C3: C9          ret
D3C4: CD BE EA    call $EABE
D3C7: CD 81 D4    call $D481
D3CA: 28 12       jr   z,$D3DE
D3CC: AF          xor  a
D3CD: 32 77 60    ld   (guard_2_in_elevator_6077),a
D3D0: 3A 09 62    ld   a,(unknown_6209)
D3D3: FE 01       cp   $01
D3D5: 20 07       jr   nz,$D3DE
D3D7: CD 33 FD    call $FD33
D3DA: AF          xor  a
D3DB: 32 09 62    ld   (unknown_6209),a
D3DE: DD 21 8F 60 ld   ix,unknown_608F
D3E2: FD 21 57 61 ld   iy,unknown_6157
D3E6: 21 E9 62    ld   hl,unknown_62E9
D3E9: D9          exx
D3EA: 21 98 65    ld   hl,guard_2_struct_6598
D3ED: 22 15 62    ld   (guard_struct_pointer_6215),hl
D3F0: 2A 78 60    ld   hl,(guard_2_logical_address_6078)
D3F3: 11 7B 60    ld   de,guard_2_in_elevator_607B
D3F6: 3A 9A 60    ld   a,(guard_2_screen_609A)
D3F9: 32 98 60    ld   (current_guard_screen_index_6098),a
D3FC: 01 12 62    ld   bc,unknown_6212
D3FF: CD 41 D4    call $D441
D402: CD B1 EA    call $EAB1
D405: CD 81 D4    call $D481
D408: 28 12       jr   z,$D41C
D40A: AF          xor  a
D40B: 32 37 60    ld   (guard_1_in_elevator_6037),a
D40E: 3A 08 62    ld   a,(unknown_6208)
D411: FE 01       cp   $01
D413: 20 07       jr   nz,$D41C
D415: CD F4 FC    call $FCF4
D418: AF          xor  a
D419: 32 08 62    ld   (unknown_6208),a
D41C: DD 21 4F 60 ld   ix,unknown_604F
D420: FD 21 56 61 ld   iy,unknown_6156
D424: 21 ED 62    ld   hl,unknown_62ED
D427: D9          exx
D428: 21 94 65    ld   hl,guard_1_struct_6594
D42B: 22 15 62    ld   (guard_struct_pointer_6215),hl
D42E: 2A 38 60    ld   hl,(guard_1_logical_address_6038)
D431: 11 3B 60    ld   de,guard_1_in_elevator_603B
D434: 3A 99 60    ld   a,(guard_1_screen_6099)
D437: 32 98 60    ld   (current_guard_screen_index_6098),a
D43A: 01 11 62    ld   bc,unknown_6211
D43D: CD 41 D4    call $D441
D440: C9          ret
D441: DD 7E 00    ld   a,(ix+$00)
D444: FE 12       cp   $12
D446: 38 15       jr   c,$D45D
D448: CD 81 D4    call $D481
D44B: 20 56       jr   nz,$D4A3
D44D: 1A          ld   a,(de)
D44E: FE 01       cp   $01
D450: 28 51       jr   z,$D4A3
D452: D9          exx
D453: 7E          ld   a,(hl)
D454: D9          exx
D455: FE 01       cp   $01
D457: 28 4A       jr   z,$D4A3
D459: 3E 01       ld   a,$01
D45B: 02          ld   (bc),a
D45C: C9          ret
D45D: 0A          ld   a,(bc)
D45E: FE 01       cp   $01
D460: 28 47       jr   z,$D4A9
D462: AF          xor  a
D463: C9          ret
D464: 7E          ld   a,(hl)
D465: E5          push hl
D466: C5          push bc
D467: 01 0A 00    ld   bc,$000A
D46A: 21 77 D4    ld   hl,$D477
D46D: ED B1       cpir
D46F: C1          pop  bc
D470: E1          pop  hl
D471: C8          ret  z
D472: AF          xor  a
D473: 32 08 60    ld   (unknown_6008),a
D476: C9          ret
D477: E0          ret  po
D478: FB          ei
D479: B3          or   e
D47A: B2          or   d
D47B: B1          or   c
D47C: B0          or   b
D47D: 4C          ld   c,h
D47E: 4D          ld   c,l
D47F: 4E          ld   c,(hl)
D480: 4F          ld   c,a
D481: 7E          ld   a,(hl)
D482: E5          push hl
D483: C5          push bc
D484: 01 14 00    ld   bc,$0014
D487: 21 8F D4    ld   hl,$D48F
D48A: ED B1       cpir
D48C: C1          pop  bc
D48D: E1          pop  hl
D48E: C9          ret
D48F: FF          rst  $38
D490: FE FD       cp   $FD
D492: FC FB FA    call m,$FAFB
D495: F9          ld   sp,hl
D496: E2 E1 E0    jp   po,$E0E1
D499: DF          rst  $18
D49A: DE 4C       sbc  a,$4C
D49C: 4D          ld   c,l
D49D: 4E          ld   c,(hl)
D49E: 4F          ld   c,a
D49F: B3          or   e
D4A0: B2          or   d
D4A1: B1          or   c
D4A2: B0          or   b
D4A3: 2A 15 62    ld   hl,(guard_struct_pointer_6215)
D4A6: 3E 22       ld   a,$22
D4A8: 77          ld   (hl),a
D4A9: AF          xor  a
D4AA: 02          ld   (bc),a
D4AB: DD 77 00    ld   (ix+$00),a
D4AE: 3E 01       ld   a,$01
D4B0: FD 77 00    ld   (iy+$00),a
D4B3: EB          ex   de,hl
D4B4: 11 04 00    ld   de,$0004
D4B7: AF          xor  a
D4B8: ED 52       sbc  hl,de
D4BA: 77          ld   (hl),a
D4BB: 21 52 27    ld   hl,$2752
D4BE: 22 54 61    ld   (unknown_6154),hl
D4C1: AF          xor  a
D4C2: 32 F5 61    ld   (unknown_61F5),a
D4C5: 3A 98 60    ld   a,(current_guard_screen_index_6098)
D4C8: 47          ld   b,a
D4C9: 3A 0D 60    ld   a,(player_screen_600D)
D4CC: B8          cp   b
D4CD: C0          ret  nz
D4CE: 21 B1 D9    ld   hl,$D9B1
D4D1: CD 84 EC    call play_sample_EC84
D4D4: AF          xor  a
D4D5: 32 53 61    ld   (unknown_6153),a
D4D8: C9          ret

can_pick_bag_D4D9:
D4D9: DD E5       push ix
D4DB: DD 2A 40 61 ld   ix,(ay_sound_pointer_6140)
D4DF: DD 7E 03    ld   a,(ix+$03)
D4E2: DD E1       pop  ix
D4E4: FE FF       cp   $FF
D4E6: C0          ret  nz
D4E7: 3A 43 63    ld   a,(unknown_6343)
D4EA: FE 01       cp   $01
D4EC: C8          ret  z
D4ED: 3A 10 62    ld   a,(must_play_music_6210)
D4F0: FE 01       cp   $01
D4F2: C8          ret  z
D4F3: 3A 00 60    ld   a,(number_of_credits_6000)
D4F6: FE 00       cp   $00
D4F8: 20 0F       jr   nz,$D509
D4FA: 3A 54 60    ld   a,(gameplay_allowed_6054)
D4FD: FE 01       cp   $01
D4FF: 28 08       jr   z,$D509
D501: 3A 00 B0    ld   a,($B000)
D504: E6 40       and  $40
D506: FE 40       cp   $40
D508: C9          ret
D509: 3E 00       ld   a,$00
D50B: FE 00       cp   $00
D50D: C9          ret
D50E: 3A 54 60    ld   a,(gameplay_allowed_6054)
D511: 3A 00 B8    ld   a,(io_read_shit_B800)
D514: DD 21 80 65 ld   ix,player_struct_6580
D518: FD 21 A8 65 ld   iy,player_shadow_sprite_65A8
D51C: CD D7 D6    call $D6D7
D51F: DD 21 84 65 ld   ix,elevator_struct_6584
D523: FD 21 A4 65 ld   iy,elevator_shadow_sprite_65A4
D527: CD D7 D6    call $D6D7
D52A: DD 21 88 65 ld   ix,wagon_1_struct_6588
D52E: FD 21 AC 65 ld   iy,wagon_1_shadow_sprite_65AC
D532: CD D7 D6    call $D6D7
D535: DD 21 8C 65 ld   ix,wagon_2_shadow_sprite_658C
D539: FD 21 B0 65 ld   iy,unknown_65B0
D53D: CD D7 D6    call $D6D7
D540: DD 21 90 65 ld   ix,wagon_3_shadow_sprite_6590
D544: FD 21 B4 65 ld   iy,unknown_65B4
D548: CD D7 D6    call $D6D7
D54B: DD 21 9C 65 ld   ix,object_held_struct_659C
D54F: FD 21 A0 65 ld   iy,barrow_sprite_shadow_ram_65A0
D553: CD D7 D6    call $D6D7
D556: AF          xor  a
D557: 32 5F 98    ld   ($985F),a
D55A: 0E 01       ld   c,$01
D55C: 3A FD 61    ld   a,(unknown_61FD)
D55F: FE 01       cp   $01
D561: 20 02       jr   nz,$D565
D563: 0E FF       ld   c,$FF
D565: CD EF D8    call $D8EF
D568: 06 08       ld   b,$08
D56A: 11 04 00    ld   de,$0004
D56D: 21 A3 65    ld   hl,unknown_65A3
D570: 7E          ld   a,(hl)
D571: FE 00       cp   $00
D573: 28 02       jr   z,$D577
D575: 81          add  a,c
D576: 77          ld   (hl),a
D577: 19          add  hl,de
D578: 10 F6       djnz $D570
D57A: 21 AF 65    ld   hl,unknown_65AF
D57D: 06 03       ld   b,$03
D57F: 35          dec  (hl)
D580: 19          add  hl,de
D581: 10 FC       djnz $D57F
D583: 79          ld   a,c
D584: FE FF       cp   $FF
D586: 20 16       jr   nz,$D59E
D588: 3A 0D 60    ld   a,(player_screen_600D)
D58B: FE 04       cp   $04
D58D: 20 0F       jr   nz,$D59E
D58F: 3A ED 61    ld   a,(check_scenery_disabled_61ED)
D592: FE 01       cp   $01
D594: 28 08       jr   z,$D59E
D596: 3A A6 65    ld   a,(unknown_65A6)
D599: 3C          inc  a
D59A: 3C          inc  a
D59B: 32 A6 65    ld   (unknown_65A6),a
D59E: C9          ret
D59F: 3A C7 61    ld   a,(holds_barrow_61C7)
D5A2: FE 00       cp   $00
D5A4: C8          ret  z
D5A5: 3A 3A 63    ld   a,(unknown_633A)
D5A8: FE 01       cp   $01
D5AA: 28 14       jr   z,$D5C0
D5AC: 3A 82 65    ld   a,(player_x_6582)
D5AF: C6 0E       add  a,$0E
D5B1: 32 9E 65    ld   (sprite_object_x_659E),a
D5B4: 3A 83 65    ld   a,(player_y_6583)
D5B7: 32 9F 65    ld   (sprite_object_y_659F),a
D5BA: 3E 3A       ld   a,$3A
D5BC: 32 9C 65    ld   (object_held_struct_659C),a
D5BF: C9          ret
D5C0: 3A 82 65    ld   a,(player_x_6582)
D5C3: C6 0D       add  a,$0D
D5C5: 32 9E 65    ld   (sprite_object_x_659E),a
D5C8: 3A 83 65    ld   a,(player_y_6583)
D5CB: C6 04       add  a,$04
D5CD: 32 9F 65    ld   (sprite_object_y_659F),a
D5D0: 3E 33       ld   a,$33
D5D2: 32 9C 65    ld   (object_held_struct_659C),a
D5D5: C9          ret
D5D6: 3A 11 63    ld   a,(unknown_6311)
D5D9: FE 00       cp   $00
D5DB: C8          ret  z
D5DC: 3A 80 65    ld   a,(player_struct_6580)
D5DF: E6 7F       and  $7F
D5E1: 06 02       ld   b,$02
D5E3: FE 12       cp   $12
D5E5: 28 0D       jr   z,$D5F4
D5E7: 06 06       ld   b,$06
D5E9: 3A 80 65    ld   a,(player_struct_6580)
D5EC: E6 80       and  $80
D5EE: FE 80       cp   $80
D5F0: 20 02       jr   nz,$D5F4
D5F2: 06 F9       ld   b,$F9
D5F4: 3A 82 65    ld   a,(player_x_6582)
D5F7: 80          add  a,b
D5F8: 32 9E 65    ld   (sprite_object_x_659E),a
D5FB: 3A 83 65    ld   a,(player_y_6583)
D5FE: 32 9F 65    ld   (sprite_object_y_659F),a
D601: 3E 35       ld   a,$35
D603: 32 9C 65    ld   (object_held_struct_659C),a
D606: 3E 24       ld   a,$24
D608: 32 9D 65    ld   (unknown_659D),a
D60B: C9          ret
D60C: 3A 43 63    ld   a,(unknown_6343)
D60F: FE 00       cp   $00
D611: C8          ret  z
D612: 3A 80 65    ld   a,(player_struct_6580)
D615: E6 7F       and  $7F
D617: 0E 00       ld   c,$00
D619: 06 00       ld   b,$00
D61B: FE 12       cp   $12
D61D: 28 11       jr   z,$D630
D61F: 0E 80       ld   c,$80
D621: 06 06       ld   b,$06
D623: 3A 80 65    ld   a,(player_struct_6580)
D626: E6 80       and  $80
D628: FE 80       cp   $80
D62A: 20 04       jr   nz,$D630
D62C: 0E 00       ld   c,$00
D62E: 06 F9       ld   b,$F9
D630: 3A 82 65    ld   a,(player_x_6582)
D633: 80          add  a,b
D634: 32 9E 65    ld   (sprite_object_x_659E),a
D637: 3A 83 65    ld   a,(player_y_6583)
D63A: C6 04       add  a,$04
D63C: 32 9F 65    ld   (sprite_object_y_659F),a
D63F: 3E 1B       ld   a,$1B
D641: B1          or   c
D642: 32 9C 65    ld   (object_held_struct_659C),a
D645: 3E 08       ld   a,$08
D647: 32 9D 65    ld   (unknown_659D),a
D64A: C9          ret
D64B: 3A C7 61    ld   a,(holds_barrow_61C7)
D64E: FE 01       cp   $01
D650: C0          ret  nz
D651: CD CE D6    call $D6CE
D654: 3A C7 61    ld   a,(holds_barrow_61C7)
D657: FE 01       cp   $01
D659: C0          ret  nz
D65A: 06 08       ld   b,$08
D65C: CD B8 D6    call $D6B8
D65F: 3A C7 61    ld   a,(holds_barrow_61C7)
D662: FE 01       cp   $01
D664: C0          ret  nz
D665: 06 10       ld   b,$10
D667: CD C4 D6    call $D6C4
D66A: 3A C7 61    ld   a,(holds_barrow_61C7)
D66D: FE 01       cp   $01
D66F: C0          ret  nz
D670: 06 08       ld   b,$08
D672: CD C4 D6    call $D6C4
D675: 3A C7 61    ld   a,(holds_barrow_61C7)
D678: FE 01       cp   $01
D67A: C0          ret  nz
D67B: 06 08       ld   b,$08
D67D: CD C4 D6    call $D6C4
D680: 3A C7 61    ld   a,(holds_barrow_61C7)
D683: FE 01       cp   $01
D685: C0          ret  nz
D686: 06 08       ld   b,$08
D688: CD C4 D6    call $D6C4
D68B: 3A C7 61    ld   a,(holds_barrow_61C7)
D68E: FE 01       cp   $01
D690: C0          ret  nz
D691: 06 08       ld   b,$08
D693: CD C4 D6    call $D6C4
D696: 06 08       ld   b,$08
D698: CD C4 D6    call $D6C4
D69B: 3A C7 61    ld   a,(holds_barrow_61C7)
D69E: FE 01       cp   $01
D6A0: C0          ret  nz
D6A1: 3A C7 61    ld   a,(holds_barrow_61C7)
D6A4: FE 01       cp   $01
D6A6: C0          ret  nz
D6A7: 06 40       ld   b,$40
D6A9: CD B8 D6    call $D6B8
D6AC: 3A C7 61    ld   a,(holds_barrow_61C7)
D6AF: FE 01       cp   $01
D6B1: C0          ret  nz
D6B2: 06 08       ld   b,$08
D6B4: CD B8 D6    call $D6B8
D6B7: C9          ret
D6B8: 3A 9E 65    ld   a,(sprite_object_x_659E)
D6BB: 80          add  a,b
D6BC: FE E0       cp   $E0
D6BE: D0          ret  nc
D6BF: 32 9E 65    ld   (sprite_object_x_659E),a
D6C2: 18 0A       jr   $D6CE
D6C4: 3A 9E 65    ld   a,(sprite_object_x_659E)
D6C7: 90          sub  b
D6C8: FE 10       cp   $10
D6CA: D8          ret  c
D6CB: 32 9E 65    ld   (sprite_object_x_659E),a
D6CE: 3E 01       ld   a,$01
D6D0: 32 60 61    ld   (pickup_flag_6160),a
D6D3: CD BD DA    call $DABD
D6D6: C9          ret
D6D7: 06 04       ld   b,$04
D6D9: DD 7E 00    ld   a,(ix+$00)
D6DC: FD 77 00    ld   (iy+$00),a
D6DF: DD 23       inc  ix
D6E1: FD 23       inc  iy
D6E3: 10 F4       djnz $D6D9
D6E5: C9          ret
D6E6: 3A 0D 60    ld   a,(player_screen_600D)
D6E9: FE 05       cp   $05
D6EB: C0          ret  nz
D6EC: DD 7E 02    ld   a,(ix+$02)
D6EF: FE A9       cp   $A9
D6F1: D8          ret  c
D6F2: 3A E3 62    ld   a,(unknown_62E3)
D6F5: C6 08       add  a,$08
D6F7: 47          ld   b,a
D6F8: C6 08       add  a,$08
D6FA: 4F          ld   c,a
D6FB: DD 7E 03    ld   a,(ix+$03)
D6FE: B8          cp   b
D6FF: D8          ret  c
D700: B9          cp   c
D701: D0          ret  nc
D702: 3E 01       ld   a,$01
D704: FD 77 00    ld   (iy+$00),a
D707: C9          ret
D708: 3A 0D 60    ld   a,(player_screen_600D)
D70B: FE 05       cp   $05
D70D: 20 0B       jr   nz,$D71A
D70F: DD 21 80 65 ld   ix,player_struct_6580
D713: FD 21 25 60 ld   iy,player_death_flag_6025
D717: CD E6 D6    call $D6E6
D71A: 3A 99 60    ld   a,(guard_1_screen_6099)
D71D: FE 05       cp   $05
D71F: 20 0B       jr   nz,$D72C
D721: DD 21 94 65 ld   ix,guard_1_struct_6594
D725: FD 21 9F 62 ld   iy,unknown_629F
D729: CD E6 D6    call $D6E6
D72C: 3A 9A 60    ld   a,(guard_2_screen_609A)
D72F: FE 05       cp   $05
D731: C0          ret  nz
D732: DD 21 98 65 ld   ix,guard_2_struct_6598
D736: FD 21 A7 62 ld   iy,unknown_62A7
D73A: CD E6 D6    call $D6E6
D73D: C9          ret
D73E: 3A C7 61    ld   a,(holds_barrow_61C7)
D741: FE 01       cp   $01
D743: C8          ret  z
D744: 3A CF 61    ld   a,(has_pick_61CF)
D747: FE 01       cp   $01
D749: C8          ret  z
D74A: 3A 11 63    ld   a,(unknown_6311)
D74D: FE 01       cp   $01
D74F: C8          ret  z
D750: 3A 58 61    ld   a,(has_bag_6158)
D753: FE 01       cp   $01
D755: C9          ret
D756: AF          xor  a
D757: 32 97 60    ld   (guard_2_not_moving_timeout_counter_6097),a
D75A: 32 88 62    ld   (unknown_6288),a
D75D: 32 08 60    ld   (unknown_6008),a
D760: 32 13 60    ld   (unknown_6013),a
D763: 32 29 60    ld   (player_in_wagon_flag_6029),a
D766: 32 2A 60    ld   (player_gripping_handle_602A),a
D769: 32 4E 60    ld   (fatal_fall_height_reached_604E),a
D76C: 32 77 60    ld   (guard_2_in_elevator_6077),a
D76F: 32 28 60    ld   (player_controls_frozen_6028),a
D772: 32 E0 61    ld   (pickaxe_timer_duration_61E0),a
D775: 32 E1 61    ld   (unknown_61E1),a
D778: 32 14 60    ld   (unknown_6014),a
D77B: 32 13 60    ld   (unknown_6013),a
D77E: 32 B5 62    ld   (unknown_62B5),a
D781: 32 B6 62    ld   (unknown_62B6),a
D784: 32 B9 62    ld   (unknown_62B9),a
D787: 32 BA 62    ld   (unknown_62BA),a
D78A: 32 AF 62    ld   (unknown_62AF),a
D78D: 32 B0 62    ld   (unknown_62B0),a
D790: 32 D2 62    ld   (unknown_62D2),a
D793: 32 D6 62    ld   (unknown_62D6),a
D796: 32 DA 62    ld   (unknown_62DA),a
D799: 32 D3 62    ld   (unknown_62D3),a
D79C: 32 BD 62    ld   (unknown_62BD),a
D79F: 32 F6 61    ld   (picked_up_object_screen_address_61F6),a
D7A2: 32 F7 61    ld   (unknown_61F7),a
D7A5: 32 11 63    ld   (unknown_6311),a
D7A8: C9          ret
D7A9: 3A D3 60    ld   a,(unknown_60D3)
D7AC: FE 02       cp   $02
D7AE: D8          ret  c
D7AF: 3E 06       ld   a,$06
D7B1: 32 94 62    ld   (unknown_6294),a
D7B4: 32 9C 62    ld   (unknown_629C),a
D7B7: 32 A4 62    ld   (unknown_62A4),a
D7BA: 3E 01       ld   a,$01
D7BC: 32 93 62    ld   (unknown_6293),a
D7BF: 32 9B 62    ld   (unknown_629B),a
D7C2: 32 A3 62    ld   (unknown_62A3),a
D7C5: 32 99 62    ld   (unknown_6299),a
D7C8: C9          ret
D7C9: AF          xor  a
D7CA: 32 C7 61    ld   (holds_barrow_61C7),a
D7CD: 32 CF 61    ld   (has_pick_61CF),a
D7D0: 32 14 60    ld   (unknown_6014),a
D7D3: 32 1C 60    ld   (player_in_wagon_1_601C),a
D7D6: 32 58 61    ld   (has_bag_6158),a
D7D9: 32 40 63    ld   (unknown_6340),a
D7DC: 32 41 63    ld   (unknown_6341),a
D7DF: 3E 01       ld   a,$01
D7E1: 32 D3 60    ld   (unknown_60D3),a
D7E4: 32 B6 61    ld   (unknown_61B6),a
D7E7: C9          ret
D7E8: DD E5       push ix
D7EA: F5          push af
D7EB: D5          push de
D7EC: C5          push bc
D7ED: DD 21 01 90 ld   ix,$9001
D7F1: FD 21 00 90 ld   iy,$9000
D7F5: 11 20 00    ld   de,$0020
D7F8: 06 20       ld   b,$20
D7FA: DD E5       push ix
D7FC: FD E5       push iy
D7FE: C5          push bc
D7FF: 06 1F       ld   b,$1F
D801: DD 7E 00    ld   a,(ix+$00)
D804: 4F          ld   c,a
D805: DD 7E 00    ld   a,(ix+$00)
D808: B9          cp   c
D809: 20 F6       jr   nz,$D801
D80B: FD 77 00    ld   (iy+$00),a
D80E: DD 23       inc  ix
D810: FD 23       inc  iy
D812: 10 ED       djnz $D801
D814: 3E 0A       ld   a,$0A
D816: FD 77 00    ld   (iy+$00),a
D819: C1          pop  bc
D81A: FD E1       pop  iy
D81C: DD E1       pop  ix
D81E: DD 19       add  ix,de
D820: FD 19       add  iy,de
D822: 10 D6       djnz $D7FA
D824: C1          pop  bc
D825: D1          pop  de
D826: F1          pop  af
D827: DD E1       pop  ix
D829: C9          ret
D82A: AF          xor  a
D82B: 06 20       ld   b,$20
D82D: 21 00 98    ld   hl,$9800
D830: 77          ld   (hl),a
D831: 23          inc  hl
D832: 10 FC       djnz $D830
D834: 32 5F 98    ld   ($985F),a
D837: 3E 01       ld   a,$01
D839: 32 03 A0    ld   ($A003),a
D83C: CD E2 D8    call $D8E2
D83F: 21 B0 93    ld   hl,$93B0
D842: 22 2F 63    ld   (unknown_632F),hl
D845: ED 56       im   1
D847: FB          ei
D848: 3E 01       ld   a,$01
D84A: 32 00 A0    ld   (interrupt_control_A000),a
D84D: DD 7E 00    ld   a,(ix+$00)
D850: FE FF       cp   $FF
D852: 28 1F       jr   z,$D873
D854: CD A2 D8    call $D8A2
D857: CD D4 D8    call $D8D4
D85A: DD 23       inc  ix
D85C: DD 7E 00    ld   a,(ix+$00)
D85F: FE FE       cp   $FE
D861: CC 86 D8    call z,$D886
D864: 3A 42 63    ld   a,(unknown_6342)
D867: FE 01       cp   $01
D869: 28 E2       jr   z,$D84D
D86B: 3A 00 60    ld   a,(number_of_credits_6000)
D86E: FE 00       cp   $00
D870: C0          ret  nz
D871: 18 DA       jr   $D84D
D873: CD D4 D8    call $D8D4
D876: CD D4 D8    call $D8D4
D879: CD D4 D8    call $D8D4
D87C: CD D4 D8    call $D8D4
D87F: CD D4 D8    call $D8D4
D882: CD D4 D8    call $D8D4
D885: C9          ret
D886: 2A 2F 63    ld   hl,(unknown_632F)
D889: F5          push af
D88A: 7D          ld   a,l
D88B: FE BF       cp   $BF
D88D: 20 05       jr   nz,$D894
D88F: CD E8 D7    call $D7E8
D892: 18 01       jr   $D895
D894: 23          inc  hl
D895: 22 2F 63    ld   (unknown_632F),hl
D898: F1          pop  af
D899: DD 23       inc  ix
D89B: CD E8 D7    call $D7E8
D89E: CD CD D8    call $D8CD
D8A1: C9          ret
D8A2: DD 7E 00    ld   a,(ix+$00)
D8A5: D6 30       sub  $30
D8A7: FE 0A       cp   $0A
D8A9: CC D4 D8    call z,$D8D4
D8AC: 77          ld   (hl),a
D8AD: FE 0A       cp   $0A
D8AF: C4 C0 D8    call nz,$D8C0
D8B2: E5          push hl
D8B3: 11 00 08    ld   de,$0800
D8B6: 19          add  hl,de
D8B7: 3E 04       ld   a,$04
D8B9: 77          ld   (hl),a
D8BA: E1          pop  hl
D8BB: 11 E0 FF    ld   de,$FFE0
D8BE: 19          add  hl,de
D8BF: C9          ret
D8C0: E5          push hl
D8C1: C5          push bc
D8C2: D5          push de
D8C3: 21 7B D9    ld   hl,$D97B
D8C6: CD 84 EC    call play_sample_EC84
D8C9: D1          pop  de
D8CA: C1          pop  bc
D8CB: E1          pop  hl
D8CC: C9          ret
D8CD: E5          push hl
D8CE: F5          push af
D8CF: 21 00 60    ld   hl,number_of_credits_6000
D8D2: 18 05       jr   $D8D9
D8D4: E5          push hl
D8D5: F5          push af
D8D6: 21 00 30    ld   hl,$3000
D8D9: 2B          dec  hl
D8DA: 7C          ld   a,h
D8DB: FE 00       cp   $00
D8DD: 20 FA       jr   nz,$D8D9
D8DF: F1          pop  af
D8E0: E1          pop  hl
D8E1: C9          ret
D8E2: F5          push af
D8E3: 00          nop
D8E4: 00          nop
D8E5: 00          nop
D8E6: 00          nop
D8E7: 32 01 A0    ld   ($A001),a
D8EA: 32 02 A0    ld   ($A002),a
D8ED: F1          pop  af
D8EE: C9          ret
D8EF: C9          ret
D8F0: 79          ld   a,c
D8F1: 2F          cpl
D8F2: 3C          inc  a
D8F3: 4F          ld   c,a
D8F4: C9          ret

D9BA: 7E          ld   a,(hl)
D9BB: FE 01       cp   $01
D9BD: 20 0D       jr   nz,$D9CC
D9BF: 7E          ld   a,(hl)
D9C0: 23          inc  hl
D9C1: 77          ld   (hl),a
D9C2: 2A 46 61    ld   hl,(unknown_pointer_6146)
D9C5: 23          inc  hl
D9C6: 23          inc  hl
D9C7: 23          inc  hl
D9C8: 23          inc  hl
D9C9: AF          xor  a
D9CA: 77          ld   (hl),a
D9CB: C9          ret
D9CC: FD E5       push iy
D9CE: FD 21 A8 23 ld   iy,$23A8
D9D2: FD 7E 00    ld   a,(iy+$00)
D9D5: 67          ld   h,a
D9D6: FD 7E 01    ld   a,(iy+$01)
D9D9: 6F          ld   l,a
D9DA: AF          xor  a
D9DB: ED 52       sbc  hl,de
D9DD: 28 14       jr   z,$D9F3
D9DF: FD 23       inc  iy
D9E1: FD 23       inc  iy
D9E3: FD 7E 01    ld   a,(iy+$01)
D9E6: FE FF       cp   $FF
D9E8: 20 E8       jr   nz,$D9D2
D9EA: 2A 3D 63    ld   hl,(unknown_633D)
D9ED: 7E          ld   a,(hl)
D9EE: 23          inc  hl
D9EF: 77          ld   (hl),a
D9F0: FD E1       pop  iy
D9F2: C9          ret
D9F3: FD E1       pop  iy
D9F5: 2A 3D 63    ld   hl,(unknown_633D)
D9F8: 23          inc  hl
D9F9: 7E          ld   a,(hl)
D9FA: 2A 46 61    ld   hl,(unknown_pointer_6146)
D9FD: FE 01       cp   $01
D9FF: 20 21       jr   nz,$DA22
DA01: 2A 95 60    ld   hl,(guard_direction_pointer_6095)
DA04: 3E 40       ld   a,$40
DA06: 77          ld   (hl),a
DA07: C9          ret
DA08: 06 80       ld   b,$80
DA0A: FD 7E 03    ld   a,(iy+$03)
DA0D: FE 98       cp   $98
DA0F: 28 02       jr   z,$DA13
DA11: 06 40       ld   b,$40
DA13: 2A 95 60    ld   hl,(guard_direction_pointer_6095)
DA16: 78          ld   a,b
DA17: 77          ld   (hl),a
DA18: 2A 46 61    ld   hl,(unknown_pointer_6146)
DA1B: 23          inc  hl
DA1C: 23          inc  hl
DA1D: 23          inc  hl
DA1E: 23          inc  hl
DA1F: AF          xor  a
DA20: 77          ld   (hl),a
DA21: C9          ret
DA22: 3A 0D 60    ld   a,(player_screen_600D)
DA25: FE 05       cp   $05
DA27: 20 DF       jr   nz,$DA08
DA29: FD 7E 03    ld   a,(iy+$03)
DA2C: 23          inc  hl
DA2D: 23          inc  hl
DA2E: 23          inc  hl
DA2F: 23          inc  hl
DA30: 47          ld   b,a
DA31: 3A E3 62    ld   a,(unknown_62E3)
DA34: B8          cp   b
DA35: 28 15       jr   z,$DA4C
DA37: 3D          dec  a
DA38: B8          cp   b
DA39: 28 11       jr   z,$DA4C
DA3B: 3E 01       ld   a,$01
DA3D: 77          ld   (hl),a
DA3E: 7D          ld   a,l
DA3F: 21 57 60    ld   hl,guard_1_not_moving_timeout_counter_6057
DA42: FE 48       cp   $48
DA44: 28 03       jr   z,$DA49
DA46: 21 97 60    ld   hl,guard_2_not_moving_timeout_counter_6097
DA49: AF          xor  a
DA4A: 77          ld   (hl),a
DA4B: C9          ret
DA4C: AF          xor  a
DA4D: 77          ld   (hl),a
DA4E: 2A 95 60    ld   hl,(guard_direction_pointer_6095)
DA51: 3E 80       ld   a,$80
DA53: 77          ld   (hl),a
DA54: C9          ret
DA55: 3A 34 63    ld   a,(unknown_6334)
DA58: FE 01       cp   $01
DA5A: C8          ret  z
DA5B: 2A 26 63    ld   hl,(unknown_6326)
DA5E: 7E          ld   a,(hl)
DA5F: FE D4       cp   $D4
DA61: 28 07       jr   z,$DA6A
DA63: 3E D4       ld   a,$D4
DA65: 08          ex   af,af'
DA66: 3E 24       ld   a,$24
DA68: 18 05       jr   $DA6F
DA6A: 3E D0       ld   a,$D0
DA6C: 08          ex   af,af'
DA6D: 3E 2C       ld   a,$2C
DA6F: 08          ex   af,af'
DA70: 77          ld   (hl),a
DA71: E5          push hl
DA72: F5          push af
DA73: 7C          ld   a,h
DA74: C6 08       add  a,$08
DA76: 67          ld   h,a
DA77: F1          pop  af
DA78: 08          ex   af,af'
DA79: 77          ld   (hl),a
DA7A: E1          pop  hl
DA7B: 11 20 00    ld   de,$0020
DA7E: 19          add  hl,de
DA7F: 08          ex   af,af'
DA80: 3C          inc  a
DA81: 3C          inc  a
DA82: 77          ld   (hl),a
DA83: 7C          ld   a,h
DA84: C6 08       add  a,$08
DA86: 67          ld   h,a
DA87: 08          ex   af,af'
DA88: 77          ld   (hl),a
DA89: C9          ret
DA8A: 3A CF 61    ld   a,(has_pick_61CF)
DA8D: FE 00       cp   $00
DA8F: C8          ret  z
DA90: 2A E0 61    ld   hl,(pickaxe_timer_duration_61E0)
DA93: 7D          ld   a,l
DA94: FE 00       cp   $00
DA96: 20 06       jr   nz,$DA9E
DA98: 7C          ld   a,h
DA99: FE 00       cp   $00
DA9B: 20 01       jr   nz,$DA9E
DA9D: C9          ret
DA9E: 23          inc  hl
DA9F: 22 E0 61    ld   (pickaxe_timer_duration_61E0),hl
DAA2: 11 FF 01    ld   de,$01FF
DAA5: ED 52       sbc  hl,de
DAA7: C0          ret  nz
DAA8: 21 00 00    ld   hl,$0000
DAAB: 22 E0 61    ld   (pickaxe_timer_duration_61E0),hl
DAAE: 3E 00       ld   a,$00
DAB0: DD 21 CC 61 ld   ix,current_pickaxe_screen_params_61CC
DAB4: DD 77 03    ld   (ix+$03),a
DAB7: 3E FF       ld   a,$FF
DAB9: 32 9F 65    ld   (sprite_object_y_659F),a
DABC: C9          ret
DABD: 3A 60 61    ld   a,(pickup_flag_6160)
DAC0: FE 01       cp   $01
DAC2: C0          ret  nz
DAC3: 3A 34 63    ld   a,(unknown_6334)
DAC6: FE 01       cp   $01
DAC8: C8          ret  z
DAC9: 3A CF 61    ld   a,(has_pick_61CF)
DACC: FE 01       cp   $01
DACE: 28 28       jr   z,$DAF8
DAD0: 3A 58 61    ld   a,(has_bag_6158)
DAD3: FE 01       cp   $01
DAD5: 28 21       jr   z,$DAF8
DAD7: 3A 11 63    ld   a,(unknown_6311)
DADA: FE 01       cp   $01
DADC: CA 65 DB    jp   z,$DB65
DADF: 01 C7 61    ld   bc,holds_barrow_61C7
DAE2: FD 21 C4 61 ld   iy,barrow_screen_params_61C4
DAE6: 3E 3A       ld   a,$3A
DAE8: FD 77 04    ld   (iy+$04),a
DAEB: 3E 28       ld   a,$28
DAED: FD 77 05    ld   (iy+$05),a
DAF0: 3E EC       ld   a,$EC
DAF2: 32 CA 61    ld   (unknown_61CA),a
DAF5: CD CC FB    call check_object_pickup_FBCC
DAF8: 06 04       ld   b,$04
DAFA: FD 21 D0 61 ld   iy,struct_swap_buffer_61D0
DAFE: 3A C7 61    ld   a,(holds_barrow_61C7)
DB01: FE 01       cp   $01
DB03: CA 4F DB    jp   z,$DB4F
DB06: C5          push bc
DB07: FD E5       push iy
DB09: 01 CF 61    ld   bc,has_pick_61CF
DB0C: FD 21 CC 61 ld   iy,current_pickaxe_screen_params_61CC
DB10: 3E 37       ld   a,$37
DB12: FD 77 04    ld   (iy+$04),a
DB15: 3E 20       ld   a,$20
DB17: FD 77 05    ld   (iy+$05),a
DB1A: 3A 00 B8    ld   a,(io_read_shit_B800)
DB1D: 3E E4       ld   a,$E4
DB1F: 32 D2 61    ld   (unknown_61D2),a
DB22: CD CC FB    call check_object_pickup_FBCC
DB25: FD E1       pop  iy
DB27: FD 23       inc  iy
DB29: FD 23       inc  iy
DB2B: FD 23       inc  iy
DB2D: CD C2 DB    call swap_3_bytes_DBC2
DB30: C1          pop  bc
DB31: 10 D3       djnz $DB06
DB33: 01 CF 61    ld   bc,has_pick_61CF
DB36: FD 21 CC 61 ld   iy,current_pickaxe_screen_params_61CC
DB3A: 3E 37       ld   a,$37
DB3C: FD 77 04    ld   (iy+$04),a
DB3F: 3E 20       ld   a,$20
DB41: FD 77 05    ld   (iy+$05),a
DB44: 3A 00 B8    ld   a,(io_read_shit_B800)
DB47: 3E E4       ld   a,$E4
DB49: 32 D2 61    ld   (unknown_61D2),a
DB4C: CD CC FB    call check_object_pickup_FBCC
DB4F: 3A 60 61    ld   a,(pickup_flag_6160)
DB52: FE 01       cp   $01
DB54: C0          ret  nz
DB55: 3A C7 61    ld   a,(holds_barrow_61C7)
DB58: FE 01       cp   $01
DB5A: CA B4 DB    jp   z,$DBB4
DB5D: 3A CF 61    ld   a,(has_pick_61CF)
DB60: FE 01       cp   $01
DB62: CA B4 DB    jp   z,$DBB4
DB65: 06 04       ld   b,$04
DB67: FD 21 12 63 ld   iy,unknown_6312
DB6B: C5          push bc
DB6C: FD E5       push iy
DB6E: 01 11 63    ld   bc,unknown_6311
DB71: FD 21 0E 63 ld   iy,unknown_630E
DB75: 3E 35       ld   a,$35
DB77: FD 77 04    ld   (iy+$04),a
DB7A: 3E 24       ld   a,$24
DB7C: FD 77 05    ld   (iy+$05),a
DB7F: 3A 00 B8    ld   a,(io_read_shit_B800)
DB82: 3E D4       ld   a,$D4
DB84: 32 14 63    ld   (unknown_6314),a
DB87: CD CC FB    call check_object_pickup_FBCC
DB8A: FD E1       pop  iy
DB8C: FD 23       inc  iy
DB8E: FD 23       inc  iy
DB90: FD 23       inc  iy
DB92: CD B5 DB    call $DBB5
DB95: C1          pop  bc
DB96: 10 D3       djnz $DB6B
DB98: 01 11 63    ld   bc,unknown_6311
DB9B: FD 21 0E 63 ld   iy,unknown_630E
DB9F: 3E 32       ld   a,$32
DBA1: FD 77 04    ld   (iy+$04),a
DBA4: 3E 24       ld   a,$24
DBA6: FD 77 05    ld   (iy+$05),a
DBA9: 3A 00 B8    ld   a,(io_read_shit_B800)
DBAC: 3E D4       ld   a,$D4
DBAE: 32 14 63    ld   (unknown_6314),a
DBB1: CD CC FB    call check_object_pickup_FBCC
DBB4: C9          ret
DBB5: C5          push bc
DBB6: FD E5       push iy
DBB8: DD E5       push ix
DBBA: 06 03       ld   b,$03
DBBC: DD 21 0E 63 ld   ix,unknown_630E
DBC0: 18 0B       jr   $DBCD

swap_3_bytes_DBC2:
DBC2: C5          push bc
DBC3: FD E5       push iy
DBC5: DD E5       push ix
DBC7: 06 03       ld   b,$03
DBC9: DD 21 CC 61 ld   ix,current_pickaxe_screen_params_61CC
DBCD: DD 7E 00    ld   a,(ix+$00)
DBD0: 08          ex   af,af'
DBD1: FD 7E 00    ld   a,(iy+$00)
DBD4: DD 77 00    ld   (ix+$00),a
DBD7: 08          ex   af,af'
DBD8: FD 77 00    ld   (iy+$00),a
DBDB: DD 23       inc  ix
DBDD: FD 23       inc  iy
DBDF: 10 EC       djnz $DBCD
DBE1: DD E1       pop  ix
DBE3: FD E1       pop  iy
DBE5: C1          pop  bc
DBE6: C9          ret
DBE7: 3A F5 62    ld   a,(unknown_62F5)
DBEA: FE 01       cp   $01
DBEC: C0          ret  nz
DBED: AF          xor  a
DBEE: 32 51 63    ld   (unknown_6351),a
DBF1: 2A 26 63    ld   hl,(unknown_6326)
DBF4: 22 F6 61    ld   (picked_up_object_screen_address_61F6),hl
DBF7: CD F3 F3    call $F3F3
DBFA: 2A 26 63    ld   hl,(unknown_6326)
DBFD: 11 40 00    ld   de,$0040
DC00: 19          add  hl,de
DC01: 22 F8 62    ld   (unknown_62F8),hl
DC04: 21 B6 DE    ld   hl,$DEB6
DC07: 22 F6 62    ld   (unknown_62F6),hl
DC0A: FD 2A F8 62 ld   iy,(unknown_62F8)
DC0E: DD 21 FC 62 ld   ix,unknown_62FC
DC12: FD 7E 00    ld   a,(iy+$00)
DC15: DD 77 00    ld   (ix+$00),a
DC18: FD 7E 01    ld   a,(iy+$01)
DC1B: DD 77 01    ld   (ix+$01),a
DC1E: FD 7E E0    ld   a,(iy-$20)
DC21: DD 77 02    ld   (ix+$02),a
DC24: FD 7E E1    ld   a,(iy-$1f)
DC27: DD 77 03    ld   (ix+$03),a
DC2A: FD 7E C0    ld   a,(iy-$40)
DC2D: DD 77 04    ld   (ix+$04),a
DC30: FD 7E C1    ld   a,(iy-$3f)
DC33: DD 77 05    ld   (ix+$05),a
DC36: FD 7E A0    ld   a,(iy-$60)
DC39: DD 77 06    ld   (ix+$06),a
DC3C: FD 7E A1    ld   a,(iy-$5f)
DC3F: DD 77 07    ld   (ix+$07),a
DC42: E5          push hl
DC43: C5          push bc
DC44: FD E5       push iy
DC46: 06 08       ld   b,$08
DC48: FD 21 FC 62 ld   iy,unknown_62FC
DC4C: 16 0B       ld   d,$0B
DC4E: FD 7E 00    ld   a,(iy+$00)
DC51: BA          cp   d
DC52: DC F3 DC    call c,$DCF3
DC55: FD 23       inc  iy
DC57: 10 F5       djnz $DC4E
DC59: 18 00       jr   $DC5B
DC5B: FD E1       pop  iy
DC5D: C1          pop  bc
DC5E: E1          pop  hl
DC5F: FD 2A F8 62 ld   iy,(unknown_62F8)
DC63: 11 00 08    ld   de,$0800
DC66: FD 19       add  iy,de
DC68: DD 21 04 63 ld   ix,unknown_6304
DC6C: FD 7E 00    ld   a,(iy+$00)
DC6F: DD 77 00    ld   (ix+$00),a
DC72: FD 7E 01    ld   a,(iy+$01)
DC75: DD 77 01    ld   (ix+$01),a
DC78: FD 7E E0    ld   a,(iy-$20)
DC7B: DD 77 02    ld   (ix+$02),a
DC7E: FD 7E E1    ld   a,(iy-$1f)
DC81: DD 77 03    ld   (ix+$03),a
DC84: FD 7E C0    ld   a,(iy-$40)
DC87: DD 77 04    ld   (ix+$04),a
DC8A: FD 7E C1    ld   a,(iy-$3f)
DC8D: DD 77 05    ld   (ix+$05),a
DC90: FD 7E A0    ld   a,(iy-$60)
DC93: DD 77 06    ld   (ix+$06),a
DC96: FD 7E A1    ld   a,(iy-$5f)
DC99: DD 77 07    ld   (ix+$07),a
DC9C: CD 3B DE    call $DE3B
DC9F: 06 08       ld   b,$08
DCA1: DD 21 FC 62 ld   ix,unknown_62FC
DCA5: FD 21 04 63 ld   iy,unknown_6304
DCA9: CD DD DC    call $DCDD
DCAC: DD 23       inc  ix
DCAE: FD 23       inc  iy
DCB0: 10 F7       djnz $DCA9
DCB2: 3E 01       ld   a,$01
DCB4: 32 F5 62    ld   (unknown_62F5),a
DCB7: 3A 54 60    ld   a,(gameplay_allowed_6054)
DCBA: FE 00       cp   $00
DCBC: C8          ret  z
DCBD: 3E 1F       ld   a,$1F
DCBF: 32 4C 63    ld   (unknown_634C),a
DCC2: 3E 07       ld   a,$07
DCC4: 32 4D 63    ld   (unknown_634D),a
DCC7: 3A 48 63    ld   a,(unknown_6348)
DCCA: FE 01       cp   $01
DCCC: C8          ret  z
DCCD: 21 DC 3F    ld   hl,$3FDC
DCD0: 22 4E 63    ld   (unknown_634E),hl
DCD3: AF          xor  a
DCD4: 32 42 61    ld   (ay_sound_start_6142),a
DCD7: 3E 03       ld   a,$03
DCD9: 32 48 63    ld   (unknown_6348),a
DCDC: C9          ret
DCDD: DD 7E 00    ld   a,(ix+$00)
DCE0: FE 49       cp   $49
DCE2: 28 09       jr   z,$DCED
DCE4: FE 4A       cp   $4A
DCE6: 28 05       jr   z,$DCED
DCE8: FE 4B       cp   $4B
DCEA: 28 01       jr   z,$DCED
DCEC: C9          ret
DCED: 3E 1F       ld   a,$1F
DCEF: FD 77 00    ld   (iy+$00),a
DCF2: C9          ret
DCF3: 3E E0       ld   a,$E0
DCF5: FD 77 00    ld   (iy+$00),a
DCF8: 3E 3F       ld   a,$3F
DCFA: FD 77 08    ld   (iy+$08),a
DCFD: 3A 0D 60    ld   a,(player_screen_600D)
DD00: FE 05       cp   $05
DD02: C0          ret  nz
DD03: CD 77 EA    call $EA77
DD06: CD 77 EA    call $EA77
DD09: CD 77 EA    call $EA77
DD0C: CD 77 EA    call $EA77
DD0F: CD 77 EA    call $EA77
DD12: C9          ret
DD13: 3A F5 62    ld   a,(unknown_62F5)
DD16: FE 01       cp   $01
DD18: C0          ret  nz
DD19: 3A 34 63    ld   a,(unknown_6334)
DD1C: FE 01       cp   $01
DD1E: C8          ret  z
DD1F: 3A FA 62    ld   a,(unknown_62FA)
DD22: FE 00       cp   $00
DD24: 28 05       jr   z,$DD2B
DD26: 3D          dec  a
DD27: 32 FA 62    ld   (unknown_62FA),a
DD2A: C9          ret
DD2B: FD 2A F6 62 ld   iy,(unknown_62F6)
DD2F: 2A F8 62    ld   hl,(unknown_62F8)
DD32: FD 7E 00    ld   a,(iy+$00)
DD35: 77          ld   (hl),a
DD36: CD AC DE    call $DEAC
DD39: 11 E0 FF    ld   de,$FFE0
DD3C: 19          add  hl,de
DD3D: FD 23       inc  iy
DD3F: FD 7E 00    ld   a,(iy+$00)
DD42: 77          ld   (hl),a
DD43: CD AC DE    call $DEAC
DD46: 19          add  hl,de
DD47: FD 23       inc  iy
DD49: FD 7E 00    ld   a,(iy+$00)
DD4C: 77          ld   (hl),a
DD4D: CD AC DE    call $DEAC
DD50: 19          add  hl,de
DD51: FD 23       inc  iy
DD53: FD 7E 00    ld   a,(iy+$00)
DD56: 77          ld   (hl),a
DD57: CD AC DE    call $DEAC
DD5A: FD 23       inc  iy
DD5C: 11 61 00    ld   de,$0061
DD5F: 19          add  hl,de
DD60: FD 7E 00    ld   a,(iy+$00)
DD63: 77          ld   (hl),a
DD64: CD AC DE    call $DEAC
DD67: FD 23       inc  iy
DD69: 11 E0 FF    ld   de,$FFE0
DD6C: 19          add  hl,de
DD6D: FD 7E 00    ld   a,(iy+$00)
DD70: 77          ld   (hl),a
DD71: CD AC DE    call $DEAC
DD74: FD 23       inc  iy
DD76: 19          add  hl,de
DD77: FD 7E 00    ld   a,(iy+$00)
DD7A: 77          ld   (hl),a
DD7B: CD AC DE    call $DEAC
DD7E: FD 23       inc  iy
DD80: FD 7E 00    ld   a,(iy+$00)
DD83: 19          add  hl,de
DD84: 77          ld   (hl),a
DD85: CD AC DE    call $DEAC
DD88: FD 23       inc  iy
DD8A: FD 22 F6 62 ld   (unknown_62F6),iy
DD8E: 3E 03       ld   a,$03
DD90: 32 FA 62    ld   (unknown_62FA),a
DD93: FD 7E 00    ld   a,(iy+$00)
DD96: FE FF       cp   $FF
DD98: C0          ret  nz
DD99: AF          xor  a
DD9A: 32 F5 62    ld   (unknown_62F5),a
DD9D: FD 2A F8 62 ld   iy,(unknown_62F8)
DDA1: DD 21 FC 62 ld   ix,unknown_62FC
DDA5: DD 7E 00    ld   a,(ix+$00)
DDA8: FD 77 00    ld   (iy+$00),a
DDAB: DD 7E 01    ld   a,(ix+$01)
DDAE: FD 77 01    ld   (iy+$01),a
DDB1: DD 7E 02    ld   a,(ix+$02)
DDB4: FD 77 E0    ld   (iy-$20),a
DDB7: DD 7E 03    ld   a,(ix+$03)
DDBA: FD 77 E1    ld   (iy-$1f),a
DDBD: DD 7E 04    ld   a,(ix+$04)
DDC0: FD 77 C0    ld   (iy-$40),a
DDC3: DD 7E 05    ld   a,(ix+$05)
DDC6: FD 77 C1    ld   (iy-$3f),a
DDC9: DD 7E 06    ld   a,(ix+$06)
DDCC: FD 77 A0    ld   (iy-$60),a
DDCF: DD 7E 07    ld   a,(ix+$07)
DDD2: FD 77 A1    ld   (iy-$5f),a
DDD5: FD 2A F8 62 ld   iy,(unknown_62F8)
DDD9: 11 00 08    ld   de,$0800
DDDC: FD 19       add  iy,de
DDDE: DD 21 04 63 ld   ix,unknown_6304
DDE2: DD 7E 00    ld   a,(ix+$00)
DDE5: FD 77 00    ld   (iy+$00),a
DDE8: DD 7E 01    ld   a,(ix+$01)
DDEB: FD 77 01    ld   (iy+$01),a
DDEE: DD 7E 02    ld   a,(ix+$02)
DDF1: FD 77 E0    ld   (iy-$20),a
DDF4: DD 7E 03    ld   a,(ix+$03)
DDF7: FD 77 E1    ld   (iy-$1f),a
DDFA: DD 7E 04    ld   a,(ix+$04)
DDFD: FD 77 C0    ld   (iy-$40),a
DE00: DD 7E 05    ld   a,(ix+$05)
DE03: FD 77 C1    ld   (iy-$3f),a
DE06: DD 7E 06    ld   a,(ix+$06)
DE09: FD 77 A0    ld   (iy-$60),a
DE0C: DD 7E 07    ld   a,(ix+$07)
DE0F: FD 77 A1    ld   (iy-$5f),a
DE12: 3A 36 63    ld   a,(unknown_6336)
DE15: FE 01       cp   $01
DE17: 20 03       jr   nz,$DE1C
DE19: 32 25 60    ld   (player_death_flag_6025),a
DE1C: 3A 37 63    ld   a,(unknown_6337)
DE1F: FE 01       cp   $01
DE21: 20 03       jr   nz,$DE26
DE23: 32 9F 62    ld   (unknown_629F),a
DE26: 3A 38 63    ld   a,(unknown_6338)
DE29: FE 01       cp   $01
DE2B: 20 03       jr   nz,$DE30
DE2D: 32 A7 62    ld   (unknown_62A7),a
DE30: AF          xor  a
DE31: 32 36 63    ld   (unknown_6336),a
DE34: 32 37 63    ld   (unknown_6337),a
DE37: 32 38 63    ld   (unknown_6338),a
DE3A: C9          ret
DE3B: 2A F8 62    ld   hl,(unknown_62F8)
DE3E: CD 64 EB    call $EB64
DE41: FD 21 36 63 ld   iy,unknown_6336
DE45: DD 21 80 65 ld   ix,player_struct_6580
DE49: CD 4E EB    call $EB4E
DE4C: FD 7E 00    ld   a,(iy+$00)
DE4F: FE 01       cp   $01
DE51: 20 08       jr   nz,$DE5B
DE53: 3E 01       ld   a,$01
DE55: 32 60 61    ld   (pickup_flag_6160),a
DE58: CD 99 E3    call $E399
DE5B: FD 21 37 63 ld   iy,unknown_6337
DE5F: DD 21 94 65 ld   ix,guard_1_struct_6594
DE63: CD 4E EB    call $EB4E
DE66: FD 7E 00    ld   a,(iy+$00)
DE69: FE 01       cp   $01
DE6B: CC 21 E3    call z,$E321
DE6E: FD 21 38 63 ld   iy,unknown_6338
DE72: DD 21 98 65 ld   ix,guard_2_struct_6598
DE76: CD 4E EB    call $EB4E
DE79: FD 7E 00    ld   a,(iy+$00)
DE7C: FE 01       cp   $01
DE7E: CC 7D E3    call z,$E37D
DE81: C9          ret
DE82: 3A 0D 60    ld   a,(player_screen_600D)
DE85: D5          push de
DE86: 47          ld   b,a
DE87: 11 A6 DE    ld   de,$DEA6
DE8A: 13          inc  de
DE8B: 10 FD       djnz $DE8A
DE8D: 1A          ld   a,(de)
DE8E: 47          ld   b,a
DE8F: 7C          ld   a,h
DE90: 90          sub  b
DE91: 67          ld   h,a
DE92: D1          pop  de
DE93: C9          ret
DE94: 3A 0D 60    ld   a,(player_screen_600D)
DE97: D5          push de
DE98: 47          ld   b,a
DE99: 11 A6 DE    ld   de,$DEA6
DE9C: 13          inc  de
DE9D: 10 FD       djnz $DE9C
DE9F: 1A          ld   a,(de)
DEA0: 47          ld   b,a
DEA1: 7C          ld   a,h
DEA2: 80          add  a,b
DEA3: 67          ld   h,a
DEA4: D1          pop  de
DEA5: C9          ret
DEA6: 00          nop
DEA7: 50          ld   d,b
DEA8: 4C          ld   c,h
DEA9: 48          ld   c,b
DEAA: 60          ld   h,b
DEAB: 5C          ld   e,h
DEAC: E5          push hl
DEAD: 7C          ld   a,h
DEAE: C6 08       add  a,$08
DEB0: 67          ld   h,a
DEB1: 3E 38       ld   a,$38
DEB3: 77          ld   (hl),a
DEB4: E1          pop  hl
DEB5: C9          ret
DEB6: E0          ret  po
DEB7: 7D          ld   a,l
DEB8: 7C          ld   a,h
DEB9: 7B          ld   a,e
DEBA: E0          ret  po
DEBB: 79          ld   a,c
DEBC: 78          ld   a,b
DEBD: 77          ld   (hl),a
DEBE: 76          halt
DEBF: 75          ld   (hl),l
DEC0: 74          ld   (hl),h
DEC1: 73          ld   (hl),e
DEC2: 72          ld   (hl),d
DEC3: 71          ld   (hl),c
DEC4: 70          ld   (hl),b
DEC5: 6F          ld   l,a
DEC6: 6E          ld   l,(hl)
DEC7: 6D          ld   l,l
DEC8: 6C          ld   l,h
DEC9: 6B          ld   l,e
DECA: 6A          ld   l,d
DECB: 69          ld   l,c
DECC: 68          ld   l,b
DECD: 67          ld   h,a
DECE: 6E          ld   l,(hl)
DECF: 6D          ld   l,l
DED0: 6C          ld   l,h
DED1: 6B          ld   l,e
DED2: 6A          ld   l,d
DED3: 69          ld   l,c
DED4: 68          ld   l,b
DED5: 67          ld   h,a
DED6: 76          halt
DED7: 75          ld   (hl),l
DED8: 74          ld   (hl),h
DED9: 73          ld   (hl),e
DEDA: 72          ld   (hl),d
DEDB: 71          ld   (hl),c
DEDC: 70          ld   (hl),b
DEDD: 6F          ld   l,a
DEDE: 76          halt
DEDF: 75          ld   (hl),l
DEE0: 74          ld   (hl),h
DEE1: 73          ld   (hl),e
DEE2: 72          ld   (hl),d
DEE3: 71          ld   (hl),c
DEE4: 70          ld   (hl),b
DEE5: 6F          ld   l,a
DEE6: E0          ret  po
DEE7: 7D          ld   a,l
DEE8: 7C          ld   a,h
DEE9: 7B          ld   a,e
DEEA: E0          ret  po
DEEB: 79          ld   a,c
DEEC: 78          ld   a,b
DEED: 77          ld   (hl),a
DEEE: E0          ret  po
DEEF: E0          ret  po
DEF0: E0          ret  po
DEF1: E0          ret  po
DEF2: E0          ret  po
DEF3: E0          ret  po
DEF4: E0          ret  po
DEF5: E0          ret  po
DEF6: FF          rst  $38
DEF7: 3A 43 63    ld   a,(unknown_6343)
DEFA: FE 01       cp   $01
DEFC: C8          ret  z
DEFD: 3A F0 62    ld   a,(unknown_62F0)
DF00: 3C          inc  a
DF01: 32 F0 62    ld   (unknown_62F0),a
DF04: FE 0C       cp   $0C
DF06: C0          ret  nz
DF07: AF          xor  a
DF08: 32 F0 62    ld   (unknown_62F0),a
DF0B: 3A 0D 60    ld   a,(player_screen_600D)
DF0E: FE 02       cp   $02
DF10: C0          ret  nz
DF11: 2A F1 62    ld   hl,(unknown_62F1)
DF14: 23          inc  hl
DF15: 22 F1 62    ld   (unknown_62F1),hl
DF18: 7E          ld   a,(hl)
DF19: FE FF       cp   $FF
DF1B: 20 07       jr   nz,$DF24
DF1D: 21 2D DF    ld   hl,$DF2D
DF20: 22 F1 62    ld   (unknown_62F1),hl
DF23: 7E          ld   a,(hl)
DF24: 32 8E 93    ld   ($938E),a
DF27: 3E 08       ld   a,$08
DF29: 32 8E 9B    ld   ($9B8E),a
DF2C: C9          ret
DF2D: 78          ld   a,b
DF2E: 7C          ld   a,h
DF2F: 74          ld   (hl),h
DF30: 72          ld   (hl),d
DF31: 6E          ld   l,(hl)
DF32: 6A          ld   l,d
DF33: 76          halt
DF34: 7E          ld   a,(hl)
DF35: 7A          ld   a,d
DF36: E0          ret  po
DF37: E0          ret  po
DF38: E0          ret  po
DF39: E0          ret  po
DF3A: E0          ret  po
DF3B: E0          ret  po
DF3C: E0          ret  po
DF3D: E0          ret  po
DF3E: E0          ret  po
DF3F: E0          ret  po
DF40: E0          ret  po
DF41: FF          rst  $38
DF42: DD 21 80 65 ld   ix,player_struct_6580
DF46: FD 21 E5 62 ld   iy,unknown_62E5
DF4A: 3A 0D 60    ld   a,(player_screen_600D)
DF4D: CD 6D DF    call $DF6D
DF50: DD 21 94 65 ld   ix,guard_1_struct_6594
DF54: FD 21 E9 62 ld   iy,unknown_62E9
DF58: 3A 99 60    ld   a,(guard_1_screen_6099)
DF5B: CD 6D DF    call $DF6D
DF5E: DD 21 98 65 ld   ix,guard_2_struct_6598
DF62: FD 21 ED 62 ld   iy,unknown_62ED
DF66: 3A 9A 60    ld   a,(guard_2_screen_609A)
DF69: CD 6D DF    call $DF6D
DF6C: C9          ret
DF6D: 47          ld   b,a
DF6E: DD 7E 02    ld   a,(ix+$02)
DF71: FE A9       cp   $A9
DF73: 38 13       jr   c,$DF88
DF75: 78          ld   a,b
DF76: FE 05       cp   $05
DF78: 20 0E       jr   nz,$DF88
DF7A: 3A E3 62    ld   a,(unknown_62E3)
DF7D: DD BE 03    cp   (ix+$03)
DF80: 20 06       jr   nz,$DF88
DF82: 3E 01       ld   a,$01
DF84: FD 77 00    ld   (iy+$00),a
DF87: C9          ret
DF88: AF          xor  a
DF89: FD 77 00    ld   (iy+$00),a
DF8C: C9          ret
DF8D: 21 C7 90    ld   hl,$90C7
DF90: 22 DD 62    ld   (unknown_62DD),hl
DF93: 21 04 E0    ld   hl,$E004
DF96: 22 DB 62    ld   (unknown_62DB),hl
DF99: 3E BB       ld   a,$BB
DF9B: 32 E0 62    ld   (unknown_62E0),a
DF9E: 3E FF       ld   a,$FF
DFA0: 32 DF 62    ld   (unknown_62DF),a
DFA3: 3E 28       ld   a,$28
DFA5: 32 E3 62    ld   (unknown_62E3),a
DFA8: 3A 0D 60    ld   a,(player_screen_600D)
DFAB: FE 05       cp   $05
DFAD: C0          ret  nz
DFAE: 3E B2       ld   a,$B2
DFB0: 32 C6 90    ld   ($90C6),a
DFB3: 32 06 91    ld   ($9106),a
DFB6: 3E B3       ld   a,$B3
DFB8: 32 E6 90    ld   ($90E6),a
DFBB: 32 26 91    ld   ($9126),a
DFBE: C9          ret
DFBF: CD 8D DF    call $DF8D
DFC2: 21 2D DF    ld   hl,$DF2D
DFC5: 22 F1 62    ld   (unknown_62F1),hl
DFC8: 21 63 92    ld   hl,$9263
DFCB: 22 0E 63    ld   (unknown_630E),hl
DFCE: 3E 01       ld   a,$01
DFD0: 32 10 63    ld   (unknown_6310),a
DFD3: 21 3C 91    ld   hl,$913C
DFD6: 22 15 63    ld   (unknown_6315),hl
DFD9: 3E 02       ld   a,$02
DFDB: 32 17 63    ld   (unknown_6317),a
DFDE: 21 54 92    ld   hl,$9254
DFE1: 22 18 63    ld   (unknown_6318),hl
DFE4: 3E 03       ld   a,$03
DFE6: 32 1A 63    ld   (unknown_631A),a
DFE9: 21 2E 91    ld   hl,$912E
DFEC: 22 1B 63    ld   (unknown_631B),hl
DFEF: 3E 04       ld   a,$04
DFF1: 32 1D 63    ld   (unknown_631D),a
DFF4: 21 7C 92    ld   hl,$927C
DFF7: 22 1E 63    ld   (unknown_631E),hl
DFFA: 3E 05       ld   a,$05
DFFC: 32 20 63    ld   (unknown_6320),a
DFFF: CD 8C E5    call $E58C
E002: C9          ret
E003: FE AC       cp   $AC
E005: A8          xor  b
E006: A4          and  h
E007: A0          and  b
E008: 9C          sbc  a,h
E009: 98          sbc  a,b
E00A: 94          sub  h
E00B: 90          sub  b
E00C: AE          xor  (hl)
E00D: AA          xor  d
E00E: A6          and  (hl)
E00F: A2          and  d
E010: 9E          sbc  a,(hl)
E011: 9A          sbc  a,d
E012: 96          sub  (hl)
E013: 92          sub  d
E014: FF          rst  $38
E015: 00          nop
E016: 00          nop
E017: 00          nop
E018: 00          nop
E019: 00          nop
E01A: 00          nop
E01B: 00          nop
E01C: 00          nop
E01D: 00          nop
E01E: 01 00 00    ld   bc,$0000
E021: 00          nop
E022: 00          nop
E023: 00          nop
E024: 00          nop
E025: 00          nop
E026: 01 01 00    ld   bc,$0001
E029: 00          nop
E02A: 00          nop
E02B: 00          nop
E02C: 00          nop
E02D: 00          nop
E02E: 00          nop
E02F: 01 00 00    ld   bc,$0000
E032: 00          nop
E033: 00          nop
E034: 00          nop
E035: 00          nop
E036: 00          nop
E037: 00          nop
E038: 00          nop
E039: CD 8D DF    call $DF8D
E03C: 2A DD 62    ld   hl,(unknown_62DD)
E03F: 7D          ld   a,l
E040: FE C7       cp   $C7
E042: 38 F5       jr   c,$E039
E044: FE DE       cp   $DE
E046: 30 F1       jr   nc,$E039
E048: 3A E1 62    ld   a,(unknown_62E1)
E04B: FE 00       cp   $00
E04D: 28 05       jr   z,$E054
E04F: 3D          dec  a
E050: 32 E1 62    ld   (unknown_62E1),a
E053: C9          ret
E054: 3A DF 62    ld   a,(unknown_62DF)
E057: FE 00       cp   $00
E059: C8          ret  z
E05A: 47          ld   b,a
E05B: 3A E3 62    ld   a,(unknown_62E3)
E05E: 90          sub  b
E05F: 32 E3 62    ld   (unknown_62E3),a
E062: 47          ld   b,a
E063: 3A E5 62    ld   a,(unknown_62E5)
E066: FE 00       cp   $00
E068: 28 04       jr   z,$E06E
E06A: 78          ld   a,b
E06B: 32 83 65    ld   (player_y_6583),a
E06E: 3A E9 62    ld   a,(unknown_62E9)
E071: FE 00       cp   $00
E073: 28 04       jr   z,$E079
E075: 78          ld   a,b
E076: 32 97 65    ld   (guard_1_y_6597),a
E079: 3A ED 62    ld   a,(unknown_62ED)
E07C: FE 00       cp   $00
E07E: 28 04       jr   z,$E084
E080: 78          ld   a,b
E081: 32 9B 65    ld   (guard_2_y_659B),a
E084: 3A DF 62    ld   a,(unknown_62DF)
E087: 47          ld   b,a
E088: 2A DD 62    ld   hl,(unknown_62DD)
E08B: CD 88 E1    call $E188
E08E: DD 2A DB 62 ld   ix,(unknown_62DB)
E092: 3A DF 62    ld   a,(unknown_62DF)
E095: FE FF       cp   $FF
E097: DD 7E 12    ld   a,(ix+$12)
E09A: 28 03       jr   z,$E09F
E09C: DD 7E 24    ld   a,(ix+$24)
E09F: FE 01       cp   $01
E0A1: CC C7 E0    call z,$E0C7
E0A4: DD 2A DB 62 ld   ix,(unknown_62DB)
E0A8: 2A DD 62    ld   hl,(unknown_62DD)
E0AB: DD 7E 00    ld   a,(ix+$00)
E0AE: CD F7 E0    call $E0F7
E0B1: CD 72 E1    call $E172
E0B4: 2A DB 62    ld   hl,(unknown_62DB)
E0B7: CD EC E0    call $E0EC
E0BA: 22 DB 62    ld   (unknown_62DB),hl
E0BD: 2A DD 62    ld   hl,(unknown_62DD)
E0C0: CD 37 E1    call $E137
E0C3: CD 51 E1    call $E151
E0C6: C9          ret
E0C7: DD 7E 00    ld   a,(ix+$00)
E0CA: FE FF       cp   $FF
E0CC: CC DE E0    call z,$E0DE
E0CF: FE FE       cp   $FE
E0D1: CC E5 E0    call z,$E0E5
E0D4: 2A DD 62    ld   hl,(unknown_62DD)
E0D7: CD EC E0    call $E0EC
E0DA: 22 DD 62    ld   (unknown_62DD),hl
E0DD: C9          ret
E0DE: 21 04 E0    ld   hl,$E004
E0E1: 22 DB 62    ld   (unknown_62DB),hl
E0E4: C9          ret
E0E5: 21 13 E0    ld   hl,$E013
E0E8: 22 DB 62    ld   (unknown_62DB),hl
E0EB: C9          ret
E0EC: 3A DF 62    ld   a,(unknown_62DF)
E0EF: FE FF       cp   $FF
E0F1: 28 02       jr   z,$E0F5
E0F3: 2B          dec  hl
E0F4: C9          ret
E0F5: 23          inc  hl
E0F6: C9          ret
E0F7: F5          push af
E0F8: FE AE       cp   $AE
E0FA: 28 0E       jr   z,$E10A
E0FC: FE AC       cp   $AC
E0FE: 28 0A       jr   z,$E10A
E100: FE 90       cp   $90
E102: 28 27       jr   z,$E12B
E104: FE 92       cp   $92
E106: 28 23       jr   z,$E12B
E108: 18 2B       jr   $E135
E10A: 7D          ld   a,l
E10B: 1E 49       ld   e,$49
E10D: FE CB       cp   $CB
E10F: CC AA E1    call z,$E1AA
E112: 1E 71       ld   e,$71
E114: FE D0       cp   $D0
E116: CC AA E1    call z,$E1AA
E119: 1E 99       ld   e,$99
E11B: FE D5       cp   $D5
E11D: CC AA E1    call z,$E1AA
E120: 1E 29       ld   e,$29
E122: FE C7       cp   $C7
E124: 20 0F       jr   nz,$E135
E126: CD AA E1    call $E1AA
E129: 18 0A       jr   $E135
E12B: 7D          ld   a,l
E12C: 1E E0       ld   e,$E0
E12E: FE DD       cp   $DD
E130: 20 03       jr   nz,$E135
E132: CD AA E1    call $E1AA
E135: F1          pop  af
E136: C9          ret
E137: 3A DF 62    ld   a,(unknown_62DF)
E13A: FE 01       cp   $01
E13C: C0          ret  nz
E13D: 7D          ld   a,l
E13E: FE C7       cp   $C7
E140: C0          ret  nz
E141: DD 7E 00    ld   a,(ix+$00)
E144: FE AC       cp   $AC
E146: C0          ret  nz
E147: 2A DB 62    ld   hl,(unknown_62DB)
E14A: 23          inc  hl
E14B: 23          inc  hl
E14C: 22 DB 62    ld   (unknown_62DB),hl
E14F: 18 18       jr   $E169
E151: 3A DF 62    ld   a,(unknown_62DF)
E154: FE FF       cp   $FF
E156: C0          ret  nz
E157: 7D          ld   a,l
E158: FE DD       cp   $DD
E15A: C0          ret  nz
E15B: DD 7E 00    ld   a,(ix+$00)
E15E: FE 90       cp   $90
E160: C0          ret  nz
E161: 2A DB 62    ld   hl,(unknown_62DB)
E164: 2B          dec  hl
E165: 2B          dec  hl
E166: 22 DB 62    ld   (unknown_62DB),hl
E169: 3A DF 62    ld   a,(unknown_62DF)
E16C: 2F          cpl
E16D: 3C          inc  a
E16E: 32 DF 62    ld   (unknown_62DF),a
E171: C9          ret
E172: 08          ex   af,af'
E173: 3A 0D 60    ld   a,(player_screen_600D)
E176: FE 05       cp   $05
E178: C0          ret  nz
E179: 08          ex   af,af'
E17A: 77          ld   (hl),a
E17B: 11 20 00    ld   de,$0020
E17E: 19          add  hl,de
E17F: 3C          inc  a
E180: 77          ld   (hl),a
E181: 19          add  hl,de
E182: 3D          dec  a
E183: 77          ld   (hl),a
E184: 19          add  hl,de
E185: 3C          inc  a
E186: 77          ld   (hl),a
E187: C9          ret
E188: 3A 0D 60    ld   a,(player_screen_600D)
E18B: FE 05       cp   $05
E18D: C0          ret  nz
E18E: CD A1 E1    call $E1A1
E191: 11 20 00    ld   de,$0020
E194: 19          add  hl,de
E195: CD A1 E1    call $E1A1
E198: 19          add  hl,de
E199: CD A1 E1    call $E1A1
E19C: 19          add  hl,de
E19D: CD A1 E1    call $E1A1
E1A0: C9          ret
E1A1: E5          push hl
E1A2: C1          pop  bc
E1A3: 78          ld   a,b
E1A4: D6 5C       sub  $5C
E1A6: 47          ld   b,a
E1A7: 0A          ld   a,(bc)
E1A8: 77          ld   (hl),a
E1A9: C9          ret
E1AA: 3E 50       ld   a,$50
E1AC: 32 E1 62    ld   (unknown_62E1),a
E1AF: 7B          ld   a,e
E1B0: 32 E3 62    ld   (unknown_62E3),a
E1B3: C9          ret
E1B4: DD 21 80 65 ld   ix,player_struct_6580
E1B8: FD 21 D2 62 ld   iy,unknown_62D2
E1BC: CD D8 E1    call $E1D8
E1BF: C9          ret
E1C0: DD 21 94 65 ld   ix,guard_1_struct_6594
E1C4: FD 21 D6 62 ld   iy,unknown_62D6
E1C8: CD D8 E1    call $E1D8
E1CB: C9          ret
E1CC: DD 21 98 65 ld   ix,guard_2_struct_6598
E1D0: FD 21 DA 62 ld   iy,unknown_62DA
E1D4: CD D8 E1    call $E1D8
E1D7: C9          ret
E1D8: FD 7E 00    ld   a,(iy+$00)
E1DB: FE 01       cp   $01
E1DD: C0          ret  nz
E1DE: DD 7E 02    ld   a,(ix+$02)
E1E1: 3C          inc  a
E1E2: DD 77 02    ld   (ix+$02),a
E1E5: DD 7E 03    ld   a,(ix+$03)
E1E8: 3C          inc  a
E1E9: DD 77 03    ld   (ix+$03),a
E1EC: C9          ret
E1ED: DD 21 80 65 ld   ix,player_struct_6580
E1F1: FD 21 D2 62 ld   iy,unknown_62D2
E1F5: 11 0D 60    ld   de,player_screen_600D
E1F8: 06 1C       ld   b,$1C
E1FA: 3A 08 60    ld   a,(unknown_6008)
E1FD: FE 01       cp   $01
E1FF: 28 08       jr   z,$E209
E201: 3A BD 62    ld   a,(unknown_62BD)
E204: FE 01       cp   $01
E206: C4 64 E2    call nz,$E264
E209: CD 43 E2    call $E243
E20C: C9          ret
E20D: DD 21 94 65 ld   ix,guard_1_struct_6594
E211: FD 21 D6 62 ld   iy,unknown_62D6
E215: 11 99 60    ld   de,guard_1_screen_6099
E218: 3A 37 60    ld   a,(guard_1_in_elevator_6037)
E21B: FE 01       cp   $01
E21D: 28 05       jr   z,$E224
E21F: 06 3F       ld   b,$3F
E221: CD 64 E2    call $E264
E224: CD 43 E2    call $E243
E227: C9          ret
E228: DD 21 98 65 ld   ix,guard_2_struct_6598
E22C: FD 21 DA 62 ld   iy,unknown_62DA
E230: 11 9A 60    ld   de,guard_2_screen_609A
E233: 06 3F       ld   b,$3F
E235: 3A 77 60    ld   a,(guard_2_in_elevator_6077)
E238: FE 01       cp   $01
E23A: 28 03       jr   z,$E23F
E23C: CD 64 E2    call $E264
E23F: CD 43 E2    call $E243
E242: C9          ret
E243: FD 7E 00    ld   a,(iy+$00)
E246: FE 01       cp   $01
E248: C0          ret  nz
E249: 1A          ld   a,(de)
E24A: FE 03       cp   $03
E24C: 28 0B       jr   z,$E259
E24E: DD 7E 02    ld   a,(ix+$02)
E251: FE 81       cp   $81
E253: D8          ret  c
E254: AF          xor  a
E255: FD 77 00    ld   (iy+$00),a
E258: C9          ret
E259: DD 7E 02    ld   a,(ix+$02)
E25C: FE 73       cp   $73
E25E: D8          ret  c
E25F: AF          xor  a
E260: FD 77 00    ld   (iy+$00),a
E263: C9          ret
E264: FD 7E 00    ld   a,(iy+$00)
E267: FE 01       cp   $01
E269: C8          ret  z
E26A: DD 7E 03    ld   a,(ix+$03)
E26D: FE 38       cp   $38
E26F: 20 24       jr   nz,$E295
E271: 1A          ld   a,(de)
E272: FE 02       cp   $02
E274: C0          ret  nz
E275: DD 7E 02    ld   a,(ix+$02)
E278: FE 50       cp   $50
E27A: D8          ret  c
E27B: DD 7E 02    ld   a,(ix+$02)
E27E: FE 55       cp   $55
E280: D0          ret  nc
E281: 3E 01       ld   a,$01
E283: FD 77 00    ld   (iy+$00),a
E286: DD 7E 00    ld   a,(ix+$00)
E289: E6 80       and  $80
E28B: B0          or   b
E28C: DD 77 00    ld   (ix+$00),a
E28F: 3E 20       ld   a,$20
E291: FD 77 01    ld   (iy+$01),a
E294: C9          ret
E295: FE 50       cp   $50
E297: 20 0F       jr   nz,$E2A8
E299: 1A          ld   a,(de)
E29A: FE 03       cp   $03
E29C: C0          ret  nz
E29D: DD 7E 02    ld   a,(ix+$02)
E2A0: FE 41       cp   $41
E2A2: D8          ret  c
E2A3: FE 50       cp   $50
E2A5: D0          ret  nc
E2A6: 18 D9       jr   $E281
E2A8: FE 53       cp   $53
E2AA: D8          ret  c
E2AB: FE 70       cp   $70
E2AD: D0          ret  nc
E2AE: 1A          ld   a,(de)
E2AF: FE 03       cp   $03
E2B1: C0          ret  nz
E2B2: DD 7E 02    ld   a,(ix+$02)
E2B5: FE 4B       cp   $4B
E2B7: D8          ret  c
E2B8: FE 60       cp   $60
E2BA: D0          ret  nc
E2BB: DD 7E 02    ld   a,(ix+$02)
E2BE: C6 10       add  a,$10
E2C0: DD 77 03    ld   (ix+$03),a
E2C3: 18 BC       jr   $E281
E2C5: 11 99 60    ld   de,guard_1_screen_6099
E2C8: DD 21 94 65 ld   ix,guard_1_struct_6594
E2CC: 21 27 60    ld   hl,guard_1_direction_6027
E2CF: CD EC E2    call $E2EC
E2D2: 78          ld   a,b
E2D3: FE 01       cp   $01
E2D5: CC 21 E3    call z,$E321
E2D8: 11 9A 60    ld   de,guard_2_screen_609A
E2DB: DD 21 98 65 ld   ix,guard_2_struct_6598
E2DF: 21 67 60    ld   hl,guard_2_direction_6067
E2E2: CD EC E2    call $E2EC
E2E5: 78          ld   a,b
E2E6: FE 01       cp   $01
E2E8: CC 7D E3    call z,$E37D
E2EB: C9          ret
E2EC: FD 21 2D E3 ld   iy,$E32D
E2F0: 06 00       ld   b,$00
E2F2: 1A          ld   a,(de)
E2F3: FD BE 02    cp   (iy+$02)
E2F6: 20 19       jr   nz,$E311
E2F8: DD 7E 02    ld   a,(ix+$02)
E2FB: FD BE 00    cp   (iy+$00)
E2FE: 20 11       jr   nz,$E311
E300: DD 7E 03    ld   a,(ix+$03)
E303: FD BE 01    cp   (iy+$01)
E306: 20 09       jr   nz,$E311
E308: 7E          ld   a,(hl)
E309: FD BE 03    cp   (iy+$03)
E30C: 20 03       jr   nz,$E311
E30E: 06 01       ld   b,$01
E310: C9          ret
E311: FD 23       inc  iy
E313: FD 23       inc  iy
E315: FD 23       inc  iy
E317: FD 23       inc  iy
E319: FD 7E 00    ld   a,(iy+$00)
E31C: FE FF       cp   $FF
E31E: C8          ret  z
E31F: 18 D1       jr   $E2F2
E321: DD 21 94 65 ld   ix,guard_1_struct_6594
E325: FD 21 C4 62 ld   iy,unknown_62C4
E329: CD 87 E4    call $E487
E32C: C9          ret
E32D: 92          sub  d
E32E: C0          ret  nz
E32F: 02          ld   (bc),a
E330: 40          ld   b,b
E331: 81          add  a,c
E332: C0          ret  nz
E333: 02          ld   (bc),a
E334: 80          add  a,b
E335: 5A          ld   e,d
E336: C0          ret  nz
E337: 02          ld   (bc),a
E338: 40          ld   b,b
E339: 49          ld   c,c
E33A: C0          ret  nz
E33B: 02          ld   (bc),a
E33C: 80          add  a,b
E33D: A2          and  d
E33E: 68          ld   l,b
E33F: 02          ld   (bc),a
E340: 40          ld   b,b
E341: 90          sub  b
E342: 68          ld   l,b
E343: 02          ld   (bc),a
E344: 80          add  a,b
E345: 92          sub  d
E346: 80          add  a,b
E347: 03          inc  bc
E348: 40          ld   b,b
E349: 7A          ld   a,d
E34A: 80          add  a,b
E34B: 03          inc  bc
E34C: 80          add  a,b
E34D: 32 50 04    ld   ($0450),a
E350: 40          ld   b,b
E351: 20 50       jr   nz,$E3A3
E353: 04          inc  b
E354: 80          add  a,b
E355: 38 70       jr   c,$E3C7
E357: 04          inc  b
E358: 80          add  a,b
E359: B8          cp   b
E35A: 18 04       jr   $E360
E35C: 80          add  a,b
E35D: B8          cp   b
E35E: 70          ld   (hl),b
E35F: 04          inc  b
E360: 80          add  a,b
E361: C2 18 04    jp   nz,$0418
E364: 40          ld   b,b
E365: C2 70 04    jp   nz,$0470
E368: 40          ld   b,b
E369: FF          rst  $38
E36A: FF          rst  $38
E36B: FF          rst  $38
E36C: FF          rst  $38
E36D: DD 21 94 65 ld   ix,guard_1_struct_6594
E371: FD 21 C4 62 ld   iy,unknown_62C4
E375: ED 5B 38 60 ld   de,(guard_1_logical_address_6038)
E379: CD F0 E3    call $E3F0
E37C: C9          ret
E37D: DD 21 98 65 ld   ix,guard_2_struct_6598
E381: FD 21 CB 62 ld   iy,unknown_62CB
E385: CD 87 E4    call $E487
E388: C9          ret
E389: DD 21 98 65 ld   ix,guard_2_struct_6598
E38D: FD 21 CB 62 ld   iy,unknown_62CB
E391: ED 5B 78 60 ld   de,(guard_2_logical_address_6078)
E395: CD F0 E3    call $E3F0
E398: C9          ret
E399: DD 21 80 65 ld   ix,player_struct_6580
E39D: FD 21 BD 62 ld   iy,unknown_62BD
E3A1: 3A 08 60    ld   a,(unknown_6008)
E3A4: FE 00       cp   $00
E3A6: C0          ret  nz
E3A7: 3A 1C 60    ld   a,(player_in_wagon_1_601C)
E3AA: FE 01       cp   $01
E3AC: C8          ret  z
E3AD: 3A 2A 60    ld   a,(player_gripping_handle_602A)
E3B0: FE 01       cp   $01
E3B2: C8          ret  z
E3B3: 3A 60 61    ld   a,(pickup_flag_6160)
E3B6: FE 01       cp   $01
E3B8: C0          ret  nz
E3B9: 3A AF 62    ld   a,(unknown_62AF)
E3BC: FE 01       cp   $01
E3BE: C8          ret  z
E3BF: 3A B0 62    ld   a,(unknown_62B0)
E3C2: FE 01       cp   $01
E3C4: C8          ret  z
E3C5: CD 63 E4    call $E463
E3C8: C9          ret
E3C9: 3A BC 62    ld   a,(unknown_62BC)
E3CC: FE 01       cp   $01
E3CE: 20 08       jr   nz,$E3D8
E3D0: AF          xor  a
E3D1: 32 BC 62    ld   (unknown_62BC),a
E3D4: CD 63 E4    call $E463
E3D7: C9          ret
E3D8: 3A BC 62    ld   a,(unknown_62BC)
E3DB: 3C          inc  a
E3DC: 32 BC 62    ld   (unknown_62BC),a
E3DF: C9          ret
E3E0: DD 21 80 65 ld   ix,player_struct_6580
E3E4: FD 21 BD 62 ld   iy,unknown_62BD
E3E8: ED 5B 09 60 ld   de,(player_logical_address_6009)
E3EC: CD F0 E3    call $E3F0
E3EF: C9          ret
E3F0: FD 7E 00    ld   a,(iy+$00)
E3F3: FE 00       cp   $00
E3F5: C8          ret  z
E3F6: FD 66 01    ld   h,(iy+$01)
E3F9: FD 6E 02    ld   l,(iy+$02)
E3FC: 7E          ld   a,(hl)
E3FD: FE FF       cp   $FF
E3FF: 28 5D       jr   z,$E45E
E401: DD E5       push ix
E403: FD E5       push iy
E405: E5          push hl
E406: EB          ex   de,hl
E407: FD 7E 03    ld   a,(iy+$03)
E40A: FE 80       cp   $80
E40C: 20 05       jr   nz,$E413
E40E: CD CC 0D    call character_can_walk_left_0DCC
E411: 18 03       jr   $E416
E413: CD 71 0D    call character_can_walk_right_0D71
E416: 3A 0B 60    ld   a,(way_clear_flag_600B)
E419: FE 02       cp   $02
E41B: E1          pop  hl
E41C: FD E1       pop  iy
E41E: DD E1       pop  ix
E420: 20 3C       jr   nz,$E45E
E422: 7E          ld   a,(hl)
E423: 47          ld   b,a
E424: FD 7E 03    ld   a,(iy+$03)
E427: B0          or   b
E428: DD 77 00    ld   (ix+$00),a
E42B: 23          inc  hl
E42C: 7E          ld   a,(hl)
E42D: 47          ld   b,a
E42E: FD 7E 04    ld   a,(iy+$04)
E431: FE 00       cp   $00
E433: 28 05       jr   z,$E43A
E435: 3D          dec  a
E436: FD 77 04    ld   (iy+$04),a
E439: 04          inc  b
E43A: FD 7E 03    ld   a,(iy+$03)
E43D: FE 80       cp   $80
E43F: 20 04       jr   nz,$E445
E441: 78          ld   a,b
E442: 2F          cpl
E443: 3C          inc  a
E444: 47          ld   b,a
E445: DD 7E 02    ld   a,(ix+$02)
E448: 80          add  a,b
E449: DD 77 02    ld   (ix+$02),a
E44C: 23          inc  hl
E44D: 7E          ld   a,(hl)
E44E: 47          ld   b,a
E44F: DD 7E 03    ld   a,(ix+$03)
E452: 80          add  a,b
E453: DD 77 03    ld   (ix+$03),a
E456: 23          inc  hl
E457: FD 74 01    ld   (iy+$01),h
E45A: FD 75 02    ld   (iy+$02),l
E45D: C9          ret
E45E: AF          xor  a
E45F: FD 77 00    ld   (iy+$00),a
E462: C9          ret
E463: CD E3 F4    call test_pickup_flag_F4E3
E466: 78          ld   a,b
E467: FE 01       cp   $01
E469: C0          ret  nz
E46A: FD 7E 00    ld   a,(iy+$00)
E46D: FE 00       cp   $00
E46F: C0          ret  nz
E470: 3E 01       ld   a,$01
E472: FD 77 00    ld   (iy+$00),a
E475: 21 A4 E4    ld   hl,$E4A4
E478: FD 74 01    ld   (iy+$01),h
E47B: FD 75 02    ld   (iy+$02),l
E47E: DD 7E 00    ld   a,(ix+$00)
E481: E6 80       and  $80
E483: FD 77 03    ld   (iy+$03),a
E486: C9          ret
E487: FD 7E 00    ld   a,(iy+$00)
E48A: FE 00       cp   $00
E48C: C0          ret  nz
E48D: 3E 01       ld   a,$01
E48F: FD 77 00    ld   (iy+$00),a
E492: 21 01 E5    ld   hl,$E501
E495: FD 74 01    ld   (iy+$01),h
E498: FD 75 02    ld   (iy+$02),l
E49B: DD 7E 00    ld   a,(ix+$00)
E49E: E6 80       and  $80
E4A0: FD 77 03    ld   (iy+$03),a
E4A3: C9          ret


convert_logical_to_screen_address_E55E:
E55E: FE 01       cp   $01
E560: 20 04       jr   nz,$E566
E562: 7C          ld   a,h
E563: C6 50       add  a,$50
E565: C9          ret
E566: FE 02       cp   $02
E568: 20 04       jr   nz,$E56E
E56A: 7C          ld   a,h
E56B: C6 4C       add  a,$4C
E56D: C9          ret
E56E: FE 03       cp   $03
E570: 20 04       jr   nz,$E576
E572: 7C          ld   a,h
E573: C6 48       add  a,$48
E575: C9          ret
E576: FE 04       cp   $04
E578: 20 04       jr   nz,$E57E
E57A: 7C          ld   a,h
E57B: C6 60       add  a,$60
E57D: C9          ret
E57E: FE 05       cp   $05
E580: C0          ret  nz
E581: 7C          ld   a,h
E582: C6 5C       add  a,$5C
E584: C9          ret

memset_E585:
E585: DD 77 00    ld   (ix+$00),a
E588: DD 23       inc  ix
E58A: 10 F9       djnz memset_E585
E58C: AF          xor  a
E58D: DD 21 93 62 ld   ix,unknown_6293
E591: 06 24       ld   b,$24
E593: DD 77 00    ld   (ix+$00),a
E596: DD 23       inc  ix
E598: 10 F9       djnz $E593
E59A: AF          xor  a
E59B: 32 F5 62    ld   (unknown_62F5),a
E59E: 32 F6 62    ld   (unknown_62F6),a
E5A1: 32 F7 62    ld   (unknown_62F7),a
E5A4: 32 F8 62    ld   (unknown_62F8),a
E5A7: 32 F9 62    ld   (unknown_62F9),a
E5AA: 32 FA 62    ld   (unknown_62FA),a
E5AD: 32 FB 62    ld   (unknown_62FB),a
E5B0: 32 23 63    ld   (unknown_6323),a
E5B3: 32 24 63    ld   (unknown_6324),a
E5B6: 32 26 63    ld   (unknown_6326),a
E5B9: 32 27 63    ld   (unknown_6327),a
E5BC: 32 E5 62    ld   (unknown_62E5),a
E5BF: 32 E9 62    ld   (unknown_62E9),a
E5C2: 32 EA 62    ld   (unknown_62EA),a
E5C5: 32 ED 62    ld   (unknown_62ED),a
E5C8: 32 EE 62    ld   (unknown_62EE),a
E5CB: 32 D2 62    ld   (unknown_62D2),a
E5CE: CD CC F9    call $F9CC
E5D1: C9          ret

E5D2: 06 00       ld   b,$00
E5D4: 3A 54 60    ld   a,(gameplay_allowed_6054)
E5D7: FE 00       cp   $00
E5D9: 28 30       jr   z,$E60B
E5DB: 3A FD 61    ld   a,(unknown_61FD)
E5DE: FE 01       cp   $01
E5E0: 28 16       jr   z,$E5F8
E5E2: 3A 50 60    ld   a,(player_previous_input_6050)
E5E5: E6 04       and  $04
E5E7: FE 04       cp   $04
E5E9: 28 0C       jr   z,$E5F7
E5EB: 3A 26 60    ld   a,(player_input_6026)
E5EE: E6 04       and  $04
E5F0: FE 04       cp   $04
E5F2: 20 03       jr   nz,$E5F7
E5F4: 06 01       ld   b,$01
E5F6: C9          ret
E5F7: C9          ret
E5F8: 3A 52 60    ld   a,(coin_start_prev_inputs_6052)
E5FB: E6 04       and  $04
E5FD: FE 04       cp   $04
E5FF: C8          ret  z
E600: 3A 51 60    ld   a,(coin_start_inputs_6051)
E603: E6 04       and  $04
E605: FE 04       cp   $04
E607: C0          ret  nz
E608: 06 01       ld   b,$01
E60A: C9          ret
E60B: 3A 50 60    ld   a,(player_previous_input_6050)
E60E: E6 04       and  $04
E610: FE 04       cp   $04
E612: C0          ret  nz
E613: 06 01       ld   b,$01
E615: C9          ret
E616: 11 95 62    ld   de,unknown_6295
E619: CD 29 E6    call $E629
E61C: 11 9D 62    ld   de,unknown_629D
E61F: CD 29 E6    call $E629
E622: 11 A5 62    ld   de,unknown_62A5
E625: CD 29 E6    call $E629
E628: C9          ret
E629: 1A          ld   a,(de)
E62A: FE 00       cp   $00
E62C: C8          ret  z
E62D: 3D          dec  a
E62E: 12          ld   (de),a
E62F: C9          ret
E630: 3A 0D 60    ld   a,(player_screen_600D)
E633: FE 03       cp   $03
E635: C0          ret  nz
E636: DD 21 80 65 ld   ix,player_struct_6580
E63A: DD 7E 03    ld   a,(ix+$03)
E63D: FE A0       cp   $A0
E63F: 20 26       jr   nz,$E667
E641: DD 7E 02    ld   a,(ix+$02)
E644: FE 58       cp   $58
E646: 38 1F       jr   c,$E667
E648: FE 60       cp   $60
E64A: 30 1B       jr   nc,$E667
E64C: 3E 01       ld   a,$01
E64E: 32 93 62    ld   (unknown_6293),a
E651: 3E 06       ld   a,$06
E653: 32 94 62    ld   (unknown_6294),a
E656: 32 9C 62    ld   (unknown_629C),a
E659: 32 A4 62    ld   (unknown_62A4),a
E65C: 3E E0       ld   a,$E0
E65E: 32 95 92    ld   ($9295),a
E661: 3E 3F       ld   a,$3F
E663: 32 95 9A    ld   ($9A95),a
E666: C9          ret
E667: 3A 94 62    ld   a,(unknown_6294)
E66A: FE 00       cp   $00
E66C: C0          ret  nz
E66D: 3E BD       ld   a,$BD
E66F: 32 95 92    ld   ($9295),a
E672: 3E 36       ld   a,$36
E674: 32 95 9A    ld   ($9A95),a
E677: C9          ret
E678: AF          xor  a
E679: 32 46 63    ld   (unknown_6346),a
E67C: C9          ret
E67D: DD 21 98 65 ld   ix,guard_2_struct_6598
E681: FD 21 A3 62 ld   iy,unknown_62A3
E685: 3A 99 62    ld   a,(unknown_6299)
E688: FE 01       cp   $01
E68A: C0          ret  nz
E68B: 3A 97 62    ld   a,(unknown_6297)
E68E: FE 01       cp   $01
E690: C8          ret  z
E691: 3A A4 62    ld   a,(unknown_62A4)
E694: FE 00       cp   $00
E696: C8          ret  z
E697: CD 53 E8    call $E853
E69A: 78          ld   a,b
E69B: FE 01       cp   $01
E69D: C8          ret  z
E69E: 3A 7C 60    ld   a,(guard_2_sees_player_right_607C)
E6A1: FE 80       cp   $80
E6A3: 20 0A       jr   nz,$E6AF
E6A5: DD 7E 00    ld   a,(ix+$00)
E6A8: E6 80       and  $80
E6AA: FE 00       cp   $00
E6AC: C0          ret  nz
E6AD: 18 08       jr   $E6B7
E6AF: DD 7E 00    ld   a,(ix+$00)
E6B2: E6 80       and  $80
E6B4: FE 00       cp   $00
E6B6: C8          ret  z
E6B7: 3A 9A 60    ld   a,(guard_2_screen_609A)
E6BA: 47          ld   b,a
E6BB: 3A 0D 60    ld   a,(player_screen_600D)
E6BE: B8          cp   b
E6BF: C0          ret  nz
E6C0: 3A 57 61    ld   a,(unknown_6157)
E6C3: FE 00       cp   $00
E6C5: 20 B1       jr   nz,$E678
E6C7: 3A 46 63    ld   a,(unknown_6346)
E6CA: FE 0F       cp   $0F
E6CC: 38 10       jr   c,$E6DE
E6CE: 0E 28       ld   c,$28
E6D0: DD 7E 00    ld   a,(ix+$00)
E6D3: E6 80       and  $80
E6D5: B1          or   c
E6D6: DD 77 00    ld   (ix+$00),a
E6D9: 3E 20       ld   a,$20
E6DB: FD 77 02    ld   (iy+$02),a
E6DE: CD 2C E8    call $E82C
E6E1: 3A 46 63    ld   a,(unknown_6346)
E6E4: 3C          inc  a
E6E5: 32 46 63    ld   (unknown_6346),a
E6E8: B8          cp   b
E6E9: D8          ret  c
E6EA: AF          xor  a
E6EB: 32 46 63    ld   (unknown_6346),a
E6EE: 3E 28       ld   a,$28
E6F0: 4F          ld   c,a
E6F1: C3 B4 E7    jp   $E7B4
E6F4: AF          xor  a
E6F5: 32 45 63    ld   (unknown_6345),a
E6F8: C9          ret
E6F9: DD 21 94 65 ld   ix,guard_1_struct_6594
E6FD: FD 21 9B 62 ld   iy,unknown_629B
E701: 3A 99 62    ld   a,(unknown_6299)
E704: FE 01       cp   $01
E706: C0          ret  nz
E707: 3A 97 62    ld   a,(unknown_6297)
E70A: FE 01       cp   $01
E70C: C8          ret  z
E70D: 3A 9C 62    ld   a,(unknown_629C)
E710: FE 00       cp   $00
E712: C8          ret  z
E713: CD 53 E8    call $E853
E716: 78          ld   a,b
E717: FE 01       cp   $01
E719: C8          ret  z
E71A: 3A 3C 60    ld   a,(guard_1_sees_player_right_603C)
E71D: FE 80       cp   $80
E71F: 20 0A       jr   nz,$E72B
E721: DD 7E 00    ld   a,(ix+$00)
E724: E6 80       and  $80
E726: FE 00       cp   $00
E728: C0          ret  nz
E729: 18 08       jr   $E733
E72B: DD 7E 00    ld   a,(ix+$00)
E72E: E6 80       and  $80
E730: FE 00       cp   $00
E732: C8          ret  z
E733: 3A 99 60    ld   a,(guard_1_screen_6099)
E736: 47          ld   b,a
E737: 3A 0D 60    ld   a,(player_screen_600D)
E73A: B8          cp   b
E73B: C0          ret  nz
E73C: 3A 56 61    ld   a,(unknown_6156)
E73F: FE 00       cp   $00
E741: 20 B1       jr   nz,$E6F4
E743: 3A 45 63    ld   a,(unknown_6345)
E746: FE 0F       cp   $0F
E748: 38 10       jr   c,$E75A
E74A: 0E 28       ld   c,$28
E74C: DD 7E 00    ld   a,(ix+$00)
E74F: E6 80       and  $80
E751: B1          or   c
E752: DD 77 00    ld   (ix+$00),a
E755: 3E 20       ld   a,$20
E757: FD 77 02    ld   (iy+$02),a
E75A: CD 2C E8    call $E82C
E75D: 3A 45 63    ld   a,(unknown_6345)
E760: 3C          inc  a
E761: 32 45 63    ld   (unknown_6345),a
E764: B8          cp   b
E765: D8          ret  c
E766: AF          xor  a
E767: 32 45 63    ld   (unknown_6345),a
E76A: 3E 28       ld   a,$28
E76C: 4F          ld   c,a
E76D: 18 45       jr   $E7B4
E76F: 3A 93 62    ld   a,(unknown_6293)
E772: FE 01       cp   $01
E774: C0          ret  nz
E775: 3E BD       ld   a,$BD
E777: 32 1F 92    ld   ($921F),a
E77A: 3E 35       ld   a,$35
E77C: 32 1F 9A    ld   ($9A1F),a
E77F: 3A 94 62    ld   a,(unknown_6294)
E782: FE 00       cp   $00
E784: 20 05       jr   nz,$E78B
E786: 3E E0       ld   a,$E0
E788: 32 1F 92    ld   ($921F),a
E78B: 3A 52 63    ld   a,(unknown_6352)
E78E: C6 04       add  a,$04
E790: 32 52 63    ld   (unknown_6352),a
E793: FE 80       cp   $80
E795: 38 05       jr   c,$E79C
E797: 3E E0       ld   a,$E0
E799: 32 1F 92    ld   ($921F),a
E79C: 3A 97 62    ld   a,(unknown_6297)
E79F: FE 00       cp   $00
E7A1: C0          ret  nz
E7A2: CD D2 E5    call $E5D2
E7A5: 78          ld   a,b
E7A6: FE 00       cp   $00
E7A8: C8          ret  z
E7A9: 3E 11       ld   a,$11
E7AB: 4F          ld   c,a
E7AC: DD 21 80 65 ld   ix,player_struct_6580
E7B0: FD 21 93 62 ld   iy,unknown_6293
E7B4: FD 7E 01    ld   a,(iy+$01)
E7B7: FE 00       cp   $00
E7B9: C8          ret  z
E7BA: FD 7E 01    ld   a,(iy+$01)
E7BD: 3D          dec  a
E7BE: FD 77 01    ld   (iy+$01),a
E7C1: 3E 01       ld   a,$01
E7C3: 32 97 62    ld   (unknown_6297),a
E7C6: 06 01       ld   b,$01
E7C8: DD 7E 00    ld   a,(ix+$00)
E7CB: E6 80       and  $80
E7CD: FE 80       cp   $80
E7CF: 20 02       jr   nz,$E7D3
E7D1: 06 FF       ld   b,$FF
E7D3: 78          ld   a,b
E7D4: 32 98 62    ld   (unknown_6298),a
E7D7: DD 7E 00    ld   a,(ix+$00)
E7DA: E6 80       and  $80
E7DC: B1          or   c
E7DD: DD 77 00    ld   (ix+$00),a
E7E0: DD 7E 02    ld   a,(ix+$02)
E7E3: 80          add  a,b
E7E4: 80          add  a,b
E7E5: 80          add  a,b
E7E6: 80          add  a,b
E7E7: 80          add  a,b
E7E8: 80          add  a,b
E7E9: 80          add  a,b
E7EA: 80          add  a,b
E7EB: 80          add  a,b
E7EC: 80          add  a,b
E7ED: 80          add  a,b
E7EE: 32 8E 65    ld   (unknown_658E),a
E7F1: DD 7E 03    ld   a,(ix+$03)
E7F4: 32 8F 65    ld   (unknown_658F),a
E7F7: 3E 10       ld   a,$10
E7F9: 32 8C 65    ld   (wagon_2_shadow_sprite_658C),a
E7FC: 3E 0F       ld   a,$0F
E7FE: 32 8D 65    ld   (unknown_658D),a
E801: 3E 30       ld   a,$30
E803: FD 77 02    ld   (iy+$02),a
E806: 3A 48 63    ld   a,(unknown_6348)
E809: FE 01       cp   $01
E80B: C8          ret  z
E80C: 3A 54 60    ld   a,(gameplay_allowed_6054)
E80F: FE 00       cp   $00
E811: C8          ret  z
E812: 21 28 54    ld   hl,$5428
E815: 22 4E 63    ld   (unknown_634E),hl
E818: AF          xor  a
E819: 32 42 61    ld   (ay_sound_start_6142),a
E81C: 3E 02       ld   a,$02
E81E: 32 48 63    ld   (unknown_6348),a
E821: 3E 0F       ld   a,$0F
E823: 32 4C 63    ld   (unknown_634C),a
E826: 3E 01       ld   a,$01
E828: 32 4D 63    ld   (unknown_634D),a
E82B: C9          ret
E82C: 3A 64 61    ld   a,(guard_speed_6164)
E82F: 06 18       ld   b,$18
E831: C9          ret
E832: 06 38       ld   b,$38
E834: FE 00       cp   $00
E836: C8          ret  z
E837: 06 30       ld   b,$30
E839: FE 01       cp   $01
E83B: C8          ret  z
E83C: 06 28       ld   b,$28
E83E: FE 02       cp   $02
E840: C8          ret  z
E841: 06 20       ld   b,$20
E843: FE 03       cp   $03
E845: C8          ret  z
E846: 06 18       ld   b,$18
E848: FE 04       cp   $04
E84A: C8          ret  z
E84B: 06 10       ld   b,$10
E84D: FE 05       cp   $05
E84F: C8          ret  z
E850: 06 08       ld   b,$08
E852: C9          ret
E853: DD 7E 02    ld   a,(ix+$02)
E856: 06 01       ld   b,$01
E858: FE D8       cp   $D8
E85A: D0          ret  nc
E85B: FE 18       cp   $18
E85D: D8          ret  c
E85E: 06 00       ld   b,$00
E860: C9          ret
E861: 3A 97 62    ld   a,(unknown_6297)
E864: FE 01       cp   $01
E866: C0          ret  nz
E867: 18 1F       jr   $E888
E869: 3A 97 62    ld   a,(unknown_6297)
E86C: FE 01       cp   $01
E86E: C0          ret  nz
E86F: 3A ED 61    ld   a,(check_scenery_disabled_61ED)
E872: FE 01       cp   $01
E874: C8          ret  z
E875: CD CB EA    call $EACB
E878: 11 1F 00    ld   de,$001F
E87B: 19          add  hl,de
E87C: 7E          ld   a,(hl)
E87D: CD 05 0E    call check_against_space_tiles_0E05
E880: 3A 0B 60    ld   a,(way_clear_flag_600B)
E883: FE 02       cp   $02
E885: C2 14 E9    jp   nz,$E914
E888: 3A 8E 65    ld   a,(unknown_658E)
E88B: FE 10       cp   $10
E88D: DA 14 E9    jp   c,$E914
E890: FE F0       cp   $F0
E892: D2 14 E9    jp   nc,$E914
E895: DD E5       push ix
E897: 3A 0D 60    ld   a,(player_screen_600D)
E89A: 32 98 60    ld   (current_guard_screen_index_6098),a
E89D: DD 21 80 65 ld   ix,player_struct_6580
E8A1: 21 25 60    ld   hl,player_death_flag_6025
E8A4: 11 25 60    ld   de,player_death_flag_6025
E8A7: CD DE E8    call $E8DE
E8AA: 3A 99 60    ld   a,(guard_1_screen_6099)
E8AD: 32 98 60    ld   (current_guard_screen_index_6098),a
E8B0: DD 21 94 65 ld   ix,guard_1_struct_6594
E8B4: 21 9F 62    ld   hl,unknown_629F
E8B7: 11 56 61    ld   de,unknown_6156
E8BA: CD DE E8    call $E8DE
E8BD: 3A 9A 60    ld   a,(guard_2_screen_609A)
E8C0: 32 98 60    ld   (current_guard_screen_index_6098),a
E8C3: DD 21 98 65 ld   ix,guard_2_struct_6598
E8C7: 21 A7 62    ld   hl,unknown_62A7
E8CA: 11 57 61    ld   de,unknown_6157
E8CD: CD DE E8    call $E8DE
E8D0: DD E1       pop  ix
E8D2: 3A 98 62    ld   a,(unknown_6298)
E8D5: 47          ld   b,a
E8D6: 3A 8E 65    ld   a,(unknown_658E)
E8D9: 80          add  a,b
E8DA: 32 8E 65    ld   (unknown_658E),a
E8DD: C9          ret
E8DE: 3A 98 60    ld   a,(current_guard_screen_index_6098)
E8E1: 47          ld   b,a
E8E2: 3A 0D 60    ld   a,(player_screen_600D)
E8E5: B8          cp   b
E8E6: C0          ret  nz
E8E7: 1A          ld   a,(de)
E8E8: FE 01       cp   $01
E8EA: C8          ret  z
E8EB: DD 7E 02    ld   a,(ix+$02)
E8EE: D6 08       sub  $08
E8F0: 47          ld   b,a
E8F1: C6 10       add  a,$10
E8F3: 4F          ld   c,a
E8F4: 3A 8E 65    ld   a,(unknown_658E)
E8F7: B8          cp   b
E8F8: D8          ret  c
E8F9: B9          cp   c
E8FA: D0          ret  nc
E8FB: 3A 8F 65    ld   a,(unknown_658F)
E8FE: C6 07       add  a,$07
E900: 47          ld   b,a
E901: D6 0E       sub  $0E
E903: 4F          ld   c,a
E904: DD 7E 03    ld   a,(ix+$03)
E907: B8          cp   b
E908: D0          ret  nc
E909: B9          cp   c
E90A: D8          ret  c
E90B: 3E 01       ld   a,$01
E90D: 77          ld   (hl),a
E90E: 32 99 62    ld   (unknown_6299),a
E911: 18 01       jr   $E914
E913: C9          ret
E914: AF          xor  a
E915: 32 97 62    ld   (unknown_6297),a
E918: 32 8F 65    ld   (unknown_658F),a
E91B: C9          ret
E91C: DD 21 80 65 ld   ix,player_struct_6580
E920: FD 21 AF 62 ld   iy,unknown_62AF
E924: 3A 0D 60    ld   a,(player_screen_600D)
E927: CD 4F E9    call $E94F
E92A: DD 21 94 65 ld   ix,guard_1_struct_6594
E92E: FD 21 B5 62 ld   iy,unknown_62B5
E932: 3A 99 60    ld   a,(guard_1_screen_6099)
E935: CD 4F E9    call $E94F
E938: DD 21 98 65 ld   ix,guard_2_struct_6598
E93C: FD 21 B9 62 ld   iy,unknown_62B9
E940: 3A 9A 60    ld   a,(guard_2_screen_609A)
E943: CD 4F E9    call $E94F
E946: C9          ret
E947: AF          xor  a
E948: FD 77 00    ld   (iy+$00),a
E94B: FD 77 01    ld   (iy+$01),a
E94E: C9          ret
E94F: FE 01       cp   $01
E951: 20 F4       jr   nz,$E947
E953: CD 7C E9    call $E97C
E956: CD BF E9    call $E9BF
E959: CD 9E E9    call $E99E
E95C: FD 7E 00    ld   a,(iy+$00)
E95F: FE 00       cp   $00
E961: C8          ret  z
E962: FD 7E 01    ld   a,(iy+$01)
E965: FE 01       cp   $01
E967: 28 0B       jr   z,$E974
E969: F3          di
E96A: DD 7E 03    ld   a,(ix+$03)
E96D: FE 39       cp   $39
E96F: 38 03       jr   c,$E974
E971: DD 35 03    dec  (ix+$03)
E974: DD 34 02    inc  (ix+$02)
E977: DD 34 02    inc  (ix+$02)
E97A: FB          ei
E97B: C9          ret
E97C: DD 7E 02    ld   a,(ix+$02)
E97F: FE 48       cp   $48
E981: D8          ret  c
E982: FE 50       cp   $50
E984: D0          ret  nc
E985: DD 7E 03    ld   a,(ix+$03)
E988: FE 70       cp   $70
E98A: C0          ret  nz
E98B: 3A AD 62    ld   a,(unknown_62AD)
E98E: FE 00       cp   $00
E990: C0          ret  nz
E991: 3E 01       ld   a,$01
E993: FD 77 00    ld   (iy+$00),a
E996: DD 7E 03    ld   a,(ix+$03)
E999: 3C          inc  a
E99A: DD 77 03    ld   (ix+$03),a
E99D: C9          ret
E99E: DD 7E 02    ld   a,(ix+$02)
E9A1: FE B8       cp   $B8
E9A3: D8          ret  c
E9A4: FE C0       cp   $C0
E9A6: D0          ret  nc
E9A7: DD 7E 03    ld   a,(ix+$03)
E9AA: FE 38       cp   $38
E9AC: 28 08       jr   z,$E9B6
E9AE: FE 37       cp   $37
E9B0: C0          ret  nz
E9B1: 3E 38       ld   a,$38
E9B3: DD 77 03    ld   (ix+$03),a
E9B6: 3E 01       ld   a,$01
E9B8: FD 77 00    ld   (iy+$00),a
E9BB: FD 77 01    ld   (iy+$01),a
E9BE: C9          ret
E9BF: FD 7E 00    ld   a,(iy+$00)
E9C2: FE 01       cp   $01
E9C4: C0          ret  nz
E9C5: DD 7E 03    ld   a,(ix+$03)
E9C8: FE 39       cp   $39
E9CA: D0          ret  nc
E9CB: AF          xor  a
E9CC: FD 77 00    ld   (iy+$00),a
E9CF: FD 77 01    ld   (iy+$01),a
E9D2: C9          ret
E9D3: 3A AC 62    ld   a,(unknown_62AC)
E9D6: FE 03       cp   $03
E9D8: D8          ret  c
E9D9: AF          xor  a
E9DA: 32 AC 62    ld   (unknown_62AC),a
E9DD: 3A 0D 60    ld   a,(player_screen_600D)
E9E0: FE 01       cp   $01
E9E2: C0          ret  nz
E9E3: 3A ED 61    ld   a,(check_scenery_disabled_61ED)
E9E6: FE 01       cp   $01
E9E8: C8          ret  z
E9E9: DD 21 87 1B ld   ix,$1B87
E9ED: ED 5B AD 62 ld   de,(unknown_62AD)
E9F1: DD 19       add  ix,de
E9F3: 21 D0 92    ld   hl,$92D0
E9F6: CD 3C EA    call $EA3C
E9F9: DD 21 87 1B ld   ix,$1B87
E9FD: DD 19       add  ix,de
E9FF: 21 8F 92    ld   hl,$928F
EA02: CD 3C EA    call $EA3C
EA05: 21 4E 92    ld   hl,$924E
EA08: CD 3C EA    call $EA3C
EA0B: 21 0D 92    ld   hl,$920D
EA0E: CD 3C EA    call $EA3C
EA11: 21 CC 91    ld   hl,$91CC
EA14: CD 3C EA    call $EA3C
EA17: 21 8B 91    ld   hl,$918B
EA1A: CD 3C EA    call $EA3C
EA1D: 21 4A 91    ld   hl,$914A
EA20: CD 3C EA    call $EA3C
EA23: D5          push de
EA24: CD 1C E9    call $E91C
EA27: D1          pop  de
EA28: 13          inc  de
EA29: 13          inc  de
EA2A: 13          inc  de
EA2B: 13          inc  de
EA2C: ED 53 AD 62 ld   (unknown_62AD),de
EA30: 7B          ld   a,e
EA31: FE 20       cp   $20
EA33: D8          ret  c
EA34: 11 00 00    ld   de,$0000
EA37: ED 53 AD 62 ld   (unknown_62AD),de
EA3B: C9          ret
EA3C: DD 7E 00    ld   a,(ix+$00)
EA3F: 77          ld   (hl),a
EA40: 2B          dec  hl
EA41: DD 7E 02    ld   a,(ix+$02)
EA44: 77          ld   (hl),a
EA45: D5          push de
EA46: 11 E0 FF    ld   de,$FFE0
EA49: 19          add  hl,de
EA4A: D1          pop  de
EA4B: DD 7E 03    ld   a,(ix+$03)
EA4E: 77          ld   (hl),a
EA4F: 23          inc  hl
EA50: DD 7E 01    ld   a,(ix+$01)
EA53: 77          ld   (hl),a
EA54: C9          ret

handle_player_destroying_wall_EA55:
EA55: 3A 0D 60    ld   a,(player_screen_600D)
EA58: FE 05       cp   $05
EA5A: C0          ret  nz
EA5B: 3A 83 65    ld   a,(player_y_6583)
EA5E: FE 98       cp   $98
EA60: C0          ret  nz
EA61: 3A 82 65    ld   a,(player_x_6582)
EA64: FE 88       cp   $88
EA66: C0          ret  nz
EA67: 3A CF 61    ld   a,(has_pick_61CF)
EA6A: FE 00       cp   $00
EA6C: C8          ret  z
EA6D: 3A 9C 65    ld   a,(object_held_struct_659C)
EA70: FE B8       cp   $B8
EA72: 28 03       jr   z,$EA77
EA74: FE B7       cp   $B7
EA76: C0          ret  nz
EA77: 3A F3 91    ld   a,($91F3)
EA7A: FE E0       cp   $E0
EA7C: C8          ret  z
EA7D: FE E6       cp   $E6
EA7F: C8          ret  z
EA80: FE E4       cp   $E4
EA82: C8          ret  z
EA83: FE D0       cp   $D0
EA85: C8          ret  z
EA86: 3A F3 91    ld   a,($91F3)
EA89: FE 02       cp   $02
EA8B: 28 0B       jr   z,$EA98
EA8D: 3D          dec  a
EA8E: 3D          dec  a
EA8F: 32 F3 91    ld   ($91F3),a
EA92: 3D          dec  a
EA93: 32 F4 91    ld   ($91F4),a
EA96: 18 08       jr   $EAA0
EA98: 3E E0       ld   a,$E0
EA9A: 32 F3 91    ld   ($91F3),a
EA9D: 32 F4 91    ld   ($91F4),a
EAA0: 3A F3 91    ld   a,($91F3)
EAA3: 32 7D 62    ld   (unknown_627D),a
EAA6: C9          ret
EAA7: DD 21 80 65 ld   ix,player_struct_6580
EAAB: FD 21 09 60 ld   iy,player_logical_address_6009
EAAF: 18 34       jr   $EAE5
EAB1: DD 21 94 65 ld   ix,guard_1_struct_6594
EAB5: FD 21 38 60 ld   iy,guard_1_logical_address_6038
EAB9: 3A 99 60    ld   a,(guard_1_screen_6099)
EABC: 18 2A       jr   $EAE8
EABE: DD 21 98 65 ld   ix,guard_2_struct_6598
EAC2: FD 21 78 60 ld   iy,guard_2_logical_address_6078
EAC6: 3A 9A 60    ld   a,(guard_2_screen_609A)
EAC9: 18 1D       jr   $EAE8
EACB: DD 21 8C 65 ld   ix,wagon_2_shadow_sprite_658C
EACF: FD 21 B2 62 ld   iy,unknown_62B2
EAD3: 3A 0D 60    ld   a,(player_screen_600D)
EAD6: 18 10       jr   $EAE8
EAD8: DD 21 9C 65 ld   ix,object_held_struct_659C
EADC: FD 21 5A 61 ld   iy,unknown_615A
EAE0: 3A 0D 60    ld   a,(player_screen_600D)
EAE3: 18 03       jr   $EAE8
EAE5: 3A 0D 60    ld   a,(player_screen_600D)
EAE8: 32 98 60    ld   (current_guard_screen_index_6098),a
EAEB: CD EF EA    call compute_logical_address_from_xy_EAEF
EAEE: C9          ret

compute_logical_address_from_xy_EAEF:
EAEF: CD 0E EB    call $EB0E
EAF2: CD FC EA    call $EAFC
EAF5: FD 75 00    ld   (iy+$00),l
EAF8: FD 74 01    ld   (iy+$01),h
EAFB: C9          ret
EAFC: DD 7E 03    ld   a,(ix+$03)
EAFF: C6 10       add  a,$10
EB01: CB 3F       srl  a
EB03: CB 3F       srl  a
EB05: CB 3F       srl  a
EB07: 85          add  a,l
EB08: 6F          ld   l,a
EB09: 7C          ld   a,h
EB0A: CE 00       adc  a,$00
EB0C: 67          ld   h,a
EB0D: C9          ret
EB0E: DD 7E 02    ld   a,(ix+$02)
EB11: C6 07       add  a,$07
EB13: 2F          cpl
EB14: E6 F8       and  $F8
EB16: 26 00       ld   h,$00
EB18: 6F          ld   l,a
EB19: CB 25       sla  l
EB1B: CB 14       rl   h
EB1D: CB 25       sla  l
EB1F: CB 14       rl   h
EB21: 7C          ld   a,h
EB22: F6 40       or   $40
EB24: 67          ld   h,a
EB25: 3A 98 60    ld   a,(current_guard_screen_index_6098)
EB28: FE 01       cp   $01
EB2A: C8          ret  z
EB2B: FE 02       cp   $02
EB2D: 20 05       jr   nz,$EB34
EB2F: 7C          ld   a,h
EB30: C6 04       add  a,$04
EB32: 67          ld   h,a
EB33: C9          ret
EB34: FE 03       cp   $03
EB36: 20 05       jr   nz,$EB3D
EB38: 7C          ld   a,h
EB39: C6 08       add  a,$08
EB3B: 67          ld   h,a
EB3C: C9          ret
EB3D: FE 04       cp   $04
EB3F: 20 05       jr   nz,$EB46
EB41: 7C          ld   a,h
EB42: D6 10       sub  $10
EB44: 67          ld   h,a
EB45: C9          ret
EB46: FE 05       cp   $05
EB48: C0          ret  nz
EB49: 7C          ld   a,h
EB4A: D6 0C       sub  $0C
EB4C: 67          ld   h,a
EB4D: C9          ret
EB4E: DD 7E 02    ld   a,(ix+$02)
EB51: B8          cp   b
EB52: D8          ret  c
EB53: B9          cp   c
EB54: D0          ret  nc
EB55: D9          exx
EB56: DD 7E 03    ld   a,(ix+$03)
EB59: B8          cp   b
EB5A: D8          ret  c
EB5B: B9          cp   c
EB5C: D0          ret  nc
EB5D: D9          exx
EB5E: 3E 01       ld   a,$01
EB60: FD 77 00    ld   (iy+$00),a
EB63: C9          ret
EB64: 7D          ld   a,l
EB65: CB 27       sla  a
EB67: CB 27       sla  a
EB69: CB 27       sla  a
EB6B: D6 08       sub  $08
EB6D: 47          ld   b,a
EB6E: C6 10       add  a,$10
EB70: 4F          ld   c,a
EB71: CB 3C       srl  h
EB73: CB 1D       rr   l
EB75: CB 3C       srl  h
EB77: CB 1D       rr   l
EB79: 7D          ld   a,l
EB7A: D9          exx
EB7B: E6 F8       and  $F8
EB7D: C6 07       add  a,$07
EB7F: 2F          cpl
EB80: D6 08       sub  $08
EB82: 47          ld   b,a
EB83: C6 25       add  a,$25
EB85: 4F          ld   c,a
EB86: C9          ret
EB87: 06 50       ld   b,$50
EB89: FE 01       cp   $01
EB8B: C8          ret  z
EB8C: 06 4C       ld   b,$4C
EB8E: FE 02       cp   $02
EB90: C8          ret  z
EB91: 06 48       ld   b,$48
EB93: FE 03       cp   $03
EB95: C8          ret  z
EB96: 06 60       ld   b,$60
EB98: FE 04       cp   $04
EB9A: C8          ret  z
EB9B: 06 5C       ld   b,$5C
EB9D: C9          ret
EB9E: 3A C7 61    ld   a,(holds_barrow_61C7)
EBA1: FE 01       cp   $01
EBA3: C0          ret  nz
EBA4: CD E9 EB    call $EBE9
EBA7: 3A C7 61    ld   a,(holds_barrow_61C7)
EBAA: FE 01       cp   $01
EBAC: C0          ret  nz
EBAD: 3A 9E 65    ld   a,(sprite_object_x_659E)
EBB0: D6 20       sub  $20
EBB2: 32 9E 65    ld   (sprite_object_x_659E),a
EBB5: CD E9 EB    call $EBE9
EBB8: 3A C7 61    ld   a,(holds_barrow_61C7)
EBBB: FE 01       cp   $01
EBBD: C0          ret  nz
EBBE: 3A 9E 65    ld   a,(sprite_object_x_659E)
EBC1: D6 08       sub  $08
EBC3: 32 9E 65    ld   (sprite_object_x_659E),a
EBC6: CD E9 EB    call $EBE9
EBC9: 3A C7 61    ld   a,(holds_barrow_61C7)
EBCC: FE 01       cp   $01
EBCE: C0          ret  nz
EBCF: 3A 9E 65    ld   a,(sprite_object_x_659E)
EBD2: D6 08       sub  $08
EBD4: 32 9E 65    ld   (sprite_object_x_659E),a
EBD7: CD E9 EB    call $EBE9
EBDA: 3A C7 61    ld   a,(holds_barrow_61C7)
EBDD: FE 01       cp   $01
EBDF: C0          ret  nz
EBE0: 3A 9E 65    ld   a,(sprite_object_x_659E)
EBE3: C6 30       add  a,$30
EBE5: 32 9E 65    ld   (sprite_object_x_659E),a
EBE8: C9          ret
EBE9: C5          push bc
EBEA: FD E5       push iy
EBEC: 01 C7 61    ld   bc,holds_barrow_61C7
EBEF: D9          exx
EBF0: FD 21 C4 61 ld   iy,barrow_screen_params_61C4
EBF4: 3E 28       ld   a,$28
EBF6: FD 77 05    ld   (iy+$05),a
EBF9: 3E EC       ld   a,$EC
EBFB: FD 77 06    ld   (iy+$06),a
EBFE: CD 55 FC    call drop_object_FC55
EC01: FD E1       pop  iy
EC03: C1          pop  bc
EC04: C9          ret
EC05: 3A 41 63    ld   a,(unknown_6341)
EC08: FE 01       cp   $01
EC0A: 28 14       jr   z,$EC20
EC0C: 23          inc  hl
EC0D: 7E          ld   a,(hl)
EC0E: FE ED       cp   $ED
EC10: C8          ret  z
EC11: FE EF       cp   $EF
EC13: C8          ret  z
EC14: 7D          ld   a,l
EC15: C6 20       add  a,$20
EC17: 6F          ld   l,a
EC18: 7C          ld   a,h
EC19: CE 00       adc  a,$00
EC1B: 67          ld   h,a
EC1C: 7E          ld   a,(hl)
EC1D: FE ED       cp   $ED
EC1F: C9          ret
EC20: 23          inc  hl
EC21: 7E          ld   a,(hl)
EC22: FE BF       cp   $BF
EC24: C8          ret  z
EC25: D5          push de
EC26: 11 20 00    ld   de,$0020
EC29: 19          add  hl,de
EC2A: 7E          ld   a,(hl)
EC2B: FE BF       cp   $BF
EC2D: 28 06       jr   z,$EC35
EC2F: 19          add  hl,de
EC30: 7E          ld   a,(hl)
EC31: FE BF       cp   $BF
EC33: 28 00       jr   z,$EC35
EC35: D1          pop  de
EC36: C9          ret
EC37: 3A 83 65    ld   a,(player_y_6583)
EC3A: D6 02       sub  $02
EC3C: 32 9F 65    ld   (sprite_object_y_659F),a
EC3F: 3A 80 65    ld   a,(player_struct_6580)
EC42: E6 7F       and  $7F
EC44: FE 12       cp   $12
EC46: C8          ret  z
EC47: 3A 80 65    ld   a,(player_struct_6580)
EC4A: E6 80       and  $80
EC4C: FE 80       cp   $80
EC4E: 28 0E       jr   z,$EC5E
EC50: 3A 82 65    ld   a,(player_x_6582)
EC53: C6 08       add  a,$08
EC55: 32 9E 65    ld   (sprite_object_x_659E),a
EC58: 3E 31       ld   a,$31
EC5A: 32 9C 65    ld   (object_held_struct_659C),a
EC5D: C9          ret
EC5E: 3A 82 65    ld   a,(player_x_6582)
EC61: D6 08       sub  $08
EC63: 32 9E 65    ld   (sprite_object_x_659E),a
EC66: 3E B1       ld   a,$B1
EC68: 32 9C 65    ld   (object_held_struct_659C),a
EC6B: C9          ret
EC6C: 21 6E 92    ld   hl,$926E
EC6F: 11 A1 56    ld   de,$56A1
EC72: CD 67 CA    call display_localized_text_CA67
EC75: C9          ret
EC76: 06 18       ld   b,$18
EC78: 21 00 30    ld   hl,$3000
EC7B: 2B          dec  hl
EC7C: 7C          ld   a,h
EC7D: FE 00       cp   $00
EC7F: 20 FA       jr   nz,$EC7B
EC81: 10 F5       djnz $EC78
EC83: C9          ret

play_sample_EC84:
EC84: 3A 10 62    ld   a,(must_play_music_6210)
EC87: FE 01       cp   $01
EC89: 28 0F       jr   z,$EC9A
EC8B: 3A 54 60    ld   a,(gameplay_allowed_6054)
EC8E: FE 01       cp   $01
EC90: 28 08       jr   z,$EC9A
EC92: 3A 00 B0    ld   a,($B000)
EC95: E6 40       and  $40
EC97: FE 40       cp   $40
EC99: C0          ret  nz
EC9A: 11 BD 61    ld   de,unknown_61BD
EC9D: 01 06 00    ld   bc,$0006
ECA0: ED B0       ldir
ECA2: 3E 01       ld   a,$01
ECA4: 32 F3 61    ld   (unknown_61F3),a
ECA7: C9          ret

ECA8: AF          xor  a
ECA9: 32 00 A0    ld   (interrupt_control_A000),a
ECAC: F3          di
ECAD: 3C          inc  a
ECAE: C3 00 C0    jp   $C000
ECB1: 21 00 05    ld   hl,$0500
ECB4: CD D9 C5    call $C5D9
ECB7: 3E 01       ld   a,$01
ECB9: CD E2 D8    call $D8E2
ECBC: 3E 40       ld   a,$40
ECBE: 32 E8 61    ld   (time_61E8),a
ECC1: CD 18 12    call play_intro_1218
ECC4: CD DB CF    call set_bags_coordinates_easy_level_CFDB
ECC7: CD E7 CF    call set_bags_coordinates_CFE7
ECCA: 21 3C 51    ld   hl,$513C
ECCD: 22 40 61    ld   (ay_sound_pointer_6140),hl
ECD0: 22 4E 63    ld   (unknown_634E),hl
ECD3: 3E 38       ld   a,$38
ECD5: 32 4D 63    ld   (unknown_634D),a
ECD8: AF          xor  a
ECD9: 32 48 63    ld   (unknown_6348),a
ECDC: F3          di
ECDD: 3A 00 B8    ld   a,(io_read_shit_B800)
ECE0: CD 51 F9    call init_new_game_F951
ECE3: CD 14 C3    call init_guard_directions_and_wagons_C314
ECE6: AF          xor  a
ECE7: 32 25 60    ld   (player_death_flag_6025),a
ECEA: 3C          inc  a
ECEB: 32 9A 60    ld   (guard_2_screen_609A),a
ECEE: 3E 03       ld   a,$03
ECF0: 32 99 60    ld   (guard_1_screen_6099),a
ECF3: CD BF DF    call $DFBF
ECF6: CD A9 D7    call $D7A9
ECF9: 3E 01       ld   a,$01
ECFB: ED 56       im   1
ECFD: 32 00 A0    ld   (interrupt_control_A000),a
ED00: FB          ei
ED01: 3A 00 A8    ld   a,($A800)
ED04: CD 34 CF    call $CF34
ED07: CD 2E C0    call $C02E
ED0A: DD 21 80 65 ld   ix,player_struct_6580
ED0E: FD 21 94 65 ld   iy,guard_1_struct_6594
ED12: 11 04 00    ld   de,$0004
ED15: 3A 0D 60    ld   a,(player_screen_600D)
ED18: 47          ld   b,a
ED19: 3A 99 60    ld   a,(guard_1_screen_6099)
ED1C: B8          cp   b
ED1D: 20 13       jr   nz,$ED32
ED1F: CD 37 55    call $5537
ED22: FE 00       cp   $00
ED24: 28 0C       jr   z,$ED32
ED26: 3A 56 61    ld   a,(unknown_6156)
ED29: FE 00       cp   $00
ED2B: 20 05       jr   nz,$ED32
ED2D: 3E 01       ld   a,$01
ED2F: 32 25 60    ld   (player_death_flag_6025),a
ED32: DD 21 80 65 ld   ix,player_struct_6580
ED36: FD 21 98 65 ld   iy,guard_2_struct_6598
ED3A: 11 04 00    ld   de,$0004
ED3D: 3A 0D 60    ld   a,(player_screen_600D)
ED40: 47          ld   b,a
ED41: 3A 9A 60    ld   a,(guard_2_screen_609A)
ED44: B8          cp   b
ED45: 20 13       jr   nz,$ED5A
ED47: CD 37 55    call $5537
ED4A: FE 00       cp   $00
ED4C: 28 0C       jr   z,$ED5A
ED4E: 3A 57 61    ld   a,(unknown_6157)
ED51: FE 00       cp   $00
ED53: 20 05       jr   nz,$ED5A
ED55: 3E 01       ld   a,$01
ED57: 32 25 60    ld   (player_death_flag_6025),a
ED5A: 3A 54 60    ld   a,(gameplay_allowed_6054)
ED5D: FE 01       cp   $01
ED5F: 28 64       jr   z,$EDC5
ED61: 3E 01       ld   a,$01
ED63: CD E2 D8    call $D8E2
ED66: 3A 53 60    ld   a,(game_locked_6053)
ED69: FE 01       cp   $01
ED6B: 20 58       jr   nz,$EDC5
ED6D: 3A 10 62    ld   a,(must_play_music_6210)
ED70: FE 01       cp   $01
ED72: 28 51       jr   z,$EDC5
ED74: F3          di
ED75: 3A 55 60    ld   a,(unknown_6055)
ED78: FE 01       cp   $01
ED7A: 28 23       jr   z,$ED9F
ED7C: 3A 00 B8    ld   a,(io_read_shit_B800)
ED7F: CD E3 C3    call $C3E3
ED82: CD A4 F8    call display_player_ids_and_credit_F8A4
ED85: CD 2E 16    call $162E
ED88: 21 68 5B    ld   hl,$5B68
ED8B: 22 40 61    ld   (ay_sound_pointer_6140),hl
ED8E: AF          xor  a
ED8F: 32 42 61    ld   (ay_sound_start_6142),a
ED92: 3E 01       ld   a,$01
ED94: 32 55 60    ld   (unknown_6055),a
ED97: 3A 54 60    ld   a,(gameplay_allowed_6054)
ED9A: FE 01       cp   $01
ED9C: CA F9 EC    jp   z,$ECF9
ED9F: 3A 10 62    ld   a,(must_play_music_6210)
EDA2: FE 01       cp   $01
EDA4: 28 1F       jr   z,$EDC5
EDA6: 3A 00 60    ld   a,(number_of_credits_6000)
EDA9: FE 01       cp   $01
EDAB: 20 0C       jr   nz,$EDB9
EDAD: 11 DF 56    ld   de,$56DF
EDB0: 21 11 93    ld   hl,$9311
EDB3: CD 67 CA    call display_localized_text_CA67
EDB6: C3 F9 EC    jp   $ECF9
EDB9: 11 F2 56    ld   de,$56F2
EDBC: 21 11 93    ld   hl,$9311
EDBF: CD 67 CA    call display_localized_text_CA67
EDC2: C3 F9 EC    jp   $ECF9
EDC5: CD F7 F8    call $F8F7
EDC8: FE 01       cp   $01
EDCA: CA DC EC    jp   z,$ECDC
EDCD: 3A E8 61    ld   a,(time_61E8)
EDD0: FE 00       cp   $00
EDD2: 20 08       jr   nz,$EDDC
EDD4: CD 2D F9    call $F92D
EDD7: FE 01       cp   $01
EDD9: CA DC EC    jp   z,$ECDC
EDDC: CD 37 F9    call $F937
EDDF: 32 00 B8    ld   (io_read_shit_B800),a
EDE2: CD F2 F6    call handle_guard_1_views_player_F6F2
EDE5: 3A A3 58    ld   a,($58A3)
EDE8: 32 73 62    ld   (unknown_6273),a
EDEB: 3A 00 B8    ld   a,(io_read_shit_B800)
EDEE: 3A 0D 60    ld   a,(player_screen_600D)
EDF1: 47          ld   b,a
EDF2: 3A 99 60    ld   a,(guard_1_screen_6099)
EDF5: B8          cp   b
EDF6: CC 6D F6    call z,$F66D
EDF9: FB          ei
EDFA: CD 8B F7    call handle_guard_2_views_player_F78B
EDFD: 3A 0F 57    ld   a,($570F)
EE00: 32 70 62    ld   (unknown_6270),a
EE03: 3A 00 B8    ld   a,(io_read_shit_B800)
EE06: 3A 00 B8    ld   a,(io_read_shit_B800)
EE09: 3A 0D 60    ld   a,(player_screen_600D)
EE0C: 47          ld   b,a
EE0D: 3A 9A 60    ld   a,(guard_2_screen_609A)
EE10: B8          cp   b
EE11: CC 56 F7    call z,$F756
EE14: FB          ei
EE15: 32 00 B0    ld   ($B000),a
EE18: 3A 99 60    ld   a,(guard_1_screen_6099)
EE1B: 32 98 60    ld   (current_guard_screen_index_6098),a
EE1E: FD 21 94 65 ld   iy,guard_1_struct_6594
EE22: FD 22 93 60 ld   (guard_struct_pointer_6093),iy
EE26: DD 21 27 60 ld   ix,guard_1_direction_6027
EE2A: DD 22 95 60 ld   (guard_direction_pointer_6095),ix
EE2E: DD 21 35 60 ld   ix,guard_1_ladder_frame_6035
EE32: FD 21 94 65 ld   iy,guard_1_struct_6594
EE36: ED 5B 38 60 ld   de,(guard_1_logical_address_6038)
EE3A: ED 53 91 60 ld   (guard_logical_address_6091),de
EE3E: 3A 00 B8    ld   a,(io_read_shit_B800)
EE41: CD 0B F5    call analyse_guard_direction_change_F50B
EE44: DD 21 3B 60 ld   ix,guard_1_in_elevator_603B
EE48: 21 57 60    ld   hl,guard_1_not_moving_timeout_counter_6057
EE4B: 11 48 61    ld   de,unknown_6148
EE4E: CD 2E F4    call check_for_not_moving_timeout_F42E
EE51: 3A 48 61    ld   a,(unknown_6148)
EE54: FE 00       cp   $00
EE56: 20 2D       jr   nz,$EE85
EE58: 3A 57 60    ld   a,(guard_1_not_moving_timeout_counter_6057)
EE5B: FE F0       cp   $F0
EE5D: D4 58 CB    call nc,$CB58
EE60: FE 10       cp   $10
EE62: FD 21 94 65 ld   iy,guard_1_struct_6594
EE66: FD 22 93 60 ld   (guard_struct_pointer_6093),iy
EE6A: DD 21 27 60 ld   ix,guard_1_direction_6027
EE6E: DD 22 95 60 ld   (guard_direction_pointer_6095),ix
EE72: FD 21 94 65 ld   iy,guard_1_struct_6594
EE76: ED 5B 38 60 ld   de,(guard_1_logical_address_6038)
EE7A: ED 53 91 60 ld   (guard_logical_address_6091),de
EE7E: DD 21 35 60 ld   ix,guard_1_ladder_frame_6035
EE82: D4 B8 FB    call nc,choose_guard_random_direction_FBB8
EE85: 3A 9A 60    ld   a,(guard_2_screen_609A)
EE88: 32 98 60    ld   (current_guard_screen_index_6098),a
EE8B: FD 21 98 65 ld   iy,guard_2_struct_6598
EE8F: FD 22 93 60 ld   (guard_struct_pointer_6093),iy
EE93: DD 21 67 60 ld   ix,guard_2_direction_6067
EE97: DD 22 95 60 ld   (guard_direction_pointer_6095),ix
EE9B: DD 21 75 60 ld   ix,guard_2_ladder_frame_6075
EE9F: FD 21 98 65 ld   iy,guard_2_struct_6598
EEA3: ED 5B 78 60 ld   de,(guard_2_logical_address_6078)
EEA7: ED 53 91 60 ld   (guard_logical_address_6091),de
EEAB: 3A 00 B8    ld   a,(io_read_shit_B800)
EEAE: 3A 0C 57    ld   a,($570C)
EEB1: 32 71 62    ld   (unknown_6271),a
EEB4: CD 0B F5    call analyse_guard_direction_change_F50B
EEB7: DD 21 7B 60 ld   ix,guard_2_in_elevator_607B
EEBB: 21 97 60    ld   hl,guard_2_not_moving_timeout_counter_6097
EEBE: 11 49 61    ld   de,unknown_6149
EEC1: CD 2E F4    call check_for_not_moving_timeout_F42E
EEC4: 3A 49 61    ld   a,(unknown_6149)
EEC7: FE 00       cp   $00
EEC9: 20 2D       jr   nz,$EEF8
EECB: 3A 97 60    ld   a,(guard_2_not_moving_timeout_counter_6097)
EECE: FE F0       cp   $F0
EED0: D4 7D CB    call nc,$CB7D
EED3: FE 10       cp   $10
EED5: FD 21 98 65 ld   iy,guard_2_struct_6598
EED9: FD 22 93 60 ld   (guard_struct_pointer_6093),iy
EEDD: DD 21 67 60 ld   ix,guard_2_direction_6067
EEE1: DD 22 95 60 ld   (guard_direction_pointer_6095),ix
EEE5: FD 21 98 65 ld   iy,guard_2_struct_6598
EEE9: ED 5B 78 60 ld   de,(guard_2_logical_address_6078)
EEED: ED 53 91 60 ld   (guard_logical_address_6091),de
EEF1: DD 21 75 60 ld   ix,guard_2_ladder_frame_6075
EEF5: D4 B8 FB    call nc,choose_guard_random_direction_FBB8
EEF8: FB          ei
EEF9: 3A ED 62    ld   a,(unknown_62ED)
EEFC: FE 01       cp   $01
EEFE: 28 10       jr   z,$EF10
EF00: 2A 78 60    ld   hl,(guard_2_logical_address_6078)
EF03: CD 8E F1    call $F18E
EF06: CA 0B EF    jp   z,$EF0B
EF09: 18 05       jr   $EF10
EF0B: 3E 01       ld   a,$01
EF0D: 32 77 60    ld   (guard_2_in_elevator_6077),a
EF10: 2A 38 60    ld   hl,(guard_1_logical_address_6038)
EF13: 3A E9 62    ld   a,(unknown_62E9)
EF16: FE 01       cp   $01
EF18: 28 0C       jr   z,$EF26
EF1A: CD 8E F1    call $F18E
EF1D: 28 02       jr   z,$EF21
EF1F: 18 05       jr   $EF26
EF21: 3E 01       ld   a,$01
EF23: 32 37 60    ld   (guard_1_in_elevator_6037),a
EF26: 2A 38 60    ld   hl,(guard_1_logical_address_6038)
EF29: FD 21 37 60 ld   iy,guard_1_in_elevator_6037
EF2D: DD 21 94 65 ld   ix,guard_1_struct_6594
EF31: CD 2A C1    call $C12A
EF34: 01 E0 FF    ld   bc,$FFE0
EF37: 2A 38 60    ld   hl,(guard_1_logical_address_6038)
EF3A: DD 21 94 65 ld   ix,guard_1_struct_6594
EF3E: CD 98 C0    call $C098
EF41: 2A 78 60    ld   hl,(guard_2_logical_address_6078)
EF44: FD 21 77 60 ld   iy,guard_2_in_elevator_6077
EF48: DD 21 98 65 ld   ix,guard_2_struct_6598
EF4C: CD 2A C1    call $C12A
EF4F: 01 E0 FF    ld   bc,$FFE0
EF52: 2A 78 60    ld   hl,(guard_2_logical_address_6078)
EF55: DD 21 98 65 ld   ix,guard_2_struct_6598
EF59: CD 98 C0    call $C098
EF5C: 3A 00 B8    ld   a,(io_read_shit_B800)
EF5F: 2A 09 60    ld   hl,(player_logical_address_6009)
EF62: FB          ei
EF63: CD 8E F1    call $F18E
EF66: 28 0E       jr   z,$EF76
EF68: 3A 4E 60    ld   a,(fatal_fall_height_reached_604E)
EF6B: FE 01       cp   $01
EF6D: 28 0C       jr   z,$EF7B
EF6F: 3E 00       ld   a,$00
EF71: 32 08 60    ld   (unknown_6008),a
EF74: 18 05       jr   $EF7B
EF76: 3E 01       ld   a,$01
EF78: 32 08 60    ld   (unknown_6008),a
EF7B: 2A 09 60    ld   hl,(player_logical_address_6009)
EF7E: FD 21 08 60 ld   iy,unknown_6008
EF82: DD 21 80 65 ld   ix,player_struct_6580
EF86: CD 2A C1    call $C12A
EF89: 2A 09 60    ld   hl,(player_logical_address_6009)
EF8C: DD 21 80 65 ld   ix,player_struct_6580
EF90: 01 3A 63    ld   bc,unknown_633A
EF93: CD 98 C0    call $C098
EF96: 3E 01       ld   a,$01
EF98: 32 6F 62    ld   (unknown_626F),a
EF9B: 3A 00 B8    ld   a,(io_read_shit_B800)
EF9E: CD EB CB    call $CBEB
EFA1: 3E 00       ld   a,$00
EFA3: 32 6F 62    ld   (unknown_626F),a
EFA6: CD 2D F8    call $F82D
EFA9: FE 01       cp   $01
EFAB: CA DC EC    jp   z,$ECDC
EFAE: DD 21 3C 60 ld   ix,guard_1_sees_player_right_603C
EFB2: 06 04       ld   b,$04
EFB4: DD 7E 00    ld   a,(ix+$00)
EFB7: FE 00       cp   $00
EFB9: 20 30       jr   nz,guard_2_sees_player_EFEB
EFBB: DD 23       inc  ix
EFBD: 10 F5       djnz $EFB4
EFBF: 21 E9 62    ld   hl,unknown_62E9
EFC2: 22 3D 63    ld   (unknown_633D),hl
EFC5: 21 27 60    ld   hl,guard_1_direction_6027
EFC8: 22 95 60    ld   (guard_direction_pointer_6095),hl
EFCB: 21 44 61    ld   hl,unknown_6144
EFCE: 22 46 61    ld   (unknown_pointer_6146),hl
EFD1: 3A 99 60    ld   a,(guard_1_screen_6099)
EFD4: 32 98 60    ld   (current_guard_screen_index_6098),a
EFD7: DD 21 80 65 ld   ix,player_struct_6580
EFDB: FD 21 94 65 ld   iy,guard_1_struct_6594
EFDF: ED 5B 38 60 ld   de,(guard_1_logical_address_6038)
EFE3: 21 3B 60    ld   hl,guard_1_in_elevator_603B
EFE6: CD BC C4    call guard_wait_for_elevator_test_C4BC
EFE9: 18 04       jr   $EFEF

guard_2_sees_player_EFEB:
EFEB: AF          xor  a
EFEC: 32 48 61    ld   (unknown_6148),a
EFEF: DD 21 7C 60 ld   ix,guard_2_sees_player_right_607C
EFF3: 06 04       ld   b,$04
EFF5: DD 7E 00    ld   a,(ix+$00)
EFF8: FE 00       cp   $00
EFFA: 20 30       jr   nz,guard_1_sees_player_F02C
EFFC: DD 23       inc  ix
EFFE: 10 F5       djnz $EFF5
F000: 21 ED 62    ld   hl,unknown_62ED
F003: 22 3D 63    ld   (unknown_633D),hl
F006: 21 67 60    ld   hl,guard_2_direction_6067
F009: 22 95 60    ld   (guard_direction_pointer_6095),hl
F00C: 21 45 61    ld   hl,unknown_6145
F00F: 22 46 61    ld   (unknown_pointer_6146),hl
F012: 3A 9A 60    ld   a,(guard_2_screen_609A)
F015: 32 98 60    ld   (current_guard_screen_index_6098),a
F018: DD 21 80 65 ld   ix,player_struct_6580
F01C: FD 21 98 65 ld   iy,guard_2_struct_6598
F020: ED 5B 78 60 ld   de,(guard_2_logical_address_6078)
F024: 21 7B 60    ld   hl,guard_2_in_elevator_607B
F027: CD BC C4    call guard_wait_for_elevator_test_C4BC
F02A: 18 04       jr   $F030

guard_1_sees_player_F02C:
F02C: AF          xor  a
F02D: 32 49 61    ld   (unknown_6149),a
F030: 3A 60 61    ld   a,(pickup_flag_6160)
F033: 32 2A 63    ld   (unknown_632A),a
F036: 2A 09 60    ld   hl,(player_logical_address_6009)
F039: CD CB F2    call $F2CB
F03C: F3          di
F03D: CD BD DA    call $DABD
F040: CD 3E D7    call $D73E
F043: 28 03       jr   z,$F048
F045: CD 99 E3    call $E399
F048: FB          ei
F049: 3A CF 61    ld   a,(has_pick_61CF)
F04C: FE 00       cp   $00
F04E: 28 27       jr   z,$F077
F050: 3A 99 60    ld   a,(guard_1_screen_6099)
F053: 47          ld   b,a
F054: 3A 70 62    ld   a,(unknown_6270)
F057: B8          cp   b
F058: 3A 0D 60    ld   a,(player_screen_600D)
F05B: B8          cp   b
F05C: 20 19       jr   nz,$F077
F05E: DD 21 94 65 ld   ix,guard_1_struct_6594
F062: FD 21 9C 65 ld   iy,object_held_struct_659C
F066: 0E 00       ld   c,$00
F068: 06 06       ld   b,$06
F06A: CD 97 C4    call $C497
F06D: FE 01       cp   $01
F06F: 20 06       jr   nz,$F077
F071: CD F4 FC    call $FCF4
F074: CD AD CA    call $CAAD
F077: 3A 9F 62    ld   a,(unknown_629F)
F07A: FE 01       cp   $01
F07C: CC F4 FC    call z,$FCF4
F07F: AF          xor  a
F080: 32 9F 62    ld   (unknown_629F),a
F083: 3A CF 61    ld   a,(has_pick_61CF)
F086: FE 00       cp   $00
F088: 28 23       jr   z,$F0AD
F08A: DD 21 98 65 ld   ix,guard_2_struct_6598
F08E: FD 21 9C 65 ld   iy,object_held_struct_659C
F092: 3A 9A 60    ld   a,(guard_2_screen_609A)
F095: 47          ld   b,a
F096: 3A 0D 60    ld   a,(player_screen_600D)
F099: B8          cp   b
F09A: 20 11       jr   nz,$F0AD
F09C: 0E 00       ld   c,$00
F09E: 06 06       ld   b,$06
F0A0: CD 97 C4    call $C497
F0A3: FE 01       cp   $01
F0A5: 20 06       jr   nz,$F0AD
F0A7: CD 33 FD    call $FD33
F0AA: CD AD CA    call $CAAD
F0AD: 3A A7 62    ld   a,(unknown_62A7)
F0B0: FE 01       cp   $01
F0B2: CC 33 FD    call z,$FD33
F0B5: AF          xor  a
F0B6: 32 A7 62    ld   (unknown_62A7),a
F0B9: DD 21 80 65 ld   ix,player_struct_6580
F0BD: FD 21 84 65 ld   iy,elevator_struct_6584
F0C1: CD 93 C4    call guard_collision_with_pick_C493
F0C4: FE 01       cp   $01
F0C6: 20 11       jr   nz,$F0D9
F0C8: 3E 01       ld   a,$01
F0CA: 32 25 60    ld   (player_death_flag_6025),a
F0CD: AF          xor  a
F0CE: 32 29 60    ld   (player_in_wagon_flag_6029),a
F0D1: CD 2D F8    call $F82D
F0D4: FE 01       cp   $01
F0D6: CA DC EC    jp   z,$ECDC
F0D9: FB          ei
F0DA: CD EE C5    call compute_guard_speed_from_dipsw_C5EE
F0DD: CD 7E D2    call $D27E
F0E0: 3A ED 61    ld   a,(check_scenery_disabled_61ED)
F0E3: FE 00       cp   $00
F0E5: CC 72 FD    call z,draw_object_tiles_FD72
F0E8: 3A 7C 60    ld   a,(guard_2_sees_player_right_607C)
F0EB: 47          ld   b,a
F0EC: 3A 7D 60    ld   a,(guard_2_sees_player_left_607D)
F0EF: B0          or   b
F0F0: FE 00       cp   $00
F0F2: C4 7D E6    call nz,$E67D
F0F5: 3A 3C 60    ld   a,(guard_1_sees_player_right_603C)
F0F8: 47          ld   b,a
F0F9: 3A 3D 60    ld   a,(guard_1_sees_player_left_603D)
F0FC: B0          or   b
F0FD: FE 00       cp   $00
F0FF: C4 F9 E6    call nz,$E6F9
F102: CD C5 E2    call $E2C5
F105: CD ED E1    call $E1ED
F108: CD 0D E2    call $E20D
F10B: CD 28 E2    call $E228
F10E: CD F7 DE    call $DEF7
F111: CD 08 D7    call $D708
F114: 3A 43 63    ld   a,(unknown_6343)
F117: FE 01       cp   $01
F119: CC 2F D1    call z,check_if_level_completed_D12F
F11C: 3A 11 63    ld   a,(unknown_6311)
F11F: FE 01       cp   $01
F121: 28 2F       jr   z,$F152
F123: 3A 23 63    ld   a,(unknown_6323)
F126: FE 01       cp   $01
F128: 20 32       jr   nz,$F15C
F12A: 3A 34 63    ld   a,(unknown_6334)
F12D: FE 01       cp   $01
F12F: 28 2B       jr   z,$F15C
F131: 3A 24 63    ld   a,(unknown_6324)
F134: 3D          dec  a
F135: 32 24 63    ld   (unknown_6324),a
F138: FE 00       cp   $00
F13A: 20 11       jr   nz,$F14D
F13C: 3E 01       ld   a,$01
F13E: 32 F5 62    ld   (unknown_62F5),a
F141: 3E 01       ld   a,$01
F143: 32 51 63    ld   (unknown_6351),a
F146: AF          xor  a
F147: 32 23 63    ld   (unknown_6323),a
F14A: C3 5C F1    jp   $F15C
F14D: CD 55 DA    call $DA55
F150: 18 0A       jr   $F15C
F152: 3E 01       ld   a,$01
F154: 32 23 63    ld   (unknown_6323),a
F157: 3E 20       ld   a,$20
F159: 32 24 63    ld   (unknown_6324),a
F15C: 3A B6 62    ld   a,(unknown_62B6)
F15F: FE 01       cp   $01
F161: 20 05       jr   nz,$F168
F163: 3E 80       ld   a,$80
F165: 32 27 60    ld   (guard_1_direction_6027),a
F168: 3A BA 62    ld   a,(unknown_62BA)
F16B: FE 01       cp   $01
F16D: 20 05       jr   nz,$F174
F16F: 3E 80       ld   a,$80
F171: 32 67 60    ld   (guard_2_direction_6067),a
F174: 3A 56 61    ld   a,(unknown_6156)
F177: FE 00       cp   $00
F179: 28 04       jr   z,$F17F
F17B: AF          xor  a
F17C: 32 57 60    ld   (guard_1_not_moving_timeout_counter_6057),a
F17F: 3A 57 61    ld   a,(unknown_6157)
F182: FE 00       cp   $00
F184: 28 04       jr   z,$F18A
F186: AF          xor  a
F187: 32 97 60    ld   (guard_2_not_moving_timeout_counter_6097),a
F18A: 00          nop
F18B: C3 F9 EC    jp   $ECF9
F18E: 7E          ld   a,(hl)
F18F: 21 9E 23    ld   hl,$239E
F192: 23          inc  hl
F193: 01 09 00    ld   bc,$0009
F196: ED B1       cpir
F198: C9          ret
F199: 3A 5E 61    ld   a,(bag_sliding_615E)
F19C: FE 00       cp   $00
F19E: 20 06       jr   nz,$F1A6
F1A0: 3A 59 61    ld   a,(bag_falling_6159)
F1A3: FE 00       cp   $00
F1A5: C8          ret  z
F1A6: DD 21 9C 65 ld   ix,object_held_struct_659C
F1AA: FD 21 5A 61 ld   iy,unknown_615A
F1AE: 3A 0D 60    ld   a,(player_screen_600D)
F1B1: 32 98 60    ld   (current_guard_screen_index_6098),a
F1B4: DD 35 03    dec  (ix+$03)
F1B7: CD EF EA    call compute_logical_address_from_xy_EAEF
F1BA: DD 21 9C 65 ld   ix,object_held_struct_659C
F1BE: DD 34 03    inc  (ix+$03)
F1C1: 7E          ld   a,(hl)
F1C2: E5          push hl
F1C3: 21 24 5B    ld   hl,$5B24
F1C6: 01 07 00    ld   bc,$0007
F1C9: ED B9       cpdr
F1CB: E1          pop  hl
F1CC: C2 D9 F1    jp   nz,$F1D9
F1CF: 3E 01       ld   a,$01
F1D1: 32 5E 61    ld   (bag_sliding_615E),a
F1D4: AF          xor  a
F1D5: 32 59 61    ld   (bag_falling_6159),a
F1D8: C9          ret
F1D9: AF          xor  a
F1DA: 32 5E 61    ld   (bag_sliding_615E),a
F1DD: 3C          inc  a
F1DE: 32 59 61    ld   (bag_falling_6159),a
F1E1: DD 21 9C 65 ld   ix,object_held_struct_659C
F1E5: FD 21 5A 61 ld   iy,unknown_615A
F1E9: 3A 0D 60    ld   a,(player_screen_600D)
F1EC: 32 98 60    ld   (current_guard_screen_index_6098),a
F1EF: CD EF EA    call compute_logical_address_from_xy_EAEF
F1F2: 7E          ld   a,(hl)
F1F3: E5          push hl
F1F4: 21 E3 21    ld   hl,$21E3
F1F7: 01 17 00    ld   bc,$0017
F1FA: ED B9       cpdr
F1FC: E1          pop  hl
F1FD: C8          ret  z
F1FE: AF          xor  a
F1FF: 32 5E 61    ld   (bag_sliding_615E),a
F202: 32 59 61    ld   (bag_falling_6159),a
F205: FD 2A 5C 61 ld   iy,(unknown_pointer_615C)
F209: 3A 0D 60    ld   a,(player_screen_600D)
F20C: FD 77 02    ld   (iy+$02),a
F20F: CD B2 F2    call $F2B2
F212: 7E          ld   a,(hl)
F213: EB          ex   de,hl
F214: 21 E3 21    ld   hl,$21E3
F217: 01 17 00    ld   bc,$0017
F21A: ED B9       cpdr
F21C: EB          ex   de,hl
F21D: 28 06       jr   z,$F225
F21F: 11 20 00    ld   de,$0020
F222: 19          add  hl,de
F223: 18 21       jr   $F246
F225: 11 20 00    ld   de,$0020
F228: E5          push hl
F229: 19          add  hl,de
F22A: 7E          ld   a,(hl)
F22B: E1          pop  hl
F22C: FE EC       cp   $EC
F22E: 28 16       jr   z,$F246
F230: FE EE       cp   $EE
F232: 28 12       jr   z,$F246
F234: EB          ex   de,hl
F235: 21 E3 21    ld   hl,$21E3
F238: 01 17 00    ld   bc,$0017
F23B: ED B9       cpdr
F23D: EB          ex   de,hl
F23E: 28 06       jr   z,$F246
F240: 11 20 00    ld   de,$0020
F243: AF          xor  a
F244: ED 52       sbc  hl,de
F246: F3          di
F247: FD 75 00    ld   (iy+$00),l
F24A: 7D          ld   a,l
F24B: FE C0       cp   $C0
F24D: 20 02       jr   nz,$F251
F24F: 3E 68       ld   a,$68   ; will be overwritten just after
F251: FD 74 01    ld   (iy+$01),h
F254: 3A 0D 60    ld   a,(player_screen_600D)
F257: FD 77 02    ld   (iy+$02),a
F25A: FB          ei
F25B: CD 05 EC    call $EC05
F25E: 28 02       jr   z,$F262
F260: 18 42       jr   $F2A4
F262: DD E5       push ix
F264: CD C2 F2    call $F2C2
F267: 3A 9D 65    ld   a,(unknown_659D)
F26A: FE 24       cp   $24
F26C: 20 0B       jr   nz,$F279
F26E: 3E 20       ld   a,$20
F270: 32 9D 65    ld   (unknown_659D),a
F273: CD C2 F2    call $F2C2
F276: CD C2 F2    call $F2C2
F279: 21 81 D9    ld   hl,$D981
F27C: CD 84 EC    call play_sample_EC84
F27F: CD D9 D4    call can_pick_bag_D4D9
F282: 20 0A       jr   nz,$F28E
F284: 21 78 5B    ld   hl,$5B78
F287: 22 40 61    ld   (ay_sound_pointer_6140),hl
F28A: AF          xor  a
F28B: 32 42 61    ld   (ay_sound_start_6142),a
F28E: DD E1       pop  ix
F290: F3          di
F291: AF          xor  a
F292: FD 77 00    ld   (iy+$00),a
F295: FD 77 01    ld   (iy+$01),a
F298: FD 77 02    ld   (iy+$02),a
F29B: FB          ei
F29C: 3E 40       ld   a,$40
F29E: 32 E8 61    ld   (time_61E8),a
F2A1: CD 2F D1    call check_if_level_completed_D12F
F2A4: AF          xor  a
F2A5: DD 21 9C 65 ld   ix,object_held_struct_659C
F2A9: DD 77 02    ld   (ix+$02),a
F2AC: 3E FF       ld   a,$FF
F2AE: DD 77 03    ld   (ix+$03),a
F2B1: C9          ret
F2B2: CD 87 EB    call $EB87
F2B5: 7C          ld   a,h
F2B6: 80          add  a,b
F2B7: 67          ld   h,a
F2B8: AF          xor  a
F2B9: 7D          ld   a,l
F2BA: D6 22       sub  $22
F2BC: 6F          ld   l,a
F2BD: 7C          ld   a,h
F2BE: DE 00       sbc  a,$00
F2C0: 67          ld   h,a
F2C1: C9          ret
F2C2: 2A E7 61    ld   hl,(timer_high_prec_61E7)
F2C5: 2E 00       ld   l,$00
F2C7: CD 90 5C    call add_to_score_5C90
F2CA: C9          ret
F2CB: 3A D2 62    ld   a,(unknown_62D2)
F2CE: FE 01       cp   $01
F2D0: C8          ret  z
F2D1: 3A 3A 63    ld   a,(unknown_633A)
F2D4: FE 01       cp   $01
F2D6: C8          ret  z
F2D7: 3A 58 61    ld   a,(has_bag_6158)
F2DA: FE 00       cp   $00
F2DC: C2 A7 F4    jp   nz,$F4A7
F2DF: 3A CF 61    ld   a,(has_pick_61CF)
F2E2: FE 01       cp   $01
F2E4: C8          ret  z
F2E5: 3A C7 61    ld   a,(holds_barrow_61C7)
F2E8: FE 01       cp   $01
F2EA: C8          ret  z
F2EB: 3A 59 61    ld   a,(bag_falling_6159)
F2EE: FE 01       cp   $01
F2F0: C8          ret  z
F2F1: 3A 11 63    ld   a,(unknown_6311)
F2F4: FE 01       cp   $01
F2F6: C8          ret  z
F2F7: 3A 5E 61    ld   a,(bag_sliding_615E)
F2FA: FE 01       cp   $01
F2FC: C8          ret  z
F2FD: 3A 34 63    ld   a,(unknown_6334)
F300: FE 01       cp   $01
F302: C8          ret  z
F303: FD 21 9C 60 ld   iy,bags_coordinates_609C
F307: 06 12       ld   b,$12
F309: 2A 09 60    ld   hl,(player_logical_address_6009)
F30C: 3E 24       ld   a,$24
F30E: 32 7B 62    ld   (unknown_627B),a
F311: FD 7E 02    ld   a,(iy+$02)
F314: C5          push bc
F315: 47          ld   b,a
F316: 3A 0D 60    ld   a,(player_screen_600D)
F319: B8          cp   b
F31A: C1          pop  bc
F31B: C2 35 F3    jp   nz,$F335
F31E: FD 56 01    ld   d,(iy+$01)
F321: FD 5E 00    ld   e,(iy+$00)
F324: 13          inc  de
F325: 13          inc  de
F326: CD 7B F4    call compute_backbuffer_tile_address_F47B
F329: AF          xor  a
F32A: E5          push hl
F32B: ED 52       sbc  hl,de
F32D: E1          pop  hl
F32E: 28 13       jr   z,$F343
F330: CD 0B D0    call $D00B
F333: 28 0E       jr   z,$F343
F335: FD 23       inc  iy
F337: FD 23       inc  iy
F339: FD 23       inc  iy
F33B: 3E 20       ld   a,$20
F33D: 32 7B 62    ld   (unknown_627B),a
F340: 10 CF       djnz $F311
F342: C9          ret
F343: CD E3 F4    call test_pickup_flag_F4E3
F346: 78          ld   a,b
F347: FE 00       cp   $00
F349: C8          ret  z
F34A: 3A CF 61    ld   a,(has_pick_61CF)
F34D: FE 00       cp   $00
F34F: 28 1F       jr   z,$F370
F351: FD E5       push iy
F353: E5          push hl
F354: 01 CF 61    ld   bc,has_pick_61CF
F357: FD 21 CC 61 ld   iy,current_pickaxe_screen_params_61CC
F35B: 3E 38       ld   a,$38
F35D: FD 77 04    ld   (iy+$04),a
F360: 3E 28       ld   a,$28
F362: FD 77 05    ld   (iy+$05),a
F365: 3E E4       ld   a,$E4
F367: 32 D2 61    ld   (unknown_61D2),a
F36A: CD 55 FC    call drop_object_FC55
F36D: E1          pop  hl
F36E: FD E1       pop  iy
F370: DD 21 80 65 ld   ix,player_struct_6580
F374: 3A 41 63    ld   a,(unknown_6341)
F377: FE 01       cp   $01
F379: 20 1A       jr   nz,$F395
F37B: 3E 31       ld   a,$31
F37D: DD 77 1C    ld   (ix+$1c),a
F380: 3E 24       ld   a,$24
F382: DD 77 1D    ld   (ix+$1d),a
F385: DD 7E 03    ld   a,(ix+$03)
F388: DD 77 1F    ld   (ix+$1f),a
F38B: DD 7E 02    ld   a,(ix+$02)
F38E: D6 08       sub  $08
F390: DD 77 1E    ld   (ix+$1e),a
F393: 18 19       jr   $F3AE
F395: 3E 3F       ld   a,$3F
F397: DD 77 1C    ld   (ix+$1c),a
F39A: 3A 7B 62    ld   a,(unknown_627B)
F39D: DD 77 1D    ld   (ix+$1d),a
F3A0: DD 7E 03    ld   a,(ix+$03)
F3A3: DD 77 1F    ld   (ix+$1f),a
F3A6: DD 7E 02    ld   a,(ix+$02)
F3A9: D6 08       sub  $08
F3AB: DD 77 1E    ld   (ix+$1e),a
F3AE: CD D9 D4    call can_pick_bag_D4D9
F3B1: 20 0A       jr   nz,$F3BD
F3B3: 21 A8 5B    ld   hl,$5BA8
F3B6: 22 40 61    ld   (ay_sound_pointer_6140),hl
F3B9: AF          xor  a
F3BA: 32 42 61    ld   (ay_sound_start_6142),a
F3BD: 3E 01       ld   a,$01
F3BF: 32 58 61    ld   (has_bag_6158),a
F3C2: FD 22 5C 61 ld   (unknown_pointer_615C),iy
F3C6: FD 66 01    ld   h,(iy+$01)
F3C9: FD 6E 00    ld   l,(iy+$00)
F3CC: 22 F6 61    ld   (picked_up_object_screen_address_61F6),hl
F3CF: AF          xor  a
F3D0: 32 7E 62    ld   (unknown_627E),a
F3D3: F3          di
F3D4: FD 77 00    ld   (iy+$00),a
F3D7: FD 77 01    ld   (iy+$01),a
F3DA: FD 77 02    ld   (iy+$02),a
F3DD: FB          ei
F3DE: 3A 7B 62    ld   a,(unknown_627B)
F3E1: FE 24       cp   $24
F3E3: 3E 00       ld   a,$00
F3E5: 20 02       jr   nz,$F3E9
F3E7: 3E 01       ld   a,$01
F3E9: 32 7C 62    ld   (player_has_blue_bag_flag_627C),a
F3EC: C9          ret
F3ED: 3A 7E 62    ld   a,(unknown_627E)
F3F0: FE 07       cp   $07
F3F2: D0          ret  nc
F3F3: 2A F6 61    ld   hl,(picked_up_object_screen_address_61F6)
F3F6: 7C          ld   a,h
F3F7: FE 00       cp   $00
F3F9: C8          ret  z
F3FA: 7D          ld   a,l
F3FB: E6 1F       and  $1F
F3FD: FE 00       cp   $00
F3FF: C8          ret  z
F400: CD 65 F4    call restore_background_tile_F465
F403: CD 3B F4    call color_background_tile_F43B
F406: 23          inc  hl
F407: CD 65 F4    call restore_background_tile_F465
F40A: CD 3B F4    call color_background_tile_F43B
F40D: 11 20 00    ld   de,$0020
F410: 19          add  hl,de
F411: CD 65 F4    call restore_background_tile_F465
F414: CD 3B F4    call color_background_tile_F43B
F417: 2B          dec  hl
F418: CD 65 F4    call restore_background_tile_F465
F41B: CD 3B F4    call color_background_tile_F43B
F41E: 3A 7E 62    ld   a,(unknown_627E)
F421: 3C          inc  a
F422: 32 7E 62    ld   (unknown_627E),a
F425: 3A 0D 60    ld   a,(player_screen_600D)
F428: FE 05       cp   $05
F42A: CC 4D CE    call z,switch_to_screen_5_CE4D
F42D: C9          ret
check_for_not_moving_timeout_F42E:
F42E: DD 7E 00    ld   a,(ix+$00)
F431: FE 01       cp   $01
F433: C8          ret  z
F434: 7E          ld   a,(hl)
F435: FE F0       cp   $F0
F437: D8          ret  c
F438: AF          xor  a
F439: 12          ld   (de),a
F43A: C9          ret
color_background_tile_F43B:
F43B: 06 1F       ld   b,$1F
F43D: 7E          ld   a,(hl)
F43E: FE 49       cp   $49
F440: 28 16       jr   z,$F458
F442: FE 4A       cp   $4A
F444: 28 12       jr   z,$F458
F446: FE 4B       cp   $4B
F448: 28 0E       jr   z,$F458
F44A: FE 51       cp   $51
F44C: 28 13       jr   z,$F461
F44E: FE 52       cp   $52
F450: 28 0F       jr   z,$F461
F452: FE 57       cp   $57
F454: 28 0B       jr   z,$F461
F456: 06 3F       ld   b,$3F
F458: E5          push hl
F459: 7C          ld   a,h
F45A: C6 08       add  a,$08
F45C: 67          ld   h,a
F45D: 78          ld   a,b
F45E: 77          ld   (hl),a
F45F: E1          pop  hl
F460: C9          ret
F461: 06 32       ld   b,$32
F463: 18 F3       jr   $F458

restore_background_tile_F465:
F465: 7C          ld   a,h
F466: 57          ld   d,a
F467: 7D          ld   a,l
F468: 5F          ld   e,a
F469: CD 7B F4    call compute_backbuffer_tile_address_F47B
; copy tile data back to screen
F46C: 1A          ld   a,(de)
F46D: 77          ld   (hl),a
; loop until write succeeds...
; maybe video ram has issues?
F46E: 1A          ld   a,(de)
F46F: BE          cp   (hl)
F470: 20 FA       jr   nz,$F46C
F472: E5          push hl
F473: 7C          ld   a,h
F474: C6 08       add  a,$08
F476: 67          ld   h,a
F477: AF          xor  a
F478: 77          ld   (hl),a
F479: E1          pop  hl
F47A: C9          ret
compute_backbuffer_tile_address_F47B:
F47B: 3A 0D 60    ld   a,(player_screen_600D)
F47E: FE 01       cp   $01
F480: 20 05       jr   nz,$F487
F482: 7A          ld   a,d
F483: D6 50       sub  $50
F485: 57          ld   d,a
F486: C9          ret
F487: FE 02       cp   $02
F489: 20 05       jr   nz,$F490
F48B: 7A          ld   a,d
F48C: D6 4C       sub  $4C
F48E: 57          ld   d,a
F48F: C9          ret
F490: FE 03       cp   $03
F492: 20 05       jr   nz,$F499
F494: 7A          ld   a,d
F495: D6 48       sub  $48
F497: 57          ld   d,a
F498: C9          ret
F499: FE 04       cp   $04
F49B: 20 05       jr   nz,$F4A2
F49D: 7A          ld   a,d
F49E: D6 60       sub  $60
F4A0: 57          ld   d,a
F4A1: C9          ret
F4A2: 7A          ld   a,d
F4A3: D6 5C       sub  $5C
F4A5: 57          ld   d,a
F4A6: C9          ret
F4A7: 3A 59 61    ld   a,(bag_falling_6159)
F4AA: FE 01       cp   $01
F4AC: C8          ret  z
F4AD: 3A 9E 65    ld   a,(sprite_object_x_659E)
F4B0: FE E0       cp   $E0
F4B2: D0          ret  nc
F4B3: FE 18       cp   $18
F4B5: D8          ret  c
F4B6: CD E3 F4    call test_pickup_flag_F4E3
F4B9: 78          ld   a,b
F4BA: FE 00       cp   $00
F4BC: C8          ret  z
F4BD: DD 21 9C 65 ld   ix,object_held_struct_659C
F4C1: FD 21 5A 61 ld   iy,unknown_615A
F4C5: 3A 0D 60    ld   a,(player_screen_600D)
F4C8: 32 98 60    ld   (current_guard_screen_index_6098),a
F4CB: CD EF EA    call compute_logical_address_from_xy_EAEF
F4CE: FB          ei
F4CF: 2B          dec  hl
F4D0: 7E          ld   a,(hl)
F4D1: E5          push hl
F4D2: CD F2 F4    call $F4F2
F4D5: E1          pop  hl
F4D6: C0          ret  nz
F4D7: AF          xor  a
F4D8: 32 58 61    ld   (has_bag_6158),a
F4DB: 32 7C 62    ld   (player_has_blue_bag_flag_627C),a
F4DE: 3C          inc  a
F4DF: 32 59 61    ld   (bag_falling_6159),a
F4E2: C9          ret

test_pickup_flag_F4E3:
F4E3: 06 00       ld   b,$00
F4E5: 3A 60 61    ld   a,(pickup_flag_6160)
F4E8: FE 00       cp   $00
F4EA: C8          ret  z
F4EB: AF          xor  a
F4EC: 32 60 61    ld   (pickup_flag_6160),a
F4EF: 06 01       ld   b,$01
F4F1: C9          ret
F4F2: 21 84 23    ld   hl,$2384
F4F5: 01 13 00    ld   bc,$0013
F4F8: F5          push af
F4F9: 3A 41 63    ld   a,(unknown_6341)
F4FC: FE 01       cp   $01
F4FE: CB 1B       rr   e
F500: F1          pop  af
F501: CB 13       rl   e
F503: 38 03       jr   c,$F508
F505: 01 15 00    ld   bc,$0015
F508: ED B9       cpdr
F50A: C9          ret
	;; < $6095:	pointer on direction ($6027/$6067)
	;; < de:	guard screen address
	;; < $6098:	guard screen index
	;; < ix:	6035 or 6057 guard ????? what????
	;; < iy:	guard struct
analyse_guard_direction_change_F50B:
F50B: FD E5       push iy
F50D: CD 18 19    call $1918
	;; loop to look for branches (ladders, etc)
F510: FD 7E 00    ld   a,(iy+$00)
F513: 67          ld   h,a
F514: FD 7E 01    ld   a,(iy+$01)
F517: 6F          ld   l,a
F518: AF          xor  a
F519: ED 52       sbc  hl,de	; get address distance between guard and
F51B: 28 17       jr   z,$F534
F51D: FD 23       inc  iy
F51F: FD 23       inc  iy
F521: FD 23       inc  iy
F523: 3A 00 B8    ld   a,(io_read_shit_B800)
F526: FD 7E 02    ld   a,(iy+$02)
F529: FE FF       cp   $FF
F52B: 20 E3       jr   nz,$F510
F52D: AF          xor  a
F52E: DD 77 11    ld   (ix+$11),a
F531: FD E1       pop  iy
F533: C9          ret
	;; branch found:	what do we decide??
F534: DD E5       push ix
F536: FD 22 4B 60 ld   (unknown_pointer_604B),iy
F53A: 3A 98 60    ld   a,(current_guard_screen_index_6098)
F53D: 47          ld   b,a
F53E: 3A 0D 60    ld   a,(player_screen_600D)
F541: B8          cp   b
F542: 28 03       jr   z,$F547
F544: CD 3A 19    call guide_guard_on_hidden_screen_193A
F547: 06 08       ld   b,$08
F549: DD 7E 11    ld   a,(ix+$11)
F54C: FE 01       cp   $01
F54E: CA 44 F6    jp   z,$F644
F551: DD 7E 07    ld   a,(ix+$07)
F554: FE 00       cp   $00
F556: C2 44 F6    jp   nz,$F644
F559: DD 23       inc  ix
F55B: 10 F4       djnz $F551
F55D: DD E1       pop  ix
F55F: AF          xor  a
F560: DD 77 15    ld   (ix+$15),a
F563: 3A 47 60    ld   a,(player_just_moved_flag_6047)
F566: FE 00       cp   $00
F568: CA 95 F5    jp   z,$F595
F56B: 3A 82 65    ld   a,(player_x_6582)
F56E: 47          ld   b,a
F56F: FD E1       pop  iy
F571: FD 7E 02    ld   a,(iy+$02)
F574: FD E5       push iy
F576: B8          cp   b
F577: F5          push af
F578: D4 49 F6    call nc,guard_goes_left_F649
F57B: F1          pop  af
F57C: DC 52 F6    call c,guard_goes_right_F652
F57F: 3A 83 65    ld   a,(player_y_6583)
F582: 47          ld   b,a
F583: FD E1       pop  iy
F585: FD 7E 03    ld   a,(iy+$03)
F588: FD E5       push iy
F58A: B8          cp   b
F58B: F5          push af
F58C: DC 64 F6    call c,guard_goes_down_F664
F58F: F1          pop  af
F590: D4 5B F6    call nc,guard_goes_up_F65B
F593: 18 58       jr   $F5ED
F595: 3A 00 A0    ld   a,(interrupt_control_A000)
F598: E5          push hl
F599: 21 85 23    ld   hl,direction_index_table_2385
F59C: E6 03       and  $03	; random 0 1 2 3
F59E: 85          add  a,l
F59F: 6F          ld   l,a
F5A0: 7C          ld   a,h
F5A1: CE 00       adc  a,$00
F5A3: 67          ld   h,a
F5A4: 3A 00 B8    ld   a,(io_read_shit_B800)
F5A7: 7E          ld   a,(hl)	; turns to random 8 4 2 1 thanks to table @2385
F5A8: C5          push bc
F5A9: DD E5       push ix
F5AB: DD 2A 95 60 ld   ix,(guard_direction_pointer_6095)
F5AF: 47          ld   b,a	;  set 8 4 2 1 value to b
F5B0: DD 7E 00    ld   a,(ix+$00) ; guard direction
F5B3: CB 0F       rrc  a
F5B5: CB 0F       rrc  a
F5B7: CB 0F       rrc  a
F5B9: CB 0F       rrc  a
F5BB: E6 0F       and  $0F
F5BD: FE 01       cp   $01
F5BF: 20 04       jr   nz,$F5C5
F5C1: 3E 02       ld   a,$02
F5C3: 18 16       jr   $F5DB
F5C5: FE 02       cp   $02
F5C7: 20 04       jr   nz,$F5CD
F5C9: 3E 01       ld   a,$01
F5CB: 18 0E       jr   $F5DB
F5CD: FE 04       cp   $04
F5CF: 20 04       jr   nz,$F5D5
F5D1: 3E 08       ld   a,$08
F5D3: 18 06       jr   $F5DB
F5D5: FE 08       cp   $08
F5D7: 20 02       jr   nz,$F5DB
F5D9: 3E 04       ld   a,$04
F5DB: B8          cp   b
F5DC: 20 07       jr   nz,$F5E5 ; ok:	 random did not give the opposite
F5DE: DD E1       pop  ix
F5E0: C1          pop  bc
F5E1: E1          pop  hl
F5E2: C3 95 F5    jp   $F595	; retry until random gives something else than the opposite
F5E5: DD E1       pop  ix
F5E7: 78          ld   a,b
F5E8: C1          pop  bc
F5E9: E1          pop  hl
F5EA: DD 77 15    ld   (ix+$15),a ;  save a
F5ED: AF          xor  a
F5EE: FD 2A 4B 60 ld   iy,(unknown_pointer_604B)
F5F2: FD 7E 02    ld   a,(iy+$02)
F5F5: CB 0F       rrc  a
F5F7: CB 0F       rrc  a
F5F9: CB 0F       rrc  a
F5FB: CB 0F       rrc  a
F5FD: 47          ld   b,a
F5FE: DD 7E 15    ld   a,(ix+$15) ;  restore a
F601: A0          and  b
F602: CB 0F       rrc  a
F604: 2A 91 60    ld   hl,(guard_logical_address_6091)
F607: 32 44 60    ld   (stored_logical_address_6044),a
F60A: FD 21 94 65 ld   iy,guard_1_struct_6594
F60E: FD 22 93 60 ld   (guard_struct_pointer_6093),iy
F612: 2A 95 60    ld   hl,(guard_direction_pointer_6095) ; contains guard direction pointer unknown_6027 or unknown_6067
F615: 30 05       jr   nc,$F61C
F617: CD E8 F6    call set_guard_direction_up_F6E8
F61A: 18 20       jr   $F63C
F61C: CB 0F       rrc  a
F61E: 30 05       jr   nc,$F625
F620: CD DE F6    call set_guard_direction_down_F6DE
F623: 18 17       jr   $F63C
F625: CB 0F       rrc  a
F627: 30 05       jr   nc,$F62E
F629: CD C0 F6    call set_guard_direction_left_F6C0
F62C: 18 07       jr   $F635
F62E: CB 0F       rrc  a
F630: 30 0A       jr   nc,$F63C
F632: CD A2 F6    call set_guard_direction_right_F6A2
F635: 3A 0B 60    ld   a,(way_clear_flag_600B)
F638: FE 02       cp   $02
F63A: 20 05       jr   nz,$F641
F63C: 3E 01       ld   a,$01
F63E: DD 77 11    ld   (ix+$11),a
F641: FD E1       pop  iy
F643: C9          ret
F644: DD E1       pop  ix
F646: FD E1       pop  iy
F648: C9          ret
guard_goes_left_F649:
F649: DD 7E 15    ld   a,(ix+$15)
F64C: F6 04       or   $04
F64E: DD 77 15    ld   (ix+$15),a
F651: C9          ret
F652: DD 7E 15    ld   a,(ix+$15)
F655: F6 08       or   $08
F657: DD 77 15    ld   (ix+$15),a
F65A: C9          ret
F65B: DD 7E 15    ld   a,(ix+$15)
F65E: F6 01       or   $01
F660: DD 77 15    ld   (ix+$15),a
F663: C9          ret
F664: DD 7E 15    ld   a,(ix+$15)
F667: F6 02       or   $02
F669: DD 77 15    ld   (ix+$15),a
F66C: C9          ret
F66D: 2A 38 60    ld   hl,(guard_1_logical_address_6038)
F670: 22 91 60    ld   (guard_logical_address_6091),hl
F673: FD 21 94 65 ld   iy,guard_1_struct_6594
F677: FD 22 93 60 ld   (guard_struct_pointer_6093),iy
F67B: 21 27 60    ld   hl,guard_1_direction_6027
F67E: 22 95 60    ld   (guard_direction_pointer_6095),hl
F681: 3A 3C 60    ld   a,(guard_1_sees_player_right_603C)
F684: FE 00       cp   $00
F686: C4 A2 F6    call nz,set_guard_direction_right_F6A2
F689: 3A 3D 60    ld   a,(guard_1_sees_player_left_603D)
F68C: FE 00       cp   $00
F68E: C4 C0 F6    call nz,set_guard_direction_left_F6C0
F691: 3A 3E 60    ld   a,(guard_1_sees_player_up_603E)
F694: FE 00       cp   $00
F696: C4 E8 F6    call nz,set_guard_direction_up_F6E8
F699: 3A 3F 60    ld   a,(guard_1_sees_player_down_603F)
F69C: FE 00       cp   $00
F69E: C4 DE F6    call nz,set_guard_direction_down_F6DE
F6A1: C9          ret
set_guard_direction_right_F6A2:
F6A2: 2A 91 60    ld   hl,(guard_logical_address_6091)
F6A5: DD E5       push ix
F6A7: DD 2A 93 60 ld   ix,(guard_struct_pointer_6093)
F6AB: CD 71 0D    call character_can_walk_right_0D71
F6AE: DD E1       pop  ix
F6B0: 3A 0B 60    ld   a,(way_clear_flag_600B)
F6B3: FE 02       cp   $02
F6B5: C0          ret  nz
F6B6: E5          push hl
F6B7: 2A 95 60    ld   hl,(guard_direction_pointer_6095)
F6BA: AF          xor  a
F6BB: CB FF       set  7,a
F6BD: 77          ld   (hl),a
F6BE: E1          pop  hl
F6BF: C9          ret
set_guard_direction_left_F6C0:
F6C0: 2A 91 60    ld   hl,(guard_logical_address_6091)
F6C3: DD E5       push ix
F6C5: DD 2A 93 60 ld   ix,(guard_struct_pointer_6093)
F6C9: CD CC 0D    call character_can_walk_left_0DCC
F6CC: DD E1       pop  ix
F6CE: 3A 0B 60    ld   a,(way_clear_flag_600B)
F6D1: FE 02       cp   $02
F6D3: C0          ret  nz
F6D4: E5          push hl
F6D5: 2A 95 60    ld   hl,(guard_direction_pointer_6095)
F6D8: AF          xor  a
F6D9: CB F7       set  6,a
F6DB: 77          ld   (hl),a
F6DC: E1          pop  hl
F6DD: C9          ret
set_guard_direction_down_F6DE:
F6DE: AF          xor  a
F6DF: E5          push hl
F6E0: 2A 95 60    ld   hl,(guard_direction_pointer_6095)
F6E3: CB EF       set  5,a	; set direction to down
F6E5: 77          ld   (hl),a
F6E6: E1          pop  hl
F6E7: C9          ret
set_guard_direction_up_F6E8:
F6E8: AF          xor  a
F6E9: E5          push hl
F6EA: 2A 95 60    ld   hl,(guard_direction_pointer_6095)
F6ED: CB E7       set  4,a
F6EF: 77          ld   (hl),a
F6F0: E1          pop  hl
F6F1: C9          ret
handle_guard_1_views_player_F6F2:
F6F2: 3A 0D 60    ld   a,(player_screen_600D)
F6F5: 47          ld   b,a
F6F6: 3A 99 60    ld   a,(guard_1_screen_6099)
F6F9: B8          cp   b
F6FA: C0          ret  nz
F6FB: DD 21 3D 60 ld   ix,guard_1_sees_player_left_603D
F6FF: 2A 38 60    ld   hl,(guard_1_logical_address_6038)
F702: 01 E0 FF    ld   bc,$FFE0
F705: 3A CF 61    ld   a,(has_pick_61CF)
F708: FE 00       cp   $00
F70A: 3E 40       ld   a,$40
F70C: 20 06       jr   nz,$F714
F70E: DD 21 3C 60 ld   ix,guard_1_sees_player_right_603C
F712: 3E 80       ld   a,$80
F714: 08          ex   af,af'
F715: CD F5 F7    call is_way_clear_to_player_F7F5
F718: 2A 38 60    ld   hl,(guard_1_logical_address_6038)
F71B: DD 21 3C 60 ld   ix,guard_1_sees_player_right_603C
F71F: 01 20 00    ld   bc,$0020
F722: 3A CF 61    ld   a,(has_pick_61CF)
F725: FE 00       cp   $00
F727: 3E 80       ld   a,$80
F729: 20 06       jr   nz,$F731
F72B: DD 21 3D 60 ld   ix,guard_1_sees_player_left_603D
F72F: 3E 40       ld   a,$40
F731: 08          ex   af,af'
F732: CD F5 F7    call is_way_clear_to_player_F7F5
F735: 2A 38 60    ld   hl,(guard_1_logical_address_6038)
F738: 01 FF FF    ld   bc,$FFFF
F73B: 3E 10       ld   a,$10
F73D: 08          ex   af,af'
F73E: DD 21 3E 60 ld   ix,guard_1_sees_player_up_603E
F742: CD F5 F7    call is_way_clear_to_player_F7F5
F745: 2A 38 60    ld   hl,(guard_1_logical_address_6038)
F748: DD 21 3F 60 ld   ix,guard_1_sees_player_down_603F
F74C: 01 01 00    ld   bc,$0001
F74F: 3E 20       ld   a,$20
F751: 08          ex   af,af'
F752: CD F5 F7    call is_way_clear_to_player_F7F5
F755: C9          ret
F756: 2A 78 60    ld   hl,(guard_2_logical_address_6078)
F759: 22 91 60    ld   (guard_logical_address_6091),hl
F75C: FD 21 98 65 ld   iy,guard_2_struct_6598
F760: FD 22 93 60 ld   (guard_struct_pointer_6093),iy
F764: 21 67 60    ld   hl,guard_2_direction_6067
F767: 22 95 60    ld   (guard_direction_pointer_6095),hl
F76A: 3A 7C 60    ld   a,(guard_2_sees_player_right_607C)
F76D: FE 00       cp   $00
F76F: C4 A2 F6    call nz,set_guard_direction_right_F6A2
F772: 3A 7D 60    ld   a,(guard_2_sees_player_left_607D)
F775: FE 00       cp   $00
F777: C4 C0 F6    call nz,set_guard_direction_left_F6C0
F77A: 3A 7E 60    ld   a,(guard_2_sees_player_up_607E)
F77D: FE 00       cp   $00
F77F: C4 E8 F6    call nz,set_guard_direction_up_F6E8
F782: 3A 7F 60    ld   a,(guard_2_sees_player_down_607F)
F785: FE 00       cp   $00
F787: C4 DE F6    call nz,set_guard_direction_down_F6DE
F78A: C9          ret
handle_guard_2_views_player_F78B:
F78B: 3A 0D 60    ld   a,(player_screen_600D)
F78E: 47          ld   b,a
F78F: 3A 9A 60    ld   a,(guard_2_screen_609A)
F792: B8          cp   b
F793: C0          ret  nz
F794: DD 21 7D 60 ld   ix,guard_2_sees_player_left_607D
F798: 2A 78 60    ld   hl,(guard_2_logical_address_6078)
F79B: 01 E0 FF    ld   bc,$FFE0
;; if player has pick reverts tests:	 if sees on the right, actually
;;  pretend he saw him on the left
F79E: 3A CF 61    ld   a,(has_pick_61CF)
F7A1: FE 00       cp   $00
F7A3: 3E 40       ld   a,$40
F7A5: 20 06       jr   nz,$F7AD
F7A7: DD 21 7C 60 ld   ix,guard_2_sees_player_right_607C
F7AB: 3E 80       ld   a,$80
F7AD: 08          ex   af,af'
F7AE: CD F5 F7    call is_way_clear_to_player_F7F5
F7B1: 2A 78 60    ld   hl,(guard_2_logical_address_6078)
F7B4: 01 20 00    ld   bc,$0020
F7B7: DD 21 7C 60 ld   ix,guard_2_sees_player_right_607C
;; if player has pick reverts tests:	 if sees on the left, actually
;;  pretend he saw him on the right
F7BB: 3A CF 61    ld   a,(has_pick_61CF)
F7BE: FE 00       cp   $00
; protection??? reads video memory stores is somewhere
F7C0: 3A B2 91    ld   a,($91B2)
F7C3: 32 72 62    ld   (unknown_6272),a
; protection ends
F7C6: 3E 80       ld   a,$80
F7C8: 20 06       jr   nz,$F7D0
F7CA: DD 21 7D 60 ld   ix,guard_2_sees_player_left_607D
F7CE: 3E 40       ld   a,$40
F7D0: 08          ex   af,af'
F7D1: CD F5 F7    call is_way_clear_to_player_F7F5
	;; up and down (note that having the pick has no effect on those tests)
F7D4: 2A 78 60    ld   hl,(guard_2_logical_address_6078)
F7D7: 01 FF FF    ld   bc,$FFFF
F7DA: 3E 10       ld   a,$10
F7DC: 08          ex   af,af'
F7DD: DD 21 7E 60 ld   ix,guard_2_sees_player_up_607E
F7E1: CD F5 F7    call is_way_clear_to_player_F7F5
F7E4: 2A 78 60    ld   hl,(guard_2_logical_address_6078)
F7E7: DD 21 7F 60 ld   ix,guard_2_sees_player_down_607F
F7EB: 01 01 00    ld   bc,$0001
F7EE: 3E 20       ld   a,$20
F7F0: 08          ex   af,af'
F7F1: CD F5 F7    call is_way_clear_to_player_F7F5
F7F4: C9          ret
;;; test if there's something blocking the view from guard to player
;;; works for all directions (up,down,left,right)
;;;
;;; params:
;;; a':	direction value to set if test works ($40:to left, $80:to right, $10:up, $20:down)
;;; ix: store a or 0 in (ix)
;;; hl: screen address
;;; bc: direction increment (1:	down, -1: up, 32: right, -32: left)
is_way_clear_to_player_F7F5:
F7F5: 2B          dec  hl
F7F6: 2B          dec  hl
F7F7: AF          xor  a
F7F8: DD 77 00    ld   (ix+$00),a
F7FB: ED 4A       adc  hl,bc
F7FD: 7E          ld   a,(hl)
F7FE: C5          push bc
F7FF: 06 15       ld   b,$15
F801: FD 21 89 23 ld   iy,$2389
F805: FD BE 00    cp   (iy+$00)
F808: 28 06       jr   z,$F810
F80A: FD 23       inc  iy
F80C: 10 F7       djnz $F805
F80E: C1          pop  bc
F80F: C9          ret
F810: C1          pop  bc
F811: E5          push hl
F812: ED 5B 09 60 ld   de,(player_logical_address_6009)
F816: 1B          dec  de
F817: 1B          dec  de
F818: AF          xor  a
F819: ED 52       sbc  hl,de
F81B: E1          pop  hl
F81C: 28 0A       jr   z,$F828
F81E: E5          push hl
F81F: 13          inc  de
F820: AF          xor  a
F821: ED 52       sbc  hl,de
F823: E1          pop  hl
F824: 28 02       jr   z,$F828
F826: 18 CF       jr   $F7F7
F828: 08          ex   af,af'
F829: DD 77 00    ld   (ix+$00),a
F82C: C9          ret
F82D: 3A 29 60    ld   a,(player_in_wagon_flag_6029)
F830: FE 01       cp   $01
F832: 28 08       jr   z,$F83C
F834: 3A 25 60    ld   a,(player_death_flag_6025)
F837: FE 01       cp   $01
F839: CA E1 F9    jp   z,player_dies_F9E1
F83C: AF          xor  a
F83D: C9          ret
wagon_player_collision_F83E:
F83E: 3A 25 60    ld   a,(player_death_flag_6025)
F841: FE 01       cp   $01
F843: C8          ret  z		; return immediately if player dies
F844: 3A 29 60    ld   a,(player_in_wagon_flag_6029)
F847: FE 01       cp   $01
F849: C8          ret  z
F84A: DD 21 82 65 ld   ix,player_x_6582
F84E: FD 21 8A 65 ld   iy,wagon_data_658A
F852: 21 22 60    ld   hl,unknown_6022
F855: 11 04 00    ld   de,$0004
F858: 3A 2A 60    ld   a,(player_gripping_handle_602A)
F85B: FE 01       cp   $01
F85D: C8          ret  z
F85E: CD 62 F8    call $F862
F861: C9          ret
F862: FD 7E 01    ld   a,(iy+$01)
F865: D6 04       sub  $04
F867: DD BE 01    cp   (ix+$01)
F86A: D0          ret  nc
F86B: FD 7E 01    ld   a,(iy+$01)
F86E: C6 0E       add  a,$0E
F870: DD BE 01    cp   (ix+$01)
F873: D8          ret  c
F874: FD 7E 00    ld   a,(iy+$00)
F877: D6 0D       sub  $0D
F879: 47          ld   b,a
F87A: C6 04       add  a,$04
F87C: 4F          ld   c,a
F87D: CD 96 F8    call $F896
F880: 32 25 60    ld   (player_death_flag_6025),a
F883: FE 01       cp   $01
F885: C8          ret  z
F886: FD 7E 00    ld   a,(iy+$00)
F889: C6 0A       add  a,$0A
F88B: 47          ld   b,a
F88C: C6 04       add  a,$04
F88E: 4F          ld   c,a
F88F: CD 96 F8    call $F896
F892: 32 25 60    ld   (player_death_flag_6025),a
F895: C9          ret
F896: DD 7E 00    ld   a,(ix+$00)
F899: B8          cp   b
F89A: 38 06       jr   c,$F8A2
F89C: B9          cp   c
F89D: 30 03       jr   nc,$F8A2
F89F: 3E 01       ld   a,$01
F8A1: C9          ret
F8A2: AF          xor  a
F8A3: C9          ret
; display PLAYER 1
display_player_ids_and_credit_F8A4:
F8A4: 11 80 56    ld   de,$5680
F8A7: 21 A0 93    ld   hl,$93A0
F8AA: CD 67 CA    call display_localized_text_CA67
; display PLAYER 1 again
F8AD: 11 80 56    ld   de,$5680
F8B0: 21 20 91    ld   hl,$9120
; display BONUS
F8B3: CD 67 CA    call display_localized_text_CA67
F8B6: 11 05 57    ld   de,$5705
F8B9: 21 40 92    ld   hl,$9240
F8BC: CD 67 CA    call display_localized_text_CA67
F8BF: 3E 02       ld   a,$02
F8C1: 21 40 90    ld   hl,$9040
F8C4: 77          ld   (hl),a
F8C5: 11 89 56    ld   de,$5689
F8C8: 21 9F 91    ld   hl,$919F
F8CB: CD 67 CA    call display_localized_text_CA67
* credit digits seems useless: wrong and overwritten
* by the real value read from number_of_credits_6000
F8CE: 3A 04 60    ld   a,(fake_credit_digit_6004)
F8D1: 32 9F 90    ld   ($909F),a
F8D4: 3A 05 60    ld   a,(fake_credit_digit_6005)
F8D7: 32 BF 90    ld   ($90BF),a
F8DA: CD DE F8    call $F8DE
F8DD: C9          ret
F8DE: 3E 02       ld   a,$02
F8E0: 21 40 98    ld   hl,$9840
F8E3: CD 05 56    call write_attribute_on_line_5605
F8E6: 3E 08       ld   a,$08
F8E8: 21 5F 98    ld   hl,$985F
F8EB: CD 05 56    call write_attribute_on_line_5605
F8EE: 3E 05       ld   a,$05
F8F0: 21 41 98    ld   hl,$9841
F8F3: CD 05 56    call write_attribute_on_line_5605
F8F6: C9          ret
F8F7: 3A 4D 60    ld   a,(fall_height_604D)
F8FA: FE 12       cp   $12
F8FC: 38 25       jr   c,$F923
F8FE: 3E 01       ld   a,$01
F900: 32 4E 60    ld   (fatal_fall_height_reached_604E),a
F903: 2A 09 60    ld   hl,(player_logical_address_6009)
F906: 7E          ld   a,(hl)
F907: FE F8       cp   $F8
F909: E5          push hl
F90A: 21 A7 23    ld   hl,$23A7
F90D: 01 0A 00    ld   bc,$000A
F910: ED B9       cpdr
F912: E1          pop  hl
F913: 20 10       jr   nz,$F925
F915: 3A 14 60    ld   a,(unknown_6014)
F918: FE 01       cp   $01
F91A: 28 11       jr   z,$F92D
F91C: 3A E5 62    ld   a,(unknown_62E5)
F91F: FE 01       cp   $01
F921: 28 0A       jr   z,$F92D
F923: AF          xor  a
F924: C9          ret
F925: 3A 83 65    ld   a,(player_y_6583)
F928: D6 02       sub  $02
F92A: 32 83 65    ld   (player_y_6583),a
F92D: AF          xor  a
F92E: 32 08 60    ld   (unknown_6008),a
F931: CD E1 F9    call player_dies_F9E1
F934: 3E 01       ld   a,$01
F936: C9          ret
F937: 3A 54 60    ld   a,(gameplay_allowed_6054)
F93A: FE 01       cp   $01
F93C: 28 0C       jr   z,$F94A
F93E: 3A 00 60    ld   a,(number_of_credits_6000)
F941: FE 00       cp   $00
F943: 28 06       jr   z,$F94B
F945: 3E 01       ld   a,$01
F947: 32 53 60    ld   (game_locked_6053),a
F94A: C9          ret
F94B: 3E 00       ld   a,$00
F94D: 32 53 60    ld   (game_locked_6053),a
F950: C9          ret

init_new_game_F951:
F951: 21 60 5B    ld   hl,$5B60
F954: 22 40 61    ld   (ay_sound_pointer_6140),hl
F957: AF          xor  a
F958: 32 42 61    ld   (ay_sound_start_6142),a
F95B: CD E7 D4    call $D4E7
F95E: 20 0D       jr   nz,$F96D
F960: 21 68 3B    ld   hl,$3B68
F963: 22 40 61    ld   (ay_sound_pointer_6140),hl
F966: AF          xor  a
F967: 32 42 61    ld   (ay_sound_start_6142),a
F96A: 32 48 63    ld   (unknown_6348),a
F96D: AF          xor  a
F96E: 32 03 A0    ld   ($A003),a
F971: CD C9 C2    call display_maze_C2C9
F974: 3E 01       ld   a,$01
F976: 32 16 60    ld   (wagon_direction_array_6016),a
F979: CD A4 F8    call display_player_ids_and_credit_F8A4
F97C: 3E 01       ld   a,$01
F97E: 32 0D 60    ld   (player_screen_600D),a
F981: 32 03 A0    ld   ($A003),a
F984: 3E 20       ld   a,$20
F986: 21 80 65    ld   hl,player_struct_6580
F989: 77          ld   (hl),a
F98A: 23          inc  hl
F98B: 3E 08       ld   a,$08
F98D: 77          ld   (hl),a
F98E: 23          inc  hl
F98F: 3E 29       ld   a,$29
F991: 77          ld   (hl),a
F992: 23          inc  hl
F993: 3E D8       ld   a,$D8
F995: 77          ld   (hl),a
F996: 32 29 60    ld   (player_in_wagon_flag_6029),a
F999: 3E 40       ld   a,$40
F99B: 32 65 61    ld   (unknown_6165),a
F99E: 3E C8       ld   a,$C8
F9A0: 32 66 61    ld   (unknown_6166),a
F9A3: 11 C7 61    ld   de,holds_barrow_61C7
F9A6: 21 FB 1B    ld   hl,$1BFB
F9A9: 01 18 00    ld   bc,$0018
F9AC: ED B0       ldir
F9AE: 3E 40       ld   a,$40
F9B0: 32 E8 61    ld   (time_61E8),a
F9B3: 3E 01       ld   a,$01
F9B5: 32 86 62    ld   (extra_life_awarded_6286),a
F9B8: 32 19 60    ld   (unknown_6019),a
F9BB: 3E B0       ld   a,$B0
F9BD: 32 9A 65    ld   (guard_2_x_659A),a
F9C0: CD BF DF    call $DFBF
F9C3: 3E 38       ld   a,$38
F9C5: 32 4D 63    ld   (unknown_634D),a
F9C8: CD 56 D7    call $D756
F9CB: C9          ret
F9CC: 3A C5 61    ld   a,(unknown_61C5)
F9CF: FE 00       cp   $00
F9D1: 28 01       jr   z,$F9D4
F9D3: C9          ret
F9D4: 3A 41 63    ld   a,(unknown_6341)
F9D7: FE 01       cp   $01
F9D9: C8          ret  z
F9DA: 21 C3 92    ld   hl,$92C3
F9DD: 22 C4 61    ld   (barrow_screen_params_61C4),hl
F9E0: C9          ret

player_dies_F9E1:
F9E1: CD 4B D6    call $D64B
F9E4: 3E 01       ld   a,$01
F9E6: 32 F1 61    ld   (unknown_61F1),a
F9E9: CD 69 D2    call check_remaining_bags_D269
F9EC: 79          ld   a,c
F9ED: FE 01       cp   $01
F9EF: CC BD CF    call z,set_bags_coordinates_hard_level_CFBD
F9F2: 3A 7C 61    ld   a,(current_player_617C)
F9F5: 32 6C 62    ld   (unknown_626C),a
F9F8: 2A 09 60    ld   hl,(player_logical_address_6009)
F9FB: FD 21 08 60 ld   iy,unknown_6008
F9FF: DD 21 80 65 ld   ix,player_struct_6580
FA03: CD 2A C1    call $C12A
FA06: 3E 01       ld   a,$01
FA08: 32 51 61    ld   (game_locked_6151),a
FA0B: 32 00 A0    ld   (interrupt_control_A000),a
FA0E: 21 79 27    ld   hl,$2779
FA11: 22 54 61    ld   (unknown_6154),hl
FA14: 21 5D D9    ld   hl,$D95D
FA17: AF          xor  a
FA18: 32 52 61    ld   (wait_flag_6152),a
FA1B: FB          ei
FA1C: CD 84 EC    call play_sample_EC84
FA1F: 3A 56 60    ld   a,(lives_6056)
FA22: FE 00       cp   $00
FA24: 28 0F       jr   z,$FA35
FA26: 21 38 5B    ld   hl,$5B38
FA29: 22 40 61    ld   (ay_sound_pointer_6140),hl
FA2C: AF          xor  a
FA2D: 32 42 61    ld   (ay_sound_start_6142),a
FA30: 32 48 63    ld   (unknown_6348),a
FA33: 18 16       jr   $FA4B
FA35: CD E7 D4    call $D4E7
FA38: 20 11       jr   nz,$FA4B
FA3A: F3          di
FA3B: 21 60 3F    ld   hl,$3F60
FA3E: 22 40 61    ld   (ay_sound_pointer_6140),hl
FA41: AF          xor  a
FA42: 32 42 61    ld   (ay_sound_start_6142),a
FA45: 3E 01       ld   a,$01
FA47: 32 48 63    ld   (unknown_6348),a
FA4A: FB          ei
FA4B: 3A 52 61    ld   a,(wait_flag_6152)
FA4E: FE 01       cp   $01
FA50: 20 F9       jr   nz,$FA4B
FA52: 21 00 E0    ld   hl,$E000
FA55: 2B          dec  hl
FA56: 7C          ld   a,h
FA57: FE 00       cp   $00
FA59: 20 FA       jr   nz,$FA55
FA5B: 3A 56 60    ld   a,(lives_6056)
FA5E: FE 00       cp   $00
FA60: 20 06       jr   nz,$FA68
FA62: CD 6C EC    call $EC6C
FA65: CD 76 EC    call $EC76
FA68: CD EA FA    call start_new_life_FAEA
FA6B: DD 21 9C 65 ld   ix,object_held_struct_659C
FA6F: DD 77 00    ld   (ix+$00),a
FA72: DD 77 01    ld   (ix+$01),a
FA75: DD 77 02    ld   (ix+$02),a
FA78: 3E FF       ld   a,$FF
FA7A: DD 77 03    ld   (ix+$03),a
FA7D: AF          xor  a
FA7E: 32 58 61    ld   (has_bag_6158),a
FA81: 32 C7 61    ld   (holds_barrow_61C7),a
FA84: 32 11 63    ld   (unknown_6311),a
FA87: CD BF DF    call $DFBF
FA8A: 3A 7D 61    ld   a,(unknown_617D)
FA8D: FE 01       cp   $01
FA8F: 28 14       jr   z,$FAA5
FA91: 3A 7C 61    ld   a,(current_player_617C)
FA94: C6 01       add  a,$01
FA96: E6 01       and  $01
FA98: 32 7C 61    ld   (current_player_617C),a
FA9B: 3A 7D 61    ld   a,(unknown_617D)
FA9E: 47          ld   b,a
FA9F: FE 02       cp   $02
FAA1: 78          ld   a,b
FAA2: CC 27 C4    call z,$C427
FAA5: 3A 56 60    ld   a,(lives_6056)
FAA8: FE 00       cp   $00
FAAA: 20 1B       jr   nz,$FAC7
FAAC: 3A 7C 61    ld   a,(current_player_617C)
FAAF: C6 01       add  a,$01
FAB1: E6 01       and  $01
FAB3: 32 7C 61    ld   (current_player_617C),a
FAB6: 3A 7D 61    ld   a,(unknown_617D)
FAB9: 47          ld   b,a
FABA: FE 02       cp   $02
FABC: 78          ld   a,b
FABD: CC 27 C4    call z,$C427
FAC0: 3A 56 60    ld   a,(lives_6056)
FAC3: FE 00       cp   $00
FAC5: 28 51       jr   z,$FB18
FAC7: 3D          dec  a
FAC8: 32 56 60    ld   (lives_6056),a
FACB: CD 17 D0    call $D017
FACE: AF          xor  a
FACF: 32 08 60    ld   (unknown_6008),a
FAD2: 32 4E 60    ld   (fatal_fall_height_reached_604E),a
FAD5: 32 4D 60    ld   (fall_height_604D),a
FAD8: 32 8F 60    ld   (unknown_608F),a
FADB: 32 77 60    ld   (guard_2_in_elevator_6077),a
FADE: 32 37 60    ld   (guard_1_in_elevator_6037),a
FAE1: 32 4F 60    ld   (unknown_604F),a
FAE4: CD 14 C3    call init_guard_directions_and_wagons_C314
FAE7: 3E 01       ld   a,$01
FAE9: C9          ret
start_new_life_FAEA:
FAEA: DD 21 44 61 ld   ix,unknown_6144
FAEE: 3E 00       ld   a,$00
FAF0: 06 06       ld   b,$06
FAF2: CD 85 E5    call memset_E585
FAF5: AF          xor  a
; set everything player-related to 0
FAF6: 32 52 61    ld   (wait_flag_6152),a
FAF9: 32 51 61    ld   (game_locked_6151),a
FAFC: 32 25 60    ld   (player_death_flag_6025),a
FAFF: 32 28 60    ld   (player_controls_frozen_6028),a
FB02: 32 4E 60    ld   (fatal_fall_height_reached_604E),a
FB05: 32 29 60    ld   (player_in_wagon_flag_6029),a
FB08: 32 13 60    ld   (unknown_6013),a
FB0B: 32 4D 60    ld   (fall_height_604D),a
FB0E: 32 59 61    ld   (bag_falling_6159),a
FB11: 32 5E 61    ld   (bag_sliding_615E),a
FB14: 32 C7 61    ld   (holds_barrow_61C7),a
FB17: C9          ret
FB18: CD 6C EC    call $EC6C
FB1B: AF          xor  a
FB1C: 32 54 60    ld   (gameplay_allowed_6054),a
FB1F: 06 16       ld   b,$16
FB21: 21 00 30    ld   hl,$3000
FB24: 2B          dec  hl
FB25: FB          ei
FB26: 3E 01       ld   a,$01
FB28: 32 53 60    ld   (game_locked_6053),a
FB2B: 32 F1 61    ld   (unknown_61F1),a
FB2E: 7C          ld   a,h
FB2F: FE 00       cp   $00
FB31: 20 F1       jr   nz,$FB24
FB33: 10 EC       djnz $FB21
FB35: CD 74 C6    call $C674
FB38: AF          xor  a
FB39: 32 10 62    ld   (must_play_music_6210),a
FB3C: 32 7C 61    ld   (current_player_617C),a
FB3F: 3A 00 60    ld   a,(number_of_credits_6000)
FB42: FE 00       cp   $00
FB44: 20 35       jr   nz,$FB7B
FB46: CD 98 FB    call prepare_cleared_screen_FB98
FB49: 11 AC 56    ld   de,$56AC
FB4C: 21 5A 93    ld   hl,$935A
FB4F: CD 67 CA    call display_localized_text_CA67
FB52: 11 53 23    ld   de,$2353
FB55: 21 B5 93    ld   hl,$93B5
FB58: CD D9 55    call $55D9
FB5B: 3E 0E       ld   a,$0E
FB5D: 21 9A 98    ld   hl,$989A
FB60: CD 05 56    call write_attribute_on_line_5605
FB63: 3E 03       ld   a,$03
FB65: 21 55 98    ld   hl,$9855
FB68: CD 05 56    call write_attribute_on_line_5605
FB6B: 3E 11       ld   a,$11
FB6D: 32 B5 9B    ld   ($9BB5),a
FB70: CD FB C8    call $C8FB
FB73: 3E 01       ld   a,$01
FB75: 32 00 A0    ld   (interrupt_control_A000),a
FB78: CD D5 C5    call $C5D5
FB7B: F3          di
FB7C: CD DB CF    call set_bags_coordinates_easy_level_CFDB
FB7F: CD E7 CF    call set_bags_coordinates_CFE7
FB82: CD 1A C4    call $C41A
FB85: AF          xor  a
FB86: 32 53 60    ld   (game_locked_6053),a
FB89: 32 F1 61    ld   (unknown_61F1),a
FB8C: 3A 00 60    ld   a,(number_of_credits_6000)
FB8F: FE 00       cp   $00
FB91: CC 18 12    call z,play_intro_1218
FB94: FB          ei
FB95: 3E 01       ld   a,$01
FB97: C9          ret

prepare_cleared_screen_FB98:
FB98: 3E 00       ld   a,$00
FB9A: 32 03 A0    ld   ($A003),a
FB9D: CD B7 C3    call clear_screen_C3B7
FBA0: 3E 30       ld   a,$30
FBA2: CD A3 C3    call change_attribute_everywhere_C3A3
FBA5: 06 01       ld   b,$01
FBA7: 21 80 65    ld   hl,player_struct_6580
FBAA: 3E 00       ld   a,$00
FBAC: CD A8 C3    call $C3A8
FBAF: CD A4 F8    call display_player_ids_and_credit_F8A4
FBB2: 3E 01       ld   a,$01
FBB4: 32 03 A0    ld   ($A003),a
FBB7: C9          ret
choose_guard_random_direction_FBB8:
FBB8: 3A 00 A0    ld   a,(interrupt_control_A000)
FBBB: 21 70 59    ld   hl,$5970
FBBE: E6 03       and  $03
FBC0: 85          add  a,l
FBC1: 6F          ld   l,a
FBC2: 7C          ld   a,h
FBC3: CE 00       adc  a,$00
FBC5: 67          ld   h,a
FBC6: 7E          ld   a,(hl)
FBC7: 2A 95 60    ld   hl,(guard_direction_pointer_6095)
FBCA: 77          ld   (hl),a
FBCB: C9          ret
check_object_pickup_FBCC:
FBCC: 3A 59 61    ld   a,(bag_falling_6159)
FBCF: FE 01       cp   $01
FBD1: C8          ret  z
FBD2: 3A 5E 61    ld   a,(bag_sliding_615E)
FBD5: FE 01       cp   $01
FBD7: C8          ret  z
FBD8: 0A          ld   a,(bc)
FBD9: D9          exx
FBDA: FE 00       cp   $00
FBDC: C2 3C FC    jp   nz,$FC3C
FBDF: 2A 09 60    ld   hl,(player_logical_address_6009)
FBE2: 3A 0D 60    ld   a,(player_screen_600D)
FBE5: FD BE 02    cp   (iy+$02)
FBE8: C0          ret  nz
FBE9: FD 56 01    ld   d,(iy+$01)
FBEC: FD 5E 00    ld   e,(iy+$00)
FBEF: D5          push de
FBF0: 13          inc  de
FBF1: 13          inc  de
FBF2: CD 7B F4    call compute_backbuffer_tile_address_F47B
FBF5: E5          push hl
FBF6: AF          xor  a
FBF7: ED 52       sbc  hl,de
FBF9: E1          pop  hl
FBFA: 28 07       jr   z,$FC03
FBFC: CD 0B D0    call $D00B
FBFF: 28 02       jr   z,$FC03
FC01: D1          pop  de
FC02: C9          ret
FC03: D1          pop  de
FC04: CD E3 F4    call test_pickup_flag_F4E3
FC07: 78          ld   a,b
FC08: FE 00       cp   $00
FC0A: C8          ret  z
pick_up_object_FC0B:
FC0B: 62          ld   h,d
FC0C: 6B          ld   l,e
FC0D: 22 F6 61    ld   (picked_up_object_screen_address_61F6),hl
FC10: AF          xor  a
FC11: 32 7E 62    ld   (unknown_627E),a
FC14: DD 21 80 65 ld   ix,player_struct_6580
FC18: FD 7E 04    ld   a,(iy+$04)
FC1B: DD 77 1C    ld   (ix+$1c),a
FC1E: FD 7E 05    ld   a,(iy+$05)
FC21: DD 77 1D    ld   (ix+$1d),a
FC24: AF          xor  a
FC25: FD 77 00    ld   (iy+$00),a
FC28: FD 77 01    ld   (iy+$01),a
FC2B: FD 7E 04    ld   a,(iy+$04)
FC2E: FE 37       cp   $37
FC30: 20 05       jr   nz,$FC37
; resets the LSB of pickaxe timer
; which means that if timer gets past 0x100 once during a life
; or until a pick is lost (not dropped)
; it's not reset (all picks will now only last half the time
; until a life is lost or the pick "times out"!)
;
; not sure if it's a bug or on purpose...
FC32: 3E 01       ld   a,$01
FC34: FD 77 14    ld   (iy+$14),a
FC37: 3E 01       ld   a,$01
FC39: D9          exx
FC3A: 02          ld   (bc),a
FC3B: C9          ret
FC3C: FD 7E 00    ld   a,(iy+$00)
FC3F: FE 00       cp   $00
FC41: C0          ret  nz
FC42: 3A 82 65    ld   a,(player_x_6582)
FC45: FE D0       cp   $D0
FC47: D0          ret  nc
FC48: 3A 3A 63    ld   a,(unknown_633A)
FC4B: FE 01       cp   $01
FC4D: C8          ret  z
FC4E: CD E3 F4    call test_pickup_flag_F4E3
FC51: 78          ld   a,b
FC52: FE 00       cp   $00
FC54: C8          ret  z

drop_object_FC55:
FC55: DD 21 9C 65 ld   ix,object_held_struct_659C
FC59: 3A 0D 60    ld   a,(player_screen_600D)
FC5C: 32 98 60    ld   (current_guard_screen_index_6098),a
FC5F: CD EF EA    call compute_logical_address_from_xy_EAEF
FC62: 3A 11 63    ld   a,(unknown_6311)
FC65: FE 01       cp   $01
FC67: CA E7 FC    jp   z,$FCE7
FC6A: E5          push hl
FC6B: 3A 0D 60    ld   a,(player_screen_600D)
FC6E: FD 77 02    ld   (iy+$02),a
FC71: CD 5E E5    call convert_logical_to_screen_address_E55E
FC74: 67          ld   h,a
FC75: AF          xor  a
FC76: 7D          ld   a,l
FC77: D6 22       sub  $22
FC79: 6F          ld   l,a
FC7A: 7C          ld   a,h
FC7B: DE 00       sbc  a,$00
FC7D: 67          ld   h,a
FC7E: FD 75 00    ld   (iy+$00),l
FC81: FD 74 01    ld   (iy+$01),h
FC84: 3A 0D 60    ld   a,(player_screen_600D)
FC87: FD 77 02    ld   (iy+$02),a
FC8A: C5          push bc
FC8B: CD 6C D3    call test_non_blocking_tiles_D36C
FC8E: 78          ld   a,b
FC8F: C1          pop  bc
FC90: FE 00       cp   $00
FC92: CA A7 D3    jp   z,$D3A7
FC95: E1          pop  hl
FC96: 7E          ld   a,(hl)
FC97: FE E0       cp   $E0
FC99: E5          push hl
FC9A: CA A7 D3    jp   z,$D3A7
FC9D: E1          pop  hl
; useless code: pushes hl to sub $20 to it then pops it
; without using the computing value
FC9E: E5          push hl
FC9F: AF          xor  a
FCA0: 7D          ld   a,l
FCA1: D6 20       sub  $20
; does not even store a back to l !!
FCA3: 7C          ld   a,h
FCA4: DE 00       sbc  a,$00
FCA6: 67          ld   h,a
FCA7: E1          pop  hl
; hl is the same here as in 21F3 so test cannot be true, ever
FCA8: 7E          ld   a,(hl)
FCA9: FE E0       cp   $E0
FCAB: C8          ret  z
FCAC: D9          exx
FCAD: 3A C7 61    ld   a,(holds_barrow_61C7)
FCB0: FE 01       cp   $01
FCB2: 20 05       jr   nz,$FCB9
FCB4: 3E 28       ld   a,$28
FCB6: 08          ex   af,af'
FCB7: 18 1A       jr   $FCD3
; compute attribute color in D7 for draw_object_tiles_3417
; either pick or barrow or ...
FCB9: 3E 20       ld   a,$20
FCBB: 08          ex   af,af'
FCBC: 3A CF 61    ld   a,(has_pick_61CF)
FCBF: FE 01       cp   $01
FCC1: 28 10       jr   z,$FCD3
FCC3: AF          xor  a
FCC4: FD 77 00    ld   (iy+$00),a
FCC7: FD 77 01    ld   (iy+$01),a
FCCA: AF          xor  a
FCCB: D9          exx
FCCC: 02          ld   (bc),a
FCCD: 3E 01       ld   a,$01
FCCF: 32 34 63    ld   (unknown_6334),a
FCD2: C9          ret
FCD3: AF          xor  a
FCD4: 02          ld   (bc),a
FCD5: FD 6E 00    ld   l,(iy+$00)
FCD8: FD 66 01    ld   h,(iy+$01)
FCDB: FD 7E 06    ld   a,(iy+$06)
FCDE: CD 7C CE    call draw_object_tiles_CE7C
FCE1: 3E FF       ld   a,$FF
FCE3: 32 9F 65    ld   (sprite_object_y_659F),a
FCE6: C9          ret
FCE7: 2B          dec  hl
FCE8: C5          push bc
FCE9: 7E          ld   a,(hl)
FCEA: E5          push hl
FCEB: CD F2 F4    call $F4F2
FCEE: E1          pop  hl
FCEF: C1          pop  bc
FCF0: C0          ret  nz
FCF1: C3 C3 FC    jp   $FCC3

FCF4: FD 21 56 61 ld   iy,unknown_6156
FCF8: FD 7E 00    ld   a,(iy+$00)
FCFB: FE 01       cp   $01
FCFD: C8          ret  z
FCFE: 3A 99 60    ld   a,(guard_1_screen_6099)
FD01: 32 98 60    ld   (current_guard_screen_index_6098),a
FD04: DD E5       push ix
FD06: 21 00 05    ld   hl,$0500
FD09: CD 90 5C    call add_to_score_5C90
FD0C: 21 6F D9    ld   hl,$D96F
FD0F: CD 84 EC    call play_sample_EC84
FD12: DD E1       pop  ix
FD14: DD 21 4F 60 ld   ix,unknown_604F
FD18: CD A9 D4    call $D4A9
FD1B: AF          xor  a
FD1C: 32 57 60    ld   (guard_1_not_moving_timeout_counter_6057),a
FD1F: 3E 21       ld   a,$21
FD21: 32 94 65    ld   (guard_1_struct_6594),a
FD24: 2A 38 60    ld   hl,(guard_1_logical_address_6038)
FD27: FD 21 37 60 ld   iy,guard_1_in_elevator_6037
FD2B: DD 21 94 65 ld   ix,guard_1_struct_6594
FD2F: CD 2A C1    call $C12A
FD32: C9          ret
FD33: FD 21 57 61 ld   iy,unknown_6157
FD37: FD 7E 00    ld   a,(iy+$00)
FD3A: FE 01       cp   $01
FD3C: C8          ret  z
FD3D: 3A 9A 60    ld   a,(guard_2_screen_609A)
FD40: 32 98 60    ld   (current_guard_screen_index_6098),a
FD43: DD E5       push ix
FD45: 21 00 05    ld   hl,$0500
FD48: CD 90 5C    call add_to_score_5C90
FD4B: 21 6F D9    ld   hl,$D96F
FD4E: CD 84 EC    call play_sample_EC84
FD51: DD E1       pop  ix
FD53: DD 21 8F 60 ld   ix,unknown_608F
FD57: CD A9 D4    call $D4A9
FD5A: AF          xor  a
FD5B: 32 97 60    ld   (guard_2_not_moving_timeout_counter_6097),a
FD5E: 3E 21       ld   a,$21
FD60: 32 98 65    ld   (guard_2_struct_6598),a
FD63: 2A 78 60    ld   hl,(guard_2_logical_address_6078)
FD66: FD 21 77 60 ld   iy,guard_2_in_elevator_6077
FD6A: DD 21 98 65 ld   ix,guard_2_struct_6598
FD6E: CD 2A C1    call $C12A
FD71: C9          ret
draw_object_tiles_FD72:
FD72: DD 21 9C 60 ld   ix,bags_coordinates_609C
FD76: 3E 04       ld   a,$04
FD78: 32 7A 62    ld   (bag_color_color_attribute_627A),a
FD7B: 06 13       ld   b,$13
FD7D: DD E5       push ix
FD7F: C5          push bc
FD80: CD C1 CA    call $CAC1
FD83: C1          pop  bc
FD84: DD E1       pop  ix
FD86: DD 23       inc  ix
FD88: DD 23       inc  ix
FD8A: DD 23       inc  ix
FD8C: 3E 01       ld   a,$01
FD8E: 32 7A 62    ld   (bag_color_color_attribute_627A),a
FD91: 10 EA       djnz $FD7D
FD93: 3A C7 61    ld   a,(holds_barrow_61C7)
FD96: FE 01       cp   $01
FD98: 28 1C       jr   z,$FDB6
FD9A: 3A 0D 60    ld   a,(player_screen_600D)
FD9D: 47          ld   b,a
FD9E: FD 21 C4 61 ld   iy,barrow_screen_params_61C4
FDA2: FD 7E 02    ld   a,(iy+$02)
FDA5: B8          cp   b
FDA6: 20 0E       jr   nz,$FDB6
FDA8: FD 6E 00    ld   l,(iy+$00)
FDAB: FD 66 01    ld   h,(iy+$01)
FDAE: 3E 28       ld   a,$28
FDB0: 08          ex   af,af'
FDB1: 3E EC       ld   a,$EC
FDB3: CD 7C CE    call draw_object_tiles_CE7C
FDB6: 3A 0D 60    ld   a,(player_screen_600D)
FDB9: 47          ld   b,a
FDBA: FD 21 CC 61 ld   iy,current_pickaxe_screen_params_61CC
FDBE: FD 7E 02    ld   a,(iy+$02)
FDC1: B8          cp   b
FDC2: 20 22       jr   nz,$FDE6
FDC4: FD 6E 00    ld   l,(iy+$00)
FDC7: FD 66 01    ld   h,(iy+$01)
FDCA: 7E          ld   a,(hl)
FDCB: CD F3 CF    call is_background_tile_for_object_drop_CFF3
FDCE: 20 16       jr   nz,$FDE6
FDD0: E5          push hl
FDD1: D5          push de
FDD2: 11 20 00    ld   de,$0020
FDD5: 19          add  hl,de
FDD6: 7E          ld   a,(hl)
FDD7: CD F3 CF    call is_background_tile_for_object_drop_CFF3
FDDA: D1          pop  de
FDDB: E1          pop  hl
FDDC: 20 08       jr   nz,$FDE6
FDDE: 3E 20       ld   a,$20
FDE0: 08          ex   af,af'
FDE1: 3E E4       ld   a,$E4
FDE3: CD 7C CE    call draw_object_tiles_CE7C
FDE6: 06 04       ld   b,$04
FDE8: FD 21 D3 61 ld   iy,struct_swap_buffer_61D3
FDEC: 11 CC 61    ld   de,current_pickaxe_screen_params_61CC
FDEF: C5          push bc
FDF0: FD E5       push iy
FDF2: D5          push de
FDF3: CD C2 DB    call swap_3_bytes_DBC2
FDF6: 1A          ld   a,(de)
FDF7: 6F          ld   l,a
FDF8: 13          inc  de
FDF9: 1A          ld   a,(de)
FDFA: 67          ld   h,a
FDFB: 1B          dec  de
FDFC: 3A 0D 60    ld   a,(player_screen_600D)
FDFF: FD E1       pop  iy
FE01: FD BE 02    cp   (iy+$02)
FE04: FD E5       push iy
FE06: 20 1C       jr   nz,$FE24
FE08: 7E          ld   a,(hl)
FE09: CD F3 CF    call is_background_tile_for_object_drop_CFF3
FE0C: 20 16       jr   nz,$FE24
FE0E: E5          push hl
FE0F: D5          push de
FE10: 11 20 00    ld   de,$0020
FE13: 19          add  hl,de
FE14: 7E          ld   a,(hl)
FE15: CD F3 CF    call is_background_tile_for_object_drop_CFF3
FE18: D1          pop  de
FE19: E1          pop  hl
FE1A: 20 08       jr   nz,$FE24
FE1C: 3E 20       ld   a,$20
FE1E: 08          ex   af,af'
FE1F: 3E E4       ld   a,$E4
FE21: CD 7C CE    call draw_object_tiles_CE7C
FE24: D1          pop  de
FE25: FD E1       pop  iy
FE27: C1          pop  bc
FE28: FD 23       inc  iy
FE2A: FD 23       inc  iy
FE2C: FD 23       inc  iy
FE2E: 10 BF       djnz $FDEF
FE30: 3A FF FF    ld   a,($FFFF)
FE33: 3A 0D 60    ld   a,(player_screen_600D)
FE36: 47          ld   b,a
FE37: FD 21 0E 63 ld   iy,unknown_630E
FE3B: FD 7E 02    ld   a,(iy+$02)
FE3E: B8          cp   b
FE3F: 20 22       jr   nz,$FE63
FE41: FD 6E 00    ld   l,(iy+$00)
FE44: FD 66 01    ld   h,(iy+$01)
FE47: 7E          ld   a,(hl)
FE48: CD F3 CF    call is_background_tile_for_object_drop_CFF3
FE4B: 20 16       jr   nz,$FE63
FE4D: E5          push hl
FE4E: D5          push de
FE4F: 11 20 00    ld   de,$0020
FE52: 19          add  hl,de
FE53: 7E          ld   a,(hl)
FE54: CD F3 CF    call is_background_tile_for_object_drop_CFF3
FE57: D1          pop  de
FE58: E1          pop  hl
FE59: 20 08       jr   nz,$FE63
FE5B: 3E 24       ld   a,$24
FE5D: 08          ex   af,af'
FE5E: 3E D4       ld   a,$D4
FE60: CD 7C CE    call draw_object_tiles_CE7C
FE63: 06 04       ld   b,$04
FE65: FD 21 15 63 ld   iy,unknown_6315
FE69: 11 0E 63    ld   de,unknown_630E
FE6C: C5          push bc
FE6D: FD E5       push iy
FE6F: D5          push de
FE70: CD B5 DB    call $DBB5
FE73: 1A          ld   a,(de)
FE74: 6F          ld   l,a
FE75: 13          inc  de
FE76: 1A          ld   a,(de)
FE77: 67          ld   h,a
FE78: 1B          dec  de
FE79: 3A 0D 60    ld   a,(player_screen_600D)
FE7C: FD E1       pop  iy
FE7E: FD BE 02    cp   (iy+$02)
FE81: FD E5       push iy
FE83: 20 1C       jr   nz,$FEA1
FE85: 7E          ld   a,(hl)
FE86: CD F3 CF    call is_background_tile_for_object_drop_CFF3
FE89: 20 16       jr   nz,$FEA1
FE8B: E5          push hl
FE8C: D5          push de
FE8D: 11 20 00    ld   de,$0020
FE90: 19          add  hl,de
FE91: 7E          ld   a,(hl)
FE92: CD F3 CF    call is_background_tile_for_object_drop_CFF3
FE95: D1          pop  de
FE96: E1          pop  hl
FE97: 20 08       jr   nz,$FEA1
FE99: 3E 24       ld   a,$24
FE9B: 08          ex   af,af'
FE9C: 3E D4       ld   a,$D4
FE9E: CD 7C CE    call draw_object_tiles_CE7C
FEA1: D1          pop  de
FEA2: FD E1       pop  iy
FEA4: C1          pop  bc
FEA5: FD 23       inc  iy
FEA7: FD 23       inc  iy
FEA9: FD 23       inc  iy
FEAB: 10 BF       djnz $FE6C
FEAD: C9          ret
FEAE: 3A 34 63    ld   a,(unknown_6334)
FEB1: FE 00       cp   $00
FEB3: C8          ret  z
FEB4: DD 21 9C 65 ld   ix,object_held_struct_659C
FEB8: FD 21 5A 61 ld   iy,unknown_615A
FEBC: 3A 0D 60    ld   a,(player_screen_600D)
FEBF: 32 98 60    ld   (current_guard_screen_index_6098),a
FEC2: CD EF EA    call compute_logical_address_from_xy_EAEF
FEC5: 7E          ld   a,(hl)
FEC6: E5          push hl
FEC7: 21 E3 21    ld   hl,$21E3
FECA: 01 17 00    ld   bc,$0017
FECD: ED B9       cpdr
FECF: E1          pop  hl
FED0: C8          ret  z
FED1: 3A 0D 60    ld   a,(player_screen_600D)
FED4: CD B2 F2    call $F2B2
FED7: 22 26 63    ld   (unknown_6326),hl
FEDA: 3E 24       ld   a,$24
FEDC: 08          ex   af,af'
FEDD: 3E D4       ld   a,$D4
FEDF: CD 7C CE    call draw_object_tiles_CE7C
FEE2: 3E 00       ld   a,$00
FEE4: 32 34 63    ld   (unknown_6334),a
FEE7: 3E FF       ld   a,$FF
FEE9: 32 9F 65    ld   (sprite_object_y_659F),a
FEEC: C9          ret
FEED: 05          dec  b
FEEE: 08          ex   af,af'
FEEF: 4E          ld   c,(hl)
FEF0: 20 48       jr   nz,$FF3A
FEF2: 03          inc  bc
FEF3: 41          ld   b,c
FEF4: 30 08       jr   nc,$FEFE
FEF6: 01 DC 08    ld   bc,$08DC
FEF9: 0C          inc  c
FEFA: 30 45       jr   nc,$FF41
FEFC: 10 46       djnz $FF44
FEFE: 31 4D FE    ld   sp,$FE4D
FF01: 06 D8       ld   b,$D8
FF03: 06 0B       ld   b,$0B
FF05: FE 07       cp   $07
FF07: D8          ret  c
FF08: 06 0C       ld   b,$0C
FF0A: FE 08       cp   $08
FF0C: D8          ret  c
FF0D: 06 0D       ld   b,$0D
FF0F: FE 09       cp   $09
FF11: D8          ret  c
FF12: 06 0E       ld   b,$0E
FF14: FE 0A       cp   $0A
FF16: C9          ret
FF17: DD 77 00    ld   (ix+$00),a
FF1A: 3E 0C       ld   a,$0C
FF1C: C3 EE 06    jp   guard_move_if_fast_enough_06EE
FF1F: DD 77 00    ld   (ix+$00),a
FF22: 3E 0D       ld   a,$0D
FF24: C3 EE 06    jp   guard_move_if_fast_enough_06EE
FF27: DD 77 00    ld   (ix+$00),a
FF2A: 3E 0E       ld   a,$0E
FF2C: C3 EE 06    jp   guard_move_if_fast_enough_06EE
FF2F: DD 77 00    ld   (ix+$00),a
FF32: 3E 0D       ld   a,$0D
FF34: C3 EE 06    jp   guard_move_if_fast_enough_06EE
