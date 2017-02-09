/* author: Jonathan P.
	last update: 03-05-2013
	Description: Turns on all the LEDs on the testboard
	Hardware setup:
		PORTC connected to 8 LEDs
		Buttons connected to RA4, RA5
*/
#include <pic.h>	//include a library of procedure specific to the PIC family of microcontrollers

__CONFIG(FOSC_INTRCIO & WDTE_OFF & PWRTE_OFF & MCLRE_OFF & CP_OFF & CPD_OFF & BOREN_OFF & IESO_OFF & FCMEN_OFF);

//define constants - the compiler does a substitution


//Global Variables




//PREDEFINE PROCEDURES: procedure must be defined before you can use them

void init_hardware(void);



void main(void)
{
	init_hardware();	//run procedure init_hardware()
	PORTC = 0b11111111;
	while(1)
	{
		//do nothing
	}
}

void init_hardware(void)	//set it and forget it, setup your hardware here
{
	//set analogue pins as analogue(1) or digital (0)
	ANSEL = 0b00000000;	// enabling/disabling analogue pins
							//(0 = disable, 1 = enable)
							//AN7 to AN0
	ANSELH = 0b00000000; //n/c, n/c, n/c, n/c, AN11, AN10, AN9, AN8
	
	//set pins as Input(1) or Output(0)
	TRISA = 0b00000000;	//set direction of port pins through the tri-state
	TRISB = 0b00000000;	//(output = 0, input = 1)
	TRISC = 0b00000000;
	
	//initialize the ports
	PORTA = 0b00000000;	//Clear (GND) all the output pins
							//(0 = GND, 1 = 5V)
	PORTB = 0b00000000;	//RB7, RB6, RB5, RB4, n/c, n/c, n/c, n/c
	PORTC = 0b00000000;
}