#.section .rodata
#.globl hello
#hello:
#  .string "Hello, World!"

.text
.global main
main:
  and a0, a0, x0
  #ret
