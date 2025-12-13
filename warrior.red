;redcode
;name Night of the Living Dead
;author John Metcalf
;strategy qscan -> living dead
;assert CORESIZE==8000

; qscan - 36 scans in 48 instructions

        qfirst equ (qp2+2*qstep)
        qdist  equ qfirst+130
        qstep  equ 260

        qi     equ 7
        qr     equ 7

qbomb   dat <qi/2-qi*qr,   <qi*qr-qi/2

        qa  equ qstep*16
        qb  equ qstep*5+2
        qc  equ qstep*10
        qd  equ qstep*2
        qe  equ qstep*1

qscan   cmp qdist+qc,      qfirst+qc
        jmp qfast,         <qa
        cmp qdist+qe+qd,   qfirst+qe+qd
qp1     jmp <qfast,        <qc
qp2     cmp qdist,         qfirst
qp3     jmp qskip,         <qe

        cmp qdist+qb,      qfirst+qb
q1      djn qfast,         #qp1

        cmp qdist+qd+qc,   qfirst+qd+qc
        jmp qslow,         <qfirst+qd+qc+4
        cmp qdist+qd+qb,   qfirst+qd+qb
x1      jmp qslow,         <q1
        cmp qdist+qc+qc,   qfirst+qc+qc
q2      djn qslow,         #qp2
        cmp qdist+qd,      qfirst+qd
        jmp qslow,         <qfast
        cmp qdist+qa,      qfirst+qa
        jmp q1,            <q1

        cmp qdist+qa+qd,   qfirst+qa+qd
        jmp x1,            <q1
        cmp qdist+qc+qb,   qfirst+qc+qb
        jmp q2,            <q1
        cmp qdist+qe+qd+qc,qfirst+qe+qd+qc
        jmp qslower,       <qfirst+qe+qd+qc+4
        cmp qdist+qe+qd+qb,qfirst+qe+qd+qb
        jmp qslower,       <q1
        cmp qdist+qe+qc+qc,qfirst+qe+qc+qc
        jmp qslower,       <q2
        cmp qdist+qd+qd+qc,qfirst+qd+qd+qc
q3      djn qslower,       #qp3
        cmp qdist+qe+qc,   qfirst+qe+qc
        jmp <qfast,        <q2
        cmp qdist+qd+qd,   qfirst+qd+qd
        jmp <qfast,        <q3
        cmp qdist+qd+qd+qb,qfirst+qd+qd+qb
        slt <q3,           <q1

        jmz warr,          qdist+qe+qd+qc+10

qslower add @q3,           @qslow
qslow   add @q2,           qkil
qfast   add @q1,           @qslow

qskip   cmp <qdist+qstep+50, @qkil
        jmp qloop,         <1234

        add #qdist-qfirst, qkil
qloop   mov qbomb,         @qkil
qkil    mov <qfirst+qstep+50, <qfirst
        sub #qi,           @qloop
        djn qloop,         #qr+2

; boot - binary launch 8 clears

        dfirst equ 4200
        dinc   equ 200

        boot   equ warr+100
        bgap   equ 917

        cpos   equ -5-bgap*5

warr    spl x,             <dfirst+dinc*0
        spl y,             <dfirst+dinc*1
        spl b1,            <dfirst+dinc*2

b0      mov d,             boot+0*bgap
        mov m,             <b0
        mov s,             <b0
        djn @b0,           <dfirst+dinc*3

b1      mov d,             boot+1*bgap
        mov m,             <b1
        mov s,             <b1
        djn @b1,           <dfirst+dinc*4

y       spl b3,            <dfirst+dinc*5

b2      mov d,             boot+2*bgap
        mov m,             <b2
        mov s,             <b2
        djn @b2,           <dfirst+dinc*6

b3      mov d,             boot+3*bgap
        mov m,             <b3
        mov s,             <b3
        djn @b3,           <dfirst+dinc*7

x       spl z,             <dfirst+dinc*8
        spl b5,            <dfirst+dinc*9

b4      mov d,             boot+4*bgap
        mov m,             <b4
        mov s,             <b4
        djn @b4,           <dfirst+dinc*10

b5      mov d,             boot+5*bgap
        mov m,             <b5
        mov s,             <b5
        djn @b5,           <dfirst+dinc*11

z       spl b7,            <dfirst+dinc*12

b6      mov d,             boot+6*bgap
        mov m,             <b6
        mov s,             <b6
        djn @b6,           <dfirst+dinc*13

b7      mov d,             boot+7*bgap
        mov m,             <b7
        mov s,             <b7
        djn @b7,           <dfirst+dinc*14

; anti-imp clear

s       spl 0,             <d
m       mov 0,             <d
d       djn s,             #cpos

        end qscan
