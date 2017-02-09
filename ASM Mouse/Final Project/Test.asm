;**********************************************************************
;																		*
;	Filename:		Test.asm											*
;	Date:																*
;	File Version:														*
;																		*
;	Author:			Jonathan											*
;	Company:															*
;																		* 
;																		*
;**********************************************************************
;																		*
;	Files Required:	P16F690.INC											*
;																		*
;**********************************************************************
;																		*
;	Notes:																*
;		button stat: 	hardware, 0=pressed								*
;						software vars, 1=unpressed						*
;																		*
;**********************************************************************
;        _    _     ___     _    _ 										*
;       | |  | |   /   \   | |  | |										*
;       | |  | |  / /'\ \  | |  | |										*
;       | |__| | | |   | | | |__| |           _  ___					*
;       |      | | |   | | |      |     |\ | / \  |						*
;       '""""| | | |   | | '""""| |     | \| \_/  |						*
;            | | | |   | |      | |   _  _            _					*
;            | | | \   | |      | |  |_ / \ | | |\ | | \				*
;            | |  \ \_/ /       | |  |  \_/ \_/ | \| |_/				*
;            | |   \   /        | |										*
;            '"'    '"'         '"'										*
;																		*
;**********************************************************************


	list		p=16f690		; list directive to define processor
	#include <p16F690.inc>
	__config (_INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _BOR_OFF & _IESO_OFF & _FCMEN_OFF)

	cblock 0x20
Delay1						; Assign an address to label Delay1
Delay2
Delay3

ButtonStat					; Bit0 = RA5, Bit1 = RA4, 1 = unpressed

VarOut						; define a variable to hold the diplay
DirLR						; 0=right, 1=left
	endc
	
	org 0

Start:
	bsf			STATUS,RP0					; select Register Page 1
	bcf			STATUS,RP1
	movlw		0xFF			
	movwf		TRISA						; set PORT A to input
	clrf		TRISC						; set PORT C to output
	
	
	bcf			STATUS,RP0					; back to Register Page 0
	bcf			STATUS,RP1
	
	clrf		PORTC
	movlw		.07							
	movwf		VarOut						; set display to 0000 0111
	bcf			DirLR, 0
;	movlw		.1
;	movwf		DirLR						; set initial direction to right
	bcf			STATUS, C

Main:
	clrw
	
	
	call		CheckButtons
	call		SetChanges
	
	movf		DirLR, w					; check direction, Z becomes 0 if DirLR=1
	btfss		STATUS, Z					
	call		RotLeft						; if 1 (Z=0), go left
	btfsc		STATUS, Z
	call		RotRight					; if 0 (Z=1), go right
	
	
	movf		VarOut, w
;	movwf		PORTC						; OUTPUT DISPLAY
	
	
	movlw		.255						; speed param
	movwf		Delay1
	movwf		Delay2
	movwf		Delay3
	goto		Delay						; Frame Limiter

CheckButtons:								
	btfsc		PORTA, 5					; RA5
	bcf			ButtonStat, 0				; If unpressed, set as 0
	btfss		PORTA, 5
	bsf			ButtonStat, 0				; If pressed, set as 1
	
	btfsc		PORTA, 4					; RA4
	bcf			ButtonStat, 1				;
	btfss		PORTA, 4
	bsf			ButtonStat, 1
	
	return
	
SetChanges:
	bcf			PORTC, 1
;	bcf			DirLR, 0
	btfsc		ButtonStat, 1
	bsf			PORTC, 1
;	bsf			DirLR, 0
;	call		ChangeDir
	return
	
ChangeDir:
	btfss		DirLR, 0					; if DirLR = 0, set to 1
	movlw		0x1
	btfsc		DirLR, 0					; if DirLR = 1, set to 0
	movlw		0x0
	return

RotLeft:
	rlf			VarOut, f					; Edit Variable Output
	movf		VarOut, w					; Copy Display to w
	return
	
RotRight:
	rrf			VarOut, f					; Edit Variable Output
	movf		VarOut, w					; Copy Display to w
	return
	
Delay:
	decfsz		Delay1,f					; Delay1 = Delay1 - 1  
	goto		Delay						; The Inner loop takes 3 instructions per loop * 256 loopss = 768 instructions
	
	
	decfsz		Delay2,f					; Delay2 = Delay2 - 1
	goto		Delay						; (768+3) * 256 = 197376 instructions / 1M instructions per second = 0.197 sec.
	goto		Main

	end

