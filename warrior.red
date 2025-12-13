;redcode-94nop
;name Hellfire
;author John Metcalf
;strategy qscan -> airbag incendiary bomber
;assert CORESIZE==8000

        org    qscan

        olap   equ 321
        step   equ 2205
        hop    equ (4001+step*olap)
        bdist  equ (warr+6462)

warr    mov    mbmb,         bdist+step+1

        spl    2,            <qc
qtab1   spl    2,            <qd
        spl    1,            <qe

        mov    <btop,        {boot
gate    mov    <btop,        {boot
boot    djn.f  >bdist+10,    <3000

btop    mov.i  {0,           #10
bomber  mov    step,         }hit+1-hop
        add.ab <0,           >0
        mov    <sbmb,        @bomber
hit     jmz    bomber,       >sbmb
sbmb    spl    #hop,         1
clear   mov    dbmb,         >gate
        djn.f  clear,        >gate
dbmb    dat    <1,           13

mbmb    mov    -hop,         }-hop

        for    55
        dat    0,0
        rof

        qfac   equ 3213
        qdec   equ -1722

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
        jmp    warr,         <4000

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
qtab0   jmp    warr,         qb
qtab2   dat    qgap,         qf


