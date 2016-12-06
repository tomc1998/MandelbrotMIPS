#############
# This file contains functions to generate the mandelbrot set in the
# framebuffer (see framebuffer.s)
#############

############# Constants
.data
.include "macros.s"
max_mod_sq: .float 4.0 # The maximum that the mandelbrot function's result's
                       # modulus squared can be before we know it diverges
newline: .asciiz "\n"

# Index increment for mandelbrot (4/80)
x_index_increment: .float 0.03
y_index_increment: .float 0.05
# Start of the incrementation for plotting the mandelbrot set
x_index_start: .float -1.5
y_index_start: .float -1.5

############# Functions
.text

#########################################
# Function does_diverge
# Calculates whether the given complex number diverges over NUM_ITERATIONS
# iterations.
# Args:
# 4b (Floating point real part of c)
# 4b (Floating point imag part of c)
# Returns: 
# v0 = Number of iterations taken to diverge, or 0 if doesn't
.eqv NUM_ITERATIONS 100
.globl does_diverge
does_diverge:
  # Save $ra, $s0, $s1, $f20 to $f23 on stack
  l.s $f4, 4($sp)  # creal
  l.s $f5, 0($sp)  # cimag
  addi $sp, $sp, -28
  sw $ra, 24($sp)
  sw $s0, 20($sp)
  sw $s1, 16($sp)
  s.s $f20, 12($sp)
  s.s $f21, 8($sp)
  s.s $f22, 4($sp)
  s.s $f23, 0($sp)
  li  $s0, 1 # Counter
  li  $s1, NUM_ITERATIONS # Limit of counter
  mov.s $f20, $f4
  mov.s $f21, $f5
  l.s $f22, fpzero  # zreal
  l.s $f23, fpzero  # zimag
  
  diverge_loop:
    # Find z^2
    addi $sp, $sp, -8
    s.s $f22 4($sp)
    s.s $f23 0($sp)
    jal complex_sq
    mov.s $f22, $f0 # Set z = z^2
    mov.s $f23, $f1
    # Find z^2 + c
    addi $sp, $sp, -8
    s.s $f20 12($sp)
    s.s $f21 8($sp)
    s.s $f22 4($sp)
    s.s $f23 0($sp)
    jal complex_add
    addi $sp, $sp, 16
    mov.s $f22, $f0 # Set z = z^2 + c
    mov.s $f23, $f1

    # Check if diverging, find mod^2 and check if > 4
    addi $sp, $sp, -8
    s.s $f22 4($sp)
    s.s $f23 0($sp)
    jal complex_mod_sq
    addi $sp, $sp, 8
    l.s $f8, max_mod_sq
    c.le.s $f0, $f8
    bc1t continue_diverge_loop
    j exit_does_diverge_true # Does diverge, > 4, goto end

    continue_diverge_loop:
    # else doesn't diverge, go back around loop?
    addi $s0, $s0, 1
    bgt $s0, $s1, exit_does_diverge_false
    j diverge_loop
  
  exit_does_diverge_true:
  move $v0, $s0
  j exit_does_diverge

  exit_does_diverge_false:
  li $v0, 0
  j exit_does_diverge

  exit_does_diverge:
  # Restore saved registers and return addr
  lw $ra, 24($sp)
  lw $s0, 20($sp)
  lw $s1, 16($sp)
  l.s $f20, 12($sp)
  l.s $f21, 8($sp)
  l.s $f22, 4($sp)
  l.s $f23, 0($sp)
  addi $sp, $sp, 28
  jr $ra
  
  
    
  


# Function mandelbrot
# Calculates the mandelbrot set and places results into the framebuffer. 1
# 'pixel' = 4/80 units (see index_increment constant above).
# Args: None
# Returns: None
.text
.globl mandelbrot
mandelbrot:
  # Save saved registers
  addi $sp, $sp -20
  sw $ra, 16($sp)
  s.s $f20, 12($sp)
  s.s $f21, 8($sp)
  sw $s0, 4($sp)
  sw $s1, 0($sp)
  li $s0, 0 # x index in framebuffer
  li $s1, 0 # y index in framebuffer
  l.s $f20, x_index_start # x index
  l.s $f21, y_index_start # y index
  addi $sp, $sp, -8
  row_loop:
    column_loop:
      s.s $f20, 4($sp)
      s.s $f21, 0($sp)
      jal does_diverge

      # Compute location in framebuffer to insert
      li $t0, FRAMEBUFFER_WIDTH
      mult $t0, $s1
      mflo $t0
      add $t0, $t0, $s0
      la $t1, framebuffer
      add $t1, $t1, $t0
      sb $v0, 0($t1)

      # Increment x indexes
      li $t0, FRAMEBUFFER_WIDTH
      addi $s0, $s0, 1
      beq $t0, $s0, finish_column_loop
      l.s $f4, x_index_increment
      add.s $f20, $f20, $f4
      j column_loop

      finish_column_loop:
      li $s0, 0
      l.s $f20, x_index_start

    # End of row loop
    addi $s1, $s1, 1
    li $t0, FRAMEBUFFER_HEIGHT
    beq $t0, $s1, finish_mandelbrot
    l.s $f4, y_index_increment
    add.s $f21, $f21, $f4
    j row_loop

  finish_mandelbrot:
  addi $sp, $sp, 8
  lw $ra, 16($sp)
  l.s $f20, 12($sp)
  l.s $f21, 8($sp)
  lw $s0, 4($sp)
  lw $s1, 0($sp)
  addi $sp, $sp 20
  jr $ra
  
    
