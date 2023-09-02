
**
**	0xVER: custom.i 39.1 (18.9.92)
**	Includes Release 40.13
**
**	Offsets of Amiga custom chip registers
**
**	(C) Copyright 1985-1993 Commodore-Amiga, Inc.
**	    All Rights Reserved
**

*
* do this to get base of custom registers:
*  XREF _custom;
*

bltddat     =   0x000
dmaconr     =   0x002
vposr	    =   0x004
vhposr	    =   0x006
dskdatr     =   0x008
joy0dat     =   0x00A
joy1dat     =   0x00C
clxdat	    =   0x00E

adkconr     =   0x010
pot0dat     =   0x012
pot1dat     =   0x014
potinp	    =   0x016
serdatr     =   0x018
dskbytr     =   0x01A
intenar     =   0x01C
intreqr     =   0x01E

dskpt	    =   0x020
dsklen	    =   0x024
dskdat	    =   0x026
refptr	    =   0x028
vposw	    =   0x02A
vhposw	    =   0x02C
copcon	    =   0x02E
serdat	    =   0x030
serper	    =   0x032
potgo	    =   0x034
joytest     =   0x036
strequ	    =   0x038
strvbl	    =   0x03A
strhor	    =   0x03C
strlong     =   0x03E

bltcon0     =   0x040
bltcon1     =   0x042
bltafwm     =   0x044
bltalwm     =   0x046
bltcpt	    =   0x048
bltbpt	    =   0x04C
bltapt	    =   0x050
bltdpt	    =   0x054
bltsize     =   0x058
bltcon0l    =   0x05B		
bltsizv     =   0x05C
bltsizh     =   0x05E

bltcmod     =   0x060
bltbmod     =   0x062
bltamod     =   0x064
bltdmod     =   0x066

bltcdat     =   0x070
bltbdat     =   0x072
bltadat     =   0x074

deniseid    =   0x07C
dsksync     =   0x07E

cop1lc	    =   0x080
cop2lc	    =   0x084
copjmp1     =   0x088
copjmp2     =   0x08A
copins	    =   0x08C
diwstrt     =   0x08E
diwstop     =   0x090
ddfstrt     =   0x092
ddfstop     =   0x094
dmacon	    =   0x096
clxcon	    =   0x098
intena	    =   0x09A
intreq	    =   0x09C
adkcon	    =   0x09E

aud	    =   0x0A0
aud0	    =   0x0A0
aud1	    =   0x0B0
aud2	    =   0x0C0
aud3	    =   0x0D0

* AudChannel
ac_ptr	    =   0x00
ac_len	    =   0x04
ac_per	    =   0x06
ac_vol	    =   0x08
ac_dat	    =   0x0A
ac_SIZEOF   =   0x10

bplpt	    =   0x0E0

bplcon0     =   0x100
bplcon1     =   0x102
bplcon2     =   0x104
bplcon3     =   0x106
bpl1mod     =   0x108
bpl2mod     =   0x10A
bplcon4     =   0x10C
clxcon2     =   0x10E

bpldat	    =   0x110

sprpt	    =   0x120

spr	    =   0x140

* SpriteDef
sd_pos	    =   0x00
sd_ctl	    =   0x02
sd_dataa    =   0x04
sd_dataB    =   0x06
sd_SIZEOF   =   0x08

color	    =   0x180

htotal	    =   0x1c0
hsstop	    =   0x1c2
hbstrt	    =   0x1c4
hbstop	    =   0x1c6
vtotal	    =   0x1c8
vsstop	    =   0x1ca
vbstrt	    =   0x1cc
vbstop	    =   0x1ce
sprhstrt    =   0x1d0
sprhstop    =   0x1d2
bplhstrt    =   0x1d4
bplhstop    =   0x1d6
hhposw	    =   0x1d8
hhposr	    =   0x1da
beamcon0    =   0x1dc
hsstrt	    =   0x1de
vsstrt	    =   0x1e0
hcenter     =   0x1e2
diwhigh     =   0x1e4
fmode	    =   0x1fc
