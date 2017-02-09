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

#define sec 1000000


//Global Variables

int ledValue = 3;		//determines output LED lights; 0-7 (right to left)
int wLevel = 0;			//determines the current level number in writing the levelMovement array; 1-10; WRITE LEVEL #
int rLevel = 0;			//determines the current level number while playing; keeps track of score; 1-10; READ LEVEL #
int movement;			//determines left or right
int input;				//determines player input, left or right
int yesXno = 1;			//determines continue loop
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
void cast_correctLed(void);			//lighting procedure for correct answer
void cast_wrongLed(void);			//lighting procedure for incorrect answer
void cast_flashLED(void);			//lighting procedure to indicate next level


//--------------------------Main Procedure------------------------------------------

void main(void)
{
	init_hardware();				//{broadcast} runs "init_hardware()" below
	srand(rand() %100);				//generates random number seed; random as input
	
	
	for(i=0; i<10; i++)				//pre-set the sequence of LEDs for all 10 levels, lights are not lit
	{
		movement = rand() % 2;				//sets movement variable to left or right; left = 1, right = 0; rand 0-1
	
		if(ledValue == 7)					//if at the max; ie. 1000 0000
		{movement = 0;}							//set move to right
		if(ledValue == 0)					//if at minimum; ie. 0000 0001
		{movement = 1;}							//set move to left
		
		if(movement == 1)					//change ledValue based on movement value
		{ledValue = ledValue + 1;}				//add if movement is to left
		else
		{ledValue = ledValue - 1;}				//subtract if movement is to right
		
		ledSequence[wLevel] = ledArray[ledValue];	//write the current value to the array at the given level#
		wLevel = wLevel + 1;				//set to next level on next iteration
	}	
	
	while(yesXno == 1)				//main game loop, repeats until variable equals 0
	{
		
		PORTC = ledArray[ledValue];			//turns on selected lights based on variable
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

void cast_correctLed(void)	// lighting procedure for correct answer
{
	for(j=0; j<3; j++)
	{
		PORTC = 0b00000001;
		for(i=0; i<8; i++)
		{
			_delay(sec/20);
			PORTC = PORTC * 2;
		}
	}
}

void cast_wrongLed(void)	//lighting procedure for incorrect answer
{
	for(j=0; j<6; j++)
	{
		PORTC = 0b00100000;
		_delay(sec/5);
		PORTC = 0b00000100;
		_delay(sec/5);
	}
}

void cast_flashLED(void)	//lighting procedure to indicate next level
{
	for(j=0; j<3; j++)
	{
		PORTC = 0b00000000;
		_delay(sec/4);
		PORTC = 0b11111111;
		_delay(sec/10);
	}
}