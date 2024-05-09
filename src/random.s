# vim:sw=2 syntax=asm
.data
seed:


.text
  .globl gen_byte, gen_bit

# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Return value:
#  Compute the next valid byte (00, 01, 10) and put into $v0
#  If 11 would be returned, produce two new bits until valid
#
gen_byte:
#saving the $ra of the gen_byte
  add $sp $sp -4  #allocating 4 byte
  sw  $ra 0($sp) #storing $ra
  li $t0 2 #loads the value 2 to compare
  
  gen_two_num:
  jal gen_bit #calling gen_bit for the first value
  move $t1 $v0 #moves the value of $v0 t0 $t1
  
  jal gen_bit #calling gen_bit for the second value
  move $t2 $v0 #moves the value of $v0 to $t2

  addu $t3 $t1 $t2 #adding the value of $t1 and $t2
  beq $t0 $t3 gen_two_num #comparing the value with 2
  sll $t1 $t1 1 #shifting the value to right by 1
  or $v0 $t1 $t2 #concatenating two registers and storing in $vo
  
  lw $ra 0($sp) #restoring the value of the $ra
  add $sp $sp 4 #restoring the stack pointer back to the intial value
  jr $ra

# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Return value:
#  Look at the field {eca} and use the associated random number generator to generate one bit.
#  Put the computed bit into $v0
#
gen_bit:
  li $v0 41 #generate random number
  li $a0 0
  syscall
  andi $v0 $a0 1 #stores the least bit value
  jr $ra