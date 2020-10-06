( Test built-in words)

( test user variables, and . )
base .
current .
fence .
h .
span .
state .
>in .
tib .

( test ! )
0 pad !

( test * )
2 3 * .

( test */mod )
2 3 4 */mod . .

( test + )
2 3 + .

( test - )
2 3 - .

( test << )
2 3 << .

( test >> )
2 3 >> .

( test /mod )
2 3 /mod . .

( test 0< )
1 0< .

( test 0= )
1 0= .

( test >r, r> )
1 >r r> .

( test ?dup )
1 ?dup . .

( test @ )
pad @ .

( test and )
1 2 and .

( test c! )
0 pad c!

( test c@ )
pad c@ .

( test depth )
depth .

( test drop )
( See all of the above )

( test emit )
65 emit

( test execute )
2 3 ' + execute .

( test key )
( Skip for now )

( test negate )
1 negate .

( test not )
1 not .

( test or )
1 2 or .

( test pick )
1 2 1 pick . . .

( test r )
1 >r r . r> .

( test roll )
1 2 3 2 roll . . .

( test rp! )
( An rstack underflow is expected, the rstack is being clobbered while interpret is running )
rp!

( test sp! )
sp!

( test u< )
1 2 u< .

( test u* )
1 2 u* .

( test u/mod )
1 2 u/mod . .

( test u*/mod )
1 2 3 u*/mod . .

( test xor )
1 2 xor .

( test number conversion, type, sign )
: convert <# # #s sign #> ;
42 convert type 
: uconvert <#u # #s sign #> ;
-42 uconvert type

( test +! )
1 pad +!

( test */ )
1 2 3 */ .

( test / )
42 6 / .

( test , )
42 ,

( test c, )
42 c,

( test . )
( See above )

( test u. )
42 u.

( test ." )
." Hello, world!"

( test 0> )
42 0> .

( test 1+ )
42 1+ .

( test 1- )
42 1- .

( test 2+ )
42 2+ .

( test 2- )
42 2- .

( test 2/ )
42 2/ .

( test < )
1 2 < .

( test = )
1 2 = .

( test > )
1 2 > .

( test ? )
pad ?

( test [ and ] )
] [

( test ?compiling )
?compiling

( test word definition )
: foo 42 + ;
13 foo .

( test ' )
' foo .

( test abort )
abort

( test abort" )
0 abort" No"
1 abort" Yes"

( test abs )
-1 abs .

( test allot )
8 allot

( test begin / while / repeat )
: test 10 0 begin over over > while dup . 1+ repeat drop drop ;
test

( test begin / until )
: test 10 0 begin dup . 1+ over over < until drop drop ;
test

( test do / loop )
: test 10 0 do i . loop ;
test

( test do / +loop )
: test 10 0 do i . 2 +loop ;
test

( test bl )
bl .

( test chr )
chr a .

( test cmove )
pad pad 4 + 4 cmove

( test cmove> )
pad pad 4 + 4 cmove>

( test constant )
42 constant meaning
meaning .

( test latest, count )
latest count type

( test cr )
cr

( test literal )
: test [ 42 ] literal ;
test .

( test lfa )
latest lfa .

( test cfa )
latest cfa .

( test pfa )
latest pfa .

( test decimal )
decimal

( test dup )
42 dup . .

( test if / else / endif )
: test if ." Yes" else ." No" endif ;
0 test
1 test

( test exit )
: test if ." Yes" exit endif ." No" ;
0 test
1 test

( test expect )

( test fill )
pad 10 0 fill

( test find )
hex 1 pad 10 + c! 2d pad 11 + c!
pad 10 + find . .

( test forget )
forget test

( test here )
here .

( test hex )
hex

( test hold )
: test <# # 41 hold #s #> type ;
42 test

( test immed )
immed

( test interpret )
( ... )

( test max )
1 2 max .

( test min )
1 2 min .

( test mod )
42 4 mod .

( test over )
1 2 over . . .

( test number )
1 pad 10 + c! 35 pad 11 + c!
pad 10 + number . .

( test quit )
quit

( test query )

( test rot )
1 2 3 rot . . .

( test space )
space ." x"

( test spaces )
10 spaces ." x"

( test swap )
1 2 swap . .

( test type )
( See above )

( test variable )
variable foo
42 foo !
foo ?

( test create, word, does> )
: string create [ hex ] 22 word  pad here pad c@ 1+ cmove here c@ 1+ allot does> ;
string s "A test string"
s count type

-exit
