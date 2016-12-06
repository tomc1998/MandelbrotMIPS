#############
# This file contains functions to deal with complex numbers.
#############

#########################################
# Function complex_add
# Adds 2 complex numbers together
# Args: 
# 4b (Floating point real part A)
# 4b (Floating point imag part A)
# 4b (Floating point real part B)
# 4b (Floating point imag part B)
# Returns:
# f0 = Floating point real part result
# f1 = Floating point imag part result
.globl complex_add
complex_add:
  l.s $f4, 12($sp) # Areal
  l.s $f5, 8($sp)  # Aimag
  l.s $f6, 4($sp)  # Breal
  l.s $f7, 0($sp)  # Bimag
  add.s $f0, $f4, $f6
  add.s $f1, $f5, $f7
  jr $ra

#########################################
# Function complex_mult
# Multiplies 2 complex numbers
# Args: 
# 4b (Floating point real part A)
# 4b (Floating point imag part A)
# 4b (Floating point real part B)
# 4b (Floating point imag part B)
# Returns:
# f0 = Floating point real part result
# f1 = Floating point imag part result
.globl complex_mult
complex_mult:
  l.s $f4, 12($sp)   # Areal
  l.s $f5, 8($sp)   # Aimag
  l.s $f6, 4($sp)   # Breal
  l.s $f7, 0($sp)  # Bimag
  # Calculate real part
  mul.s $f0, $f4, $f6 # Real mult
  mul.s $f8, $f5, $f7 # Imag mult
  sub.s $f0, $f0, $f8
  # Calculate imaginary part
  mul.s $f1, $f4, $f7 
  mul.s $f8, $f5, $f6 
  add.s $f1, $f1, $f8
  jr $ra

#########################################
# Function complex_sq
# Squares a complex number
# Args: 
# 4b (Floating point real part)
# 4b (Floating point imag part)
# Returns:
# f0 = Floating point real part result
# f1 = Floating point imag part result
.globl complex_sq
complex_sq:
  l.s $f4, 4($sp)   # Areal
  l.s $f5, 0($sp)   # Aimag
  # Push ra to stack
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  # Push to stack to call complex_mult
  addi $sp, $sp, -16
  s.s $f4, 12($sp)
  s.s $f5, 8($sp)
  s.s $f4, 4($sp)
  s.s $f5, 0($sp)
  jal complex_mult
  addi $sp, $sp, 16
  # Restore $ra
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $ra
  
#########################################
# Function complex_mod_sq
# Computes the square of the modulus of a given complex number
# Args: 
# 4b (Floating point real part)
# 4b (Floating point imag part)
# Returns:
# f0 = mod^2
.globl complex_mod_sq
complex_mod_sq:
  l.s $f4, 4($sp)
  l.s $f5, 0($sp)
  mul.s $f6, $f4, $f4
  mul.s $f7, $f5, $f5
  add.s $f0, $f6, $f7
  jr $ra
  
  
  
  

