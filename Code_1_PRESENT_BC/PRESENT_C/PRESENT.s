	.file	"PRESENT.c"
	.text
	.globl	s_box
	.type	s_box, @function
s_box:
.LFB6:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$176, %rsp
	movq	%rdi, -168(%rbp)
	movq	%rsi, -176(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	$0, -152(%rbp)
	movq	$12, -144(%rbp)
	movq	$5, -136(%rbp)
	movq	$6, -128(%rbp)
	movq	$11, -120(%rbp)
	movq	$9, -112(%rbp)
	movq	$0, -104(%rbp)
	movq	$10, -96(%rbp)
	movq	$13, -88(%rbp)
	movq	$3, -80(%rbp)
	movq	$14, -72(%rbp)
	movq	$15, -64(%rbp)
	movq	$8, -56(%rbp)
	movq	$4, -48(%rbp)
	movq	$7, -40(%rbp)
	movq	$1, -32(%rbp)
	movq	$2, -24(%rbp)
	movl	$0, -156(%rbp)
	jmp	.L2
.L3:
	movl	-156(%rbp), %eax
	sall	$2, %eax
	movq	-168(%rbp), %rdx
	movl	%eax, %ecx
	shrq	%cl, %rdx
	movq	%rdx, %rax
	andl	$15, %eax
	movq	-144(%rbp,%rax,8), %rdx
	movl	-156(%rbp), %eax
	sall	$2, %eax
	movl	%eax, %ecx
	salq	%cl, %rdx
	movq	%rdx, %rax
	orq	%rax, -152(%rbp)
	addl	$1, -156(%rbp)
.L2:
	cmpl	$15, -156(%rbp)
	jbe	.L3
	movq	-176(%rbp), %rax
	movq	-152(%rbp), %rdx
	movq	%rdx, (%rax)
	nop
	movq	-8(%rbp), %rsi
	xorq	%fs:40, %rsi
	je	.L4
	call	__stack_chk_fail@PLT
.L4:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	s_box, .-s_box
	.globl	p_box
	.type	p_box, @function
p_box:
.LFB7:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movq	%rdi, -104(%rbp)
	movq	%rsi, -112(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	$0, -88(%rbp)
	movabsq	$3540129478889967616, %rax
	movabsq	$3684809824566120962, %rdx
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	movabsq	$3829490170242274308, %rax
	movabsq	$3974170515918427654, %rdx
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movabsq	$4118850861594581000, %rax
	movabsq	$4263531207270734346, %rdx
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movabsq	$4408211552946887692, %rax
	movabsq	$4552891898623041038, %rdx
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movl	$0, -92(%rbp)
	jmp	.L6
.L7:
	movl	-92(%rbp), %eax
	movq	-104(%rbp), %rdx
	movl	%eax, %ecx
	shrq	%cl, %rdx
	movq	%rdx, %rax
	andl	$1, %eax
	movq	%rax, %rdx
	movl	-92(%rbp), %eax
	movzbl	-80(%rbp,%rax), %eax
	movzbl	%al, %eax
	movl	%eax, %ecx
	salq	%cl, %rdx
	movq	%rdx, %rax
	orq	%rax, -88(%rbp)
	addl	$1, -92(%rbp)
.L6:
	cmpl	$63, -92(%rbp)
	jbe	.L7
	movq	-112(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rdx, (%rax)
	nop
	movq	-8(%rbp), %rsi
	xorq	%fs:40, %rsi
	je	.L8
	call	__stack_chk_fail@PLT
.L8:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	p_box, .-p_box
	.globl	key_update
	.type	key_update, @function
key_update:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$352, %rsp
	movq	%rdi, -328(%rbp)
	movq	%rsi, -336(%rbp)
	movq	%rdx, -344(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-288(%rbp), %rdx
	movl	$0, %eax
	movl	$32, %ecx
	movq	%rdx, %rdi
	rep stosq
	movabsq	$939563511099819276, %rax
	movabsq	$144404376949034499, %rdx
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-328(%rbp), %rax
	movq	(%rax), %rdx
	movq	-344(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-336(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -288(%rbp)
	movq	$0, -304(%rbp)
	jmp	.L10
.L13:
	movq	-336(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -296(%rbp)
	movq	-296(%rbp), %rax
	salq	$61, %rax
	movq	%rax, %rdx
	movq	-328(%rbp), %rax
	movq	(%rax), %rax
	shrq	$3, %rax
	orq	%rax, %rdx
	movq	-336(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-328(%rbp), %rax
	movq	(%rax), %rax
	salq	$61, %rax
	movq	%rax, %rdx
	movq	-296(%rbp), %rax
	shrq	$3, %rax
	orq	%rax, %rdx
	movq	-328(%rbp), %rax
	movq	%rdx, (%rax)
	movq	$0, -312(%rbp)
	movl	$0, -316(%rbp)
	jmp	.L11
.L12:
	movq	-328(%rbp), %rax
	movq	(%rax), %rax
	shrq	$56, %rax
	movq	%rax, %rdx
	movl	-316(%rbp), %eax
	sall	$2, %eax
	movl	%eax, %ecx
	shrq	%cl, %rdx
	movq	%rdx, %rax
	andl	$15, %eax
	movzbl	-32(%rbp,%rax), %eax
	movzbl	%al, %edx
	movl	-316(%rbp), %eax
	sall	$2, %eax
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	cltq
	movzbl	%al, %eax
	orq	%rax, -312(%rbp)
	addl	$1, -316(%rbp)
.L11:
	cmpl	$1, -316(%rbp)
	jbe	.L12
	movq	-328(%rbp), %rax
	movq	(%rax), %rax
	movabsq	$72057594037927935, %rdx
	andq	%rax, %rdx
	movq	-328(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-328(%rbp), %rax
	movq	(%rax), %rax
	movq	-312(%rbp), %rdx
	salq	$56, %rdx
	orq	%rax, %rdx
	movq	-328(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-336(%rbp), %rax
	movq	(%rax), %rax
	movq	-304(%rbp), %rdx
	addq	$1, %rdx
	salq	$62, %rdx
	xorq	%rax, %rdx
	movq	-336(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-328(%rbp), %rax
	movq	(%rax), %rax
	movq	-304(%rbp), %rdx
	addq	$1, %rdx
	shrq	$2, %rdx
	xorq	%rax, %rdx
	movq	-328(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-304(%rbp), %rax
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-344(%rbp), %rax
	addq	%rax, %rdx
	movq	-328(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, (%rdx)
	movq	-304(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	-336(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -288(%rbp,%rdx,8)
	addq	$1, -304(%rbp)
.L10:
	cmpq	$30, -304(%rbp)
	jbe	.L13
	nop
	movq	-8(%rbp), %rsi
	xorq	%fs:40, %rsi
	je	.L14
	call	__stack_chk_fail@PLT
.L14:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	key_update, .-key_update
	.globl	present_round
	.type	present_round, @function
present_round:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, -32(%rbp)
	cmpq	$30, -24(%rbp)
	ja	.L16
	movq	-8(%rbp), %rax
	xorq	-16(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	leaq	-8(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	s_box
	movq	-8(%rbp), %rax
	leaq	-8(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	p_box
	movq	-8(%rbp), %rdx
	movq	-32(%rbp), %rax
	movq	%rdx, (%rax)
	jmp	.L17
.L16:
	movq	-8(%rbp), %rax
	xorq	-16(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rdx
	movq	-32(%rbp), %rax
	movq	%rdx, (%rax)
.L17:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	present_round, .-present_round
	.section	.rodata
	.align 8
.LC0:
	.string	"\n \342\235\247 PT %02d| :%016lx: (Round key applied::%016lx::)\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$304, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	$0, -296(%rbp)
	movq	$0, -288(%rbp)
	movq	$0, -280(%rbp)
	leaq	-272(%rbp), %rdx
	movl	$0, %eax
	movl	$32, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	-272(%rbp), %rdx
	leaq	-288(%rbp), %rax
	leaq	8(%rax), %rcx
	leaq	-288(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	key_update
	movb	$0, -297(%rbp)
	jmp	.L19
.L20:
	movzbl	-297(%rbp), %edx
	movzbl	-297(%rbp), %eax
	cltq
	movq	-272(%rbp,%rax,8), %rsi
	movq	-296(%rbp), %rax
	leaq	-296(%rbp), %rcx
	movq	%rax, %rdi
	call	present_round
	movzbl	-297(%rbp), %eax
	addl	$1, %eax
	movb	%al, -297(%rbp)
.L19:
	cmpb	$31, -297(%rbp)
	jbe	.L20
	movzbl	-297(%rbp), %eax
	cltq
	movq	-272(%rbp,%rax,8), %rcx
	movq	-296(%rbp), %rdx
	movzbl	-297(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	movq	-8(%rbp), %rsi
	xorq	%fs:40, %rsi
	je	.L22
	call	__stack_chk_fail@PLT
.L22:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
