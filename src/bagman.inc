

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
	.else
	
    * hardware options
    OPT_DISABLE_BG_LAYER=0
    OPT_DISABLE_SPRITES=0
   
	* cheats to test game
    * score is BCD format
	* all options must be zeroed for release
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
    .equ  DRAW_MAZE_SND,         0x01
    .equ  START_SND,         0x02
    .equ  DIAMONDS_ALIGNED_SND,         0x03
    .equ  LEVEL_COMPLETED_SND,         0x04
    .equ  PLAYER_DIES_SND,         0x05
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
    .equ  SHAKE_WALL_SND,         0x14
	.equ	BLOCK_HITS_WALL_SND,		0x15
	.equ	BLOCK_SLIDES_SND,		0x16

    
