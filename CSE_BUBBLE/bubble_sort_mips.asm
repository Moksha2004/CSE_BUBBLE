.data
n: .word 5 #enter the size of the array to be sorted here.
arr: .word 5 4 3 2 1
next: .asciiz " "  #Just space defined
.text
.globl main
main:
  la $a0, arr  # $a0 stores the address of arr[0]
  li $s0, 5    # $s0=n
   addi $s4, $s0, -1  # $s4=n-1
  #li $s4, 4
Bubble_sort:
li $s1, 1   #$s1=k
li $t0, -1    #$t0=i
    loop_1:
    addi $t0, $t0, 1  #i++
    slt $t1, $t0, $s4   #if i>=n-1, you exit!
    beq $t1, $zero, EXIT
    sll $t2, $t0, 2   #$t2=i*4
    add $a1, $t2, $a0  #$a1=&arr[i]
    addi $a3, $a1, 4
    lw $s2, 0($a1)  #$s2=arr[i] 
    lw $t5, 0($a3)  #$t5=arr[i+1] 
    slt $t3, $t5, $s2  
    beq $t3, $zero, swap 
        
        lw $a2, 0($a3)  #$a2=t=a[i+1]
        sw $s2, 0($a3)  # a[i+1]=a[i]
        sw $a2, 0($a1)  # a[i]=t
        add $s1, $zero , $zero      # k=0
        swap:
        beq $s1, $zero, Bubble_sort
    j loop_1
EXIT:
    li $t0, 0    # loop counter
    li $s0, 0
    li $t1, 5    # array size
loop:
    bge $s0, $t1, exit
    lw $a0, arr($t0)

    li $v0, 1   
    syscall
    li $a0, ' '   
    li $v0, 11   
    syscall
    addi $t0, $t0, 4   
    addi $s0, $s0, 1
    j loop
exit:
    li $v0, 10   
    syscall