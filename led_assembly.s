@; led manipulation in assembly
@; user input 1 - turn on red LED
@; user input 2 - turn on green LED
@; user input 3 - turn off both LEDs

@; data section
.data
	.balign 4										@; ensure variable is 4 byte aligned
	userinput:										@; variable to store user input
		.word  0

	.balign 4										@; ensure variable is 4 byte aligned
	format:											@; format for scanf
		.asciz "%d"

	.balign 4										@; ensure variable is 4 byte aligned
	error:											@; error message if wiringPiSetup fails
		.asciz "Error during setup, exiting"

	.balign 4										@; ensure variable is 4 byte aligned
	prompt:											@; prompt message for user input
		.asciz "Enter a number\n1 - turn on the red LED\n"

	.balign 4										@; ensure variable is 4 byte aligned
	prompt_cont:										@; second half of prompt message
		.asciz "2 - turn on the green LED\n3 - turn off both LEDs\n0 - exit\n"

	.balign 4										@; ensure variable is 4 byte aligned
	invalid_msg:										@; message to print when user keys invalid input
		.asciz "Invalid input!\n"

	.balign 4										@; ensure variable is 4 byte aligned
	green:											@; wiring pi pin for green led
		.int    1									@; green led is connected to physical pin 12, wiring pi pin 1

	.balign 4										@; ensure variable is 4 byte aligned
	red:											@; wiring pi pin for red led
		.int    0									@; red led is connected to physical pin 11, wiring pi pin 0

	OUTPUT = 1										@; define output for pinmode

.text
	.balign 4			@; ensure function sections starts 4 byte aligned
	.global main			@; entry of the program
	.extern printf			@; to print message
	.extern scanf			@; to store user data
	.extern wiringPiSetup		@; initialise wiringpi
	.extern pinMode 		@; initialise whether wiring pin is input or output (LEDs are outputs)
	.extern digitalWrite		@; to turn on or turn off led

main:
	PUSH {ip, lr}			@; store return address, ie link register and ip (intra procedural call) register in Stack
	BL  wiringPiSetup		@; call wiringPiSetup to initialise wiringPi, return value will be in r0
	MOV R1, #0			@; load value 0 into r1
	CMP R0, R1			@; compare wiringPiSetup return value to r1
	BEQ init			@; if equal, continue to initialise, branch to init
	LDR R0, addr_of_error		@; if not, error, load error message into r0
	BL  printf			@; print error message using printf
	B   end				@; end program

init:					@; initialise red and green led using pinMode
	LDR R0, addr_of_red		@; load address of value of red led pin into r0
	LDR R0, [R0]			@; load value of red led pin into r0
	MOV R1, #OUTPUT			@; load OUTPUT value into r1
	BL  pinMode			@; call pinMoode, red led is now initialised as output

	LDR R0, addr_of_green		@; load address of value of green led pin into r0
	LDR R0, [R0]			@; load value of green led pin into r0
	MOV R1, #OUTPUT			@; load OUTPUT value into r1
	BL  pinMode			@; call pinMode, green led is now initialised as output

	LDR R0, addr_of_green		@; load address of value of green led pin into r0
	LDR R0, [R0]			@; load value of green led pin into r0
	MOV R1, #0			@; load 0 value into r1
	BL  digitalWrite		@; call digitalWrite to turn off green led

	LDR R0, addr_of_red		@; load address of value of red led pin into r0
	LDR R0, [R0]			@; load value of red led pin into r0
	MOV R1, #0			@; load 0 value into r1
	BL  digitalWrite		@; call digitalWrite to turn off red led

	B   loop			@; branch to loop

loop:
	LDR R0, addr_of_prompt		@; load first half of prompt message into r0
	BL  printf			@; print first half of prompt message
	LDR R0, addr_of_prompt_cont	@; load second half of prompt mmessage into r0
	BL  printf			@; print second half of prompt message

	LDR R0, addr_of_format		@; load scanf format into r0
	LDR R1, addr_of_input		@; load address to store user input into r1
	BL scanf			@; call scanf to store value into user input

	LDR R0, addr_of_input		@; load address of userinput into r0
	LDR R0, [R0]			@; load value of userinput into r0

	CMP R0, #0			@; compare userinput to value of 0
	BEQ end_demo			@; if equal, end the program

	BLT default			@; if less than 0, branch to default
	CMP R0, #3			@; compare userinput to value of 3
	BGT default			@; if more than 3, branch to default

	CMP R0, #1			@; compare userinput to value of 1
	BEQ red_on			@; if equal, branch to red_on function to turn red led on

	CMP R0, #2			@; compare userinput to value of 2
	BEQ green_on			@; if equal, branch to green_on function to turn green led on

	CMP R0, #3			@; compare userinput to value of 3
	BEQ turn_off			@; if equal, branch to turn_off function to turn both led off

red_on:					@; function to turn red led on
	LDR R0, addr_of_red		@; load address of value of red led pin into r0
	LDR R0, [R0]			@; load value of red led pin into r0
	MOV R1, #1			@; load value of 1 into r1
	BL digitalWrite			@; call digitalWrite to turn red led on

	B   loop			@; branch back to loop to continue program

green_on:				@; function to turn green led on
	LDR R0, addr_of_green		@; load address of value of green led pin into r0
	LDR R0, [R0]			@; load value of green led pin into r0
	MOV R1, #1			@; load value of 1 into r1
	BL  digitalWrite		@; call digital write to turn green led on

	B   loop			@; branch back to loop to continue program

turn_off:				@; function to turn both led off
	LDR R0, addr_of_red		@; load address of value of red led pin into r0
	LDR R0, [R0]			@; load value of red led pin into r0
	MOV R1, #0			@; load value of 0 into r1
	BL  digitalWrite		@; call digitalWrite to turn red led off

	LDR R0, addr_of_green		@; load address of value of green led pin into r0
	LDR R0, [R0]			@; load value of green led pin into r0
	MOV R1, #0			@; load value 0 into r1
	BL  digitalWrite		@; call digitalWrite to turn green led off

	B   loop			@; branch back to loop to continue program

end_demo:				@; user enter 0 to end program, turn both led off
	LDR R0, addr_of_red		@; load address of value of red led pin into r0
	LDR R0, [R0]			@; load value of red led pin into r0
	MOV R1, #0			@; load value of 0 into r1
	BL  digitalWrite		@; call digitalWrite to turn red led off

	LDR R0, addr_of_green		@; load address of value of green led pin into r0
	LDR R0, [R0]			@; load vlaue of green led pin into r0
	MOV R1, #0			@; load value of 0 into r1
	BL  digitalWrite		@; call digitalWrite to turn green led off

	B   end				@; branch to end to end program

default:				@; user enter invalid input
	LDR R0, addr_of_invalid_msg	@; load invalid msg into r0
	BL  printf			@; call printf to print invalid msg
	B   loop			@; branch back to loop

end:					@; end program
	POP {ip, pc}			@; pop ip reg, and pop lr (link reg) value to pc, return

@; addresses needed to access data
addr_of_input       : .word userinput 	@; addr_of_input is address of userinput
addr_of_format      : .word format	@; addr_of_format is address of format
addr_of_error       : .word error	@; addr_of_error is address of error
addr_of_prompt      : .word prompt	@; addr_of_prompt is address of prompt
addr_of_prompt_cont : .word prompt_cont	@; addr_of_prompt_cont is address of prompt_cont
addr_of_invalid_msg : .word invalid_msg	@; addr_of_invalid_msg is address of invalid_msg
addr_of_green       : .word green	@; addr_of_green is address of green
addr_of_red         : .word red		@; addr_of_red is address of red


