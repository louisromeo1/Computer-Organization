.data

.globl minimum
.globl negate
.globl evens
.globl print

.globl jan
.globl feb
.globl mar
.globl apr
.globl may
.globl jun

jan:    .word -10
feb:    .word -5
mar:    .word 0
apr:    .word 5
may:    .word 10
jun:    .word 15

minimum: .word 1
negate:  .word 1
evens:   .word 0
print:   .word 0



.text

.globl main
main:
	jal studentMain


	# dump out the 6 data values, and the 4 control values
.data
TESTCASE_MSG:	.asciiz "\n\nTestcase Variable Dump:\n"
.text
	addi	$v0, $zero, 4		# print_str(TESTCASE_MSG)
	la	$a0, TESTCASE_MSG
	syscall

	addi	$v0, $zero, 1		# print_int(jan)
	la	$a0, jan
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,'\n'
	syscall
	
	addi	$v0, $zero, 1		# print_int(feb)
	la	$a0, feb
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,'\n'
	syscall
	
	addi	$v0, $zero, 1		# print_int(mar)
	la	$a0, mar
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,'\n'
	syscall
	
	addi	$v0, $zero, 1		# print_int(apr)
	la	$a0, apr
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,'\n'
	syscall
	
	addi	$v0, $zero, 1		# print_int(may)
	la	$a0, may
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,'\n'
	syscall
	
	addi	$v0, $zero, 1		# print_int(jun)
	la	$a0, jun
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,'\n'
	syscall
	
	addi	$v0, $zero, 1		# print_int(minimum)
	la	$a0, minimum
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,'\n'
	syscall
	
	addi	$v0, $zero, 1		# print_int(negate)
	la	$a0, negate
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,'\n'
	syscall
	
	addi	$v0, $zero, 1		# print_int(evens)
	la	$a0, evens
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,'\n'
	syscall
	
	addi	$v0, $zero, 1		# print_int(print)
	la	$a0, print
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,'\n'
	syscall
	
	
	# terminate the program	
	addi	$v0, $zero, 10		# syscall_exit
	syscall


