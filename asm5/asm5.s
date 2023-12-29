# Louis Romeo
# CSC 252
# asm5.s
# 11/10/2023

.data
dashes:   	.asciiz "----------------\n"
newline: 	.asciiz "\n"
otherStr: 	.asciiz "<other>: "
colon:    	.asciiz ": "
	
.text
.globl countLetters
# void countLetters(char *str) 
#         int letters[26]; 
#         int other = 0; // this function must fill these with zeroes 
#         printf("----------------\n%s\n----------------\n", str); 
#         char *cur = str; 
#         while (*cur != ?\0?) 
#             if (*cur >= ?a? && *cur <= ?z?) 
#                 letters[*cur-?a?]++; 
#             else if (*cur >= ?A? && *cur <= ?Z?) 
#                 letters[*cur-?A?]++; 
#             else 
#                 other++;      
#             cur++; 
#
#         for (int i=0; i<26; i++) 
#	             printf("%c: %d\n", ?a?+i, letters[i]); 
#         printf("<other>: %d\n", other); 
#
# registers:
# s0 = other
# s1 = cur
# s2 = pointer to str
# s3 = address of letters
# t0
# t1
# t2
# t3
# t4
# t5
# t6
# t7
countLetters:
	addiu $sp, $sp, -24			# standard prolouge 
	sw $fp, 0($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 20
	
	# make space for the array of ints, letters[26] and set their values to 0
	addiu $sp, $sp, -16			# save the s registers
	sw   $s0, 0($sp)
	sw   $s1, 4($sp)
	sw   $s2, 8($sp)
	sw   $s3, 12($sp)
	
	addiu $sp, $sp, -108
	addi  $s0, $zero, 0			# other = 0
	addi  $s1, $a0, 0			# cur = pointer to str
	addi  $s2, $a0, 0			# s2 = pointer to str
	
	addi  $s3, $sp, 0			# s3 = address of letters[0]
	addi  $s3, $s3, 104
	
	addi  $t0, $zero, 0			# t0 = i = 0
	
	initLetters:
		slti $t1, $t0, 26			# t1 = i < 26
	
		beq  $t1, $zero, afterInitialize
		sw   $zero, 0($s3)			# letters[i] = 0
		addi $s3, $s3, -4
		addi $t0, $t0, 1			# i++
		j initLetters
	
	afterInitialize:
		addi $s3, $sp, 104			# s3 = *letters[0]
	
		addi $v0, $zero, 4			# print a line of dashes
		la   $a0, dashes
		syscall
	
		# Print each character in the string str
		addi $t0, $zero, 0			# t0 = i = 0
	
	checkPrint:
		add  $t1, $s2, $t0			# t1 = address of str + i
		lb   $a0, 0($t1)			# a0 = str[i]
	
		beq $a0, $zero, afterPrintStr
	
		addi $v0, $zero, 11			# the value of str[i] has already been loaded into a0
		syscall					# print str[i]
	
		addi $t0, $t0, 1			# i++
		j checkPrint
	
	afterPrintStr:
		addi $v0, $zero, 4			# print a newline character
		la   $a0, newline
		syscall
	
		addi $v0, $zero, 4			# print a line of dashes	
		la   $a0, dashes
		syscall
	
		# while loop to iterate over str and count occurences of each character
		addi $t0, $zero, 0			# t0 = i = 0
		addi $t3, $zero, 'z'			# t3 = z
		addi $t4, $zero, 'Z'			# t3 = Z
		addi $t6, $zero, 'a'
		addi $t7, $zero, 'A'
	
	whileBody:
		lb   $t1, 0($s1)			# t1 = char of str
		beq $t1, $zero, afterWhile		# if str null terminator is found branch
	
		# if statement
		slti $t2, $t1, 'a'			# t2 = str[i] < 'a'
		bne  $t2, $zero, whileElseIf		# if true the condition is not met and we can branch
	
		slt $t2, $t3, $t1			# t2 = z < str[i]
		bne $t2, $zero, whileElseIf		# if true branch
	
		sub $t0, $t1, $t6			# t0 char - a

		sll $t0, $t0, 2				# char -  a * 4
		sub $t0, $s3, $t0			# t0 = *letters[cur - 'a']
	
		lw   $t5, 0($t0)			# t5 = current value of letters[cur - a]
		addi $t5, $t5, 1			# t5++
	
		sw $t5, 0($t0)				# letters[cur - a] = t5

		j conditionsDone
	
	whileElseIf:
		slti $t2, $t1, 'A'			# t2 = str[i] < 'A'
		bne  $t2, $zero, whileElse		# if true the condition is not met and we can branch
	
		slt $t2, $t4, $t1			# t2 = Z < str[i]
		bne $t2, $zero, whileElse		# if true branch
	
		sub $t0, $t1, $t7			# t0 char - A

		sll $t0, $t0, 2				# char -  A * 4
		sub $t0, $s3, $t0			# t0 = *letters[cur - 'A']
	
		lw   $t5, 0($t0)			# t5 = current value of letters[cur - A]
		addi $t5, $t5, 1			# t5++
	
		sw $t5, 0($t0)				# letters[cur - A] = t5
	
		j conditionsDone				
	
	whileElse:
	
		addi $s0, $s0, 1			# increment other

	conditionsDone:
	
		addi $s1, $s1, 1			# increment the address to go to next byte of str
		j whileBody
	
	afterWhile:
		addi $t0, $zero, 0			# t0 = i = 0
	
	forLoop:
		slti $t1, $t0, 26			# t1 = i < 26
		beq $t1, $zero, forAfter
		addi $t2, $t0, 'a'			# t2 = a + i
	
		addi $v0, $zero, 11
		add  $a0, $zero, $t2
		syscall
	
		addi $v0, $zero, 4			# print a colon
		la   $a0, colon
		syscall
	
		sll $t3, $t0, 2				# t3 = i*4
		sub $t3, $s3, $t3			# t3 = base + i*4
	
		addi $v0, $zero, 1			# print the value of letters[i]
		lw $a0, 0($t3)	
		syscall
	
		addi $v0, $zero, 4			# print a newline
		la $a0, newline
		syscall
	
		addi $t0, $t0, 1			# i++
		j forLoop
	
	forAfter:
		addiu $sp, $sp, 108			# restore the stack pointer from the int array
	
		addi $v0, $zero, 4			# print the string <other>:
		la $a0, otherStr
		syscall
	
		addi $v0, $zero, 1			# print the value of other
		addi $a0, $s0, 0
		syscall
	
		addi $v0, $zero, 4			# print a newline
		la $a0, newline
		syscall
	
		lw   $s0, 0($sp)			# restore the s registers
		lw   $s1, 4($sp)
		lw   $s2, 8($sp)
		lw   $s3, 12($sp)
		addiu $sp, $sp, 16
			
	lw $ra, 4($sp)				# standard epilogue 
	lw $fp, 0($sp)
	addiu $sp, $sp, 24
	jr $ra
	
	
.globl subsCipher
# void subsCipher(char *str, char *map)  
#         // NOTE: len is one more than the length of the string; it includes 
#         //      an extra character for the null terminator. 
#         int len = strlen(str)+1; 
#         int len_roundUp = (len+3) & ~0x3; 
#         char dup[len_roundUp]; // not legal in C, typically. See spec. 
#         for (int i=0; i<len-1; i++) 
#             dup[i] = map[(int)str[i]]; 
#         dup[len-1] = ?\0?;   
#         printSubstitutedString(dup); 
#
# registers:
# s0 = address of str
# s1 = address of map
# s2 = address of dup
# t0 = len
# t1 = len_roundUp
# t2
# t3
# t4
# t5
# t6
# t7

subsCipher:
	addiu $sp, $sp, -24			# standard prolouge 
	sw $fp, 0($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 20
	
	addiu $sp, $sp, -12			# saves registers
	sw   $s0, 0($sp)
	sw   $s1, 4($sp)
	sw   $s2, 8($sp)
	
	addi $s0, $a0, 0			# s0 = *str
	addi $s1, $a1, 0			# s1 = *map	
	
	jal strlen				# get the length of the string
	
	addi $t0, $v0, 1			# t0 = strlen(str) + 1
	addi $t1, $t0, 3			# t1 = len + 3
	addi $t2, $zero, 0x3			# t2 = negation of 0x3
	
	nor  $t2, $t2, $t2
	and  $t1, $t1, $t2			# t1 = rounded len & ~0x3
	subu $sp, $sp, $t1			# make space on the stack for dup
	
	addi $s2, $sp, 0			# s2 = address of dup[0]
	addi $t3, $zero, 0			# t3 = i = 0
	addi $t0, $t0, -1			# len -= 1

	dupFor:
	slt  $t4, $t3, $t0			# t4 = i < len - 1
	beq  $t4, $zero, afterDupFor
	
	add  $t5, $s0, $t3			# t5 = address of str + i
	lb   $t5, 0($t5)			# t5 = str[i]
	
	add  $t5, $t5, $s1			# t5 = str[i] + *map
	
	lb   $t6, 0($t5)			# t6 = map[int str[i]]

	add  $t7, $s2, $t3			# t7 = *dup[0] + i
	sb   $t6, 0($t7)			# dup[i] = map[str[i]]
	
	addi $t3, $t3, 1			# i++
	j dupFor
	
	afterDupFor:
	addi $t7, $t0, 0
	add  $t0, $t0, $sp			# t0 = len-1 + *dup
	addi $t2, $zero, '\0'			# t2 = null terminator
	sb   $t2, 0($t0)			# dup[len-1] = \0

	addu  $sp, $sp, $t1			# restore the stack pointer

	addi  $a0, $s2, 0			# a0 = *dup
	jal printSubstitutedString
	
	lw    $s0, 0($sp)			# restore s registers
	lw    $s1, 4($sp)
	lw    $s2, 8($sp)
	addi  $sp, $sp, 12
	
	lw $ra, 4($sp)				# standard epilogue 
	lw $fp, 0($sp)
	addiu $sp, $sp, 24
	jr $ra
	

.globl strlen
strlen:
	addiu $sp, $sp, -24			# standard prolouge 
	sw $fp, 0($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 20
	
	addi $t0, $zero, 0			# t0 = i = 0
	addi $t1, $zero, 0			# t1 = len = 0
	lenLoop:
		add $t2, $t0, $a0			# t2 - base + i
	
		lb $t3, 0($t2)				# t3 = value of str[i]
		addi $t0, $t0, 1			# i++
		beq $t3, $zero, afterLoop
		addi $t1, $t1, 1			# len++
		j lenLoop
	
	afterLoop:
		add $v0, $zero, $t1			# put len in return register
	
		lw $ra, 4($sp)				# standard epilogue 
		lw $fp, 0($sp)
		addiu $sp, $sp, 24
		jr $ra
