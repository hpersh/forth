/***************************************************************************
 *
 * CPU-independent macros and constants
 *
 ***************************************************************************/

	.macro _strlit f,s
	.byte	\f|(2f-1f)
1:	
	.ascii	"\s"
2:	
	.align	WORD_SIZE
	.endm

	.macro	strlit s
	_strlit 0,"\s"
	.endm
		
	.macro	_hdr f,name,sym
	.align	WORD_SIZE
	.set	_cur,.
	_strlit \f,"\name"
	fword	_prev
	.global	\sym
	.equ	\sym,.		# cfa
	.set	_prev,_cur
	.set	_dict_last,_cur
	.endm

	.macro	hdr name
	_hdr 0,"\name",\name
	.endm

	.equ	IMMED,0x80
	
	.macro _code_hdr f,name,sym
	_hdr \f,"\name",\sym
	fword	.+WORD_SIZE
	.endm

	.macro code_hdr name
	_code_hdr 0,"\name",\name
	.endm

	.macro _defconst name,sym,val
	_hdr 0,"\name",\sym
	fword	doconst
	fword	\val
	.endm

	.macro defconst name,val
	_defconst "\name",\name,\val
	.endm

	.equ	forth_cr,0xa
	.equ	forth_bs,0x7f
	
