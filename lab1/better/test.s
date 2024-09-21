    .data
    .align 3
prompt_msg:     .asciz "Please enter 5 floating-point numbers:\n"    # 提示信息
input_msg:      .asciz "Enter number %d: "                           # 输入提示
format_float:   .asciz "%lf"                                         # scanf格式
sum_msg:        .asciz "The sum of the 5 floating-point numbers is: %.2f\n"  # 输出提示
    
    .text
    .align 1
    .globl main
    .type main, @function

main:
    # 保存返回地址和帧指针，分配48字节栈空间
    addi sp, sp, -48             # 分配栈空间：40字节（寄存器保存） + 8字节（临时浮点数存储）
    sd ra, 40(sp)                # 保存返回地址
    sd s0, 32(sp)                # 保存帧指针
    addi s0, sp, 48              # 设置帧指针为栈顶

    # 保存需要在函数调用后保持的寄存器
    sd s1, 24(sp)                # 保存 s1（循环计数器）
    fsd fs0, 16(sp)              # 保存 fs0（浮点数总和）

    # 初始化总和为0.0，初始化循环计数器
    fmv.d.x fs0, zero            # 将 fs0 初始化为 0.0（总和，双精度）
    li s1, 0                     # 循环计数器 s1 = 0

    # 打印提示信息
    lui a5, %hi(prompt_msg)      # 加载高位地址
    addi a0, a5, %lo(prompt_msg) # 加载完整地址到 a0
    call puts                    # 调用 puts 打印提示信息

loop_input:
    li t0, 5                     # t0 = 5，循环次数
    bge s1, t0, sum_output       # 如果 s1 >= 5，跳转到 sum_output

    # 提示用户输入第几个数
    lui a5, %hi(input_msg)       # 加载高位地址
    addi a0, a5, %lo(input_msg)  # 加载完整地址到 a0
    addi a1, s1, 1               # a1 = s1 + 1
    call printf                  # 调用 printf 打印输入提示

    # 为可变参数函数调整栈指针，使其16字节对齐
    addi sp, sp, -16             # 调整栈指针

    # 读取用户输入的浮点数
    lui a5, %hi(format_float)    # 加载高位地址
    addi a0, a5, %lo(format_float) # 加载完整地址到 a0

    # 设置 scanf 的参数，a1 指向临时存储地址（sp）
    mv a1, sp                    # a1 = sp

    call scanf                   # 调用 scanf 读取浮点数

    addi sp, sp, 16              # 恢复栈指针

    # 从临时存储加载浮点数并累加到总和
    fld ft0, 0(sp)               # 加载输入的浮点数到 ft0
    fadd.d fs0, fs0, ft0         # 累加到总和 fs0

    # 循环计数器加1
    addi s1, s1, 1               # s1 = s1 + 1
    j loop_input                 # 跳回循环开始

sum_output:
    # 输出总和
    lui a5, %hi(sum_msg)         # 加载高位地址
    addi a0, a5, %lo(sum_msg)    # 加载完整地址到 a0

    # 为可变参数函数调整栈指针，使其16字节对齐
    addi sp, sp, -16             # 调整栈指针

    # 将总和 fs0 存储到栈顶，作为 printf 的参数
    fsd fs0, 0(sp)               # 将 fs0 存储到 0(sp)

    call printf                  # 调用 printf 输出总和

    addi sp, sp, 16              # 恢复栈指针

    # 恢复保存的寄存器和栈指针
    fld fs0, 16(sp)              # 恢复 fs0
    ld s1, 24(sp)                # 恢复 s1
    ld s0, 32(sp)                # 恢复 s0
    ld ra, 40(sp)                # 恢复 ra
    addi sp, sp, 48              # 恢复栈指针
    li a0, 0                     # 设置返回值为0
    ret                          # 返回

