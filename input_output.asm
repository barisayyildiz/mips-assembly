.data
prompt: .asciiz "\nPlease enter an input value : "
bye: .asciiz "\nBYE!\n"

.global main
.text

main:
li $v0, 4 #system call code for Print String
la $a0, prompt
syscall

li $v0, 5 # system call code for Read Integer
syscall

beq $v0, $zero, endProgram # branch to end if $v0 == 0
move $a0, $v0 # if you want to use this variable, move to another register
li $v0, 1 #system call for Print Integer
syscall
j main

endProgram:
li $v0, 4
syscall

