    .data
    .align 3
prompt_msg:     .asciz "Please enter 5 floating-point numbers:"    # 提示信息
input_msg:      .asciz "Enter number %d: "                           # 输入提示
format_float:   .asciz "%lf"                                         # scanf格式
sum_msg:        .asciz "The sum of the 5 floating-point numbers is: %.2f\n"  # 输出提示

    .text
    .align 1
    .globl main
    .type main, @function

main:
    # 保存返回地址和帧指针
    addi sp, sp, -208            # 分配栈空间：80字节（浮点数存储）+ 128字节（可变参数区域）
    sd ra, 200(sp)               # 保存返回地址
    sd s0, 192(sp)               # 保存帧指针
    addi s0, sp, 208             # 设置帧指针为栈顶

    # 保存需要在函数调用后保持的寄存器
    sd s1, 184(sp)               # 保存 s1（循环计数器）
    fsd fs0, 176(sp)             # 保存 fs0（浮点数总和）

    # 初始化总和为0.0，初始化循环计数器
    fmv.d.x fs0, zero            # 将 fs0 初始化为 0.0（总和，双精度）
    li s1, 0                     # 循环计数器 s1 = 0

    # 打印提示信息
    lui a5, %hi(prompt_msg)
    addi a0, a5, %lo(prompt_msg)
    call puts

loop_input:
    li t0, 5                     # t0 = 5，循环次数
    bge s1, t0, sum_output       # 如果 s1 >= 5，跳转到 sum_output

    # 提示用户输入第几个数
    lui a5, %hi(input_msg)
    addi a0, a5, %lo(input_msg)
    addi a1, s1, 1               # a1 = s1 + 1
    call printf

    # 为可变参数函数调整栈指针，使其16字节对齐
    addi sp, sp, -16             # 调整栈指针

    # 读取用户输入的浮点数
    lui a5, %hi(format_float)
    addi a0, a5, %lo(format_float)

    # 计算存储输入浮点数的地址
    addi t1, s0, -208            # t1 = s0 - 208（浮点数数组起始地址）
    slli t2, s1, 3               # t2 = s1 * 8（偏移量，双精度浮点数占8字节）
    add t3, t1, t2               # t3 = t1 + t2（当前浮点数的存储地址）
    mv a1, t3                    # a1 = t3

    call scanf

    addi sp, sp, 16              # 恢复栈指针

    # 计算存储输入浮点数的地址
    addi t1, s0, -208            # t1 = s0 - 208（浮点数数组起始地址）
    slli t2, s1, 3               # t2 = s1 * 8（偏移量，双精度浮点数占8字节）
    add t3, t1, t2               # t3 = t1 + t2（当前浮点数的存储地址）
    mv a1, t3                    # a1 = t3

    # 从栈中加载浮点数并累加到总和
    fld ft0, 0(t3)               # 加载输入的浮点数到 ft0
    fadd.d fs0, fs0, ft0         # 累加到总和 fs0

    # 循环计数器加1
    addi s1, s1, 1
    j loop_input

sum_output:
    # 输出总和
    lui a5, %hi(sum_msg)
    addi a0, a5, %lo(sum_msg)

    # 为可变参数函数调整栈指针，使其16字节对齐
    addi sp, sp, -16

    # 准备浮点数参数
    fmv.x.d a1,fs0               # 将总和 fs0 移动到 fa0，供 printf 使用

    call printf

    addi sp, sp, 16              # 恢复栈指针

    # 恢复保存的寄存器和栈指针
    fld fs0, 176(sp)             # 恢复 fs0
    ld s1, 184(sp)               # 恢复 s1
    ld s0, 192(sp)               # 恢复 s0
    ld ra, 200(sp)               # 恢复 ra
    addi sp, sp, 208             # 恢复栈指针
    li a0, 0                     # 返回值 0
    ret
