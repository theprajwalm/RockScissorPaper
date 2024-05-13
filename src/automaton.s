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
