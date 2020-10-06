/***************************************************************************
 *
 * Main source file for i386 CPU on Linux platform
 *
 ***************************************************************************/
	
	.include	"forth_defs_i386.s"
	.include	"forth_defs_shared.s"
	.include	"forth_io_i386_linux.s"
	.include	"forth_i386.s"
	.include	"forth_shared.s"

	.text
	
	_code_hdr 0,"-exit1",linux_exit1
	chkstk 1,0,0,0
	popl	%edi
	call	exit
	jmp	next

	_code_hdr 0,"-exit",linux_exit
	movl	$0,%edi
	call	exit
	jmp	next
