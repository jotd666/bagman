@echo off
cd %~pd0
gprbuild -Pbagman.gpr -XBuild=Release -Xdebug_conf=false -Xarch=m68k-amigaos 
pause