@ CS 413L Lab 2
@ Phil Lane
@ 1/29/2020
@ This software gets dimensions and a shape, and calculates the area.

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
	.asciz "Area: %d\n"
invstr:
	.asciz "Invalid dimension. Please re-enter.\n"

.text
.global main
.global printf
.global scanf
.global strcmp
.global stdin

main:
intro:
	LDR R0, =welcstr
	BL printf
	LDR R0, =triangle
	BL printf
	LDR R0, =nl
	BL printf
	LDR R0, =rectangle
	BL printf
	LDR R0, =nl
	BL printf
	LDR R0, =trapezoid
	BL printf
	LDR R0, =nl
	BL printf
	LDR R0, =square
	BL printf
	LDR R0, =nl
	BL printf

readinp:
	SUB SP, #100
	MOV R1, SP
	LDR R0, =pers
	BL scanf

testinp:
	MOV R0, SP
	LDR R1, =triangle
	BL strcmp
	CMP R0, #0
	BEQ triinp
	MOV R0, SP
	LDR R1, =trapezoid
	BL strcmp
	CMP R0, #0
	BEQ trapinp
	MOV R0, SP
	LDR R1, =rectangle
	BL strcmp
	CMP R0, #0
	BEQ rectinp
	MOV R0, SP
	LDR R1, =square
	BL strcmp
	CMP R0, #0
	BEQ squinp
	ADD SP, #100
	B readinp

triinp:
	LDR R0, =stdin
	LDR R0, [R0]
	BL fflush
	LDR R0, =trimsg
	BL printf
	SUB SP, #8
	MOV R1, SP
	ADD R1, #4
	LDR R0, =perd
	BL scanf
	LDR R0, [SP, #4]
	CMP R0, #0
	BLLE invalid
	BLE triinp
	MOV R1, SP
	LDR R0, =perd
	BL scanf
	LDR R0, [SP]
	CMP R0, #0
	BLLE invalid
	BLE triinp
	BL calctri
	POP { R0 }
	ADD SP, #8
	MOV R1, R0
	LDR R0, =areamsg
	BL printf
	B return

trapinp:
	LDR R0, =stdin
	LDR R0, [R0]
	BL fflush
	LDR R0, =trapmsg
	BL printf
	SUB SP, #12
	MOV R1, SP
	ADD R1, #8
	LDR R0, =perd
	BL scanf
	LDR R0, [SP, #8]
	CMP R0, #0
	BLLE invalid
	BLE trapinp
	MOV R1, SP
	ADD R1, #4
	LDR R0, =perd
	BL scanf
	LDR R0, [SP, #4]
	CMP R0, #0
	BLLE invalid
	BLE trapinp
	MOV R1, SP
	LDR R0, =perd
	BL scanf
	LDR R0, [SP]
	CMP R0, #0
	BLLE invalid
	BLE trapinp
	BL calctrap
	POP { R0 }
	ADD SP, #12
	MOV R1, R0
	LDR R0, =areamsg
	BL printf
	B return

rectinp:
	LDR R0, =stdin
	LDR R0, [R0]
	BL fflush
	LDR R0, =rectmsg
	BL printf
	SUB SP, #8
	MOV R1, SP
	ADD R1, #4
	LDR R0, =perd
	BL scanf
	LDR R0, [SP, #4]
	CMP R0, #0
	BLLE invalid
	BLE rectinp
	MOV R1, SP
	LDR R0, =perd
	BL scanf
	LDR R0, [SP]
	CMP R0, #0
	BLLE invalid
	BLE rectinp
	BL calcrect
	POP { R0 }
	ADD SP, #8
	MOV R1, R0
	LDR R0, =areamsg
	BL printf
	B return

squinp:
	LDR R0, =stdin
	LDR R0, [R0]
	BL scanf
	LDR R0, =squmsg
	BL printf
	SUB SP, #4
	MOV R1, SP
	LDR R0, =perd
	BL scanf
	LDR R0, [SP]
	CMP R0, #0
	BLLE invalid
	BLE squinp
	BL calcsqu
	POP { R0 }
	ADD SP, #4
	MOV R1, R0
	LDR R0, =areamsg
	BL printf
	B return

return:
	MOV R7, #1
	SVC 0

calctri:
	PUSH { LR }
	PUSH { FP }
	MOV FP, SP
	PUSH { R4-R5 }
	LDR R4, [FP, #8]
	LDR R5, [FP, #12]
	MUL R4, R5
	ASR R4, #1
	MOV R0, R4
	POP { R4-R5 }
	POP { FP }
	POP { R1 }
	PUSH { R0 }
	MOV PC, R1

calcsqu:
	PUSH { LR }
	PUSH { FP }
	MOV FP, SP
	PUSH { R4-R5 }
	LDR R4, [FP, #8]
	MOV R5, R4
	MUL R4, R5
	MOV R0, R4
	POP { R4-R5 }
	POP { FP }
	POP { R1 }
	PUSH { R0 }
	MOV PC, R1

calcrect:
	PUSH { LR }
	PUSH { FP }
	MOV FP, SP
	PUSH { R4-R5 }
	LDR R4, [FP, #8]
	LDR R5, [FP, #12]
	MUL R4, R5
	MOV R0, R4
	POP { R4-R5 }
	POP { FP }
	POP { R1 }
	PUSH { R0 }
	MOV PC, R1

calctrap:
	PUSH { LR }
	PUSH { FP }
	MOV FP, SP
	PUSH { R4-R6 }
	LDR R4, [FP, #8]
	LDR R5, [FP, #12]
	LDR R6, [FP, #16]
	MUL R5, R4
	MUL R6, R4
	ADD R5, R6
	ASR R5, #1
	MOV R0, R5
	POP { R4-R6 }
	POP { FP }
	POP { R1 }
	PUSH { R0 }
	MOV PC, R1

invalid:
	PUSH { LR }
	PUSH { FP }
	MOV FP, SP
	LDR R0, =invstr
	BL printf
	POP { FP }
	POP { PC }
