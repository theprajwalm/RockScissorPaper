# vim:sw=2 syntax=asm
.data
alive: .asciiz "X"
dead: .asciiz "_"
end: .asciiz "\n"

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
  # TODO
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
  addiu $sp $sp -4 #saving $ra
  sw $ra 0($sp)
  
  lw $t0 4($a0) #loading  tape
  lb $t2 8($a0) #tape_len
  li $t3 0 #loopCounter
  
  loop:
  andi $t1 $t0 1 #getting the lsb
  srl $t0 $t0 1 #1 shift right
  
  bne $t1 $zero printAlive #conditions
  b printDead
  
  printAlive:
  la $a0 alive
  li $v0 4
  syscall
  j continue
  
  printDead:
  la $a0 dead
  li $v0 4
  syscall
  																																																		
  continue:
  addiu $t3 $t3 1 #increasing the loop counter
  bne $t3 $t2 loop #checking if we are done or not with all bits
  
  programEnd:
  la $a0 end
  li $v0 4
  syscall
  
  lw $ra 0($sp) #restoring $ra
  addiu $sp $sp 4 
  
  jr $ra
