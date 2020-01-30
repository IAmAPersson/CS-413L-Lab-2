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
	LDR R0, =trimsg
	BL printf
	SUB SP, #8
	MOV R1, SP
	ADD R1, #4
	PUSH { R1 }
	BL inputd
	ADD SP, #4
	LDR R0, [SP, #4]
	CMP R0, #0
	BLLE invalid
	ADDLE SP, #8
	BLE triinp
	MOV R1, SP
	PUSH { R1 }
	BL inputd
	ADD SP, #4
	LDR R0, [SP]
	CMP R0, #0
	BLLE invalid
	ADDLE SP, #8
	BLE triinp
	BL calctri
	POP { R0 }
	ADD SP, #8
	CMP R0, #0
	BLT return
	MOV R1, R0
	LDR R0, =areamsg
	BL printf
	B return

trapinp:
	LDR R0, =trapmsg
	BL printf
	SUB SP, #12
	MOV R1, SP
	ADD R1, #8
	PUSH { R1 }
	BL inputd
	ADD SP, #4
	LDR R0, [SP, #8]
	CMP R0, #0
	BLLE invalid
	ADDLE SP, #12
	BLE trapinp
	MOV R1, SP
	ADD R1, #4
	PUSH { R1 }
	BL inputd
	ADD SP, #4
	LDR R0, [SP, #4]
	CMP R0, #0
	BLLE invalid
	ADDLE SP, #12
	BLE trapinp
	MOV R1, SP
	PUSH { R1 }
	BL inputd
	ADD SP, #4
	LDR R0, [SP]
	CMP R0, #0
	BLLE invalid
	ADDLE SP, #12
	BLE trapinp
	BL calctrap
	POP { R0 }
	ADD SP, #12
	CMP R0, #0
	BLT return
	MOV R1, R0
	LDR R0, =areamsg
	BL printf
	B return

rectinp:
	LDR R0, =rectmsg
	BL printf
	SUB SP, #8
	MOV R1, SP
	ADD R1, #4
	PUSH { R1 }
	BL inputd
	ADD SP, #4
	LDR R0, [SP, #4]
	CMP R0, #0
	BLLE invalid
	ADDLE SP, #8
	BLE rectinp
	MOV R1, SP
	PUSH { R1 }
	BL inputd
	ADD SP, #4
	LDR R0, [SP]
	CMP R0, #0
	BLLE invalid
	ADDLE SP, #8
	BLE rectinp
	BL calcrect
	POP { R0 }
	ADD SP, #8
	CMP R0, #0
	BLT return
	MOV R1, R0
	LDR R0, =areamsg
	BL printf
	B return

squinp:
	LDR R0, =squmsg
	BL printf
	SUB SP, #4
	MOV R1, SP
	PUSH { R1 }
	BL inputd
	ADD SP, #4
	LDR R0, [SP]
	CMP R0, #0
	BLLE invalid
	ADDLE SP, #4
	BLE squinp
	BL calcsqu
	POP { R0 }
	ADD SP, #4
	CMP R0, #0
	BLT return
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
	PUSH { R4-R7 }
	LDR R4, [FP, #8]
	LDR R5, [FP, #12]
	MOV R6, #0
	UMULL R7, R6, R4, R5
	CMP R6, #0
	MOVGT R7, #-1
	ASRLE R7, #1
	BLGT overflow
	MOV R0, R7
	POP { R4-R7 }
	POP { FP }
	POP { R1 }
	PUSH { R0 }
	MOV PC, R1

calcsqu:
	PUSH { LR }
	PUSH { FP }
	MOV FP, SP
	PUSH { R4-R7 }
	LDR R4, [FP, #8]
	MOV R5, R4
	MOV R6, #0
	UMULL R7, R6, R4, R5
	CMP R6, #0
	MOVGT R7, #-1
	BLGT overflow
	MOV R0, R7
	POP { R4-R7 }
	POP { FP }
	POP { R1 }
	PUSH { R0 }
	MOV PC, R1

calcrect:
	PUSH { LR }
	PUSH { FP }
	MOV FP, SP
	PUSH { R4-R7 }
	LDR R4, [FP, #8]
	LDR R5, [FP, #12]
	MOV R6, #0
	UMULL R7, R6, R4, R5
	CMP R6, #0
	MOVGT R7, #-1
	BLGT overflow
	MOV R0, R7
	POP { R4-R7 }
	POP { FP }
	POP { R1 }
	PUSH { R0 }
	MOV PC, R1

calctrap:
	PUSH { LR }
	PUSH { FP }
	MOV FP, SP
	PUSH { R4-R8 }
	LDR R4, [FP, #8]
	LDR R5, [FP, #12]
	LDR R6, [FP, #16]
	MOV R7, #0
	UMULL R8, R7, R5, R4
	MOV R5, R8
	CMP R7, #0
	BLGT overflow
	CMP R7, #0
	MOVGT R0, #-1
	BGT trapskip
	UMULL R8, R7, R6, R4
	MOV R6, R8
	CMP R7, #0
	BLGT overflow
	CMP R7, #0
	MOVGT R0, #-1
	BGT trapskip
	ADDS R5, R6
	MOVVS R0, #-1
	BLVS overflow
	BVS trapskip
	ASR R5, #1
	MOV R0, R5
trapskip:
	POP { R4-R8 }
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

overflow:
	PUSH { LR }
	PUSH { FP }
	MOV FP, SP
	LDR R0, =ofstr
	BL printf
	POP { FP }
	POP { PC }

inputd:
	PUSH { LR }
	PUSH { FP }
	MOV FP, SP
	SUB SP, #4
	MOV R2, #0
	STR R2, [SP]
	MOV R2, SP
	LDR R1, [FP, #8]
	LDR R0, =perdperc
	BL scanf
	CMP R0, #2
	BNE inputdinvalid
	LDR R0, [SP]
	CMP R0, #10
	BNE inputdinvalid
	B inputdret
inputdinvalid:
	LDR R1, [FP, #8]
	MOV R0, #-1
	STR R0, [R1]
	SUB SP, #100
	LDR R0, =pers
	MOV R1, SP
	BL scanf
	ADD SP, #100
inputdret:
	ADD SP, #4
	POP { FP }
	POP { PC }
