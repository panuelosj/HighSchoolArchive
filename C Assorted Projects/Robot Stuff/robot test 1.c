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
*/

//--------------------------Initialization------------------------------------------
#include <pic.h>	//include a library of procedure specific to the PIC family of microcontrollers
#include <htc.h>
#include <stdlib.h>	//includes random function; srand, rand

__CONFIG(FOSC_INTRCIO & WDTE_OFF & PWRTE_OFF & MCLRE_OFF & CP_OFF & CPD_OFF & BOREN_OFF & IESO_OFF & FCMEN_OFF);


//Define Constants - the compiler does a substitution

#define on 1
#define off 0

#define leftF RC2
#define leftB RC3
#define rightF RC5
#define rightB RC4

#define sensR RA1
#define sensL RA2

#define black 0
#define white 1

#define pressed 1					
#define unpressed 0					

#define buttonA RA0
#define idLED RB6

#define minChange 10				//minimum number of cycles before recognizing black-black (with changeCounter)
#define sec 1000000


//Global Variables

int i;
int loopExit = 0;		//temp code for exiting loops

int changeCounter = 0;	//used to ignore misreads

int statMotorR = 0;		//controls motor status
int statMotorL = 0;			// 1 = forward, 2 = backward, 0 = off

int dutyMotorR = 90;	//controls motor speed (duty cycle)
int dutyMotorL = 90;		// 90 = 90% speed

int dutyCounter = 0;	//counts up for PWM (0 to 100)


//Arrays; note, always read 0-7


//PREDEFINE PROCEDURES: procedure must be defined before you can use them

void init_hardware(void);			//initialize hardware
void start_animation(void);			//start animation (flash lights)

void move_forwards(void);
void move_backwards(void);
void move_left(void);
void move_right(void);
void move_stop(void);



//--------------------------Main Procedure------------------------------------------

void main(void)
{
	init_hardware();				//{broadcast} runs "init_hardware()" below

	idLED = on;
	while(buttonA == 0){}
	idLED = off;
	loopExit = 1;
	
	while(loopExit == 1)
	{
		if(sensL == black && sensR == black)
		{
			loopExit = 0;
			move_stop();
		}
		if(sensL == black && sensR == white)
		{
			move_left();
		}
		if(sensL == white && sensR == black)
		{
			move_right();
		}
		if(sensL == white && sensR == white)
		{
			move_forwards();
		}
	}
	_delay(999999);
	
}
					

//---------------------------Outside Procedures; run by {broadcast}-----------------

void move_forwards(void)
{
	rightF = on;
	rightB = off;
	leftF = on;
	leftB = off;
}

void move_backwards(void)
{
	rightF = off;
	rightB = on;
	leftF = off;
	leftB = on;
}

void move_left(void)
{
	rightF = on;
	rightB = off;
	leftF = off;
	leftB = off;
}

void move_right(void)
{
	rightF = off;
	rightB = off;
	leftF = on;
	leftB = off;
}

void move_stop(void)
{
	rightF = off;
	rightB = off;
	leftF = off;
	leftB = off;
}

void start_animation(void)		//program start animation
{
	
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
	TRISA = 0b00000111;	//set direction of port pins through the tri-state
							//(output = 0, input = 1)
	TRISB = 0b00000000;
	TRISC = 0b00000000;
	
	//initialize the ports
	PORTA = 0b00000000;	//Clear (GND) all the output pins
							//(0 = GND, 1 = 5V)
	PORTB = 0b00000000;	//RB7, RB6, RB5, RB4, n/c, n/c, n/c, n/c
	PORTC = 0b00000000; //Initializes LEDs
	
	//initialize ADC
	//ADCON0 = 0b00101001;
	//ANSELH = 0b00000100;
	
	//initialize speed
	IRCF0 = 1;
	IRCF1 = 1;
	IRCF2 = 1;
}
