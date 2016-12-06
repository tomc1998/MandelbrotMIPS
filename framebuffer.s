#############
# This file describes structs and functions used to 'render' a frame buffer
# using ASCII art.
#############

############# Constants
.data

# 80 x 40 framebuffer, 1 byte per pixel
# 0  = no pixel
# 1  = light pixel
# 2  = dark pixel
# >2 = dark as possible
.include "macros.s"
.globl framebuffer
framebuffer:
  .space FRAMEBUFFER_SIZE

# Space used when rendering the framebuffer line by line.
# 2 extra byte for the line due to return and terminating NUL char.
line:
  .space FRAMEBUFFER_WIDTH
  .asciiz "\n"

############# Functions
.text

#########################################
# Function render
# Renders the framebuffer (space allocated above).
# Args: None
# Returns: None
.globl render
render:
  addi $sp, $sp, -20  # Push $ra, $s0, $s1, $s2 then $s3
  sw $ra, 16($sp)
  sw $s0, 12($sp)
  sw $s1, 8($sp)
  sw $s2, 4($sp)
  sw $s3, 0($sp)
  la $s0, framebuffer # Load addresses for memcpy into registers
  la $s1, line
  li $t2, FRAMEBUFFER_WIDTH
  # Load size onto stack for memcpy arg (same size every loop, so only need
  # to load one)
  addi $sp, $sp, -12
  sw $t2, 0($sp)

  li $s2, FRAMEBUFFER_HEIGHT # Load for loop indexes
  li $s3, 0
  render_loop:
    # Copy to line
    sw $s0, 4($sp) # src
    sw $s1, 8($sp) # dest
    jal memcpy
    # Encode line to ascii
    addi $sp, $sp, -8
    li $t0, FRAMEBUFFER_WIDTH
    sw $s1, 4($sp) # Address of line
    sw $t0, 0($sp) # Size of line
    jal ascii_art_encode_line
    addi $sp, $sp, 8
    # Print line
    la $a0, line
    li $v0, 4
    syscall
    
    addi $s0, $s0, FRAMEBUFFER_WIDTH # Increment everything for loop
    addi $s3, $s3, 1
    beq $s3, $s2, render_exit # Exit loop?
    j render_loop

  render_exit:
  addi $sp,    $sp, 12 # Pop function args
  lw   $ra, 16($sp)    # Restore saved registers
  lw   $s0, 12($sp)
  lw   $s1,  8($sp)
  lw   $s2,  4($sp)
  lw   $s3,  0($sp)
  addi $sp,    $sp, 20    # Pop saved registers
  jr   $ra
  
#########################################
# Function ascii_art_encode_line
# Encodes a list of bytes into ASCII chars using the following system:
# 0  = no pixel
# 1  = light pixel
# 2  = dark pixel
# >2 = dark as possible
# Args:
# 4b (Address of line)
# 4b (Length of line)
# Returns: None, but modifies memory at the address of line
.eqv BLANK_PIXEL 0 
.eqv LIGHT_PIXEL 1 
.eqv DARK_PIXEL  2 
.eqv BLANK_PIXEL_SYM 46 # Symbol = .
.eqv LIGHT_PIXEL_SYM 43 # Symbol = +
.eqv DARK_PIXEL_SYM  48 # Symbol = 0
.eqv BLACK_PIXEL_SYM 64 # Symbol = @

ascii_art_encode_line:
  lw $t0 4($sp) # Address of line
  lw $t1 0($sp) # Length of line
  li $t2 0      # Counter for loop
  li $t3 BLANK_PIXEL
  li $t4 LIGHT_PIXEL
  li $t5 DARK_PIXEL
  aael_loop:
    lb  $t6, 0($t0)
    beq $t3, $t6, aael_blank
    beq $t3, $t6, aael_light
    beq $t3, $t6, aael_dark
    j aael_black
    aael_blank:
      li $t6, BLANK_PIXEL_SYM
      sb $t6, 0($t0)
      j end_loop
    aael_light:
      li $t6, LIGHT_PIXEL_SYM
      sb $t6, 0($t0)
      j end_loop
    aael_dark:
      li $t6, DARK_PIXEL_SYM
      sb $t6, 0($t0)
      j end_loop
    aael_black:
      li $t6, BLACK_PIXEL_SYM
      sb $t6, 0($t0)
      j end_loop

    # Increment counters
    end_loop:
    addi $t0, $t0, 1
    addi $t2, $t2, 1
    beq $t1, $t2, ascii_art_encode_line_exit
    j aael_loop
  
  ascii_art_encode_line_exit:
  jr $ra
    
   














 
