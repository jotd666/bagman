**
**	$VER: cia.i 39.1 (18.9.92)
**	Includes Release 40.13
**
**	registers and bits in the Complex Interface Adapter (CIA) chip
**
**	(C) Copyright 1985-1993 Commodore-Amiga, Inc.
**	    All Rights Reserved
**

*
* _ciaa is on an ODD address (e.g. the low byte) | 0xbfe001
* _ciab is on an EVEN address (e.g. the high byte) | 0xbfd000
*
* do this to get the definitions:
*    XREF _ciaa
*    XREF _ciab
*
ciaa = 0xbfe001
ciab = 0xbfd000
CIAA = 0xbfe001
CIAB = 0xbfd000

* cia register offsets
CIAPRA		  =	0X0000
CIAPRB		  =	0X0100
CIADDRA	  =	0X0200
CIADDRB	  =	0X0300
CIATALO	  =	0X0400
CIATAHI	  =	0X0500
CIATBLO	  =	0X0600
CIATBHI	  =	0X0700
CIATODLOW	  =	0X0800
CIATODMID	  =	0X0900
CIATODHI	  =	0X0A00
CIASDR		  =	0X0C00
CIAICR		  =	0X0D00
CIACRA		  =	0X0E00
CIACRB		  =	0X0F00

* interrupt control register bit numbers
CIAICRB_TA	  =	0
CIAICRB_TB	  =	1
CIAICRB_ALRM	  =	2
CIAICRB_SP	  =	3
CIAICRB_FLG	  =	4
CIAICRB_IR	  =	7
CIAICRB_SETCLR	  =	7

* control register A bit numbers
CIACRAB_START	  =	0
CIACRAB_PBON	  =	1
CIACRAB_OUTMODE   =	2
CIACRAB_RUNMODE   =	3
CIACRAB_LOAD	  =	4
CIACRAB_INMODE	  =	5
CIACRAB_SPMODE	  =	6
CIACRAB_TODIN	  =	7

* control register B bit numbers
CIACRBB_START	  =	0
CIACRBB_PBON	  =	1
CIACRBB_OUTMODE   =	2
CIACRBB_RUNMODE   =	3
CIACRBB_LOAD	  =	4
CIACRBB_INMODE0   =	5
CIACRBB_INMODE1   =	6
CIACRBB_ALARM	  =	7

* interrupt control register bit masks
CIAICRF_TA	  =	(1<<0)
CIAICRF_TB	  =	(1<<1)
CIAICRF_ALRM	  =	(1<<2)
CIAICRF_SP	  =	(1<<3)
CIAICRF_FLG	  =	(1<<4)
CIAICRF_IR	  =	(1<<7)
CIAICRF_SETCLR	  =	(1<<7)

* control register A bit masks
CIACRAF_START	  =	(1<<0)
CIACRAF_PBON	  =	(1<<1)
CIACRAF_OUTMODE   =	(1<<2)
CIACRAF_RUNMODE   =	(1<<3)
CIACRAF_LOAD	  =	(1<<4)
CIACRAF_INMODE	  =	(1<<5)
CIACRAF_SPMODE	  =	(1<<6)
CIACRAF_TODIN	  =	(1<<7)

* control register B bit masks
CIACRBF_START	  =	(1<<0)
CIACRBF_PBON	  =	(1<<1)
CIACRBF_OUTMODE   =	(1<<2)
CIACRBF_RUNMODE   =	(1<<3)
CIACRBF_LOAD	  =	(1<<4)
CIACRBF_INMODE0   =	(1<<5)
CIACRBF_INMODE1   =	(1<<6)
CIACRBF_ALARM	  =	(1<<7)

* control register B INMODE masks
CIACRBF_IN_PHI2   =	0
CIACRBF_IN_CNT	  =	(CIACRBF_INMODE0)
CIACRBF_IN_TA	  =	(CIACRBF_INMODE1)
CIACRBF_IN_CNT_TA =	(CIACRBF_INMODE0!CIACRBF_INMODE1)


*
* Port definitions | what each bit in a cia peripheral register is tied to
*

* ciaa port A (0xbfe001)
CIAB_GAMEPORT1	  =	(7)   | gameport 1, pin 6 (fire button*)
CIAB_GAMEPORT0	  =	(6)   | gameport 0, pin 6 (fire button*)
CIAB_DSKRDY	  =	(5)   | disk ready*
CIAB_DSKTRACK0	  =	(4)   | disk on track 00*
CIAB_DSKPROT	  =	(3)   | disk write protect*
CIAB_DSKCHANGE	  =	(2)   | disk change*
CIAB_LED	  =	(1)   | led light control (0==>bright)
CIAB_OVERLAY	  =	(0)   | memory overlay bit

* ciaa port B (0xbfe101) | parallel port

* ciab port A (0xbfd000) | serial and printer control
CIAB_COMDTR	  =	(7)   | serial Data Terminal Ready*
CIAB_COMRTS	  =	(6)   | serial Request to Send*
CIAB_COMCD	  =	(5)   | serial Carrier Detect*
CIAB_COMCTS	  =	(4)  | serial Clear to Send*
CIAB_COMDSR	  =	(3)   | serial Data Set Ready*
CIAB_PRTRSEL	  =	(2)   | printer SELECT
CIAB_PRTRPOUT	  =	(1)   | printer paper out
CIAB_PRTRBUSY	  =	(0)   | printer busy

* ciab port B (0xbfd100) | disk control
CIAB_DSKMOTOR	  =	(7)   | disk motorr*
CIAB_DSKSEL3	  =	(6)   | disk select unit 3*
CIAB_DSKSEL2	  =	(5)   | disk select unit 2*
CIAB_DSKSEL1	  =	(4)   | disk select unit 1*
CIAB_DSKSEL0	  =	(3)   | disk select unit 0*
CIAB_DSKSIDE	  =	(2)   | disk side select*
CIAB_DSKDIREC	  =	(1)   | disk direction of seek*
CIAB_DSKSTEP	  =	(0)   | disk step heads*

* ciaa port A (0xbfe001)
CIAF_GAMEPORT1	  =	(1<<7)
CIAF_GAMEPORT0	  =	(1<<6)
CIAF_DSKRDY	  =	(1<<5)
CIAF_DSKTRACK0	  =	(1<<4)
CIAF_DSKPROT	  =	(1<<3)
CIAF_DSKCHANGE	  =	(1<<2)
CIAF_LED	  =	(1<<1)
CIAF_OVERLAY	  =	(1<<0)

* ciaa port B (0xbfe101) | parallel port

* ciab port A (0xbfd000) | serial and printer control
CIAF_COMDTR	  =	(1<<7)
CIAF_COMRTS	  =	(1<<6)
CIAF_COMCD	  =	(1<<5)
CIAF_COMCTS	  =	(1<<4)
CIAF_COMDSR	  =	(1<<3)
CIAF_PRTRSEL	  =	(1<<2)
CIAF_PRTRPOUT	  =	(1<<1)
CIAF_PRTRBUSY	  =	(1<<0)

* ciab port B (0xbfd100) | disk control
CIAF_DSKMOTOR	  =	(1<<7)
CIAF_DSKSEL3	  =	(1<<6)
CIAF_DSKSEL2	  =	(1<<5)
CIAF_DSKSEL1	  =	(1<<4)
CIAF_DSKSEL0	  =	(1<<3)
CIAF_DSKSIDE	  =	(1<<2)
CIAF_DSKDIREC	  =	(1<<1)
CIAF_DSKSTEP	  =	(1<<0)

