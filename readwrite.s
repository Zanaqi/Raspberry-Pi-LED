@; Reading and writing into RAM
@; data section
.data
	.balign 4 					    	@; ensure variable stored is 4-byte aligned
	number:						    	@; variable to user input
		.word  0

	.balign 4 					    	@; ensure variable stored is 4-byte aligned
	target:						    	@; variable to store target address value
		.word  0x21000  				@; read and write from RAM address 0x21000

	.balign 4 					    	@; ensure variable stored is 4-byte aligned
	prompt:						    	@; define first message to prompt for user input
		.asciz "Enter a number\n"

	.balign 4 					    	@; ensure variable stored is 4-byte aligned
	format:						    	@; scanf format
		.asciz "%d"                 			@; "%d"

	.balign 4			  		    	@; ensure variable stored is 4-byte aligned
	output_msg:					    	@; define varibale to print out user input after user has key in
		.asciz "You entered: %d\n"

	.balign 4 					   	@; ensure variable stored is 4-byte aligned
	moving_msg:   						@; message to let user know which RAM address will be written
		.asciz "Moving data to RAM address 0x%x\n"

	.balign 4					    	@; ensure variable stored is 4-byte aligned
	final_msg: 				  	    	@; final message to print out the value stored in target RAM address
		.asciz "Data in address 0x%x: %d\n"

@; text section
.text
	.balign 4 			@; ensure function starts 4-byte aligned
	.global main 			@; entry of the program
	.extern scanf  			@; external function scanf to take in user input
	.extern printf			@; external function prinf to print messages in terminal

main:
	PUSH {ip, lr}
	LDR R0, addr_of_prompt 		@; load address of prompt msg in r0
	BL printf             		@; print msg

	LDR R0, addr_of_format  	@; load first argument of scanf
	LDR R1, addr_of_number  	@; load address to store variable into r1
	BL scanf              		@; scanf

	LDR R0, addr_of_output_msg	@; load address of output_msg into r0
	LDR R1, addr_of_number  	@; load address of variable into r1
	LDR R1, [R1]          		@; load value stored in the address into r1
	BL printf             		@; printf

	LDR R0, addr_of_moving_msg  	@; load msg to let user know which address
	LDR R1, addr_of_target		@; load address of target address value into r1
	LDR R1, [R1]			@; load target address value into r1
	BL printf             		@; printf

	LDR R0, addr_of_number     	@; load address of input into r0	
	LDR R0, [R0]          		@; load value stored into r0
	LDR R1, addr_of_target	   	@; load address of target address value into r1
	LDR R1, [R1]	      		@; load target address value 0x21000 into r1
	STR R0, [R1]          		@; write user input into RAM memory location 0x21000

	LDR R0, addr_of_final_msg	@; load addres of final message into r0
	LDR R1, addr_of_target     	@; load address of target address value into r1
	LDR R1, [R1]          		@; load address value stored into r2
	LDR R2, [R1]          		@; load value stored in target address into r2
	BL printf	      		@; printf

	POP {ip, lr}               	@; exit code


@; addresses needed to access data
addr_of_number     : .word number	@; addr_of_number is address of number
addr_of_target	   : .word target     	@; addr_of_target is address of target
addr_of_prompt     : .word prompt     	@; addr_of_prompt is address of prompt
addr_of_format     : .word format     	@; addr_of_format is address of format
addr_of_output_msg : .word output_msg 	@; addr_of_output_msg is the address of output_msg
addr_of_moving_msg : .word moving_msg	@; addr_of_moving_msg is the address of moving_msg
addr_of_final_msg  : .word final_msg	@; addr_of_final_msg is the address of final_msg

