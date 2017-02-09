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
;		Input Analog light sensor at RB5/AN11
;		Output Dimming LED at RB6
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
ANLumi

DataSend
DataReceive
ByteLength
PortCStat
PortBStat
DutyTotal
Duty0
Duty1
Duty2
DutyRB6

	endc
	
	org 0

Start:
	movlw		0xFF
	banksel		OSCCON						; set CPU speed
	bsf			OSCCON, IRCF0				
	bsf			OSCCON, IRCF1				
	bsf			OSCCON, IRCF2				
	banksel		TRISA
	movwf		TRISA						; set PORT A to input
	
	bsf			TRISA, 2					; RA2 = clock in
	bsf			TRISA, 1					; RA1 = data in
	bcf			TRISB, 7					; RB7 = clock out
	bcf			TRISB, 6					; RB6 = data out
	
	bsf			TRISB, 5					; set RB5 to input (analog later)
	bcf			TRISB, 6					; set RB6 to output
	clrf		TRISC						; set PORT C to output
	
	banksel		ADCON0						
	clrf		ADCON0						; clear junk
	movlw		b'00101101'					; turn ADC on
	movwf		ADCON0
	banksel		ANSEL
	clrf		ANSEL
	clrf		ANSELH
	bsf			ANSELH, 3					; set RB5/AN11 to analog
	
	banksel		PORTC
	clrf		PORTC
	clrf		PORTB
	
;	bcf			STATUS, RP0
;	bcf			STATUS, RP1
	banksel		ADCON0						; BANK 0

	clrf		VarOut
	clrf		ANLumi
	bcf			STATUS, C					; clear Carry bit
	clrf		DataSend
	clrf		DataReceive

Main:
	clrw
	
;	call		CheckButtons
	
	btfss		ADCON0, GO					; analog reading
	bsf			ADCON0, GO
	btfsc		ADCON0, GO
	goto		$-1
	call		SetChanges
	
	
	movlw		.255
	movwf		DutyTotal
	
	movf		ANLumi, w					
	movwf		PORTC
	
		
	movwf		DataSend
	movlw		.8
	movwf		ByteLength
	call		SendComms
	
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
	
ReceiveComms:
	rlf			DataReceive, f				; shift bits first
	btfss		PORTA, 2					; wait for clock to on / byte sent
	goto		$-1
	
	btfss		PORTA, 1					; copy received data to rightmost bit
	bcf			DataReceive, 0
	btfsc		PORTA, 1
	bsf			DataReceive, 0
	
	bsf			PORTB, 7					; set acknowledge bit
	
	btfsc		PORTA, 2					; wait for sender to reset
	goto		$-1
	bcf			PORTB, 7					; acknowledge reset
	
	bcf			STATUS, C
	decfsz		ByteLength
	goto		ReceiveComms
	return		
	
	
SendComms:
	bsf			PORTB, 7					; turn comm clock on
	
	btfss		DataSend, 7					; send leftmost bit
	bcf			PORTB, 6
	btfsc		DataSend, 7
	bsf			PORTB, 6
	
	btfss		PORTA, 2					; wait for data recieved to be recognized
	goto		$-1
	bcf			PORTB, 7					; turn comm clock off, recieve acknowledged
	btfsc		PORTA, 2					; wait for clock off to be acknowledged
	goto		$-1
	
	rlf			DataSend, f
	bcf			STATUS, C
	decfsz		ByteLength
	goto		SendComms
	return
	
SetChanges:
	movf		ADRESH, w
;	sublw		.255
	
	
	sublw		.128
	movwf		ANLumi
	bcf			ANLumi, 7
	rlf			ANLumi, 1
	movf		ANLumi, w
	
;	sublw		.255
;	movwf		VarOut
	
	movwf		DutyRB6
	
	return
	
Delay:
	decfsz		Delay1,f					; Delay1 = Delay1 - 1  
	goto		Delay						; The Inner loop takes 3 instructions per loop * 256 loopss = 768 instructions
	
	decfsz		Delay2,f					; Delay2 = Delay2 - 1
	goto		Delay						; (768+3) * 256 = 197376 instructions / 1M instructions per second = 0.197 sec.
	
	return

	end

