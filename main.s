.data
str:  .asciiz "Hello, world!\n"
dest: .space  128
ar: .float 1.0
ai: .float 1.0
br: .float 2.0
bi: .float 1.0

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

  # Test complex
  # a = 1 + i
  # b = 2 + i
  # ab = (1+i)(2+i) = 2 + i + 2i - 1 = 1 + 3i
  l.s $f4, ar
  l.s $f5, ai
  # Push values onto stack
  addi $sp, $sp, -8
  s.s $f4, 4($sp)   # Breal
  s.s $f5, 0($sp)   # Bimag
  jal complex_sq
  addi $sp, $sp, 8
  li $v0, 2
  mov.s $f12, $f0
  syscall
  mov.s $f12, $f1
  syscall

  li $v0, 10
  syscall
