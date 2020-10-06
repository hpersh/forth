/***************************************************************************
 *
 * Main source file for x86-64 CPU in Linux platform
 *
 ***************************************************************************/

	.include	"forth_defs_x86-64.s"
	.include	"forth_defs_shared.s"
	.include	"forth_io_x86-64_linux.s"
	.include	"forth_x86-64.s"

	.text
	
	_code_hdr 0,"-exit1",linux_exit1
	chkstk 1,0,0,0
	call	forth_cio_restore
	popq	%rdi
	call	exit
	jmp	next

	_code_hdr 0,"-exit",linux_exit
	call	forth_cio_restore
	movq	$0,%rdi
	call	exit
	jmp	next

	.include	"forth_shared.s"


	
	
