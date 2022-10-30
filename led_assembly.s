.data																								@initialise data
	userinput:   	 .word  0																		@variable to store user input
	format:      	 .asciz "%d"																	@format to scanf user input
	error:	     	 .asciz "Error during setup, exiting"			                     			@error messaage if wiringPiSetup fails
	prompt:       	 .asciz "Enter a number\n1 - turn on the red LED\n2 - turn on the green LED\n"	@prompt message
	prompt_cont:	 .asciz "3 - turn off both LEDs\n0 - exit\n"					                @prompt continued
	invalid_msg:	 .asciz "Invalid input!\n"							                            @message when user enter invalid number
	green:       	 .int    1									                                    @wiring pin for green led
	red:		     .int    0									                                    @wiring pin for red led
	OUTPUT           =       1									                                    @define output for pinmode

.text
	.global main
	.extern printf			@to print message
	.extern scanf			@to store user data
	.extern wiringPiSetup	@initialise wiringpi
	.extern pinMode 		@initialise whether wiring pin is input or output (LEDs are outputs)
	.extern digitalWrite	@to turn on or turn off led

main:
	bl  wiringPiSetup		@call wiringPiSetup to initialise wiringPi, return value will be in r0
	mov r1, #0				@load value 0 into r1
	cmp r0, r1				@compare wiringPiSetup return value to r1
	beq init				@if equal, continue to initialise, branch to init
	ldr r0, =error			@if not, error, load error message into r0
	bl  printf				@print error message using printf
	b   end					@end program

init:						@initialise red and green led using pinMode
	ldr r0, =red			@load address of value of red led pin into r0
	ldr r0, [r0]			@load value of red led pin into r0
	mov r1, #OUTPUT			@load OUTPUT value into r1
	bl  pinMode				@call pinMoode, red led is now initialised as output

	ldr r0, =green			@load address of value of green led pin into r0
	ldr r0, [r0]			@load value of green led pin into r0
	mov r1, #OUTPUT			@load OUTPUT value into r1
	bl  pinMode				@call pinMode, green led is now initialised as output

	ldr r0, =green			@load address of value of green led pin into r0
	ldr r0, [r0]			@load value of green led pin into r0
	mov r1, #0				@load 0 value into r1
	bl  digitalWrite		@call digitalWrite to turn off green led

	ldr r0, =red			@load address of value of red led pin into r0
	ldr r0, [r0]			@load value of red led pin into r0
	mov r1, #0				@load 0 value into r1
	bl  digitalWrite		@call digitalWrite to turn off red led

	b   loop				@branch to loop

loop:	ldr r0, =prompt		@load first half of prompt message into r0
	bl  printf				@print first half of prompt message
	ldr r0, =prompt_cont	@load second half of prompt mmessage into r0
	bl  printf				@print second half of prompt message

	ldr r0, =format			@load scanf format into r0
	ldr r1, =userinput		@load address to store user input into r1
	bl scanf				@call scanf to store value into user input

	ldr r0, =userinput		@load address of userinput into r0
	ldr r0, [r0]			@load value of userinput into r0

	cmp r0, #0				@compare userinput to value of 0
	beq end_demo			@if equal, end the program

	blt default				@if less than 0, branch to default
	cmp r0, #3				@compare userinput to value of 3
	bgt default				@if more than 3, branch to default

	cmp r0, #1				@compare userinput to value of 1
	beq red_on				@if equal, branch to red_on function to turn red led on

	cmp r0, #2				@compare userinput to value of 2
	beq green_on			@if equal, branch to green_on function to turn green led on

	cmp r0, #3				@compare userinput to value of 3
	beq turn_off			@if equal, branch to turn_off function to turn both led off

red_on:						@function to turn red led on
	ldr r0, =red			@load address of value of red led pin into r0
	ldr r0, [r0]			@load value of red led pin into r0
	mov r1, #1				@load value of 1 into r1
	bl digitalWrite			@call digitalWrite to turn red led on

	b   loop				@branch back to loop to continue program

green_on:					@function to turn green led on
	ldr r0, =green			@load address of value of green led pin into r0
	ldr r0, [r0]			@load value of green led pin into r0
	mov r1, #1				@load value of 1 into r1
	bl  digitalWrite		@call digital write to turn green led on

	b   loop				@branch back to loop to continue program

turn_off:					@function to turn both led off
	ldr r0, =red			@load address of value of red led pin into r0
	ldr r0, [r0]			@load value of red led pin into r0
	mov r1, #0				@load value of 0 into r1
	bl  digitalWrite		@call digitalWrite to turn red led off

	ldr r0, =green			@load address of value of green led pin into r0
	ldr r0, [r0]			@load value of green led pin into r0
	mov r1, #0				@load value 0 into r1
	bl  digitalWrite		@call digitalWrite to turn green led off

	b   loop				@branch back to loop to continue program

end_demo:					@user enter 0 to end program, turn both led off
	ldr r0, =red			@load address of value of red led pin into r0
	ldr r0, [r0]			@load value of red led pin into r0
	mov r1, #0				@load value of 0 into r1
	bl  digitalWrite		@call digitalWrite to turn red led off

	ldr r0, =green			@load address of value of green led pin into r0
	ldr r0, [r0]			@load vlaue of green led pin into r0
	mov r1, #0				@load value of 0 into r1
	bl  digitalWrite		@call digitalWrite to turn green led off

	b   end					@branch to end to end program

default:					@user enter invalid input
	ldr r0, =invalid_msg	@load invalid msg into r0
	bl  printf				@call printf to print invalid msg
	b   loop				@branch back to loop

end:						@code to end program
	mov r0, #0
	mov r7, #1				@exit syscall
	swi 0					@software interupt to end program


