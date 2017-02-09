/* -------------------------------------------------------------------------------------------
	author: Jonathan P.
		/\
	   /\/\
		last update: 09-05-2013
		Description: moving a robot - line following
	UPDATE: added Proportional Calculations
			added Integral Calculations
			added Derivative Calculations
			tuning
		Hardware setup:
			Left Motor		- RC6 and RC3 ; Pin 8 and 8
			Right Motor		- RC5 and RC4 ; Pin 5 and 6
			
			Left Light Sensor - RA2
			Right Light Sensor - RC0
			
			Analog Left Sensor - AN11
			
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

#define anSensR AN10
#define anSensL AN11

#define servo RC2

#define buttonA RC7
#define idLED RB6



#define on 1						// Software state readability shorthand
#define off 0

#define black 0
#define white 1

#define pressed 1					
#define unpressed 0					

#define active 1
#define inactive 0

									// Software constats
#define minChange 10				//minimum number of cycles before recognizing black-black (with changeCounter)
#define thresh 0b11000111			//analog treshold between black and white
#define blackLength 10
#define sec 1000000
#define aLittle 800000
#define turn90 1300000
#define turn180 2600000
#define maxDuty 100

									//PID constants
#define Kp 70								//90		//35 * 4/5		//30		//55
#define Ki 1								//10		//10 * 1/15		//10		//1
#define Kd 700											//75 * 4/3		//93		//700

//Global Variables

int i = 0;
int loopExit = 0;				//temp code for exiting loops

int changeCounter = 0;			//used to ignore misreads
int blackBlackCounter = 0;		//counts black-black

int readSensR;					//analog sensor R reading
int readSensL;					//analog sensor L reading


	//PID Vars		
signed int error;				//error (difference between sensors)

signed int integralError = 0;	//running total of errors

signed int pastError = 0;
signed int derivativeError;

signed int P_turn;
signed int I_turn;
signed int D_turn;

signed int totalTurn;




int statMotorR = 1;		//controls motor status
int statMotorL = 1;			// 1 = forward, 2 = backward, 0 = off
int dutyMotorR = 90;	//controls motor speed (duty cycle)
int dutyMotorL = 90;		// 90 = 90% speed

int PWMCounter = 0;		//counts up for PWM (0 to 100)


//Arrays; note, always read 0-7


//PREDEFINE PROCEDURES: procedure must be defined before you can use them

void init_hardware(void);			//initialize hardware
void start_animation(void);			//start animation (flash lights)

void ADC_convert(void);
void PID_controller(void);
void PWM_PID_convert(void);

void PWM_reset(void);				//restarts duty cycle back to 0 count
void PWM_check(void);				//shuts motors off if they are over the duty cycle

void black_black_check(void);		//compares to threshold to check for a junction

void move_forwards_aLittle(void);
void move_180(void);
void move_left_90(void);
void move_right_90(void);
void move_stop(void);

void servo_on(void);
void servo_off(void);



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
			
			ADC_convert();			
			PID_controller();
			PWM_PID_convert();
			
			black_black_check();
			PWM_reset();
		}
		
		PWM_check();		
		
	}
	move_stop();
	
	integralError = 0;
	pastError = 0;
	_delay(999999);
	
}
					

//---------------------------Outside Procedures; run by {broadcast}-----------------

void ADC_convert(void)
{
	ADCON0 = 0b00101001;				//right AN10
	GO_nDONE = 1;							//starts ADC					--------------------!!!!! WARNING - DO NOT COMBINE WITH ADCON0	
	while(GO_nDONE != 0){}
	readSensR = ADRESH;
	
	_delay(5);							//delay to prevent interference between reading sensors
	
	ADCON0 = 0b00101101;				//left AN11
	GO_nDONE = 1;							//starts ADC					--------------------!!!!! WARNING - DO NOT COMBINE WITH ADCON0	
	while(GO_nDONE != 0){}
	readSensL = ADRESH;
	
//	ADCON0 = 0b00000000;					//turns off ADC to conserve power ------------------!!!!! WARNING - DO NOT DO THIS

//	readSensR = readSensR + 0b00010110;			//offset to equalize difference in sensor readings
	readSensR = readSensR * 9 / 10;
	readSensR = readSensR + 25;
}

void black_black_check(void)
{
	if(readSensL >= thresh && readSensR >= thresh)
	{
		changeCounter++;			//ignore black-black misreadings
		if(changeCounter > blackLength)			//constant is number of cycles before black-black registers
		{
			changeCounter = 0;				//reset counter
			blackBlackCounter++;
			
			if(blackBlackCounter == 1)
			{
				move_forwards_aLittle();
			}
			else
			{
				move_180();
			}
			integralError = 0;				//reset PID vars
			pastError = 0;
			derivativeError = 0;
			
		}
	}
	else
	{
		changeCounter = 0;
	}
}


//---------------------PID CONTROLLER-----------------------------------------------
void PID_controller(void)
{
	error = readSensL - readSensR;
	//DERIVATIVE-------------------------------------------------------------------
	derivativeError = error - pastError;
	D_turn = Kd * derivativeError;				//*4/5
	pastError = error;
	
	
	//INTEGRAL---------------------------------------------------------------------
	integralError += error;
	I_turn = Ki * integralError;					//15
	
	
	//PROPORTIONAL-----------------------------------------------------------------
	P_turn = Kp * error;							//*4/3

	//SUMMATION--------------------------------------------------------------------
	totalTurn = P_turn + I_turn + D_turn;
	totalTurn = totalTurn / 100;
}

//---------------------math to translate PID output to motor PWM input--------------
void PWM_PID_convert(void)
{
	if(totalTurn > 0)						//turn Right
	{
		
		sensR = 0;							//indicators
		sensL = 1;
		
		statMotorR = 1;
		dutyMotorR = 100;
		if(totalTurn > 100)
		{
			statMotorL = 2;
			dutyMotorL = 100 - totalTurn;
		}
		else
		{
			statMotorL = 1;
			dutyMotorL = 100 - totalTurn;
		}
	}
	if(totalTurn < 0)						//turn Left
	{
		
		sensR = 1;							//indicators
		sensL = 0;
		
		totalTurn = totalTurn * -1;
		statMotorL = 1;
		dutyMotorL = 100;
		
		if(totalTurn > 100)
		{
			statMotorR = 2;
			dutyMotorR = 100 - totalTurn;
		}
		else
		{
			statMotorR = 1;
			dutyMotorR = 100 - totalTurn;
		}
	}
}

//---------------------PWM BLOCK----------------------------------------------------
void PWM_check(void)
{
	if(PWMCounter > dutyMotorL)
	{
		leftF = off;
		leftB = off;
	}
	if(PWMCounter > dutyMotorR)
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

void servo_on(void)
{
	servo = active;
}
void servo_off(void)
{
	servo = inactive;
}

void move_forwards_aLittle(void)
{
	leftF = 1;
	leftB = 0;
	rightF = 1;
	rightB = 0;
	_delay(aLittle);
}

void move_left_90(void)
{
	leftF = 1;
	leftB = 0;
	rightF = 0;
	rightB = 1;
	_delay(turn90);
}

void move_right_90(void)
{
	leftF = 0;
	leftB = 1;
	rightF = 1;
	rightB = 0;
	_delay(turn90);
}

void move_180(void)
{
	leftF = 1;							//move forwards a bit
	leftB = 0;
	rightF = 1;
	rightB = 0;
	_delay(100000);
	leftF = 1;							//turn a bit to prevent checking the perpendicular
	leftB = 0;
	rightF = 0;
	rightB = 1;
	_delay(1000000);
	ADC_convert();
	while(readSensR < 0b01110000)		//continue turning until black is seen
	{
		ADC_convert();
		_delay(50);
	}
}

void move_stop(void)
{
	leftF = 0;
	leftB = 0;
	rightF = 0;
	rightB = 0;
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
	ANSELH = 0b00001100; //n/c, n/c, n/c, n/c, AN11, AN10, AN9, AN8
	
	//set pins as Input(1) or Output(0)
	TRISA = 0b00000000;	//set direction of port pins through the tri-state		xRA2 = SensL
							//(output = 0, input = 1)
	TRISB = 0b00110000;		//													RB4 = anSensR, RB5 = anSensL
	TRISC = 0b10000000;		//													xRC0 = SensR, RC7 = ButtonA
	
	//initialize the ports
	PORTA = 0b00000000;	//Clear (GND) all the output pins
							//(0 = GND, 1 = 5V)
	PORTB = 0b00000000;	//RB7, RB6, RB5, RB4, n/c, n/c, n/c, n/c
	PORTC = 0b00000000; //Initializes LEDs
	
	//initialize ADC
	ADCON0 = 0b00000001;		// Justify 0 (left);	VoltRef 0 (none);	ChannelSel <5:2> (4-bit bin);	GO_nDONE 0 (idle);	ADC 1 (enable)
	ANSELH = 0b00001100;
	
	//initialize speed
	IRCF0 = 1;
	IRCF1 = 1;
	IRCF2 = 1;
}
