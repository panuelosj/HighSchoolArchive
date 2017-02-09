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
			added servo
			commenting
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
#define active 0
#define inactive 1
									// Software constats
#define minChange 10				//minimum number of cycles before recognizing black-black (with changeCounter)
#define thresh 0b11000111			//analog treshold between black and white
#define blackLength 10
#define sec 1000000
#define aLittle 800000
#define turn90 1300000
#define turn180 2600000
#define maxDuty 100
									//PID constants		(comments contain previous tuning values)
#define Kp 70								//90		//35 * 4/5		//30		//55
#define Ki 1								//10		//10 * 1/15		//10		//1
#define Kd 700											//75 * 4/3		//93		//700



//Global Variables
int i = 0;
int loopExit = 0;				//temporary code for exiting loops
int changeCounter = 0;			//used to ignore misreads
int blackBlackCounter = 0;		//counts black-black
int readSensR;					//analog sensor R reading
int readSensL;					//analog sensor L reading

	//PID Vars		
signed int error;				//error (difference between sensors)
signed int integralError = 0;	//running total of errors
signed int pastError = 0;		//error of previous cycle
signed int derivativeError;		//speed at which error changes between cycles

signed int P_turn;				//proportional value
signed int I_turn;				//integral value
signed int D_turn;				//derivative value
signed int totalTurn;			//total of above

	//PWM Vars
int statMotorR = 1;				//controls motor status
int statMotorL = 1;					// 1 = forward, 2 = backward, 0 = off
int dutyMotorR = 90;			//controls motor speed (duty cycle)
int dutyMotorL = 90;				// 90 = 90% speed
int PWMCounter = 0;				//counts up for PWM (0 to 100)



//PREDEFINE PROCEDURES: procedure must be defined before you can use them
void init_hardware(void);			//initialize hardware
void start_animation(void);			//start animation (flash lights)

void ADC_convert(void);				//reads analog sensors (greyscale value)
void PID_controller(void);			//calculates PID values based on errors between analog sensor readings
void PWM_PID_convert(void);			//uses PID output and converts it to a percentage for duty cycle to control motor speed
void PWM_reset(void);				//restarts duty cycle back to 0 count and turns all motors on
void PWM_check(void);				//shuts motors off if they are over the duty cycle
void black_black_check(void);		//compares to threshold to check for a junction

void move_forwards_aLittle(void);	//premade procedures for junctions
void move_180(void);				
void move_stop(void);				

void servo_on(void);				//servo controllers
void servo_off(void);



//--------------------------Main Procedure------------------------------------------
void main(void)
{
	init_hardware();				//initialize hardware

	idLED = on;
	while(buttonA == 0){}			//wait until button is pressed
	idLED = off;
	loopExit = 1;
	
	while(loopExit == 1)			//can be used to end program (not used in current compilation)
	{
		if(PWMCounter < 99)			//runs the dutyCounter up to 100
		{
			PWMCounter++;
		}
		else						//resets cycle back to 0
		{
			ADC_convert();						//reads analog sensors
			PID_controller();					//calculates turning offset based on difference to the center
			PWM_PID_convert();					//uses offset calculated by PID to calculate duty cycle for motors
			black_black_check();				//digital black-black sensor, counter, and case controller
			PWM_reset();						//resets all motors to on for next duty cycle
		}
		PWM_check();				//checks when to turn motors off to control speed
	}
	
	move_stop();			//PROGRAM END
	integralError = 0;
	pastError = 0;
	_delay(999999);
	
}
					

//---------------------------Outside Procedures; run by {broadcast}-----------------

void ADC_convert(void)			//Reads analog sensors for use in calculating offset
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
	
	readSensR = readSensR * 9 / 10;				//offset to equalize difference in sensor readings
	readSensR = readSensR + 25;
}

void black_black_check(void)	//Checks for junction
{
	if(readSensL >= thresh && readSensR >= thresh)	//if both sensors black (acts like a digital sensor)
	{
		changeCounter++;					//counter for black-black readings (must be black-black for 10 consecutive cycles)
		if(changeCounter > blackLength)	
		{
			changeCounter = 0;					//reset misread counter
			blackBlackCounter++;				//increment counter to register a black-black
			
					//------------------CASES---------------------------------------
			if(blackBlackCounter == 1)
			{
				move_forwards_aLittle();
				servo_off();
			}
			else if(blackBlackCounter == 2 || blackBlackCounter == 4 || blackBlackCounter == 6) 
			{
				move_stop();
				servo_on();
				_delay(sec);
				move_180();
			}
			else if(blackBlackCounter == 3 || blackBlackCounter == 5 || blackBlackCounter == 7)
			{
				move_stop();
				servo_off();
				_delay(sec);
				move_180();
			}
			else
				move_180();
			
			integralError = 0;				//reset PID vars to prevent previous accumulation from carrying through
			pastError = 0;
			derivativeError = 0;
		}
	}
	else
		changeCounter = 0;			//reset black-black counter if consecutive black-black is interrupted
}

//---------------------PID CONTROLLER-----------------------------------------------
void PID_controller(void)		//Calcuate PID based on offset and previous data
{
	error = readSensL - readSensR;
	
	derivativeError = error - pastError;			//Derivative	(how fast the offset is changing from one to another)
	D_turn = Kd * derivativeError;				
	pastError = error;
	
	integralError += error;							//Integral		(how much offset has accumulated in the past)
	I_turn = integralError * Ki;	
	
	P_turn = Kp * error;							//Proportional	(how off is the robot from the middle)

	totalTurn = P_turn + I_turn + D_turn;			//Summation
	totalTurn = totalTurn / 100;
}

void PWM_PID_convert(void)		//Translate PID output to motor speed (also controls motor direction if necessary)
{
	if(totalTurn > 0)						//turn Right
	{
		sensR = 0;							//indicator LEDs
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
		
		sensR = 1;							//indicator LEDs
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
void PWM_check(void)					//turns off motor once duty cycle is finished
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

void PWM_reset(void)					//turns motors on at the start of the duty cycle
{
	idLED = !idLED;
	PWMCounter = 0;
	
	if(statMotorR == 1)						//right motor
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
	
	if(statMotorL == 1)						//left motor
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

void move_forwards_aLittle(void)		//really? Just as it says - move forwards for a little bit
{
	leftF = 1;
	leftB = 0;
	rightF = 1;
	rightB = 0;
	_delay(aLittle);
}

void move_180(void)
{
	leftF = 0;							//move backwards a bit
	leftB = 1;
	rightF = 0;
	rightB = 1;
	_delay(sec*3/4);					
	leftF = 1;							//turn a bit to prevent checking the perpendicular
	leftB = 0;
	rightF = 0;
	rightB = 1;
	_delay(sec*3/2);
	ADC_convert();
	while(readSensR < 0b11100000)		//continue turning until black is seen
	{
		ADC_convert();
		_delay(50);
	}
}

void move_stop(void)					//shuts down all motors
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
	
	//initialize speed - runs at 8MHz
	IRCF0 = 1;
	IRCF1 = 1;
	IRCF2 = 1;
}
