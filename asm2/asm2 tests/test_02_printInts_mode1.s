.data

.globl	printInts
.globl	printWords
.globl	bubbleSort

.globl	printInts_howToFindLen
.globl	intsArray
.globl	intsArray_END
.globl	intsArray_len
.globl	theString

printInts:
	.byte	1
printWords:
	.byte	0
bubbleSort:
	.byte	0

printInts_howToFindLen:
	.half	1	# 0 - read intsArray_len; 1 - calc intsArray_END-intsArray; 2 - null terminated

intsArray:
	.word	17
	.word	2570
	.word	65535
	.word	123
	.word	-256
	.word	0	# zero-terminator
intsArray_END:

intsArray_len:
	.word	5	# this is a lie!

theString:
	.asciiz	"The quick brown fox jumps over the lazy dog."



# ----------- main() -----------
.text

.globl	main

main:
	jal studentMain
	
	
	# dump out all of the values.
.data
TESTCASE_MSG:	.ascii 	"+-------------------------------+\n"
		.ascii	"|    Testcase Variable Dump:    |\n"
		.asciiz	"+-------------------------------+\n"
.text
	addi	$v0, $zero, 4		# print_str(TESTCASE_MSG)
	la	$a0, TESTCASE_MSG
	syscall

	la      $s0, intsArray          # s0 = intsArray = &intsArray[0]

	addi	$v0, $zero, 1		# print_int(intsArray[0])
	lw	$a0, 0($s0)
	syscall
	
	addi	$v0, $zero,11		# print_char(' ')
	addi	$a0, $zero,0x20
	syscall
	
	addi	$v0, $zero, 1		# print_int(intsArray[1])
	lw	$a0, 4($s0)
	syscall
	
	addi	$v0, $zero,11		# print_char(' ')
	addi	$a0, $zero,0x20
	syscall
	
	addi	$v0, $zero, 1		# print_int(intsArray[2])
	lw	$a0, 8($s0)
	syscall
	
	addi	$v0, $zero,11		# print_char(' ')
	addi	$a0, $zero,0x20
	syscall
	
	addi	$v0, $zero, 1		# print_int(intsArray[3])
	lw	$a0, 12($s0)
	syscall
	
	addi	$v0, $zero,11		# print_char(' ')
	addi	$a0, $zero,0x20
	syscall
	
	addi	$v0, $zero, 1		# print_int(intsArray[4])
	lw	$a0, 16($s0)
	syscall
	
	addi	$v0, $zero,11		# print_char(' ')
	addi	$a0, $zero,0x20
	syscall
	
	addi	$v0, $zero, 1		# print_int(intsArray[5])
	lw	$a0, 20($s0)
	syscall
	
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,0xa
	syscall
	
	# terminate the program	
	addi	$v0, $zero, 10		# syscall_exit
	syscall


