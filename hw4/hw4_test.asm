############################ CHANGE THIS FILE AS YOU DEEM FIT ############################
############################ Add more names if needed ####################################

.data

Name1: .asciiz "Jane"
Name2: .asciiz "Joey"
Name3: .asciiz "Alit"
Name4: .asciiz "Veen"
Name5: .asciiz "Stan"
Name6: .asciiz "Billy"
Name7: .asciiz "Andrew"
Name8: .asciiz "Dave"
Name9: .asciiz "Joshua"
I: .word 10
J: .word 20

network_created: .asciiz "Network successfully created"
network_createdf: .asciiz "Error occured when creating Network"
person_added: .asciiz "Person has been successfully added"
person_addedf: .asciiz "Error occured when adding a Person"
person_found: .asciiz "Person has been successfully found"
person_foundf: .asciiz "Error occured when finding a Person"
relation_added: .asciiz "Relation has been successfully added"
relation_addedf: .asciiz "Error occured when adding Relation"
distant_friend1: .asciiz "Distant friends have been found"
distant_friend2: .asciiz "Person does not exist in the network"
distant_friend3: .asciiz "Person does not have any distant friends"
space: .asciiz "\n"

.text
main:
    lw $a0, I
    lw $a1, J
    jal create_network
    add $s0, $v0, $0		# network address in heap
    jal network_msg
    
    add $a0, $0, $s0		# pass network address to add_person
    la $a1, Name1
    jal add_person
    jal add_person_msg
    
    add $a0, $0, $s0		# pass network address to add_person
    la $a1, Name2
    jal add_person
    jal add_person_msg
    
    add $a0, $0, $s0		# pass network address to add_person
    la $a1, Name3
    jal add_person
    jal add_person_msg
    
    add $a0, $0, $s0		# pass network address to add_person
    la $a1, Name4
    jal add_person
    jal add_person_msg
    
    #add $a0, $0, $s0		# pass network address to add_person
    #la $a1, Name5
    #jal add_person
    #jal add_person_msg
    
    #add $a0, $0, $s0		# pass network address to add_person
    #la $a1, Name6
    #jal add_person
    #jal add_person_msg
    
    #add $a0, $0, $s0		# pass network address to add_person
    #la $a1, Name7
    #jal add_person
    #jal add_person_msg
    
    #add $a0, $0, $s0           # pass network address to add_person
    #la $a1, Name8
    #jal add_person
    #jal add_person_msg
    
    #add $a0, $0, $s0           # pass network address to add_person
    #la $a1, Name9
    #jal add_person
    #jal add_person_msg
    
    add $a0, $0, $s0
    la $a1, Name2
    la $a2, Name1
    li $a3, 3
    jal add_relation
    jal add_relation_msg
    
    add $a0, $0, $s0
    la $a1, Name3
    la $a2, Name1
    li $a3, 0
    jal add_relation
    jal add_relation_msg
    
    add $a0, $0, $s0
    la $a1, Name4
    la $a2, Name1
    li $a3, 1
    jal add_relation
    jal add_relation_msg
    
    add $a0, $0, $s0
    la $a1, Name2
    la $a2, Name4
    li $a3, 1
    jal add_relation
    jal add_relation_msg
    
    add $a0, $0, $s0
    la $a1, Name3
    la $a2, Name4
    li $a3, 1
    jal add_relation
    jal add_relation_msg
    #write test code

exit:
    li $v0, 10
    syscall
.include "hw4.asm"

network_msg:
    li $t0, -1
    beq $v0, $t0, network_failed
    la $a0, network_created
    j network_print
    network_failed:
    la $a0, network_createdf
    network_print:
    li $v0, 4
    syscall
    la $a0, space
    syscall
    jr $ra
    
add_person_msg:
    li $t0, -1
    beq $v0, $t0, adding_failed
    la $a0, person_added
    j added_print
    adding_failed:
    la $a0, person_addedf
    added_print:
    li $v0, 4
    syscall
    la $a0, space
    syscall
    jr $ra

get_person_msg:
    li $t0, -1
    beq $v0, $t0, finding_failed
    la $a0, person_found
    j found_print
    finding_failed:
    la $a0, person_foundf
    found_print:
    li $v0, 4
    syscall
    la $a0, space
    syscall
    jr $ra

add_relation_msg:
    li $t0, -1
    beq $v0, $t0, radding_failed
    la $a0, relation_added
    j radded_print
    radding_failed:
    la $a0, relation_addedf
    radded_print:
    li $v0, 4
    syscall
    la $a0, space
    syscall
    jr $ra

distant_friends_msg:
    li $t0, -1
    beq $v0, $t0, no_distant_friend
    li $t0, -2
    beq $v0, $t0, doesnt_exist
    la $a0, distant_friend1
    distant_friends_msg_return:
    li $v0, 4
    syscall
    la $a0, space
    syscall
    jr $ra
doesnt_exist:
    la $a0, distant_friend2
    j distant_friends_msg_return
no_distant_friend:
    la $a0, distant_friend3
    j distant_friends_msg_return
