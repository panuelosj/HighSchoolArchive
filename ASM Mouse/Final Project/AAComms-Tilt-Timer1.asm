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
	; SET CPU SPEED			110 = 4MHz
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
	bsf			TRISA, 1
	
	
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
	bcf			TXSTA, TX9					; 9-bit Transmit
	bsf			TXSTA, TXEN					; Transmit Enable: 			Set later if sender
	bcf			TXSTA, SYNC					; EUSART Mode Select: 0=asynchronous
	bcf			TXSTA, SENB					; Send Break Character bit
	bsf			TXSTA, BRGH					; High Baud Rate Select Bit
	
	banksel		RCSTA					; Receiver Config
	bsf			RCSTA, SPEN					; Serial Port Enable
	bcf			RCSTA, RX9					; 9-bit Receive
	bsf			RCSTA, CREN					; Receive Enable:			Set later if receiver
	
	banksel		BAUDCTL
	bcf			BAUDCTL, SCKP				; Synchronous Clock Polarity Select Bit
	bcf			BAUDCTL, BRG16				; 16-bit baud rate gen:		0 = 8-bit baud rate
	bcf			BAUDCTL, WUE				; Wake-up Enable:			0 = no interrupts
;	bsf			BAUDCTL, ABDEN				; Auto-Baud mode
	banksel		SPBRG
	movlw		.51
	movwf		SPBRG
	movlw		.0
	movwf		SPBRGH
	
	;-----------------------------------------------------------------
	; INTERRUPTS					Turn Everything Off
	;
	;-----------------------------------------------------------------
	banksel		PIE1
	clrf		PIE1
	clrf		PIE2
	bsf			PIE1, TXIE
	bsf			PIE1, RCIE
	banksel		INTCON
	clrf		INTCON
	bsf			INTCON, PEIE				; Enable Peripheral Interrupts
	bsf			INTCON, GIE					; Global Interrupt Enable
	
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
;	btfss		PORTA, 1
;	movlw		b'11110000'
;	btfsc		PORTA, 1
;	movlw		b'00001111'
;	movwf		VarTx
	btfsc		PORTA, 1
	goto		$-1
	btfss		PORTA, 1
	goto		$-1
	clrf		xRaw
	clrf		xRawH
	
	incf		xRaw, f
	btfsc		STATUS, Z
	call		IncrXHigh
	btfsc		PORTA, 1
	goto		$-4
	
	movf		xRawH, w
	movwf		VarTx
	
	goto		MainTransmit
	
	

IncrXHigh:
	incf		xRawH, f
	movlw		.230
	movwf		xRaw
	return

MainReceive:
	movf		VarRc, w
	movwf		PORTC

;	btfsc		RCSTA, FERR
;	call		ReceiveError
;	btfsc		RCSTA, OERR
;	call		ReceiveError
	
	goto		MainReceive


ReceiveError:
	bcf			RCSTA, CREN
	nop
	nop
	bsf			RCSTA, CREN
	return

;-----------------------------------------------------------------
; Interrupts
;
;-----------------------------------------------------------------
Interrupt:
	banksel		INTCON
	bcf			INTCON, 7
	btfsc		PIR1, RCIF
	goto		Interrupt_Rc
	btfsc		PIR1, TXIF
	goto		Interrupt_Tx
	goto		Quit_Int
	
Interrupt_Tx:
	banksel		TXREG
	movf		VarTx, w
	movwf		TXREG
	goto		Quit_Int

Interrupt_Rc:
	banksel		RCREG
	btfsc		RCSTA, OERR					; test for overrun error
	goto		Error_Overrun
	btfsc		RCSTA, FERR					; test for framing error
	goto		Error_Framing
	movf		RCREG, w
	movwf		VarRc
		bsf			PORTA, 2
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
	
;	decfsz		Delay2,f					; Delay2 = Delay2 - 1
;	goto		Delay						; (768+3) * 256 = 197376 instructions / 1M instructions per second = 0.197 sec.
	
	return

	end

