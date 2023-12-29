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
	.byte	0
printWords:
	.byte	0
bubbleSort:
	.byte	1

printInts_howToFindLen:
	.half	0	# 0 - read intsArray_len; 1 - calc intsArray_END-intsArray; 2 - null terminated

intsArray:
	.word	123
	.word	123
	.word	123
	.word	123
	.word	123
	.word	123
	.word	123
	.word	123
	.word	123
	.word	123
	.word	123
	.word	123
	.word	123
	.word	123
	.word	123
	.word	123
intsArray_END:

intsArray_len:
	.word	16

theString:
	.asciiz	"Four scores and seven field goals ago..."



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
	
	addi	$v0, $zero,11		# print_char(' ')
	addi	$a0, $zero,0x20
	syscall
	
	addi	$v0, $zero, 1		# print_int(intsArray[6])
	lw	$a0, 24($s0)
	syscall
	
	addi	$v0, $zero,11		# print_char(' ')
	addi	$a0, $zero,0x20
	syscall
	
	addi	$v0, $zero, 1		# print_int(intsArray[7])
	lw	$a0, 28($s0)
	syscall
	
	addi	$v0, $zero,11		# print_char(' ')
	addi	$a0, $zero,0x20
	syscall
	
	addi	$v0, $zero, 1		# print_int(intsArray[8])
	lw	$a0, 32($s0)
	syscall
	
	addi	$v0, $zero,11		# print_char(' ')
	addi	$a0, $zero,0x20
	syscall
	
	addi	$v0, $zero, 1		# print_int(intsArray[9])
	lw	$a0, 36($s0)
	syscall
	
	addi	$v0, $zero,11		# print_char(' ')
	addi	$a0, $zero,0x20
	syscall
	
	addi	$v0, $zero, 1		# print_int(intsArray[10])
	lw	$a0, 40($s0)
	syscall
	
	addi	$v0, $zero,11		# print_char(' ')
	addi	$a0, $zero,0x20
	syscall
	
	addi	$v0, $zero, 1		# print_int(intsArray[11])
	lw	$a0, 44($s0)
	syscall
	
	addi	$v0, $zero,11		# print_char(' ')
	addi	$a0, $zero,0x20
	syscall
	
	addi	$v0, $zero, 1		# print_int(intsArray[12])
	lw	$a0, 48($s0)
	syscall
	
	addi	$v0, $zero,11		# print_char(' ')
	addi	$a0, $zero,0x20
	syscall
	
	addi	$v0, $zero, 1		# print_int(intsArray[13])
	lw	$a0, 52($s0)
	syscall
	
	addi	$v0, $zero,11		# print_char(' ')
	addi	$a0, $zero,0x20
	syscall
	
	addi	$v0, $zero, 1		# print_int(intsArray[14])
	lw	$a0, 56($s0)
	syscall
	
	addi	$v0, $zero,11		# print_char(' ')
	addi	$a0, $zero,0x20
	syscall
	
	addi	$v0, $zero, 1		# print_int(intsArray[15])
	lw	$a0, 60($s0)
	syscall
	
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,0xa
	syscall
	
	# terminate the program	
	addi	$v0, $zero, 10		# syscall_exit
	syscall


