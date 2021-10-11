@echo off


Rem ;Assemble the z80 pcm driver
%~dp0/tools/zmac.exe src/pcm_driver.asm -o build/pcm_driver.cim -o build/pcm_driver.lst

Rem ;Assemble the main 68k code
%~dp0/tools/asm68k.exe /j src/* /k /p /o ae+ src/main.asm, build/out.bin >build/errors.txt, build/out.map, build/out.lst

%~dp0/build/errors.txt