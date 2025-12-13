;redcode-94nop
;name Silkworm
;author John Metcalf
;strategy qscan -> paper/imps
;assert CORESIZE==8000

        qfac   equ 5829
        qdec   equ 270

        qa     equ (qfac*(qtab0-1-qptr)+1)
        qb     equ (qfac*(qtab0-qptr)+1)
        qc     equ (qfac*(qtab1-1-qptr)+1)
        qd     equ (qfac*(qtab1-qptr)+1)
        qe     equ (qfac*(qtab1+1-qptr)+1)
        qf     equ (qfac*(qtab2-qptr)+1)

        qtime  equ 18
        qstep  equ -7
        qgap   equ 87

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
qtab0   jmp    warr,         {qb
qtab2   dat    qgap,         qf

qdecode mul.b  *q1,          qptr
q0      sne    <qtab0,       @qptr
q1      add.b  qtab1,        qptr
q2      mov    qtab2,        @qptr
qptr    mov    qtab2,        *qdec
        add    #qstep,       qptr
        djn    q2,           #qtime
        jmp    warr,         {6300

        for    55
        dat    0,0
        rof

wimp    jmp    #0

        step1  equ 3205
        step2  equ 1805
        istep  equ 2667

warr    mov    wimp,     4377
        spl    @warr,    {1400

        spl    2,        {qc      ; 6 parallel processes
qtab1   spl    1,        {qd
        spl    1,        {qe
        spl    boot,     {1800

        mov    {papera,  {boot0
boot0   djn.f  papera-istep+6,{200

boot    mov    *papera,  {boot2
boot2   spl    papera+istep+6,{2000

papera  spl    @0+6,     }step1
        mov    }papera,  >papera
paperb  spl    step2,    {papera
        mov    }papera,  }paperb
        mov.i  #step1*2-step2+4,}istep
imp     mov.i  #1,       istep

