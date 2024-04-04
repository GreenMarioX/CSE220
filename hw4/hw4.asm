######### Steven Tung ##########
######### 114437192 ##########
######### stetung ##########

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:

.globl create_network
create_network:
    	addi $sp, $sp, -8
    	sw $a0, 4($sp)
    	sw $a1, 0($sp)
    	blt $a0, $zero, buildNetworkError
    	blt $a1, $zero, buildNetworkError
    	li $t5, 16                          
    	li $t9, 4
    	mult $a0, $t9
    	mflo $t7
    	add $t5, $t5, $t7
    	mult $a1, $t9
    	mflo $t7
    	add $t5, $t5, $t7
    	move $a0, $t5
    	li $v0, 9
    	syscall
    	move $t9, $v0                     
    	lw $t7, 4($sp)
    	sw $t7, 0($t9)               
    	addi $t9, $t9, 4
    	lw $t7, 0($sp)
    	sw $t7, 0($t9)
    	addi $t9, $t9, 4
    	addi $t5, $t5, -8
    	li $t7, 0
    	buildNetworkLoop:
        	beq $t5, $t7, buildNetworkEnd
        	sw $t7, 0($t9)
        	addi $t9, $t9, 4
        	addi $t5, $t5, -4
        	j buildNetworkLoop
    	buildNetworkEnd:
    		addi $sp, $sp, 8
    		jr $ra
    	buildNetworkError:
        	li $v0, -1
        	j buildNetworkEnd

.globl add_person
add_person:
    addi $sp, $sp, -8
    sw $a0, 4($sp)
    sw $a1, 0($sp)
    lw $t0, 0($a0)
    lw $t1, 8($a0)
    beq $t0, $t1, addPersonError
    lb $t0, 0($a1)
    beq $t0, $0, addPersonError
    lw $t9, 4($sp)
    li $t0, 0                  
    personNameBreak:
        lb $t1, 0($a1)
        beq $t1, $0, personNameBreakEnd
        addi $a1, $a1, 1
        addi $sp, $sp, -1
        addi $t0, $t0, 1
        sb $t1, 0($sp)
        j personNameBreak
    personNameBreakEnd:
    addi $t1, $t0, 5                
    li $t2, 0                       
    add $sp, $sp, $t0
    addi $sp, $sp, -1
    lw $t3, 8($a0)
    addi $t3, $t3, -1           
    addi $a0, $a0, 16
    li $t5, 0
    personNLC:
        addi $t2, $t2, 1
        bgt $t2, $t3, personNLCDone
        lw $t4, 0($a0)            
        lw $t5, 0($t4)
        addi $a0, $a0, 4
        bne $t0, $t5, personNLC
        addi $t4, $t4, 4
        li $t5, 0                 
        personNLCC:
            lb $t6, 0($t4)
            addi $t4, $t4, 1
            lb $t7, 0($sp)
            addi $sp, $sp, -1
            addi $t5, $t5, 1
            bne $t6, $t7, personNLCR
            beq $t0, $t5, samePersonError
            j personNLCC         
    personNLCDone:
    li $v0, 9
    move $a0, $t1
    syscall
    move $a0, $t9
    lw $t2, 8($a0)
    li $t3, 4
    mult $t2, $t3
    mflo $t2
    addi $t2, $t2, 16
    add $a0, $a0, $t2
    sw $v0, 0($a0)
    sw $t0, 0($v0)
    addi $v0, $v0, 4
    li $t2, 0
    storePerson:
        beq $t0, $t2, storePersonEnd
        lb $t3, 0($sp)
        addi $sp, $sp, -1
        sb $t3, 0($v0)
        addi $t2, $t2, 1
        addi $v0, $v0, 1
        j storePerson
    storePersonEnd:
    li $t3, 0
    sb $t3, 0($v0)
    move $v0, $t9
    lw $t3, 8($v0)
    addi $t3, $t3, 1
    sw $t3, 8($v0)
    li $v1, 1
    add $sp, $sp, $t0
    addi $sp, $sp, 1
    addPersonEnd:
    addi $sp, $sp, 8
    jr $ra
    
    personNLCR:
        add $sp, $sp, $t5
        j personNLC
        
    samePersonError:
        add $sp, $sp, $t0
        addi $sp, $sp, 1
    addPersonError:
        li $v0, -1
        li $v1, -1
        j addPersonEnd

.globl get_person
get_person:
  	lb $t5, 0($a1)
  	beqz $t5, end
  	lw $t5, 8($a0)
  	beqz $t5, end
  	li $t9, 0 
  	addi $t7, $a0, 16 
  	nodeLooper:
    		beq $t5, $t9, end
    		lw $t2, 0($t7)
    		move $t0, $a1 
    		addi $t1, $t2, 4
    	charLooper:
      		lb $t3, 0($t0)
      		lb $t4, 0($t1)
      		bne $t3, $t4, nodeAdvance
      		add $t3, $t3, $t4
      		beqz $t3, personDiscovered
      		addi $t0, $t0, 1
      		addi $t1, $t1, 1
      		j charLooper 
    	nodeAdvance:
      		addi $t9, $t9, 1 
      		addi $t7, $t7, 4
      		j nodeLooper
  	personDiscovered:
    		move $v0, $t2
    		li $v1, 1
    		jr $ra

.globl add_relation
add_relation:
    	addi $sp, $sp, -20
    	sw $ra, 16($sp)
    	sw $a0, 12($sp)
   	sw $a1, 8($sp)
    	sw $a2, 4($sp)
    	sw $a3, 0($sp)
    	li $t8, 0
    	beq $a1, $a2, addRelationErr                 
    	lw $t5, 4($a0)
    	lw $t9, 12($a0)
   	 beq $t5, $t9, addRelationErr          
    	blt $a3, $0, addRelationErr                  
    	li $t5, 3
    	bgt $a3, $t5, addRelationErr               
    	lw $t5, 12($a0)                               
    	lw $t9, 0($a0)
    	li $t7, 4
    	mult $t9, $t7
    	mflo $t9
   	addi $a0, $a0, 16
    	add $a0, $a0, $t9
    	li $t9, 0                                       
	addRelationCheck:
        	beq $t5, $t9, addRelationCheckEnd
        	lw $t7, 0($a0)                             
        	addi $a0, $a0, 4
        	addi $t9, $t9, 1
        	li $t2, 0                                     
        	li $t0, 2                               
        edgeTrack:
            	lw $a1, 8($sp)
            	lw $a2, 4($sp)
            	beq $t0, $0, edgeTrackEnd
           	lw $t1, 0($t7)                          
            	addi $t0, $t0, -1
           	 addi $t1, $t1, 4
        nameEdgeTrack:
                lb $t3, 0($t1)
                addi $t1, $t1, 1
                lb $t4, 0($a1)
                addi $a1, $a1, 1
                bne $t3, $t4, nameEdgeTrackEnd
                beq $t3, $0, edgeNameSame
                j nameEdgeTrack
        nameEdgeTrackEnd:
            	lw $t1, 0($t7)
       	name2EdgeTrack:
                lb $t3, 0($t1)
                addi $t1, $t1, 1
                lb $t4, 0($a2)
                addi $a2, $a2, 1
                bne $t3, $t4, name2EdgeTrackEnd
                beq $t3, $0, edgeNameSame
                j name2EdgeTrack
       	edgeNameSame:
                addi $t2, $t2, 1
        name2EdgeTrackEnd:
            	addi $t7, $t7, 4    
            	j edgeTrack
        edgeTrackEnd:
        	li $t0, 2
        	beq $t2, $t0, addRelationErr 
        	j addRelationCheck
    	addRelationCheckEnd:
    		li $t8, 4                                       
    		addi $sp, $sp, -4
    		sw $a0, 0($sp)
    		lw $a0, 16($sp)
    		lw $a1, 12($sp) 
    		jal get_person
    		li $t5, -1
    		beq $t5, $v1, addRelationErr                 
    		addi $sp, $sp, -4
    		addi $t8, $t8, 4
    		sw $v0, 0($sp)
    		lw $a0, 20($sp)
    		lw $a1, 12($sp)
    		jal get_person
    		li $t5, -1
    		beq $t5, $v1, addRelationErr                   
    		addi $sp, $sp, -4
    		addi $t8, $t8, 4
    		sw $v0, 0($sp)
    		li $a0, 12
    		li $v0, 9
    		syscall
    		lw $t4, 8($sp)
    		sw $v0, 0($t4)
    		lw $t5, 4($sp)
    		sw $t5, 0($v0)
    		lw $t5, 0($sp)
    		sw $t5, 4($v0)
    		sw $a3, 8($v0)
    		lw $a0, 24($sp)
    		addi $a0, $a0, 12
    		lw $t5, 0($a0)
    		addi $t5, $t5, 1
    		sw $t5, 0($a0)
    		lw $v0, 24($sp)
    		li $v1, 1
    	addRelationFinish:
    		add $sp, $sp, $t8
    		lw $ra, 16($sp)
    		addi $sp, $sp, 20
    		jr $ra
    	addRelationErr:
        	li $v0, -1
        	li $v1, -1
        	j addRelationFinish

.globl get_distant_friends
get_distant_friends:
  	move $t6, $ra
  	jal get_person 
  	move $ra, $t6
  	bltz $v1, end2
  	lw $t9, 12($a0) 
  	beqz $t9, end 
  	addi $sp, $sp, -20
 	sw $s1, 0($sp)
  	sw $s2, 4($sp)
  	sw $s3, 8($sp)
  	sw $s4, 12($sp)
  	sw $s5, 16($sp)
 	 move $s5, $a0  
  	lw $t5, 8($a0)
  	lw $t9, 12($a0) 
  	li $t7, 4 
	addi $t2, $t5, 1
  	mult $t7, $t2
  	mflo $a0
  	li $v0, 9
  	syscall
  	move $s1, $v0
    	li $t0, 0 
    	move $t2, $v0
    	initOne:
      		beq $t0, $a0, nextOne
      		sw $zero, 0($t2)
      		addi $t2, $t2, 4
      		addi $t0, $t0, 4
      		j initOne
  	nextOne:
  	addi $t2, $t5, 1
  	mult $t7, $t2
  	mflo $a0
  	li $v0, 9
  	syscall
  	move $s2, $v0 
    	li $t0, 0 
    	move $t2, $v0
    	initTwo:
      		beq $t0, $a0, nextTwo
      		sw $zero, 0($t2)
      		addi $t2, $t2, 4
      		addi $t0, $t0, 4
      		j initTwo
  	nextTwo:
  		move $t2, $t5
  		mult $t7, $t2
  		mflo $a0
  		li $v0, 9
  		syscall
  		move $s3, $v0
    		li $t0, 0 
    		move $t2, $v0
    	initThree:
     	 	beq $t0, $a0, nextThree
      		sw $0, 0($t2)
      		addi $t2, $t2, 4
      		addi $t0, $t0, 4
      		j initThree
  
  	nextThree:
  		addi $t2, $t9, 1
  		mult $t7, $t2
  		mflo $a0
  		li $v0, 9
  		syscall
  		move $s4, $v0
    		li $t0, 0 
    		move $t2, $v0
    	initFour:
      		beq $t0, $a0, nextFour
      		sw $0, 0($t2)
      		addi $t2, $t2, 4
      		addi $t0, $t0, 4
      		j initFour
  	nextFour:
  		move $a0, $s5 
  		lw $t5, 8($a0)
  		lw $t9, 12($a0)
  		li $t7, 4
  		mult $t5, $t7
  		mflo $t2   
  		add $t2, $t2, $a0
  		addi $t2, $t2, 16
  		move $t0, $t2
  		mult $t9, $t7
 		 mflo $t1
  		li $t3, 0  
  	edgeCopy:
    		beq $t1, $t3, copyFinish
    		lw $t4, 0($t0) 
    		lw $t8, 8($t4)
    		addi $t8, $t8, -1
   		beqz $t8, edgeValid
    		j edgeInvalid
    	edgeValid:
      		add $t8, $s4, $t3
      		sw $t4, 0($t8)
      		j edgeMove
    	edgeInvalid:
      		add $t8, $s4, $t3
      		li $t6, -1
      		sw $t6, 0($t8)
      		j edgeMove
    	edgeMove:
      		addi $t0, $t0, 4
      		addi $t3, $t3, 4
      		j edgeCopy
  	copyFinish:
  		move $t6, $ra
  		jal get_person 
  		move $ra, $t6 
  		move $t5, $s4
  		li $t7, 0 
  	neighborsSearch:
    		lw $t9, 0($t5) 
    		beqz $t9, neighborsFound
    		bltz $t9, nextEdge
    		lw $t2, 0($t9)
    		lw $t0, 4($t9)
    		beq $v0, $t2, addNeighbor
    		sw $t0, 0($t9) 
    		sw $t2, 4($t9)
    		lw $t2, 0($t9) 
    		lw $t0, 4($t9) 
    		beq $v0, $t2, addNeighbor
    		j nextEdge
    	addNeighbor:
      		add $t1, $s3, $t7
		addi $t7, $t7, 4
      		sw $t0, 0($t1)
    	nextEdge:
      		addi $t5, $t5, 4
      		j neighborsSearch
  	neighborsFound:
  		sw $v0, 0($s1) 
  		li $t5, 0
  		li $t9, 0
  		li $t7, 4 
  		li $t2, 0 
  	queuePriority:
    		add $t5, $s1, $t9
    		lw $t5, 0($t5) 
    		beqz $t5, endBreathFirst
    		li $t0, 0 
    	addNeighToQueue:  
      	add $t1, $s4, $t0
      	lw $t1, 0($t1) 
     	bltz $t1, nextEdgeValid
      	beqz $t1, iterateQueuePriority
      	lw $t3, 0($t1) 
      	lw $t4, 4($t1) 
      	beq $t5, $t3, checkPQ
      	sw $t3, 4($t1)
      	sw $t4, 0($t1)
      	lw $t3, 0($t1)
      	lw $t4, 4($t1)
      	beq $t5, $t3, checkPQ
      	j nextEdgeValid  
      	checkPQ:
        	move $t3, $s1
      	checkPQLoop:
        	lw $t8, 0($t3)
        	beqz $t8, addToPQ
        	beq $t4, $t8, nextEdgeValid 
        	addi $t3, $t3, 4
        	j checkPQLoop 
      	addToPQ:
        	add $t3, $s1, $t7
        	sw $t4, 0($t3)
        	addi $t7, $t7, 4  
      	nextEdgeValid:
        	addi $t0, $t0, 4
        	j addNeighToQueue
    	iterateQueuePriority:
      		add $t3, $s2, $t2
      		sw $t5, 0($t3) 
      		addi $t9, $t9, 4
      		addi $t2, $t2, 4
      		j queuePriority
  	endBreathFirst:
    		li $t5, -1
    		sw $t5, 0($s2)
    		move $t9, $s2 
    		move $t7, $s3 
    	removeVisit:
      		lw $t2, 0($t7) 
      		beqz $t2, createLL
     		move $t0, $s2
      	pullAway:
        	lw $t1, 0($t0)
       		beq $t2, $t1, remove
        	beqz $t1, nextNeigh
        	addi $t0, $t0, 4
        	j pullAway
      	remove:
        	sw $t5, 0($t0)
	nextNeigh:
        	addi $t7, $t7, 4
        	j removeVisit
    	createLL:
    		li $t5, 0 
    		move $t9, $s2
    	countNumNeigh:
      		lw $t7, 0($t9)
      		bltz $t7, iterateNext
      		beqz $t7, foundNeighborCount
      		addi $t5, $t5, 1
      	iterateNext:
        	addi $t9, $t9, 4
        	j countNumNeigh
    	foundNeighborCount:
      		beqz $t5, endAndRestore
    		addi $t9, $t9, -4
    		li $t0, 4
    		li $t4, 0 
    	iterateBack:
      		beqz $t5, finishedLL
      		lw $t7, 0($t9)
      		bltz $t7, backOne
      		lw $t2, 0($t7)
      		addi $t2, $t2, 1 
      	untilFD:
       		div $t2, $t0
        	mfhi $t1
        	beqz $t1, createFN
        	addi $t2, $t2, 1
        	j untilFD
      	createFN:
        	addi $a0, $t2, 4
        	li $v0, 9 
        	syscall
        	move $t3, $v0
        	li $t8, 0 
        initFN:
          	beq $t8, $a0, link
          	sw $0, 0($t3)
          	addi $t3, $t3, 4
          	addi $t8, $t8, 4
          	j initFN
        link:
          	add $t3, $v0, $t2
          	sw $t4, 0($t3)
          	move $t4, $v0 
        	move $t3, $v0
        	addi $t8, $t7, 4 
        cString:
          	lb $t1, 0($t8) 
          	beqz $t1, endCTFN
          	sb $t1, 0($t3)
          	addi $t3, $t3, 1
          	addi $t8, $t8, 1
          	j cString  
      	endCTFN:
        	addi $t5, $t5, -1
      	backOne:
        	addi $t9, $t9, -4
        	j iterateBack   
    	finishedLL:
      	move $a0, $s5
      	lw $s1, 0($sp)
      	lw $s2, 4($sp)
      	lw $s3, 8($sp)
      	lw $s4, 12($sp)
      	lw $s5, 16($sp)
      	addi $sp, $sp, 20
      	jr $ra
endAndRestore:
  	lw $s1, 0($sp)
  	lw $s2, 4($sp)
  	lw $s3, 8($sp)
  	lw $s4, 12($sp)
  	lw $s5, 16($sp)
  	addi $sp, $sp, 20
end:
  	li $v0, -1
  	li $v1, -1
  	jr $ra
  
end2:
  	li $v0, -2
  	li $v1, -1
  	jr $ra
