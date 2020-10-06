/***************************************************************************
 *
 * Code words for x86-64 CPU
 *
 ***************************************************************************/

	.equ	debug,1

# IP is %rsi
# SP is %rsp
# RP is %rdi

	.bss

	.ifne debug
	.equ	num_debug_break,16
debug_break:	.space	8*num_debug_break
	.endif

	.text

	.global	next
next:
	.ifne debug
	movq	$debug_break,%rbx
	movq	$num_debug_break,%rcx
next_break_loop:
	orq	%rcx,%rcx
	jz	next2
	cmpq	%rsi,(%rbx)
	jz	next_break_found
	lea	8(%rbx),%rbx
	decq	%rcx
	jmp	next_break_loop
next_break_found:
	nop
	.endif

next2:	
	lodsq	(%rsi),%rax
	movq	%rax,%rbx
	jmpq	*(%rbx)

	.global	doconst
doconst:
	chkstk 0,-1,0,0
	pushq	8(%rbx)
	jmp	next

	.global	dovar
dovar:
	chkstk 0,-1,0,0
	lea	8(%rbx),%rax
	pushq	%rax
	jmp	next

	.global	docol
docol:
	chkstk 0,0,0,-1
	pushr	%rsi
	lea	8(%rbx),%rsi
	jmp	next

	.align	8
dodoes:
	lea	-8(%rsp),%rax
	cmpq	$stack,%rax
	jae	dodoes11
	movq	$err_stk_ovf,%rax
	jmp	*%rax
dodoes11:	
	lea	-8(%rdi),%rax
	cmpq	$rstack,%rax
	jae	dodoes12
	movq	$err_rstk_ovf,%rax
	jmp	*%rax
dodoes12:	
	lea	8(%rbx),%rax
	pushq	%rax
	pushr	%rsi
	call	dodoes2
dodoes2:	
	popq	%rsi
	lea	(dodoes3-dodoes2)(%rsi),%rsi
	movq	$next,%rax
	jmp	*%rax
	.align	8
dodoes3:	


err_div_zero:
	movq	$div_zero_msg,%rax
	jmp	abort2

err_stk_unf:
	movq	$stk_unf_msg,%rax
	jmp	abort2

err_stk_ovf:
	movq	$stk_ovf_msg,%rax
	jmp	abort2

err_rstk_unf:
	movq	$rstk_unf_msg,%rax
	jmp	abort2

err_rstk_ovf:
	movq	$rstk_ovf_msg,%rax

abort2:
	movq	%rax,abort_msg
	movq	$abort3,%rsi
	jmp	next


	.set	_prev,0
	
	
	_code_hdr 0,"!",store
	chkstk 2,0,0,0
	popq	%rbx
	popq	%rax
	movq	%rax,(%rbx)
	jmp	next

	
	_code_hdr 0,"*",star
	chkstk 2,0,0,0
	popq	%rbx
	popq	%rax
	imul	%rbx
	pushq	%rax
	jmp	next


	_code_hdr 0,"*/mod",stslmod
	chkstk 3,0,0,0
	popq	%rcx
	orq	%rcx,%rcx
	jz	err_div_zero
	popq	%rbx
	popq	%rax
	imul	%rbx
	idiv	%rcx
	pushq	%rdx
	pushq	%rax
	jmp	next

	
	_code_hdr 0,"(lit)",lit
	chkstk 0,-1,0,0
	lodsq	(%rsi),%rax
	pushq	%rax
	jmp	next
	

	_code_hdr 0,"+",plus
	chkstk 2,0,0,0
	popq	%rax
	addq	%rax,(%rsp)
	jmp	next


	_code_hdr 0,"-",sub
	chkstk 2,0,0,0
	popq	%rax
	subq	%rax,(%rsp)
	jmp	next


	_code_hdr 0,"<<",lsh
	chkstk 2,0,0,0
	popq	%rcx
	shlq	%cl,(%rsp)
	jmp	next


	_code_hdr 0,">>",rsh
	chkstk 2,0,0,0
	popq	%rcx
	shrq	%cl,(%rsp)
	jmp	next


	_code_hdr 0,";s",semis
	chkstk 0,0,1,0
	popr	%rsi
	jmp	next

	
	_code_hdr 0,"/mod",slmod
	chkstk 2,0,0,0
	popq	%rbx
	orq	%rbx,%rbx
	jz	err_div_zero
	popq	%rax
	cdq
	idiv	%rbx
	pushq	%rdx
	pushq	%rax
	jmp	next


	_code_hdr 0,"0<",zless
	chkstk 1,0,0,0
	xorq	%rbx,%rbx
	movq	(%rsp),%rax
	orq	%rax,%rax
	jns	zless2
	incq	%rbx
zless2:
	movq	%rbx,(%rsp)
	jmp	next


	.align	8
	.set	_cur,.
	strlit "0="
	.quad	_prev
	.set	_prev,_cur
	.global	zequ
	.equ	zequ,.		# cfa
	.quad	.+8
	chkstk 1,0,0,0
	xorq	%rbx,%rbx
	movq	(%rsp),%rax
	orq	%rax,%rax
	jnz	zequ2
	incq	%rbx
zequ2:		
	movq	%rbx,(%rsp)
	jmp	next


	_code_hdr 0,"0branch",zbran
	chkstk 1,0,0,0
	popq	%rax
	orq	%rax,%rax
	jz	bran1
	lea	8(%rsi),%rsi
	jmp	next


	_code_hdr 0,"(do)",xdo
	chkstk 2,0,0,-2
	lea	-16(%rdi),%rdi
	movq	(%rsp),%rax
	movq	%rax,(%rdi)
	movq	8(%rsp),%rax
	movq	%rax,8(%rdi)
	lea	16(%rsp),%rsp
	jmp	next


	_code_hdr 0,"(+loop)",xploop
	chkstk 1,0,2,0
	popq	%rax
xploop2:
	addq	(%rdi),%rax
	cmpq	8(%rdi),%rax
	jl	xploop3
	lea	16(%edi),%edi
	lea	8(%rsi),%rsi
	jmp	next
xploop3:
	movq	%rax,(%rdi)
	jmp	bran1

	
	_code_hdr 0,"(loop)",xloop
	chkstk 0,0,2,0
	movq	$1,%rax
	jmp	xploop2
	

	code_hdr leave
	chkstk 0,0,2,0
	movq	8(%rdi),%rax
	movq	%rax,(%rdi)
	jmp	next
	

	code_hdr i
	chkstk 0,-1,1,0
	pushq	(%rdi)
	jmp	next

	
	_code_hdr 0,"i'",iprime
	chkstk 0,-1,2,0
	pushq	8(%rdi)
	jmp	next


	code_hdr j
	chkstk 0,-1,3,0
	pushq	16(%rdi)
	jmp	next
	
	
	_code_hdr 0,">r",tor
	chkstk 1,0,0,-1
	popq	%rax
	pushr	%rax
	jmp	next


	_code_hdr 0,"?dup",qdup
	chkstk 1,0,0,0
	movq	(%rsp),%rbx
	orq	%rbx,%rbx
	jz	next
	chkstk	0,-1,0,0
	pushq	%rbx
	jmp	next


	_code_hdr 0,"@",at
	chkstk 1,0,0,0
	movq	(%rsp),%rbx
	movq	(%rbx),%rax
	movq	%rax,(%rsp)
	jmp	next


	code_hdr and
	chkstk 2,0,0,0
	popq	%rax
	andq	%rax,(%rsp)
	jmp	next


	_code_hdr 0,"branch",bran
bran1:	
	movq	(%rsi),%rsi
	jmp	next

	
	_code_hdr 0,"c!",cstore
	chkstk 2,0,0,0
	popq	%rbx
	popq	%rax
	movb	%al,(%rbx)
	jmp	next


	_code_hdr 0,"c@",cat
	chkstk 1,0,0,0
	movq	(%rsp),%rbx
	movzxb	(%rbx),%rax
	movq	%rax,(%rsp)
	jmp	next	


	code_hdr depth
	chkstk 0,-1,0,0
	movq	$stack_end,%rax
	subq	%rsp,%rax
	sarq	$3,%rax
	pushq	%rax
	jmp	next


	code_hdr drop
	chkstk 1,0,0,0
	lea	8(%rsp),%rsp
	jmp	next


	code_hdr emit
	chkstk 1,0,0,0
	popq	%rax
	forth_emit
	jmp	next


	code_hdr execute
	chkstk 1,0,0,0
	popq	%rbx
	jmpq	*(%rbx)


	code_hdr key
	chkstk 0,-1,0,0
	forth_key
	pushq	%rax
	jmp	next
	

	code_hdr negate
	chkstk 1,0,0,0
	negq	(%rsp)
	jmp	next


	code_hdr not
	chkstk 1,0,0,0
	notq	(%rsp)
	jmp	next


	code_hdr or
	chkstk 2,0,0,0
	popq	%rax
	orq	%rax,(%rsp)
	jmp	next


	code_hdr pick
	chkstk 1,0,0,0
	movq	(%rsp),%rcx
	incq	%rcx
	lea	(%rsp,%rcx,8),%rbx
	cmpq	$stack_end,%rbx
	jae	err_stk_unf
	movq	(%rbx),%rax
	movq	%rax,(%rsp)	
	jmp	next


	_code_hdr 0,"r>",rfrom
	chkstk 0,-1,1,0
	pushq	(%rdi)
	lea	8(%rdi),%rdi
	jmp	next


	_code_hdr 0,"r",rat
	chkstk 0,-1,1,0
	pushq	(%rdi)
	jmp	next


	code_hdr roll
	chkstk 1,0,0,0
	popq	%rcx
	orq	%rcx,%rcx
	jz	next
	js	roll_dn
	lea	(%rsp,%rcx,8),%rbx
	cmpq	$stack_end,%rbx
	jae	err_stk_unf
	movq	(%rbx),%rdx
roll_loop:
	movq	-8(%rbx),%rax
	movq	%rax,(%rbx)
	lea	-8(%rbx),%rbx
	decq	%rcx
	jnz	roll_loop	
	movq	%rdx,(%rbx)
	jmp	next
roll_dn:	
	negq	%rcx
	lea	(%rsp,%rcx,8),%rbx
	cmpq	$stack_end,%rbx
	jae	err_stk_unf
	movq	%rsp,%rbx
	movq	(%rbx),%rdx
roll_dn_loop:
	movq	8(%rbx),%rax
	movq	%rax,(%rbx)
	lea	8(%rbx),%rbx
	decq	%rcx
	jnz	roll_dn_loop
	movq	%rdx,(%rbx)
	jmp	next


	_code_hdr 0,"rp!",rpstore
	rpinit
	jmp	next

	
	_code_hdr 0,"sp!",spstore
	spinit
	jmp	next
	
	
	_code_hdr 0,"u<",uless
	chkstk 2,0,0,0
	xorq	%rbx,%rbx
	popq	%rax
	cmpq	%rax,(%rsp)
	jnc	uless2
	incq	%rbx
uless2:
	movq	%rbx,(%rsp)
	jmp	next


	_code_hdr 0,"u*",ustar
	chkstk 2,0,0,0
	popq	%rbx
	popq	%rax
	mul	%rbx
	pushq	%rax
	jmp	next


	_code_hdr 0,"u/mod",uslmod
	chkstk 2,0,0,0
	popq	%rbx
	orq	%rbx,%rbx
	jz	err_div_zero
	popq	%rax
	xorq	%rdx,%rdx
	div	%rbx
	pushq	%rdx
	pushq	%rax
	jmp	next


	_code_hdr 0,"u*/mod",ustslmod
	chkstk 3,0,0,0
	popq	%rcx
	orq	%rcx,%rcx
	jz	err_div_zero
	popq	%rbx
	popq	%rax
	mul	%rbx
	div	%rcx
	pushq	%rdx
	pushq	%rax
	jmp	next

	
	code_hdr xor
	chkstk 2,0,0,0
	popq	%rax
	xorq	%rax,(%rsp)
	jmp	next	

	
	_hdr IMMED,"does>",does
	.quad	docol
	.quad	qcomp
	.quad	lit,lit,comma
	.quad	here,lit,5*8,plus,comma
	.quad	lit,latest,comma
	.quad	lit,cfa,comma
	.quad	lit,store,comma
	.quad	lit,semis,comma
	.quad	lit,dodoes,here,lit,dodoes3-dodoes,cmove
	.quad	lit,dodoes3-dodoes,allot
	.quad	semis

	
	_hdr 0,"next",_next
	.quad	docol
	.quad	lit,0xe9,ccomma
	.quad	lit,next,here,lit,8,plus,sub
	.quad	dup,ccomma
	.quad	dup,lit,8,rsh,ccomma
	.quad	dup,lit,16,rsh,ccomma
	.quad	lit,24,rsh,ccomma
	.quad	semis

	.text

	.global	main
main:
	forth_io_init
	cld	
	spinit
	rpinit
	movq	$forth_entry,%rsi
	jmp	next
