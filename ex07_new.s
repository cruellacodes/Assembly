	.data
str1: .asciz "Enter an integer\n"
str2: .asciz "Final exit programm\n"
str3: .asciz "Exit of creating list\n"
str4: .asciz "Enter an integer to start printing\n"
str5: .asciz " "


	.text
	.globl main	
main:
	addi x17,x0,9
	addi x10,x10,8
	ecall		#create a dummy node
	
	add s0,x10,x0	#Head = dummy node
	add s1,x10,x0	#Tail = dummy node
	
	sw x0,0(x10)	#dummy node->data = 0
	sw x0,4(x10)	#dummy node->nxtPtr = 0
	
	addi x5,x0,1
	
	
	jal create_list
	
	jal scan_list
	
	j main
	
create_list:
	
	addi a7, x0, 4  #Enter an integer
	la a0, str1
	ecall
	
	addi sp, sp, -4  #save return address before calling the new function 
	sw ra, 0(sp)
	
	jal read_int
	
	lw ra, 0(sp)
	addi sp, sp, 4  #load the ra after returning function
	
	add x6,a0,x0 	#save in x6/t1 the value from a0 = input	
	blt x6,x5,exit_list	#if input<1 exit loop -> go to scan_list

	
	addi sp, sp, -4  #save return address before calling the new function 
	sw ra, 0(sp)
	
	jal node_alloc
	
	lw ra, 0(sp)
	addi sp, sp, 4  #load the ra after returning function
	
	sw x6,0(x10)	#node_data = x6
	sw x0,4(x10)	#node_nxtPtr = 0
	
	sw x10,4(s1)	#nxtPtr of last node = new node
	add s1,x0,x10	#tail = new node
	
	j create_list
	
exit_list:
	addi a7, x0, 4  #Exit of creating list
	la a0, str3
	ecall
	
	jr ra,0
	
scan_list:

	addi a7, x0, 4  #Enter an integer to start printing
	la a0, str4
	ecall

	addi sp, sp, -4  #save return address before calling the new function 
	sw ra, 0(sp)
	
	jal read_int
	
	lw ra, 0(sp)
	addi sp, sp, 4  #load the ra after returning function
	
	add s1,a0,x0	#s1 = new input
	blt s1,x0,final_exit	#if input<0 final exit programm
	
	
	lw x7,4(s0)
	#s2 = head -> next of list
	add s2,x0,x7
	
	addi sp, sp, -4  #save return address before calling the new function 
	sw ra, 0(sp)
	
	jal search_list
	
	lw ra, 0(sp)
	addi sp, sp, 4  #load the ra after returning function
	
	j scan_list
	

read_int: 
	addi x17,x0,5
	ecall		#read integer
	
	jr ra,0	#return
	
	
	
node_alloc:
	addi x17,x0,9
	addi x10,x10,8
	ecall		#create a new node
	
	jr ra,0
	
	
	
search_list:
	
	lw t2, 0(s2)  
	add a0, t2, x0
	
	addi sp, sp, -4  #save return address before calling the new function 
	sw ra, 0(sp)
	
	jal print_node
	
	lw ra, 0(sp)
	addi sp, sp, 4  #load the ra after returning function
	
	lw t6,4(s2)
	beq t6,x0,exit_loop2	#if nxtptr->s2 == 0 exit
	
	add s2,x0,t6	#s2 = nextptr -> s2
	
	j search_list
	
exit_loop2:
	jr ra,0
	
	
print_node:

	slt t4,a0,s1	#set t4 = 1 if data->node < input integer
	addi t5,x0,1
	beq a0,s1,exit_print  #if data->node = input integer -> exit_print
	beq t4,t5,exit_print	#if t4 == 1 exit printing
	
	addi	x17, x0, 1	#print data of node
	add	a0, x0, a0
	ecall
	
	addi a7, x0, 4  #Space 
	la a0, str5
	ecall

	jr ra,0
	
	
exit_print:
	jr ra,0
	
final_exit:
	addi a7, x0, 4  #Final exit programm
	la a0, str2
	ecall
	
	addi x17,x0,10	#exit call
	ecall
	
	
	
