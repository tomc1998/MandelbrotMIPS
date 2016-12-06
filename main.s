.data
str:  .asciiz "Hello, world!\n"
dest: .space  128
ar: .float 1.0
ai: .float 0.0
br: .float -1.0
bi: .float 0.0

.text

#########################################
# Function main
# Entry point to program
.globl main
main:

  jal mandelbrot

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
  jal does_diverge
  addi $sp, $sp, 8
  move $a0, $v0
  li $v0, 1
  syscall
  l.s $f4, br
  l.s $f5, bi
  # Push values onto stack
  addi $sp, $sp, -8
  s.s $f4, 4($sp)   # Breal
  s.s $f5, 0($sp)   # Bimag
  jal does_diverge
  addi $sp, $sp, 8
  move $a0, $v0
  li $v0, 1
  syscall

  li $v0, 10
  syscall
