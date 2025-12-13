;redcode-94nop
;name Macro Magic
;author John Metcalf
;strategy scanner
;assert CORESIZE == 8000

        org qscan

        step   equ 4961
        hit    equ 3   ; location of the final scan (first line is 0)
        invis  equ 5   ; location of invisible instruction
        length equ 9   ; length of scanner

; --------------------------------------
; calculate # of scans before self-scan
; --------------------------------------

        for CORESIZE+!(f=1)*(h=hit)
        for !t=t+(f=f*((h=(h+step)%CORESIZE)>=length||h==invis))
        rof
        rof

        time   equ t
        first  equ (hit+attack+step*time)

; --------------------------------------

        warr   equ scan+1
        gate   equ scan

attack  mov    *sbmb,      >scan
        mov    jbmb,       @scan
scan    sub    #step,      #first
jbmb    jmz.f  scan,       @scan     ; hit
        djn    @0,         @attack
sbmb    spl    #0,         0         ; invis
clear   mov    dbmb,       >gate
        djn.f  clear,      >gate
dbmb    dat    <1,         3-gate

        for 61
        dat 0,0
        rof

        qfac   equ 1111
        power  equ 3199

; --------------------------------------
; calculate power using the binary method
; --------------------------------------

;       qdec   equ 1+qfac^power

        for 20+!(r=1)*(x=qfac)*(n=power)
        for n%2
        for !r=(r*x)%CORESIZE
        rof
        rof
        for !x=(x*x)%CORESIZE+!n=n/2
        rof
        rof

        qdec   equ (r+1)

; --------------------------------------

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

