;redcode-94nop
;name vamps are back 0.2
;author elkauka
;strategy hybrid vampire/scanner
;assert 1

;; Qscan Constants

        zero    EQU     qbomb
        qtab3   EQU     qbomb
        qz      EQU     2108
        qy      EQU     243

        qc2     EQU     ((1 + (qtab3-qptr)*qy) % CORESIZE)
        qb1     EQU     ((1 + (qtab2-1-qptr)*qy) % CORESIZE)
        qb2     EQU     ((1 + (qtab2-qptr)*qy) % CORESIZE)
        qb3     EQU     ((1 + (qtab2+1-qptr)*qy) % CORESIZE)
        qa1     EQU     ((1 + (qtab1-1-qptr)*qy) % CORESIZE)
        qa2     EQU     ((1 + (qtab1-qptr)*qy) % CORESIZE)

        qoff    EQU     -88
        qstep   EQU     -7
        qtime   EQU     20

;; Constants for optimization

        trap    EQU     6941
        vSTEP   EQU     4691
        vTIME   EQU     73
        pBoot   EQU     5235

        dat     0,                      0
qbomb   dat     > qoff,                 > qc2

;; 45 instructions

pGo     spl     1,                      zero+pBoot+1

FOR 6
        mov.i   { bomb+1,               < pGo
ROF
        djn     zero+pBoot-8,           # 1
        mov.i   1,                      -1

gate    dat     trap,                   0
fang    jmp     gate+trap,              0
loop    mov.i   inc,                    } gate
        add.f   inc,                    fang
        mov.i   fang,                   @ fang
        jmz.f   loop,                   * fang
ptr     mov.a   fang,                   gate
        djn.b   loop,                   # vTIME
inc     spl     # vSTEP,                # -vSTEP
clear   mov     bomb,                   > loop
        djn.f   -1,                     > loop
bomb    dat     < 2667,                 13

FOR 24
        dat     0,                      0
ROF

;;

        dat     0,                      < qb1
qtab2   dat     0,                      < qb2
        dat     0,                      < qb3

FOR 4
        dat     0,                      0
ROF

        dat     zero-1,                 qa1
qtab1   dat     zero-1,                 qa2

FOR 5
        dat     0,                      0
ROF

qgo     sne     qptr+qz*qc2,            qptr+qz*qc2+qb2
        seq     <qtab3,                 qptr+qz*(qc2-1)+qb2
        jmp     q0,                     } q0

        sne     qptr+qz*qa2,            qptr + qz*qa2 + qb2
        seq     < qtab1,                qptr+qz*(qa2-1)+qb2
        jmp     q0,                     { q0

        sne     qptr+qz*qa1,            qptr+qz*qa1+qb2
        seq     < (qtab1-1),            qptr+qz*(qa1-1)+qb2
        djn.a   q0,                     { q0

        sne     qptr+qz*qb3,            qptr+qz*qb3+qb3
        seq     < (qtab2+1),            qptr+qz*(qb3-1)+(qb3-1)
        jmp     q0,                     } q1

        sne     qptr+qz*qb1,            qptr+qz*qb1+qb1
        seq     < (qtab2-1),            qptr+qz*(qb1-1)+(qb1-1)
        jmp     q0,                     { q1

        sne     qptr+qz*qb2,            qptr+qz*qb2+qb2
        seq     < qtab2,                qptr+qz*(qb2-1)+(qb2-1)
        jmp     q0,                     } 4443 ; extra attack

        seq     > qptr,                 qptr+qz+(qb2-1)
        jmp     q2,                     < qptr

        seq     qptr+(qz+1)*(qc2-1),    qptr+(qz+1)*(qc2-1)+(qb2-1)
        jmp     q0,                     } q0

        seq     qptr+(qz+1)*(qa2-1),    qptr+(qz+1)*(qa2-1)+(qb2-1)
        jmp     q0,                     { q0

        seq     qptr+(qz+1)*(qa1-1),    qptr+(qz+1)*(qa1-1)+(qb2-1)
        djn.a   q0,                     { q0

        jmz.f   pGo,                    qptr+(qz+1)*(qb2-1)+(qb2-1)

q0      mul.b   * 2,                    qptr
q2      sne     { qtab1,                @ qptr
q1      add.b   qtab2,                  qptr
        mov     qtab3,                  @ qptr
qptr    mov     qbomb,                  } qz
        sub     # qstep,                qptr
        djn     -3,                     # qtime

        jmp     pGo,                    } 3256 ; extra attack

FOR 4
        dat     0,              0
ROF

        END     qgo

