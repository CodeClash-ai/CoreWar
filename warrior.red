;redcode-94nop
;name Kosmos
;author John Metcalf
;strategy double satellite
;assert CORESIZE==8000

        org qscan

        step   equ 644
        dist   equ launch+4680

warr    spl    1,          satel
        spl    1,          <4000

        mov    >warr,      }boot
        mov    >warr,      >boot

paper   spl    step
        mov    >paper,     }paper
        mov    <launch,    {launch
launch  djn.f  step*2+dist,*dist

boot    dat    dist-4,     dist+step-4

satel   spl    #4000,      <-2
        mov    1,          <1
        mov    <0,         <3703
        djn.f  satel,      <satel-2

        istep  equ 2667

sat2    spl    #istep+2,   1
        spl    istep+1,    <4000
        mov    >sat2,      }sat2
imp     mov.i  #istep,     *0

        for 53
        dat 0,0
        rof

        qfac   equ 1861
        qdec   equ 1742

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

        end

