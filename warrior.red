;redcode
;name Infiltrator
;author inversed
;strategy Self-replicating scanner / stone
;assert CORESIZE == 8000

;.............. Replicator ................................;
len     equ     29
len0    equ     21
step    equ     3634
hop     equ     13
sofs    equ     5809
pofs    equ     7061

from    mov     # len       ,       len0
loop    add     # step+1    ,       ptr
        mov       bomb      ,     < ptr
ptr     jmz       loop      ,     < sofs+1
copy    mov       bomb2     ,     < ptr
        mov     < from      ,     < pptr
        jmn       copy      ,       from
        spl       from      ,       0
pptr    jmz     @ 0         ,       pofs+len
bomb2   dat     < 2667      ,     < 5334
bomb    dat     < 2667      ,     <-hop+1
bfrom   dat     # 0         ,     # 0

;.............. Boot ......................................;
blen    equ     11
bdist   equ     5843
x0      equ     (-CURLINE)

boot i for blen
        mov     < bfrom     ,     < bptr
rof
bptr    jmp       x0+bdist+2,       x0+bdist+blen

;.............. QScan .....................................;
qs      equ     3841
qd      equ     4000
qbinc   equ     -9
qbhop   equ     43
qbtime  equ     6
nil     equ     qbomb+1

qscan   cmp       2*qs+qd        ,       2*qs
qt1     jmp       qa0            ,     < 3*qs
        cmp       qscan+ 5*qs+qd ,       qscan+ 5*qs
qt2     jmp       qa1            ,     < 4*qs
        cmp       qscan+ 4*qs+qd ,       qscan+ 4*qs
qs1     djn       qa1            ,     # qt1
        cmp       qscan+10*qs-2  ,       qscan+10*qs+qd-2
qs2     djn       qa2            ,     # qt2
        cmp       qscan+ 9*qs+qd ,       qscan+ 9*qs
qt3     jmp       qa2            ,     < 6*qs
        cmp       qscan+ 6*qs+qd ,       qscan+ 6*qs
        jmp       qa2            ,     < qa1
        cmp       qscan+ 8*qs+qd ,       qscan+ 8*qs
        jmp       qa2            ,     < qs1
        cmp       qscan+11*qs    ,       qscan+11*qs+qd
        jmp       qa3            ,     < qa2
        cmp       qscan+18*qs-8  ,       qscan+18*qs+qd-8
qs3     djn       qa3            ,     # qt3
        cmp       qscan+16*qs-2  ,       qscan+16*qs+qd-2
        jmp       qa3            ,     < qs2
        cmp       qscan+12*qs    ,       qscan+12*qs+qd
        jmp       qa3            ,     < qa1
        cmp       qscan+14*qs    ,       qscan+14*qs+qd
        jmp       qa3            ,     < qs1
        jmz       boot           ,       qscan+15*qs

qa3     add     @ qs3            ,       qp
qa2     add     @ qs2            ,     @ qa3
qa1     add     @ qs1            ,     @ qa3
qa0     cmp     @ qp             ,       nil
        cmp     @ 0              ,       0
        add     # qd             ,       qp
ql      mov       qbomb          ,     @ qp
qp      mov       nil            ,     < qscan+2*qs
        add     # qbinc          ,     @ ql
        djn       ql             ,     # qbtime
        jmp       boot           ,       0
qbomb   dat     # 0              ,     # qbhop

end     qscan

