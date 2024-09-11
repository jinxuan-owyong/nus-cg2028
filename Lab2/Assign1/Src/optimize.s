/*
 * optimize.s
 *
 *  Created on: 20/8/2024
 *      Author: Ni Qingqing & Hou Linxin
 */
   .syntax unified
	.cpu cortex-m4
	.fpu softvfp
	.thumb

		.global optimize

@ Start of executable code
.section .text

@ EE2028 Assignment 1, Sem 1, AY 2024/25
@ (c) ECE NUS, 2024

@ Write Student 1’s Name here:
@ Write Student 2’s Name here:

@ Look-up table for registers:

@ R0 arr[0]
@ R1 x0_int / x - reuse register
@ R2 lambda_int - directly convert to 2's complement
@ R3 round - number of iterations
@ R4 fp
@ R5 xprev
@ R6 temp
@ write your program from here:

optimize:
	// Pre-calculate b*10 to reduce register usage
	MOV R3, #10
	LDR R4, [R0, #4]
	MUL R4, R3
	STR R4, [R0, #4]

	// calculate 2's complement of lambda since we only use its negative value
	MVN R2, R2  // 1's complement
	ADD R2, #1  // 2's complement

	// Initialise round to 0
	MOV R3, #0

dowhile:
	ADD R3, #1

	// update xprev
	MOV R5, R1

	// calculate fp
	LDR R6, [R0]            // R6 temp = arr[0] = a
	MUL R4, R6, R1          // a * x
	LSL R4, #1              // x2

	LDR R6, [R0, #4]       // R6 temp = arr[1] = b
	ADD R4, R6              // + b*10

	// calculate fp/100
	MOV  R6, #100
	SDIV R4, R6

	// instead of
	// change = -lambda*fp/100;
	// x = x + change;
	// we can simplify it to an MLA instruction
	// x = -lambda * (fp/100) + x
	MLA R1, R2, R4, R1

	TEQ R1, R5         // x and xprev
	BNE dowhile        // while (x != xprev)

store_result:
	LDR R2, =RESULT    // output return value
	STR R1, [R2], #4   // store x in RESULT[0]
	STR R3, [R2], #-4  // store round in RESULT[1]

cleanup:
	// revert b*10 calculation in arr[1]
	MOV  R3, #10
	LDR  R4, [R0, #4]
	SDIV R4, R3
	STR  R4, [R0, #4]

	// set R0 as output - see store_result
	MOV R0, R2

	BX LR

@ Allocate 8 bytes for output array
.lcomm RESULT 8
