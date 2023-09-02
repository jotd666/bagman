.macro  BITDEF   prefix,name,bitnum
	    BITDEF0 \prefix,\name,B_,\bitnum
  
	    BITDEF0 \prefix,\name,F_,1<<\bitnum
.endm

.macro	BITDEF0     prefix,name,type,value
\prefix\type\name	    =     \value
.endm


	BITDEF	JP,BTN_RIGHT,0
	BITDEF	JP,BTN_LEFT,1
	BITDEF	JP,BTN_DOWN,2
	BITDEF	JP,BTN_UP,3
	BITDEF	JP,BTN_PLAY,0x11
	BITDEF	JP,BTN_REVERSE,0x12
	BITDEF	JP,BTN_FORWARD,0x13
	BITDEF	JP,BTN_GRN,0x14
	BITDEF	JP,BTN_YEL,0x15
	BITDEF	JP,BTN_RED,0x16
	BITDEF	JP,BTN_BLU,0x17
	
	.global	_detect_controller_types
	.global	_read_joystick
	.global	controller_joypad_0
	.global	controller_joypad_1
