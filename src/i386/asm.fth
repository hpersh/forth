( i386 assembler for FORTH )

base @ hex

0 constant %eax
1 constant %ecx
2 constant %edx
3 constant %ebx
4 constant %esp
5 constant %ebp
6 constant %esi
7 constant %edi

: movr 8b c, 3 << or c0 or c, ;

: movi c7 c, c0 or c, , ;

: pushr 50 or c, ;

: popr 58 or c, ;

: pusha 60 c, ;

: popa  61 c, ;

: in 0ed c, ;

code input %edx popr in %eax pushr next

: out 0ef c, ;

code output %edx popr %eax popr out next

base !
