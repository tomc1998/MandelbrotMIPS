.text

#########################################
# Function main
# Entry point to program
.globl main
main:

  # Run mandelbrot, populate framebuffer with image
  jal mandelbrot

  # Render image
  jal render

  # Exit
  li $v0, 10
  syscall
