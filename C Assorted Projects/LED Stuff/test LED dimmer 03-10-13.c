/* author: Jonathan P.
	last update: 03-09-2013
	Description: memory game based on determining direction of led movement
	Hardware setup:
		PORTC connected to 8 LEDs
		Buttons connected to RA4, RA5
*/

//--------------------------Initialization------------------------------------------
#include <pic.h>	//include a library of procedure specific to the PIC family of microcontrollers
#include <htc.h>
#include <stdlib.h>	//includes random function; srand, rand

__CONFIG(FOSC_INTRCIO & WDTE_OFF & PWRTE_OFF & MCLRE_OFF & CP_OFF & CPD_OFF & BOREN_OFF & IESO_OFF & FCMEN_OFF);


//Define Constants - the compiler does a substitution

#define on 1
#define off 0

#define LED0 RC0

#define buttonL RA5
#define buttonR RA4

#define sec 10000


//Global Variables

int ledValue = 3;		//determines output LED lights; 0-7 (right to left)
int ledDim = 100;		//determines duration that LED is off
int ledOn = 0;			//determines duration that LED is on (out of 100)
int wLevel = 0;			//determines the current level number in writing the levelMovement array; 1-10; WRITE LEVEL #
int rLevel = 0;			//determines the current level number while playing; keeps track of score; 1-10; READ LEVEL #
int i;					//determines loop repeat length
int j;					//determines loop repeat length - nested 1



//Arrays; note, always read 0-7

int ledArray[8] = {0b00000001, 0b00000010, 0b00000100, 0b00001000, 0b00010000, 0b00100000, 0b01000000, 0b10000000};
						//determines which LED is on, converts variabe for ledValue to PORTC input
int ledSequence[10];
						//stores sequence in which LEDs turn on


/*Notes
	left = 1
	right = 0
*/


//PREDEFINE PROCEDURES: procedure must be defined before you can use them

void init_hardware(void);			//initialize hardware
void light_LEDs(void);				//keeping light on

//--------------------------Main Procedure------------------------------------------

void main(void)
{
	init_hardware();				//{broadcast} runs "init_hardware()" below
	RC0 = 1;
	RC1 = 1;
	
	while(1)
	{
		if(RA4 == 1)
		{
			ledDim = ledDim + 2;
			while(RA4 == 1)
			{
				light_LEDs();
			}
		}
		if(RA5 == 1)
		{
			
			ledDim = ledDim - 2;
			while(RA5 == 1)
			{
				light_LEDs();
			}
		}
		light_LEDs();
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

void light_LEDs(void)
{
	RC1 = 0;
	for(i=0; i<ledDim; i++)
	{
		_delay(1);
	}
	RC1 = 1;
	ledOn = 100 - ledDim;
	for(i=0; i<ledOn; i++)
	{
		_delay(1);
	}
}