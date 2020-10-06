/***************************************************************************
 *
 * Macros for terminal I/O, for x86-64 CPU on Linux platform
 *
 ***************************************************************************/

	.macro	forth_io_init
	pusha
	call	forth_cio_init
	popa	
	.endm
	
	.macro	forth_emit
	pushq	%rax
	chkstk 0,-256,0,0
	pusha
	movq	7*8(%rsp),%rdi
	call	forth_cio_emit
	popa
	popq	%rax
	.endm

	.macro	forth_key
	chkstk 0,-256,0,0
	pusha
	call	forth_cio_key
	movq	%rax,6*8(%rsp)
	popa
	.endm

	.macro	forth_qkey
	chkstk 0,-256,0,0
	pusha
	call	forth_cio_qkey
	movl	%rax,6*8(%rsp)
	popa
	.endm
