.data
minimum_str:	.asciiz 		"minimum: "
new_line: 	.asciiz 		"\n"
negate_str: 	.asciiz 		"NEGATE"
even_start_str: .asciiz			"EVENS START"
even_end_str: 	.asciiz 		"EVENS END"
jan_str: 	.asciiz 		"jan: "
feb_str: 	.asciiz 		"feb: "
mar_str:	.asciiz 		"mar: "
apr_str: 	.asciiz 		"apr: "
may_str:	.asciiz 		"may: "
jun_str: 	.asciiz 		"jun: "
.text
.globl studentMain
studentMain:
	addiu $sp, $sp, -24 		# allocate stack space -- default of 24 here
	sw $fp, 0($sp) 			# save caller’s frame pointer
	sw $ra, 4($sp) 			# save return address
	addiu $fp, $sp, 20 		# setup main’s frame pointer

	la $s0, minimum 		# loads address s0 = minimum
	lw $s0, 0($s0)	 		# places minimum value in register s0 
	
	la $s1, negate 			# loads address s1 = negate
	lw $s1, 0($s1) 			# places negate value in register s1
	
	la $s2, evens	 		# loads address s2 = evens
	lw $s2, 0($s2) 			# places evens value in register s2
	
	la $s3, print 			# loads address s3 = print
	lw $s3, 0($s3) 			# places print value in register s3
	
	la $s4, jan 			# loads address s4 = jan
	lw $s4, 0($s4) 			# places jan value in register s4
	
	la $s5, feb 			# loads address s5 = feb
	lw $s5, 0($s5) 			# places feb value in register s5
	
	la $s6, mar 			# loads address s6 = mar
	lw $s6, 0($s6) 			# places mar value in register s6
	
	la $s7, apr 			# loads address s7 = apr
	lw $s7, 0($s7) 			# places apr value in register s7
	
	la $t8, may 			# loads address t8 = may
	lw $t8, 0($t8) 			# places may value in register t8
	
	la $t9, jun 			# loads address t9 = jun
	lw $t9, 0($t9) 			# places jun value in register t9
	
	# Initial minimum check
	beq $s0, $zero, FN_NEGATE 	# If minumum==0, go to negate
	j FN_MINIMUM
	
# if minimum == 1
# my_val = jan
# if feb < my_val
# 	my_val = feb
# if mar < my_val
#	my_val = mar
# if apr < my_val
#	my_val = apr
# if may < my_val
# 	my_val = may
# if jun < my_val
#	my_val = jun
# print my_val
# registers: 
# s0 = minimum
# s4 = jan
# s5 = feb
# s6 = mar
# s7 = apr
# t8 = may
# t9 = jun
# t0 = my_val

FN_MINIMUM:
	add $t0, $s4, $zero 			# t0 = my_val = jan
	FEB_PORT:
		slt $t1, $s5, $t0 		# if feb < my_val, if true t1 = 1
		bne $t1, $zero, FEB_BODY 	# if feb < my_val, jump to first port
		j MAR_PORT
		FEB_BODY:
			add $t0, $s5, $zero 	# t0 = my_val = feb
			j MAR_PORT
	MAR_PORT:
		slt $t1, $s6, $t0 		# if mar < my_val, if true t1 = 1
		bne $t1, $zero, MAR_BODY	# if mar < my_val, jump to second port
		j APR_PORT			# if not, jump to next port
		MAR_BODY:
			add $t0, $s6, $zero 	# t0 = my_val = mar
			j APR_PORT
	APR_PORT: 
		slt $t1, $s7, $t0 		# if apr < my_val, if true t1 = 1
		bne $t1, $zero, APR_BODY	# if apr < my_val, jump to third port
		j MAY_PORT			# if not, jump to next port
		APR_BODY: 
			add $t0, $s7, $zero 	# t0 = my_val = apr
			j MAY_PORT
	MAY_PORT:
		slt $t1, $t8, $t0 		# if may < my_val, if true t1 = 1
		bne $t1, $zero, MAY_BODY	# if may < my_val, jump to fourth port
		j JUN_PORT			# if not, jump to next port
		MAY_BODY: 
			add $t0, $t8, $zero 	# t0 = my_val = may
			j JUN_PORT
	JUN_PORT:
		slt $t1, $t9, $t0 		# if jun < my_val, if true t1 = 1
		bne $t1, $zero, JUN_BODY	# if jun < my_val, jump to fifth port
		j END_MINIMUM			# if not, end function
		JUN_BODY: 
			add $t0, $t9, $zero 	# t0 = my_val = jun
			j END_MINIMUM	
	END_MINIMUM:
		addi $v0, $zero, 4 		# printing string "minimum: "		
		la $a0, minimum_str
		syscall
		
		addi $v0, $zero, 1 		# printing integer my_val		
		add $a0, $zero, $t0
		syscall
		
		addi $v0, $zero, 4 		# printing string "\n"		
		la $a0, new_line
		syscall

# the negate function takes each variable value, negates it
# by subtracting the value from itself twice, then promptly
# places it back into its proper spot in memory	
# registers:
# s1 = negate
# s4 = jan
# s5 = feb
# s6 = mar
# s7 = apr
# t8 = may
# t9 = jun
# t2 = negated value
# t3 = stored value

FN_NEGATE: 
	beq $s1, $zero, FN_EVENS 		# Checks if negate variable == 0
	NEGATE_BODY:
		addi $t2, $s4, 0 		# set register t2 = jan
		sub $s4, $t2, $t2 		# jan = t2 - t2 (jan - jan)
		sub $s4, $s4, $t2 		# jan - t2 = - jan
		la $t3, jan 			# loads address of jan into t3
		sw $s4, 0($t3) 			# stores the negation of jan into jan			
	
		addi $t2, $s5, 0 		# set register t2 = feb
		sub $s5, $t2, $t2 		# feb = t2 - t2 (feb - feb)
		sub $s5, $s5, $t2 		# feb - t2 = - feb
		la $t3, feb 			# loads address of feb into t3
		sw $s5, 0($t3) 			# stores the negation of feb into feb
	
		addi $t2, $s6, 0 		# set register t2 = mar
		sub $s6, $t2, $t2 		# mar = t2 - t2 (mar - mar)
		sub $s6, $s6, $t2 		# mar - t2 = - mar
		la $t3, mar 			# loads address of mar into t3
		sw $s6, 0($t3) 			# stores the negation of mar into mar
	
		addi $t2, $s7, 0 		# set register t2 = apr
		sub $s7, $t2, $t2 		# apr = t2 - t2 (apr - apr)
		sub $s7, $s7, $t2 		# apr - t2 = - apr
		la $t3, apr 			# loads address of apr into t3
		sw $s7, 0($t3) 			# stores the negation of apr into apr	
	
		addi $t2, $t8, 0 		# set register t2 = may
		sub $t8, $t2, $t2 		# may = t2 - t2 (may - may)
		sub $t8, $t8, $t2 		# may - t2 = - may
		la $t3, may 			# loads address of may into t3
		sw $t8, 0($t3) 			# stores the negation of may into may
	
		addi $t2, $t9, 0 		# set register t2 = jun
		sub $t9, $t2, $t2 		# jun = t2 - t2 (jun - jun)
		sub $t9, $t9, $t2 		# jun - t2 = - jun
		la $t3, jun 			# loads address of jun into t3
		sw $t9, 0($t3) 			# stores the negation of jun into jun
		
		addi $v0, $zero, 4 		# printing string "NEGATE"		
		la $a0, negate_str
		syscall	
		
		addi $v0, $zero, 4 		# printing string "\n"		
		la $a0, new_line
		syscall

# evens function checks all variables, then prints out
# the even variables on a seperate line, skips over
# the odd variable values
# registers:
# s2 = evens
# s4 = jan
# s5 = feb
# s6 = mar
# s7 = apr
# t8 = may
# t9 = jun
# t2 = stores LSB

FN_EVENS:
	beq $s2, $zero, FN_PRINT		# Checks if evens variable == 0
	EVENS_BODY:
		addi $v0, $zero, 4 		# printing string "EVENS START"		
		la $a0, even_start_str
		syscall
		
		addi $v0, $zero, 4 		# printing string "\n"		
		la $a0, new_line
		syscall
		
	JAN_PRINT:
		andi $t2, $s4, 1 		# removes all bits except LSB, t2 = LSB
		bne $t2, $zero, FEB_PRINT	# if not even, skip to next check
		JAN_PRINT_BODY:
			addi $v0, $zero, 1 	# printing integer jan (if even)		
			add $a0, $zero, $s4
			syscall
		
			addi $v0, $zero, 4 	# printing string "\n"		
			la $a0, new_line
			syscall
	FEB_PRINT:
		andi $t2, $s5, 1 		# removes all bits except LSB, t2 = LSB
		bne $t2, $zero, MAR_PRINT	# if not even, skip to next check
		FEB_PRINT_BODY:
			addi $v0, $zero, 1 	# printing integer feb (if even)		
			add $a0, $zero, $s5
			syscall
		
			addi $v0, $zero, 4 	# printing string "\n"		
			la $a0, new_line
			syscall
	MAR_PRINT:
		andi $t2, $s6, 1 		# removes all bits except LSB, t2 = LSB
		bne $t2, $zero, APR_PRINT	# if not even, skip to next check
		MAR_PRINT_BODY:
			addi $v0, $zero, 1 	# printing integer mar (if even)		
			add $a0, $zero, $s6
			syscall
		
			addi $v0, $zero, 4 	# printing string "\n"		
			la $a0, new_line
			syscall
	APR_PRINT:
		andi $t2, $s7, 1 		# removes all bits except LSB, t2 = LSB
		bne $t2, $zero, MAY_PRINT	# if not even, skip to next check
		APR_PRINT_BODY:
			addi $v0, $zero, 1 	# printing integer apr (if even)		
			add $a0, $zero, $s7
			syscall
		
			addi $v0, $zero, 4 	# printing string "\n"		
			la $a0, new_line
			syscall
	MAY_PRINT:
		andi $t2, $t8, 1 		# removes all bits except LSB, t2 = LSB
		bne $t2, $zero, JUN_PRINT	# if not even, skip to next check
		MAY_PRINT_BODY:
			addi $v0, $zero, 1 	# printing integer may (if even)		
			add $a0, $zero, $t8
			syscall
		
			addi $v0, $zero, 4 	# printing string "\n"		
			la $a0, new_line
			syscall
	JUN_PRINT:
		andi $t2, $t9, 1 		# removes all bits except LSB, t2 = LSB
		bne $t2, $zero, END_EVENS	# if not even, skip to end function
		JUN_PRINT_BODY:
			addi $v0, $zero, 1 	# printing integer jun (if even)		
			add $a0, $zero, $t9
			syscall
		
			addi $v0, $zero, 4 	# printing string "\n"		
			la $a0, new_line
			syscall
	END_EVENS:
		addi $v0, $zero, 4 		# printing string "EVENS END"		
		la $a0, even_end_str
		syscall
		
		addi $v0, $zero, 4 		# printing string "\n"		
		la $a0, new_line
		syscall
		
# print is responsible for printing a string with the
# variable name, the value of the variable, and a new
# line seperating the results on each line
# registers:
# s3 = evens
# s4 = jan
# s5 = feb
# s6 = mar
# s7 = apr
# t8 = may
# t9 = jun

FN_PRINT:
	beq $s3, $zero, DONE			# Checks if evens variable == 0
	PRINT_BODY:
		addi $v0, $zero, 4 		# printing string "jan: "		
		la $a0, jan_str
		syscall
		
		addi $v0, $zero, 1 		# printing variable jan		
		add $a0, $zero, $s4
		syscall
		
		addi $v0, $zero, 4 		# printing string "\n"		
		la $a0, new_line
		syscall
		
		addi $v0, $zero, 4 		# printing string "feb: "		
		la $a0, feb_str
		syscall
		
		addi $v0, $zero, 1 		# printing variable feb		
		add $a0, $zero, $s5
		syscall
		
		addi $v0, $zero, 4 		# printing string "\n"		
		la $a0, new_line
		syscall
		
		addi $v0, $zero, 4 		# printing string "mar: "		
		la $a0, mar_str
		syscall
		
		addi $v0, $zero, 1 		# printing variable mar		
		add $a0, $zero, $s6
		syscall
		
		addi $v0, $zero, 4 		# printing string "\n"		
		la $a0, new_line
		syscall
		
		addi $v0, $zero, 4 		# printing string "apr: "		
		la $a0, apr_str
		syscall
		
		addi $v0, $zero, 1 		# printing variable apr		
		add $a0, $zero, $s7
		syscall
		
		addi $v0, $zero, 4 		# printing string "\n"		
		la $a0, new_line
		syscall
		
		addi $v0, $zero, 4 		# printing string "may: "		
		la $a0, may_str
		syscall
		
		addi $v0, $zero, 1 		# printing variable may		
		add $a0, $zero, $t8
		syscall
		
		addi $v0, $zero, 4 		# printing string "\n"		
		la $a0, new_line
		syscall
		
		addi $v0, $zero, 4 		# printing string "jun: "		
		la $a0, jun_str
		syscall
		
		addi $v0, $zero, 1 		# printing variable jun		
		add $a0, $zero, $t9
		syscall
		
		addi $v0, $zero, 4 		# printing string "\n"		
		la $a0, new_line
		syscall
		
DONE:
	lw $ra, 4($sp) 				# get return address from stack
	lw $fp, 0($sp) 				# restore the caller’s frame pointer
	addiu $sp, $sp, 24		 	# restore the caller’s stack pointer
	jr $ra 					# return to caller’s code
