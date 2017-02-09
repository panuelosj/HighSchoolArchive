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


#define leftF RC6					// Hardware Pin identifiers
#define leftB RC3
#define rightF RC5
#define rightB RC4

#define sensR RC0
#define sensL RA2

#define buttonA RC7
#define idLED RB6



#define on 1						// Software state readability shorthand
#define off 0

#define black 0
#define white 1

#define pressed 1					
#define unpressed 0					


									// Software constats
#define minChange 10				//minimum number of cycles before recognizing black-black (with changeCounter)
#define sec 1000000


//Global Variables

int i;
int loopExit = 0;		//temp code for exiting loops

int changeCounter = 0;	//used to ignore misreads

int statMotorR = 1;		//controls motor status
int statMotorL = 1;			// 1 = forward, 2 = backward, 0 = off

int dutyMotorR = 90;	//controls motor speed (duty cycle)
int dutyMotorL = 90;		// 90 = 90% speed

int PWMCounter = 0;		//counts up for PWM (0 to 100)


//Arrays; note, always read 0-7


//PREDEFINE PROCEDURES: procedure must be defined before you can use them

void init_hardware(void);			//initialize hardware
void start_animation(void);			//start animation (flash lights)

void PWM_reset(void);				//restarts duty cycle back to 0 count
void PWM_check(void);				//shuts motors off if they are over the duty cycle

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
		if(PWMCounter < 99)			//runs the dutyCounter up to 100
		{
			PWMCounter++;
		}
		else								//resets cycle back to 0
		{
			PWM_reset();
			
			//----SENSOR CHECKING
			if(sensL == black && sensR == black)
			{
				changeCounter++;			//ignore black-black misreadings
				if(changeCounter > 20)			//constant is number of cycles before black-black registers
				{
					changeCounter = 0;				//reset counter
					loopExit = 0;
					move_stop();
				}
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
		
		PWM_check();		
		
	}
	_delay(999999);
	
}
					

//---------------------------Outside Procedures; run by {broadcast}-----------------


//---------------------PWM BLOCK----------------------------------------------------
void PWM_check(void)
{
	if(PWMCounter == dutyMotorL)
	{
		leftF = off;
		leftB = off;
	}
	if(PWMCounter == dutyMotorR)
	{
		rightF = off;
		rightB = off;
	}
}

void PWM_reset(void)
{
	idLED = !idLED;
	PWMCounter = 0;
	
	if(statMotorR == 1)					//resets right motor
	{
		rightF = on;
		rightB = off;
	}
	else if(statMotorR == 2)
	{
		rightF = off;
		rightB = on;
	}
	else
	{
		rightF = off;
		rightB = off;
	}
	
	if(statMotorL == 1)					//resets left motor
	{
		leftF = on;
		leftB = off;
	}
	else if(statMotorL == 2)
	{
		leftF = off;
		leftB = on;
	}
	else
	{
		leftF = off;
		leftB = off;
	}	
}

//---------------------MOTOR CONTROL BLOCK------------------------------------------

void move_forwards(void)
{
	statMotorR = 1;
	statMotorL = 1;
	dutyMotorR = 90;
	dutyMotorL = 90;
}

void move_backwards(void)
{
	statMotorR = 2;
	statMotorL = 2;
	dutyMotorR = 90;
	dutyMotorL = 90;
}

void move_left(void)
{
	statMotorR = 1;
	statMotorL = 1;
	dutyMotorR = 90;
	dutyMotorL = 0;
}

void move_right(void)
{
	statMotorR = 1;
	statMotorL = 1;
	dutyMotorR = 0;
	dutyMotorL = 90;
}

void move_stop(void)
{
	statMotorR = 0;
	statMotorL = 0;
	dutyMotorR = 0;
	dutyMotorL = 0;
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
	TRISA = 0b00000100;	//set direction of port pins through the tri-state
							//(output = 0, input = 1)
	TRISB = 0b00000000;
	TRISC = 0b10000001;
	
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
