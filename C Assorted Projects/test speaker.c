/* -------------------------------------------------------------------------------------------
	author: Jonathan P.
		/\
	   /\/\
		last update: 04-06-2013
		Description: testing pitch modulation
		Hardware setup:
			PORTC connected to 8 LEDs
			Buttons connected to RA4, RA5
			
			RB7 = speaker power
*/

//--------------------------Initialization------------------------------------------
#include <pic.h>	//include a library of procedure specific to the PIC family of microcontrollers
#include <htc.h>
#include <stdlib.h>	//includes random function; srand, rand

__CONFIG(FOSC_INTRCIO & WDTE_OFF & PWRTE_OFF & MCLRE_OFF & CP_OFF & CPD_OFF & BOREN_OFF & IESO_OFF & FCMEN_OFF);


//Define Constants - the compiler does a substitution

#define on 1
#define off 0

#define UpB RA5
#define DownB RA4

#define pressed 0
#define unpressed 1

#define sec 1000000


//Global Variables

int UpHeld = 0;			//RA5 held in last cycle (1-held, 0-not held)
int DownHeld = 0;		//RA4 held in last cycle
int holdDoubleTap = 0;	//counts how many cycles between last time button let go; prevent a double tap

int ledDutyCycle = 15;	//determines cycle number when LED turns off

int i;					//determines loop repeat length
int j;					//determines loop repeat length - nested 1

int cycleNumber = 1;	//determines which cycle the PIC is currently in (1 to 100)


//Arrays; note, always read 0-7

int ledArray[8] = {0b00000001, 0b00000010, 0b00000100, 0b00001000, 0b00010000, 0b00100000, 0b01000000, 0b10000000};
						//determines which LED is on, converts variabe for ledValue to PORTC input


//PREDEFINE PROCEDURES: procedure must be defined before you can use them

void init_hardware(void);			//initialize hardware

//--------------------------Main Procedure------------------------------------------

void main(void)
{
	init_hardware();				//{broadcast} runs "init_hardware()" below
	
	for(j=0; j<3; j++)				//program start animation
	{
		for(i=0; i<8; i++)
		{
			PORTC = ledArray[i];
			_delay(sec/35);
		}
	}
	
	RC0 = 1;						//turns on idiot light; constant for 100% brightness
	
	while(1)						//forever loop
	{
		RB7 = 1;
		_delay(1900);
		RB7 = 0;
		_delay(1900);
	}
}
					

//---------------------------Outside Procedures; run by {broadcast}-----------------



void init_hardware(void)	//set it and forget it, setup your hardware here
{
	//set analogue pins as analogue(1) or digital (0)
	ANSEL = 0b00000000;	// enabling/disabling analogue pins
							//(0 = disable, 1 = enable)
							//AN7 to AN0
	ANSELH = 0b00000000; //n/c, n/c, n/c, n/c, AN11, AN10, AN9, AN8
	
	//set pins as Input(1) or Output(0)
	TRISA = 0b00110000;	//set direction of port pins through the tri-state
							//(output = 0, input = 1)
	TRISB = 0b00000000;
	TRISC = 0b00000000;
	
	//initialize the ports
	PORTA = 0b00000000;	//Clear (GND) all the output pins
							//(0 = GND, 1 = 5V)
	PORTB = 0b00000000;	//RB7, RB6, RB5, RB4, n/c, n/c, n/c, n/c
	PORTC = 0b00000000; //Initializes LEDs
}
