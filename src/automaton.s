# vim:sw=2 syntax=asm
.data
alive: .asciiz "X"
dead: .asciiz "_"
over: .asciiz "\n"

.text
  .globl simulate_automaton, print_tape

# Simulate one step of the cellular automaton
# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Returns: Nothing, but updates the tape in memory location 4($a0)

simulate_automaton:
  addi $sp $sp -12        	#allocate space on stack
  sw $ra 0($sp)            	#store $ra
  sw $s0 4($sp)            	#store $s0
  sw $s1 8($sp)           	#store $s1
  
  lw $t0 4($a0)            	#load tape
  lb $t1 8($a0)            	#load tape length
  lb $t2 9($a0)            	#load rule
  li $t3 0                 	#Counter loop
  li $t4 0                 	#place for new tape

tloop:
  add $s0 $t3 -1          	#index of right neighbor 
  add $s1 $t3 1           	#index of left neighbor
  blt $s0 0 left 	#go to left end if right index is negative
  bge $s1 $t1 right  	#go to right end if left index is length or greater
  j nachbar   	#else go to neighbor calculation 

left:
  add $s0, $s0, $t1         	#go to left end by adding the length
  j nachbar  

right:
  sub $s1, $s1, $t1        	 #go to right end by subtracting the length

nachbar:
  srlv $t5 $t0 $s0        	#right neighbor
  andi $t5 $t5 1

  srlv $t6 $t0 $t3        	#current cell
  andi $t6 $t6 1

  srlv $t7 $t0 $s1        
  andi $t7 $t7 1	    	#left neighbor

  sll $t7 $t7 2           	#left shift the left neighbor to create space
  sll $t6 $t6 1			#left shift current cell as well
  or $t7 $t7 $t6		#combine left and current cell
  or $t7 $t7 $t5          	#combine right cell as well

  srlv $t7 $t2 $t7        	#extract the corresponding bit from the rule
  andi $t7 $t7 1

  sllv $t7 $t7 $t3        
  or $t4 $t4 $t7		#save the new state in tape 

  addiu $t3 $t3 1
  blt $t3 $t1 tloop       	#loop for all cells

  sw $t4 4($a0)            	#store the new tape

  lw $ra 0($sp)            	#load $ra
  lw $s0 4($sp)            	#load $s0
  lw $s1 8($sp)           	#load $s1
  addi $sp $sp 12         	#deallocate space on stack
  jr $ra
  jr $ra

# Print the tape of the cellular automaton
# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Return nothing, print the tape as follows:
#   Example:
#       tape: 42 (0b00101010)
#       tape_len: 8
#   Print:  
#       __X_X_X_
print_tape:
 
  lw $t0 4($a0) #load tape
  lb $t1 8($a0) #load tape_len
  
  li $t2 0 #loop counter
  
  loop:
  beq $t1 $t2 end #if tape_len and loop number equal
  subi $t5 $t1 1 #estimate the length to be shifted
  sub $t6 $t5 $t2 #for correct shift number
  srlv $t7 $t0 $t6 #shifting
  andi $t8 $t7 1 #getting the bit
  
  check:
  beq $t8 $zero deadcell 
  
  alivecell: #print X
  la $a0 alive
  li $v0 4
  syscall
  b continue
  
  deadcell: #print _
  la $a0 dead
  li $v0 4
  syscall
  
  continue:
  addiu $t2 $t2 1 #increase the loop counter
  j loop
  
  end: #print \n
  la $a0 over
  li $v0 4
  syscall
  
  jr $ra
