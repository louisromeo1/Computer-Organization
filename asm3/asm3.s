# Louis Romeo
# CSC 252
# Fall 2023
# asm3.s
.data
 new_line: 		.asciiz 	"\n"
 space: 		.asciiz		" "
 collatz_str1:		.asciiz		"collatz("
 collatz_str2:		.asciiz		") completed after "
 collatz_str3:		.asciiz 	" calls to collatz_line()."
.text

.globl collatz_line

# int collatz_line(int val){
# 	if (val % 2 == 1){
#		printf("%d\n", val);
#		return val;
#	}
#	printf("%d", val);
#	int cur = val;
#	while (cur % 2 == 0){
#		cur /= 2;
#		printf(" %d", cur);
#	}
#	printf("\n");
# 	return cur;
# 	}
# registers:
# t7: t7 is used to store the original 'val' to be used later in the function
# t0: t0 is used to contain the result if t7 is even or odd(0 for even & 1 for odd)
# t1: t1 represents cur through the operations
# a0: a0 contains val

collatz_line:
	addiu $sp, $sp, -24 			# allocate stack space-- default of 24 here sw 
	sw $fp, 0($sp)    			# save caller?s frame pointer
	sw $ra, 4($sp)     			# save return address
	addiu $fp, $sp, 20 			# setup main?s frame pointer
	
	add $t7, $zero, $a0			# loading in parameter val in register t7
	
	andi $t0, $t7, 1			# t0 will be 0 if even, 1 if odd
	
	bne $t0, $zero, IF_ONE_CL		# compares value at t0 to 0, if( t0 != 0), jump
	j AFTER_IF_ONE_CL			# jumps to after the initial if stmt					
	
	IF_ONE_CL:
		addi $v0, $zero, 1 		# printing val	
		add $a0, $zero, $t7
		syscall
		
		addi $v0, $zero, 4 		# printing \n		
		la $a0, new_line
		syscall	
		
		add $v0, $zero, $t7		# return statement
		j CL_EPILOUGE			# jump to end function
	
	AFTER_IF_ONE_CL:
		addi $v0, $zero, 1 			# printing val	
		add $a0, $zero, $t7
		syscall
	
		add $t1, $zero, $t7			# cur == val
	
		#	while (cur % 2 == 0){
		#		cur /= 2;
		#		printf(" %d", cur);
		#	}
		# registers:
		# t0: t0 is used to contain the result if t1 is even or odd(0 for even & 1 for odd)
		# t1: t1 represents cur through the operations
		WHILE_CL_CHECK:
	
			andi $t0, $t1, 1		# t0 will be 0 if even, 1 if odd
		
			beq $t0, $zero, WHILE_CL	# checks to see that $t1 aka cur is even, if( t0 != 0), jump
			j AFTER_WHILE_CL		# code executed after while loop
		
		WHILE_CL:
			srl $t1, $t1, 1			# divides cur by 2
		
			addi $v0, $zero, 4 		# printing " "		
			la $a0, space
			syscall	
		
			addi $v0, $zero, 1 		# printing cur	
			add $a0, $zero, $t1
			syscall
		
			j WHILE_CL_CHECK		# jump back to the start of the loop
		
	
		AFTER_WHILE_CL:
	
			addi $v0, $zero, 4 		# printing \n		
			la $a0, new_line
			syscall	
		
			add $v0, $zero, $t1		# return statement, stores cur
			j CL_EPILOUGE	
			
	CL_EPILOUGE:
		lw $ra, 4($sp) 			# get return address from stack
		lw $fp, 0($sp) 			# restore the caller?s frame pointer
		addiu $sp, $sp, 24		# restore the caller?s stack pointer
		jr $ra 				# return to caller?s code
		
		
.globl collatz

# void collatz(int val){
#	int cur = val;
# 	int calls = 0;
#	cur = collatz_line(cur);
#	while (cur != 1){
#		cur = 3*cur+1;
#		cur = collatz_line(cur);
# 		calls++;
#	}
#	printf("collatz(%d) completed after %d calls to collatz_line().\n", val, calls);
# 	printf("\n");
#}
# registers:
# t3: t3 represents calls
# t8: t8 represents a register storing the original 'val' parameter passed into collatz
# t0: t0 represents cur
# t2: t2 stores one to perform the cur != 1 operation
# t1: t1 is used to store output while doing the 3*cur operation
# a0: the original 'val' for collatz and 'cur' when collatz_line is called.

collatz:
	addiu $sp, $sp, -24 		# allocate stack space-- default of 24 here sw 
	sw $fp, 0($sp)    		# save caller?s frame pointer
	sw $ra, 4($sp)     		# save return address
	addiu $fp, $sp, 20 		# setup main?s frame pointer
	
	add $t3, $zero, $zero		# t3 = calls = 0
	
	add $t0, $zero, $a0		# parameter in t0, cur == val
	add $t8, $zero, $a0		# t8= original val
	
	sw $a0, 8($sp)			# storing a0 as parameter
	sw $t3, 12($sp)			# saves t3
	sw $t8, 16($sp)			# store $t8 to store the original val
	jal collatz_line		# jump to collatz_line
	lw $t8, 16($sp)			# loads $t8 to store the original val
	lw $t3, 12($sp)			# loads t3 back in
	lw $a0, 8($sp)			# loads parameter
	add $t0, $zero, $v0		# cur = collatz_line(cur) 
	
	#	while (cur != 1){
	#		cur = 3*cur+1;
	#		cur = collatz_line(cur);
	# 		calls++;
	#	}
	# registers:
	# t0: t0 represents cur
	# t3: t3 represents calls
	# t8: t8 represents a register storing the original 'val' parameter passed into collatz
	# t2: t2 stores one to perform the cur != 1 operation
	# t1: t1 is used to store output while doing the 3*cur operation
	# a0:  'cur' when collatz_line is called.
	COLLATZ_WHILE_CHECK:
		
		addi $t2, $zero, 1			# t2 == 1
		bne $t0, $t2, COLLATZ_WHILE		#true: cur !=1 jump into loop
		j AFTER_WHILE_COLLATZ			#go to the print stmts after the loop
				
		COLLATZ_WHILE:
		
			add $t1, $t0, $t0		# add t0 to t1 # cur = cur + cur >> (cur * 2)
			
			
			add $t0, $t1, $t0		# add t0 to t0 # cur = (cur * 2) + cur
			
			addi $t0, $t0, 1		# cur = 3 * cur + 1
			
			sw $t8, 20($sp)			# store $t8 to store the original val
			sw $a0, 16($sp)			# store val
			sw $t3, 12($sp)			# store calls
			sw $t0, 8($sp)			# store cur
			
			add $a0, $zero, $t0		# places cur in a0 (parameter)
			
			jal collatz_line		# jump to collatz_line
			lw $t0, 8($sp)			# load cur value to $t0
			lw $t3, 12($sp)			# load calls value to $t3
			lw $a0, 16($sp)			# load original val value to $a0
			lw $t8, 20($sp)			# store $t8 to store the original val
			
			add $t0, $zero, $v0		# cur = collatz_line(cur) # v0 might get erased in cl_epilouge
			addi $t3, $t3, 1		# calls++
			j COLLATZ_WHILE_CHECK		# jump back up to the start of the loop
	
	AFTER_WHILE_COLLATZ:
		
		addi $v0, $zero, 4 			# printing collatz_str1 >> "collatz("	
		la $a0, collatz_str1
		syscall
		
		addi $v0, $zero, 1 			# printing val	
		add $a0, $zero, $t8
		syscall
		
		addi $v0, $zero, 4 			# printing collatz_str2 >> ") completed after "		
		la $a0, collatz_str2
		syscall
		
		addi $v0, $zero, 1 			# printing calls	
		add $a0, $zero, $t3
		syscall
		
		addi $v0, $zero, 4 			# printing collatz_str3 >> " calls to collatz_line()."	
		la $a0, collatz_str3
		syscall
		
		addi $v0, $zero, 4 			# printing \n		
		la $a0, new_line
		syscall
		
		addi $v0, $zero, 4 			# printing \n		
		la $a0, new_line
		syscall
		
		j COLLATZ_END				# jump to the function's epilogue
		
	COLLATZ_END:

		lw $ra, 4($sp) 		# get return address from stack
		lw $fp, 0($sp) 		# restore the caller?s frame pointer
		addiu $sp, $sp, 24	# restore the caller?s stack pointer
		jr $ra 			# return to caller?s code
		
		
		
	
		
.globl percentSearch
#void percentSearch(Str in)
#{
#	int index = 0
#
#	while(in[index] != '\0'){
#	
#		if(in[index] == '%'){
#			return index
#		}
#		index ++
#	}
#	return -1
#}
# registers:
# t0: t0 represents in
# t3: t3 represents index
# t1: t1 represents the '%' symbol for comparisons
# t5: t5 represents the spot in the string to get the next character
# t2: t2 represents loading up the actual value of in[index]
# t6: t6 represents a register equalling -1 and returning it.
# t4: t4 represents the null terminator for the loop check
percentSearch:

	addiu $sp, $sp, -24 			# allocate stack space-- default of 24 here sw 
	sw $fp, 0($sp)    			# save caller?s frame pointer
	sw $ra, 4($sp)     			# save return address
	addiu $fp, $sp, 20 			# setup main?s frame pointer
	
	add $t0, $zero, $a0			# sets t0 == in
	add $t3, $zero, $zero			# index == 0
	
	
	#	while(in[index] != '\0'){
	#	
	#		if(in[index] == '%'){
	#			return index
	#		}
	#		index ++
	#	}
	# registers:
	# t0: t0 represents in
	# t3: t3 represents index
	# t1: t1 represents the '%' symbol for comparisons
	# t5: t5 represents the spot in the string to get the next character
	# t2: t2 represents loading up the actual value of in[index]
	# t6: t6 represents a register equalling -1 and returning it.
	# t4: t4 represents the null terminator for the loop check
	PS_LOOP_CHECK:
	
		ori $t1, $zero, 0x25		# t1 == "%"
		add $t5, $t0, $t3		# spot of in[index]
		lb $t2, 0($t5)			# t2 = in[index]
		
		
		ori $t4, $zero, 0x00		# t4 == '\0'
		beq $t1, $t2, PS_PASS		# current character == "%", go into if stmt
		beq $t2, $t4, PS_FAIL		# current character == '\0', go to end of the function
		j PS_LOOP			# go to the body of the loop
		
		PS_LOOP:
			addi $t3, $t3, 1	# index++
			j PS_LOOP_CHECK
			
		PS_PASS:
			add $v0, $zero, $t3 	# return index of %
			j PS_EPILOUGE
			
		PS_FAIL:
			addi $t6, $zero, -1	# t6 == -1
			add $v0, $zero, $t6	# return -1
			j PS_EPILOUGE
			
	PS_EPILOUGE:	
	
		lw $ra, 4($sp) 		# get return address from stack
		lw $fp, 0($sp) 		# restore the caller?s frame pointer
		addiu $sp, $sp, 24	# restore the caller?s stack pointer
		jr $ra 			# return to caller?s code

.globl letterTree

# int letterTree(int step){
#	int count = 0;
#	int pos = 0;
#	while (1){
#		char c = getNextLetter(pos);
#		if (c == ’\0’)
#			break
#		for (int i=0; i<=count; i++){
#			printf("%c", c);
#		}
#		printf("\n");
#		count++;
#		pos += step;
#	}
#	return pos
#}
# registers:
# t7: t7 represents the value of the parameter step
# t8: t8 represents count
# t9: t9 represents pos 
# t0: t0 represents the return c from getNextLetter(pos)
# t1: t1 represents i for the inner for loop
# t4: t4 represents '\0' for the if stmt check in the while loop
# t2: t2 represents output for i<=count check for the inner for loop
letterTree:

	addiu $sp, $sp, -24 				# allocate stack space-- default of 24 here sw 
	sw $fp, 0($sp)    				# save caller?s frame pointer
	sw $ra, 4($sp)     				# save return address
	addiu $fp, $sp, 20 				# setup main?s frame pointer
	
	add $t7, $zero, $a0				# loading in parameter step in register t7
	addi $t8, $zero, 0				# t8 = count == 0
	addi $t9, $zero, 0				# t9 = pos == 0
	
	#	while (1){
	#		char c = getNextLetter(pos);
	#		if (c == ’\0’)
	#			break
	#		for (int i=0; i<=count; i++){
	#			printf("%c", c);
	#		}
	#		printf("\n");
	#		count++;
	#		pos += step;
	#	}
	# registers:
	# t7: t7 represents the value of the parameter step
	# t8: t8 represents count
	# t9: t9 represents pos 
	# t0: t0 represents the return c from getNextLetter(pos)
	# t1: t1 represents i for the inner for loop
	# t4: t4 represents '\0' for the if stmt check in the while loop
	# t2: t2 represents output for i<=count check for the inner for loop
	LT_WHILE_LOOP:
	
		add $a0, $zero, $t9			# add pos to a0 to pass a parameter for getNextLetter(pos)
		sw $t7, 8($sp)				# store step
		sw $t8, 12($sp)				# store count
		sw $t9, 16($sp)				# store pos
		jal getNextLetter			# jump to getNextLetter
		lw $t7, 8($sp)				# load step to t7
		lw $t8, 12($sp)				# load count to t8
		lw $t9, 16($sp)				# load pos to t9
			
		add $t0, $zero, $v0			# t0 == c from getNextLetter(pos)
		addi $t1, $zero, 0			# t1 = i == 0
		ori $t4, $zero, 0x00			# t4 == /0
		beq $t4, $t0, LT_EPILOUGE		# c == /0, break
		j LT_FOR_ONE_CHECK			# jump to inner for loop
		
		#for (int i=0; i<=count; i++){
		#	printf("%c", c);
		#}
		# registers:
		# t2: t2 represents output for i<=count check for the inner for loop
		# t0: t0 represents the return c from getNextLetter(pos)
		# t1: t1 represents i for the inner for loop
		# t8: t8 represents count
		LT_FOR_ONE_CHECK:
			slt $t2, $t8, $t1		# if count < index, the opposite of i<=count
			beq $t2, $zero, LT_FOR_ONE	# if the opposite is falce then i<=count is true
			j LT_AFTER_FOR
			LT_FOR_ONE:
				addi $v0, $zero, 11 	# printing c	
				add $a0, $zero, $t0
				syscall
				
				addi $t1, $t1, 1	#i++
				
				j LT_FOR_ONE_CHECK
		LT_AFTER_FOR:
		
			addi $v0, $zero, 4 		# printing \n		
			la $a0, new_line
			syscall
			
			addi $t8, $t8, 1		# count++
			add $t9, $t9, $t7		# pos += step
			j LT_WHILE_LOOP
	LT_EPILOUGE:
	
		add $v0, $zero, $t9			# return pos
		lw $ra, 4($sp) 				# get return address from stack
		lw $fp, 0($sp) 				# restore the caller?s frame pointer
		addiu $sp, $sp, 24			# restore the caller?s stack pointer
		jr $ra 					# return to caller?s code
