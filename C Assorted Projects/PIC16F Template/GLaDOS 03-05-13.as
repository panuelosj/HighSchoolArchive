opt subtitle "HI-TECH Software Omniscient Code Generator (Lite mode) build 10920"

opt pagewidth 120

	opt lm

	processor	16F690
clrc	macro
	bcf	3,0
	endm
clrz	macro
	bcf	3,2
	endm
setc	macro
	bsf	3,0
	endm
setz	macro
	bsf	3,2
	endm
skipc	macro
	btfss	3,0
	endm
skipz	macro
	btfss	3,2
	endm
skipnc	macro
	btfsc	3,0
	endm
skipnz	macro
	btfsc	3,2
	endm
indf	equ	0
indf0	equ	0
pc	equ	2
pcl	equ	2
status	equ	3
fsr	equ	4
fsr0	equ	4
c	equ	1
z	equ	0
pclath	equ	10
# 32 "C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
	psect config,class=CONFIG,delta=2 ;#
# 32 "C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
	dw 0xFFFC & 0xFFF7 & 0xFFFF & 0xFFDF & 0xFFFF & 0xFFFF & 0xFCFF & 0xFBFF & 0xF7FF ;#
	FNCALL	_main,_init_hardware
	FNCALL	_main,_ADC_convert
	FNCALL	_main,_PID_controller
	FNCALL	_main,_PWM_PID_convert
	FNCALL	_main,_black_black_check
	FNCALL	_main,_PWM_reset
	FNCALL	_main,_PWM_check
	FNCALL	_main,_move_stop
	FNCALL	_black_black_check,_move_forwards_aLittle
	FNCALL	_black_black_check,_servo_off
	FNCALL	_black_black_check,_move_stop
	FNCALL	_black_black_check,_servo_on
	FNCALL	_black_black_check,_move_180
	FNCALL	_move_180,_ADC_convert
	FNCALL	_PID_controller,___wmul
	FNCALL	_PID_controller,___awdiv
	FNCALL	_ADC_convert,___wmul
	FNCALL	_ADC_convert,___awdiv
	FNROOT	_main
	global	_dutyMotorL
	global	_dutyMotorR
	global	_statMotorL
	global	_statMotorR
psect	idataBANK0,class=CODE,space=0,delta=2
global __pidataBANK0
__pidataBANK0:
	file	"C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
	line	95

;initializer for _dutyMotorL
	retlw	05Ah
	retlw	0

	line	94

;initializer for _dutyMotorR
	retlw	05Ah
	retlw	0

	line	93

;initializer for _statMotorL
	retlw	01h
	retlw	0

	line	92

;initializer for _statMotorR
	retlw	01h
	retlw	0

	global	_D_turn
	global	_I_turn
	global	_PWMCounter
	global	_P_turn
	global	_blackBlackCounter
	global	_changeCounter
	global	_i
	global	_integralError
	global	_loopExit
	global	_pastError
	global	_readSensL
	global	_readSensR
	global	_derivativeError
	global	_error
	global	_totalTurn
	global	_ADCON0
_ADCON0	set	31
	global	_ADRESH
_ADRESH	set	30
	global	_PORTA
_PORTA	set	5
	global	_PORTB
_PORTB	set	6
	global	_PORTC
_PORTC	set	7
	global	_CARRY
_CARRY	set	24
	global	_GIE
_GIE	set	95
	global	_GO_nDONE
_GO_nDONE	set	249
	global	_RA2
_RA2	set	42
	global	_RB6
_RB6	set	54
	global	_RC0
_RC0	set	56
	global	_RC2
_RC2	set	58
	global	_RC3
_RC3	set	59
	global	_RC4
_RC4	set	60
	global	_RC5
_RC5	set	61
	global	_RC6
_RC6	set	62
	global	_RC7
_RC7	set	63
	global	_TRISA
_TRISA	set	133
	global	_TRISB
_TRISB	set	134
	global	_TRISC
_TRISC	set	135
	global	_IRCF0
_IRCF0	set	1148
	global	_IRCF1
_IRCF1	set	1149
	global	_IRCF2
_IRCF2	set	1150
	global	_ANSEL
_ANSEL	set	286
	global	_ANSELH
_ANSELH	set	287
	global	_EEADR
_EEADR	set	269
	global	_EEDATA
_EEDATA	set	268
	global	_EECON1
_EECON1	set	396
	global	_EECON2
_EECON2	set	397
	global	_RD
_RD	set	3168
	global	_WR
_WR	set	3169
	global	_WREN
_WREN	set	3170
	file	"GLaDOS 03-05-13.as"
	line	#
psect cinit,class=CODE,delta=2
global start_initialization
start_initialization:

psect	bssBANK0,class=BANK0,space=1
global __pbssBANK0
__pbssBANK0:
_D_turn:
       ds      2

_I_turn:
       ds      2

_PWMCounter:
       ds      2

_P_turn:
       ds      2

_blackBlackCounter:
       ds      2

_changeCounter:
       ds      2

_i:
       ds      2

_integralError:
       ds      2

_loopExit:
       ds      2

_pastError:
       ds      2

_readSensL:
       ds      2

_readSensR:
       ds      2

_derivativeError:
       ds      2

_error:
       ds      2

_totalTurn:
       ds      2

psect	dataBANK0,class=BANK0,space=1
global __pdataBANK0
__pdataBANK0:
	file	"C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
	line	95
_dutyMotorL:
       ds      2

psect	dataBANK0
	file	"C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
	line	94
_dutyMotorR:
       ds      2

psect	dataBANK0
	file	"C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
	line	93
_statMotorL:
       ds      2

psect	dataBANK0
	file	"C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
	line	92
_statMotorR:
       ds      2

psect clrtext,class=CODE,delta=2
global clear_ram
;	Called with FSR containing the base address, and
;	W with the last address+1
clear_ram:
	clrwdt			;clear the watchdog before getting into this loop
clrloop:
	clrf	indf		;clear RAM location pointed to by FSR
	incf	fsr,f		;increment pointer
	xorwf	fsr,w		;XOR with final address
	btfsc	status,2	;have we reached the end yet?
	retlw	0		;all done for this memory range, return
	xorwf	fsr,w		;XOR again to restore value
	goto	clrloop		;do the next byte

; Clear objects allocated to BANK0
psect cinit,class=CODE,delta=2
	bcf	status, 7	;select IRP bank0
	movlw	low(__pbssBANK0)
	movwf	fsr
	movlw	low((__pbssBANK0)+01Eh)
	fcall	clear_ram
; Initialize objects allocated to BANK0
	global __pidataBANK0
psect cinit,class=CODE,delta=2
	fcall	__pidataBANK0+0		;fetch initializer
	movwf	__pdataBANK0+0&07fh		
	fcall	__pidataBANK0+1		;fetch initializer
	movwf	__pdataBANK0+1&07fh		
	fcall	__pidataBANK0+2		;fetch initializer
	movwf	__pdataBANK0+2&07fh		
	fcall	__pidataBANK0+3		;fetch initializer
	movwf	__pdataBANK0+3&07fh		
	fcall	__pidataBANK0+4		;fetch initializer
	movwf	__pdataBANK0+4&07fh		
	fcall	__pidataBANK0+5		;fetch initializer
	movwf	__pdataBANK0+5&07fh		
	fcall	__pidataBANK0+6		;fetch initializer
	movwf	__pdataBANK0+6&07fh		
	fcall	__pidataBANK0+7		;fetch initializer
	movwf	__pdataBANK0+7&07fh		
psect cinit,class=CODE,delta=2
global end_of_initialization

;End of C runtime variable initialization code

end_of_initialization:
clrf status
ljmp _main	;jump to C main() function
psect	cstackCOMMON,class=COMMON,space=1
global __pcstackCOMMON
__pcstackCOMMON:
	global	?_init_hardware
?_init_hardware:	; 0 bytes @ 0x0
	global	??_init_hardware
??_init_hardware:	; 0 bytes @ 0x0
	global	?_ADC_convert
?_ADC_convert:	; 0 bytes @ 0x0
	global	?_PID_controller
?_PID_controller:	; 0 bytes @ 0x0
	global	?_PWM_PID_convert
?_PWM_PID_convert:	; 0 bytes @ 0x0
	global	??_PWM_PID_convert
??_PWM_PID_convert:	; 0 bytes @ 0x0
	global	?_black_black_check
?_black_black_check:	; 0 bytes @ 0x0
	global	?_PWM_reset
?_PWM_reset:	; 0 bytes @ 0x0
	global	??_PWM_reset
??_PWM_reset:	; 0 bytes @ 0x0
	global	?_PWM_check
?_PWM_check:	; 0 bytes @ 0x0
	global	??_PWM_check
??_PWM_check:	; 0 bytes @ 0x0
	global	?_move_stop
?_move_stop:	; 0 bytes @ 0x0
	global	??_move_stop
??_move_stop:	; 0 bytes @ 0x0
	global	?_move_forwards_aLittle
?_move_forwards_aLittle:	; 0 bytes @ 0x0
	global	??_move_forwards_aLittle
??_move_forwards_aLittle:	; 0 bytes @ 0x0
	global	?_servo_off
?_servo_off:	; 0 bytes @ 0x0
	global	??_servo_off
??_servo_off:	; 0 bytes @ 0x0
	global	?_servo_on
?_servo_on:	; 0 bytes @ 0x0
	global	??_servo_on
??_servo_on:	; 0 bytes @ 0x0
	global	?_move_180
?_move_180:	; 0 bytes @ 0x0
	global	?_main
?_main:	; 0 bytes @ 0x0
	global	?___wmul
?___wmul:	; 2 bytes @ 0x0
	global	___wmul@multiplier
___wmul@multiplier:	; 2 bytes @ 0x0
	ds	2
	global	___wmul@multiplicand
___wmul@multiplicand:	; 2 bytes @ 0x2
	ds	2
	global	??___wmul
??___wmul:	; 0 bytes @ 0x4
	global	___wmul@product
___wmul@product:	; 2 bytes @ 0x4
	ds	2
	global	?___awdiv
?___awdiv:	; 2 bytes @ 0x6
	global	___awdiv@divisor
___awdiv@divisor:	; 2 bytes @ 0x6
	ds	2
	global	___awdiv@dividend
___awdiv@dividend:	; 2 bytes @ 0x8
	ds	2
	global	??___awdiv
??___awdiv:	; 0 bytes @ 0xA
	ds	1
	global	??_ADC_convert
??_ADC_convert:	; 0 bytes @ 0xB
	global	??_PID_controller
??_PID_controller:	; 0 bytes @ 0xB
	ds	2
psect	cstackBANK0,class=BANK0,space=1
global __pcstackBANK0
__pcstackBANK0:
	global	___awdiv@counter
___awdiv@counter:	; 1 bytes @ 0x0
	ds	1
	global	___awdiv@sign
___awdiv@sign:	; 1 bytes @ 0x1
	ds	1
	global	___awdiv@quotient
___awdiv@quotient:	; 2 bytes @ 0x2
	ds	2
	global	??_move_180
??_move_180:	; 0 bytes @ 0x4
	ds	3
	global	??_black_black_check
??_black_black_check:	; 0 bytes @ 0x7
	ds	3
	global	??_main
??_main:	; 0 bytes @ 0xA
	ds	3
;;Data sizes: Strings 0, constant 0, data 8, bss 30, persistent 0 stack 0
;;Auto spaces:   Size  Autos    Used
;; COMMON          14     13      13
;; BANK0           80     13      51
;; BANK1           80      0       0
;; BANK2           80      0       0

;;
;; Pointer list with targets:

;; ?___wmul	unsigned int  size(1) Largest target is 0
;;
;; ?___awdiv	int  size(1) Largest target is 0
;;


;;
;; Critical Paths under _main in COMMON
;;
;;   _main->_ADC_convert
;;   _main->_PID_controller
;;   _move_180->_ADC_convert
;;   _PID_controller->___awdiv
;;   _ADC_convert->___awdiv
;;   ___awdiv->___wmul
;;
;; Critical Paths under _main in BANK0
;;
;;   _main->_black_black_check
;;   _black_black_check->_move_180
;;   _PID_controller->___awdiv
;;   _ADC_convert->___awdiv
;;
;; Critical Paths under _main in BANK1
;;
;;   None.
;;
;; Critical Paths under _main in BANK2
;;
;;   None.

;;
;;Main: autosize = 0, tempsize = 3, incstack = 0, save=0
;;

;;
;;Call Graph Tables:
;;
;; ---------------------------------------------------------------------------------
;; (Depth) Function   	        Calls       Base Space   Used Autos Params    Refs
;; ---------------------------------------------------------------------------------
;; (0) _main                                                 3     3      0    1176
;;                                             10 BANK0      3     3      0
;;                      _init_hardware
;;                        _ADC_convert
;;                     _PID_controller
;;                    _PWM_PID_convert
;;                  _black_black_check
;;                          _PWM_reset
;;                          _PWM_check
;;                          _move_stop
;; ---------------------------------------------------------------------------------
;; (1) _black_black_check                                    3     3      0     392
;;                                              7 BANK0      3     3      0
;;              _move_forwards_aLittle
;;                          _servo_off
;;                          _move_stop
;;                           _servo_on
;;                           _move_180
;; ---------------------------------------------------------------------------------
;; (2) _move_180                                             3     3      0     392
;;                                              4 BANK0      3     3      0
;;                        _ADC_convert
;; ---------------------------------------------------------------------------------
;; (2) _move_forwards_aLittle                                3     3      0       0
;;                                              0 COMMON     3     3      0
;; ---------------------------------------------------------------------------------
;; (1) _PID_controller                                       2     2      0     392
;;                                             11 COMMON     2     2      0
;;                             ___wmul
;;                            ___awdiv
;; ---------------------------------------------------------------------------------
;; (3) _ADC_convert                                          2     2      0     392
;;                                             11 COMMON     2     2      0
;;                             ___wmul
;;                            ___awdiv
;; ---------------------------------------------------------------------------------
;; (4) ___awdiv                                              9     5      4     300
;;                                              6 COMMON     5     1      4
;;                                              0 BANK0      4     4      0
;;                             ___wmul (ARG)
;; ---------------------------------------------------------------------------------
;; (4) ___wmul                                               6     2      4      92
;;                                              0 COMMON     6     2      4
;; ---------------------------------------------------------------------------------
;; (2) _servo_on                                             0     0      0       0
;; ---------------------------------------------------------------------------------
;; (2) _servo_off                                            0     0      0       0
;; ---------------------------------------------------------------------------------
;; (1) _move_stop                                            0     0      0       0
;; ---------------------------------------------------------------------------------
;; (1) _PWM_check                                            1     1      0       0
;;                                              0 COMMON     1     1      0
;; ---------------------------------------------------------------------------------
;; (1) _PWM_reset                                            0     0      0       0
;; ---------------------------------------------------------------------------------
;; (1) _PWM_PID_convert                                      2     2      0       0
;;                                              0 COMMON     2     2      0
;; ---------------------------------------------------------------------------------
;; (1) _init_hardware                                        0     0      0       0
;; ---------------------------------------------------------------------------------
;; Estimated maximum stack depth 4
;; ---------------------------------------------------------------------------------

;; Call Graph Graphs:

;; _main (ROOT)
;;   _init_hardware
;;   _ADC_convert
;;     ___wmul
;;     ___awdiv
;;       ___wmul (ARG)
;;   _PID_controller
;;     ___wmul
;;     ___awdiv
;;       ___wmul (ARG)
;;   _PWM_PID_convert
;;   _black_black_check
;;     _move_forwards_aLittle
;;     _servo_off
;;     _move_stop
;;     _servo_on
;;     _move_180
;;       _ADC_convert
;;         ___wmul
;;         ___awdiv
;;           ___wmul (ARG)
;;   _PWM_reset
;;   _PWM_check
;;   _move_stop
;;

;; Address spaces:

;;Name               Size   Autos  Total    Cost      Usage
;;SFR3                 0      0       0       4        0.0%
;;BITSFR3              0      0       0       4        0.0%
;;BANK2               50      0       0       7        0.0%
;;BITBANK2            50      0       0       6        0.0%
;;SFR2                 0      0       0       5        0.0%
;;BITSFR2              0      0       0       5        0.0%
;;SFR1                 0      0       0       2        0.0%
;;BITSFR1              0      0       0       2        0.0%
;;BANK1               50      0       0       5        0.0%
;;BITBANK1            50      0       0       4        0.0%
;;CODE                 0      0       0       0        0.0%
;;DATA                 0      0      44      10        0.0%
;;ABS                  0      0      40       8        0.0%
;;NULL                 0      0       0       0        0.0%
;;STACK                0      0       4       2        0.0%
;;BANK0               50      D      33       3       63.8%
;;BITBANK0            50      0       0       9        0.0%
;;SFR0                 0      0       0       1        0.0%
;;BITSFR0              0      0       0       1        0.0%
;;COMMON               E      D       D       1       92.9%
;;BITCOMMON            E      0       0       0        0.0%
;;EEDATA             100      0       0       0        0.0%

	global	_main
psect	maintext,global,class=CODE,delta=2
global __pmaintext
__pmaintext:

;; *************** function _main *****************
;; Defined at:
;;		line 122 in file "C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;		None               void
;; Registers used:
;;		wreg, status,2, status,0, btemp+1, pclath, cstack
;; Tracked objects:
;;		On entry : 17F/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMMON   BANK0   BANK1   BANK2
;;      Params:         0       0       0       0
;;      Locals:         0       0       0       0
;;      Temps:          0       3       0       0
;;      Totals:         0       3       0       0
;;Total ram usage:        3 bytes
;; Hardware stack levels required when called:    4
;; This function calls:
;;		_init_hardware
;;		_ADC_convert
;;		_PID_controller
;;		_PWM_PID_convert
;;		_black_black_check
;;		_PWM_reset
;;		_PWM_check
;;		_move_stop
;; This function is called by:
;;		Startup code after reset
;; This function uses a non-reentrant model
;;
psect	maintext
	file	"C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
	line	122
	global	__size_of_main
	__size_of_main	equ	__end_of_main-_main
	
_main:	
	opt	stack 4
; Regs used in _main: [wreg+status,2+status,0+btemp+1+pclath+cstack]
	line	123
	
l3681:	
;robot test 2 - Ch2 yes servo.c: 123: init_hardware();
	fcall	_init_hardware
	line	125
	
l3683:	
;robot test 2 - Ch2 yes servo.c: 125: RB6 = 1;
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	bsf	(54/8),(54)&7
	line	126
;robot test 2 - Ch2 yes servo.c: 126: while(RC7 == 0){}
	goto	l951
	
l952:	
	
l951:	
	btfss	(63/8),(63)&7
	goto	u2851
	goto	u2850
u2851:
	goto	l951
u2850:
	
l953:	
	line	127
;robot test 2 - Ch2 yes servo.c: 127: RB6 = 0;
	bcf	(54/8),(54)&7
	line	128
	
l3685:	
;robot test 2 - Ch2 yes servo.c: 128: loopExit = 1;
	movlw	low(01h)
	movwf	(_loopExit)
	movlw	high(01h)
	movwf	((_loopExit))+1
	line	130
;robot test 2 - Ch2 yes servo.c: 130: while(loopExit == 1)
	goto	l3697
	
l955:	
	line	132
	
l3687:	
;robot test 2 - Ch2 yes servo.c: 131: {
;robot test 2 - Ch2 yes servo.c: 132: if(PWMCounter < 99)
	movf	(_PWMCounter+1),w
	xorlw	80h
	movwf	btemp+1
	movlw	(high(063h))^80h
	subwf	btemp+1,w
	skipz
	goto	u2865
	movlw	low(063h)
	subwf	(_PWMCounter),w
u2865:

	skipnc
	goto	u2861
	goto	u2860
u2861:
	goto	l3691
u2860:
	line	134
	
l3689:	
;robot test 2 - Ch2 yes servo.c: 133: {
;robot test 2 - Ch2 yes servo.c: 134: PWMCounter++;
	movlw	low(01h)
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	addwf	(_PWMCounter),f
	skipnc
	incf	(_PWMCounter+1),f
	movlw	high(01h)
	addwf	(_PWMCounter+1),f
	line	135
;robot test 2 - Ch2 yes servo.c: 135: }
	goto	l957
	line	136
	
l956:	
	line	138
	
l3691:	
;robot test 2 - Ch2 yes servo.c: 136: else
;robot test 2 - Ch2 yes servo.c: 137: {
;robot test 2 - Ch2 yes servo.c: 138: ADC_convert();
	fcall	_ADC_convert
	line	139
;robot test 2 - Ch2 yes servo.c: 139: PID_controller();
	fcall	_PID_controller
	line	140
	
l3693:	
;robot test 2 - Ch2 yes servo.c: 140: PWM_PID_convert();
	fcall	_PWM_PID_convert
	line	141
	
l3695:	
;robot test 2 - Ch2 yes servo.c: 141: black_black_check();
	fcall	_black_black_check
	line	142
;robot test 2 - Ch2 yes servo.c: 142: PWM_reset();
	fcall	_PWM_reset
	line	143
	
l957:	
	line	144
;robot test 2 - Ch2 yes servo.c: 143: }
;robot test 2 - Ch2 yes servo.c: 144: PWM_check();
	fcall	_PWM_check
	goto	l3697
	line	145
	
l954:	
	line	130
	
l3697:	
	movlw	01h
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	xorwf	(_loopExit),w
	iorwf	(_loopExit+1),w
	skipnz
	goto	u2871
	goto	u2870
u2871:
	goto	l3687
u2870:
	goto	l3699
	
l958:	
	line	147
	
l3699:	
;robot test 2 - Ch2 yes servo.c: 145: }
;robot test 2 - Ch2 yes servo.c: 147: move_stop();
	fcall	_move_stop
	line	148
	
l3701:	
;robot test 2 - Ch2 yes servo.c: 148: integralError = 0;
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	clrf	(_integralError)
	clrf	(_integralError+1)
	line	149
	
l3703:	
;robot test 2 - Ch2 yes servo.c: 149: pastError = 0;
	clrf	(_pastError)
	clrf	(_pastError+1)
	line	150
	
l3705:	
;robot test 2 - Ch2 yes servo.c: 150: _delay(999999);
	opt asmopt_off
movlw  6
movwf	((??_main+0)+0+2),f
movlw	19
movwf	((??_main+0)+0+1),f
	movlw	177
movwf	((??_main+0)+0),f
u2887:
	decfsz	((??_main+0)+0),f
	goto	u2887
	decfsz	((??_main+0)+0+1),f
	goto	u2887
	decfsz	((??_main+0)+0+2),f
	goto	u2887
	clrwdt
opt asmopt_on

	line	152
	
l959:	
	global	start
	ljmp	start
	opt stack 0
GLOBAL	__end_of_main
	__end_of_main:
;; =============== function _main ends ============

	signat	_main,88
	global	_black_black_check
psect	text388,local,class=CODE,delta=2
global __ptext388
__ptext388:

;; *************** function _black_black_check *****************
;; Defined at:
;;		line 176 in file "C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;		None               void
;; Registers used:
;;		wreg, status,2, status,0, btemp+1, pclath, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMMON   BANK0   BANK1   BANK2
;;      Params:         0       0       0       0
;;      Locals:         0       0       0       0
;;      Temps:          0       3       0       0
;;      Totals:         0       3       0       0
;;Total ram usage:        3 bytes
;; Hardware stack levels used:    1
;; Hardware stack levels required when called:    3
;; This function calls:
;;		_move_forwards_aLittle
;;		_servo_off
;;		_move_stop
;;		_servo_on
;;		_move_180
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text388
	file	"C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
	line	176
	global	__size_of_black_black_check
	__size_of_black_black_check	equ	__end_of_black_black_check-_black_black_check
	
_black_black_check:	
	opt	stack 4
; Regs used in _black_black_check: [wreg+status,2+status,0+btemp+1+pclath+cstack]
	line	177
	
l3629:	
;robot test 2 - Ch2 yes servo.c: 177: if(readSensL >= 0b11000111 && readSensR >= 0b11000111)
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movf	(_readSensL+1),w
	xorlw	80h
	movwf	btemp+1
	movlw	(high(0C7h))^80h
	subwf	btemp+1,w
	skipz
	goto	u2755
	movlw	low(0C7h)
	subwf	(_readSensL),w
u2755:

	skipc
	goto	u2751
	goto	u2750
u2751:
	goto	l3679
u2750:
	
l3631:	
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movf	(_readSensR+1),w
	xorlw	80h
	movwf	btemp+1
	movlw	(high(0C7h))^80h
	subwf	btemp+1,w
	skipz
	goto	u2765
	movlw	low(0C7h)
	subwf	(_readSensR),w
u2765:

	skipc
	goto	u2761
	goto	u2760
u2761:
	goto	l3679
u2760:
	line	179
	
l3633:	
;robot test 2 - Ch2 yes servo.c: 178: {
;robot test 2 - Ch2 yes servo.c: 179: changeCounter++;
	movlw	low(01h)
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	addwf	(_changeCounter),f
	skipnc
	incf	(_changeCounter+1),f
	movlw	high(01h)
	addwf	(_changeCounter+1),f
	line	180
	
l3635:	
;robot test 2 - Ch2 yes servo.c: 180: if(changeCounter > 10)
	movf	(_changeCounter+1),w
	xorlw	80h
	movwf	btemp+1
	movlw	(high(0Bh))^80h
	subwf	btemp+1,w
	skipz
	goto	u2775
	movlw	low(0Bh)
	subwf	(_changeCounter),w
u2775:

	skipc
	goto	u2771
	goto	u2770
u2771:
	goto	l984
u2770:
	line	182
	
l3637:	
;robot test 2 - Ch2 yes servo.c: 181: {
;robot test 2 - Ch2 yes servo.c: 182: changeCounter = 0;
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	clrf	(_changeCounter)
	clrf	(_changeCounter+1)
	line	183
	
l3639:	
;robot test 2 - Ch2 yes servo.c: 183: blackBlackCounter++;
	movlw	low(01h)
	addwf	(_blackBlackCounter),f
	skipnc
	incf	(_blackBlackCounter+1),f
	movlw	high(01h)
	addwf	(_blackBlackCounter+1),f
	line	186
	
l3641:	
;robot test 2 - Ch2 yes servo.c: 186: if(blackBlackCounter == 1)
	movlw	01h
	xorwf	(_blackBlackCounter),w
	iorwf	(_blackBlackCounter+1),w
	skipz
	goto	u2781
	goto	u2780
u2781:
	goto	l3647
u2780:
	line	188
	
l3643:	
;robot test 2 - Ch2 yes servo.c: 187: {
;robot test 2 - Ch2 yes servo.c: 188: move_forwards_aLittle();
	fcall	_move_forwards_aLittle
	line	189
	
l3645:	
;robot test 2 - Ch2 yes servo.c: 189: servo_off();
	fcall	_servo_off
	line	190
;robot test 2 - Ch2 yes servo.c: 190: }
	goto	l3673
	line	191
	
l973:	
	
l3647:	
;robot test 2 - Ch2 yes servo.c: 191: else if(blackBlackCounter == 2 || blackBlackCounter == 4 || blackBlackCounter == 6)
	movlw	02h
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	xorwf	(_blackBlackCounter),w
	iorwf	(_blackBlackCounter+1),w
	skipnz
	goto	u2791
	goto	u2790
u2791:
	goto	l3653
u2790:
	
l3649:	
	movlw	04h
	xorwf	(_blackBlackCounter),w
	iorwf	(_blackBlackCounter+1),w
	skipnz
	goto	u2801
	goto	u2800
u2801:
	goto	l3653
u2800:
	
l3651:	
	movlw	06h
	xorwf	(_blackBlackCounter),w
	iorwf	(_blackBlackCounter+1),w
	skipz
	goto	u2811
	goto	u2810
u2811:
	goto	l3659
u2810:
	goto	l3653
	
l977:	
	line	193
	
l3653:	
;robot test 2 - Ch2 yes servo.c: 192: {
;robot test 2 - Ch2 yes servo.c: 193: move_stop();
	fcall	_move_stop
	line	194
;robot test 2 - Ch2 yes servo.c: 194: servo_on();
	fcall	_servo_on
	line	195
	
l3655:	
;robot test 2 - Ch2 yes servo.c: 195: _delay(1000000);
	opt asmopt_off
movlw  6
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
movwf	((??_black_black_check+0)+0+2),f
movlw	19
movwf	((??_black_black_check+0)+0+1),f
	movlw	177
movwf	((??_black_black_check+0)+0),f
u2897:
	decfsz	((??_black_black_check+0)+0),f
	goto	u2897
	decfsz	((??_black_black_check+0)+0+1),f
	goto	u2897
	decfsz	((??_black_black_check+0)+0+2),f
	goto	u2897
	nop2
opt asmopt_on

	line	196
	
l3657:	
;robot test 2 - Ch2 yes servo.c: 196: move_180();
	fcall	_move_180
	line	197
;robot test 2 - Ch2 yes servo.c: 197: }
	goto	l3673
	line	198
	
l975:	
	
l3659:	
;robot test 2 - Ch2 yes servo.c: 198: else if(blackBlackCounter == 3 || blackBlackCounter == 5 || blackBlackCounter == 7)
	movlw	03h
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	xorwf	(_blackBlackCounter),w
	iorwf	(_blackBlackCounter+1),w
	skipnz
	goto	u2821
	goto	u2820
u2821:
	goto	l3665
u2820:
	
l3661:	
	movlw	05h
	xorwf	(_blackBlackCounter),w
	iorwf	(_blackBlackCounter+1),w
	skipnz
	goto	u2831
	goto	u2830
u2831:
	goto	l3665
u2830:
	
l3663:	
	movlw	07h
	xorwf	(_blackBlackCounter),w
	iorwf	(_blackBlackCounter+1),w
	skipz
	goto	u2841
	goto	u2840
u2841:
	goto	l3671
u2840:
	goto	l3665
	
l981:	
	line	200
	
l3665:	
;robot test 2 - Ch2 yes servo.c: 199: {
;robot test 2 - Ch2 yes servo.c: 200: move_stop();
	fcall	_move_stop
	line	201
;robot test 2 - Ch2 yes servo.c: 201: servo_off();
	fcall	_servo_off
	line	202
	
l3667:	
;robot test 2 - Ch2 yes servo.c: 202: _delay(1000000);
	opt asmopt_off
movlw  6
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
movwf	((??_black_black_check+0)+0+2),f
movlw	19
movwf	((??_black_black_check+0)+0+1),f
	movlw	177
movwf	((??_black_black_check+0)+0),f
u2907:
	decfsz	((??_black_black_check+0)+0),f
	goto	u2907
	decfsz	((??_black_black_check+0)+0+1),f
	goto	u2907
	decfsz	((??_black_black_check+0)+0+2),f
	goto	u2907
	nop2
opt asmopt_on

	line	203
	
l3669:	
;robot test 2 - Ch2 yes servo.c: 203: move_180();
	fcall	_move_180
	line	204
;robot test 2 - Ch2 yes servo.c: 204: }
	goto	l3673
	line	205
	
l979:	
	line	206
	
l3671:	
;robot test 2 - Ch2 yes servo.c: 205: else
;robot test 2 - Ch2 yes servo.c: 206: move_180();
	fcall	_move_180
	goto	l3673
	
l982:	
	goto	l3673
	
l978:	
	goto	l3673
	
l974:	
	line	208
	
l3673:	
;robot test 2 - Ch2 yes servo.c: 208: integralError = 0;
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	clrf	(_integralError)
	clrf	(_integralError+1)
	line	209
	
l3675:	
;robot test 2 - Ch2 yes servo.c: 209: pastError = 0;
	clrf	(_pastError)
	clrf	(_pastError+1)
	line	210
	
l3677:	
;robot test 2 - Ch2 yes servo.c: 210: derivativeError = 0;
	clrf	(_derivativeError)
	clrf	(_derivativeError+1)
	goto	l984
	line	211
	
l972:	
	line	212
;robot test 2 - Ch2 yes servo.c: 211: }
;robot test 2 - Ch2 yes servo.c: 212: }
	goto	l984
	line	213
	
l971:	
	line	214
	
l3679:	
;robot test 2 - Ch2 yes servo.c: 213: else
;robot test 2 - Ch2 yes servo.c: 214: changeCounter = 0;
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	clrf	(_changeCounter)
	clrf	(_changeCounter+1)
	goto	l984
	
l983:	
	line	215
	
l984:	
	return
	opt stack 0
GLOBAL	__end_of_black_black_check
	__end_of_black_black_check:
;; =============== function _black_black_check ends ============

	signat	_black_black_check,88
	global	_move_180
psect	text389,local,class=CODE,delta=2
global __ptext389
__ptext389:

;; *************** function _move_180 *****************
;; Defined at:
;;		line 352 in file "C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;		None               void
;; Registers used:
;;		wreg, status,2, status,0, btemp+1, pclath, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMMON   BANK0   BANK1   BANK2
;;      Params:         0       0       0       0
;;      Locals:         0       0       0       0
;;      Temps:          0       3       0       0
;;      Totals:         0       3       0       0
;;Total ram usage:        3 bytes
;; Hardware stack levels used:    1
;; Hardware stack levels required when called:    2
;; This function calls:
;;		_ADC_convert
;; This function is called by:
;;		_black_black_check
;; This function uses a non-reentrant model
;;
psect	text389
	file	"C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
	line	352
	global	__size_of_move_180
	__size_of_move_180	equ	__end_of_move_180-_move_180
	
_move_180:	
	opt	stack 4
; Regs used in _move_180: [wreg+status,2+status,0+btemp+1+pclath+cstack]
	line	353
	
l3609:	
;robot test 2 - Ch2 yes servo.c: 353: RC6 = 0;
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	bcf	(62/8),(62)&7
	line	354
;robot test 2 - Ch2 yes servo.c: 354: RC3 = 1;
	bsf	(59/8),(59)&7
	line	355
;robot test 2 - Ch2 yes servo.c: 355: RC5 = 0;
	bcf	(61/8),(61)&7
	line	356
;robot test 2 - Ch2 yes servo.c: 356: RC4 = 1;
	bsf	(60/8),(60)&7
	line	357
	
l3611:	
;robot test 2 - Ch2 yes servo.c: 357: _delay(1000000*3/4);
	opt asmopt_off
movlw  4
movwf	((??_move_180+0)+0+2),f
movlw	207
movwf	((??_move_180+0)+0+1),f
	movlw	3
movwf	((??_move_180+0)+0),f
u2917:
	decfsz	((??_move_180+0)+0),f
	goto	u2917
	decfsz	((??_move_180+0)+0+1),f
	goto	u2917
	decfsz	((??_move_180+0)+0+2),f
	goto	u2917
	nop2
opt asmopt_on

	line	358
	
l3613:	
;robot test 2 - Ch2 yes servo.c: 358: RC6 = 1;
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	bsf	(62/8),(62)&7
	line	359
	
l3615:	
;robot test 2 - Ch2 yes servo.c: 359: RC3 = 0;
	bcf	(59/8),(59)&7
	line	360
	
l3617:	
;robot test 2 - Ch2 yes servo.c: 360: RC5 = 0;
	bcf	(61/8),(61)&7
	line	361
	
l3619:	
;robot test 2 - Ch2 yes servo.c: 361: RC4 = 1;
	bsf	(60/8),(60)&7
	line	362
;robot test 2 - Ch2 yes servo.c: 362: _delay(1000000*3/2);
	opt asmopt_off
movlw  8
movwf	((??_move_180+0)+0+2),f
movlw	157
movwf	((??_move_180+0)+0+1),f
	movlw	11
movwf	((??_move_180+0)+0),f
u2927:
	decfsz	((??_move_180+0)+0),f
	goto	u2927
	decfsz	((??_move_180+0)+0+1),f
	goto	u2927
	decfsz	((??_move_180+0)+0+2),f
	goto	u2927
	nop2
opt asmopt_on

	line	363
	
l3621:	
;robot test 2 - Ch2 yes servo.c: 363: ADC_convert();
	fcall	_ADC_convert
	line	364
;robot test 2 - Ch2 yes servo.c: 364: while(readSensR < 0b11100000)
	goto	l3627
	
l1025:	
	line	366
	
l3623:	
;robot test 2 - Ch2 yes servo.c: 365: {
;robot test 2 - Ch2 yes servo.c: 366: ADC_convert();
	fcall	_ADC_convert
	line	367
	
l3625:	
;robot test 2 - Ch2 yes servo.c: 367: _delay(50);
	opt asmopt_off
movlw	16
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
movwf	(??_move_180+0)+0,f
u2937:
decfsz	(??_move_180+0)+0,f
	goto	u2937
	clrwdt
opt asmopt_on

	goto	l3627
	line	368
	
l1024:	
	line	364
	
l3627:	
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movf	(_readSensR+1),w
	xorlw	80h
	movwf	btemp+1
	movlw	(high(0E0h))^80h
	subwf	btemp+1,w
	skipz
	goto	u2745
	movlw	low(0E0h)
	subwf	(_readSensR),w
u2745:

	skipc
	goto	u2741
	goto	u2740
u2741:
	goto	l3623
u2740:
	goto	l1027
	
l1026:	
	line	369
	
l1027:	
	return
	opt stack 0
GLOBAL	__end_of_move_180
	__end_of_move_180:
;; =============== function _move_180 ends ============

	signat	_move_180,88
	global	_move_forwards_aLittle
psect	text390,local,class=CODE,delta=2
global __ptext390
__ptext390:

;; *************** function _move_forwards_aLittle *****************
;; Defined at:
;;		line 343 in file "C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;		None               void
;; Registers used:
;;		wreg
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMMON   BANK0   BANK1   BANK2
;;      Params:         0       0       0       0
;;      Locals:         0       0       0       0
;;      Temps:          3       0       0       0
;;      Totals:         3       0       0       0
;;Total ram usage:        3 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_black_black_check
;; This function uses a non-reentrant model
;;
psect	text390
	file	"C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
	line	343
	global	__size_of_move_forwards_aLittle
	__size_of_move_forwards_aLittle	equ	__end_of_move_forwards_aLittle-_move_forwards_aLittle
	
_move_forwards_aLittle:	
	opt	stack 6
; Regs used in _move_forwards_aLittle: [wreg]
	line	344
	
l3605:	
;robot test 2 - Ch2 yes servo.c: 344: RC6 = 1;
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	bsf	(62/8),(62)&7
	line	345
;robot test 2 - Ch2 yes servo.c: 345: RC3 = 0;
	bcf	(59/8),(59)&7
	line	346
;robot test 2 - Ch2 yes servo.c: 346: RC5 = 1;
	bsf	(61/8),(61)&7
	line	347
;robot test 2 - Ch2 yes servo.c: 347: RC4 = 0;
	bcf	(60/8),(60)&7
	line	348
	
l3607:	
;robot test 2 - Ch2 yes servo.c: 348: _delay(800000);
	opt asmopt_off
movlw  5
movwf	((??_move_forwards_aLittle+0)+0+2),f
movlw	15
movwf	((??_move_forwards_aLittle+0)+0+1),f
	movlw	244
movwf	((??_move_forwards_aLittle+0)+0),f
u2947:
	decfsz	((??_move_forwards_aLittle+0)+0),f
	goto	u2947
	decfsz	((??_move_forwards_aLittle+0)+0+1),f
	goto	u2947
	decfsz	((??_move_forwards_aLittle+0)+0+2),f
	goto	u2947
opt asmopt_on

	line	349
	
l1021:	
	return
	opt stack 0
GLOBAL	__end_of_move_forwards_aLittle
	__end_of_move_forwards_aLittle:
;; =============== function _move_forwards_aLittle ends ============

	signat	_move_forwards_aLittle,88
	global	_PID_controller
psect	text391,local,class=CODE,delta=2
global __ptext391
__ptext391:

;; *************** function _PID_controller *****************
;; Defined at:
;;		line 219 in file "C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;		None               void
;; Registers used:
;;		wreg, status,2, status,0, pclath, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMMON   BANK0   BANK1   BANK2
;;      Params:         0       0       0       0
;;      Locals:         0       0       0       0
;;      Temps:          2       0       0       0
;;      Totals:         2       0       0       0
;;Total ram usage:        2 bytes
;; Hardware stack levels used:    1
;; Hardware stack levels required when called:    1
;; This function calls:
;;		___wmul
;;		___awdiv
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text391
	file	"C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
	line	219
	global	__size_of_PID_controller
	__size_of_PID_controller	equ	__end_of_PID_controller-_PID_controller
	
_PID_controller:	
	opt	stack 6
; Regs used in _PID_controller: [wreg+status,2+status,0+pclath+cstack]
	line	220
	
l3589:	
;robot test 2 - Ch2 yes servo.c: 220: error = readSensL - readSensR;
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	comf	(_readSensR),w
	movwf	(??_PID_controller+0)+0
	comf	(_readSensR+1),w
	movwf	((??_PID_controller+0)+0+1)
	incf	(??_PID_controller+0)+0,f
	skipnz
	incf	((??_PID_controller+0)+0+1),f
	movf	(_readSensL),w
	addwf	0+(??_PID_controller+0)+0,w
	movwf	(_error)
	movf	(_readSensL+1),w
	skipnc
	incf	(_readSensL+1),w
	addwf	1+(??_PID_controller+0)+0,w
	movwf	1+(_error)
	line	222
;robot test 2 - Ch2 yes servo.c: 222: derivativeError = error - pastError;
	comf	(_pastError),w
	movwf	(??_PID_controller+0)+0
	comf	(_pastError+1),w
	movwf	((??_PID_controller+0)+0+1)
	incf	(??_PID_controller+0)+0,f
	skipnz
	incf	((??_PID_controller+0)+0+1),f
	movf	(_error),w
	addwf	0+(??_PID_controller+0)+0,w
	movwf	(_derivativeError)
	movf	(_error+1),w
	skipnc
	incf	(_error+1),w
	addwf	1+(??_PID_controller+0)+0,w
	movwf	1+(_derivativeError)
	line	223
	
l3591:	
;robot test 2 - Ch2 yes servo.c: 223: D_turn = 700 * derivativeError;
	movf	(_derivativeError+1),w
	clrf	(?___wmul+1)
	addwf	(?___wmul+1)
	movf	(_derivativeError),w
	clrf	(?___wmul)
	addwf	(?___wmul)

	movlw	low(02BCh)
	movwf	0+(?___wmul)+02h
	movlw	high(02BCh)
	movwf	(0+(?___wmul)+02h)+1
	fcall	___wmul
	movf	(1+(?___wmul)),w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	clrf	(_D_turn+1)
	addwf	(_D_turn+1)
	movf	(0+(?___wmul)),w
	clrf	(_D_turn)
	addwf	(_D_turn)

	line	224
	
l3593:	
;robot test 2 - Ch2 yes servo.c: 224: pastError = error;
	movf	(_error+1),w
	clrf	(_pastError+1)
	addwf	(_pastError+1)
	movf	(_error),w
	clrf	(_pastError)
	addwf	(_pastError)

	line	226
	
l3595:	
;robot test 2 - Ch2 yes servo.c: 226: integralError += error;
	movf	(_error),w
	addwf	(_integralError),f
	skipnc
	incf	(_integralError+1),f
	movf	(_error+1),w
	addwf	(_integralError+1),f
	line	227
	
l3597:	
;robot test 2 - Ch2 yes servo.c: 227: I_turn = integralError * 1;
	movf	(_integralError+1),w
	clrf	(_I_turn+1)
	addwf	(_I_turn+1)
	movf	(_integralError),w
	clrf	(_I_turn)
	addwf	(_I_turn)

	line	229
	
l3599:	
;robot test 2 - Ch2 yes servo.c: 229: P_turn = 70 * error;
	movf	(_error+1),w
	clrf	(?___wmul+1)
	addwf	(?___wmul+1)
	movf	(_error),w
	clrf	(?___wmul)
	addwf	(?___wmul)

	movlw	low(046h)
	movwf	0+(?___wmul)+02h
	movlw	high(046h)
	movwf	(0+(?___wmul)+02h)+1
	fcall	___wmul
	movf	(1+(?___wmul)),w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	clrf	(_P_turn+1)
	addwf	(_P_turn+1)
	movf	(0+(?___wmul)),w
	clrf	(_P_turn)
	addwf	(_P_turn)

	line	231
	
l3601:	
;robot test 2 - Ch2 yes servo.c: 231: totalTurn = P_turn + I_turn + D_turn;
	movf	(_I_turn),w
	addwf	(_P_turn),w
	movwf	(??_PID_controller+0)+0
	movf	(_I_turn+1),w
	skipnc
	incf	(_I_turn+1),w
	addwf	(_P_turn+1),w
	movwf	1+(??_PID_controller+0)+0
	movf	(_D_turn),w
	addwf	0+(??_PID_controller+0)+0,w
	movwf	(_totalTurn)
	movf	(_D_turn+1),w
	skipnc
	incf	(_D_turn+1),w
	addwf	1+(??_PID_controller+0)+0,w
	movwf	1+(_totalTurn)
	line	232
	
l3603:	
;robot test 2 - Ch2 yes servo.c: 232: totalTurn = totalTurn / 100;
	movlw	low(064h)
	movwf	(?___awdiv)
	movlw	high(064h)
	movwf	((?___awdiv))+1
	movf	(_totalTurn+1),w
	clrf	1+(?___awdiv)+02h
	addwf	1+(?___awdiv)+02h
	movf	(_totalTurn),w
	clrf	0+(?___awdiv)+02h
	addwf	0+(?___awdiv)+02h

	fcall	___awdiv
	movf	(1+(?___awdiv)),w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	clrf	(_totalTurn+1)
	addwf	(_totalTurn+1)
	movf	(0+(?___awdiv)),w
	clrf	(_totalTurn)
	addwf	(_totalTurn)

	line	233
	
l987:	
	return
	opt stack 0
GLOBAL	__end_of_PID_controller
	__end_of_PID_controller:
;; =============== function _PID_controller ends ============

	signat	_PID_controller,88
	global	_ADC_convert
psect	text392,local,class=CODE,delta=2
global __ptext392
__ptext392:

;; *************** function _ADC_convert *****************
;; Defined at:
;;		line 158 in file "C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;		None               void
;; Registers used:
;;		wreg, status,2, status,0, pclath, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMMON   BANK0   BANK1   BANK2
;;      Params:         0       0       0       0
;;      Locals:         0       0       0       0
;;      Temps:          2       0       0       0
;;      Totals:         2       0       0       0
;;Total ram usage:        2 bytes
;; Hardware stack levels used:    1
;; Hardware stack levels required when called:    1
;; This function calls:
;;		___wmul
;;		___awdiv
;; This function is called by:
;;		_main
;;		_move_180
;; This function uses a non-reentrant model
;;
psect	text392
	file	"C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
	line	158
	global	__size_of_ADC_convert
	__size_of_ADC_convert	equ	__end_of_ADC_convert-_ADC_convert
	
_ADC_convert:	
	opt	stack 4
; Regs used in _ADC_convert: [wreg+status,2+status,0+pclath+cstack]
	line	159
	
l3573:	
;robot test 2 - Ch2 yes servo.c: 159: ADCON0 = 0b00101001;
	movlw	(029h)
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(31)	;volatile
	line	160
	
l3575:	
;robot test 2 - Ch2 yes servo.c: 160: GO_nDONE = 1;
	bsf	(249/8),(249)&7
	line	161
;robot test 2 - Ch2 yes servo.c: 161: while(GO_nDONE != 0){}
	goto	l962
	
l963:	
	
l962:	
	btfsc	(249/8),(249)&7
	goto	u2721
	goto	u2720
u2721:
	goto	l962
u2720:
	goto	l3577
	
l964:	
	line	162
	
l3577:	
;robot test 2 - Ch2 yes servo.c: 162: readSensR = ADRESH;
	movf	(30),w	;volatile
	movwf	(??_ADC_convert+0)+0
	clrf	(??_ADC_convert+0)+0+1
	movf	0+(??_ADC_convert+0)+0,w
	movwf	(_readSensR)
	movf	1+(??_ADC_convert+0)+0,w
	movwf	(_readSensR+1)
	line	164
	
l3579:	
;robot test 2 - Ch2 yes servo.c: 164: _delay(5);
		opt asmopt_off
	nop2	;2 cycle nop
	opt asmopt_on
	opt asmopt_off
	nop2	;2 cycle nop
	opt asmopt_on
	opt asmopt_off
	clrwdt
	opt asmopt_on

	line	166
;robot test 2 - Ch2 yes servo.c: 166: ADCON0 = 0b00101101;
	movlw	(02Dh)
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(31)	;volatile
	line	167
	
l3581:	
;robot test 2 - Ch2 yes servo.c: 167: GO_nDONE = 1;
	bsf	(249/8),(249)&7
	line	168
;robot test 2 - Ch2 yes servo.c: 168: while(GO_nDONE != 0){}
	goto	l965
	
l966:	
	
l965:	
	btfsc	(249/8),(249)&7
	goto	u2731
	goto	u2730
u2731:
	goto	l965
u2730:
	goto	l3583
	
l967:	
	line	169
	
l3583:	
;robot test 2 - Ch2 yes servo.c: 169: readSensL = ADRESH;
	movf	(30),w	;volatile
	movwf	(??_ADC_convert+0)+0
	clrf	(??_ADC_convert+0)+0+1
	movf	0+(??_ADC_convert+0)+0,w
	movwf	(_readSensL)
	movf	1+(??_ADC_convert+0)+0,w
	movwf	(_readSensL+1)
	line	171
	
l3585:	
;robot test 2 - Ch2 yes servo.c: 171: readSensR = readSensR * 9 / 10;
	movlw	low(0Ah)
	movwf	(?___awdiv)
	movlw	high(0Ah)
	movwf	((?___awdiv))+1
	movf	(_readSensR+1),w
	clrf	(?___wmul+1)
	addwf	(?___wmul+1)
	movf	(_readSensR),w
	clrf	(?___wmul)
	addwf	(?___wmul)

	movlw	low(09h)
	movwf	0+(?___wmul)+02h
	movlw	high(09h)
	movwf	(0+(?___wmul)+02h)+1
	fcall	___wmul
	movf	(1+(?___wmul)),w
	clrf	1+(?___awdiv)+02h
	addwf	1+(?___awdiv)+02h
	movf	(0+(?___wmul)),w
	clrf	0+(?___awdiv)+02h
	addwf	0+(?___awdiv)+02h

	fcall	___awdiv
	movf	(1+(?___awdiv)),w
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	clrf	(_readSensR+1)
	addwf	(_readSensR+1)
	movf	(0+(?___awdiv)),w
	clrf	(_readSensR)
	addwf	(_readSensR)

	line	172
	
l3587:	
;robot test 2 - Ch2 yes servo.c: 172: readSensR = readSensR + 25;
	movf	(_readSensR),w
	addlw	low(019h)
	movwf	(_readSensR)
	movf	(_readSensR+1),w
	skipnc
	addlw	1
	addlw	high(019h)
	movwf	1+(_readSensR)
	line	173
	
l968:	
	return
	opt stack 0
GLOBAL	__end_of_ADC_convert
	__end_of_ADC_convert:
;; =============== function _ADC_convert ends ============

	signat	_ADC_convert,88
	global	___awdiv
psect	text393,local,class=CODE,delta=2
global __ptext393
__ptext393:

;; *************** function ___awdiv *****************
;; Defined at:
;;		line 5 in file "C:\Program Files (x86)\HI-TECH Software\PICC\9.83\sources\awdiv.c"
;; Parameters:    Size  Location     Type
;;  divisor         2    6[COMMON] int 
;;  dividend        2    8[COMMON] int 
;; Auto vars:     Size  Location     Type
;;  quotient        2    2[BANK0 ] int 
;;  sign            1    1[BANK0 ] unsigned char 
;;  counter         1    0[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  2    6[COMMON] int 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMMON   BANK0   BANK1   BANK2
;;      Params:         4       0       0       0
;;      Locals:         0       4       0       0
;;      Temps:          1       0       0       0
;;      Totals:         5       4       0       0
;;Total ram usage:        9 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_ADC_convert
;;		_PID_controller
;; This function uses a non-reentrant model
;;
psect	text393
	file	"C:\Program Files (x86)\HI-TECH Software\PICC\9.83\sources\awdiv.c"
	line	5
	global	__size_of___awdiv
	__size_of___awdiv	equ	__end_of___awdiv-___awdiv
	
___awdiv:	
	opt	stack 4
; Regs used in ___awdiv: [wreg+status,2+status,0]
	line	9
	
l3533:	
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	clrf	(___awdiv@sign)
	line	10
	btfss	(___awdiv@divisor+1),7
	goto	u2621
	goto	u2620
u2621:
	goto	l3537
u2620:
	line	11
	
l3535:	
	comf	(___awdiv@divisor),f
	comf	(___awdiv@divisor+1),f
	incf	(___awdiv@divisor),f
	skipnz
	incf	(___awdiv@divisor+1),f
	line	12
	clrf	(___awdiv@sign)
	bsf	status,0
	rlf	(___awdiv@sign),f
	goto	l3537
	line	13
	
l2035:	
	line	14
	
l3537:	
	btfss	(___awdiv@dividend+1),7
	goto	u2631
	goto	u2630
u2631:
	goto	l3543
u2630:
	line	15
	
l3539:	
	comf	(___awdiv@dividend),f
	comf	(___awdiv@dividend+1),f
	incf	(___awdiv@dividend),f
	skipnz
	incf	(___awdiv@dividend+1),f
	line	16
	
l3541:	
	movlw	(01h)
	movwf	(??___awdiv+0)+0
	movf	(??___awdiv+0)+0,w
	xorwf	(___awdiv@sign),f
	goto	l3543
	line	17
	
l2036:	
	line	18
	
l3543:	
	clrf	(___awdiv@quotient)
	clrf	(___awdiv@quotient+1)
	line	19
	
l3545:	
	movf	(___awdiv@divisor+1),w
	iorwf	(___awdiv@divisor),w
	skipnz
	goto	u2641
	goto	u2640
u2641:
	goto	l3565
u2640:
	line	20
	
l3547:	
	clrf	(___awdiv@counter)
	bsf	status,0
	rlf	(___awdiv@counter),f
	line	21
	goto	l3553
	
l2039:	
	line	22
	
l3549:	
	movlw	01h
	
u2655:
	clrc
	rlf	(___awdiv@divisor),f
	rlf	(___awdiv@divisor+1),f
	addlw	-1
	skipz
	goto	u2655
	line	23
	
l3551:	
	movlw	(01h)
	movwf	(??___awdiv+0)+0
	movf	(??___awdiv+0)+0,w
	addwf	(___awdiv@counter),f
	goto	l3553
	line	24
	
l2038:	
	line	21
	
l3553:	
	btfss	(___awdiv@divisor+1),(15)&7
	goto	u2661
	goto	u2660
u2661:
	goto	l3549
u2660:
	goto	l3555
	
l2040:	
	goto	l3555
	line	25
	
l2041:	
	line	26
	
l3555:	
	movlw	01h
	
u2675:
	clrc
	rlf	(___awdiv@quotient),f
	rlf	(___awdiv@quotient+1),f
	addlw	-1
	skipz
	goto	u2675
	line	27
	movf	(___awdiv@divisor+1),w
	subwf	(___awdiv@dividend+1),w
	skipz
	goto	u2685
	movf	(___awdiv@divisor),w
	subwf	(___awdiv@dividend),w
u2685:
	skipc
	goto	u2681
	goto	u2680
u2681:
	goto	l3561
u2680:
	line	28
	
l3557:	
	movf	(___awdiv@divisor),w
	subwf	(___awdiv@dividend),f
	movf	(___awdiv@divisor+1),w
	skipc
	decf	(___awdiv@dividend+1),f
	subwf	(___awdiv@dividend+1),f
	line	29
	
l3559:	
	bsf	(___awdiv@quotient)+(0/8),(0)&7
	goto	l3561
	line	30
	
l2042:	
	line	31
	
l3561:	
	movlw	01h
	
u2695:
	clrc
	rrf	(___awdiv@divisor+1),f
	rrf	(___awdiv@divisor),f
	addlw	-1
	skipz
	goto	u2695
	line	32
	
l3563:	
	movlw	low(01h)
	subwf	(___awdiv@counter),f
	btfss	status,2
	goto	u2701
	goto	u2700
u2701:
	goto	l3555
u2700:
	goto	l3565
	
l2043:	
	goto	l3565
	line	33
	
l2037:	
	line	34
	
l3565:	
	movf	(___awdiv@sign),w
	skipz
	goto	u2710
	goto	l3569
u2710:
	line	35
	
l3567:	
	comf	(___awdiv@quotient),f
	comf	(___awdiv@quotient+1),f
	incf	(___awdiv@quotient),f
	skipnz
	incf	(___awdiv@quotient+1),f
	goto	l3569
	
l2044:	
	line	36
	
l3569:	
	movf	(___awdiv@quotient+1),w
	clrf	(?___awdiv+1)
	addwf	(?___awdiv+1)
	movf	(___awdiv@quotient),w
	clrf	(?___awdiv)
	addwf	(?___awdiv)

	goto	l2045
	
l3571:	
	line	37
	
l2045:	
	return
	opt stack 0
GLOBAL	__end_of___awdiv
	__end_of___awdiv:
;; =============== function ___awdiv ends ============

	signat	___awdiv,8314
	global	___wmul
psect	text394,local,class=CODE,delta=2
global __ptext394
__ptext394:

;; *************** function ___wmul *****************
;; Defined at:
;;		line 3 in file "C:\Program Files (x86)\HI-TECH Software\PICC\9.83\sources\wmul.c"
;; Parameters:    Size  Location     Type
;;  multiplier      2    0[COMMON] unsigned int 
;;  multiplicand    2    2[COMMON] unsigned int 
;; Auto vars:     Size  Location     Type
;;  product         2    4[COMMON] unsigned int 
;; Return value:  Size  Location     Type
;;                  2    0[COMMON] unsigned int 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMMON   BANK0   BANK1   BANK2
;;      Params:         4       0       0       0
;;      Locals:         2       0       0       0
;;      Temps:          0       0       0       0
;;      Totals:         6       0       0       0
;;Total ram usage:        6 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_ADC_convert
;;		_PID_controller
;; This function uses a non-reentrant model
;;
psect	text394
	file	"C:\Program Files (x86)\HI-TECH Software\PICC\9.83\sources\wmul.c"
	line	3
	global	__size_of___wmul
	__size_of___wmul	equ	__end_of___wmul-___wmul
	
___wmul:	
	opt	stack 4
; Regs used in ___wmul: [wreg+status,2+status,0]
	line	4
	
l3521:	
	clrf	(___wmul@product)
	clrf	(___wmul@product+1)
	goto	l3523
	line	6
	
l1895:	
	line	7
	
l3523:	
	btfss	(___wmul@multiplier),(0)&7
	goto	u2581
	goto	u2580
u2581:
	goto	l1896
u2580:
	line	8
	
l3525:	
	movf	(___wmul@multiplicand),w
	addwf	(___wmul@product),f
	skipnc
	incf	(___wmul@product+1),f
	movf	(___wmul@multiplicand+1),w
	addwf	(___wmul@product+1),f
	
l1896:	
	line	9
	movlw	01h
	
u2595:
	clrc
	rlf	(___wmul@multiplicand),f
	rlf	(___wmul@multiplicand+1),f
	addlw	-1
	skipz
	goto	u2595
	line	10
	
l3527:	
	movlw	01h
	
u2605:
	clrc
	rrf	(___wmul@multiplier+1),f
	rrf	(___wmul@multiplier),f
	addlw	-1
	skipz
	goto	u2605
	line	11
	movf	((___wmul@multiplier+1)),w
	iorwf	((___wmul@multiplier)),w
	skipz
	goto	u2611
	goto	u2610
u2611:
	goto	l3523
u2610:
	goto	l3529
	
l1897:	
	line	12
	
l3529:	
	movf	(___wmul@product+1),w
	clrf	(?___wmul+1)
	addwf	(?___wmul+1)
	movf	(___wmul@product),w
	clrf	(?___wmul)
	addwf	(?___wmul)

	goto	l1898
	
l3531:	
	line	13
	
l1898:	
	return
	opt stack 0
GLOBAL	__end_of___wmul
	__end_of___wmul:
;; =============== function ___wmul ends ============

	signat	___wmul,8314
	global	_servo_on
psect	text395,local,class=CODE,delta=2
global __ptext395
__ptext395:

;; *************** function _servo_on *****************
;; Defined at:
;;		line 334 in file "C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;		None               void
;; Registers used:
;;		None
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMMON   BANK0   BANK1   BANK2
;;      Params:         0       0       0       0
;;      Locals:         0       0       0       0
;;      Temps:          0       0       0       0
;;      Totals:         0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_black_black_check
;; This function uses a non-reentrant model
;;
psect	text395
	file	"C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
	line	334
	global	__size_of_servo_on
	__size_of_servo_on	equ	__end_of_servo_on-_servo_on
	
_servo_on:	
	opt	stack 6
; Regs used in _servo_on: []
	line	335
	
l3519:	
;robot test 2 - Ch2 yes servo.c: 335: RC2 = 0;
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	bcf	(58/8),(58)&7
	line	336
	
l1015:	
	return
	opt stack 0
GLOBAL	__end_of_servo_on
	__end_of_servo_on:
;; =============== function _servo_on ends ============

	signat	_servo_on,88
	global	_servo_off
psect	text396,local,class=CODE,delta=2
global __ptext396
__ptext396:

;; *************** function _servo_off *****************
;; Defined at:
;;		line 338 in file "C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;		None               void
;; Registers used:
;;		None
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMMON   BANK0   BANK1   BANK2
;;      Params:         0       0       0       0
;;      Locals:         0       0       0       0
;;      Temps:          0       0       0       0
;;      Totals:         0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_black_black_check
;; This function uses a non-reentrant model
;;
psect	text396
	file	"C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
	line	338
	global	__size_of_servo_off
	__size_of_servo_off	equ	__end_of_servo_off-_servo_off
	
_servo_off:	
	opt	stack 6
; Regs used in _servo_off: []
	line	339
	
l3517:	
;robot test 2 - Ch2 yes servo.c: 339: RC2 = 1;
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	bsf	(58/8),(58)&7
	line	340
	
l1018:	
	return
	opt stack 0
GLOBAL	__end_of_servo_off
	__end_of_servo_off:
;; =============== function _servo_off ends ============

	signat	_servo_off,88
	global	_move_stop
psect	text397,local,class=CODE,delta=2
global __ptext397
__ptext397:

;; *************** function _move_stop *****************
;; Defined at:
;;		line 372 in file "C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;		None               void
;; Registers used:
;;		None
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMMON   BANK0   BANK1   BANK2
;;      Params:         0       0       0       0
;;      Locals:         0       0       0       0
;;      Temps:          0       0       0       0
;;      Totals:         0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;;		_black_black_check
;; This function uses a non-reentrant model
;;
psect	text397
	file	"C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
	line	372
	global	__size_of_move_stop
	__size_of_move_stop	equ	__end_of_move_stop-_move_stop
	
_move_stop:	
	opt	stack 7
; Regs used in _move_stop: []
	line	373
	
l3515:	
;robot test 2 - Ch2 yes servo.c: 373: RC6 = 0;
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	bcf	(62/8),(62)&7
	line	374
;robot test 2 - Ch2 yes servo.c: 374: RC3 = 0;
	bcf	(59/8),(59)&7
	line	375
;robot test 2 - Ch2 yes servo.c: 375: RC5 = 0;
	bcf	(61/8),(61)&7
	line	376
;robot test 2 - Ch2 yes servo.c: 376: RC4 = 0;
	bcf	(60/8),(60)&7
	line	377
	
l1030:	
	return
	opt stack 0
GLOBAL	__end_of_move_stop
	__end_of_move_stop:
;; =============== function _move_stop ends ============

	signat	_move_stop,88
	global	_PWM_check
psect	text398,local,class=CODE,delta=2
global __ptext398
__ptext398:

;; *************** function _PWM_check *****************
;; Defined at:
;;		line 280 in file "C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;		None               void
;; Registers used:
;;		wreg
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMMON   BANK0   BANK1   BANK2
;;      Params:         0       0       0       0
;;      Locals:         0       0       0       0
;;      Temps:          1       0       0       0
;;      Totals:         1       0       0       0
;;Total ram usage:        1 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text398
	file	"C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
	line	280
	global	__size_of_PWM_check
	__size_of_PWM_check	equ	__end_of_PWM_check-_PWM_check
	
_PWM_check:	
	opt	stack 7
; Regs used in _PWM_check: [wreg]
	line	281
	
l3507:	
;robot test 2 - Ch2 yes servo.c: 281: if(PWMCounter > dutyMotorL)
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movf	(_dutyMotorL+1),w
	xorlw	80h
	movwf	(??_PWM_check+0)+0
	movf	(_PWMCounter+1),w
	xorlw	80h
	subwf	(??_PWM_check+0)+0,w
	skipz
	goto	u2565
	movf	(_PWMCounter),w
	subwf	(_dutyMotorL),w
u2565:

	skipnc
	goto	u2561
	goto	u2560
u2561:
	goto	l3511
u2560:
	line	283
	
l3509:	
;robot test 2 - Ch2 yes servo.c: 282: {
;robot test 2 - Ch2 yes servo.c: 283: RC6 = 0;
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	bcf	(62/8),(62)&7
	line	284
;robot test 2 - Ch2 yes servo.c: 284: RC3 = 0;
	bcf	(59/8),(59)&7
	goto	l3511
	line	285
	
l999:	
	line	286
	
l3511:	
;robot test 2 - Ch2 yes servo.c: 285: }
;robot test 2 - Ch2 yes servo.c: 286: if(PWMCounter > dutyMotorR)
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movf	(_dutyMotorR+1),w
	xorlw	80h
	movwf	(??_PWM_check+0)+0
	movf	(_PWMCounter+1),w
	xorlw	80h
	subwf	(??_PWM_check+0)+0,w
	skipz
	goto	u2575
	movf	(_PWMCounter),w
	subwf	(_dutyMotorR),w
u2575:

	skipnc
	goto	u2571
	goto	u2570
u2571:
	goto	l1001
u2570:
	line	288
	
l3513:	
;robot test 2 - Ch2 yes servo.c: 287: {
;robot test 2 - Ch2 yes servo.c: 288: RC5 = 0;
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	bcf	(61/8),(61)&7
	line	289
;robot test 2 - Ch2 yes servo.c: 289: RC4 = 0;
	bcf	(60/8),(60)&7
	goto	l1001
	line	290
	
l1000:	
	line	291
	
l1001:	
	return
	opt stack 0
GLOBAL	__end_of_PWM_check
	__end_of_PWM_check:
;; =============== function _PWM_check ends ============

	signat	_PWM_check,88
	global	_PWM_reset
psect	text399,local,class=CODE,delta=2
global __ptext399
__ptext399:

;; *************** function _PWM_reset *****************
;; Defined at:
;;		line 294 in file "C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;		None               void
;; Registers used:
;;		wreg, status,2
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMMON   BANK0   BANK1   BANK2
;;      Params:         0       0       0       0
;;      Locals:         0       0       0       0
;;      Temps:          0       0       0       0
;;      Totals:         0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text399
	file	"C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
	line	294
	global	__size_of_PWM_reset
	__size_of_PWM_reset	equ	__end_of_PWM_reset-_PWM_reset
	
_PWM_reset:	
	opt	stack 7
; Regs used in _PWM_reset: [wreg+status,2]
	line	295
	
l3487:	
;robot test 2 - Ch2 yes servo.c: 295: RB6 = !RB6;
	movlw	1<<((54)&7)
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	xorwf	((54)/8),f
	line	296
	
l3489:	
;robot test 2 - Ch2 yes servo.c: 296: PWMCounter = 0;
	clrf	(_PWMCounter)
	clrf	(_PWMCounter+1)
	line	298
	
l3491:	
;robot test 2 - Ch2 yes servo.c: 298: if(statMotorR == 1)
	movlw	01h
	xorwf	(_statMotorR),w
	iorwf	(_statMotorR+1),w
	skipz
	goto	u2521
	goto	u2520
u2521:
	goto	l3495
u2520:
	line	300
	
l3493:	
;robot test 2 - Ch2 yes servo.c: 299: {
;robot test 2 - Ch2 yes servo.c: 300: RC5 = 1;
	bsf	(61/8),(61)&7
	line	301
;robot test 2 - Ch2 yes servo.c: 301: RC4 = 0;
	bcf	(60/8),(60)&7
	line	302
;robot test 2 - Ch2 yes servo.c: 302: }
	goto	l3499
	line	303
	
l1004:	
	
l3495:	
;robot test 2 - Ch2 yes servo.c: 303: else if(statMotorR == 2)
	movlw	02h
	xorwf	(_statMotorR),w
	iorwf	(_statMotorR+1),w
	skipz
	goto	u2531
	goto	u2530
u2531:
	goto	l1006
u2530:
	line	305
	
l3497:	
;robot test 2 - Ch2 yes servo.c: 304: {
;robot test 2 - Ch2 yes servo.c: 305: RC5 = 0;
	bcf	(61/8),(61)&7
	line	306
;robot test 2 - Ch2 yes servo.c: 306: RC4 = 1;
	bsf	(60/8),(60)&7
	line	307
;robot test 2 - Ch2 yes servo.c: 307: }
	goto	l3499
	line	308
	
l1006:	
	line	310
;robot test 2 - Ch2 yes servo.c: 308: else
;robot test 2 - Ch2 yes servo.c: 309: {
;robot test 2 - Ch2 yes servo.c: 310: RC5 = 0;
	bcf	(61/8),(61)&7
	line	311
;robot test 2 - Ch2 yes servo.c: 311: RC4 = 0;
	bcf	(60/8),(60)&7
	goto	l3499
	line	312
	
l1007:	
	goto	l3499
	
l1005:	
	line	314
	
l3499:	
;robot test 2 - Ch2 yes servo.c: 312: }
;robot test 2 - Ch2 yes servo.c: 314: if(statMotorL == 1)
	movlw	01h
	xorwf	(_statMotorL),w
	iorwf	(_statMotorL+1),w
	skipz
	goto	u2541
	goto	u2540
u2541:
	goto	l3503
u2540:
	line	316
	
l3501:	
;robot test 2 - Ch2 yes servo.c: 315: {
;robot test 2 - Ch2 yes servo.c: 316: RC6 = 1;
	bsf	(62/8),(62)&7
	line	317
;robot test 2 - Ch2 yes servo.c: 317: RC3 = 0;
	bcf	(59/8),(59)&7
	line	318
;robot test 2 - Ch2 yes servo.c: 318: }
	goto	l1012
	line	319
	
l1008:	
	
l3503:	
;robot test 2 - Ch2 yes servo.c: 319: else if(statMotorL == 2)
	movlw	02h
	xorwf	(_statMotorL),w
	iorwf	(_statMotorL+1),w
	skipz
	goto	u2551
	goto	u2550
u2551:
	goto	l1010
u2550:
	line	321
	
l3505:	
;robot test 2 - Ch2 yes servo.c: 320: {
;robot test 2 - Ch2 yes servo.c: 321: RC6 = 0;
	bcf	(62/8),(62)&7
	line	322
;robot test 2 - Ch2 yes servo.c: 322: RC3 = 1;
	bsf	(59/8),(59)&7
	line	323
;robot test 2 - Ch2 yes servo.c: 323: }
	goto	l1012
	line	324
	
l1010:	
	line	326
;robot test 2 - Ch2 yes servo.c: 324: else
;robot test 2 - Ch2 yes servo.c: 325: {
;robot test 2 - Ch2 yes servo.c: 326: RC6 = 0;
	bcf	(62/8),(62)&7
	line	327
;robot test 2 - Ch2 yes servo.c: 327: RC3 = 0;
	bcf	(59/8),(59)&7
	goto	l1012
	line	328
	
l1011:	
	goto	l1012
	
l1009:	
	line	329
	
l1012:	
	return
	opt stack 0
GLOBAL	__end_of_PWM_reset
	__end_of_PWM_reset:
;; =============== function _PWM_reset ends ============

	signat	_PWM_reset,88
	global	_PWM_PID_convert
psect	text400,local,class=CODE,delta=2
global __ptext400
__ptext400:

;; *************** function _PWM_PID_convert *****************
;; Defined at:
;;		line 236 in file "C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;		None               void
;; Registers used:
;;		wreg, status,2, status,0, btemp+1
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMMON   BANK0   BANK1   BANK2
;;      Params:         0       0       0       0
;;      Locals:         0       0       0       0
;;      Temps:          2       0       0       0
;;      Totals:         2       0       0       0
;;Total ram usage:        2 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text400
	file	"C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
	line	236
	global	__size_of_PWM_PID_convert
	__size_of_PWM_PID_convert	equ	__end_of_PWM_PID_convert-_PWM_PID_convert
	
_PWM_PID_convert:	
	opt	stack 7
; Regs used in _PWM_PID_convert: [wreg+status,2+status,0+btemp+1]
	line	237
	
l3451:	
;robot test 2 - Ch2 yes servo.c: 237: if(totalTurn > 0)
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movf	(_totalTurn+1),w
	xorlw	80h
	movwf	btemp+1
	movlw	(high(01h))^80h
	subwf	btemp+1,w
	skipz
	goto	u2485
	movlw	low(01h)
	subwf	(_totalTurn),w
u2485:

	skipc
	goto	u2481
	goto	u2480
u2481:
	goto	l3467
u2480:
	line	239
	
l3453:	
;robot test 2 - Ch2 yes servo.c: 238: {
;robot test 2 - Ch2 yes servo.c: 239: RC0 = 0;
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	bcf	(56/8),(56)&7
	line	240
;robot test 2 - Ch2 yes servo.c: 240: RA2 = 1;
	bsf	(42/8),(42)&7
	line	242
	
l3455:	
;robot test 2 - Ch2 yes servo.c: 242: statMotorR = 1;
	movlw	low(01h)
	movwf	(_statMotorR)
	movlw	high(01h)
	movwf	((_statMotorR))+1
	line	243
;robot test 2 - Ch2 yes servo.c: 243: dutyMotorR = 100;
	movlw	low(064h)
	movwf	(_dutyMotorR)
	movlw	high(064h)
	movwf	((_dutyMotorR))+1
	line	244
	
l3457:	
;robot test 2 - Ch2 yes servo.c: 244: if(totalTurn > 100)
	movf	(_totalTurn+1),w
	xorlw	80h
	movwf	btemp+1
	movlw	(high(065h))^80h
	subwf	btemp+1,w
	skipz
	goto	u2495
	movlw	low(065h)
	subwf	(_totalTurn),w
u2495:

	skipc
	goto	u2491
	goto	u2490
u2491:
	goto	l3463
u2490:
	line	246
	
l3459:	
;robot test 2 - Ch2 yes servo.c: 245: {
;robot test 2 - Ch2 yes servo.c: 246: statMotorL = 2;
	movlw	low(02h)
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(_statMotorL)
	movlw	high(02h)
	movwf	((_statMotorL))+1
	line	247
	
l3461:	
;robot test 2 - Ch2 yes servo.c: 247: dutyMotorL = 100 - totalTurn;
	comf	(_totalTurn),w
	movwf	(??_PWM_PID_convert+0)+0
	comf	(_totalTurn+1),w
	movwf	((??_PWM_PID_convert+0)+0+1)
	incf	(??_PWM_PID_convert+0)+0,f
	skipnz
	incf	((??_PWM_PID_convert+0)+0+1),f
	movf	0+(??_PWM_PID_convert+0)+0,w
	addlw	low(064h)
	movwf	(_dutyMotorL)
	movf	1+(??_PWM_PID_convert+0)+0,w
	skipnc
	addlw	1
	addlw	high(064h)
	movwf	1+(_dutyMotorL)
	line	248
;robot test 2 - Ch2 yes servo.c: 248: }
	goto	l3467
	line	249
	
l991:	
	line	251
	
l3463:	
;robot test 2 - Ch2 yes servo.c: 249: else
;robot test 2 - Ch2 yes servo.c: 250: {
;robot test 2 - Ch2 yes servo.c: 251: statMotorL = 1;
	movlw	low(01h)
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(_statMotorL)
	movlw	high(01h)
	movwf	((_statMotorL))+1
	line	252
	
l3465:	
;robot test 2 - Ch2 yes servo.c: 252: dutyMotorL = 100 - totalTurn;
	comf	(_totalTurn),w
	movwf	(??_PWM_PID_convert+0)+0
	comf	(_totalTurn+1),w
	movwf	((??_PWM_PID_convert+0)+0+1)
	incf	(??_PWM_PID_convert+0)+0,f
	skipnz
	incf	((??_PWM_PID_convert+0)+0+1),f
	movf	0+(??_PWM_PID_convert+0)+0,w
	addlw	low(064h)
	movwf	(_dutyMotorL)
	movf	1+(??_PWM_PID_convert+0)+0,w
	skipnc
	addlw	1
	addlw	high(064h)
	movwf	1+(_dutyMotorL)
	goto	l3467
	line	253
	
l992:	
	goto	l3467
	line	254
	
l990:	
	line	255
	
l3467:	
;robot test 2 - Ch2 yes servo.c: 253: }
;robot test 2 - Ch2 yes servo.c: 254: }
;robot test 2 - Ch2 yes servo.c: 255: if(totalTurn < 0)
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	btfss	(_totalTurn+1),7
	goto	u2501
	goto	u2500
u2501:
	goto	l996
u2500:
	line	258
	
l3469:	
;robot test 2 - Ch2 yes servo.c: 256: {
;robot test 2 - Ch2 yes servo.c: 258: RC0 = 1;
	bsf	(56/8),(56)&7
	line	259
;robot test 2 - Ch2 yes servo.c: 259: RA2 = 0;
	bcf	(42/8),(42)&7
	line	261
	
l3471:	
;robot test 2 - Ch2 yes servo.c: 261: totalTurn = totalTurn * -1;
	comf	(_totalTurn),f
	comf	(_totalTurn+1),f
	incf	(_totalTurn),f
	skipnz
	incf	(_totalTurn+1),f
	line	262
	
l3473:	
;robot test 2 - Ch2 yes servo.c: 262: statMotorL = 1;
	movlw	low(01h)
	movwf	(_statMotorL)
	movlw	high(01h)
	movwf	((_statMotorL))+1
	line	263
	
l3475:	
;robot test 2 - Ch2 yes servo.c: 263: dutyMotorL = 100;
	movlw	low(064h)
	movwf	(_dutyMotorL)
	movlw	high(064h)
	movwf	((_dutyMotorL))+1
	line	265
	
l3477:	
;robot test 2 - Ch2 yes servo.c: 265: if(totalTurn > 100)
	movf	(_totalTurn+1),w
	xorlw	80h
	movwf	btemp+1
	movlw	(high(065h))^80h
	subwf	btemp+1,w
	skipz
	goto	u2515
	movlw	low(065h)
	subwf	(_totalTurn),w
u2515:

	skipc
	goto	u2511
	goto	u2510
u2511:
	goto	l3483
u2510:
	line	267
	
l3479:	
;robot test 2 - Ch2 yes servo.c: 266: {
;robot test 2 - Ch2 yes servo.c: 267: statMotorR = 2;
	movlw	low(02h)
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(_statMotorR)
	movlw	high(02h)
	movwf	((_statMotorR))+1
	line	268
	
l3481:	
;robot test 2 - Ch2 yes servo.c: 268: dutyMotorR = 100 - totalTurn;
	comf	(_totalTurn),w
	movwf	(??_PWM_PID_convert+0)+0
	comf	(_totalTurn+1),w
	movwf	((??_PWM_PID_convert+0)+0+1)
	incf	(??_PWM_PID_convert+0)+0,f
	skipnz
	incf	((??_PWM_PID_convert+0)+0+1),f
	movf	0+(??_PWM_PID_convert+0)+0,w
	addlw	low(064h)
	movwf	(_dutyMotorR)
	movf	1+(??_PWM_PID_convert+0)+0,w
	skipnc
	addlw	1
	addlw	high(064h)
	movwf	1+(_dutyMotorR)
	line	269
;robot test 2 - Ch2 yes servo.c: 269: }
	goto	l996
	line	270
	
l994:	
	line	272
	
l3483:	
;robot test 2 - Ch2 yes servo.c: 270: else
;robot test 2 - Ch2 yes servo.c: 271: {
;robot test 2 - Ch2 yes servo.c: 272: statMotorR = 1;
	movlw	low(01h)
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	movwf	(_statMotorR)
	movlw	high(01h)
	movwf	((_statMotorR))+1
	line	273
	
l3485:	
;robot test 2 - Ch2 yes servo.c: 273: dutyMotorR = 100 - totalTurn;
	comf	(_totalTurn),w
	movwf	(??_PWM_PID_convert+0)+0
	comf	(_totalTurn+1),w
	movwf	((??_PWM_PID_convert+0)+0+1)
	incf	(??_PWM_PID_convert+0)+0,f
	skipnz
	incf	((??_PWM_PID_convert+0)+0+1),f
	movf	0+(??_PWM_PID_convert+0)+0,w
	addlw	low(064h)
	movwf	(_dutyMotorR)
	movf	1+(??_PWM_PID_convert+0)+0,w
	skipnc
	addlw	1
	addlw	high(064h)
	movwf	1+(_dutyMotorR)
	goto	l996
	line	274
	
l995:	
	goto	l996
	line	275
	
l993:	
	line	276
	
l996:	
	return
	opt stack 0
GLOBAL	__end_of_PWM_PID_convert
	__end_of_PWM_PID_convert:
;; =============== function _PWM_PID_convert ends ============

	signat	_PWM_PID_convert,88
	global	_init_hardware
psect	text401,local,class=CODE,delta=2
global __ptext401
__ptext401:

;; *************** function _init_hardware *****************
;; Defined at:
;;		line 387 in file "C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;		None               void
;; Registers used:
;;		wreg, status,2
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMMON   BANK0   BANK1   BANK2
;;      Params:         0       0       0       0
;;      Locals:         0       0       0       0
;;      Temps:          0       0       0       0
;;      Totals:         0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text401
	file	"C:\Users\User\Documents\Jonathan\J Panu\robot test 2 - Ch2 yes servo.c"
	line	387
	global	__size_of_init_hardware
	__size_of_init_hardware	equ	__end_of_init_hardware-_init_hardware
	
_init_hardware:	
	opt	stack 7
; Regs used in _init_hardware: [wreg+status,2]
	line	389
	
l3429:	
;robot test 2 - Ch2 yes servo.c: 389: ANSEL = 0b00000000;
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	clrf	(286)^0100h	;volatile
	line	392
	
l3431:	
;robot test 2 - Ch2 yes servo.c: 392: ANSELH = 0b00001100;
	movlw	(0Ch)
	movwf	(287)^0100h	;volatile
	line	395
	
l3433:	
;robot test 2 - Ch2 yes servo.c: 395: TRISA = 0b00000000;
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	clrf	(133)^080h	;volatile
	line	397
;robot test 2 - Ch2 yes servo.c: 397: TRISB = 0b00110000;
	movlw	(030h)
	movwf	(134)^080h	;volatile
	line	398
;robot test 2 - Ch2 yes servo.c: 398: TRISC = 0b10000000;
	movlw	(080h)
	movwf	(135)^080h	;volatile
	line	401
	
l3435:	
;robot test 2 - Ch2 yes servo.c: 401: PORTA = 0b00000000;
	bcf	status, 5	;RP0=0, select bank0
	bcf	status, 6	;RP1=0, select bank0
	clrf	(5)	;volatile
	line	403
	
l3437:	
;robot test 2 - Ch2 yes servo.c: 403: PORTB = 0b00000000;
	clrf	(6)	;volatile
	line	404
	
l3439:	
;robot test 2 - Ch2 yes servo.c: 404: PORTC = 0b00000000;
	clrf	(7)	;volatile
	line	407
	
l3441:	
;robot test 2 - Ch2 yes servo.c: 407: ADCON0 = 0b00000001;
	movlw	(01h)
	movwf	(31)	;volatile
	line	408
	
l3443:	
;robot test 2 - Ch2 yes servo.c: 408: ANSELH = 0b00001100;
	movlw	(0Ch)
	bcf	status, 5	;RP0=0, select bank2
	bsf	status, 6	;RP1=1, select bank2
	movwf	(287)^0100h	;volatile
	line	411
	
l3445:	
;robot test 2 - Ch2 yes servo.c: 411: IRCF0 = 1;
	bsf	status, 5	;RP0=1, select bank1
	bcf	status, 6	;RP1=0, select bank1
	bsf	(1148/8)^080h,(1148)&7
	line	412
	
l3447:	
;robot test 2 - Ch2 yes servo.c: 412: IRCF1 = 1;
	bsf	(1149/8)^080h,(1149)&7
	line	413
	
l3449:	
;robot test 2 - Ch2 yes servo.c: 413: IRCF2 = 1;
	bsf	(1150/8)^080h,(1150)&7
	line	414
	
l1036:	
	return
	opt stack 0
GLOBAL	__end_of_init_hardware
	__end_of_init_hardware:
;; =============== function _init_hardware ends ============

	signat	_init_hardware,88
psect	text402,local,class=CODE,delta=2
global __ptext402
__ptext402:
	global	btemp
	btemp set 07Eh

	DABS	1,126,2	;btemp
	global	wtemp0
	wtemp0 set btemp
	end
