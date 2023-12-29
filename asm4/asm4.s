# Louis Romeo
# 10/18/2023
# CSC 252
# asm4.s

.data
new_line: 		.asciiz 	"\n"
.text

# void bst_init_node(BSTNode *node, int key)
# 	node->key = key
# 	node->left = NULL;
# 	node->right = NULL;
# registers:
# t0 = temp register
# t1 = node.key
# t2 = node.left
# t3 = node.right
.globl bst_init_node
bst_init_node:

	addiu $sp, $sp, -24 			# allocate stack space-- default of 24 here sw 
	sw $fp, 0($sp)    			# save caller?s frame pointer
	sw $ra, 4($sp)     			# save return address
	addiu $fp, $sp, 20 			# setup main?s frame pointer
	
	add $t0, $zero, $a0			# adds a0 into temp register t0
	add $t1, $zero, $a1			# loads a1 into temp register t1
	
	addi $t2, $zero, 0			# sets t2 == 0
	addi $t3, $zero, 0			# sets t3 == 0
	
	sw $t1, 0($t0)				# stores key at t1
	sw $t2, 4($t0)				# stores .left in t2
	sw $t3, 8($t0)				# stores .right in t3
	
	lw $ra, 4($sp) 				# get return address from stack
	lw $fp, 0($sp) 				# restore the caller?s frame pointer
	addiu $sp, $sp, 24			# restore the caller?s stack pointer
	jr $ra 					# return to caller?s code
		
# BSTNode *bst_search(BSTNode *node, int key)
#	BSTNode *cur = node;
#	while (cur != NULL)
#		if (cur->key == key)
#			return cur;
#		if (key < cur->key)
#			cur = cur->left;
#		else
#			cur = cur->right;
#	return NULL;
# registers:
# t0
# t1 = *node
# t2 = cur.key
# t3 = cur.left
# t4 = cur.right	
.globl bst_search
bst_search:

	addiu $sp, $sp, -24 		# allocate stack space-- default of 24 here sw 
	sw $fp, 0($sp)    		# save caller?s frame pointer
	sw $ra, 4($sp)     		# save return address
	addiu $fp, $sp, 20 		# setup main?s frame pointer
		
	add $t0, $zero, $a0				# BSTNode *cur = node;
	add $t1, $zero, $a1				# adds param a1 into temp regsiter t1
	
	WHILE_SEARCH_FLAG:
		
		bne $t0, $zero, WHILE_SEARCH_BODY
		j AFTER_WHILE_SEARCH
		
		WHILE_SEARCH_BODY:
			
			lw $t2, 0($t0)					# t2 = cur.key
			lw $t3, 4($t0)					# t3 = cur.left
			lw $t4,	8($t0)					# t4 = cur.right 
	
			IF_ONE_SEARCH:
				
				beq $t1, $t2, IF_ONE_BODY
				j IF_TWO_SEARCH
			
				IF_ONE_BODY:
					add $v0, $zero, $t0		# return cur
					j SEARCH_EPILOUGE
					
			IF_TWO_SEARCH:
			
				slt $t5, $t1, $t2			# stores value of key < cur.key
				beq $t5, $zero, ELSE_SEARCH	
				j IF_TWO_BODY
				
				IF_TWO_BODY:
					
					add $t0, $zero, $t3		# cur = cur.left
					j WHILE_SEARCH_FLAG
						
			ELSE_SEARCH:
				
				add $t0, $zero, $t4 			# cur = cur.right
				j WHILE_SEARCH_FLAG
	
		AFTER_WHILE_SEARCH:
		
			add $v0, $zero, $zero				# returns null
			j SEARCH_EPILOUGE
	
		SEARCH_EPILOUGE:
		
			lw $ra, 4($sp) 			# get return address from stack
			lw $fp, 0($sp) 			# restore the caller?s frame pointer
			addiu $sp, $sp, 24		# restore the caller?s stack pointer
			jr $ra 				# return to caller?s code


# int bst_count(BSTNode *node)
#	if (node == NULL)
#	return 0;
# return bst_count(node->left) + 1 + bst_count(node->right);
# registers:
# t0 = *node
# t1 = node.left
# t2 = node.right
# t3
# t4		
.globl bst_count
bst_count:
	
	addiu $sp, $sp, -24 			# allocate stack space-- default of 24 here sw 
	sw $fp, 0($sp)    			# save caller?s frame pointer
	sw $ra, 4($sp)     			# save return address
	addiu $fp, $sp, 20 			# setup main?s frame pointer
	
	add $t0, $zero, $a0			# t0 = *node
	beq $t0, $zero, IF_COUNT_ONE
	
	j COUNT_AFTER_IF
	
	IF_COUNT_ONE:
		add $v0, $zero, $zero		# returns 0;
		j COUNT_EPILOUGE
	
	COUNT_AFTER_IF:
		lw $t1, 4($t0)			# t1 = node.left
		lw $t2, 8($t0)			# t2 = node.right
		
		sw $t0, 16($sp)			# store $t8 to store the original val
		sw $t1, 12($sp)			# store val
		sw $t2, 8($sp)			# store calls
			
		add $a0, $zero, $t1		# recursive param node.left
			
		jal bst_count			# recursive call to bst_count
		
		lw $t0, 16($sp)			# store $t8 to store the original val
		lw $t1, 12($sp)			# store val
		lw $t2, 8($sp)			# store calls
		
		sw $t0, 16($sp)			# store $t8 to store the original val
		sw $t1, 12($sp)			# store val
		sw $t2, 8($sp)			# store calls
		
		add $t3, $zero, $v0		# bst_count(node->left) + 1
		addi $t3, $t3, 1		# + 1
		sw $t3, 20($sp)			# saves return value on stack
		add $a0, $zero, $t2		# t2 == node.right
		jal bst_count			# second recursive call			
		
		lw $t0, 16($sp)			# load cur value to $t0
		lw $t1, 12($sp)			# load calls value to $t3
		lw $t2, 8($sp)			# load original val value to $a0
		lw $t3, 20($sp)			# store $t3 to store the original val
		
		add $t4, $zero, $v0		# bst_count(node->right)
		
		add $v0, $t3, $t4 		# return bst_count(node->left) + 1 + bst_count(node->right)
		j COUNT_EPILOUGE
		
	COUNT_EPILOUGE:
		lw $ra, 4($sp) 			# get return address from stack
		lw $fp, 0($sp) 			# restore the caller?s frame pointer
		addiu $sp, $sp, 24		# restore the caller?s stack pointer
		jr $ra 				# return to caller?s code

# void bst_in_order_traversal(BSTNode *node)
# 	if (node == NULL)
# 		return;
# 	bst_in_order_traversal(node->left);
# 	printf("%d\n", node->key);
# 	bst_in_order_traversal(node->right);
# registers:
# t0 = node
# t1 
# t2
# t3
# t4 
	
.globl bst_in_order_traversal
bst_in_order_traversal:

	addiu $sp, $sp, -24 			# allocate stack space-- default of 24 here sw 
	sw $fp, 0($sp)    			# save caller?s frame pointer
	sw $ra, 4($sp)     			# save return address
	addiu $fp, $sp, 20 			# setup main?s frame pointer
	
	add $t0, $zero, $a0			# t0 = *node
	add $t1, $zero, $zero 			# t1 = 0
	beq $t0, $t1, IN_ORDER_IF		# if (node == NULL)
	j IN_ORDER_AFTER_IF
	
	
	IN_ORDER_IF:
		add $v0, $zero, $zero		# returns null
		j IN_ORDER_EPILOUGE
		
	IN_ORDER_AFTER_IF:
	
		lw $t2, 4($t0)			# t2 = node.left
		lw $t3, 8($t0)			# t3 = node.right
		lw $t4, 0($t0)			# t4 = node.key
		
		sw $t0, 16($sp)			# store $t8 to store the original val
		sw $t1, 12($sp)			# store val
		sw $t2, 8($sp)			# store calls
			
		add $a0, $zero, $t2		# recursive param node.left
			
		jal bst_in_order_traversal	# recursive call
		add $t3, $zero, $v0		# bst_in_order_traversal(node->left)
		
		lw $t0, 16($sp)			# t0 = node
		lw $t3, 8($t0)			# t3 = node.right
		lw $t4, 0($t0)			# t4 = node.key
		
		sw $t0, 16($sp)			# store $t8 to store the original val
		sw $t1, 12($sp)			# store val
		sw $t2, 8($sp)			# store calls
		
		addi $v0, $zero, 1 		# printing node.key		
		add $a0, $zero, $t4
		syscall
		
		addi $v0, $zero, 4 		# printing \n		
		la $a0, new_line
		syscall
		
		sw $t3, 20($sp)			# saves return value on stack
		add $a0, $zero, $t3		# t3 == node.right (parameter)
		jal bst_in_order_traversal	# second recursive call			
		
		lw $t0, 16($sp)			# load cur value to $t0
		lw $t1, 12($sp)			# load calls value to $t3
		lw $t2, 8($sp)			# load original val value to $a0
		lw $t3, 20($sp)			# store $t3 to store the original val
		
		j IN_ORDER_EPILOUGE
	IN_ORDER_EPILOUGE:
		lw $ra, 4($sp) 			# get return address from stack
		lw $fp, 0($sp) 			# restore the caller?s frame pointer
		addiu $sp, $sp, 24		# restore the caller?s stack pointer
		jr $ra 				# return to caller?s code
																
# void bst_pre_order_traversal(BSTNode *node)
# 	if (node == NULL)
# 		return;
#	printf("%d\n", node->key);
# 	bst_pre_order_traversal(node->left);
# 	bst_pre_order_traversal(node->right);
# registers:
# t0 = node
# t1
# t2
# t3
# t4
# t5

.globl bst_pre_order_traversal
bst_pre_order_traversal:

	addiu $sp, $sp, -24 			# allocate stack space-- default of 24 here sw 
	sw $fp, 0($sp)    			# save caller?s frame pointer
	sw $ra, 4($sp)     			# save return address
	addiu $fp, $sp, 20 			# setup main?s frame pointer
	
	add $t0, $zero, $a0			# t0 = *node
	add $t1, $zero, $zero 			# t1 = 0
	beq $t0, $t1, PRE_ORDER_IF		# if (node == NULL)
	j PRE_ORDER_AFTER_IF
	
	PRE_ORDER_IF:
	
		add $v0, $zero, $zero		# returns null
		j PRE_ORDER_EPILOUGE
		
	PRE_ORDER_AFTER_IF:
		
		lw $t2, 4($t0)			# t2 = node.left
		lw $t3, 8($t0)			# t3 = node.right
		lw $t4, 0($t0)			# t4 = node.key
		
		sw $t0, 16($sp)			# store $t8 to store the original val
		sw $t1, 12($sp)			# store val
		sw $t2, 8($sp)			# store calls
		
		addi $v0, $zero, 1 		# printing node.key		
		add $a0, $zero, $t4
		syscall
		
		addi $v0, $zero, 4 		# printing \n		
		la $a0, new_line
		syscall
			
		add $a0, $zero, $t2		# recursive param node.left
			
		jal bst_pre_order_traversal	# recursive call
		add $t3, $zero, $v0		# bst_in_order_traversal(node->left)
		
		lw $t0, 16($sp)			# t0 = node
		lw $t3, 8($t0)			# t3 = node.right
		lw $t4, 0($t0)			# t4 = node.key
		
		sw $t0, 16($sp)			# store $t8 to store the original val
		sw $t1, 12($sp)			# store val
		sw $t2, 8($sp)			# store calls
		
		sw $t3, 20($sp)			# saves return value on stack
		add $a0, $zero, $t3		# t3 == node.right (parameter)
		jal bst_pre_order_traversal	# second recursive call			
		
		lw $t0, 16($sp)			# load cur value to $t0
		lw $t1, 12($sp)			# load calls value to $t3
		lw $t2, 8($sp)			# load original val value to $a0
		lw $t3, 20($sp)			# store $t3 to store the original val
		j PRE_ORDER_EPILOUGE
		
	PRE_ORDER_EPILOUGE:
		lw $ra, 4($sp) 			# get return address from stack
		lw $fp, 0($sp) 			# restore the caller?s frame pointer
		addiu $sp, $sp, 24		# restore the caller?s stack pointer
		jr $ra 				# return to caller?s code
	
	
# BSTNode *bst_insert(BSTNode *root, BSTNode *newNode)
# 	if (root == NULL)
# 		return newNode;
# 	if (newNode->key < root->key)
# 		root->left = bst_insert(root->left, newNode);
# 	else
# 		root->right = bst_insert(root->right, newNode);
# 	return root;
# registers:
# t0 = root
# t1 
# t2
# t3
# t6 = newNode
# t5
.globl bst_insert
bst_insert:

	addiu $sp, $sp, -24 				# allocate stack space-- default of 24 here sw 
	sw $fp, 0($sp)    				# save caller?s frame pointer
	sw $ra, 4($sp)     				# save return address
	addiu $fp, $sp, 20 				# setup main?s frame pointer
	
	
	add $t0, $zero, $a0				# t0 = *root
	beq $t0, $zero, INSERT_IF_ONE
	lw $t1, 0($t0)					# stores root.key at t1
	lw $t2, 4($t0)					# stores root.left in t2
	lw $t3, 8($t0)					# stores root.right in t3
	lw $t4, 0($a1)					# stores newNode.key in t4
	add $t6, $zero, $a1				# t6 = *newNode
	beq $t0, $zero, INSERT_IF_ONE			# if (root == NULL)
	j INSERT_IF_TWO
	
	INSERT_IF_ONE:
	
		add $v0, $zero, $a1			# returns newNode
		j INSERT_EPILOUGE
	
	INSERT_IF_TWO:
		slt $t5, $t4, $t1			# if (newNode->key < root->key)
		bne $t5, $zero, INSERT_IF_TWO_BODY
		j INSERT_ELSE
		
		INSERT_IF_TWO_BODY:
			sw $t0, 12($sp)			# saves root
			sw $t6, 16($sp)			# saves newNode
			
			add $a1, $zero, $t6		# saves newNode as parameter
			add $a0, $zero, $t2		# saves root.left as parameter
			
			jal bst_insert			# recursive call
			
			add $t3, $zero, $v0		# bst_insert(root->left)
			
			lw $t0, 12($sp)			# loads root
			lw $t1, 16($sp)			# loads newNode
				
			sw $t3, 4($t0)			# root->left = bst_insert(root->left, newNode);
			j INSERT_AFTER_ELSE
			
		INSERT_ELSE:
			sw $t0, 12($sp)			# saves root
			sw $t6, 16($sp)			# saves newNode
			
			add $a0, $zero, $t3		# saves root.left as parameter
			
			jal bst_insert			# recursive call
			add $t3, $zero, $v0		# bst_insert(root->right)
			
			lw $t0, 12($sp)			# loads root
			lw $t1, 16($sp)			# loads newNode
			
			sw $t3, 8($t0)			# root->right = bst_insert(root.right, newNode);
			j INSERT_AFTER_ELSE
		
		INSERT_AFTER_ELSE:
		
			add $v0, $zero, $t0		# returns root
			j INSERT_EPILOUGE
			
		INSERT_EPILOUGE:
			lw $ra, 4($sp) 			# get return address from stack
			lw $fp, 0($sp) 			# restore the caller?s frame pointer
			addiu $sp, $sp, 24		# restore the caller?s stack pointer
			jr $ra 				# return to caller?s code
									
