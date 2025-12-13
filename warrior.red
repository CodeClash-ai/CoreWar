;redcode-94nop
;name Kryptonite
;author John Metcalf
;strategy stone/imp
;assert CORESIZE==8000

; entered the KOTH.org 94nop and 94 hills in 1st place on 30th April 2014

        zero   equ qbomb
        qtab3  equ qbomb

qbomb   dat    >qoff,        >qc2

        dat    0,            0

        spl    2,            }qb1
qtab2   spl    2,            }qb2
        spl    1,            }qb3

        for    12
        dat    0,            0
        rof

        dat    zero-1,       qa1
qtab1   dat    zero-1,       qa2

        for    7
        dat    0,            0
        rof

        boot   equ           wgo+1576 ; boot distance

        bdista equ           7        ; distance to anti-imp bomb
        bdistb equ           10       ; distance to standard bomb

        ldist  equ           5182     ; distance to imp launcher
        idist  equ           1522     ; distance to imp

        istep  equ           1143

        hop    equ           13
        step   equ           119
        time   equ           1478

wgo     mov    bomba,        boot+bdista
        mov    bombb,        boot+bdistb
        mov    imp,          boot+idist
        spl    2,            <2015
        spl    1,            <5340
        spl    1,            <329
        mov    <stone,       {sboot
sboot   djn    boot+6,       #1

        spl    1,            <5678
        spl    1,            <5836
        mov    <launch,      {iboot
        spl    1,            <1345
iboot   jmp    boot+ldist+4, <5856

stone   spl    #0,           0+6
        spl    #0,           0
loop    mov    stone+bdista, >hit-(hop+time*step)
hit     mov    stone+bdistb, @loop
        add    #step,        @hit
        djn.f  loop,         <-1150

bombb   dat    <1,           hop
bomba   dat    <5334,        <2667

imp     mov.i  #1,           istep

launch  spl    #0,           0+4
        add.f  #istep,       iptr
iptr    djn.f  launch+idist-ldist-istep*8, <-1150

        for    14
        dat    0,            0
        rof

; Q^5 (extended Q^4) by David Houston optimized by Roy van Rijn

qc2     equ ((1+(qtab3-qptr)*qy)%CORESIZE)
qb1     equ ((1+(qtab2-1-qptr)*qy)%CORESIZE)
qb2     equ ((1+(qtab2-qptr)*qy)%CORESIZE)
qb3     equ ((1+(qtab2+1-qptr)*qy)%CORESIZE)
qa1     equ ((1+(qtab1-1-qptr)*qy)%CORESIZE)
qa2     equ ((1+(qtab1-qptr)*qy)%CORESIZE)

qy      equ 5931
qz      equ 3972

;q0 mutation
qgo     sne     qptr+qz*qa1     , qptr+qz*qa1+qb2
        seq     <(qtab1-1)      , qptr+qz*(qa1-1)+qb2
        djn.a   q0              , {q0
        sne     qptr+qz*qc2     , qptr+qz*qc2+qb2
        seq     <qtab3          , qptr+qz*(qc2-1)+qb2
        jmp     q0              , }q0
        sne     qptr+qz*qa2     , qptr+qz*qa2+qb2
        seq     <qtab1          , qptr+qz*(qa2-1)+qb2
        jmp     q0              , {q0
;q1 mutation
        sne     qptr+qz*qb3     , qptr+qz*qb3+qb3
        seq     <(qtab2+1)      , qptr+qz*(qb3-1)+(qb3-1)
        jmp     q0              , }q1
        sne     qptr+qz*qb1     , qptr+qz*qb1+qb1
        seq     <(qtab2-1)      , qptr+qz*(qb1-1)+(qb1-1)
        jmp     q0              , {q1
;no mutation
        sne     qptr+qz*qb2     , qptr+qz*qb2+qb2
        seq     <qtab2          , qptr+qz*(qb2-1)+(qb2-1)
        djn.f   q0              , <6907
;qz mutation
        seq     >qptr           , qptr+qz+(qb2-1)
        jmp     q2              , <qptr
;q0 mutation
        seq     qptr+(qz+1)*(qc2-1),qptr+(qz+1)*(qc2-1)+(qb2-1)
        jmp     q0              , }q0
        seq     qptr+(qz+1)*(qa2-1),qptr+(qz+1)*(qa2-1)+(qb2-1)
        jmp     q0              , {q0
        seq     qptr+(qz+1)*(qa1-1),qptr+(qz+1)*(qa1-1)+(qb2-1)
        djn.a   q0              , {q0
;no mutation
        jmz.f   wgo             , qptr+(qz+1)*(qb2-1)+(qb2-1)

qoff    equ     -87
qstep   equ     -7
qtime   equ     19

q0      mul.b   *2              , qptr
q2      sne     {qtab1          , @qptr
q1      add.b   qtab2           , qptr
        mov     qtab3           , @qptr
qptr    mov     qbomb           , }qz
        sub     #qstep          , qptr
        djn     -3              , #qtime
        jmp     wgo             , <855

        end     qgo
