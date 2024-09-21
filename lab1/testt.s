    .data
prompt:
    .asciz "Enter a number: "
format_in:
    .asciz "%d"
format_out:
    .asciz "%d\n"

    .text
    .globl main
main:
    # 函数前序，设置栈帧
    addi    sp, sp, -32        # 分配32字节的栈空间
    sw      ra, 28(sp)         # 保存返回地址在 sp + 28
    sw      s0, 24(sp)         # 保存帧指针在 sp + 24
    mv      s0, sp             # 设置帧指针 s0 = sp

    # 初始化变量
    li      t0, 0              # a = 0
    sw      t0, 16(s0)
    li      t0, 1              # b = 1
    sw      t0, 12(s0)
    li      t0, 1              # i = 1
    sw      t0, 8(s0)

    # 输出提示信息
    la      a0, prompt
    call    printf

    # 读取用户输入的 n
    la      a0, format_in
    addi    a1, s0, 0          # &n
    call    scanf

    # 打印初始的两个数字 a 和 b
    lw      a1, 16(s0)         # a1 = a
    la      a0, format_out
    call    printf

    lw      a1, 12(s0)         # a1 = b
    la      a0, format_out
    call    printf

    # 开始循环
loop_start:
    lw      t0, 8(s0)          # t0 = i
    lw      t1, 0(s0)          # t1 = n
    bge     t0, t1, loop_end   # 如果 i >= n，跳出循环

    # t = b;
    lw      t2, 12(s0)         # t2 = b
    sw      t2, 4(s0)          # t = t2

    # b = a + b;
    lw      t3, 16(s0)         # t3 = a
    add     t2, t2, t3         # t2 = b + a
    sw      t2, 12(s0)         # b = t2

    # 打印新的 b 值
    lw      a1, 12(s0)         # a1 = b
    la      a0, format_out
    call    printf

    # a = t;
    lw      t2, 4(s0)          # t2 = t
    sw      t2, 16(s0)         # a = t2

    # i = i + 1;
    lw      t0, 8(s0)          # t0 = i
    addi    t0, t0, 1          # t0 = t0 + 1
    sw      t0, 8(s0)          # i = t0

    j       loop_start         # 回到循环开始

loop_end:
    # 函数后序，恢复栈帧
    lw      ra, 28(sp)         # 恢复返回地址
    lw      s0, 24(sp)         # 恢复帧指针
    addi    sp, sp, 32         # 释放栈空间
    ret                        # 返回

