;redcode
;name Torment
;author John Metcalf
;strategy qscan -> hydra/paper/imp
;assert CORESIZE==8000

; qscan - 36 scans in 48 instructions

        qfirst equ (qp2+2*qstep)
        qdist  equ qfirst+130
        qstep  equ 260

        qi     equ 7
        qr     equ 7

qbomb   dat <qi/2-qi*qr,   <qi*qr-qi/2

        qa     equ qstep*16
        qb     equ qstep*5+2
        qc     equ qstep*10
        qd     equ qstep*2
        qe     equ qstep*1

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

warr    mov <s,            <hboot
        spl 1,             <1000
        spl 1,             <3000
        spl 1,             <5000
        mov <s,            <hboot
        mov <s,            <pboot
hboot   spl @0,            warr+5696
pboot   jmp @0,            warr+6576

; paper/imp from Witchcraft

        fact   equ 6484
        x      equ 3
        y      equ 5
        length equ 8

        pstepa equ fact*x
        pstepb equ 17-fact*y

        istep  equ 2667

zz      mov <length,   <pa
papera  spl @pa,       <2000
        mov <length,   <paperb
paperb  spl @0,        zz+pstepb

        spl istep+1,   <1000
        mov -1,        istep
        mov 0,         istep
pa      dat <-1,       #zz+pstepa

; continuous hydra from Abomination

s       spl 0,         9
        mov n,         <boot
        mov m,         <boot
boot    mov d,         4883
        add #636,      @boot-1
        mov s,         <boot
d       djn @boot,     <-20
n       mov m,         <m
m       mov <m,        <2171

        end qscan

