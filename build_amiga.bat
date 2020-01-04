@echo off
cd %~pd0
gprbuild -Pbagman.gpr -XBuild=Release -Xarch=m68k-amigaos 
pause