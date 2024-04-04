################# Steven Tung #################
################# stetung #################
################# 114437192 #################
################# DON'T FORGET TO ADD GITHUB USERNAME IN BRIGHTSPACE #################

################# DO NOT CHANGE THE DATA SECTION #################

.data
arg1_addr: .word 0
arg2_addr: .word 0
num_args: .word 0
invalid_arg_msg: .asciiz "Invalid Arguments\n"
args_err_msg: .asciiz "Program requires exactly two arguments\n"
invalid_hand_msg: .asciiz "Loot Hand Invalid\n"
newline: .asciiz "\n"
zero: .asciiz "Zero\n"
nan: .asciiz "NaN\n"
inf_pos: .asciiz "+Inf\n"
inf_neg: .asciiz "-Inf\n"
mantissa: .asciiz ""


.text
.globl hw_main
hw_main:
    sw $a0, num_args
    sw $a1, arg1_addr
    addi $t0, $a1, 2
    sw $t0, arg2_addr
    j start_coding_here

start_coding_here:
	#Part 1A
	lw $t1, num_args 			#load num_args in $t1
	li $t2, 2				#load 2 in to $t2
	bne $t1, $t2 printArgError		#if $t1!=$t2 then printArgError
	
	#Part 1B
	lw $t1, arg1_addr			#load arg1_addr into $t3
	lb $t0, 1($t1)				#load 1($t3) into $t4
	bne $zero, $t0, printInvalidArgMsg	#if $t4!=0 then printInvalidArgMsg

	#Part 1C
	lb $t0, 0($t1)				#set $t4 to letter of string
	li $t2, 'D'				#set $t5 to letter D
	beq $t2, $t0, isLetterD			#if $t4==$t5 then go to label isLetterD
	li $t2, 'O'				#set $t5 to letter O
	beq $t2, $t0, rTypeDecode		#if $t4==$t5 then go to label isLetterO
	li $t2, 'S'				#set $t5 to letter S
	beq $t2, $t0, rTypeDecode		#if $t4==$t5 then go to label isLetterS
	li $t2, 'T'				#set $t5 to letter T
	beq $t2, $t0, rTypeDecode		#if $t4==$t5 then go to label isLetterT
	li $t2, 'E'				#set $t5 to letter E
	beq $t2, $t0, rTypeDecode		#if $t4==$t5 then go to label isLetterE
	li $t2, 'H'				#set $t5 to letter H
	beq $t2, $t0, rTypeDecode		#if $t4==$t5 then go to label isLetterH
	li $t2, 'U'				#set $t5 to letter U
	beq $t2, $t0, rTypeDecode		#if $t4==$t5 then go to label isLetterU
	li $t2, 'F'				#set $t5 to letter F
	beq $t2, $t0, isLetterF			#if $t4==$t5 then go to label isLetterF
	li $t2, 'L'				#set $t5 to letter L
	beq $t2, $t0, isLetterL			#if $t4==$t5 then go to label isLetterL
	j printInvalidArgMsg			#if none are the corrects, printInvalidArgMsg
	
	#Part 2
isLetterD:    		
	lw $t0, arg2_addr			#reload the two's complement string into register $t0
	lb $t1 0($t0)				#get the first bit of the binary string
	beq $t1, $zero, printInvalidArgMsg	#checks if the first bit is null (if string is <1 in size)
	li $t2, '0'				#hold binary value of 0
	li $t3, '1'				#hold binary value of 1
	li $t1, 33				#store highest length of string allowed
	move $t4, $t0				#move the address of arg2_addr to a new register
	addi $t4, $t4, -1			#offest $t4 by -1
	li $t5, 0				#stores the value of the result
	beginLoopingSequence:
		addi $t1, $t1, -1
		bltz $t1, printInvalidArgMsg	
		addi $t4, $t4, 1
		lb $t6, 0($t4)
		beq $t6, $t2, doZeroAction
		beq $t6, $t3, doOneAction
		beq $t6, $zero, endLoopingSequence
		j printInvalidArgMsg
		doZeroAction:
			sll $t5, $t5,1		#shift all to left by 1 for 0
			j beginLoopingSequence
		doOneAction:
			li $t8, 1
			sll $t5, $t5, 1		#shift all to left by 1 for 1 and add 1 to right most bit
			or $t5, $t5, $t8
			j beginLoopingSequence
	endLoopingSequence:
		move $a0, $t5  			#printing result
		li $v0, 1
		syscall
	j terminate
	
rTypeDecode:
	lw $t0, arg2_addr 			#store the hex decimal encoding into $t0
	lb $t1, 0($t0)
	li $t2, '0'
	bne $t1, $t2, printInvalidArgMsg 	#checks first bit to be 0
	lb $t1, 1($t0)
	li $t2, 'x'
	bne $t1, $t2, printInvalidArgMsg	#checks first bit to be x
	
	addi $t0, $t0, 2
	lb $t1, 0($t0)
	beq $t1, $zero, printInvalidArgMsg	#checks if input is valid
	
	move $t1, $t0
	addi $t1, $t1, -1
	li $t2, 0
	li $t3, 9
	li $t4, 1
	
	rTypeLoopingStart:
		addi $t1, $t1, 1
		addi $t3, $t3, 01
		bltz $t3, printInvalidArgMsg
		lb $t5, 0($t1)
		beq $t5, $zero, rTypeLoopingEnd #check if empty string
		li $t6, '0'	
		beq $t5, $t6, rTypeZero		#check for the value of the bit and goes to corresponding code
		li $t6, '1'
		beq $t5, $t6, rTypeOne
		li $t6, '2'
		beq $t5, $t6, rTypeTwo
		li $t6, '3'
		beq $t5, $t6, rTypeThree
		li $t6, '4'
		beq $t5, $t6, rTypeFour
		li $t6, '5'
		beq $t5, $t6, rTypeFive
		li $t6, '6'
		beq $t5, $t6, rTypeSix
		li $t6, '7'
		beq $t5, $t6, rTypeSeven
		li $t6, '8'
		beq $t5, $t6, rTypeEight
		li $t6, '9'
		beq $t5, $t6, rTypeNine
		li $t6, 'A'
		beq $t5, $t6, rTypeAlpha
		li $t6, 'a'
		beq $t5, $t6, rTypeAlpha
		li $t6, 'B'
		beq $t5, $t6, rTypeBravo
		li $t6, 'b'
		beq $t5, $t6, rTypeBravo
		li $t6, 'C'
		beq $t5, $t6, rTypeCharlie
		li $t6, 'c'
		beq $t5, $t6, rTypeCharlie
		li $t6, 'D'
		beq $t5, $t6, rTypeDelta
		li $t6, 'd'
		beq $t5, $t6, rTypeDelta
		li $t6, 'E'
		beq $t5, $t6, rTypeEcho
		li $t6, 'e'
		beq $t5, $t6, rTypeEcho
		li $t6, 'F'
		beq $t5, $t6, rTypeFoxtrot
		li $t6, 'f'
		beq $t5, $t6, rTypeFoxtrot
		j printInvalidArgMsg
		
		rTypeZero:				#conversion stage: takes in hex value and converts to binary
			sll $t2, $t2, 4		
			j rTypeLoopingStart
		rTypeOne:
			sll $t2, $t2, 4
			or $t2, $t2, $t4
			j rTypeLoopingStart
		rTypeTwo:
			sll $t2, $t2, 3
			or $t2, $t2, $t4
			sll $t2, $t2, 1
			j rTypeLoopingStart
		rTypeThree:
			sll $t2, $t2, 3
			or $t2, $t2, $t4
			sll $t2, $t2, 1
			or $t2, $t2, $t4
			j rTypeLoopingStart
		rTypeFour:
                	sll $t2, $t2, 2
               		or $t2, $t2, $t4
                	sll $t2, $t2, 2
                	j rTypeLoopingStart
            	rTypeFive:
               		sll $t2, $t2, 2
                	or $t2, $t2, $t4
                	sll $t2, $t2, 2
                	or $t2, $t2, $t4
                	j rTypeLoopingStart
            	rTypeSix:
                	sll $t2, $t2, 2
                	or $t2, $t2, $t4
                	sll $t2, $t2, 1
                	or $t2, $t2, $t4
               		sll $t2, $t2, 1
                	j rTypeLoopingStart
            	rTypeSeven:
                	sll $t2, $t2, 2
                	or $t2, $t2, $t4
                	sll $t2, $t2, 1
                	or $t2, $t2, $t4
                	sll $t2, $t2, 1
                	or $t2, $t2, $t4
                	j rTypeLoopingStart
		rTypeEight:
                	sll $t2, $t2, 1
                	or $t2, $t2, $t4
                	sll $t2, $t2, 3
                	j rTypeLoopingStart
            	rTypeNine:
                	sll $t2, $t2, 1
                	or $t2, $t2, $t4
                	sll, $t2, $t2, 3
                	or $t2, $t2, $t4
                	j rTypeLoopingStart
            	rTypeAlpha:
                	sll $t2, $t2, 1
                	or $t2, $t2, $t4
                	sll $t2, $t2, 2
                	or $t2, $t2, $t4
                	sll $t2, $t2, 1
                	j rTypeLoopingStart
            	rTypeBravo:
                	sll $t2, $t2, 1
                	or $t2, $t2, $t4
                	sll $t2, $t2, 2
                	or $t2, $t2, $t4
                	sll $t2, $t2, 1
                	or $t2, $t2, $t4
                	j rTypeLoopingStart
            	rTypeCharlie:
                	sll $t2, $t2, 1
                	or $t2, $t2, $t4
                	sll $t2, $t2, 1
                	or $t2, $t2, $t4
                	sll $t2, $t2, 2
                	j rTypeLoopingStart
            	rTypeDelta:
                	sll $t2, $t2, 1
                	or $t2, $t2, $t4
                	sll $t2, $t2, 1
                	or $t2, $t2, $t4
                	sll $t2, $t2, 2
                	or $t2, $t2, $t4
                	j rTypeLoopingStart
            	rTypeEcho:
                	sll $t2, $t2, 1
                	or $t2, $t2, $t4
                	sll $t2, $t2, 1
                	or $t2, $t2, $t4
               		sll $t2, $t2, 1
                	or $t2, $t2, $t4
                	sll $t2, $t2, 1
                	j rTypeLoopingStart
            	rTypeFoxtrot:  
                	sll $t2, $t2, 1
                	or $t2, $t2, $t4
                	sll $t2, $t2, 1
                	or $t2, $t2, $t4
               		sll $t2, $t2, 1
                	or $t2, $t2, $t4
                	sll $t2, $t2, 1
                	or $t2, $t2, $t4
                	j rTypeLoopingStart
                	
                rTypeLoopingEnd:
                	lw $t5, arg1_addr
                	lb $t0, 0($t5)
                	
                	li $t1, 'O'			#checks arg1_addr input and matches to wanted result
                	beq $t1, $t0, isLetterO
                	li $t1, 'S'
                	beq $t1, $t0, isLetterS
                	li $t1, 'T'
                	beq $t1, $t0, isLetterT
                	li $t1, 'E'
                	beq $t1, $t0, isLetterE
                	li $t1, 'H'
                	beq $t1, $t0, isLetterH
                	li $t1, 'U'
                	beq $t1, $t0, isLetterU
	isLetterO:
		srl $t2, $t2, 26
    		move $a0, $t2
        	li $v0, 1
        	syscall
        	j terminate	
	isLetterS:
		sll $t2, $t2, 6
    		srl $t2, $t2, 27
    		move $a0, $t2
        	li $v0, 1
        	syscall
        	j terminate	
	isLetterT:
		sll $t2, $t2, 11
        	srl $t2, $t2, 27
        	move $a0, $t2
        	li $v0, 1
        	syscall
        	j terminate	
	isLetterE:
		sll $t2, $t2, 16
    		srl $t2, $t2, 27
        	move $a0, $t2
        	li $v0, 1
        	syscall
        	j terminate	
	isLetterH:
		sll $t2, $t2, 21
    		sra $t2, $t2, 27
        	move $a0, $t2
        	li $v0, 1
        	syscall
        	j terminate	
	isLetterU:
		sll $t2, $t2, 26
    		srl $t2, $t2, 26
        	move $a0, $t2
        	li $v0, 1
        	syscall
        	j terminate		
      
isLetterL:
	lw $t0, arg2_addr
    	li $t3, 0            #merchant counter
    	li $t4, 0            #pirate counter
    	li $t6, 6
    	lb $t1, 0($t0)
    	li $t2, 'M'
   	beq $t1, $t2, merchantShip
    	li $t2, 'P'
    	beq $t1, $t2, pirateShip
    	j printInvalidHandMsg
    	lootingLoopingStart:
        	addi $t0, $t0, 1
        	lb $t1, 0($t0)
        	add $t5, $t3, $t4
        	li $t2, 'M'
        	beq $t1, $t2, merchantShip
        	li $t2, 'P'
        	beq $t1, $t2, pirateShip
        	beq $t5, $t6, lootingLoopingEnd 
        	j printInvalidHandMsg

    	merchantShip:
        	addi $t0, $t0, 1
        	lb $t1, 0($t0)
        	li $t2, '3'
        	beq $t1, $t2, addMerchantCount
        	li $t2, '4'
        	beq $t1, $t2, addMerchantCount
        	li $t2, '5'
        	beq $t1, $t2, addMerchantCount
        	li $t2, '6'
        	beq $t1, $t2, addMerchantCount
        	li $t2, '7'
       		beq $t1, $t2, addMerchantCount
        	li $t2, '8'
        	beq $t1, $t2, addMerchantCount
        	j printInvalidHandMsg
        
        addMerchantCount:
            addi $t3, $t3, 1
            j lootingLoopingStart
    
    	pirateShip:
        	addi $t0, $t0, 1
        	lb $t1, 0($t0)
        	li $t2, '1'
        	beq $t1, $t2, addPirateCount
       		li $t2, '2'
        	beq $t1, $t2, addPirateCount
        	li $t2, '3'
        	beq $t1, $t2, addPirateCount
        	li $t2, '4'
        	beq $t1, $t2, addPirateCount
        	j printInvalidHandMsg
        
        addPirateCount:
            	addi $t4, $t4, 1
            	j lootingLoopingStart

    	lootingLoopingEnd:
       		move $t2, $t3
       		move $t3, $t4
        	li $t1, 0
        	li $t4, 0
        	li $t5, 29
        	li $t6, 3
        	move $t7, $t2
        	
        merchantDecimalToBinaryStart:
            	beqz $t6, merchantDecimalToBinaryEnd
            	move $t2, $t7
            	sllv $t2, $t2, $t5
            	srl $t2, $t2, 31
            	bnez $t2, merchantCheck
            	sll $t1, $t1, 1
        merchantCalculationLoop:
            	addi $t4, $t4, 1
            	addi $t5, $t5, 1
            	addi $t6, $t6, -1
            	j merchantDecimalToBinaryStart   
        merchantDecimalToBinaryEnd:
        	li $t5, 29
        	li $t6, 3
        	move $t7, $t3
        	pirateDecimalToBinaryStart:
            		beqz $t6, pirateDecimalToBinaryEnd
            		move $t3, $t7
            		sllv $t3, $t3, $t5
            		srl $t3, $t3, 31
            		bnez $t3, pirateCheck
			sll $t1, $t1, 1
            		pirateCalculationLoop:
            		addi $t5, $t5, 1
            		addi $t6, $t6, -1
            		j pirateDecimalToBinaryStart
        	pirateDecimalToBinaryEnd: 
        		la $a0, newline
        		li $v0, 4
        		syscall
        		move $a0, $t1
        		li $v0, 1
        		syscall
        		j terminate
    	merchantCheck:
        	beqz $t4, merchantFixer
       	 	li $t4, 1
        	sll $t1, $t1, 1
        	or $t1, $t1, $t4
        	j merchantCalculationLoop
        
    	merchantFixer:
        	li $t4, -1
        	or $t1, $t1, $t4
        	j merchantCalculationLoop
        	
    	pirateCheck:
        	li $t4, 1
        	sll $t1, $t1, 1
        	or $t1, $t1, $t4
        	j pirateCalculationLoop
        	          	
isLetterF:
	lw $t0, arg2_addr
	move $t1, $t0
	addi $t1, $t1, -1
	li $t2, 9
	li $t6, 0
	li $t7, 1
	li $t9, -1
	hexLoopingStart:
		addi $t1, $t1, 1
		addi $t2, $t2, -1
		addi $t9, $t9, 1
		blt $t2, $zero, printInvalidArgMsg
		lb $t3, 0($t1)
		beq $t3, $zero, hexLoopingEnd
		li $t4, '0'
		beq $t3, $t4, zeroHex
		li $t4, '1'
		beq $t3, $t4, oneHex
		li $t4, '2'
		beq $t3, $t4, twoHex
		li $t4, '3'
		beq $t3, $t4, threeHex
		li $t4, '4'
		beq $t3, $t4, fourHex
		li $t4, '5'
		beq $t3, $t4, fiveHex
		li $t4, '6'
		beq $t3, $t4, sixHex
		li $t4, '7'
		beq $t3, $t4, sevenHex
		li $t4, '8'
		beq $t3, $t4, eightHex
		li $t4, '9'
		beq $t3, $t4, nineHex
		li $t4, 'A'
		beq $t3, $t4, alphaHex
		li $t4, 'B'
		beq $t3, $t4, bravoHex
		li $t4, 'C'
		beq $t3, $t4, charlieHex
		li $t4, 'D'
		beq $t3, $t4, deltaHex
		li $t4, 'E'
		beq $t3, $t4, echoHex
		li $t4, 'F'
		beq $t3, $t4, foxtrotHex
		li $t4, 'a'
		beq $t3, $t4, alphaHex
		li $t4, 'b'
		beq $t3, $t4, bravoHex
		li $t4, 'c'
		beq $t3, $t4, charlieHex
		li $t4, 'd'
		beq $t3, $t4, deltaHex
		li $t4, 'e'
		beq $t3, $t4, echoHex
		li $t4, 'f'
		beq $t3, $t4, foxtrotHex
		j printInvalidArgMsg
		
		zeroHex:
			sll $t6, $t6, 4
                	j hexLoopingStart
                oneHex:
			sll $t6, $t6, 4
                	or $t6, $t6, $t7
                	j hexLoopingStart
		twoHex:
                	sll $t6, $t6, 3
                	or $t6, $t6, $t7
                	sll $t6, $t6, 1
                	j hexLoopingStart
            	threeHex:
                	sll $t6, $t6, 3
                	or $t6, $t6, $t7
                	sll $t6, $t6, 1
                	or $t6, $t6, $t7
                	j hexLoopingStart
            	fourHex:
                	sll $t6, $t6, 2
                	or $t6, $t6, $t7
                	sll $t6, $t6, 2
                	j hexLoopingStart
            	fiveHex:
                	sll $t6, $t6, 2
                	or $t6, $t6, $t7
                	sll $t6, $t6, 2
                	or $t6, $t6, $t7
                	j hexLoopingStart
            	sixHex:
                	sll $t6, $t6, 2
                	or $t6, $t6, $t7
               		sll $t6, $t6, 1
                	or $t6, $t6, $t7
                	sll $t6, $t6, 1
                	j hexLoopingStart
            	sevenHex:
                	sll $t6, $t6, 2
                	or $t6, $t6, $t7
                	sll $t6, $t6, 1
                	or $t6, $t6, $t7
                	sll $t6, $t6, 1
                	or $t6, $t6, $t7
                	j hexLoopingStart
            	eightHex:
                	sll $t6, $t6, 1
                	or $t6, $t6, $t7
                	sll $t6, $t6, 3
                	j hexLoopingStart
            	nineHex:
                	sll $t6, $t6, 1
                	or $t6, $t6, $t7
                	sll, $t6, $t6, 3
                	or $t6, $t6, $t7
                	j hexLoopingStart
            	alphaHex:
                	sll $t6, $t6, 1
                	or $t6, $t6, $t7
                	sll $t6, $t6, 2
                	or $t6, $t6, $t7
                	sll $t6, $t6, 1
                	j hexLoopingStart
            	bravoHex:
                	sll $t6, $t6, 1
                	or $t6, $t6, $t7
                	sll $t6, $t6, 2
                	or $t6, $t6, $t7
                	sll $t6, $t6, 1
                	or $t6, $t6, $t7
                	j hexLoopingStart
            	charlieHex:
                	sll $t6, $t6, 1
                	or $t6, $t6, $t7
                	sll $t6, $t6, 1
                	or $t6, $t6, $t7
                	sll $t6, $t6, 2
                	j hexLoopingStart
            	deltaHex:
                	sll $t6, $t6, 1
                	or $t6, $t6, $t7
                	sll $t6, $t6, 1
                	or $t6, $t6, $t7
                	sll $t6, $t6, 2
                	or $t6, $t6, $t7
               		j hexLoopingStart
            	echoHex:
                	sll $t6, $t6, 1
                	or $t6, $t6, $t7
                	sll $t6, $t6, 1
                	or $t6, $t6, $t7
                	sll $t6, $t6, 1
                	or $t6, $t6, $t7
                	sll $t6, $t6, 1
                	j hexLoopingStart
            	foxtrotHex:  
                	sll $t6, $t6, 1
                	or $t6, $t6, $t7
                	sll $t6, $t6, 1
                	or $t6, $t6, $t7
                	sll $t6, $t6, 1
                	or $t6, $t6, $t7
                	sll $t6, $t6, 1
                	or $t6, $t6, $t7
                	j hexLoopingStart
        hexLoopingEnd:
        	li $t8, 8
        	bne $t9, $t8, printInvalidArgMsg
        	bnez $t3, printInvalidArgMsg
        	li $t2, 0x00000000
        	beq $t2, $t6, printZero
        	li $t2, 0x80000000
       	 	beq $t2, $t6, printZero
        	li $t2, 0xFF800000
        	beq $t2, $t6, printNegInf
        	li $t2, 0x7F800000
        	beq $t2, $t6, printPosInf
        	li $t2, 0x7f800001
        	bge $t6, $t2, NaNscript
        	NaNscriptExit:
        		li $t2, 0xff800001
        		bge $t6, $t2, NaNscriptTwo
        	NaNscriptTwoExit:
        		move $t3, $t6
        		srl $t3, $t3, 31
        		bnez $t3, positive
       			li $t2, 0
        	posEnd:       
        		move $t3, $t6
        		sll $t3, $t3, 1
        		srl $t3, $t3, 24
        		addi $t3, $t3, -127
        		move $a0, $t3
        		li $v0, 1
        		syscall
 
        		move $t3, $t6
        		sll $t3, $t3, 9
        		la $t1, mantissa
        		bnez $t2, negative
        		li $t4, '1'
        		li $t5, '.'
        		sb $t4, 0($t1)
        		sb $t5, 1($t1)
        		addi $t1, $t1, 2
        	negativeEnd:
        		li $t4, 0
        		li $t5, 23
        		mLoopSequence:
            			beq $t4, $t5, mloopSequenceEnd
            			move $t6, $t3
            			sllv $t6, $t6, $t4
            			srl $t6, $t6, 31
            			beqz $t6, zeroF
            			bnez $t6, oneF
            	endCode:	
            		addi $t4, $t4, 1
            		j mLoopSequence
        	mloopSequenceEnd:
        		move $t9, $a0
      			la $a0, newline
        		li $v0, 4
        		syscall
        		la $a0, mantissa
       			li $v0, 4
        		syscall
        		move $a0, $t9
       			la $a1, mantissa
       			move $a0, $t9
        		j terminate
    	NaNscript:
    	    li $t2, 0x7FFFFFFF
    	    ble $t6,$t2, printNaN
    	    j NaNscriptExit
    	    
    	NaNscriptTwo:
    	    li $t2, 0xFFFFFFFF
    	    ble $t6, $t2, printNaN
    	    j NaNscriptTwoExit
    	    
    	positive:
    	    li $t2, 1
    	    j posEnd
    	    
    	negative:
    	    li $t4, '-'
    	    li $t5, '1'
    	    li $t6, '.'
    	    sb $t4, 0($t1)
    	    sb $t5, 1($t1)
    	    sb $t6, 2($t1)
    	    addi $t1, $t1, 3
    	    j negativeEnd
    	    
    	oneF:
      	    li $t6, '1'
      	    sb $t6, 0($t1)
      	    addi $t1, $t1, 1
      	    j endCode
      	
      	zeroF:
      	    li $t6, '0'
            sb $t6, 0($t1)
            addi $t1, $t1, 1
            j endCode	
	j terminate

#prints all errors, messages, etc
printArgError:
	la $a0,	 args_err_msg
	li $v0, 4
	syscall
	j terminate

printInvalidHandMsg:
	la $a0, invalid_hand_msg
	li $v0, 4
	syscall
	j terminate

printInvalidArgMsg:
	la $a0, invalid_arg_msg
	li $v0, 4
	syscall
	j terminate
	
printZero:
	la $a0, zero
	li $v0, 4
	syscall
	j terminate
	
printNegInf:
	la $a0, inf_neg
	li $v0, 4
	syscall
	j terminate
	
printPosInf:
	la $a0, inf_pos
	li $v0, 4
	syscall
	j terminate
	
printNaN:
	la $a0, nan
	li $v0, 4
	syscall
	j terminate
	
#termination 
terminate: 
	li $v0, 10
	syscall
