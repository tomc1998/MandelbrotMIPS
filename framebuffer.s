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
.globl framebuffer
framebuffer:
  .space 3200

# Space used when rendering the framebuffer line by line.
# 2 extra byte for the line due to return and terminating NUL char.
line:
  .space 80
  .asciiz "\n"

############# Public functions
.text

# Function render
# Renders the framebuffer (space allocated above).
# Args: None
# Returns: None
.globl render
render:
  


