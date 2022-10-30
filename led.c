#include <wiringPi.h> // library to access GPIO
#include <stdio.h>

/******************************************************
 green LED - GPIO 18 / physical pin 12 / wiring pin 1
 red LED   - GPIO 17 / physical pin 11 / wiring pin 0
 GND       - physical pin 6
******************************************************/

/* PWM range of green LED is from 0 (0%) to 1024 (100%)*/
const int green_led = 1; // global variable green_led set to 1 as green LED is connected to wiring pin 1
const int red_led = 0;	 // global variable red_led set to 0 as red LED is connected to wiring pin 0

/* User input 0, turn off both green and red LEDs */

void turn_off_both()
{
	digitalWrite(red_led, LOW); // set value of red_led pin to LOW to turn off red LED
	pwmWrite(green_led, 0);		// set PWM value of green_led pin to 0 to turn off green LED
}

/* User input 1, turn on both green and red LED */

void turn_on_both()
{
	digitalWrite(red_led, HIGH); // set value of red_led pin to HIGH to turn on red LED
	pwmWrite(green_led, 1024);	 // set PWM value of green_led pin to 1024 to turn on green LED at 100% duty cycle
}

/*                       User input 2, blink green and red LEDs two times per second                        */
/* Each period cycle = 1000ms / 2 = 500ms. To blink LEDs, turn on and off the LEDs for equal amount of time */
/*          Hence, the LEDs will turn on for 500ms/2 = 250ms and turn off for 250ms for each cycle          */
/*     In this function, the LEDs will blink for a total for 4 seconds before returning to main function    */

void blink()
{
	for (int i = 0; i < 8; i++) // to blink 4 seconds, total number of cycles = 4000ms / 500ms = 8 cycles
	{
		digitalWrite(red_led, HIGH); // set value of red_led pin to HIGH to turn on red LED
		pwmWrite(green_led, 512);	 // set PWM value of green_led pin to 512 to turn on green LED at 50% duty cycle
		delay(250);					 // delay for 250ms
		digitalWrite(red_led, LOW);	 // set value of red_led pin to LOW to turn off red LED
		pwmWrite(green_led, 0);		 // set PWM value of green_led pin to 0 to turn off green LED
		delay(250);					 // delay for 250ms
	}
}

/*         User input 3, change the pattern of the red LED light and green LED light in different ways        */
/*                 For red LED: blink the red LED light with the pattern of 8 times per second                */
/* Each period cycle = 1000ms / 8 = 125ms. To blink LED, turn on and off the red LED for equal amount of time */
/*         Hence, the red LED will turn on for 125ms/2 = 62.5ms and turn off for 62.5ms for each cycle        */
/*             For green LED: still blinks at 2 times per second, but with the reduced brightness             */
/*                               Delay for green LED remains the same at 250ms                                */
/*     In this function, the LEDs will blink for a total for 4 seconds before returning to main function      */

void special()
{
	int k = 0;
	float duty_cycle = 0.0;		// variable to change PWM value for green LED
	for (int i = 0; i < 8; i++) // to blink 4 seconds, total number of cycles = 4000ms / 500ms = 8 cycles
	{
		/*Duty cycle pattern - 50% -> 37.5% -> 25% -> 12.5% and repeat*/

		duty_cycle = 640 - ((i % 4) + 1) * 128;

		pwmWrite(green_led, duty_cycle); // set PWM value to duty_cycle variable based on the loop iteration
		for (k = 0; k < 2; k++)			 // delay for green LED is 250ms, period of red LED cycle is 125ms, loop through red LED cycle for 250ms/125ms = 2 cycles before turning green LED off
		{
			digitalWrite(red_led, HIGH); // set value of red_led pin to HIGH to turn on red LED
			delay(62.5);				 // delay for 62.5ms
			digitalWrite(red_led, LOW);	 // set value of red_led pin to LOW to turn off red LED
			delay(62.5);				 // delay for 62.5ms
		}

		pwmWrite(green_led, 0); // set PWM value of green_led pin to 0 to turn off green LED
		for (k = 0; k < 2; k++) // loop for another two cycles of red LED to get 250ms of delay before turning green LED back on
		{
			digitalWrite(red_led, HIGH); // set value of red_led pin to HIGH to turn on red LED
			delay(62.5);				 // delay for 62.5ms
			digitalWrite(red_led, LOW);	 // set value of red_led pin to LOW to turn off red LED
			delay(62.5);				 // delay for 62.5ms
		}
	}
}

/* Main function */
int main()
{
	int userInput = 1;				// variable to store user input
	int end_demo = 0;				// end_demo = 1 to exit while loop and end program
	wiringPiSetup();				// initialises wiringPi to use wiringPi pin numbering scheme (ie red LED = 0, green LED = 1)
	pinMode(green_led, PWM_OUTPUT); // set green LED wiring pin to PWM_OUTPUT
	pinMode(red_led, OUTPUT);		// set red LED wiring pin to OUTPUT

	while (end_demo == 0)
	{
		/* Menu to get user input */
		printf("Enter a number\n");
		printf("0 - Turn both LEDs off\n");
		printf("1 - Turn both LEDs on\n");
		printf("2 - Blink both LEDs 2 times per second\n");
		printf("3 - Blink red LED 8 times per second and blink green LED 2 times per second with reduced brightness\n");
		printf("4 - Exit\n");

		scanf("%d", &userInput); // get user input and store in userInput variable

		switch (userInput) // switch case to different functions based on user's input
		{
		case 0:
			turn_off_both();
			break;
		case 1:
			turn_on_both();
			break;
		case 2:
			blink();
			break;
		case 3:
			special();
			break;
		case 4:
			end_demo++; // If user input = 4, exit the program by incrementing end_demo variable by 1 to exit while loop
			break;
		default:
			printf("Invalid input!\n");
			break;
		}
		delay(100);
	}

	/* Turn off both LEDs before exiting program */
	digitalWrite(red_led, LOW);
	pwmWrite(green_led, 0);
	return 0;
}
