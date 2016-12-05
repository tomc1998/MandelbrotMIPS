.data
str:  .asciiz "Hello, world!\n"
dest: .space  128

.text

#########################################
# Function main
# Entry point to program
.globl main
main:

  li $t0, 2
  la $t1, framebuffer
  sb $t0, 10($t1)
  jal render

  li $v0, 10
  syscall
