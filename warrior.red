;redcode-94nop
;name Xenosmilus
;author John Metcalf
;strategy qscan -> scanner
;assert CORESIZE==8000

        org qscan

        step   equ 17
        first  equ 314

ptr     dat    first+step, first

        for    step-8
        dat    0,          0
        rof

bomb    spl    #0,         {0

wipe    mov    bomb,       <ptr
        mov    >ptr,       >ptr
        jmn.f  wipe,       >ptr

reset   mov.ab ptr,        ptr

scan    sub    inc,        ptr
        sne.x  *ptr,       @ptr
inc     sub.x  #-2*step,   ptr
        jmz.f  scan,       @ptr

        slt    ptr,        #last-ptr+4
        djn    wipe,       ptr
        djn    reset,      #13
last    jmp    reset,      {wipe

        for    64-step
        dat    0,0
        rof

        qfac   equ 369
        qdec   equ 3730

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
        jmp    scan+1,       qc
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
qtab0   jmp    scan+1,       qb
qtab2   dat    qgap,         qf
