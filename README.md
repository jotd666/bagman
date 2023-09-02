# Karate Champ (68K)

This is a transcode from the original arcade game Z80 to 68K assembly.


### PROGRESS:

#### TRANSCODE


#### AMIGA

- fully playable with sound
- minor bugs
- missing features

#### NEO GEO


### FEATURES:

#### CREDITS:

- Jean-Francois Fabre (aka jotd): Z80 reverse engineering, Z80 to 68k transcode, Amiga code and assets
- Mark McDougall (aka tcdev): Neo Geo code and graphical asset rips, invaluable
  help about how the graphics are displayed.
- no9: remade amiga tunes
- phx: ptplayer sound/music replay Amiga code
- DamienD: floppy menu
- mrv2k: amiga boxart
- blastar: NGFX SoundBuilder (Neo Geo sound tool)
- SEGA: original game :)

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

#### When changing asset-related data (since dependencies aren't good):

- To update the "graphics.68k" & "palette*.68k" files from "assets/amiga" subdir, 
  just run the "convert_graphics.py" python script, 
- To update sounds, use "convert_sounds.py"
  python script (audio) to create sound*.68k files.

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
- paste kchampvs.xml into MAME's hash/neogeo.xml file

#### To run in MAME:

- cart : 'mame neogeo pengo'
- cd : 'mame neocdz -cdrom roms/neocdz/kchampvs.iso'
  
