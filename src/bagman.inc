

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
	
    .equ  INTERMISSION_MUSIC_SND,         0x07
    .equ  IN_GAME_MUSIC_SND,         0x08
    .equ  HISCORE_MUSIC_SND,         0x09
    .equ  IN_GAME_MUSIC_FAST_SND,         0x0A
    .equ  IN_GAME_MUSIC_FASTER_SND,         0x0B
    .equ  SNOBEE_EATEN_SND,         0xC
    .equ  SNOBEE_CHICKEN_SND,         0xD
    .equ  SNOBEE_HATCHING_SND,         0xE
    .equ  SNOBEE_CRUSHED_SND,         0xF
    .equ  SNOBEE_STUNNED_SND,         0x10
    .equ  DIAMONDS_BONUS_SND,         0x11
    .equ  EXTRA_LIFE_SND,         0x12
    .equ  BLOCK_BROKEN_SND,         0x13


    
