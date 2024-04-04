# This is a test file. Use this file to run the functions in hw3.asm
#
# Change data section as you deem fit.
# Change filepath if necessary.
.data
Filename: .asciiz "inputs/dup3p.txt"
OutFile: .asciiz "out.txt"
Buffer:
    .word 0	# num rows
    .word 0	# num columns
    # matrix
    .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0

error_msg: .asciiz "ERROR!"
.text
main:
	#initialize the program
 	la $a0, Filename
 	la $a1, Buffer
 	jal initialize
 	
 	li $t0, -1
 	beq $v0, $t0, error
 
 	#rotate_clkws_90 test (uncomment the 3 lines below this)
 	#la $a0, Buffer
 	#la $a1, OutFile
 	#jal rotate_clkws_90
 	
 	#rotate_clkws_180 test (uncomment the 3 lines below this)
 	#la $a0, Buffer
 	#la $a1, OutFile
 	#jal rotate_clkws_180
 	
 	#rotate_clkws_270 test (uncomment the 3 lines below this)
 	#la $a0, Buffer
 	#la $a1, OutFile
 	#jal rotate_clkws_270
 	
 	#mirror test (uncomment the 3 lines below this)
 	#la $a0, Buffer
 	#la $a1, OutFile
 	#jal mirror
 	
 	#duplicate test (uncomment the 2 lines below this)
 	la $a0, Buffer
 	jal duplicate
 	
 	#print $v0 result for duplicate (uncomment the 3 lines below this)
 	move $a0, $v0
 	li $v0, 1
	syscall
 	
 	#print $v1 result for duplicate (uncomment the 3 lines below this)
 	move $a0, $v1
	li $v0, 1
 	syscall
 
 	
 	endProgram:

 	li $v0, 10
 	syscall

 	error:
 	la $a0, error_msg
 	li $v0, 4
 	syscall
 	j endProgram


.include "hw3.asm"
