;redcode-94nop
;name Rise of the Dragon
;author John Metcalf
;strategy qscan -> clear/imp
;assert CORESIZE==8000

        org    qscan

gate    dat    4000,       1700
bomb    dat    >2667,      11

        for    4
        dat    0,0
        rof

        spl    #4000,      >gate
clear   mov    bomb,       >gate
        djn.f  clear,      >gate

        for    23
        dat    0,0
        rof

        istep  equ 1143           ; (CORESIZE+1)/7

warr    spl    clear-1,    <3700
        mov    imp,        *launch
        spl    1,          <3600  ; 32 parallel processes
        spl    1,          <3500
        spl    1,          <3400
        spl    1,          <3300
        spl    1,          <3200
        spl    nxpoint,    <3100
launch  djn.f  3600,       <4000

        for    2
        dat    0,0
        rof

nxpoint add.f  #istep,     launch
        djn.f  clear-1,    <3000

imp     mov.i  #3,         istep

        for    24
        dat    0,0
        rof

        qfac   equ 7051 ; 1467 ; 6371 ;  369
        qdec   equ 4452 ; 2804 ; 3532 ; 3730

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
        jmp    warr,         qc
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
        jmp    qdecode,      <qa
qtab0   jmp    warr,         <qb
qtab2   dat    qgap,         qf


