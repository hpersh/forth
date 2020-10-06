/***************************************************************************
 *
 * Constants and macros for x86-64 CPU
 *
 ***************************************************************************/

	.equ	WORD_SIZE,8

	.macro fword x
	.quad	\x
	.endm

	.macro	pusha
	pushq	%rax
	pushq	%rcx
	pushq	%rdx
	pushq	%rbx
	pushq	%rbp
	pushq	%rsi
	pushq	%rdi
	.endm

	.macro	popa
	popq	%rdi
	popq	%rsi
	popq	%rbp
	popq	%rbx
	popq	%rdx
	popq	%rcx
	popq	%rax
	.endm

	.macro	spinit
	movq	$stack_end,%rsp
	.endm

	.macro	rpinit
	movq	$rstack_end,%rdi
	.endm

	.macro	chkstk sup,sdn,rup,rdn
	.ifne \sup
	lea	8*\sup(%rsp),%rax
	cmpq	$stack_end,%rax
	ja	err_stk_unf
	.endif
	.ifne \sdn
	lea	8*\sdn(%rsp),%rax
	cmpq	$stack,%rax
	jb	err_stk_ovf
	.endif
	.ifne \rup
	lea	8*\rup(%rdi),%rax
	cmpq	$rstack_end,%rax
	ja	err_rstk_unf
	.endif
	.ifne \rdn
	lea	8*\rdn(%rdi),%rax
	cmpq	$rstack,%rax
	jb	err_rstk_ovf
	.endif
	.endm

	.macro	pushr r
	lea	-8(%rdi),%rdi
	movq	\r,(%rdi)
	.endm

	.macro	popr r
	movq	(%rdi),\r
	lea	8(%rdi),%rdi
	.endm

	.macro	dropr n
	lea	\n*8(%rdi),%rdi
	.endm
	
	
