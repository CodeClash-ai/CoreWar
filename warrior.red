;redcode-94nop
;name Cloudburst
;author John Metcalf
;strategy qscan -> hydra/imps
;assert CORESIZE==8000

        org    qscan

        first  equ 7068
        step   equ 1808

tspl    spl    #-1986,       <boot
        mov.i  #1,           <boot
boot    mov    tdjn,         first
        add    #step,        boot
        mov    tspl,         @boot
        djn.f  @boot,        {tspl
tdjn    djn    -2,           #2510

        for    9
        dat    0,            0
        rof

        qfac   equ 1677
        qdec   equ -3386
        qa     equ (qfac*(qtab0-1-qptr)+1)
        qb     equ (qfac*(qtab0-qptr)+1)
        qc     equ (qfac*(qtab1-1-qptr)+1)
        qd     equ (qfac*(qtab1-qptr)+1)
        qe     equ (qfac*(qtab1+1-qptr)+1)
        qf     equ (qfac*(qtab2-qptr)+1)
        qtime  equ 17
        qstep  equ -7
        qgap   equ 87

qdecode mul.b  *q1,          qptr
q0      sne    {qtab0,       @qptr
q1      add.b  qtab1,        qptr
q2      mov    qtab2,        @qptr
qptr    mov    qtab2,        *qdec
        add    #qstep,       qptr
        djn    q2,           #qtime
        jmp    warr

qscan   sne    qptr+qdec*qe, qptr+qdec*qe+qe
        seq    <qtab1+1,     qptr+qdec*(qe-1)+(qe-1)
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
        seq    <qtab1-1,     qptr+qdec*(qc-1)+(qc-1)
        jmp    qdecode,      {q1
        sne    qptr+qdec*qd, qptr+qdec*qd+qd
        seq    <qtab1,       qptr+qdec*(qd-1)+(qd-1)
        jmp    qdecode,      qa
qtab0   jmp    warr,         qb
qtab2   dat    {qgap,        qf

        for    44
        dat    0,            0
        rof

        istep  equ 1143
        pstep  equ -3016
        dpos   equ -409
        pdist  equ paper+3024

warr    spl    tspl,         <4000
        spl    1,            >qc
qtab1   spl    1,            >qd
        spl    1,            >qe

pboot   spl    pdist,        paper
        mov    >pboot,       }pboot
paper   spl    @0,           >pstep
        mov.i  }paper,       >paper
        spl    #0,           0
        add.f  #istep,       iboot
iboot   djn.f  imp-istep*8,  <dpos
imp     mov.i  #1,           istep

        end

