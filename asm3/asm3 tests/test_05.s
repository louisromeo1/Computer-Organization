# ----------- main() -----------
.text

.globl	main
main:
	# fill the sX registers (and fp) with junk.  Each testcase will use a different
	# set of values.
	lui   $fp,      0xe82f
	ori   $fp, $fp, 0x628e
	lui   $s0,      0x3a55
	ori   $s0, $s0, 0x6cde
	lui   $s1,      0x1d0f
	ori   $s1, $s1, 0xac96
	lui   $s2,      0xe09a
	ori   $s2, $s2, 0xb76d
	lui   $s3,      0xa167
	ori   $s3, $s3, 0x23fb
	lui   $s4,      0x1201
	ori   $s4, $s4, 0x656c
	lui   $s5,      0x344f
	ori   $s5, $s5, 0x5ef7
	lui   $s6,      0xad71
	ori   $s6, $s6, 0x7f68
	lui   $s7,      0x23ad
	ori   $s7, $s7, 0xbed2

	# instead of explicitly dumping the stack pointer, I'll push a dummy
	# variable onto the stack.  Some students are reporting different
	# stack values in their output.
	lui   $t0, 0x59fc
	ori   $t0, $t0,0x541d
	addiu $sp, $sp,-4
	sw    $t0, 0($sp)


	# call letterTree a couple times.  We'll print out the retval, just like above.
.data
LETTER_TREE_MSG1:		.asciiz "letterTree() returned: "
.text

	addi    $a0, $zero,1               # arg1 = 1
	jal     letterTree                 # make the call
	add     $t0, $v0,$zero             # save the retval
	
	addi    $v0, $zero,4               # print_str(MSG1)
	la      $a0, LETTER_TREE_MSG1
	syscall
	
	addi    $v0, $zero,1               # print_int(retval)
	add     $a0, $t0,$zero
	syscall
	
	addi    $v0, $zero,11              # print_char('\n')
	addi    $a0, $zero,0xa
	syscall
	
	
	addi    $a0, $zero,10              # arg1 = 10
	jal     letterTree                 # make the call
	add     $t0, $v0,$zero             # save the retval
	
	addi    $v0, $zero,4               # print_str(MSG1)
	la      $a0, LETTER_TREE_MSG1
	syscall
	
	addi    $v0, $zero,1               # print_int(retval)
	add     $a0, $t0,$zero
	syscall
	
	addi    $v0, $zero,11              # print_char('\n')
	addi    $a0, $zero,0xa
	syscall
	
	
	addi    $a0, $zero,4               # arg1 = 4
	jal     letterTree                 # make the call
	add     $t0, $v0,$zero             # save the retval
	
	addi    $v0, $zero,4               # print_str(MSG1)
	la      $a0, LETTER_TREE_MSG1
	syscall
	
	addi    $v0, $zero,1               # print_int(retval)
	add     $a0, $t0,$zero
	syscall
	
	addi    $v0, $zero,11              # print_char('\n')
	addi    $a0, $zero,0xa
	syscall
	
	
	# dump out all of the registers.
.data
TESTCASE_DUMP1:	.ascii  "\n"
               	.ascii 	"+-----------------------------------------------------------+\n"
		.ascii	"|    Magic Value (popped from the stack):                   |\n"
		.asciiz	"+-----------------------------------------------------------+\n"

TESTCASE_DUMP2:	.ascii  "\n"
               	.ascii 	"+-----------------------------------------------------------+\n"
		.ascii	"|    Testcase Register Dump (fp, then 8 sX regs):           |\n"
		.asciiz	"+-----------------------------------------------------------+\n"
.text
	addi	$v0, $zero, 4		# print_str(TESTCASE_DUMP1)
	la	$a0, TESTCASE_DUMP1
	syscall

	# we pop this from the stack so that, if the stack pointer is not
	# predictable, we'll still get reliable results.
	lw      $a0, 0($sp)
	addiu   $sp, $sp,4
	jal     printHex

	# the rest of the registers have hard-coded values
	addi	$v0, $zero, 4		# print_str(TESTCASE_DUMP2)
	la	$a0, TESTCASE_DUMP2
	syscall

	add	$a0, $fp, $zero
	jal     printHex
	add	$a0, $s0, $zero
	jal     printHex
	add	$a0, $s1, $zero
	jal     printHex
	add	$a0, $s2, $zero
	jal     printHex
	add	$a0, $s3, $zero
	jal     printHex
	add	$a0, $s4, $zero
	jal     printHex
	add	$a0, $s5, $zero
	jal     printHex
	add	$a0, $s6, $zero
	jal     printHex
	add	$a0, $s7, $zero
	jal     printHex
	
	# terminate the program	
	addi	$v0, $zero, 10		# syscall_exit
	syscall
	# never get here!



.globl getNextLetter
getNextLetter:
	# standard prologue
	addiu  $sp, $sp, -24
	sw     $fp, 0($sp)
	sw     $ra, 4($sp)
	addiu  $fp, $sp, 20
	
.data
getNextLetter_BUF:	.asciiz "abcdefghijklmnopqrstuvwxyz"
			.word   0    # make sure we never overrun the buffer!
			.word   0    # make sure we never overrun the buffer!
			.word   0    # make sure we never overrun the buffer!
			.word   0    # make sure we never overrun the buffer!
			.word   0    # make sure we never overrun the buffer!
			.word   0    # make sure we never overrun the buffer!
			.word   0    # make sure we never overrun the buffer!
			.word   0    # make sure we never overrun the buffer!
			.word   0    # make sure we never overrun the buffer!
			.word   0    # make sure we never overrun the buffer!
			.word   0    # make sure we never overrun the buffer!
.text
	# no matter what input they give us, we will modulo by 32, so that positions
	# "wrap around" over time.
	andi   $a0, $a0,0x1f        # this mask has 5 bits turned on!
	
	# read the address of the string
	la     $v0, getNextLetter_BUF
	
	# offset by the parameter
	add    $v0, $v0,$a0
	
	# end then read the character there, as the value we'll return.
	lb     $v0, 0($v0)
	
	# standard epilogue
	lw     $ra, 4($sp)
	lw     $fp, 0($sp)
	addiu  $sp, $sp, 24
	jr     $ra



# void printHex(int val)
# {
#     printHex_recurse(val, 8);
#     printf("\n");
# }
printHex:
	# standard prologue
	addiu  $sp, $sp, -24
	sw     $fp, 0($sp)
	sw     $ra, 4($sp)
	addiu  $fp, $sp, 20
	
	# printHex(val, 8)
	addi   $a1, $zero, 8
	jal    printHex_recurse
	
	addi   $v0, $zero, 11      # print_char('\n')
	addi   $a0, $zero, 0xa
	syscall

	# standard epilogue
	lw     $ra, 4($sp)
	lw     $fp, 0($sp)
	addiu  $sp, $sp, 24
	jr     $ra
	
	
	
printHex_recurse:
	# standard prologue
	addiu  $sp, $sp, -24
	sw     $fp, 0($sp)
	sw     $ra, 4($sp)
	addiu  $fp, $sp, 20
	
	# if (len == 0) return;    // base case (NOP)
	beq    $a1, $zero, printHex_recurse_DONE

	# recurse first, before we print this character.
	#
	# The reason for this is because the easiest way to break up
	# a long integer is using a small shift and modulo; so *this*
	# call will be responsible for the *last* hex digit, and we'll
	# use recursion to handle the things which come *before* it.
	#
	# As we've seen just above, if the current len==1, then the
	# recursive call will be the base case, and a NOP.
	
	# of course, we have to save a0 before we recurse.  We do *NOT*
	# need to save a1, since we'll never need it again.
	sw     $a0, 8($sp)
	
	# printHex_recurse(val >> 4, len-1)
	srl    $a0, $a0,4
	addi   $a1, $a1,-1
	jal    printHex_recurse
	
	# restore a0
	lw     $a0, 8($sp)
	
	# the value we will print is (val & 0xf), interpreted as hex.
	andi   $t0, $a0,0x0f      # digit = (val & 0xf)
	
	slti   $t1, $t0,10        # t1 = (digit < 10)
	beq    $t1, $zero, printHex_recurse_LETTER
	
	# if we get here, then $t0 contains an integer from 0 to 9, inclusive.
	addi   $v0, $zero, 11     # print_char(digit+'0')
	addi   $a0, $t0, '0'
	syscall
	
	j      printHex_recurse_DONE
	
printHex_recurse_LETTER:
	# if we get here, then $t0 contains an integer from 10 to 15, inclusive.
	# convert to the equivalent letter.
	addi   $t0, $t0,-10        # digit -= 10
	
	addi   $v0, $zero, 11     # print_char(digit+'a')
	addi   $a0, $t0, 'a'
	syscall
	
	# intentional fall-through to the epilogue	

printHex_recurse_DONE:
	# standard epilogue
	lw     $ra, 4($sp)
	lw     $fp, 0($sp)
	addiu  $sp, $sp, 24
	jr     $ra
