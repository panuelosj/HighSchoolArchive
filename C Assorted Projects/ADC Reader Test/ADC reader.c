/* -------------------------------------------------------------------------------------------
	author: Jonathan P.
		/\
	   /\/\
		last update: 09-05-2013
		Description: moving a robot - line following
		Hardware setup:
			Left Motor		- RC2 and RC3 ; Pin 14 and 7
			Right Motor		- RC5 and RC4 ; Pin 5 and 6
			
			Left Light Sensor - RA1
			Right Light Sensor - RA2
			
			Start Button - RA0
			
		NOTES:
			- sensor checking does not directly control the motors, only change motor state variables
			- control of motors only done in PWM procedure
			- motor direction (controlled by motorState variables) only refreshed at the start of each PWM cycle
*/

//--------------------------Initialization------------------------------------------
#include <pic.h>	//include a library of procedure specific to the PIC family of microcontrollers
#include <htc.h>
#include <stdlib.h>	//includes random function; srand, rand

__CONFIG(FOSC_INTRCIO & WDTE_OFF & PWRTE_OFF & MCLRE_OFF & CP_OFF & CPD_OFF & BOREN_OFF & IESO_OFF & FCMEN_OFF);


//Define Constants - the compiler does a substitution


#define on 1						// Software state readability shorthand
#define off 0

#define black 0
#define white 1

#define pressed 1					
#define unpressed 0					

#define sec 1000000


//Global Variables

int i;
int loopExit = 0;		//temp code for exiting loops


//Arrays; note, always read 0-7


//PREDEFINE PROCEDURES: procedure must be defined before you can use them

void init_hardware(void);			//initialize hardware




//--------------------------Main Procedure------------------------------------------

void main(void)
{
	init_hardware();				//{broadcast} runs "init_hardware()" below
	
	RC0 = 1;
	GO_nDONE = 1;
	
	while(1)
	{
		GO_nDONE = 1;
		while(GO_nDONE != 0){}
		PORTC = ADRESH;
	}
	
}
					

//---------------------------Outside Procedures; run by {broadcast}-----------------


//----------------------------------------------------------------------------------

void init_hardware(void)		//set it and forget it, setup your hardware here
{
	//set analogue pins as analogue(1) or digital (0)
	ANSEL = 0b00000000;	// enabling/disabling analogue pins
							//(0 = disable, 1 = enable)
							//AN7 to AN0
	ANSELH = 0b00000000; //n/c, n/c, n/c, n/c, AN11, AN10, AN9, AN8
	
	//set pins as Input(1) or Output(0)
	TRISA = 0b00000000;	//set direction of port pins through the tri-state
							//(output = 0, input = 1)
	TRISB = 0b00010000;
	TRISC = 0b00000000;
	
	//initialize the ports
	PORTA = 0b00000000;	//Clear (GND) all the output pins
							//(0 = GND, 1 = 5V)
	PORTB = 0b00000000;	//RB7, RB6, RB5, RB4, n/c, n/c, n/c, n/c
	PORTC = 0b00000000; //Initializes LEDs
	
	//initialize ADC
	ADCON0 = 0b00101001;
	ANSELH = 0b00000100;
	
	//initialize speed
	IRCF0 = 1;
	IRCF1 = 1;
	IRCF2 = 1;
}
