# Jace Laquerre
# RISC-V

jal x0, main        # run main

intdiv:
blt a0, a3, crash   # crash if numer < 0
blt a1, a3, crash   # crash if denom < 0
beq a1, a3, crash   # crash if denom == 0

addi sp, sp, -32    # reserve 8 words on the stack
sw ra, 12(sp)       # save ra on the stack
sw s0, 8(sp)        # save s0 on the stack
addi s0, sp, 16     # s0 <- sp + 16
sw a0, -12(s0)      # save a0 on the stack
sw a1, -16(s0)      # save a1 on the stack

addi a0, x0, 0      # set a0 to 0
sw a0, -20(s0)      # store a0 in mem[s0-20] : this is sum (result of division)
lw a0, -12(s0)      # load a0 from the stack
lw a1, -16(s0)      # load a1 from the stack
                                                                              
blt a1, a0, Loop    # denom < numer
beq a1, a0, Loop    # denom == numer

Loop:
sub a0, a0, a1      # numer = numer - denom
sw a0, -12(s0)      # save a0 on the stack
lw a0, -20(s0)      # load sum from the stack
addi a0, a0, 1      # set a0 to a0 += 1         
sw a0, -20(s0)      # save a0 (sum) on the stack
lw a0, -12(s0)      # load a0 from the stack
blt a1, a0, Loop    # denom < numer then Loop
beq a1, a0, Loop    # denom == numer then Loop

lw a0, -20(s0)      # load a0 (sum) from the stack
lw s0, 8(sp)        # restore s0
lw ra, 12(sp)       # restore ra
lw s0, 8(sp)        # load s0 from mem[sp+8]
lw ra, 12(sp)       # load ra from mem[sp+12]
addi sp, sp, 20     # sp ¬ sp + 20
jalr x0, ra, 0      # jump to return address

crash:
beq x0, x0, 1       # error checking crash

mean:
addi sp, sp, -32    # reserve 8 words on the stack
sw ra, 12(sp)       # save ra on the stack
sw s0, 8(sp)        # save s0 on the stack
addi s0, sp, 16     # s0 <- sp + 16
sw a0, -12(s0)      # save a0 on the stack
sw a1, -16(s0)      # save a1 on the stack 

addi a0, x0, 0      # a0 <- 0
addi a2, x0, 0      # a2 <- 0
sw a0, -12(s0)      # save i to mem[s0-12]
addi sp, x0, 0      # set the stack pointer 

L1:
lw a0, 0(sp)        # load first num from mem[sp]
add a2, a2, a0      # a2 += a0
lw a0, -12(s0)      # load i from mem[s0 -12]
addi a0, a0, 1      # i += 1
sw a0, -12(s0)      # save i to mem[s0-12]
lw a0, -12(s0)      # load i from mem[s0 -12]
addi sp, sp, 4      # set the stack pointer 
blt a0, a1, L1      # if count > i

add a0, x0, a2      # set a0 to a2 (total)
add a1, x0, a1      # set a1 to count
addi sp, x0, 64     # reset stack pointer 
jal ra, intdiv      # save PC in ra and jump to label intdiv (function call)
jalr x0, ra, 0      # jump to return address
addi sp, sp, 64     # restore sp: sp ¬ sp + 64

main:
addi sp, x0, 64     # set stack pointer memory to not zero
addi a0, x0, 0      # a0 <- 0
addi a1, x0, 2      # a1 <- 2
sw a1, 0(x0)        # mem[0] <- a1
addi a1, x0, 7      # a1 <- 7
sw a1, 4(x0)        # mem[4] <- a1
addi a1, x0, 5      # a1 <- 5
sw a1, 8(x0)        # mem[8] <- a1
addi a1, x0, 3      # a1 <- 3 (this is the count)
addi sp, x0, 100    # sp <- 100
jal ra, mean        # call mean function
