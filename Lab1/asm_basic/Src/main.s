/*
 * asm_basic : main.s
 * Gu Jing, ECE, NUS
 * July 2020
 *
 * Simple ARM assembly file to demonstrate basic asm instructions.
 */

	.syntax unified
	.global main

@ Equates, equivalent to #define in C program
	.equ C,	20
	.equ D,	400

main:
@ Code starts here
@ Calculate ANSWER = A*B + C*D

	LDR R0, A
	LDR R1, B
	MUL R0, R0, R1 // R0 = R0 * R1
	LDR R1, =C
	LDR R2, =D
	MLA R0, R1, R2, R0 // R0 = R1*R2+R0
	MOV R4, R0
	LDR R3, =ANSWER // Load address of static variable into R3
	STR R4, [R3]

	// homework modification
	// modify the code to store all odd numbers between 50 and 100
	// in memory starting ANSWER + 4
	// Currently, R3 holds the address of ANSWER
	ADD R3, #4

	// Free up R0-R2
	// R0 - Current value
	// R1 - Maximum #100
	MOV R0, #51
	MOV R1, #100

loop:
	// write to output address pointer, then go to next
	STR R0, [R3], #4
	// increment by 2, since we only need odd numbers
	ADD R0, #2
	CMP R0, R1
	// go back to start of loop R0 < 100
	BLT loop

HALT:
	B HALT

@ Define constant values
A:	.word	100
B:	.word	50

@ Store result in SRAM (4 bytes)
.lcomm	ANSWER	4
.end
