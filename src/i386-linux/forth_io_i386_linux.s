/***************************************************************************
 *
 * Macros for terminal I/O, for i386 CPU on Linux platform
 *
 ***************************************************************************/
	
	.macro	forth_io_init
	pusha
	call	forth_cio_init
	popa	
	.endm
	
	.macro	forth_emit
	pushl	%eax
	chkstk 0,-256,0,0
	pusha
	movl	8*4(%esp),%eax
	pushl	%eax
	call	forth_cio_emit
	popl	%eax
	popa
	popl	%eax
	.endm

	.macro	forth_key
	chkstk 0,-256,0,0
	pusha
	call	forth_cio_key
	movl	%eax,7*4(%esp)
	popa
	.endm

	.macro	forth_qkey
	chkstk 0,-256,0,0
	pusha
	call	forth_cio_qkey
	movl	%eax,7*4(%esp)
	popa
	.endm
