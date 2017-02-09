/* author: Jonathan P.
	last update: 03-09-2013
	Description: LEDs turn on consecutively
	Hardware setup:
		PORTC connected to 8 LEDs
		Buttons connected to RA4, RA5
*/

//--------------------------Initialization------------------------------------------
#include <pic.h>	//include a library of procedure specific to the PIC family of microcontrollers
#include <htc.h>

__CONFIG(FOSC_INTRCIO & WDTE_OFF & PWRTE_OFF & MCLRE_OFF & CP_OFF & CPD_OFF & BOREN_OFF & IESO_OFF & FCMEN_OFF);


//define constants - the compiler does a substitution

#define on 1
#define off 0

#define LED0 RC0

#define buttonR RA4
#define buttonL RA5

#define sec 100000


//Global Variables

int ledValue = 0b00001000;		//determines output LED lights
int i;							//determines loop repeat length



//PREDEFINE PROCEDURES: procedure must be defined before you can use them
void init_hardware(void);



//--------------------------Main Procedure------------------------------------------

void main(void)
{
	init_hardware();				//{broadcast} runs "init_hardware()" below
	
	while(1)						//infinite loop
	{
		PORTC=0b00010000; //start up 
		_delay(1*sec);
		PORTC=0b10010000;
		_delay(1*sec);
		PORTC=0b01010000;
		_delay(1*sec);
		PORTC=0b11010000;
		_delay(1*sec);
		PORTC=0b00110000;
		_delay(1*sec);
		PORTC=0b10110000;
		_delay(1*sec);
		PORTC=0b01110000;
		_delay(1*sec);
		PORTC=0b11110000; //sine peaks
		_delay(1*sec);
		PORTC=0b01110000; //back down
		_delay(1*sec);
		PORTC=0b10110000;
		_delay(1*sec);
		PORTC=0b00110000;
		_delay(1*sec);
		PORTC=0b11010000;
		_delay(1*sec);
		PORTC=0b01010000;
		_delay(1*sec);
		PORTC=0b10010000;
		_delay(1*sec);
		PORTC=0b00010000; //back at the center
		_delay(1*sec);
		PORTC=0b11100000; //start down
		_delay(1*sec);
		PORTC=0b01100000;
		_delay(1*sec);
		PORTC=0b10100000;
		_delay(1*sec);
		PORTC=0b00100000;
		_delay(1*sec);
		PORTC=0b11000000;
		_delay(1*sec);
		PORTC=0b01000000;
		_delay(1*sec);
		PORTC=0b10000000;
		_delay(1*sec);
		PORTC=0b00000000; //sine bottoms out
		_delay(1*sec);
		PORTC=0b10000000; //back up
		_delay(1*sec);
		PORTC=0b01000000;
		_delay(1*sec);
		PORTC=0b11000000;
		_delay(1*sec);
		PORTC=0b00100000;
		_delay(1*sec);
		PORTC=0b10100000;
		_delay(1*sec);
		PORTC=0b01100000;
		_delay(1*sec);
		PORTC=0b11100000;
		_delay(1*sec);
	      //PORTB=0b00010000; back to 0, commented out to prevent a pause	
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
	TRISA = 0b00000000;	//set direction of port pins through the tri-state
							//(output = 0, input = 1)
	TRISB = 0b00000000;
	TRISC = 0b00000000;
	
	//initialize the ports
	PORTA = 0b00000000;	//Clear (GND) all the output pins
							//(0 = GND, 1 = 5V)
	PORTB = 0b00000000;	//RB7, RB6, RB5, RB4, n/c, n/c, n/c, n/c
	PORTC = 0b00000000; //Initializes LEDs
}