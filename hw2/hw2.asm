########### Steven Tung ############
########### stetung ################
########### 114437192 ################

###################################
##### DO NOT ADD A DATA SECTION ###
###################################

.text
.globl hash
hash:
	li $t2, 0 				#$t2, value counter
	move $t0, $a0				#$t0, address holder	
	hashLoop:
		lb $t1, 0($t0) 			#$t1, current byte holder
		beq $t1, $zero, hashLoopEnd
		add $t2, $t1, $t2
		addi $t0, $t0, 1
		j hashLoop
	hashLoopEnd:
		move $v0, $t2
  		jr $ra
	
.globl isPrime
isPrime:
  	li $t0, 1 
  	bleu $a0, $t0, notPrime
  	li $t0, 3
  	bleu $a0, $t0, isPrimeNum
  
  	li $t6, 1 
  	initialCheckloop:
  		addi $t6, $t6, 1
		divu $a0, $t6
  		mfhi $t7
  		beqz $t7, notPrime
  		beq $t6, $t0, endCheckLoop
  		j initialCheckloop
  	endCheckLoop:
  
  	li $t0, 5
  	li $t9, 7
  	isPrimeLoopBegin:
    		multu $t0, $t0
    		mflo $t7
    		bgeu $t7, $a0, isPrimeNum

    		divu $a0, $t0
    		mfhi $t7
    		beqz $t7, notPrime
    
    		divu $a0, $t9
    		mfhi $t7
    		beqz $t7, notPrime
   
    		addiu $t0, $t0, 6
    		addiu $t9, $t9, 6
    		j isPrimeLoopBegin
  	notPrime:
    		li $v0, 0
   		jr $ra
  	isPrimeNum:
    		li $v0, 1
    		jr $ra

.globl lcm
lcm:
	move $t6, $a0			#get first number
	move $t7, $a1			#get second number
	mult $t6, $t7
	mflo $t8
	
	move $t0, $a0			#get first number
	move $t1, $a1			#get second number
	gcdFindLoop:
		bgt $t0, $t1, gcdOrder
		move $t2, $t1			#rearrange numbers so that the largest number is in $t0
		move $t1, $t0
		move $t0, $t2
		gcdOrder:
		div $t0, $t1
		mfhi $t3
		beqz $t3, gcdFindLoopEnd
		move $t0, $t3
		j gcdFindLoop
	gcdFindLoopEnd:
		move $t3, $t1
	
	div $t8, $t3
	mflo $t5
	move $v0, $t5
  	jr $ra

.globl gcd
gcd:
	move $t0, $a0			#get first number
	move $t1, $a1			#get second number
	gcdLoop:
		bgt $t0, $t1, inOrder
		move $t2, $t1			#rearrange numbers so that the largest number is in $t0
		move $t1, $t0
		move $t0, $t2
		inOrder:
		div $t0, $t1
		mfhi $t3
		beqz $t3, gcdLoopEnd
		move $t0, $t3
		j gcdLoop
	gcdLoopEnd:
		move $v0, $t1
  		jr $ra

.globl pubkExp
pubkExp:
	move $a1, $a0
	move $s1, $ra
	li $s0, 1
	publicLoop:
		li $v0, 42
		syscall
		move $t9, $a0
		bge $t9, $a1, publicLoop
		ble $t9, $s0, publicLoop
		jal gcd
		li $s0, 1
		move $t1, $v0
		bne $s0, $t1, publicLoop
		move $v0, $t9
		move $ra, $s1
		move $s0, $zero
		move $s1, $zero
  	jr $ra

.globl prikExp
prikExp:
  	move $a2, $ra
  	jal gcd
  	li $t0, 1
  	bne $t0, $v0, coprimeChecker
  
 	move $t0, $a0 
  	move $t9, $a1
  	
  	li $t6, 0  
  	div $t9, $t0  
  	move $t9, $t0 
 	mfhi $t0       
  	mflo $t6     
  	
  	li $t5, 0
  	div $t9, $t0  
  	move $t9, $t0 
  	mfhi $t0 
  	mflo $t5    
  
  	li $t3, 0
  	li $t4, 0
  	li $t7, 1
  	li $t8, 0
 	prikLoopBegin:
    		mult $t6, $t7
    		mflo $t3
    		li $t4, 0
    		sub $t4, $t4, $t3
    		add $t4, $t8, $t4
    		bgez $t4, skip
    		abs $t4, $t4
    		div $t4, $a1
    		mfhi $t4
    		sub $t4, $a1, $t4
    	skip:
    		div $t4, $a1 
    		mfhi $t4
    		move $t8, $t7
    		move $t7, $t4
    		beqz $t0, prikLoopEnd
    		div $t9, $t0
    		move $t9, $t0
    		mfhi $t0
    		move $t6, $t5 
    		mflo $t5     
    		j prikLoopBegin 
    		
  	coprimeChecker:
    		li $v0, -1
    		jr $a2
    		
  	prikLoopEnd:
    		move $v0, $t4
    		jr $a2
    			
.globl encrypt
encrypt:
  	
  	addi $sp, $sp -16
  	sw $ra, 0($sp)
  	sw $a0, 4($sp) #6
  	sw $a1, 8($sp) #7
  	sw $a2, 12($sp)#8

  	
  	lw $a0, 8($sp)
  	jal isPrime
  	beqz $v0, endEncrypt
  	
  	lw $a0, 12($sp)
  	jal isPrime
  	beqz $v0, endEncrypt
  	
  	lw $t3, 8($sp)
  	lw $t2, 12($sp)
  	addi $a0, $t3, -1
  	addi $a1, $t2, -1
  	jal lcm
  	move $a0, $v0
  	jal pubkExp
  	move $v1, $v0
  	
  	lw $a0, 4($sp)
  	lw $a1, 8($sp)
  	lw $a2, 12($sp)
  	
  	mult $a1, $a2
  	mflo $t0
  	
  	move $t9, $v1
  	addi $t9, $t9, -1
  	
  	div $a0, $t0
  	mfhi $t7
  	
  	move $t5, $t7
  	li $t3, 0
  	
  	encryptLoop:
  		beq $t3, $t9, endEncryptLoop
  		mult $t5, $t7
  		mflo $t4
  		div $t4, $t0
  		mfhi $t5
  		addiu $t3, $t3, 1
  		j encryptLoop
  		
  	endEncryptLoop:
  		move $v0, $t5
  	endEncrypt:
  		lw $ra, 0($sp)
  		addi $sp, $sp, 16
  		jr $ra
  	
  	
  	
.globl decrypt
decrypt:
	addi $sp, $sp, -16
	sw $a2, 12($sp)
	sw $a1, 8($sp)
	sw $a0, 4($sp)
	sw $ra, 0($sp)
	
	move $a0, $a2
	jal isPrime
	beqz $v0, endDecrypt
	
	move $a0, $a3
	jal isPrime
	beqz $v0, endDecrypt
	
	addi $a0, $a2, -1
	addi $a1, $a3, -1
	jal lcm
	lw $a0, 8($sp)
	move $a1, $v0
	jal prikExp
	move $t1, $v0
	addi $t1, $t1, -1
	
	lw $a2, 12($sp)
	lw $a1, 8($sp)
	lw $a0, 4($sp)
	
	mult $a2, $a3
	mflo $t0
	div $a0, $t0
	mfhi $t3
	
	move $t5, $t3
	li $t7, 0
	
	decryptLoop:
		beq $t7, $t1, endDecryptLoop
		mult $t5, $t3
		mflo $t6
		div $t6, $t0
		mfhi $t5
		addiu $t7, $t7, 1
		j decryptLoop
	
	endDecryptLoop:
		move $v0, $t5
	
	endDecrypt:
		lw $ra, 0($sp)
		addi $sp, $sp, 16
  		jr $ra
