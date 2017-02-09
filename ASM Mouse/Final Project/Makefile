# MPLAB IDE generated this makefile for use with GNU make.
# Project: PIC.mcp
# Date: Wed May 28 18:36:33 2014

AS = MPASMWIN.exe
CC = 
LD = mplink.exe
AR = mplib.exe
RM = rm

PIC.cof : AAComms-Tilt-SerialProtB.o
	$(CC) /p16F690 "AAComms-Tilt-SerialProtB.o" /u_DEBUG /z__MPLAB_BUILD=1 /z__MPLAB_DEBUG=1 /o"PIC.cof" /M"PIC.map" /W

AAComms-Tilt-SerialProtB.o : AAComms-Tilt-SerialProtB.asm ../../../../../Program\ Files\ (x86)/Microchip/MPASM\ Suite/p16F690.inc
	$(AS) /q /p16F690 "AAComms-Tilt-SerialProtB.asm" /l"AAComms-Tilt-SerialProtB.lst" /e"AAComms-Tilt-SerialProtB.err" /o"AAComms-Tilt-SerialProtB.o" /d__DEBUG=1

clean : 
	$(CC) "AAComms-Tilt-SerialProtB.o" "AAComms-Tilt-SerialProtB.err" "AAComms-Tilt-SerialProtB.lst" "PIC.cof" "PIC.hex"

