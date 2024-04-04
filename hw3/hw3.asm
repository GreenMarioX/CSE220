######### Steven Tung ##########
######### 114437192 ##########
######### stetung ##########

######## DO NOT ADD A DATA SECTION ##########
######## DO NOT ADD A DATA SECTION ##########
######## DO NOT ADD A DATA SECTION ##########

.text
.globl initialize
initialize:
	#STORE PARAMETERS
    	addi $sp, $sp, -20
    	sw $a0, 12($sp)
    	sw $a1, 8($sp)
    	sw $ra, 16($sp)
	                            
    	#FILE
    	li $a1, 0
    	li $a2, 0
    	li $v0, 13                              
    	li $t4, 20 
    	syscall
    
    	#ERRORS CHECKING
    	blt $v0, $0, init13Error      
    	move $a0, $v0
    	lw $a1, 8($sp)
    	li $a2, 1
    	jal retrieveNumber                      
    	li $t7, 1
    	blt $v1, $t7, initDefError
    	li $t7, 10
    	bgt $v1, $t7, initDefError
   	move $t3, $v1                           
    	sw $v1, 4($sp)
    	jal retrieveNumber                            
    	li $t7, 1
    	blt $v1, $t7, initDefError
    	li $t7, 10
    	bgt $v1, $t7, initDefError
    	move $t6, $v1                            
    	sw $v1, 0($sp)
     
     	#READING
    	li $t7, 0                               
    	li $t1, 0                               
    	li $t0, 0                              
    	move $t5, $sp
    	addi $t5, $t5, 4                       
    	read2Dloop:
        	jal retrieveNumber    
        	beq $v0, $zero, initFinish
        	addi $sp, $sp, -4
        	addi $t4, $t4, 4
        	sw $v1, 0($sp)                       
        	addi $t1, $t1, 1
        	bne $t0, $0, readNL           
        	j read2Dloop
    	readNL:
        	bne $t6, $t1, initDefError 
        	addi $t7, $t7, 1
        	li $t1, 0
        	li $t0, 0
        	j read2Dloop
     
        #STORING   
    	initFinish:
        	bne $t3, $t7, initDefError  
        	move $t9, $t4
        	addi $t9, $t9, -16
        	move $sp, $t5
        swLoop:
            	beq $t9, $zero, swLoopExit
            	lw $t3, 0($sp)
            	addi $sp, $sp, -4
            	addi $t9, $t9, -4
            	sw $t3, 0($a1)                   
            	addi $a1, $a1, 4
            	j swLoop
        swLoopExit:
        	lw $t3, 0($sp)                         
        	sw $t3, 0($a1)    
        	li $v0, 16
        	syscall                               
        	li $v0, 1
    	endInit:
    		add $sp, $sp, $t4
    		lw $a1, -12($sp)
    		lw $a0, -8($sp)
    		lw $ra, -4($sp)
    		jr $ra
    
    	#ERROR HANDLING
    	initDefError:                     
        	li $t3, 0
        	sw $t3, 0($a1)
        	li $v0, 16
        	syscall
    	init13Error:                
        	li $v0, -1
        	j endInit  
   
retrieveNumber:
    	li $v1, 0                            
    	findNumLoop:
        	li $v0, 14
        	syscall
        	beq $v0, $zero, findNumExit     
        	blt $v0, $zero, findNumError   
        	  
        	lb $t9, 0($a1)   
        	                  
        	li $v0, ' '
        	beq $v0, $t9, findNumExit         
        	beq $t9, $zero, findNumExit  
        	    
        	li $v0, '0'
        	sub $t9, $t9, $v0                    
        	li $v0, -35
        	
        	beq $v0, $t9, windows                  
        	li $v0, -38
        	beq $v0, $t9, unix
        	      
        	li $v0, 0          
        	blt $t9, $v0, findNumError      
        	li $v0, 9
        	bgt $t9, $v0, findNumError       
        	li $v0, 10
        	
        	mult $v0, $v1
        	mflo $v1
        	add $v1, $v1, $t9                   
        	j findNumLoop
     	findNumError:
         	li $v1, -1
     		jr $ra
       	windows:                                     
         	li $v0, 14
         	syscall
     	unix:                                    
         	li $t0, 1
         	jr $ra 
        findNumExit:
         	jr $ra

.globl write_file
write_file:
    	addi $sp, $sp, -12
    	sw $ra, 8($sp)
   	sw $a0, 4($sp)
	sw $a1, 0($sp)
    	li $t5, 0                               
    
    	li $v0, 13                              
    	li $a1, 1
    	li $a2, 0
    	syscall
    	li $t4, 0
    	blt $v0, $t4, writeError
    	move $a0, $v0
    	lw $a1, 0($sp)
    	li $a2, 1
    
    	lw $t2, 0($a1)                        
    	jal insertNum
    	blt $v0, $0, writeError
    	jal insertNL
    
    	lw $t4, 0($a1)                        
    	jal insertNum
    	li $t9, 0
    	blt $v0, $0, writeError
    	jal insertNL
    
    	li $t9, 0                           
    	li $t1, 0                           
    	writeLoop:
        	jal insertNum
        	blt $v0, $0, writeError
        	addi $t1, $t1, 1
        	beq $t4, $t1, writeNL
        	jal insertSpace
        	j writeLoop
    	writeNL: 
        	li $t1, 0
        	addi $t9, $t9, 1
        	beq $t2, $t9, writeLoopExit
        	jal insertNL
        	j writeLoop
    	writeLoopExit:
    		jal insertNL
    		li $v0, 16
    		syscall
    		move $v0, $t5
    	writingEnd:
    		lw $ra, 8($sp)
    		addi $sp, $sp, 12
    		jr $ra
    
    	writeError:
        	li $v0, -1
        	j writingEnd
        
insertNum:
    	lw $t6, 0($a1)
    	beq $t6, $0, insert_zero
    	move $t3, $t6
    	li $t8, 0                                
    	numBreakLoop:
        	beq $t3, $0, numAssemLoop
        	li $t7, 10
        	div $t3, $t7
        	mflo $t3
        	mfhi $t7
        	addi $sp, $sp, -4
        	addi $t8, $t8, 4
        	sw $t7, 0($sp)
        	j numBreakLoop
    	numAssemLoop:
        	beq $t8, $0, numAssemLoopExit
        	lw $t3, 0($sp)
        	addi $sp, $sp, 4
        	addi $t8, $t8, -4
        	li $t7, '0'
        	add $t7, $t7, $t3
        	sb $t7, 0($a1)
        	li $v0, 15
        	syscall
        	blt $v0, $0, insertNumError
        	addi $t5, $t5, 1
        	j numAssemLoop
    	insertNumError:
    		add $sp, $sp, $t6
	numAssemLoopExit:
    		sw $t6, 0($a1)
    		addi $a1, $a1, 4
    		jr $ra
    	insert_zero:
    		li $t7, '0'
    		sw $t7, 0($a1)
    		li $v0, 15
    		syscall
    		j numAssemLoopExit
    		
	insertSpace:
    		li $t6, ' '
    		lw $t3, 0($a1)
    		sb $t6, 0($a1)
    		li $v0, 15
    		syscall
    		addi $t5, $t5, 1
    		sw $t3, 0($a1)
    		jr $ra
	insertNL:
    		li $t6, '0'
    		addi $t6, $t6, -38
    		lw $t3, 0($a1)
    		sb $t6, 0($a1)
    		li $v0, 15
    		syscall
   		addi $t5, $t5, 1
    		sw $t3, 0($a1)
    		jr $ra

.globl rotate_clkws_90
rotate_clkws_90:
	addi $sp, $sp, -500
  	addiu $t9, $sp, 0
  	move $t7, $a0
 	lw $t4, 0($t7)
  	sw $t4, 4($t9)
  
  	lw $t4, 4($t7)
 	sw $t4, 0($t9)
  	addiu $t9, $t9, 8 
  	addiu $t7, $t7, 8
  	
  	lw $t2, 0($a0)
  	lw $t1, 4($a0)

  	addi $t0, $t2, -1
  	li $t3, 0
  	li $t6, 4
  	mult $t1, $t6
  	mflo $t8
  	
  	column90Loop:
    		beq $t3, $t1, finish90
    	row90Loop:
      		bltz $t0, endRow90Loop
      		move $t5, $t7
     		mult $t0, $t8
      		mflo $t4
      		addu $t5, $t4, $t5
     
      		mult $t3, $t6
     		mflo $t4
      		addu $t5, $t4, $t5
      
      		lw $t4, 0($t5)
      		sw $t4, 0($t9)
      
      		addi $t9, $t9, 4
      		addi $t0, $t0, -1
      		j row90Loop
    	endRow90Loop:
      		addi $t0, $t2, -1
		addi $t3, $t3, 1
      		j column90Loop
      	finish90:
      		mult $t2, $t1
    		mflo $t2
    		addi $t2, $t2, 2
    		li $t1, 0
    		move $t0, $sp
    		move $t3, $a0
	bufferStore90:
      		beq $t1, $t2, fileWrite90
      		lw $t4, 0($t0)
      		sw $t4, 0($t3)
      		addi $t1, $t1, 1
      		addi $t0, $t0, 4
      		addi $t3, $t3, 4
      		j bufferStore90
  	fileWrite90:
    		addi $sp, $sp, 500
    		addi $sp, $sp, -4
    		sw $ra, 0($sp) 
    		move $t4, $a1
    		move $a1, $a0
    		move $a0, $t4
    		jal write_file
    		lw $ra, 0($sp)
    		addi $sp, $sp, 4
    		jr $ra

.globl rotate_clkws_180
rotate_clkws_180:
	addi $sp, $sp, -12
    	sw $ra, 8($sp)
    	sw $a0, 4($sp)
    	sw $a1, 0($sp)

    	lw $t8, 0($a0)                                   
    	lw $t7, 4($a0)                                   
    	addi $a0, $a0, 8

    	addi $t2, $t8, -1                                   
    	move $t9, $t7                                   
    	addi $t9, $t9, -1
    	move $t4, $sp
    	addi $t4, $t4, -4                   
    	li $t0, 0                                      
    	rotate180Iterator:
        	mult $t2, $t7
        	mflo $t3
        	add $t3, $t3, $t9
        	li $t1, 4
        	mult $t3, $t1
        	mflo $t3
        	add $a0, $a0, $t3
        	lw $t1, 0($a0)
        	addi $sp, $sp, -4
        	addi $t0, $t0, 4
        	sw $t1, 0($sp)
        	sub $a0, $a0, $t3
        	addi $t9, $t9, -1
        	blt $t9, $0, rotate180MoveRow
        	j rotate180Iterator
    	rotate180MoveRow:
        	addi $t2, $t2, -1
        	blt $t2, $0, rotate180Matrix
        	move $t9, $t7
        	addi $t9, $t9, -1
        	j rotate180Iterator
    	rotate180Matrix:
       		move $sp, $t4
        	move $t3, $t0
        	matrix180Loop:
            		beq $t3, $0, rotate180MatrixExit
            		lw $t1, 0($sp)
            		sw $t1, 0($a0)
            		addi $sp, $sp, -4
            		addi $t3, $t3, -4
            		addi $a0, $a0, 4
            		j matrix180Loop
    	rotate180MatrixExit:
    		addi $t0, $t0, 4
    		add $sp, $sp, $t0
    		lw $a0, 0($sp)
    		lw $a1, 4($sp)
    		jal write_file
    		lw $a0, 4($sp)
    		lw $a1, 0($sp)
    		lw $ra, 8($sp)
    		addi $sp, $sp, 12
    		jr $ra

.globl rotate_clkws_270
rotate_clkws_270:
    	addi $sp, $sp, -500
  	addiu $t0, $sp, 0
	move $t2, $a0
  
  	lw $t4, 0($t2)
  	sw $t4, 4($t0)
  	lw $t4, 4($t2)
  	sw $t4, 0($t0)

  	addiu $t0, $t0, 8
  	addiu $t2, $t2, 8
  
  	lw $t6, 0($a0)
  	lw $t8, 4($a0)

  	li $t1, 0
  	addi $t3, $t8, -1
  	li $t7, 4
  	mult $t8, $t7
 	mflo $t5
	column270Loop:
    		bltz $t3, finish270
    		row270Loop:
      			beq $t1, $t6, row270LoopEnd
      			move $t9, $t2
     			mult $t1, $t5
      			mflo $t4
      			addu $t9, $t4, $t9
      			mult $t3, $t7
      			mflo $t4
      			addu $t9, $t4, $t9     
      			lw $t4, 0($t9)
      			sw $t4, 0($t0)
      			addi $t0, $t0, 4
      			addi $t1, $t1, 1
      			j row270Loop 
    		row270LoopEnd:
      			li $t1, 0
      			addi $t3, $t3, -1
      			j column270Loop
  	finish270:
   		mult $t6, $t8
    		mflo $t6
    		addi $t6, $t6, 2
    		li $t8, 0
    		move $t1, $sp
    		move $t3, $a0
    	bufferLoop270:
      		beq $t8, $t6, writeLoop270
      		lw $t4, 0($t1)
      		sw $t4, 0($t3)
      		addi $t8, $t8, 1
      		addi $t1, $t1, 4
      		addi $t3, $t3, 4
      		j bufferLoop270
  	writeLoop270:
    		addi $sp, $sp, 500
    		addi $sp, $sp, -4
    		sw $ra, 0($sp)	
    		move $t4, $a1
    		move $a1, $a0
    		move $a0, $t4
    		jal write_file
    		lw $ra, 0($sp)
    		addi $sp, $sp, 4
    		jr $ra
    
    
    
    
    
.globl mirror
mirror:
    	addi $sp, $sp, -12
    	sw $ra, 8($sp)
    	sw $a0, 4($sp)
    	sw $a1, 0($sp)

    	lw $t5, 0($a0)                                   
    	lw $t6, 4($a0)                                 
    	addi $a0, $a0, 8

    	li $t3, 0                                     
    	move $t2, $t6                               
    	addi $t2, $t2, -1
    	move $t1, $sp
    	addi $t1, $t1, -4                         
    	li $t4, 0                                        
    	mirrorStacker:
        	mult $t3, $t6
        	mflo $t7
        	add $t7, $t7, $t2
        	li $t8, 4
        	mult $t7, $t8
        	mflo $t7
        	add $a0, $a0, $t7
        	lw $t8 0($a0)
        	addi $sp, $sp, -4
        	addi $t4, $t4, 4
        	sw $t8, 0($sp)
        	sub $a0, $a0, $t7
        	addi $t2, $t2, -1
        	blt $t2, $0, mirrorNewRow
        	j mirrorStacker
    	mirrorNewRow:
        	addi $t3, $t3, 1
        	beq $t3, $t5, mirrorMatrixer
        	move $t2, $t6
        	addi $t2, $t2, -1
        	j mirrorStacker
    	mirrorMatrixer:
        	move $sp, $t1
        	move $t7, $t4
        matrixLoop:
            	beq $t7, $0, mirrorMatrixerExit
            	lw $t8, 0($sp)
            	sw $t8, 0($a0)
            	addi $sp, $sp, -4
            	addi $t7, $t7, -4
            	addi $a0, $a0, 4
            	j matrixLoop
    	mirrorMatrixerExit:
    		addi $t4, $t4, 4
    		add $sp, $sp, $t4
    		lw $a0, 0($sp)
    		lw $a1, 4($sp)
    		jal write_file
    		lw $a0, 4($sp)
    		lw $a1, 0($sp)
    		lw $ra, 8($sp)
    		addi $sp, $sp, 12
    		jr $ra

.globl duplicate
duplicate:
  	addi $sp, $sp, -52

  	lw $t5, 0($a0)
  	li $t2, 1
  	beq $t5, $t2, noDuplications
  	lw $t2, 4($a0)
  
  	sw $t5, 0($sp)
 	sw $t2, 4($sp)
  
  	li $t5, 0 
  	li $t2, 0 
  	li $t4, 0 
  	li $t6, 0 
  	li $t3, 0 
  	li $t1, 0 
  	lw $t0, 0($sp) 
  	lw $t7, 4($sp)
  	li $t9, 0 
  
  	li $t8, 4
  	sw $t8, 8($sp) 
  	mult $t7, $t8
  	mflo $t8 
  	sw $t8, 12($sp) 
  	sw $s0, 16($sp)
  
  	li $v1, 0
  	rowIteration:
    		addi $t8, $t0, -1
    		beq $t5, $t8, dupeFinish
    
    		addi $t9, $t5, 1
    	subRowIteration:
     		beq $t9, $t0, rowMove
      
      	lw $t8, 12($sp)
      	mult $t5, $t8
      	mflo $t8
      	add $t4, $a0, $t8
      	addi $t4, $t4, 8
      	lw $t8, 12($sp)
      	mult $t9, $t8
      	mflo $t8
      	add $t6, $a0, $t8
      	addi $t6, $t6, 8
      	li $t2, 0
      	
      	colIteration:
        	beq $t2, $t7, containsDupe
        	lw $t3, 0($t4)
        	lw $t1, 0($t6)
        	bne $t3, $t1, subRowMove
        	addi $t2, $t2, 1 
        	addi $t4, $t4, 4
        	addi $t6, $t6, 4 
        	j colIteration
      	subRowMove:
        	addi $t9, $t9, 1
        	j subRowIteration
    	rowMove:
      		addi $t5, $t5, 1
      		j rowIteration
  	containsDupe:
    		beqz $v1, firstDuplication
    		j checkForMoreDuplicates
    	firstDuplication:
      		addi $v1, $t9, 1
      		j subRowMove
    	checkForMoreDuplicates:
      		addi $s0, $t9, 1
      		bge $s0, $v1, subRowMove
      		move $v1, $s0
      		j subRowMove
  	dupeFinish:
    		beqz $v1, noDuplications
    		li $v0, 1
    		j terminate
    	noDuplications:
      		li $v0, -1
      		li $v1, 0
    	terminate:
      		lw $s0, 16($sp)
      		addi $sp, $sp, 52
      		jr $ra
