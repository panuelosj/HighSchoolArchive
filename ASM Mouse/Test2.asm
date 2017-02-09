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

ButtonStat					; Bit0 = RA5, Bit1 = RA4, 1 = unpressed

VarOut						; define a variable to hold the diplay

PortCStat
DutyTotal
Duty0
Duty1
Duty2

	endc
	
	org 0

Start:
	movlw		0xFF
	banksel		TRISA
	movwf		TRISA						; set PORT A to input
	clrf		TRISC						; set PORT C to output
	banksel		ADCON0						; turn all junk off
	clrf		ADCON0
	banksel		ANSEL
	clrf		ANSEL
	clrf		ANSELH
	banksel		PORTC
	clrf		PORTC
	
	movlw		.07
	movwf		VarOut
	bcf			STATUS, C

Main:
	clrw
	
	
	call		CheckButtons
	call		SetChanges
	
	movlw		.255
	movwf		DutyTotal
	movlw		.255
	movwf		Duty0
	movlw		.100
	movwf		Duty1
	movlw		.0
	movwf		Duty2	
	incf		Duty0
	incf		Duty1
	incf		Duty2
	
;	movf		VarOut, w
;	movwf		PortCStat
;	movwf		PORTC
	
	movf		VarOut, w
	movwf		PORTC
	call		OutputCtrl
	
	movlw		.1							; speed param
	movwf		Delay1
	movwf		Delay2
	call		Delay						; Frame Limiter
	goto		Main

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
;	movlw		.30
;	btfsc		ButtonStat, 1
;	movlw		.10
;	btfss		ButtonStat, 1
;	nop
	
	return
	
OutputCtrl:									; cycles 255 = 1 frame
	
	clrf		PortCStat					; clear all
	decfsz		Duty0
	bsf			PortCStat, 0					; set if DutyOn not done
	decfsz		Duty1							; ie: if it is done, variable is kept off
	bsf			PortCStat, 1					; when variable is off, then LED turns off
	decfsz		Duty2
	bsf			PortCStat, 2

	btfss		PortCStat, 0
	bcf			PORTC, 0						; turn LED off when DutyOn done
	btfss		PortCStat, 0					; **DON"T NEED** LED never turned back on, so doesn't matter if set back up
	incf		Duty0
	
	btfss		PortCStat, 1
	bcf			PORTC, 1
	btfss		PortCStat, 1
	incf		Duty1	
	
	btfss		PortCStat, 2
	bcf			PORTC, 2
	btfss		PortCStat, 2
	incf		Duty2
		
	decfsz		DutyTotal
	goto		OutputCtrl
	return
	

Delay:
	decfsz		Delay1,f					; Delay1 = Delay1 - 1  
	goto		Delay						; The Inner loop takes 3 instructions per loop * 256 loopss = 768 instructions
	
	decfsz		Delay2,f					; Delay2 = Delay2 - 1
	goto		Delay						; (768+3) * 256 = 197376 instructions / 1M instructions per second = 0.197 sec.
	
	return

	end

