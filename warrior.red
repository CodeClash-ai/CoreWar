;redcode-94nop
;name luca
;author Sascha Zapf
;strategy Q3.14 -> Paper/Stone
;assert 1

qhop equ 3800
qfirst equ pos1+200
qgap equ 200

spos01 equ qfirst
spos02 equ qfirst+qgap
spos03 equ qfirst+2*qgap
spos04 equ qfirst+3*qgap
spos05 equ qfirst+4*qgap
spos06 equ qfirst+5*qgap
spos07 equ qfirst+6*qgap
spos08 equ qfirst+7*qgap
spos09 equ qfirst+8*qgap
spos10 equ qfirst+9*qgap
spos11 equ qfirst+10*qgap
spos12 equ qfirst+11*qgap
spos13 equ qfirst+12*qgap
spos14 equ qfirst+13*qgap
spos15 equ qfirst+14*qgap
spos16 equ qfirst+15*qgap
spos17 equ qfirst+16*qgap
spos18 equ qfirst+17*qgap
spos19 equ qfirst+18*qgap
spos20 equ qfirst+19*qgap

org pos1

; === 2.5 cycles decoding

pos1     seq.i  spos01, spos01+qhop
         jmp    decode ;                 ; no decode

; === 3.5 cycles decoding

pos2     seq.i  spos02, spos02+qhop
         jmp    ultra                    ; vector + 2
pos3     seq.i  spos03, spos03+qhop
         jmp    ultra,  }ultra           ; vector + 4
pos4     seq.i  spos04, spos04+qhop
         jmp    ultra,  {ultra           ; vector + 6

; === 4.5 cycles decoding

pos5     seq.i  spos05, spos05+qhop
         djn.a  fast, {fast ;                  -> vector + 4 * 2
pos6     seq.i  spos06, spos06+qhop
         jmp    fast, {fast ;                 -> vector + 5 * 2
pos7     seq.i  spos07, spos07+qhop
         jmp    fast,}fast ;                   -> vector + 6 * 2
pos8     seq.i  spos08, spos08+qhop
         jmp    fast, {qtab           ;             -> vector + 7 *2
pos9     seq.i  spos09, spos09+qhop
         jmp    fast                            ; -> vector + 8 *2
pos10    seq.i  spos10, spos10+qhop
         jmp    fast, }qtab                 ; -> vector + 9 * 2

; === reset base vector

        mov.ab  #pos11-bline,bline

; === 2.5 cycles decoding

pos11    seq.i  spos12, spos12+qhop
         jmp    decode;                 ; no decode

; === 3.5 cycles decoding

pos12    seq.i  spos13, spos13+qhop
         jmp    ultra                        ; vector + 2
pos13    seq.i  spos14, spos14+qhop
         jmp    ultra,  }ultra           ; vector + 4
pos14    seq.i  spos15, spos15+qhop
         jmp    ultra,  {ultra          ; vector + 6

; === 4.5 cycles decoding

pos15    seq.i  spos16, spos16+qhop
         djn.a  fast, {fast ;                  -> vector + 4 * 2
pos16    seq.i  spos17, spos17+qhop
         jmp    fast, {fast ;                 -> vector + 5 * 2
pos17    seq.i  spos18, spos18+qhop
         jmp    fast, }fast ;                 -> vector + 6 * 2
pos18    seq.i  spos19, spos19+qhop
         jmp fast,  {qtab                      ;  -> vector + 7 *2
pos19    sne.i  spos20, spos20+qhop
                                               ; fall through -> vector + 8 *2
        jmz.f wGo, spos20+qhop+30

; === decode ===

fast    mul.ab  qtab,     *ultra
ultra   add.b  qtab,     bline

decode  add.ab  @bline, bline

; === choose target

choose  sne.i   pos1-1, @bline   ; a-target hit ?
        add.ab  #qhop, bline

; === qbomb ===

loop    mov.i   qbomb,  @bline
bline   mov.i   qbomb,  @pos1
        add.ab  #5,     bline
        djn.b   loop,   #20
        jmp     wGo

qbomb    dat {0,-75

        dat 5,6
qtab    dat 8,2
        dat 6,4

for 12
dat 0,0
rof

sAway   equ     7338;4854
pAway   equ     4372;562

wGo     mov     hBomb           , wGo+sAway+6+hOff
        spl     }2
        spl     1
        spl     0

        mov     <dGo            , {dBoo
dBoo    spl     wGo+sAway+6     , <1719
        mov     {pEnd           , {pBoo
        spl     *-2             , <7101
pBoo    djn.f   wGo+pAway+6     , <821

for 10
dat 0,0
rof

pStep1  equ     476+7796;561
bStep1  equ     4676+7796;7157

hStep   equ     17
hTime   equ     7485
hDjn    equ     2926
hOff    equ     7735

dGo     spl     #0              , 6
        mov     hBomb+hOff      , @hPtr
hHit    add     #hStep*2        , hPtr
hPtr    mov     hBomb+hOff      , }hHit-hStep*hTime
        djn.f   -3              , {hDjn
        dat     0               , 0
hBomb   dat     }hStep          , >1

        dat     0               , 0
        dat     0               , 0

pGo     spl     pStep1		, {3
        mov     }2		, }-1
        mov     pBmb		, >bStep1
        mov     3		, }-3
        jmz.f   -4		, *-1
pBmb    dat     <5334		, <2667
pEnd    dat     0		, 0

        end

