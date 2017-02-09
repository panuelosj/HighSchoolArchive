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
;																		*
;	Microsoft Serial Mouse Protocol:									*
;		Data in 3-byte packets											*
;																		*
;		Bit:		7	6	5	4	3	2	1	0						*
;		Byte0:		1	1	LB	RB	Y7	Y6	X7	X6						*
;		Byte1:		1	0	X5	X4	X3	X2	X1	X0						*
;		Byte2:		1	0	Y5	Y4	Y3	Y2	Y1	Y0						*
;																		*
;																		*
;		Initialized by sending ASCII 'M' when RTS toggled				*
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
		
	;-----------|X AXIS|----------------------------------------------
	call		ReadX					; read tilt sensor for raw data
	call		SubtrX					; do math to fix data
	;-----------|Y AXIS|----------------------------------------------
	call		ReadY					; read tilt sensor for raw data
	call		SubtrY					; do math to fix data
	
	;-----------|BYTE 0 of PACKET - Direction + Button States|--------
	movlw		b'11000000'				; initial values
	movwf		Byte0
	btfsc		xMov, 6					; move highest two bits of x here
	bsf			Byte0, 0
	btfsc		xMov, 7
	bsf			Byte0, 1
	btfsc		yMov, 6					; move highest two bits of y here
	bsf			Byte0, 2
	btfsc		yMov, 7
	bsf			Byte0, 3
	
	bcf			Byte0, 4
	bcf			Byte0, 5
	btfsc		iRightB					; right mouse button
	bsf			Byte0, 4
	btfsc		iLeftB					; left mouse button
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
	
	
	;-----------|SENSITIVITY TOGGLE|----------------------------------
		movlw		nOffset
		movwf		offset
		movlw		nUpperBound
		movwf		upperBound
		movlw		nLowerBound
		movwf		lowerBound
		movlw		nShiftCtrl
		movwf		shiftCtrl
	btfsc		iSensTog
	goto		$+9
		movlw		sOffset
		movwf		offset
		movlw		sUpperBound
		movwf		upperBound
		movlw		sLowerBound
		movwf		lowerBound
		movlw		sShiftCtrl
		movwf		shiftCtrl	
	
	goto		Main				; infinite loop
	;-----------|INFINITE LOOP|---------------------------------------	
	
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
	movf		shiftCtrl, w			; low bits shift control (to move significant bits to higher variable)
	movwf		xRaw
	return
	
SubtrX:
	clrf		xMov					; set x change to 0, for use with dead-zone
	movf		xRawH, w				
	subwf		upperBound, w			; test if value > upperBound
	btfsc		STATUS, C				; C = 0 when W > f, aka value > upperBound
	goto		$+4
		movf		upperBound, w
		subwf		xRawH, w
		movwf		xMov	
	movf		lowerBound, w
	subwf		xRawH, w				; test if value < lowerBound
	btfss		STATUS, C				; C = 0 when W > f, aka value < lowerBound
		movwf		xMov
		
;	clrf		xRawH					; reverse sign of X
;	btfss		xMov,0						; invert all digits, add 1 (2's Complement)
;	bsf			xRawH, 0
;	btfss		xMov,1
;	bsf			xRawH, 1
;	btfss		xMov,2
;	bsf			xRawH, 2
;	btfss		xMov,3
;	bsf			xRawH, 3
;	btfss		xMov,4
;	bsf			xRawH, 4
;	btfss		xMov,5
;	bsf			xRawH, 5
;	btfss		xMov,6
;	bsf			xRawH, 6
;	btfss		xMov,7
;	bsf			xRawH, 7
;	movf		xRawH, w
;	movwf		xMov
;	incf		xMov
	
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
	movf		shiftCtrl, w			; low bits shift control (to move significant bits to higher variable)
	movwf		yRaw
	return
	
SubtrY:
				
	
	
	clrf		yMov					; set y change to 0, for use with dead-zone
	movf		yRawH, w				
	subwf		upperBound, w			; test if value > upperBound
	btfsc		STATUS, C				; C = 0 when W > f, aka value > upperBound
	goto		$+4
		movf		upperBound, w
		subwf		yRawH, w
		movwf		yMov	
	
	movf		lowerBound, w
	subwf		yRawH, w				; test if value < lowerBound
	btfss		STATUS, C				; C = 0 when W > f, aka value < lowerBound
		movwf		yMov	
	
	;movf		yMov, w
;	sublw		.255
;	movwf		yMov
;	incf		yMov
;	clrf		yRawH					; reverse sign of Y
;	btfss		yMov,0						; invert all digits, add 1 (2's Complement)
;	bsf			yRawH, 0
;	btfss		yMov,1
;	bsf			yRawH, 1
;	btfss		yMov,2
;	bsf			yRawH, 2
;	btfss		yMov,3
;	bsf			yRawH, 3
;	btfss		yMov,4
;	bsf			yRawH, 4
;	btfss		yMov,5
;	bsf			yRawH, 5
;	btfss		yMov,6
;	bsf			yRawH, 6
;	btfss		yMov,7
;	bsf			yRawH, 7
;	movf		yRawH, w
;	movwf		yMov
;	incf		yMov

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

