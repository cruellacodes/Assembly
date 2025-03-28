	.data
str_input:	.asciz "Enter an integer\n"
str_eol:	.asciz "This is the end of list\n"
str_eop:	.asciz "Integer lower/equal than/to 0 entered, will terminate...\n"
str_nl:		.asciz "\n"


		.text
		.globl main
main:
		addi a7, zero, 9	 #memory allocation
		addi a0, zero, 8  #8 bytes allocated to build node
		ecall
	
		sw zero, 0(a0)  #dummy node, 0 data
		sw zero, 4(a0)  #dummy node, null nextPtr	

		add s0, a0, zero  #head
		add s1, a0, zero  #tail

# What can we say right here for the liveness of our already used registers???

		jal l_mk

		jal l_scn
		
		j main


l_mk:
		addi a7, zero, 4  #ask for an integer
		la a0, str_input
		ecall

		addi sp, sp, -4  #caller saved -- why we save this??? 
		sw ra, 0(sp)
	
		jal read_int  #jump and link read_int routine

		lw ra, 0(sp)
		addi sp, sp, 4  #restore

		add t0, a0, zero  #place value to t0

		#maybe we branch here
		beq t0, zero, l_eol  #if t0=0 branch to l_eol
		slt t1, t0, zero
		bne t1, zero, l_eol  #if t0<0 branch l_eol

		addi sp, sp, -4  #caller saved
		sw ra, 0(sp)

		jal node_alloc  #jump and link node_alloc routine

		lw ra, 0(sp)
		addi sp, sp, 4

		#addi a7, zero, 9  #memory allocation
		#addi a0, zero, 8  #8 bytes allocated to build node
		#ecall

		sw t0, 0(a0)  #given integer -> data
		sw zero, 4(a0)  #null nextPtr
		sw a0, 4(s1)  #link the list

		add s1, a0, zero  #new addr on s1

		j l_mk

l_eol:
		#sw zero, 4(s1)  #set the ptr of the last int to 0

		addi a7, zero, 4  #set the ptr of the str to eol
		la a0, str_eol
		ecall

		# where we will return???
		jr ra, 0

l_scn:
		addi a7, zero, 4  #ask for an integer
		la a0, str_input
		ecall
		
		addi a7, zero, 5  #read an integer from the console
		ecall

		add s1, a0, zero

		slt t0, s1, zero  #if integer < 0
		bne t0, zero, prog_end

		add s2, s0, zero  #s0 = s2 for scan loop
		lw s2, 4(s2)  #pass the dummy node

		addi sp, sp, -4  #caller saved
		sw ra, 0(sp)

		jal search_list  #jump and link search_list routine

		lw ra, 0(sp)
		addi sp, sp, 4

		j l_scn 
		
search_list:
		lw t2, 0(s2)  #the number of node passed to t1
		add a0, t2, zero

		addi sp,sp, -4  #called saved
		sw ra, 0(sp)

		jal print_node  #jump and link print_node routine

		lw ra, 0(sp)
		addi sp, sp, 4

		addi a7, zero, 4
		la a0, str_nl
		ecall

last_node:
		lw s3, 4(s2)  #addr of next ptr
		lw t4, 4(s3)
		beq t4, zero, p_l
		
		add s2, s3, zero

		j search_list

		
p_l:
		lw t0, 0(s3)  #print last integer of the list
		
		slt t1, s1, t0
		beq t1, zero, j_31

		addi a7, zero, 1  #print integer
		add a0, t0, zero
		ecall

		addi a7, zero, 4
		la a0, str_nl
		ecall

j_31:
		jr ra, 0

prog_end:
		addi a7, zero, 4  #print eop
		la a0, str_eop
		ecall

		addi a7, zero, 10  #exit the program
		ecall

read_int:
		addi a7, zero, 5  #read an integer from the console
		ecall	

		jr ra, 0 

node_alloc:
		addi a7, zero, 9  #memory allocation
		addi a0, a0, 8  #8 byte allocated to build node
		ecall

		jr ra, 0

	
print_node:
		#slt t3, a0, s1  #check if s1 > t1
		slt t3, s1, a0  #a0, s1
		beq t3, zero, s_p  #there's not jal and ptr has to +4

		addi a7, zero, 1  #print integer
		add a0, a0, zero
		ecall

		jr ra, 0


s_p:
		lw ra, 0(sp)
		addi sp, sp, 4
		
		j last_node
