# vim:sw=2 syntax=asm

.data
tie_msg:.asciiz "T"
lose_msg:.asciiz "L"
win_msg:.asciiz "W"

.text
  .globl play_game_once

# Play the game once, that is
# (1) compute two moves (RPS) for the two computer players
# (2) Print (W)in (L)oss or (T)ie, whether the first player wins, looses or ties.
#
# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Returns: Nothing, only print either character 'W', 'L', or 'T' to stdout
play_game_once:
  addiu $sp $sp -4 #storing $ra
  sw $ra 0($sp)
  
  jal gen_byte #calling gen_byte for the first player
  move $s0 $v0 
  jal gen_byte #calling gen_byte for the second player
  move $s1 $v0
  
  lw $ra 0($sp)
  addiu $sp $sp 4
  
  beq $s1 $s0 tie #comparing the two players
  
  li $t0 0 #rock
  beq $s0 $t0 rock #player 1 is rock
  li $t0 1 #paper
  beq $s0 $t0 paper #player 1 is paper
  j scissor #player 1 is scissor
  
  rock:
  li $t0 2 #Scissors
  beq $s1 $t0 win  
  j lose
  
  paper:
  li $t0 0 #rock
  beq $s1 $t0 win
  j lose
  
  scissor:
  li $t0 1 #paper
  beq $s1 $t0 win
  j lose
  
  win:
  li $v0 4
  la $a0 win_msg
  syscall 
  jr $ra
  
  lose:
  li $v0 4
  la $a0 lose_msg
  syscall
  jr $ra 
  
  tie:
  li $v0 4
  la $a0 tie_msg
  syscall 
  jr $ra 