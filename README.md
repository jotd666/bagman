# Bagman (68K)

Bagman remake by JOTD in 2010-2023

Original game by Valadon Automation
ROM strings show that it has been coded by Jacques Brisse (still head of Valadon in 2015 at least)

Game has been resourced (Z80) and A.I & speeds extracted from the first versions. Now the Amiga version
uses 100% of the transcoded original code for better accuracy.

History: 

2010: first SDL version (Windows, Amiga - super slow)
2015: fixed a lot of bugs on SDL version
2019: Amiga version (needs 68020+ and fastmem, still slow)
2023: Amiga version using real game code transcoded to 68000 (should run on A500)


### PROGRESS:

#### TRANSCODE


#### AMIGA

- fully playable with sound
- still bugs
- missing features
- stuck on highscore screen

#### NEO GEO

- not planned ATM ...

### FEATURES:

#### CREDITS:

- Jean-Francois Fabre (aka jotd): Z80 reverse engineering, Z80 to 68k transcode, Amiga code and assets
- J.M.D: remade amiga tunes
- phx: ptplayer sound/music replay Amiga code
- Valadon Automation: original game :)

#### SPECIAL THANKS:

- Toni Wilen for WinUAE

#### CONTROLS (Amiga: joystick required):

- fire/5 key: insert coin (from menu)
- up/1 key: start game
- down/1 key: start 2P game
- P key: pause

## REBUILDING FROM SOURCES:

### AMIGA:

#### Prerequesites:

- Bebbo's amiga gcc compiler
- Windows
- python
- sox
- "bitplanelib.py" (asset conversion tool needs it) at https://github.com/jotd666/amiga68ktools.git

#### Build process:

- install above tools & adjust python paths
- make -f makefile.am

### NEO GEO:

#### Prerequesites:

- Windows
- NeoDev kit (Fabrice Martinez, Jeff Kurtz, et al)  
  https://wiki.neogeodev.org/index.php?title=Development_tools

#### Build process:

- install NeoDev and set path accordingly
- clone repository
- make -f makefile.ng OUTPUT={cart|cd}
  - (OUTPUT defaults to cart)
  
#### Install process (MAME):

- make -f makefile.ng OUTPUT={cart|cd} MAMEDIR={mamedir} install
  - (mamedir defaults to '.')
- paste bagman.xml into MAME's hash/neogeo.xml file

#### To run in MAME:

- cart : 'mame neogeo bagman'
- cd : 'mame neocdz -cdrom roms/neocdz/bagman.iso'
  
