.data
new_line: 		.asciiz 	"\n"
printInts_start1:	.asciiz		"printInts: About to print " 
printInts_end1:		.asciiz		" elements.\n"
printInts_start2: 	.asciiz 	"printInts: About to print an unknown number of elements. " "Will stop at a zero element.\n"
printWords_start: 	.asciiz		"printWords: There were " 
printWords_end:		.asciiz		" words.\n"
bubbleSort_str:		.asciiz		"Swap at:  "

.text
.globl studentMain 
studentMain: 

	addiu $sp, $sp, -24 	# allocate stack space-- default of 24 here sw 
	sw $fp, 0($sp)    	# save caller?s frame pointer
	sw $ra, 4($sp)     	# save return address
	addiu $fp, $sp, 20 	# setup main?s frame pointer
	
	la $s1, printWords 	# s1 = printWords
	lb $s1, 0($s1)
	
	la $s2, bubbleSort	# s2 = bubbleSort
	lb $s2, 0($s2)
	
	la $s0, printInts  	# s0 = printInts
	lb $s0, 0($s0) 
	
	la $s3, printInts_howToFindLen 	# s3 = length of array
	lh $s3, 0($s3)
	
	la $s4, intsArray	# s4 = intsArray
	
	la $s5, intsArray_len 	# s5 = intsArray_len
	lw $s5, 0($s5)
	
	la $s6, intsArray_END 	# s6 = intsArray_END

	bne $s0, $zero, TASK2 	# If printInts == 0, jump to next task
	j TASK1		# TASK1, s0

	# if(printInts_howToFindLen != 2)
	#	int count;
	#	if(printInts_howToFindLen == 0)
	# 		count = intsArray_len;
	# 	else
	#		count = intsArray_END - intsArray; // divide by 4
	#	printf("printInts: About to print " " elements.\n", count);
	#	for (int i = 0; i < count; i++)
	#		printf("\n", intsArray[i]);
	# else
	#	int *cur = intsArray;
	# 	printf("printInts: About to print an unknown number of elements. " "Will stop at a zero element.\n");
	#	while (*cur != 0)
	#		printf("%d\n", *cur);
	# 		cur++;
	#
	# registers:
	# s0 = printInts
	# s3 = printInts_howToFindLen
	
TASK1:
	addi $t9, $t9, 2		# t9 = 2
	beq $s3, $t9, ELSE_INT_ONE
	addi $t1, $zero, 0		# t1 = count
	bne $s3, $zero, ELSE_INT_TWO
	add $t1, $s4, $zero
	j IF_INT_ONE
	
	ELSE_INT_ONE:
		la $s4, intsArray  	# int cur = intsArray
		add $t2, $t2, $zero	# t2 represents cur pointer
		
		addi $v0, $zero, 4 	# printing string		
		la $a0, printInts_start2
		syscall
		
		WHILE_FLAG:
			add $t4, $zero, $t2 			# t2 = cur
			sll $t4, $t4, 2				# cur*4
			add $t5, $s4, $t4			# address of intsArray[cur]
			lw $t4, 0($s4)
			bne $s4, $zero, WHILE_INT
			j TASK2 			# TASK2
			WHILE_INT:
				addi $v0, $zero, 1 	# printing intsArray[i]		
				add $a0, $zero, $t4
				syscall
				
				addi $v0, $zero, 4 	# printing \n		
				la $a0, new_line
				syscall	
				addi $t2, $t2, 1	# cur++
				#addi $s4, $s4, 4 	# moves address by 4 to print next element
				j WHILE_FLAG
	ELSE_INT_TWO:
		sub $t1, $s6, $s4 	# places value of intsArray_END - intsArray into register t1 (count variable)
		sra $t1, $t1, 2		# shifts right into register t2, divides by 4
		j IF_INT_ONE
		
	IF_INT_ONE:
		addi $v0, $zero, 4 	# printing string		
		la $a0, printInts_start1
		syscall
		
		addi $v0, $zero, 1 	# printing integer 		
		add $a0, $zero, $t1
		syscall
		
		addi $v0, $zero, 4 	# printing string		
		la $a0, printInts_end1
		syscall	
		
		FOR_INT_ONE:
			addi $t2, $zero, 0				# t2 = i
			FOR_INT_FLAG:
				slt $t3, $t2, $t1 			# if(i < count) == 1
				bne $t3, $zero, FOR_INT_ONE_BODY	# if != 0, should go into loop
				j ELSE_INT_ONE
				FOR_INT_ONE_BODY:
					add $t4, $zero, $t2 			# t2 = i
					sll $t4, $t4, 2				# i*4
					add $t5, $s4, $t4			# address of intsArray[i]
				
					lw $t4, 0($t5)			# value of intsArrat[i]
				
					addi $v0, $zero, 1 	# printing intsArray[i]		
					add $a0, $zero, $t4
					syscall
				
					addi $v0, $zero, 4 	# printing \n		
					la $a0, new_line
					syscall	
				
					addi $s4, $s4, 4 	# moves address by 4 to print next element
					addi $t2, $t2, 1	# i++
					j FOR_INT_FLAG
					
	
	

	# char *start = theString;
	# char *cur = start;
	# int count = 1;
	# while(cur != 0)
	#	if(cur == " ")
	#		cur == /0;
	#		count++;
	#	cur++;
	# printf("printWords: There were " " words.\n", count);
	# while(cur >= start)
	#	if (cur == start || cur[-1] == /0)
	#		print("\n", cur);
	#	cur--;
	#
	# registers:
	# s1 = printWords
	# 
	
TASK2:
	beq $s1, $zero, TASK3 # TASK3 	# If printWords == 0, jump to next task
	j PRINT_WORDS_BODY
	PRINT_WORDS_BODY:
		
		la $s7, theString	# char start = theString
		la $t6, theString	# char start = theString
		lb $t0, 0($t6)		# char cur = start
		addi $t1, $zero, 1	# int count = 1
		
		WHILE_FLAG_WORDS:
			ori $t5, $zero, 0x00			# t5 == /0
			bne $t0, $t5, WHILE_BODY_WORDS		# if cur != /0
			j PRINT_WORDS_BODY_CONT
			WHILE_BODY_WORDS:
			
				ori $t4, $zero, 0x20
				beq $t0, $t4, IF_WORDS_ONE 
				j IF_WORDS_ONE_ELSE
				IF_WORDS_ONE:
					sb $t5, 0($t6) 		# cur == /0
					addi $t1, $t1, 1	# count++
					j IF_WORDS_ONE_ELSE
				IF_WORDS_ONE_ELSE:
					addi $t6, $t6, 1 	# cur++
					lb $t0, 0($t6)	
					j WHILE_FLAG_WORDS
		PRINT_WORDS_BODY_CONT:
			addi $v0, $zero, 4 	# printing string		
			la $a0, printWords_start
			syscall
			
			addi $v0, $zero, 1 	# printing integer 		
			add $a0, $zero, $t1
			syscall
			
			addi $v0, $zero, 4 	# printing string		
			la $a0, printWords_end
			syscall
			#addi $t6, $t6, -1	# cur--
			WHILE_FLAG_WORDS_TWO:
				slt $t8, $t6, $s7	# t8 == 1 if cur < start
				beq $t8, $zero, WHILE_BODY_WORDS_TWO
				j TASK3 # TASK3
				WHILE_BODY_WORDS_TWO:
					lb $t9, 0($s7)			# start == t9
					lb $t2, 0($t6)			# cur == t2
					
					beq $t9, $t2, IF_WORDS_TWO	# if(start == cur)
					addi $t4, $t6, -1		# cur[-1]
					lb $t4, 0($t4)			# 
					ori $t5, $zero, 0x00		# t5 == /0
					beq $t4, $t5, IF_WORDS_TWO	# if(cur[-1] == /0)
					j PRINT_WORDS_ELSE_TWO
					IF_WORDS_TWO:
						lb $t2, 0($t6)		# %s POSSIBLE ERROR IF STRING NOT CHAR
						
						addi	$v0, $zero, 4		#print_char() -> lr
						add	$a0, $zero, $t6		#   	$a0, ($t4)
						syscall
						
						addi $v0, $zero, 4 	# printing \n		
						la $a0, new_line
						syscall
						j PRINT_WORDS_ELSE_TWO
					PRINT_WORDS_ELSE_TWO:
						addi $t6, $t6, -1	# cur--
						j WHILE_FLAG_WORDS_TWO
					
						
	# for(int i = 0; i < intsArray_len; i ++)
	#	for(int j = 0; j < ints_Arraylen - 1; j++)
	#		if(intsArray[j] > intsArray[j + 1];
	#			printf("Swap at: "\n", j);
	#			int tmp = intsArray[j];
	#			intsArray[j] = intsArray[j+1];
	#			intsArray[j+1] = tmp;
	#
	# registers:
	# s2 = bubbleSort
	#
	
TASK3:
	beq $s0, $zero, DONE 					# if printInts == 0, jump to next task
	add $t0, $t0, $zero					# int i = 0
	la $s4, intsArray					# s4 = address of start of intsArray
	SORT_FLAG:
		slt $t1, $t0, $s5				# i < intsArray_len
		bne $t1, $zero, SORT_FOR_TWO			# run loop when i < intsArray_len
		j DONE
		SORT_FOR_ONE:
			add $t2, $t2, $zero 			# int j = 0
			SORT_FLAG_ONE:
				addi $t3, $s5, -1		# intsArray_len - 1
				slt $t4, $t0, $t3		# j < intsArray_len - 1
				beq $t4, $zero, SORT_I_INC 	#
				j SORT_FOR_TWO
				SORT_I_INC:
					addi $t0, $t0, 1	# i++
					j SORT_FLAG
		SORT_FOR_TWO:
			add $t4, $zero, $t2 			# t4 == j
			sll $t4, $t4, 2				# multiplying t4 * 4
			add $t5, $s4, $t4			# intsArray[j + 1]
			addi $t5, $t5, 4			# t5 = intsArray[j + 1]
			lw $t6, 0($t4)				# loads element at t6 ([j])
			lw $t7, 0($t5)				# loads elements at t7 ([j + 1])
			slt $t8, $t7, $t6			# if(intsArray[j] > intsArray[j + 1])
			beq $t8, $zero, SORT_J_INC
			j SORT_IF_ONE
			SORT_IF_ONE:
				addi $v0, $zero, 4 	# printing \n		
				la $a0, bubbleSort_str
				syscall	
				
				addi $v0, $zero, 1 	# printing integer 		
				add $a0, $zero, $t2
				syscall
				
				addi $v0, $zero, 4 	# printing string		
				la $a0, new_line
				syscall
				
				add $t9, $zero, $t6 		# t9 == tmp
				sw $t7, 0($t4)			# intsArray[j] == intsArray[j + 1]
				sw $t9, 0($t5)			# intsArray[j + 1] == tmp
				j SORT_J_INC
				SORT_J_INC:
					addi $t2, $t2, 1	# j++
					j SORT_FLAG_ONE		
		
		
						
DONE:	
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the caller?s frame pointer
	addiu $sp, $sp, 24	# restore the caller?s stack pointer
	jr $ra 			# return to caller?s code
	
