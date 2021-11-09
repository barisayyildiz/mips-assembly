.data
	promptMessage: .asciiz "Enter a number to find factorial : "
	resultMessage: .asciiz "\nThe factorial of the number is : "
	theNumber: .word 0
	theAnswer: .word 0
.text
	.globl main
	main:
		# prompt the message
		li $v0, 4
		la $a0, promptMessage
		syscall

		# read the number from the user
		li $v0, 5
		syscall
		sw $v0, theNumber

		# call the factorial function
		lw $a0, theNumber
		jal factorial
		sw $v0, theAnswer

		jal printResult
		j endProgram

	endProgram:
		li $v0, 10
		syscall

	printResult:
		# display the result
		li $v0, 4
		la $a0, resultMessage
		syscall
		li $v0, 1
		lw $a0, theAnswer
		syscall
		jr $ra # go back where it is called from

	.globl factorial
	factorial:
		subu $sp, $sp, 8
		sw $ra, ($sp)
		sw $s0, 4($sp)

		# base case
		li $v0, 1
		beq $a0, 0, factorialDone

		# find factorial
		move $s0, $a0
		sub $a0, $a0, 1
		jal factorial

		mul $v0, $s0, $v0

	factorialDone:
		lw $ra, ($sp)
		lw $s0, 4($sp)
		addu $sp, $sp, 8
		jr $ra



		