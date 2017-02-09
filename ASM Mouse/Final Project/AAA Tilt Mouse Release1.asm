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
	
	#define		iTiltX		PORTA,1
	#define		iTiltY		PORTA,0
	#define		iRightB		PORTA,3
	#define		iLeftB		PORTA,4
	#define		RTS			PORTB,4
	
	
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
xMov
yMov

offset

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
	movlw		.22
	movwf		offset
	
	
	
	
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
	goto		Main
	
Main:
	
	btfsc		RTS						; initialize as "Microsoft Mouse" when asked by PC-side driver
	call		MouseReboot
		
	;-----------|X AXIS|----------------------------------------------
	call		ReadX					; read tilt sensor for raw data
	call		SubtrX					; do math to fix data
	;-----------|Y AXIS|----------------------------------------------
	call		ReadY					; read tilt sensor for raw data
	call		SubtrY					; do math to fix data
	
	;-----------|BYTE 0 of PACKET - Direction + Button States|--------
	movlw		b'01000000'
	movwf		Byte0
	btfsc		xMov, 6
	bsf			Byte0, 0
	btfsc		xMov, 7
	bsf			Byte0, 1
	btfsc		yMov, 6
	bsf			Byte0, 2
	btfsc		yMov, 7
	bsf			Byte0, 3
	
	bcf			Byte0, 4
	bcf			Byte0, 5
	btfsc		iRightB
	bsf			Byte0, 4
	btfsc		iLeftB
	bsf			Byte0, 5
	;-----------|BYTE 2 of PACKET - X MAGNITUDE|----------------------
	bsf			xMov, 7
	bcf			xMov, 6
	movf		xMov, w
	movwf		Byte1
	;-----------|BYTE 3 of PACKET - Y MAGNITUDE|----------------------
	bsf			yMov, 7
	bcf			yMov, 6
	movf		yMov, w
	movwf		Byte2
	
	;-----------|UART TRANSMIT DATA|----------------------------------
	movf		Byte0, w
	movwf		VarTx
	call		Transmit					; transmit data
	movf		Byte1, w
	movwf		VarTx
	call		Transmit					; transmit data
	movf		Byte2, w
	movwf		VarTx
	call		Transmit					; transmit data
	
	;-----------|INFITITE LOOP|---------------------------------------
	goto		Main				; infinite loop
	
	
MouseReboot:
	btfss		RTS
	goto		$-1
	call		MouseInit
	return
MouseInit:
	movlw		'M'							; emulate Microsoft Mouse
	movwf		VarTx
	call		Transmit
	return




;-----------------------------------------------------------------
; Sensor Check			
;
;-----------------------------------------------------------------
ReadX:
		; Buffer
	btfsc		iTiltX					; Wait for Tilt Sensor to go low
	goto		$-1
	btfss		iTiltX					; Wait for Tilt Sensor to go high
	goto		$-1
	clrf		xRaw					
	clrf		xRawH
		; Counter
	incf		xRaw, f					; increment as duty cycle counter
	btfsc		STATUS, Z				; check if xRaw (least significant) overflows
	call		IncrXHigh				; increment high bits when xRaw overflows
	btfsc		iTiltX					; keep checking until Tilt Sensor falls (duty cycle done)
	goto		$-4
	return
IncrXHigh:
	incf		xRawH, f
	movlw		.230					; low bits shift control (to move significant bits to higher variable)
	movwf		xRaw
	return
	
SubtrX:
;	bcf			STATUS, C
;	rrf			xRawH, f				; half value to reduce mouse change
	movf		offset, w				
	subwf		xRawH, w				; xRawH - 11 -> w
	movwf		xMov
	return



ReadY:
		; Buffer
	btfsc		iTiltY					; Wait for Tilt Sensor to go low
	goto		$-1
	btfss		iTiltY					; Wait for Tilt Sensor to go high
	goto		$-1
	clrf		yRaw					
	clrf		yRawH
		; Counter
	incf		yRaw, f					; increment as duty cycle counter
	btfsc		STATUS, Z				; check if xRaw (least significant) overflows
	call		IncrYHigh				; increment high bits when xRaw overflows
	btfsc		iTiltY					; keep checking until Tilt Sensor falls (duty cycle done)
	goto		$-4
	return
IncrYHigh:
	incf		yRawH, f
	movlw		.230						; low bits shift control (to move significant bits to higher variable)
	movwf		yRaw
	return
	
SubtrY:
;	bcf			STATUS, C				
;	rrf			yRawH, f				; half value to reduce mouse change
	movf		yRawH, w				
	subwf		offset, w				; 11 - yRawH -> w			NOTE: 2's COMPLEMENT
	movwf		yMov					
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

