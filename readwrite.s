.data
	number:       .word  0                                      @user number
	target:       .word  0x21000                                @target address
	prompt:       .asciz "Enter a number\n"                     @first message to print out
	format:       .asciz "%d"                                   @scanf format
	output_msg:   .asciz "You entered: %d\n"                    @print out user number after input
	moving_msg:   .asciz "Moving data to RAM address 0x21000\n" @msg to let user know RAM address location
	final_msg:    .asciz "Data in address 0x21000: %d\n"        @print data stored in 0x21030 to check
.text
	.global main
	.extern scanf
	.extern printf

main:
	ldr r0, =prompt        	@load msg in r0
	bl printf              	@print msg

	ldr r0, =format	       	@load first argument of scanf
	ldr r1, =number        	@load address to store variable into r1
	bl scanf               	@scanf

	ldr r1, =number       	@load address of variable into r1
	ldr r1, [r1]          	@load value stored in the address into r1
	ldr r0, =output_msg    	@load second message into r0
	bl printf              	@printf

	ldr r0, =moving_msg    	@load msg to let user know which address
	bl printf             	@printf

	ldr r0, =number        	@load address of input into r0
	ldr r0, [r0]           	@load value stored into r0
	ldr r1, =target	       	@load address of target address value into r1
	ldr r1, [r1]	       	@load target address value 0x21000 into r1
	str r0, [r1]           	@write user input into RAM memory location 0x21000

	ldr r1, =0x21000       	@load address 0x21000 into r1
	ldr r1, [r1]           	@load value stored in 0x21000 into r1
	ldr r0, =final_msg     	@load final message into r0
	bl printf	       		@printf

	mov r0, #0             	@exit code
	mov r7, #1
	swi 0                  	@interupt to exit function




