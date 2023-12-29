# Louis Romeo
# asm6.s
# 12/5/2023
# Purpose: Program that reads user input, uses
# bubbleSort, and prints out the array in ascending order.

.data
int:	       		.space 32
char:	       		.space 2
start_message: 		.asciiz "Enter your number(s):\n"
how_many:      		.asciiz "How long do you want the array to be?\n"
try_again:     		.asciiz "Please enter a number from 1 to 15\n"
bracket:       		.asciiz "["
close:         		.asciiz "]\n"
original:      		.asciiz "Original array: "
sorted:        		.asciiz "Sorted array:   "
again:         		.asciiz "Would you like to run the program again? (Y/N)\n"
goodbye:       		.asciiz "Goodbye\n"
.text

.globl sortInput
# This function will call the neccessary functions to get integers as keyboard input and sort them.
# It calls getLen to determine how long the array of ints will be then adds space on the stack for the array 
# and stores the keyboard input. It calls a function to print the array, sort the array, and print the sorted array.
#
# registers:
# s0 = userLen
# t0 = i
# t1
# t2
# t3
# t4

sortInput:
	addiu $sp, $sp, -24			# standard prolouge 
	sw $fp, 0($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 20
	
	jal getLen				# find out how long the user array will be
	
	addiu $sp, $sp, -4			# save s registers
	sw    $s0, 0($sp)
	
	addi $s0, $v0, 0			# s0 = retutn value of getLen = length of ints array
	addi $t0, $0, 0				# t0 = 0 = i
	
	addi $v0, $0, 4
	la   $a0, start_message
	syscall
	
	sll $t1, $s0, 2				# t1 = space required for array of userLen
	
	subu $sp, $sp, $t1			# make space for length of array on the stack int[userLen]
	addi  $t2, $sp, 0			# t2 = address of sp
	
	enter_numbers:
		slt $t1, $t0, $s0			# if i < userLen ask for more input
		beq $t1, $zero, after_enter
	
		addi $v0, $0, 5				# ask for keyboard input
		la $a0, int
		syscall
	
		sll  $t3, $t0, 2			# t3 = i*4
		add $t3, $t2, $t3			# t3 = address of sp + i*4
	
		sw $v0, 0($t3)				# ints[i] = user input
	
		addi $t0, $t0, 1			# i++
	
		j enter_numbers
	
	after_enter:
		addiu $sp, $sp, -4
		sw    $t2, 0($sp)			# save t2 on the stack
		
		addi $v0, $0, 4				# print string original
		la   $a0, original
		syscall
	
		addi $a0, $t2, 0			# a0 = address of ints array
		addi $a1, $s0, 0			# a1 = userLen
	
		jal print_array
	
		lw $a0, 0($sp)				# a0 = addresss of ints array
		addi $a1, $s0, 0			# a1 = userLen
		jal bubble_sort
	
		addi $t6, $v0, 0			# save return value of bubble sort
	
		addi $v0, $0, 4				# print string sorted
		la   $a0, sorted
		syscall
	
		addi $a0, $t6, 0			# a0 = return of bubble sort = addresss of sorted array
		jal print_array				# print the sorted array
	
		addiu $sp, $sp, 4			# restore stack pointer
	
		sll  $t1, $s0, 2			# t1 = space needed for array[userLen]
		addu $sp, $sp, $t1			# clean up ints array
	
		lw    $s0, 0($sp)			# restore the s registers
		addiu $sp, $sp, 4
	
		jal run_again				# ask if the user wants to run the program again
	
		lw $ra, 4($sp)				# standard epilogue 
		lw $fp, 0($sp)
		addiu $sp, $sp, 24
		jr $ra
	
.globl print_array
# This function takes a pointer and the length as variables, prints out the array.
#
# registers:
# s0 = userLen
# t0 = i
# t1
# t2
# t7 = address of array

print_array:
	addiu $sp, $sp, -24			# standard prolouge 
	sw $fp, 0($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 20
	
	addiu $sp, $sp, -4			# save the s regiters
	sw    $s0, 0($sp)
	
	addi $s0, $a1, 0			# s0 = userLen
	
	addi $t7, $a0, 0			# t7 = a0 = address of int array
	addi $t0, $0, 0				# t0 = i = 0
	
	addi $v0, $0, 11			# print a [
	addi $a0, $0, '['
	syscall
	
	print_loop:
		slt $t1, $t0, $s0			# if i < userLen
		beq  $t1, $zero, after_print
	
		sll $t2, $t0, 2				# i = i*4
		add $t2, $t2, $t7			# t2 = address of ints + i*4
	
	
		addi $v0, $0, 1
		lw   $a0, 0($t2)			# a0 = ints[i]
		syscall
	
		addi $s0, $s0, -1			# UserLen - 1 to check for last character
	
		slt  $t1, $t0, $s0			# dont print a comma and space after the last item in the array
		addi $s0, $s0, 1			# UserLen + 1
		beq  $t1, $zero, skip
	
		addi $v0, $0, 11			# print a comma
		addi $a0, $0, ','
		syscall
	
		addi $v0, $0, 11			# print a space	
		addi $a0, $0, ' '
		syscall
	
	skip:
		addi $t0, $t0, 1			# i++
		j print_loop
	
	after_print:
		addi $v0, $0, 11			# print a ]
		addi $a0, $0, ']'
		syscall
	
		addi $v0, $0, 11			# print a newline
		addi $a0, $0, '\n'
		syscall
	
		lw    $s0, 0($sp)			# restore the s registers
		addiu $sp, $sp, 4
	
		lw $ra, 4($sp)				# standard epilogue 
		lw $fp, 0($sp)
		addiu $sp, $sp, 24
		jr $ra
	
	
.globl bubble_sort

# This function takes the same two parameters and uses bubble sort 
# to sort the array in ascending order.
#
# registers:
# s0 = userLen - 1
# t0 = i
# t1 = j
# t2
# t3
# t4
# t5
# t6

bubble_sort:
	addiu $sp, $sp, -24			# standard prolouge 
	sw $fp, 0($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 20
	
	addiu $sp, $sp, -4			# save the s regiters
	sw    $s0, 0($sp)
	
	addi $s0, $a1, -1			# s0 = userLen - 1
	
	addi $t0, $0, 0				# t0 = i = 0
	addi $t1, $0, 0				# t1 = j = 0
	
	outer_for:
		slt $t2, $t0, $s0
		beq $t2, $0,  after_sort		# if i = ints length - 1 break
	
	inner_for:
		slt $t2, $t1, $s0
		beq $t2, $0,  update_i			# if j = ints length - 1 go on to the next i
	
		sll $t3, $t1, 2				# t3 = j*4
		add $t3, $t3, $a0			# t3 = addresss of ints[j]
	
		addi $t4, $t1, 1			# t4 = i+1
		sll  $t4, $t4, 2			# t4 = j + 1 * 4
		add $t4, $t4, $a0			# t4 = address of ints[j+1]
	
		lw $t5, 0($t3)				# t5 = ints[j]
		lw $t6, 0($t4)				# t6 = ints[j + 1]
	
		slt $t2, $t6, $t5			# t2 = ints[j+1] < ints[j]
		beq $t2, $0, skip_swap			# if this is false they are already in order and dont need to be swapped
	
		sw $t6, 0($t3)				# ints[j] = ints[j+1]
		sw $t5, 0($t4)				# ints[j+1] = old value of ints[j]
	
	skip_swap:
		addi $t1, $t1, 1			# j++
		j inner_for
	
	update_i:
		addi $t0, $t0, 1			# i++
		addi $t1, $0, 0				# j = 0
	
		j outer_for
	
	after_sort:
		addi $v0, $a0, 0			# return the address of the int array
	
		lw    $s0, 0($sp)			# restore the s registers
		addiu $sp, $sp, 4
	
		lw $ra, 4($sp)				# standard epilogue 
		lw $fp, 0($sp)
		addiu $sp, $sp, 24
		jr $ra
	
.globl run_again
# This function uses MIPS syscalls to ask the user for
# input and asks to "run again?". Takes no parameters.
#
# registers:
# t0
# t1
# t2
# t3

run_again:
	addiu $sp, $sp, -24			# standard prolouge 
	sw $fp, 0($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 20
	
	addi $v0, $0, 11			# prints \n
	addi $a0, $0, '\n'
	syscall
	
	addi $v0, $0, 54			# take user input if the aswer is yes run again if not terminate
	la   $a0, again
	la   $a1, char
	addi $a2, $0, 2
	syscall
	
	addi $t0, $0, -2			# t0 = -2 to check cancel status
	
	la $t1, char				# the user imput address
	lb $t1, 0($t1)				# t1 = user input
	
	addi $t2, $0, 'n'
	addi $t3, $0, 'N'
	
	beq $a1, $t0, exit			# This means that the user pressed cancel
	beq $t1, $t2, exit			# the user entered n or N
	beq $t1, $t3, exit
	
	jal sortInput				# else run again
	
	exit:
		addi $v0, $0, 17			# print a goodbye message
		la   $a0, goodbye
		syscall
	
		lw $ra, 4($sp)				# standard epilogue 
		lw $fp, 0($sp)
		addiu $sp, $sp, 24
		jr $ra	

.globl getLen
# This function takes no paramters. It takes keyboard input in the form of a single int < 16. It
# then passes the int back to sortInput to be used as userLen
#
# registers:
# t0 = slt valriable
#
getLen:
	addiu $sp, $sp, -24			# standard prolouge 
	sw $fp, 0($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 20
	
	addi $v0, $0, 4
	la   $a0, how_many
	syscall
	
	addi $v0, $0, 5				# int input for how long the array will be
	syscall
	
	len_check:
		slti $t0, $v0, 16			# confirm that the array length is less than 16 numbers
		beq $t0, $zero, retry
	
		slt $t0, $v0, $zero			# t0 = userLen < 0
		beq $t0, $zero, done
	
	retry:
		addi $v0, $0, 4				# print the try again string
		la   $a0, try_again
		syscall
	
		addi $v0, $0, 5				# int input for how long the array will be
		syscall
	
		j len_check				# validate the input
	
	done:
		lw $ra, 4($sp)				# standard epilogue 
		lw $fp, 0($sp)
		addiu $sp, $sp, 24
		jr $ra
