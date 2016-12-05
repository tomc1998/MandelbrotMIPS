#############
# This file contains utility functions
#############

############# Functions
.text

#########################################
# Function memcpy
# Copies 1 chunk of memory to another.
# Args (In order of being pushed to stack):
# 4b (Destination to copy to)
# 4b (Source to copy from)
# 4b (Size of data to copy)
# Returns: None, but modifies memory at Destination
.globl memcpy
memcpy:
  lw $t0, 8($sp)  # Destination address
  lw $t1, 4($sp)  # Source address
  lw $t2, 0($sp)   # Size of data to copy
  li $t3, 0        # Counter

  memcpy_loop: # Copy bytes
    lb $t4, 0($t1)    # Load byte to copy
    sb $t4, 0($t0)    # Copy byte
    addi $t0, $t0, 1  # Increment counters
    addi $t1, $t1, 1
    addi $t3, $t3, 1
    beq, $t2, $t3, memcpy_exit # Exit loop?
    j memcpy_loop

  memcpy_exit:
  jr $ra
    
  
  


