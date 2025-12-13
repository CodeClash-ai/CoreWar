;redcode-94nop quiet
;name Ziggy
;author Roy van Rijn
;assert 1

sAway   equ     2079
pAway   equ     1008

zero    equ     qbomb

qtab3   equ     qbomb
qbomb   dat     >qoff           , >qc2

wGo     mov     hBomb           , wGo+sAway+hOff
        spl     }2              , }qb1
qtab2   spl     1               , }qb2
        spl     0               , }qb3

        mov     {dGo            , {dBoo
dBoo    spl     wGo+sAway+6     , }1933
        mov     <pPtr           , {pBoo
        spl     *dBoo           , }4788
pBoo    djn.f   wGo+pAway+6     , }2803

for     7
        dat     0               , 0
rof
        dat     zero-1          , qa1
qtab1   dat     zero-1          , qa2

        dat     0               , 0

hStep   equ    3039
hTime   equ    3360
hDjn    equ    4326
hOff    equ    28

dGo     spl     #6              , <4
        mov     dGo+hOff        , @hPtr
hHit    add     #hStep*2        , hPtr
hPtr    mov     dGo+hOff        , }hHit-hStep*hTime
        djn.f   -3              , {hDjn

        dat     0               , 0
        dat     0               , 0
        dat     0               , 0
        dat     0               , 0

pStep1  equ     3157;1406
bStep1  equ     5778;7099

pGo     mov.i   #pBmb+1         , {bStep1
        mov.i   {pGo            , <pCopy
pCopy   spl     @0              , }pStep1
        mov.i   pBmb            , <pCopy
        jmn.b   pGo             , }pGo
pBmb    dat     <5334           , <2667

for     29
        dat     0               , 0
rof

hBomb   dat     }hStep          , >1

qc2     equ ((1+(qtab3-qptr)*qy)%CORESIZE)
qb1     equ ((1+(qtab2-1-qptr)*qy)%CORESIZE)
qb2     equ ((1+(qtab2-qptr)*qy)%CORESIZE)
qb3     equ ((1+(qtab2+1-qptr)*qy)%CORESIZE)
qa1     equ ((1+(qtab1-1-qptr)*qy)%CORESIZE)
qa2     equ ((1+(qtab1-qptr)*qy)%CORESIZE)

qy      equ 5931
qz      equ 3972

;q0 mutation
qgo

        sne     qptr+qz*qa1     , qptr+qz*qa1+qb2
        seq     <(qtab1-1)      , qptr+qz*(qa1-1)+qb2
        djn.a   q0              , {q0
        sne     qptr+qz*qc2     , qptr+qz*qc2+qb2
        seq     <qtab3          , qptr+qz*(qc2-1)+qb2
        jmp     q0              , }q0
        sne     qptr+qz*qa2     , qptr+qz*qa2+qb2
        seq     <qtab1          , qptr+qz*(qa2-1)+qb2
        jmp     q0              , {q0
                                        ;q1 mutation
        sne     qptr+qz*qb3     , qptr+qz*qb3+qb3
        seq     <(qtab2+1)      , qptr+qz*(qb3-1)+(qb3-1)
        jmp     q0              , }q1
        sne     qptr+qz*qb1     , qptr+qz*qb1+qb1
        seq     <(qtab2-1)      , qptr+qz*(qb1-1)+(qb1-1)
        jmp     q0              , {q1
        sne     qptr+qz*qb2     , qptr+qz*qb2+qb2
        seq     <qtab2          , qptr+qz*(qb2-1)+(qb2-1)
        djn.f   q0              , <6907

                                        ;qz mutation
        seq     >qptr           , qptr+qz+(qb2-1)
        jmp     q2              , <qptr
                                        ;q0 mutation
        seq     qptr+(qz+1)*(qc2-1),qptr+(qz+1)*(qc2-1)+(qb2-1)
        jmp     q0              , }q0
        seq     qptr+(qz+1)*(qa2-1),qptr+(qz+1)*(qa2-1)+(qb2-1)
        jmp     q0              , {q0
        seq     qptr+(qz+1)*(qa1-1),qptr+(qz+1)*(qa1-1)+(qb2-1)
        djn.a   q0              , {q0
        jmz.f   wGo             , qptr+(qz+1)*(qb2-1)+(qb2-1)

qoff    equ     -87
qstep   equ     -7
qtime   equ     19

q0      mul.b   *2              , qptr
q2      sne     {qtab1          , @qptr
q1      add.b   qtab2           , qptr
        mov     qtab3           , @qptr
qptr    mov     qbomb           , }qz
        sub     #qstep          , qptr
        djn     -3              , #qtime
pPtr    jmp     wGo             , pBmb+1
	end qgo

