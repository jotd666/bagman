@echo off
cd /D %~PD0

set AMIGAINCLUDE=K:/jff/AmigaHD/amiga39_JFF_OS/include
set OUTDIR=..\..\..\..\obj\m68k-amigaos
set ASM=vasmm68k_mot -I%AMIGAINCLUDE% -devpac -Faout %opt% -o
%ASM% %OUTDIR%\ptplayer.o ptplayer.asm
%ASM% %OUTDIR%\readjoypad.o ReadJoypad.asm

pause

