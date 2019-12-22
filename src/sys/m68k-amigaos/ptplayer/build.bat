@echo off
cd /D %~PD0

vasmm68k_mot  -devpac -Faout %opt% -o ..\..\..\..\obj\m68k-amigaos\ptplayer.o ptplayer.asm

pause

