

***    
*** BUILD OPTIONS
***

	.ifdef	RELEASE
    OPT_DISABLE_BG_LAYER=0            | LEAVE AT 0!!!
    OPT_DISABLE_SPRITES=0             | LEAVE AT 0!!!
    OPT_START_SCORE=0                 | LEAVE AT 0!!!
	OPT_SKIP_INTRO_SCREEN=0           | LEAVE AT 0!!!
	OPT_SKIP_TITLE_SCREEN=0           | LEAVE AT 0!!!
	OPT_SKIP_GAME_DEMO=0              | LEAVE AT 0!!!
	OPT_ONLY_GUARD_ONE=0              | LEAVE AT 0!!!
	OPT_ONLY_GUARD_TWO=0              | LEAVE AT 0!!!
	.else
	
    * hardware options
    OPT_DISABLE_BG_LAYER=0
    OPT_DISABLE_SPRITES=0
   
	* cheats to test game
    * score is BCD format
	* all options are zeroed for release
	* set to 1 for: only guard at screen one is moving
	OPT_ONLY_GUARD_ONE=0
	* set to 1 for: only guard at screen 3 is moving
	OPT_ONLY_GUARD_TWO=0
    OPT_START_SCORE=0x45000
	OPT_SKIP_INTRO_SCREEN=0
	OPT_SKIP_TITLE_SCREEN=0
	OPT_SKIP_GAME_DEMO=0
	.endif
	
***
*** end of BUILD OPTIONS
***




* sound ordinals



    .equ  CREDIT_SND,         0x00
    .equ  GUARD_KILLED_SND,         0x01
    .equ  PICKAXE_SND,         0x02
    .equ  PLAYER_CLIMB_SND,         0x03
    .equ  PLAYER_WALK_SND,         0x04
    .equ  TAKE_BAG_SND,         0x05
    .equ  REWARD_TUNE_SND,         0x06
    .equ  PLAYER_KILLED_TUNE_SND,	0x07
    .equ  PLAYER_KILLED_TALK_SND,	0x08
    .equ  REWARD_TALK_SND,		0x09
    .equ  FALL_IN_WAGON_SND, 		0xA
    .equ  PLAYER_GRABS_HANDLE_SND, 	0xB
    .equ  TIME_WARN_SND,			0xC
    .equ  GUARD_CLIMB_SND,			0xD
	.equ  GUARD_WALK_SND,			0xE
	.equ  TUNE1_SND,			0xF
	.equ  TUNE2_SND,			0x10



    
