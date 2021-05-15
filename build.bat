@echo off

%~dp0/tools/asm68k.exe /j src/* /k /p /o ae+ src/main.asm, build/out.bin >build/errors.txt, build/out.map, build/out.lst

%~dp0/build/errors.txt