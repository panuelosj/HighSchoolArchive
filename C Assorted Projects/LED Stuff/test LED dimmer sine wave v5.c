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
#include <math.h>	//includes sine function

__CONFIG(FOSC_INTRCIO & WDTE_OFF & PWRTE_OFF & MCLRE_OFF & CP_OFF & CPD_OFF & BOREN_OFF & IESO_OFF & FCMEN_OFF);


//Define Constants - the compiler does a substitution

		//math
#define PI 3.14159265

#define on 1
#define off 0

#define LEDred RB5
#define LEDblue RB6
#define LEDgreen RB7

#define UpB RA5
#define DownB RA4

#define pressed 0					// -----------------WARNING - CHECK BASED ON HARDWARE
#define unpressed 1					// -----------------WARNING - CHECK BASED ON HARDWARE

#define maxDutyCycle 100

#define sec 1000000


//Global Variables

		//button input vars
int UpHeld = 0;				//RA5 held in last cycle (1-held, 0-not held)
int DownHeld = 0;			//RA4 held in last cycle
int holdDoubleTap = 0;		//counts how many cycles between last time button let go; prevent a double tap
int cycleIncrement = 1;		//sets how much to add to duty cycle for every button press

		//color specific vars
int ledColor = 0;			//which led color being manipulated currently (0=red; 1=blue; 2=green)
int ledDutyCycle = 0;		//determines cycle number when LED turns off
int pWidthRed = 0;			//pulse width of red
int pWidthBlue = 0;			//pulse width of blue
int pWidthGreen = 0;		//pulse width of green

		//loop increment vars
int i;						//loop repeat length
int j;						//loop repeat length - nested 1

		//math vars - sine function
int sinCounter = 0;			//counter to wait until degree switches; period length ~3.6 sec
int sinDegree = 0;			//determines the address to read from array sineFunction; input for dutyCycles
float angleDegree;

		//global counter
int cycleNumber = 1;		//cycle the PIC is currently in (1 to 100)


//Arrays; note, always read 0-7

int ledArray[8] = {0b00000001, 0b00000010, 0b00000100, 0b00001000, 0b00010000, 0b00100000, 0b01000000, 0b10000000};
						//determines which LED is on, converts variable for ledValue to PORTC input
char sineFunction[72];


//PREDEFINE PROCEDURES: procedure must be defined before you can use them

		//INITIALIZATION PROCEDURES
void init_hardware(void);			//initialize hardware
void start_animation(void);			//start animation (flash lights)

		//INPUT PROCEDURES
void sine_generate(void);			//creates the duty cycle based on a sine wave
void sine_parse(void);
void check_button(void);			//checks button

		//OUTPUT PROCEDURES
void light_LEDs(void);				//turn light on and off based on variable; runs for 100 cycles



//--------------------------Main Procedure------------------------------------------

void main(void)
{
	init_hardware();				//{broadcast} runs "init_hardware()" below
	
	sine_generate();				//{broadcast} sine generating procedure
	start_animation();
	
	RC0 = 1;						//turns on idiot light; constant for 100% brightness
	
	
	while(1)						//forever loop
	{
		//check_button();				//{broadcast} button-checking procedure
		light_LEDs();					//{broadcast} led-lighting procedure
		
		if(cycleNumber == 100)			// cycle counter
		{									// 100 cycles = 0.1 ms = 1 frame (100% pulse width)
			cycleNumber = 1;
			sine_parse();				//{broadcast} sine-taking procedure
			RC4 = !RC4;					//TEMP DEBUG CODE
		}
		else
		{
			cycleNumber++;	
		}
	}
}
					

//---------------------------Outside Procedures; run by {broadcast}-----------------

void sine_parse(void)
{
	if(sinCounter >= 5)										//color change speed counter
	{														//number controls how many cycles before color changes
		sinCounter = 1;
		if(sinDegree >= 71)
		{
			sinDegree = 0;
		}
		else
		{
			sinDegree++;
		}
		
		pWidthRed = sineFunction[sinDegree];
		if(sinDegree > 47)
		{
			pWidthBlue = sineFunction[sinDegree-48];
		}
		else
		{
			pWidthBlue = sineFunction[sinDegree+24];
		}
		if(sinDegree > 23)
		{
			pWidthGreen = sineFunction[sinDegree-24];
		}
		else
		{
			pWidthGreen = sineFunction[sinDegree+48];
		}
	}
	else
	{
		sinCounter++;
	}
}

//----------------------------------------------------------------------------------

void sine_generate(void)
{
	for(i=0; i<72; i++)
	{
		angleDegree = sin (i * 5 * PI/180);
		angleDegree++;
		angleDegree = angleDegree/2 * maxDutyCycle;
		sineFunction[i] = (char) angleDegree;
		RC4 = !RC4;
	}
}

//----------------------------------------------------------------------------------

void check_button(void)
{
	if(RA5 == pressed && UpHeld == 0)	//Up Button cycles through LED brightness; checks for leading edge
	{
		cycleIncrement = ledDutyCycle/10;	//sets the cycle increment
		if(cycleIncrement == 0)				//sets minimum to 1 in case it gets stuck
		{
			cycleIncrement = 1;
		}
		holdDoubleTap = 0;									//resets double tap timer
		ledDutyCycle = ledDutyCycle + cycleIncrement;		//var: cycles through 1%-30% (this section has most light change)
		if(ledDutyCycle > maxDutyCycle)						//high threshold check
		{
			ledDutyCycle = 0;									//loops back to 0 when over highest threshold
		}
		UpHeld = 1;											//sets held to 1, so next cycle does not read it as button press
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


//----------------------------------------------------------------------------------

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

//----------------------------------------------------------------------------------

void start_animation(void)		//program start animation
{
	LEDred = 1;
	for(i=0; i<8; i++)
	{								
		PORTC = ledArray[i];		
		_delay(sec/35);				
	}								
	LEDred = 0;
	LEDblue = 1;
	
	for(i=0; i<8; i++)			
	{
		PORTC = ledArray[i];
		_delay(sec/35);
	}
	LEDblue = 0;
	LEDgreen = 1;
	
	for(i=0; i<8; i++)			
	{
		PORTC = ledArray[i];
		_delay(sec/35);
	}
	LEDgreen = 0;
}

//----------------------------------------------------------------------------------

void init_hardware(void)		//set it and forget it, setup your hardware here
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
