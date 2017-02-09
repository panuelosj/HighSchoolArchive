/* -------------------------------------------------------------------------------------------
	author: Jonathan P.
		/\
	   /\/\
		last update: 04-06-2013
		Description: test to dim LEDs
		Hardware setup:
			PORTC connected to 8 LEDs
			Buttons connected to RA4, RA5
			
			RC0 = idiot light; 100% brightness constant
			RC1 = current dim indicator
			RC5, RC6, RC7 = current color indicator
		
	---------------------------------------------------------------------------------
	|	controls dimness by manipulating pulse width								|
	|																				|
	| 1 |----|			  |----|			|----|									|
	| 0 |	 |------------|	   |------------|	 |------------| 25% brightness		|
	|	 																			|
	| 1 |--------|		  |--------|		|--------|								|
	| 0 |		 |--------|		   |--------|		 |--------| 50% 				|
	|																				|
	| 1 |-----------------|-----------------|-----------------|  					|
	| 0 |				  |					|				  | 100%				|
	|																				|
	|	^_________________^															|
	|	0.1 ms = 100 cycles															|
	---------------------------------------------------------------------------------
*/

//--------------------------Initialization------------------------------------------
#include <pic.h>	//include a library of procedure specific to the PIC family of microcontrollers
#include <htc.h>
#include <stdlib.h>	//includes random function; srand, rand

__CONFIG(FOSC_INTRCIO & WDTE_OFF & PWRTE_OFF & MCLRE_OFF & CP_OFF & CPD_OFF & BOREN_OFF & IESO_OFF & FCMEN_OFF);


//Define Constants - the compiler does a substitution

#define on 1
#define off 0

#define LEDred RC2
#define LEDblue RC3
#define LEDgreen RC4

#define UpB RA5
#define DownB RA4

#define pressed 0
#define unpressed 1

#define maxDutyCycle 30

#define sec 1000000


//Global Variables

int UpHeld = 0;			//RA5 held in last cycle (1-held, 0-not held)
int DownHeld = 0;		//RA4 held in last cycle
int holdDoubleTap = 0;	//counts how many cycles between last time button let go; prevent a double tap

int ledColor = 0;		//which led color being manipulated currently (0=red; 1=blue; 2=green)
int ledDutyCycle = 15;	//determines cycle number when LED turns off
int pWidthRed = 15;		//pulse width of red
int pWidthBlue = 15;		//pulse width of blue
int pWidthGreen = 15;	//pulse width of green
int cycleIncrement = 1;	//sets how much to add to duty cycle for every button press

int i;					//determines loop repeat length
int j;					//determines loop repeat length - nested 1

int cycleNumber = 1;	//determines which cycle the PIC is currently in (1 to 100)


//Arrays; note, always read 0-7

int ledArray[8] = {0b00000001, 0b00000010, 0b00000100, 0b00001000, 0b00010000, 0b00100000, 0b01000000, 0b10000000};
						//determines which LED is on, converts variabe for ledValue to PORTC input


//PREDEFINE PROCEDURES: procedure must be defined before you can use them

void init_hardware(void);			//initialize hardware
void light_LEDs(void);				//turn light on and off based on variable; runs for 100 cycles
void check_button(void);			//checks button

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
		check_button();					//{broadcast} button-checking procedure
		light_LEDs();					//{broadcast} led-lighting procedure
		
		if(cycleNumber == 100)			// 100 cycles = 0.1 ms = 1 frame (100% pulse width)
		{
			cycleNumber = 1;
		}
		else
		{
			cycleNumber++;
		}
		
		_delay(1);						//wait 0.001 ms  [[ IS THIS REALLY NEEDED? ]]
	}
}
					

//---------------------------Outside Procedures; run by {broadcast}-----------------


void check_button(void)
{
	if(RA5 == pressed && UpHeld == 0)	//Up Button cycles through LED brightness; checks for leading edge
	{
		holdDoubleTap = 0;					//resets double tap timer
		ledDutyCycle++;						//var: cycles through 1%-30% (this section has most light change)
		if(ledDutyCycle > maxDutyCycle)			//high threshold check
		{
			ledDutyCycle = 0;					//loops back to 0 when over highest threshold
		}
		UpHeld = 1;							//sets held to 1, so next cycle does not read it as button press
	}
	else if(RA5 == unpressed)			//sets to 0 when button not held, so it can check for leading edge
	{
		if(holdDoubleTap > 100)				//if timer exceeds the min number of cycles between button presses, sets the button reading as unpressed
		{
			UpHeld = 0;
		}
		else
		{
			holdDoubleTap++;				//if double tap timer is below the min, does not yet set the var as unpressed
		}
	}
	
	if(RA4 == pressed && DownHeld == 0)	//Down Button cycles through which LED is being controlled; checks for leading edge
	{
		ledColor++;							//var: (0 = red; 1 = blue; 2 = green)
		if(ledColor > 2)					//high threshold check
		{
			ledColor = 0;						//resets to red when cycled through all three colors
		}
		
		if(ledColor == 0)					//reads stored var and copies onto control var; reads only when switching colors
		{										//used separate var for button control so button only handles one variable
			ledDutyCycle = pWidthRed;
		}
		else if(ledColor == 1)
		{
			ledDutyCycle = pWidthBlue;
		}
		else if(ledColor == 2)
		{
			ledDutyCycle = pWidthGreen;
		}
		
		DownHeld = 1;						//sets held to 1, next cycle does not read as leading edge
	}
	else if(RA4 == unpressed)			//sets to 0 when button not held, so it can check for leading edge
	{
		DownHeld = 0;
	}
	
			
	if(ledColor == 0)					//stores control var to read var
	{										//used separate var for button control so button only handles one variable
		pWidthRed = ledDutyCycle;
	}
	else if(ledColor == 1)
	{
		pWidthBlue = ledDutyCycle;
	}
	else if(ledColor == 2)
	{
		pWidthGreen = ledDutyCycle;
	}
}	



void light_LEDs(void)
{
	if(cycleNumber == 1)				//turns on all LEDs for cycle start
	{
		RC1 = 1;
		LEDred = 1;
		LEDblue = 1;
		LEDgreen = 1;
	}
	if(cycleNumber > pWidthRed)			//turns off corresponding color when its duty cycle is over
	{
		LEDred = 0;
	}
	if(cycleNumber > pWidthBlue)
	{
		LEDblue = 0;
	}
	if(cycleNumber > pWidthGreen)
	{
		LEDgreen = 0;
	}
	if(cycleNumber > ledDutyCycle)		//RC1 is indicator to dimness of color currently being manipulated
	{
		RC1 = 0;
	}
	
	if(ledColor == 0)					//lights the indicator LED: shows which color is currently being controlled
	{										//var: (0 = red; 1 = blue; 2 = green)
		RC5 = 1;							//RED
		RC6 = 0;
		RC7 = 0;
	}
	else if(ledColor == 1)
	{
		RC5 = 0;							//BLUE
		RC6 = 1;
		RC7 = 0;
	}
	else if(ledColor == 2)
	{
		RC5 = 0;							//GREEN
		RC6 = 0;
		RC7 = 1;
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
