;redcode-94nop
;name Toxic
;author John Metcalf
;strategy qscan -> paper/imp
;strategy resonant spiral-forming steps & silk-imps
;assert CORESIZE==8000

        org    qscan

        qfac   equ 2259 ; 3771 ; 1533
        qdec   equ 2140 ; 6132 ; 2198

        qa     equ (qfac*(qtab0-1-qptr)+1)
        qb     equ (qfac*(qtab0-qptr)+1)
        qc     equ (qfac*(qtab1-1-qptr)+1)
        qd     equ (qfac*(qtab1-qptr)+1)
        qe     equ (qfac*(qtab1+1-qptr)+1)
        qf     equ (qfac*(qtab2-qptr)+1)

        qtime  equ 18
        qstep  equ -7
        qgap   equ 87

qdecode mul.b  *q1,          qptr
q0      sne    <qtab0,       @qptr
q1      add.b  qtab1,        qptr
q2      mov    qtab2,        @qptr
qptr    mov    qtab2,        *qdec
        add    #qstep,       qptr
        djn    q2,           #qtime
        jmp    toxin,        qc
qtab1   dat    4000,         qd
        dat    4000,         qe

qscan   sne    qptr+qdec*qe, qptr+qdec*qe+qe
        seq    <qtab1+1,     qptr+qdec*(qe-1)+qe-1
        jmp    qdecode,      }q1
        sne    qptr+qdec*qb, qptr+qdec*qb+qd
        seq    <qtab0,       qptr+qdec*(qb-1)+qd
        jmp    qdecode,      {qdecode
        sne    qptr+qdec*qa, qptr+qdec*qa+qd
        seq    <qtab0-1,     qptr+qdec*(qa-1)+qd
        djn.a  qdecode,      {qdecode
        sne    qptr+qdec*qf, qptr+qdec*qf+qd
        seq    <qtab2,       qptr+qdec*(qf-1)+qd
        jmp    qdecode,      }qdecode
        sne    qptr+qdec*qc, qptr+qdec*qc+qc
        seq    <qtab1-1,     qptr+qdec*(qc-1)+qc-1
        jmp    qdecode,      {q1
        sne    qptr+qdec*qd, qptr+qdec*qd+qd
        seq    <qtab1,       qptr+qdec*(qd-1)+qd-1
        jmp    qdecode,      qa
qtab0   jmp    toxin,        qb
qtab2   dat    qgap,         qf

        for    57
        dat    0,        0
        rof

        fact   equ 5573 ; 3044 ; 756 ; 3356
        step1  equ 4001-fact*5
        step2  equ fact*3
        step3  equ istep+1
        istep  equ 2667           ; (CORESIZE+1)/3

toxin   spl    1,        {200
        spl    1,        {400
        spl    1,        {600
        mov.i  {papera,  {pboot
pboot   spl    *papera+4008, {800

papera  spl    @0+8,     {step1
        mov    }papera,  >papera
paperb  spl    @0,       }step2
        mov    }paperb,  >paperb
paperc  spl    @0,       }step3
        mov    }paperc,  >paperc
        mov.i  #step2+4000,}-step2
imp     mov.i  #1,       istep

        end

