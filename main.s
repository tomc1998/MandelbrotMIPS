.data
str:  .asciiz "Hello, world!\n"
dest: .space  128

.text

.globl main
main:
  # memcpy(dest, str, 15)
  la $t0, dest       # Push dest
  addi $sp, $sp, -4
  sw $t0, 0($sp)
  la $t0, str        # Push src
  addi $sp, $sp, -4
  sw $t0, 0($sp)
  li $t0, 15         # Push 15
  addi $sp, $sp, -4
  sw $t0, 0($sp)
  jal memcpy
  addi $sp, $sp, 12  # Pop all args off stack

  la $a0, dest # Print dest
  li $v0, 4
  syscall
  li $v0, 10
  syscall
  
  
  
