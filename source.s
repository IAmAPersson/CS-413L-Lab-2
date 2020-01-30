@ CS 413L Lab 2
@ Phil Lane
@ 1/29/2020
@ This software gets dimensions and a shape, and calculates the area.

@ The ARM C calling convention is not followed due to program requirements.
@ Hence, a modified x86 C calling convention is used to accomodate LR

.data
.balign 4
welcstr:
	.asciz "Hello! Enter a shape from the following menu and I will calculate its area!\n"
rectangle:
	.asciz "rectangle"
square:
	.asciz "square"
trapezoid:
	.asciz "trapezoid"
triangle:
	.asciz "triangle"
nl:
	.asciz "\n"
pers:
	.asciz "%s"
perd:
	.asciz "%d"
perdperc:
	.asciz "%d%c"
perc:
	.asciz "%c"
perdnl:
	.asciz "%d\n"
trimsg:
	.asciz "Enter two values that represent 1) width and 2) height:\n"
squmsg:
	.asciz "Enter a value that represents 1) side length:\n"
rectmsg:
	.asciz "Enter two values that represent 1) width and 2) height:\n"
trapmsg:
	.asciz "Enter three values that represent 1) base one, 2) base two, and 3) height:\n"
areamsg:
	.asciz "Area: %u\n"
invstr:
	.asciz "Invalid dimension. Please re-enter.\n"
ofstr:
	.asciz "Overflow\n"
retrystr:
	.asciz "Would you like to perform another calculation? (y/n)\n"
quitstr:
	.asciz "quit"

.text
.global main
.global printf
.global scanf
.global strcmp

main:
intro:
	LDR R0, =welcstr
	BL printf @print the welcome string
	LDR R0, =triangle
	BL printf
	LDR R0, =nl
	BL printf @print the triangle option
	LDR R0, =rectangle
	BL printf
	LDR R0, =nl
	BL printf @print the rectangle option
	LDR R0, =trapezoid
	BL printf
	LDR R0, =nl
	BL printf @print the trapezoid option
	LDR R0, =square
	BL printf
	LDR R0, =nl
	BL printf @print the square option
	LDR R0, =quitstr
	BL printf
	LDR R0, =nl
	BL printf @print the quit option

readinp:
	SUB SP, #100 @allocate space for a string on the stack of length 100
	MOV R1, SP
	LDR R0, =pers
	BL scanf @read in a string

testinp: @loop: loops until a valid input is given
	MOV R0, SP
	LDR R1, =triangle
	BL strcmp @compare to triangle
	CMP R0, #0
	BEQ triinp @go to the triangle input if same
	MOV R0, SP
	LDR R1, =trapezoid
	BL strcmp @compare to trapezoid
	CMP R0, #0
	BEQ trapinp @go to the trapezoid input if same
	MOV R0, SP
	LDR R1, =rectangle
	BL strcmp @compare to rectangle
	CMP R0, #0
	BEQ rectinp @go to the rectangle input if same
	MOV R0, SP
	LDR R1, =square
	BL strcmp @compare to square
	CMP R0, #0
	BEQ squinp @go to the square input if same
	MOV R0, SP
	LDR R1, =quitstr
	BL strcmp @compare to quit
	CMP R0, #0
	BEQ return @quit if same
	ADD SP, #100 @did not equal anything, restore stack space
	B readinp @try again

triinp: @loop: loop until two valid inputs are given
	LDR R0, =trimsg
	BL printf @print the triangle input message
	SUB SP, #8 @allocate space for two integers
	MOV R1, SP
	ADD R1, #4
	PUSH { R1 }
	BL inputd @input the first integer
	ADD SP, #4
	LDR R0, [SP, #4]
	CMP R0, #0 @see if it's <=0
	BLLE invalid
	ADDLE SP, #8
	BLE triinp @if it is, print that it's invalid, restore stack space, and try again
	MOV R1, SP
	PUSH { R1 }
	BL inputd @input the second integer
	ADD SP, #4
	LDR R0, [SP]
	CMP R0, #0 @see if it's <= 0
	BLLE invalid
	ADDLE SP, #8
	BLE triinp @if it is, print that it's invalid, restore stack space, and try again
	BL calctri @calculate triangle area
	POP { R0 } @get the return value
	ADD SP, #8 @restore stack space
	CMP R0, #0
	BLT tryagain @if invalid return value, ask for them to try again
	MOV R1, R0
	LDR R0, =areamsg
	BL printf @print the area
	B tryagain @ask for them to try again

trapinp: @loop: loops until valid inputs are given
	LDR R0, =trapmsg
	BL printf @print the trapezoid input message
	SUB SP, #12 @allocate space on the stack for three integers
	MOV R1, SP
	ADD R1, #8
	PUSH { R1 }
	BL inputd @input the first integer
	ADD SP, #4
	LDR R0, [SP, #8]
	CMP R0, #0 @see if it's a valid input
	BLLE invalid
	ADDLE SP, #12
	BLE trapinp @if invalid, tell them it's invalid, restore stack space, and try again
	MOV R1, SP
	ADD R1, #4
	PUSH { R1 }
	BL inputd @input the second integer
	ADD SP, #4
	LDR R0, [SP, #4]
	CMP R0, #0 @see if it's a valid input
	BLLE invalid
	ADDLE SP, #12
	BLE trapinp @if invalid, tell them it's invalid, restore stack space, and try again
	MOV R1, SP
	PUSH { R1 }
	BL inputd @input the third integer
	ADD SP, #4
	LDR R0, [SP]
	CMP R0, #0 @see if it's a valid input
	BLLE invalid
	ADDLE SP, #12
	BLE trapinp @if invalid, tell them it's invalid, restore stack space, and try again
	BL calctrap @calculate the area
	POP { R0 } @get the area
	ADD SP, #12 @restore stack space
	CMP R0, #0
	BLT tryagain @if invalid result, ask them if they want to try again
	MOV R1, R0
	LDR R0, =areamsg
	BL printf @print the area
	B tryagain @ask them if they want to try again

rectinp: @loop: loops until valid inputs are given
	LDR R0, =rectmsg
	BL printf @print the rectangle input message
	SUB SP, #8 @allocate stack space for two integers
	MOV R1, SP
	ADD R1, #4
	PUSH { R1 }
	BL inputd @get the first number
	ADD SP, #4
	LDR R0, [SP, #4]
	CMP R0, #0 @see if it's valid
	BLLE invalid
	ADDLE SP, #8
	BLE rectinp @if invalid, tell them it's invalid, restore stack space, and try again
	MOV R1, SP
	PUSH { R1 }
	BL inputd @get the second number
	ADD SP, #4
	LDR R0, [SP]
	CMP R0, #0 @see if it's valid
	BLLE invalid
	ADDLE SP, #8
	BLE rectinp @if invalid, tell them it's invalid, restore stack space, and try again
	BL calcrect @calculate area
	POP { R0 } @get the result
	ADD SP, #8 @ restore stack space
	CMP R0, #0 @see if it's a valid result
	BLT tryagain @if invalid result, ask them if they want to try again
	MOV R1, R0
	LDR R0, =areamsg
	BL printf @output the area
	B tryagain @ask them if they want to try again

squinp: @loop: loops until a valid input is given
	LDR R0, =squmsg
	BL printf @output the square input message
	SUB SP, #4 @allocate stack space for one integer
	MOV R1, SP
	PUSH { R1 }
	BL inputd @input the dimensions
	ADD SP, #4
	LDR R0, [SP]
	CMP R0, #0 @see if it's valid
	BLLE invalid
	ADDLE SP, #4
	BLE squinp @if invalid, tell them it's invalid, restore stack space, and try again
	BL calcsqu @calculate area
	POP { R0 } @get the area
	ADD SP, #4 @restore stack space
	CMP R0, #0 @see if it's a valid result
	BLT tryagain @if not, ask them if they want to try again
	MOV R1, R0
	LDR R0, =areamsg
	BL printf @print the area
	B tryagain @ask them if they want to try again

tryagain: @loop: loops until a valid input is given
	LDR R0, =retrystr
	BL printf @print the retry string
	SUB SP, #1 @allocate stack space for one char
	MOV R1, SP
	LDR R0, =perc
	BL scanf @input a char
	MOV R0, #0
	LDRSB R0, [SP], #4 @load the input and restore stack space
	CMP R0, #'y' @compare to 'y'
	BEQ intro @if they want to retry, go back to the intro
	CMP R0, #'n' @compare to 'n'
	BEQ return @if they don't want to retry, exit the program
	B tryagain @try again

return:
	MOV R7, #1
	SVC 0 @exit the program

calctri:
	PUSH { LR }
	PUSH { FP }
	MOV FP, SP @create stack frame
	PUSH { R4-R7 } @save registers
	LDR R4, [FP, #8] @load argument 1
	LDR R5, [FP, #12] @load argument 2
	MOV R6, #0
	UMULL R7, R6, R4, R5 @64-bit multiplication
	CMP R6, #0 @test if upper word is non-zero (for overflow)
	MOVGT R7, #-1 @if overflow, load -1 as a result
	ASRLE R7, #1 @if not overflow, divide by 2
	BLGT overflow @if overflow, tell user about the overflow
	MOV R0, R7
	POP { R4-R7 } @restore registers
	POP { FP } @restore stack frame
	POP { R1 } @restore LR
	PUSH { R0 } @push result
	MOV PC, R1 @return

calcsqu:
	PUSH { LR }
	PUSH { FP }
	MOV FP, SP @create stack frame
	PUSH { R4-R7 } @save registers
	LDR R4, [FP, #8] @load argument
	MOV R5, R4
	MOV R6, #0
	UMULL R7, R6, R4, R5 @64-bit multiplication
	CMP R6, #0 @check if overflow
	MOVGT R7, #-1 @if overflow, load -1 as result
	BLGT overflow @if overflow, tell user about overflow
	MOV R0, R7
	POP { R4-R7 } @restore registers
	POP { FP } @restore stack frame
	POP { R1 } @restore LR
	PUSH { R0 } @push return value
	MOV PC, R1 @return

calcrect:
	PUSH { LR }
	PUSH { FP }
	MOV FP, SP @create stack frame
	PUSH { R4-R7 } @save registers
	LDR R4, [FP, #8] @load argument 1
	LDR R5, [FP, #12] @load argument 2
	MOV R6, #0
	UMULL R7, R6, R4, R5 @64-bit multiplication
	CMP R6, #0 @check if overflow
	MOVGT R7, #-1 @if overflow, load -1 as result
	BLGT overflow @if overflow, tell user about overflow
	MOV R0, R7
	POP { R4-R7 } @restore registers
	POP { FP } @restore stack frame
	POP { R1 } @restore LR
	PUSH { R0 } @push return value
	MOV PC, R1 @return

calctrap:
	PUSH { LR }
	PUSH { FP }
	MOV FP, SP @create stack frame
	PUSH { R4-R8 } @save registers
	LDR R4, [FP, #8] @load argument 1
	LDR R5, [FP, #12] @load argument 2
	LDR R6, [FP, #16] @load argument 3
	MOV R7, #0
	UMULL R8, R7, R5, R4 @64-bit multiplication
	MOV R5, R8
	CMP R7, #0 @check if overflow
	BLGT overflow @if overflow, tell user about overflow
	CMP R7, #0 @check if overflow
	MOVGT R0, #-1 @if overflow, set result as -1
	BGT trapskip @if overflow, skip the rest of the calculation
	UMULL R8, R7, R6, R4 @64-bit multiplication
	MOV R6, R8
	CMP R7, #0 @check if overflow
	BLGT overflow @if overflow, tell user about overflow
	CMP R7, #0 @check if overflow
	MOVGT R0, #-1 @if overflow, set the result as -1
	BGT trapskip @if overflow, skip the rest of the calculation
	ADDS R5, R6 @add the results of the multiplications
	MOVVS R0, #-1 @if overflow, set result as -1
	BLVS overflow @if overflow, tell the user about overflow
	BVS trapskip @if overflow, skip the rest of the calculation
	ASR R5, #1 @divide by 2
	MOV R0, R5
trapskip:
	POP { R4-R8 } @restore registers
	POP { FP } @restore stack frame
	POP { R1 } @restore LR
	PUSH { R0 } @push return value
	MOV PC, R1 @return

invalid:
	PUSH { LR }
	PUSH { FP }
	MOV FP, SP @create stack frame
	LDR R0, =invstr
	BL printf @print invalid string
	POP { FP } @restore stack frame
	POP { PC } @return

overflow:
	PUSH { LR }
	PUSH { FP }
	MOV FP, SP @create stack frame
	LDR R0, =ofstr
	BL printf @print overflow string
	POP { FP } @restore stack frame
	POP { PC } @return

inputd:
	PUSH { LR }
	PUSH { FP }
	MOV FP, SP @create stack frame
	SUB SP, #4 @allocate space on stack for one character
	MOV R2, #0
	STR R2, [SP] @set the word to 0
	MOV R2, SP
	LDR R1, [FP, #8]
	LDR R0, =perdperc
	BL scanf @scanf("%d%c", &data, &nl)
	CMP R0, #2 @see if scanf read in exactly two values
	BNE inputdinvalid @if not, invalid input
	LDR R0, [SP]
	CMP R0, #10 @see if the character was a newline
	BNE inputdinvalid @if not, invalid input
	B inputdret @valud input, return
inputdinvalid:
	LDR R1, [FP, #8]
	MOV R0, #-1
	STR R0, [R1] @set the inputted value to -1
	SUB SP, #100 @allocate space on stack for a 100-character string
	LDR R0, =pers
	MOV R1, SP
	BL scanf @read in a string to flush stdin
	ADD SP, #100 @restore stack space
inputdret:
	ADD SP, #4 @restore stack space
	POP { FP } @restore stack frame
	POP { PC } @return
