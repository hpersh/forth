/***************************************************************************
 *
 * CPU-independent variables, constants, words, etc.
 *
 ***************************************************************************/
	
	.bss

	.equ	stack_size,8192*WORD_SIZE
	.equ	rstack_size,1024*WORD_SIZE
	
	.global	stack
stack:	.space	stack_size
	.global	stack_end
	.equ	stack_end,.
	.global	rstack
rstack:	.space	rstack_size
	.global	rstack_end
	.equ	rstack_end,.

user_vars:
	.global	_base
_base:		.space	WORD_SIZE
	.global	_current
_current:	.space	WORD_SIZE
	.global	_fence
_fence:		.space	WORD_SIZE
	.global	_h
_h:		.space	WORD_SIZE
	.global	_span
_span:		.space	WORD_SIZE
	.global	_state
_state:		.space	WORD_SIZE
	.global	_toin
_toin:		.space	WORD_SIZE
	.equ	tibsize,256
	.global	_tib
_tib:		.space	tibsize

	.global	abort_msg
abort_msg:	.space	WORD_SIZE
	
	.text

	.global	div_zero_msg
div_zero_msg:
	strlit "Divide by zero"

	.global	stk_unf_msg
stk_unf_msg:
	strlit "Stack underflow"

	.global stk_ovf_msg
stk_ovf_msg:
	strlit "Stack overflow"

	.global rstk_unf_msg
rstk_unf_msg:
	strlit "Return stack underflow"

	.global rstk_ovf_msg
rstk_ovf_msg:
	strlit "Return stack overflow"


err_syntax:	
	fword	xdotq
	strlit "Syntax error"
	fword	_abort
	
err_not_found:
	fword	count
	fword	lit
	fword	0x7f
	fword	and
	fword	type
	fword	xdotq
	strlit ": Word not found"
	fword	_abort
	
	defconst "base",_base
	defconst "current",_current
	defconst "fence",_fence
	defconst "h",_h
	defconst "span",_span
	defconst "state",_state
	_defconst ">in",toin,_toin
	defconst "tib",_tib


	_hdr 0,"#",sharp
	fword	docol
	fword	base
	fword	at
	fword	uslmod
	fword	swap
	fword	dup
	fword	lit
	fword	9
	fword	greater
	fword	zbran
	fword	sharp2
	fword	lit
	fword	7
	fword	plus
sharp2:
	fword	lit
	fword	0x30
	fword	plus
	fword	hold
	fword	semis

	_hdr 0,"#s",sharps
	fword	docol
sharps_loop:
	fword	dup
	fword	zbran
	fword	sharps2
	fword	sharp
	fword	bran
	fword	sharps_loop
sharps2:	
	fword	semis
	
	_hdr 0,"#>",shless
	fword	docol
	fword	drop
	fword	drop
	fword	pad
	fword	onep
	fword	pad
	fword	dup
	fword	cat
	fword	lit
	fword	2
	fword	star
	fword	plus
	fword	pad
	fword	cat
shless_loop:
	fword	qdup
	fword	zbran
	fword	shless2
	fword	lit
	fword	2
	fword	pick
	fword	cat
	fword	lit
	fword	2
	fword	pick
	fword	cstore
	fword	rot
	fword	onep
	fword	rot
	fword	onem
	fword	rot
	fword	onem
	fword	bran
	fword	shless_loop
shless2:	
	fword	swap
	fword	drop
	fword	onep
	fword	pad
	fword	cat
	fword	semis

	.align	WORD_SIZE
	.set	_cur,.
	.byte	2f-1f
1:
	.byte	0x28,0x2e,0x22,0x29 # (.")
2:	
	.align	WORD_SIZE
	fword	_prev
	.set	_prev,_cur
	.equ	xdotq,.
	fword	docol
	fword	rfrom
	fword	dup
	fword	count
	fword	type
	fword	count
	fword	plus
	fword	lit
	fword	(WORD_SIZE-1)
	fword	plus
	fword	lit
	fword	~(WORD_SIZE-1)
	fword	and
	fword	tor
	fword	semis

	_hdr 0,"+!",pstore
	fword	docol
	fword	swap
	fword	over
	fword	at
	fword	plus
	fword	swap
	fword	store
	fword	semis	
	
	_hdr 0,"*/",stslash
	fword	docol
	fword	stslmod
	fword	swap
	fword	drop
	fword	semis

	_hdr 0,"/",slash
	fword	docol
	fword	slmod
	fword	swap
	fword	drop
	fword	semis

	_hdr 0,",",comma
	fword	docol
	fword	here
	fword	store
	fword	lit
	fword	WORD_SIZE
	fword	allot
	fword	semis

	_hdr 0,"c,",ccomma
	fword	docol
	fword	here
	fword	cstore
	fword	lit
	fword	1
	fword	allot
	fword	semis

	_hdr 0,".",dot
	fword	docol
	fword	lesssh
	fword	sharp
	fword	sharps
	fword	sign
	fword	shless
	fword	type
	fword	semis

	_hdr 0,"u.",udot
	fword	docol
	fword	lessshu
	fword	sharp
	fword	sharps
	fword	shless
	fword	type
	fword	semis	
	
	.align	WORD_SIZE
	.set	_cur,.
	.byte	IMMED|(2f-1f)
1:
	.byte	0x2e,0x22	# ."
2:	
	.align	WORD_SIZE
	fword	_prev
	.equ	dotq,.		# cfa
	.set	_prev,_cur
	fword	docol
	fword	lit
	fword	0x22
	fword	word
	fword	dup
	fword	cat
	fword	zbran
	fword	err_syntax
	fword	state
	fword	at
	fword	zbran
	fword	dotq2
	fword	lit
	fword	xdotq
	fword	comma
	fword	here
	fword	over
	fword	cat
	fword	onep
	fword	cmove
	fword	here
	fword	cat
	fword	lit
	fword	WORD_SIZE
	fword	plus
	fword	lit
	fword	~(WORD_SIZE-1)
	fword	and
	fword	allot
	fword	semis
dotq2:
	fword	count
	fword	type
	fword	semis	
	
	_hdr 0,"0>",zgreater
	fword	docol
	fword	negate
	fword	zless
	fword	semis	

	_hdr 0,"1+",onep
	fword	docol
	fword	lit
	fword	1
	fword	plus
	fword	semis

	_hdr 0,"1-",onem
	fword	docol
	fword	lit
	fword	1
	fword	sub
	fword	semis

	_hdr 0,"2+",twop
	fword	docol
	fword	lit
	fword	2
	fword	plus
	fword	semis

	_hdr 0,"2-",twom
	fword	docol
	fword	lit
	fword	2
	fword	sub
	fword	semis

	_hdr 0,"2/",twod
	fword	docol
	fword	lit
	fword	2
	fword	slash
	fword	semis

	_hdr 0,"<",less
	fword	docol
	fword	sub
	fword	zless
	fword	semis
	
	_hdr 0,"<#",lesssh
	fword	docol
	fword	dup
	fword	abs
	fword	lit
	fword	0
	fword	pad
	fword	cstore
	fword	semis

	_hdr 0,"<#u",lessshu
	fword	docol
	fword	lit
	fword	0
	fword	swap
	fword	lit
	fword	0
	fword	pad
	fword	cstore
	fword	semis

	_hdr 0,"=",equal
	fword	docol
	fword	sub
	fword	zequ
	fword	semis

	_hdr 0,">",greater
	fword	docol
	fword	swap
	fword	less
	fword	semis
	
	_hdr 0,"?",quest
	fword	docol
	fword	at
	fword	dot
	fword	semis

	_hdr IMMED,"[",lbrac
	fword	docol
	fword	lit
	fword	0
	fword	state
	fword	store
	fword	semis

	_hdr 0,"]",rbrac
	fword	docol
	fword	lit
	fword	1
	fword	state
	fword	store
	fword	semis

	_hdr 0,"?compiling",qcomp
	fword	docol
	fword	state
	fword	at
	fword	zequ
	fword	xabortq
	strlit "Not compiling"
	fword	semis

	_hdr 0,":",colon
	fword	docol
	fword	create
	fword	lit
	fword	docol
	fword	here
	fword	lit
	fword	-WORD_SIZE
	fword	plus
	fword	store
	fword	rbrac
	fword	semis

	_hdr IMMED,";",semic
	fword	docol
	fword	forth_exit
	fword	lbrac
	fword	semis

	_hdr 0,"'",tick
	fword	docol
	fword	bl
	fword	word
	fword	dup
	fword	cat
	fword	zbran
	fword	err_syntax
	fword	find
	fword	zbran
	fword	err_not_found
	fword	cfa
	fword	semis

	_hdr IMMED,"(",paren
	fword	docol
	fword	lit
	fword	')'
	fword	word
	fword	drop
	fword	semis

	.align	WORD_SIZE
	.set	_cur,.
	.byte	2f-1f
1:
	.byte	0x28,0x61,0x62,0x6f,0x72,0x74,0x22,0x29 # (abort")
2:	
	.align	WORD_SIZE
	fword	_prev
	.set	_prev,_cur
	.equ	xabortq,.		# cfa
	fword	docol
	fword	zbran
	fword	xabortq2
	fword	rfrom
	fword	count
	fword	type
	fword	_abort			# Never returns
xabortq2:
	fword	rfrom
	fword	count
	fword	plus
	fword	lit
	fword	(WORD_SIZE-1)
	fword	plus
	fword	lit
	fword	~(WORD_SIZE-1)
	fword	and
	fword	tor
	fword	semis

	_hdr 0,"abort",_abort
	fword	docol
	fword	spstore
	fword	quit		# Never returns
	
	.align	WORD_SIZE
	.set	_cur,.
	.byte	IMMED|(2f-1f)
1:
	.byte	0x61,0x62,0x6f,0x72,0x74,0x22 # abort"
2:	
	.align	WORD_SIZE
	fword	_prev
	.set	_prev,_cur
	.equ	abortq,.		# cfa
	fword	docol
	fword	lit
	fword	0x22
	fword	word
	fword	dup
	fword	cat
	fword	zbran
	fword	err_syntax
	fword	state
	fword	at
	fword	zbran
	fword	abortq2
	fword	lit
	fword	xabortq
	fword	comma
	fword	here
	fword	over
	fword	cat
	fword	onep
	fword	cmove
	fword	here
	fword	cat
	fword	lit
	fword	WORD_SIZE
	fword	plus
	fword	lit
	fword	~(WORD_SIZE-1)
	fword	and
	fword	allot
	fword	semis
abortq2:
	fword	swap
	fword	zbran
	fword	abortq3
	fword	count
	fword	type
	fword	_abort
abortq3:
	fword	drop
	fword	semis

	hdr abs
	fword	docol
	fword	dup
	fword	zless
	fword	zbran
	fword	abs2
	fword	negate
abs2:		
	fword	semis

	hdr allot
	fword	docol
	fword	h
	fword	pstore
	fword	semis

	_hdr IMMED,"begin",begin
	fword	docol
	fword	qcomp
	fword	here
	fword	lit
	fword	2
	fword	semis

	_hdr IMMED,"repeat",rep
	fword	docol
	fword	qcomp
	fword	depth
	fword	lit
	fword	2
	fword	less
	fword	zequ
	fword	zbran
	fword	rep_err
	fword	dup
	fword	lit
	fword	2
	fword	equal
	fword	zbran
	fword	rep2
	fword	drop
	fword	lit
	fword	bran
	fword	comma
	fword	comma
	fword	semis
rep2:
	fword	dup
	fword	lit
	fword	3
	fword	equal
	fword	zbran
	fword	rep_err
	fword	drop
	fword	swap
	fword	lit
	fword	bran
	fword	comma
	fword	comma
	fword	here
	fword	swap
	fword	store
	fword	semis
rep_err:	
	fword	lit
	fword	1
	fword	xabortq
	strlit "repeat without begin"

	_hdr IMMED,"until",until
	fword	docol
	fword	qcomp
	fword	depth
	fword	lit
	fword	2
	fword	less
	fword	zequ
	fword	zbran
	fword	until_err
	fword	lit
	fword	2
	fword	equal
	fword	zbran
	fword	until_err
	fword	lit
	fword	zbran
	fword	comma
	fword	comma
	fword	semis	
until_err:	
	fword	lit
	fword	1
	fword	xabortq
	strlit "until without begin"

	
	_hdr IMMED,"while",while
	fword	docol
	fword	qcomp
	fword	depth
	fword	lit
	fword	2
	fword	less
	fword	zequ
	fword	zbran
	fword	while_err
	fword	dup
	fword	lit
	fword	2
	fword	equal
	fword	zbran
	fword	while_err
	fword	lit
	fword	zbran
	fword	comma
	fword	here
	fword	lit
	fword	WORD_SIZE
	fword	allot
	fword	swap
	fword	onep
	fword	semis
while_err:
	fword	lit
	fword	1
	fword	xabortq
	strlit "while without begin"
	

	_hdr IMMED,"do",do
	fword	docol
	fword	qcomp
	fword	lit
	fword	xdo
	fword	comma
	fword	here
	fword	lit
	fword	4
	fword	semis

	_hdr IMMED,"loop",loop
	fword	docol
	fword	qcomp
	fword	depth
	fword	lit
	fword	2
	fword	less
	fword	zequ
	fword	zbran
	fword	loop_err
	fword	lit
	fword	4
	fword	equal
	fword	zbran
	fword	loop_err
	fword	lit
	fword	xloop
	fword	comma
	fword	comma
	fword	semis
loop_err:
	fword	lit
	fword	1
	fword	xabortq
	strlit "loop or +loop without do"
	
	_hdr IMMED,"+loop",ploop
	fword	docol
	fword	qcomp
	fword	depth
	fword	lit
	fword	2
	fword	less
	fword	zequ
	fword	zbran
	fword	loop_err
	fword	lit
	fword	4
	fword	equal
	fword	zbran
	fword	loop_err
	fword	lit
	fword	xploop
	fword	comma
	fword	comma
	fword	semis
	
	hdr bl
	fword	docol
	fword	lit
	fword	' '
	fword	semis
	
	hdr chr
	fword	docol
	fword	bl
	fword	word
	fword	dup
	fword	cat
	fword	zbran
	fword	err_syntax
	fword	onep
	fword	cat
	fword	semis

	hdr cmove
	fword	docol
	fword	qdup
	fword	zequ
	fword	zbran
	fword	cmove2
cmove1:	
	fword	drop
	fword	drop
	fword	semis
cmove2:	
	fword	lit
	fword	2
	fword	pick
	fword	lit
	fword	2
	fword	pick
	fword	sub
	fword	qdup
	fword	zbran
	fword	cmove1
	fword	zless
	fword	zbran
	fword	cmove_dn_loop
	# Move up
	fword	lit
	fword	-2
	fword	roll
	fword	swap
	fword	lit
	fword	2
	fword	pick
	fword	onem
	fword	plus
	fword	swap
	fword	lit
	fword	2
	fword	pick
	fword	onem
	fword	plus
	fword	rot
cmove_up_loop:
	fword	qdup
	fword	zbran
	fword	cmove1
	fword	lit
	fword	2
	fword	pick
	fword	cat
	fword	lit
	fword	2
	fword	pick
	fword	cstore
	fword	rot
	fword	onem
	fword	rot
	fword	onem
	fword	rot
	fword	onem
	fword	bran
	fword	cmove_up_loop		
	# Move down
cmove_dn_loop:	
	fword	qdup
	fword	zbran
	fword	cmove1
	fword	lit
	fword	2
	fword	pick
	fword	cat
	fword	lit
	fword	2
	fword	pick
	fword	cstore
	fword	rot
	fword	onep
	fword	rot
	fword	onep
	fword	rot
	fword	onem
	fword	bran
	fword	cmove_dn_loop		

	_hdr 0,"cmove>",cmoveup
	fword	docol
	fword	cmove
	fword	semis
			
	hdr code
	fword	docol
	fword	create
	fword	here
	fword	dup
	fword	lit
	fword	WORD_SIZE
	fword	sub
	fword	store
	fword	semis

	hdr constant
	fword	docol
	fword	create
	fword	lit
	fword	doconst
	fword	here
	fword	lit
	fword	-WORD_SIZE
	fword	plus
	fword	store
	fword	comma
	fword	semis

	hdr count
	fword	docol
	fword	dup
	fword	onep
	fword	swap
	fword	cat
	fword	semis

	hdr cr
	fword	docol
	fword	lit
	fword	forth_cr
	fword	emit
	fword	semis

	hdr create
	fword	docol
	fword	here
	fword	lit
	fword	(WORD_SIZE-1)
	fword	plus
	fword	lit
	fword	~(WORD_SIZE-1)
	fword	and
	fword	h
	fword	store
	fword	bl
	fword	word
	fword	dup
	fword	cat
	fword	zbran
	fword	err_syntax
	fword	here
	fword	over
	fword	cat
	fword	onep
	fword	cmove
	fword	here
	fword	dup
	fword	cat
	fword	lit
	fword	WORD_SIZE
	fword	plus
	fword	lit
	fword	~(WORD_SIZE-1)
	fword	and
	fword	allot
	fword	latest
	fword	comma	# lfa
	fword	lit
	fword	dovar
	fword	comma	# cfa
	fword	current
	fword	store
	fword	semis

	_hdr IMMED,"literal",literal
	fword	docol
	fword	qcomp
	fword	lit
	fword	lit
	fword	comma
	fword	comma
	fword	semis
	
	hdr lfa		# nfa -- lfa
	fword	docol
	fword	dup
	fword	zbran
	fword	lfa2
	fword	count
	fword	lit
	fword	0x7f
	fword	and
	fword	plus
	fword	lit
	fword	(WORD_SIZE-1)
	fword	plus
	fword	lit
	fword	~(WORD_SIZE-1)
	fword	and
lfa2:	
	fword	semis

	hdr cfa		# nfa -- cfa
	fword	docol
	fword	dup
	fword	zbran
	fword	cfa2
	fword	lfa
	fword	lit
	fword	WORD_SIZE
	fword	plus
cfa2:	
	fword	semis
	
	hdr pfa		# nfa -- pfa
	fword	docol
	fword	dup
	fword	zbran
	fword	pfa2
	fword	lfa
	fword	lit
	fword	2*WORD_SIZE
	fword	plus
pfa2:	
	fword	semis
	
	hdr decimal
	fword	docol
	fword	lit
	fword	10
	fword	base
	fword	store
	fword	semis

	hdr dup
	fword	docol
	fword	lit
	fword	0
	fword	pick
	fword	semis

	_hdr IMMED,"else",else
	fword	docol
	fword	qcomp
	fword	depth
	fword	lit
	fword	2
	fword	less
	fword	over
	fword	lit
	fword	1
	fword	equal
	fword	zequ
	fword	or
	fword	xabortq
	strlit "else without if"
	fword	lit
	fword	bran
	fword	comma
	fword	here
	fword	lit
	fword	WORD_SIZE
	fword	allot
	fword	rot
	fword	here
	fword	swap
	fword	store
	fword	swap
	fword	semis
	
	_hdr IMMED,"endif",endif
	fword	docol
	fword	qcomp
	fword	depth
	fword	lit
	fword	2
	fword	less
	fword	over
	fword	lit
	fword	1
	fword	equal
	fword	zequ
	fword	or
	fword	xabortq
	strlit "endif without if"
	fword	drop
	fword	here
	fword	swap
	fword	store
	fword	semis

	_hdr IMMED,"exit",forth_exit
	fword	docol
	fword	qcomp
	fword	lit
	fword	semis
	fword	comma	
	fword	semis

	hdr expect
	fword	docol
	fword	lit
	fword	0
	fword	span
	fword	store
expect_loop:
	fword	span
	fword	at
	fword	over
	fword	less
	fword	zbran
	fword	expect7
	fword	key
	fword	dup
	fword	lit
	fword	forth_cr
	fword	equal
	fword	zbran
	fword	expect2
	fword	drop
	fword	bran
	fword	expect7
expect2:
	fword	dup
	fword	lit
	fword	forth_bs
	fword	equal
	fword	zbran
	fword	expect3
	fword	span
	fword	at
	fword	zbran
	fword	expect4
	fword	drop
	fword	xdotq
	.byte	3,8,' ',8
	.align	WORD_SIZE
	fword	lit
	fword	-1
	fword	span
	fword	pstore
	fword	bran
	fword	expect_loop
expect3:	
	fword	dup
	fword	lit
	fword	0x1f
	fword	greater
	fword	zbran
	fword	expect4
	fword	dup
	fword	lit
	fword	0x7e
	fword	greater
	fword	zbran
	fword	expect5
expect4:
	fword	drop
	fword	lit
	fword	7
	fword	emit
	fword	bran
	fword	expect_loop
expect5:
	fword	dup
	fword	emit	
	fword	lit
	fword	2
	fword	pick
	fword	span
	fword	at
	fword	plus
	fword	cstore
	fword	lit
	fword	1
	fword	span
	fword	pstore
	fword	bran
	fword	expect_loop
expect7:
	fword	drop
	fword	drop
	fword	semis

	hdr fill
	fword	docol
	fword	swap
fill_loop:	
	fword	qdup
	fword	zbran
	fword	fill2
	fword	over
	fword	lit
	fword	3
	fword	pick
	fword	cstore
	fword	rot
	fword	onep
	fword	lit
	fword	-2
	fword	roll
	fword	onem
	fword	bran
	fword	fill_loop
fill2:
	fword	drop
	fword	drop
	fword	semis

	_hdr 0,"find",find	# addr -- nfa f
	fword	docol
	fword	latest
find_loop:
	fword	qdup
	fword	zbran
	fword	find9
	fword	over
	fword	cat
	fword	over
	fword	cat
	fword	lit
	fword	0x7f
	fword	and
	fword	equal
	fword	zbran
	fword	find3
	fword	over
	fword	over
	fword	onep
	fword	swap
	fword	count
find_loop2:
	fword	qdup
	fword	zbran
	fword	find2
	fword	lit
	fword	2
	fword	pick
	fword	cat
	fword	lit
	fword	2
	fword	pick
	fword	cat
	fword	equal
	fword	zbran
	fword	find1
	fword	rot
	fword	onep
	fword	rot
	fword	onep
	fword	rot
	fword	onem
	fword	bran
	fword	find_loop2
find1:	
	fword	drop
	fword	drop
	fword	drop
	fword	bran
	fword	find3
find2:	
	fword	drop
	fword	drop
	fword	swap
	fword	drop
	fword	dup
	fword	cat
	fword	lit
	fword	0x80
	fword	and
	fword	zbran
	fword	find22
	fword	lit
	fword	1
	fword	bran
	fword	find23
find22:	
	fword	lit
	fword	-1
find23:	
	fword	semis
find3:
	fword	lfa
	fword	at
	fword	bran
	fword	find_loop
find9:
	fword	lit
	fword	0
	fword	semis
	
	hdr forget
	fword	docol
	fword	bl
	fword	word
	fword	dup
	fword	cat
	fword	zbran
	fword	err_syntax
	fword	find
	fword	zbran
	fword	err_not_found
	fword	dup
	fword	lit
	fword	user_dict
	fword	less
	fword	over
	fword	lit
	fword	user_dict_end
	fword	less
	fword	zequ
	fword	or
	fword	xabortq
	strlit "Forget out of range"
	fword	dup
	fword	fence
	fword	at
	fword	greater
	fword	zequ
	fword	xabortq
	strlit "Forget past fence"
	fword	dup
	fword	lfa
	fword	at
	fword	current
	fword	store
	fword	h
	fword	store
	fword	semis

	hdr here
	fword	docol
	fword	h
	fword	at
	fword	semis	

	hdr hex
	fword	docol
	fword	lit
	fword	16
	fword	base
	fword	store
	fword	semis

	hdr hold
	fword	docol
	fword	pad
	fword	cat
	fword	onep
	fword	swap
	fword	over
	fword	pad
	fword	plus
	fword	cstore
	fword	pad
	fword	cstore
	fword	semis

	_hdr IMMED,"if",if
	fword	docol
	fword	qcomp
	fword	lit
	fword	zbran
	fword	comma
	fword	here
	fword	lit
	fword	WORD_SIZE
	fword	allot
	fword	lit
	fword	1
	fword	semis

	hdr immed
	fword	docol
	fword	latest
	fword	dup
	fword	cat
	fword	lit
	fword	0x80
	fword	or
	fword	swap
	fword	cstore
	fword	semis

	hdr interpret
	fword	docol
interp_loop:	
	fword	bl
	fword	word
	fword	dup
	fword	cat
	fword	zbran
	fword	interp9
	fword	find
	fword	qdup
	fword	zbran
	fword	interp5
	fword	swap
	fword	cfa
	fword	swap
	fword	lit
	fword	1
	fword	equal
	fword	zbran
	fword	interp2
interp1:	
	fword	execute
	fword	bran
	fword	interp_loop
interp2:
	fword	state
	fword	at
	fword	zbran
	fword	interp1
	fword	comma
	fword	bran
	fword	interp_loop
interp5:
	fword	dup
	fword	number
	fword	zbran
	fword	err_not_found
	fword	swap
	fword	drop
	fword	state
	fword	at
	fword	zbran
	fword	interp_loop
	fword	lit
	fword	lit
	fword	comma
	fword	comma
	fword	bran
	fword	interp_loop
interp9:
	fword	drop
	fword	semis

	hdr latest
	fword	docol
	fword	current
	fword	at
	fword	semis
	
	hdr max
	fword	docol
	fword	over
	fword	over
	fword	less
	fword	zbran
	fword	max2
	fword	swap
max2:
	fword	drop
	fword	semis

	hdr min
	fword	docol
	fword	over
	fword	over
	fword	greater
	fword	zbran
	fword	min2
	fword	swap
min2:	
	fword	drop
	fword	semis

	hdr mod
	fword	docol
	fword	slmod
	fword	drop
	fword	semis

	hdr over
	fword	docol
	fword	lit
	fword	1
	fword	pick
	fword	semis
	
	hdr number		# addr -- val f
	fword	docol
	fword	lit
	fword	0
	fword	swap
	fword	count # 0 addr cnt
	fword	dup
	fword	zbran
	fword	number_bad3
	fword	over
	fword	cat
	fword	lit
	fword	'-'
	fword	equal
	fword	zbran
	fword	number2
	fword	dup
	fword	lit
	fword	2
	fword	less
	fword	zequ
	fword	zbran
	fword	number_bad3
	fword	onem
	fword	swap
	fword	onep
	fword	swap
	fword	lit
	fword	1
	fword	bran
	fword	number3
number2:
	fword	lit
	fword	0
number3:	
	fword	lit
	fword	-3
	fword	roll
number_loop:			# sf val addr cnt
	fword	qdup
	fword	zbran
	fword	number_good
	fword	over
	fword	cat	# sf val addr cnt c
	fword	dup
	fword	lit
	fword	0x3a
	fword	less
	fword	zbran
	fword	number_alpha
	fword	dup
	fword	lit
	fword	'0'
	fword	less
	fword	zequ
	fword	zbran
	fword	number_bad5
	fword	dup
	fword	base
	fword	at
	fword	lit
	fword	'0'
	fword	plus
	fword	less
	fword	zbran
	fword	number_bad5
	fword	lit
	fword	'0'
number1:	
	fword	sub
	fword	lit
	fword	3
	fword	roll
	fword	base
	fword	at
	fword	star
	fword	plus
	fword	lit
	fword	-2
	fword	roll
	fword	onem
	fword	swap
	fword	onep
	fword	swap	
	fword	bran
	fword	number_loop
number_alpha:
	fword	base
	fword	at
	fword	lit
	fword	10
	fword	less
	fword	zequ
	fword	zbran
	fword	number_bad5
	fword	dup
	fword	lit
	fword	0x41
	fword	less
	fword	zequ
	fword	zbran
	fword	number_bad5
	fword	dup
	fword	base
	fword	at
	fword	lit
	fword	0x37
	fword	plus
	fword	less
	fword	zbran
	fword	number_alpha2
	fword	lit
	fword	0x37
	fword	bran
	fword	number1
number_alpha2:	
	fword	dup
	fword	lit
	fword	0x61
	fword	less
	fword	zequ
	fword	zbran
	fword	number_bad5
	fword	dup
	fword	base
	fword	at
	fword	lit
	fword	0x57
	fword	plus
	fword	less
	fword	zbran
	fword	number_bad5
	fword	lit
	fword	0x57
	fword	bran
	fword	number1
number_good:
	fword	drop
	fword	swap
	fword	zbran
	fword	number_good2
	fword	negate
number_good2:
	fword	lit
	fword	1
	fword	semis
number_bad5:
	fword	drop
	fword	drop
number_bad3:	
	fword	drop
	fword	drop
	fword	drop
	fword	lit
	fword	0
	fword	semis

	hdr pad
	fword	docol
	fword	here
	fword	lit
	fword	32
	fword	plus
	fword	semis

	hdr query
	fword	docol
	fword	tib
	fword	lit
	fword	tibsize
	fword	expect
	fword	lit
	fword	0
	fword	toin
	fword	store
	fword	semis

	hdr quit
	fword	docol
	fword	lit
	fword	0
	fword	state
	fword	store
quit_loop:	
	fword	rpstore
	fword	state
	fword	at
	fword	zequ
	fword	zbran
	fword	quit2
	fword	cr
	fword	xdotq
	strlit	"ok "	
quit2:	
	fword	query
	fword	cr
	fword	interpret
	fword	bran
	fword	quit_loop

	hdr rot
	fword	docol
	fword	lit
	fword	2
	fword	roll
	fword	semis

	hdr sign
	fword	docol
	fword	over
	fword	zless
	fword	zbran
	fword	sign2
	fword	lit
	fword	'-'
	fword	hold
sign2:	
	fword	semis

	hdr space
	fword	docol
	fword	bl
	fword	emit
	fword	semis

	hdr spaces
	fword	docol
spaces_loop:	
	fword	qdup
	fword	zbran
	fword	spaces2
	fword	space
	fword	onem
	fword	bran
	fword	spaces_loop
spaces2:	
	fword	semis

	hdr swap
	fword	docol
	fword	lit
	fword	1
	fword	roll
	fword	semis

	hdr type
	fword	docol
type_loop:
	fword	qdup
	fword	zbran
	fword	type2
	fword	over
	fword	cat
	fword	emit
	fword	swap
	fword	onep
	fword	swap
	fword	onem
	fword	bran
	fword	type_loop
type2:
	fword	drop
	fword	semis

	hdr variable
	fword	docol
	fword	create
	fword	lit
	fword	0
	fword	comma
	fword	semis

	hdr word
	fword	docol
	fword	lit
	fword	0
	fword	pad
	fword	cstore
word2:
	fword	toin
	fword	at
	fword	span
	fword	at
	fword	less
	fword	zbran
	fword	word9
	fword	tib
	fword	toin
	fword	at
	fword	plus
	fword	cat
	fword	over
	fword	over
	fword	equal
	fword	zbran
	fword	word3
	fword	drop
	fword	lit
	fword	1
	fword	toin
	fword	pstore
	fword	bran
	fword	word2
word3:	
	fword	pad
	fword	dup
	fword	cat
	fword	onep
	fword	plus
	fword	cstore
	fword	pad
	fword	cat
	fword	onep
	fword	pad
	fword	cstore
	fword	lit
	fword	1
	fword	toin
	fword	pstore
	fword	toin
	fword	at
	fword	span
	fword	at
	fword	less
	fword	zbran
	fword	word9		
	fword	tib
	fword	toin
	fword	at
	fword	plus
	fword	cat
	fword	over
	fword	over
	fword	equal
	fword	zbran
	fword	word3
	fword	drop
	fword	lit
	fword	1
	fword	toin
	fword	pstore
word9:
	fword	drop
	fword	pad
	fword	semis
				
banner:
	strlit "\n\nHP Forth 1.0\n"

	.global forth_entry
	.global	abort3
forth_entry:
	# Init user vars
	fword	lit
	fword	10
	fword	base
	fword	store
	fword	lit
	fword	_dict_last
	fword	current
	fword	store
	fword	lit
	fword	0
	fword	fence
	fword	store
	fword	lit
	fword	user_dict
	fword	h
	fword	store
	fword	lit
	fword	0
	fword	span
	fword	store
	fword	lit
	fword	0
	fword	toin
	fword	store
	fword	lit
	fword	banner
	fword	lit
	fword	abort_msg
	fword	store
abort3:	
	fword	rpstore
	fword	spstore
	fword	lit
	fword	abort_msg
	fword	at
	fword	count
	fword	type
	fword	cr
	fword	quit
	# quit never returns

	
	.bss

user_dict:	
			
	.space	0x10000

user_dict_end:	
	
