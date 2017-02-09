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
	
	#define		iTiltX		PORTA,0	
	
	
	__config (_INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _BOR_OFF & _IESO_OFF & _FCMEN_OFF)


	cblock 0x20
Delay1						; Assign an address to label Delay1
Delay2

ButtonStat					; Bit0 = RA5, Bit1 = RA4, 1 = unpressed

VarTx
VarRc
xRaw
yRaw
xRawH
yRawH
xCalc
yCalc
	endc
	
	
	org 0x0
	goto		Start
	org	0x4
	goto		Interrupt

Start:	
	;-----------------------------------------------------------------
	; SET CPU SPEED			111 = 8MHz
	;
	;	111 = 8MHz; 110 = 4MHz; 101 = 2MHz; 100 = 1MHz
	;-----------------------------------------------------------------
	banksel		OSCCON						
	bsf			OSCCON, IRCF0				
	bsf			OSCCON, IRCF1				
	bsf			OSCCON, IRCF2				
	
	
	;-----------------------------------------------------------------
	; SET IO Pins			Clear all
	;
	;
	;-----------------------------------------------------------------
	banksel		TRISA
	clrf		TRISA
	clrf		TRISB
	clrf		TRISC
	bsf			TRISA, 0					; Tilt Sensor X
	
	
	;-----------------------------------------------------------------
	; SET EUSART Comms
	;
	;
	;-----------------------------------------------------------------
	banksel		TRISB
	bsf			TRISB, 5
	bsf			TRISB, 6
	bsf			TRISB, 7
		
	banksel		TXSTA					; Transmitter Config
	bcf			TXSTA, TX9					; 9-bit Transmit:			Disabled
	bsf			TXSTA, TXEN					; Transmit Enable: 			Enabled
	bcf			TXSTA, SYNC					; EUSART Mode Select: 0=asynchronous
	bcf			TXSTA, SENB					; Send Break Character bit
	bsf			TXSTA, BRGH					; High Baud Rate Select Bit
	
	banksel		RCSTA					; Receiver Config
	bsf			RCSTA, SPEN					; Serial Port Enable
	bcf			RCSTA, RX9					; 9-bit Receive:			Disabled
	bsf			RCSTA, CREN					; Receive Enable:			Enabled
	
	banksel		BAUDCTL					; Baud Rate Generator
	bcf			BAUDCTL, SCKP				; Synchronous Clock Polarity Select Bit
	bcf			BAUDCTL, BRG16				; 16-bit baud rate gen:		0 = 8-bit baud rate
	bcf			BAUDCTL, WUE				; Wake-up Enable:			0 = no interrupts
;	bsf			BAUDCTL, ABDEN				; Auto-Baud mode???
	banksel		SPBRG
	movlw		.51
	movwf		SPBRG						; 9600 Hz @ 8-bit, high rate
	movlw		.0
	movwf		SPBRGH
	
	;-----------------------------------------------------------------
	; INTERRUPTS					Turn Everything Off
	;
	;-----------------------------------------------------------------
	banksel		PIE1
	clrf		PIE1
	clrf		PIE2
	bsf			PIE1, TXIE					; Transmitter Interrupt
	bsf			PIE1, RCIE					; Receiver Interrupt
	banksel		INTCON
	clrf		INTCON
	bsf			INTCON, PEIE				; Enable Peripheral Interrupts
	bcf			INTCON, GIE					; Global Interrupt Enable
	
	;-----------------------------------------------------------------
	; SET A-D Converter				Turn Everything Off
	;	
	;-----------------------------------------------------------------
	banksel		ADCON0						
	clrf		ADCON0				
	banksel		ANSEL
	clrf		ANSEL
	clrf		ANSELH
	
	banksel		PORTA
	clrf		PORTA
	clrf		PORTC
	clrf		PORTB

	;-----------------------------------------------------------------
	; Multi-Code Pointer
	;
	;-----------------------------------------------------------------

	goto		MainTransmit
	; or
	goto		MainReceive
	
	

MainTransmit:
	btfsc		iTiltX					; Wait for Tilt Sensor to go low
	goto		$-1
	btfss		iTiltX					; Wait for Tilt Sensor to go high
	goto		$-1
	clrf		xRaw						
	clrf		xRawH
	
	incf		xRaw, f						; increment as duty cycle counter
	btfsc		STATUS, Z					; check if xRaw (least significant) overflows
	call		IncrXHigh						; increment high bits when xRaw overflows
	btfsc		iTiltX					; keep checking until Tilt Sensor falls (duty cycle done)
	goto		$-4
	
;	bcf			STATUS, C
;	rrf			xRawH, f
;	movlw		.27
;	subwf		xRawH, w
;	movf		xRawH, w					; store finished count into variable
	movwf		VarTx
	
	call		Poll_Tx						; transmit data if ready
	
	goto		MainTransmit				; infinite loop
	
	

IncrXHigh:
	incf		xRawH, f
	movlw		.230						; low bits shift control (to move significant bits to higher variable)
	movwf		xRaw
	return

MainReceive:
	movf		VarRc, w
	movwf		PORTC
	
	call		Poll_Rc
	
	goto		MainReceive


;-----------------------------------------------------------------
; Polling				Non-interrupt based status checking
;
;-----------------------------------------------------------------
Poll_Tx:
	banksel		TXREG
	movf		VarTx, w
	movwf		TXREG
	return
	
Poll_Rc:
	banksel		RCREG
	btfsc		RCSTA, OERR						; test for overrun error
	goto		Error_Overrun
	btfsc		RCSTA, FERR						; test for framing error
	goto		Error_Framing
	movf		RCREG, w
	movwf		VarRc
;		bsf			PORTA, 2
	return


;-----------------------------------------------------------------
; Interrupts
;
;-----------------------------------------------------------------
Interrupt:
	banksel		INTCON
	bcf			INTCON, 7					; clear interrupts
	btfsc		PIR1, RCIF					; check where interrupt came from
	goto		Interrupt_Rc
	btfsc		PIR1, TXIF
	goto		Interrupt_Tx
	goto		Quit_Int					; if interrupt from nowhere
	
Interrupt_Tx:								; Transmitter Interrupt
	banksel		TXREG
	movf		VarTx, w
	movwf		TXREG
	goto		Quit_Int

Interrupt_Rc:								; Receiver Interrupt
	banksel		RCREG
	btfsc		RCSTA, OERR						; test for overrun error
	goto		Error_Overrun
	btfsc		RCSTA, FERR						; test for framing error
	goto		Error_Framing
	movf		RCREG, w
	movwf		VarRc
;		bsf			PORTA, 2
	goto		Quit_Int
	
Error_Overrun:
	bcf			RCSTA, CREN
	nop
	nop
	nop
	bsf			RCSTA, CREN
	bsf			PORTA, 1
	goto		Quit_Int
	
Error_Framing:
	movf		RCREG, w
	goto		Quit_Int
	
	
	
Quit_Int:
	retfie
	

Delay:
	decfsz		Delay1,f					; Delay1 = Delay1 - 1  
	goto		Delay						; The Inner loop takes 3 instructions per loop * 256 loopss = 768 instructions
	
	decfsz		Delay2,f					; Delay2 = Delay2 - 1
	goto		Delay						; (768+3) * 256 = 197376 instructions / 1M instructions per second = 0.197 sec.
	
	return

	end

