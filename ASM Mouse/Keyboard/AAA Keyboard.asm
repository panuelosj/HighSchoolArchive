;**********************************************************************
;																		*
;	Filename:		Test.asm											*
;	Date:																*
;	File Version:	1.1.0												*
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


	list		p=16f690		; list directive to define processor
	#include <p16F690.inc>
	
	#define		iTiltX		PORTA,1
	#define		iTiltY		PORTA,0
	#define		iRightB		PORTA,4
	#define		iLeftB		PORTA,3
	#define		iSensTog	PORTA,5
	#define		RTS			PORTB,4
	
	#define		nOffset		.83
	#define		nUpperBound	.87
	#define		nLowerBound	.79
	#define		nShiftCtrl	.250
	
	#define		sOffset		.16			;.22
	#define		sUpperBound	.18			;.24
	#define		sLowerBound	.14			;.20
	#define		sShiftCtrl	.220		;.230
	
	
	__config (_INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _BOR_OFF & _IESO_OFF & _FCMEN_OFF)


	cblock 0x20
Delay1						; unused delay variables
Delay2

;ButtonStat					; Bit0 = RA5, Bit1 = RA4, 1 = unpressed

VarTx						; temporary holder for data to transmit
VarRc						; temporary holder for data received

xRaw						; raw values from tilt sensor, thrown out
yRaw
xRawH						; high bits from tilt sensor, used
yRawH
xMov						; change in direction, sent to USB
yMov

offset						; 0 degrees
upperBound					; for deadzone (offset + x degs)
lowerBound					; for deadzone (offsel - x degs)
shiftCtrl					; for changing sensitivity 

;---------------------------------------------------------------------
;	Mouse Packet Data
;---------------------------------------------------------------------
Byte0
Byte1	
Byte2
Byte3	
	endc
	
	
	org 0x0
	goto		Start

Start:	
	;-----------------------------------------------------------------
	; SET CONSTANTS
	;-----------------------------------------------------------------
	movlw		.83
	movwf		offset
	movlw		.87
	movwf		upperBound
	movlw		.79
	movwf		lowerBound	
	movlw		.250
	movwf		shiftCtrl
	
	
	;-----------------------------------------------------------------
	; SET CPU SPEED			111 = 8MHz
	;
	;	111 = 8MHz; 110 = 4MHz; 101 = 2MHz; 100 = 1MHz
	;-----------------------------------------------------------------
	banksel		OSCCON						
	bcf			OSCCON, IRCF0				
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
	bsf			TRISA, 1					; Tilt Sensor X
	bsf			TRISA, 0					; Tilt Sensor Y
	bsf			TRISA, 3					; Right Button
	bsf			TRISA, 4					; Left Button
	bsf			TRISA, 5					; sensitivity toggle
	bsf			TRISC, 0					; pressure sensor 1
	bsf			TRISC, 1					; pressure sensor 2
	bsf			TRISB, 4					; RTS: Request to send from PC
	
	
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
	movlw		.207
	movwf		SPBRG						; 1200 Hz @ 8-bit, high rate
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
	bsf			INTCON, PEIE				; Peripheral Interrupts Enabled
	bcf			INTCON, GIE					; Global Interrupt Disabled
	
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
	goto		Main
	
Main:
	
	btfsc		RTS						; initialize as "Microsoft Mouse" when asked by PC-side driver
	call		MouseReboot
	
	movf		xRawH, w				; debug code
	movwf		PORTC
	
	movlw		0x1C
	movwf		VarTx
	call		Transmit					; transmit data
	movlw		0xF0
	movwf		VarTx
	call		Transmit					; transmit data
	movlw		0x1C
	movwf		VarTx
	call		Transmit					; transmit data
	
	call		Delay
	
	goto		Main				; infinite loop
	;-----------|INFINITE LOOP|---------------------------------------	
	
MouseReboot:
	btfss		RTS
	goto		$-1
	call		MouseInit
	return
MouseInit:
	movlw		0xAA						; emulate Keyboard
	movwf		VarTx
	call		Transmit
	return



;-----------------------------------------------------------------
; Polling				Non-interrupt based status checking
;
;-----------------------------------------------------------------
Transmit:
	banksel		TXREG
	btfss		PIR1, TXIF
	goto		$-1
	movf		VarTx, w
	movwf		TXREG
	return
	
Receive:
	banksel		RCREG
	movf		RCREG, w
	movwf		VarRc
	return


Delay:
	decfsz		Delay1,f					; Delay1 = Delay1 - 1  
	goto		Delay						; The Inner loop takes 3 instructions per loop * 256 loopss = 768 instructions
	
	decfsz		Delay2,f					; Delay2 = Delay2 - 1
	goto		Delay						; (768+3) * 256 = 197376 instructions / 1M instructions per second = 0.197 sec.
	
	return

	end

