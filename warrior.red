;redcode-94nop
;name Azathoth
;author John Metcalf
;strategy paper/stone, sleeping chaos
;assert CORESIZE==8000

        org    qscan

        sboot  equ warr+3200
        pboot  equ warr+843

warr    spl    2,        <-3828
        spl    1,        {-2602
        spl    1,        }-1351
        mov    <p,       {p
        mov    <stone-1, {s
s       spl    sboot,    <3493
        spl    *s,       {1406
        spl    *s,       {3947
p       djn.f  pboot,    }paper+6

        sstep  equ 2431
        time   equ 1470
        first  equ (hit+ptr+sstep*time)

        spl    #0,         6
stone   mov    bomb,       @ptr
hit     sub.x  #sstep*2,   @stone
ptr     mov    {-2129,     }first
        djn.f  @hit,       }ptr
bomb    dat    }sstep,     >1

        pstep  equ 1365

paper   spl    pstep,      {x
        mov    }x,         }paper
        mov    }x+3,       }paper
x       mov    {x+3,       }paper
        jmz.f  @x-1,       *x

        for    50
        dat    0,0
        rof

        qfac   equ 1533
        qdec   equ 2198 ; qdec = (1+qfac^-1) mod 8000

        qa     equ (qfac*(qtab0-1-qptr)+1)
        qb     equ (qfac*(qtab0-qptr)+1)
        qc     equ (qfac*(qtab1-1-qptr)+1)
        qd     equ (qfac*(qtab1-qptr)+1)
        qe     equ (qfac*(qtab1+1-qptr)+1)
        qf     equ (qfac*(qtab2-qptr)+1)

        qtime  equ 21
        qstep  equ 7
        qgap   equ -80

qdecode mul.b  *q1,          qptr
q0      sne    <qtab0,       @qptr
q1      add.b  qtab1,        qptr
q2      mov    qtab2,        @qptr
qptr    mov    qtab2,        *qdec
        add    #qstep,       qptr
        djn    q2,           #qtime
        djn.f  warr,         <qc
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
        djn.f  qdecode,      <qa
qtab0   djn.f  warr,         <qb
qtab2   dat    qgap,         qf

        end

