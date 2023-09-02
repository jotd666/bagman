; Karate Champ slave
	INCDIR	Include:
	INCLUDE	whdload.i
	INCLUDE	whdmacros.i

;CHIP_ONLY

_base	SLAVE_HEADER					; ws_security + ws_id
	dc.w	17					; ws_version (was 10)
	dc.w	WHDLF_NoError
    IFD CHIP_ONLY
	dc.l	$200000					; ws_basememsize
    ELSE
	dc.l	$100000					; ws_expmem
    ENDC
	dc.l	0					; ws_execinstall
	dc.w	start-_base		; ws_gameloader
	dc.w	_data-_base					; ws_currentdir
	dc.w	0					; ws_dontcache
_keydebug
	dc.b	$0					; ws_keydebug
_keyexit
	dc.b	$59					; ws_keyexit
_expmem
    IFD CHIP_ONLY
    dc.l    $0
    ELSE
	dc.l	$100000					; ws_expmem
    ENDC
	dc.w	_name-_base				; ws_name
	dc.w	_copy-_base				; ws_copy
	dc.w	_info-_base				; ws_info
    dc.w    0     ; kickstart name
    dc.l    $0         ; kicksize
    dc.w    $0         ; kickcrc
    dc.w    _config-_base
;---
_config
	dc.b    "C1:X:cheat keys F1-F2 instant win:0;"
	dc.b    "C1:X:human player wins in 1 round:1;"
	dc.b    "C1:X:invincible in bull and evade:2;"
	dc.b    "C2:L:difficulty:easy,medium,hard,hardest;"
	dc.b    "C3:L:start level:pier,fuji,bamboo,bridge,"
	dc.b	"boat,field,mill,city,indian,temple,dojo,moonlight,"
	dc.b	"pier_hard,fuji_hard,bamboo_hard,bridge_hard,"
	dc.b	"boat_hard,field_hard,mill_hard,city_hard,indian_hard,temple_hard,"
	dc.b	"dojo_hard,moonlight_hard;"
	dc.b    "C4:L:controls:WinUAE joypad,CD32 joypad,2 joysticks;"
	dc.b    "C5:X:skip girl intermissions:0;"
	dc.b    "C5:X:free play:1;"
	dc.b    "C5:X:limit to 25 FPS:2;"
	dc.b	0

	IFD BARFLY
	DOSCMD	"WDate  >T:date"
	ENDC

DECL_VERSION:MACRO
	dc.b	"1.0"
	IFD BARFLY
		dc.b	" "
		INCBIN	"T:date"
	ENDC
	IFD	DATETIME
		dc.b	" "
		incbin	datetime
	ENDC
	ENDM
_data   dc.b    0
_name	dc.b	'Karate Champ VS',0
_copy	dc.b	'2023 JOTD',0
_info
    dc.b    "Music by no9",0
	dc.b	0
_kickname   dc.b    0
;--- version id

    dc.b	0
    even

start:
	LEA	_resload(PC),A1
	MOVE.L	A0,(A1)
	move.l	a0,a2
    
    IFD CHIP_ONLY
    lea  _expmem(pc),a0
    move.l  #$C0000,(a0)
    ENDC
    lea progstart(pc),a0
    move.l  _expmem(pc),(a0)

	lea	exe(pc),a0
	move.l  progstart(pc),a1
	jsr	(resload_LoadFileDecrunch,a2)
	move.l  progstart(pc),a0
    bsr   _Relocate
	move.l	_resload(pc),a0
    move.l  #'WHDL',d0
    move.b  _keyexit(pc),d1
	move.l  progstart(pc),-(a7)
    
    lea  _custom,a1
    move.w  #$1200,bplcon0(a1)
    move.w  #$0024,bplcon2(a1)
    rts
	
_Relocate	movem.l	d0-d1/a0-a2,-(sp)
        clr.l   -(a7)                   ;TAG_DONE
;        pea     -1                      ;true
;        pea     WHDLTAG_LOADSEG
		IFND		CHIP_ONLY
        move.l  #$400,-(a7)       ;chip area
        pea     WHDLTAG_CHIPPTR        
        pea     8                       ;8 byte alignment
        pea     WHDLTAG_ALIGN
		ENDC
        move.l  a7,a1                   ;tags	
		move.l	_resload(pc),a2
		jsr	resload_Relocate(a2)
		IFND		CHIP_ONLY
        add.w   #5*4,a7
		ELSE
		addq.w	#4,a7
		ENDC
		
        movem.l	(sp)+,d0-d1/a0-a2
		rts

_resload:
	dc.l	0
progstart
    dc.l    0
exe
	dc.b	"karate_champ",0
	