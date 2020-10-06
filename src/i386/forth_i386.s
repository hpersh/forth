/***************************************************************************
 *
 * Code words for i386 CPU
 *
 ***************************************************************************/	

	.equ	debug,1

# IP	ESI
# SP	ESP
# RP	EDI

	.bss

	.ifne debug
	.equ	num_debug_break,16
debug_break:	.space	4*num_debug_break
	.endif

	.text

	.macro	spinit
	movl	$stack_end,%esp
	.endm

	.macro	rpinit
	movl	$rstack_end,%edi
	.endm

	.macro	chkstk sup,sdn,rup,rdn
	.ifne \sup
	lea	4*\sup(%esp),%eax
	cmpl	$stack_end,%eax
	ja	err_stk_unf
	.endif
	.ifne \sdn
	lea	4*\sdn(%esp),%eax
	cmpl	$stack,%eax
	jb	err_stk_ovf
	.endif
	.ifne \rup
	lea	4*\rup(%edi),%eax
	cmpl	$rstack_end,%eax
	ja	err_rstk_unf
	.endif
	.ifne \rdn
	lea	4*\rdn(%edi),%eax
	cmpl	$rstack,%eax
	jb	err_rstk_ovf
	.endif
	.endm

	.macro	pushr r
	lea	-4(%edi),%edi
	movl	\r,(%edi)
	.endm

	.macro	popr r
	movl	(%edi),\r
	lea	4(%edi),%edi
	.endm

	.macro	dropr n
	lea	\n*4(%edi),%edi
	.endm
	
	.global	next
next:
	.ifne debug
	movl	$debug_break,%ebx
	movl	$num_debug_break,%ecx
next_break_loop:
	orl	%ecx,%ecx
	jz	next2
	cmpl	%esi,(%ebx)
	jz	next_break_found
	lea	4(%ebx),%ebx
	decl	%ecx
	jmp	next_break_loop
next_break_found:
	nop
	.endif

next2:	
	lodsl	(%esi),%eax
	movl	%eax,%ebx
	jmpl	*(%ebx)

	.global	doconst
doconst:
	chkstk 0,-1,0,0
	pushl	4(%ebx)
	jmp	next

	.global	dovar
dovar:
	chkstk 0,-1,0,0
	lea	4(%ebx),%eax
	pushl	%eax
	jmp	next

	.global	docol
docol:
	chkstk 0,0,0,-1
	pushr	%esi
	lea	4(%ebx),%esi
	jmp	next

	.align	4
dodoes:
	lea	-8(%esp),%eax
	cmpl	$stack,%eax
	jae	dodoes11
	movl	$err_stk_ovf,%eax
	jmp	*%eax
dodoes11:	
	lea	-4(%edi),%eax
	cmpl	$rstack,%eax
	jae	dodoes12
	movl	$err_rstk_ovf,%eax
	jmp	*%eax
dodoes12:	
	lea	4(%ebx),%eax
	pushl	%eax
	pushr	%esi
	call	dodoes2
dodoes2:	
	popl	%esi
	lea	(dodoes3-dodoes2)(%esi),%esi
	movl	$next,%eax
	jmp	*%eax
	.align	4
dodoes3:	


err_div_zero:
	movl	$div_zero_msg,%eax
	jmp	abort2

err_stk_unf:
	movl	$stk_unf_msg,%eax
	jmp	abort2

err_stk_ovf:
	movl	$stk_ovf_msg,%eax
	jmp	abort2

err_rstk_unf:
	movl	$rstk_unf_msg,%eax
	jmp	abort2

err_rstk_ovf:
	movl	$rstk_ovf_msg,%eax

abort2:
	movl	%eax,abort_msg
	movl	$abort3,%esi
	jmp	next


	.set	_prev,0
	
	
	_code_hdr 0,"!",store
	chkstk 2,0,0,0
	popl	%ebx
	popl	%eax
	movl	%eax,(%ebx)
	jmp	next

	
	_code_hdr 0,"*",star
	chkstk 2,0,0,0
	popl	%ebx
	popl	%eax
	imul	%ebx
	pushl	%eax
	jmp	next


	_code_hdr 0,"*/mod",stslmod
	chkstk 3,0,0,0
	popl	%ecx
	orl	%ecx,%ecx
	jz	err_div_zero
	popl	%ebx
	popl	%eax
	imul	%ebx
	idiv	%ecx
	pushl	%edx
	pushl	%eax
	jmp	next

	
	_code_hdr 0,"(lit)",lit
	chkstk 0,-1,0,0
	lodsl	(%esi),%eax
	pushl	%eax
	jmp	next
	

	_code_hdr 0,"+",plus
	chkstk 2,0,0,0
	popl	%eax
	addl	%eax,(%esp)
	jmp	next


	_code_hdr 0,"-",sub
	chkstk 2,0,0,0
	popl	%eax
	subl	%eax,(%esp)
	jmp	next


	_code_hdr 0,"<<",lsh
	chkstk 2,0,0,0
	popl	%ecx
	shll	%cl,(%esp)
	jmp	next


	_code_hdr 0,">>",rsh
	chkstk 2,0,0,0
	popl	%ecx
	shrl	%cl,(%esp)
	jmp	next


	_code_hdr 0,";s",semis
	chkstk 0,0,1,0
	popr	%esi
	jmp	next

	
	_code_hdr 0,"/mod",slmod
	chkstk 2,0,0,0
	popl	%ebx
	orl	%ebx,%ebx
	jz	err_div_zero
	popl	%eax
	cdq
	idiv	%ebx
	pushl	%edx
	pushl	%eax
	jmp	next


	_code_hdr 0,"0<",zless
	chkstk 1,0,0,0
	xorl	%ebx,%ebx
	movl	(%esp),%eax
	orl	%eax,%eax
	jns	zless2
	incl	%ebx
zless2:
	movl	%ebx,(%esp)
	jmp	next


	.align	4
	.set	_cur,.
	strlit "0="
	.long	_prev
	.set	_prev,_cur
	.global	zequ
	.equ	zequ,.		# cfa
	.long	.+4
	chkstk 1,0,0,0
	xorl	%ebx,%ebx
	movl	(%esp),%eax
	orl	%eax,%eax
	jnz	zequ2
	incl	%ebx
zequ2:		
	movl	%ebx,(%esp)
	jmp	next


	_code_hdr 0,"0branch",zbran
	chkstk 1,0,0,0
	popl	%eax
	orl	%eax,%eax
	jz	bran1
	lea	4(%esi),%esi
	jmp	next


	_code_hdr 0,">r",tor
	chkstk 1,0,0,-1
	popl	%eax
	pushr	%eax
	jmp	next


	_code_hdr 0,"?dup",qdup
	chkstk 1,0,0,0
	movl	(%esp),%ebx
	orl	%ebx,%ebx
	jz	next
	chkstk	0,-1,0,0
	pushl	%ebx
	jmp	next


	_code_hdr 0,"@",at
	chkstk 1,0,0,0
	movl	(%esp),%ebx
	movl	(%ebx),%eax
	movl	%eax,(%esp)
	jmp	next


	code_hdr and
	chkstk 2,0,0,0
	popl	%eax
	andl	%eax,(%esp)
	jmp	next


	_code_hdr 0,"branch",bran
bran1:	
	movl	(%esi),%esi
	jmp	next

	
	_code_hdr 0,"c!",cstore
	chkstk 2,0,0,0
	popl	%ebx
	popl	%eax
	movb	%al,(%ebx)
	jmp	next


	_code_hdr 0,"c@",cat
	chkstk 1,0,0,0
	movl	(%esp),%ebx
	movzxb	(%ebx),%eax
	movl	%eax,(%esp)
	jmp	next	


	code_hdr depth
	chkstk 0,-1,0,0
	movl	$stack_end,%eax
	subl	%esp,%eax
	sarl	$2,%eax
	pushl	%eax
	jmp	next


	code_hdr drop
	chkstk 1,0,0,0
	lea	4(%esp),%esp
	jmp	next


	code_hdr emit
	chkstk 1,0,0,0
	popl	%eax
	forth_emit
	jmp	next


	code_hdr execute
	chkstk 1,0,0,0
	popl	%ebx
	jmpl	*(%ebx)


	code_hdr key
	chkstk 0,-1,0,0
	forth_key
	pushl	%eax
	jmp	next
	

	code_hdr negate
	chkstk 1,0,0,0
	negl	(%esp)
	jmp	next


	code_hdr not
	chkstk 1,0,0,0
	notl	(%esp)
	jmp	next


	code_hdr or
	chkstk 2,0,0,0
	popl	%eax
	orl	%eax,(%esp)
	jmp	next


	code_hdr pick
	chkstk 1,0,0,0
	movl	(%esp),%ecx
	incl	%ecx
	lea	(%esp,%ecx,4),%ebx
	cmpl	$stack_end,%ebx
	jae	err_stk_unf
	movl	(%ebx),%eax
	movl	%eax,(%esp)	
	jmp	next


	_code_hdr 0,"r>",rfrom
	chkstk 0,-1,1,0
	pushl	(%edi)
	lea	4(%edi),%edi
	jmp	next


	_code_hdr 0,"r@",rat
	chkstk 0,-1,1,0
	pushl	(%edi)
	jmp	next


	code_hdr roll
	chkstk 1,0,0,0
	popl	%ecx
	orl	%ecx,%ecx
	jz	next
	js	roll_dn
	lea	(%esp,%ecx,4),%ebx
	cmpl	$stack_end,%ebx
	jae	err_stk_unf
	movl	(%ebx),%edx
roll_loop:
	movl	-4(%ebx),%eax
	movl	%eax,(%ebx)
	lea	-4(%ebx),%ebx
	decl	%ecx
	jnz	roll_loop	
	movl	%edx,(%ebx)
	jmp	next
roll_dn:	
	negl	%ecx
	lea	(%esp,%ecx,4),%ebx
	cmpl	$stack_end,%ebx
	jae	err_stk_unf
	movl	%esp,%ebx
	movl	(%ebx),%edx
roll_dn_loop:
	movl	4(%ebx),%eax
	movl	%eax,(%ebx)
	lea	4(%ebx),%ebx
	decl	%ecx
	jnz	roll_dn_loop
	movl	%edx,(%ebx)
	jmp	next


	_code_hdr 0,"rp!",rpstore
	rpinit
	jmp	next

	
	_code_hdr 0,"sp!",spstore
	spinit
	jmp	next
	
	
	_code_hdr 0,"u<",uless
	chkstk 2,0,0,0
	xorl	%ebx,%ebx
	popl	%eax
	cmpl	%eax,(%esp)
	jnc	uless2
	incl	%ebx
uless2:
	movl	%ebx,(%esp)
	jmp	next


	_code_hdr 0,"u*",ustar
	chkstk 2,0,0,0
	popl	%ebx
	popl	%eax
	mul	%ebx
	pushl	%eax
	jmp	next


	_code_hdr 0,"u/mod",uslmod
	chkstk 2,0,0,0
	popl	%ebx
	orl	%ebx,%ebx
	jz	err_div_zero
	popl	%eax
	xorl	%edx,%edx
	div	%ebx
	pushl	%edx
	pushl	%eax
	jmp	next


	_code_hdr 0,"u*/mod",ustslmod
	chkstk 3,0,0,0
	popl	%ecx
	orl	%ecx,%ecx
	jz	err_div_zero
	popl	%ebx
	popl	%eax
	mul	%ebx
	div	%ecx
	pushl	%edx
	pushl	%eax
	jmp	next

	
	code_hdr xor
	chkstk 2,0,0,0
	popl	%eax
	xorl	%eax,(%esp)
	jmp	next	

	
	_hdr IMMED,"does>",does
	.long	docol
	.long	qcomp
	.long	lit,lit,comma
	.long	here,lit,5*4,plus,comma
	.long	lit,latest,comma
	.long	lit,cfa,comma
	.long	lit,store,comma
	.long	lit,semis,comma
	.long	lit,dodoes,here,lit,dodoes3-dodoes,cmove
	.long	lit,dodoes3-dodoes,allot
	.long	semis

	
	_hdr 0,"next",_next
	.long	docol
	.long	lit,0xe9,ccomma
	.long	lit,next,here,lit,4,plus,sub
	.long	dup,ccomma
	.long	dup,lit,8,rsh,ccomma
	.long	dup,lit,16,rsh,ccomma
	.long	lit,24,rsh,ccomma
	.long	semis


	.global code_last
	.equ	code_last,_prev

	.text

	.global	main
main:
	cld	
	spinit
	rpinit
	forth_io_init
	movl	$forth_entry,%esi
	jmp	next
