/* author: Jonathan P.
	last update: 03-09-2013
	Description: test to dim LEDs
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

#define LButton RA5
#define RButton RA4

#define sec 1000000


//Global Variables

int LBheld = 0;			//
int RBheld = 0;			//

int ledValue = 0;		//determines output LED lights; 0-7 (right to left)
int blinkTimer = 0;		//
int timer = 0;			//
int reactTime = 0;		//

int randomTime = 0;		//determines length of time wait is

int i;					//determines loop repeat length
int j;					//determines loop repeat length - nested 1


//Arrays; note, always read 0-7

int ledArray[8] = {0b00000001, 0b00000010, 0b00000100, 0b00001000, 0b00010000, 0b00100000, 0b01000000, 0b10000000};
						//determines which LED is on, converts variabe for ledValue to PORTC input
int ledIdleAni[12] = {0b00000011, 0b00000101, 0b00001001, 0b00010001, 0b00100001, 0b01000001, 0b10000001, 0b01000001, 0b00100001, 0b00010001, 0b00001001, 0b00000101};
						//lights for idle animation
int ledWaitAni[6] = {0b00010001, 0b00101001, 0b01000101, 0b10000011, 0b01000101, 0b00101001};
						//lights for waiting animation

//PREDEFINE PROCEDURES: procedure must be defined before you can use them

void init_hardware(void);			//initialize hardware
void error(void);

//--------------------------Main Procedure------------------------------------------

void main(void)
{
	init_hardware();				//{broadcast} runs "init_hardware()" below
	RC0 = 1;						//idiot light - always on
	randomTime = rand() % 5001 + 2000;
	
	while(RA5 == 0)					//wait until ready button is pressed
	{
		_delay(sec/1000);
		blinkTimer++;
		if(blinkTimer>100)
		{
			blinkTimer = 0;
			if(ledValue>=11)
			{
				ledValue = 0;
			}
			else
			{
				ledValue++;
			}
		}
		PORTC = ledIdleAni[ledValue];
	}
	
	blinkTimer = 0;
	PORTC = 0b00000000;
	RC0 = 1;
	ledValue = 0;
	
	while(timer < randomTime)
	{
		_delay(sec/1000);
		timer++;
		blinkTimer++;
		if(blinkTimer>100)
		{
			blinkTimer = 0;
			if(ledValue>=5)
			{
				ledValue = 0;
			}
			else
			{
				ledValue++;
			}
		}
		if(RA5 == 0 || RA4 == 1)
		{
			error();
			return;
		}
		PORTC = ledWaitAni[ledValue];
	}
	
	blinkTimer = 0;
	PORTC = 0b11111111;
	
	while(RA4 == 0)
	{
		_delay(sec/100);
		reactTime++;
		blinkTimer++;
		if(blinkTimer > 100)
		{
			blinkTimer = 0;
			PORTC = 0b00000001;
		}
		else if(blinkTimer > 50)
		{
			PORTC = 0b11111111;
		}
	}
	if(RA5 == 1 || reactTime > 128)
	{
		error();
		return;
	}
	PORTC = 0b11111111;
	_delay(1*(sec/10));
	PORTC = 0b00000000;
	_delay(1*(sec/10));
	
	PORTC = reactTime;
	
	while(RA4 == 0 || RA5 == 0)
	{
		_delay(sec/100);
	}
	PORTC = 0b11111111;
	while(RA4 == 1 || RA5 == 1)
	{
		_delay(sec/100);
	}
	error();
}
					

//---------------------------Outside Procedures; run by {broadcast}-----------------


void error(void)
{
	for(i = 0; i < 3; i++)
	{
		PORTC = 0b11111111;
		_delay(1*(sec/10));
		PORTC = 0b00000000;
		_delay(1*(sec/10));
	}
	_delay(sec);		//end program
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
