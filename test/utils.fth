: .s
depth 0 begin
over over > while
dup 2 + pick . space
1+
repeat
drop drop
;

: .name ( nfa -- )
count [ base @ hex ] 7f [ base ! ] and type
;

: .dict ( -- )
latest begin
?dup while
dup .name space
lfa @
repeat
;

: cfa>nfa ( cfa -- nfa )
8 -
begin
dup c@ bl > while
4 -
repeat
;

: string"
create
[ chr " ] literal word
dup c@ 0= abort" Syntax error"
here over c@ 1+ cmove
here c@ 1+ allot
;

: cdump ( addr cnt -- )
base @ >r
hex
begin
?dup while
over <#u # # # # # # # # #> type space
over over 16 min begin
?dup while
over c@ <#u # # #> type space
swap 1+ swap 1-
repeat
cr
drop
dup 16 min >r
r@ -
swap r> + swap
repeat
drop
r> base !
;

: dump ( addr cnt -- )
base @ >r
hex
begin
?dup while
over <#u # # # # # # # # #> type space
over over 8 min begin
?dup while
over @ <#u # # # # # # # # #> type space
swap 4 + swap 1-
repeat
cr
drop
dup 8 min >r
r@ -
swap r> 4 * + swap
repeat
drop
r> base !
;

variable base-addr

: reg
create ,
does> @ base-addr @ +
;

hex
0  reg cntl-reg
10 reg status-reg
