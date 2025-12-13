;redcode-94 quiet
;assert CORESIZE==8000
;name Electric Razor
;author David Moore
;strategy based on Electric Head by Anton Marsden
;strategy and Razor by Michal Janeczek.
;strategy This uses a P^3 like the one in Core Warrior 70
;strategy except that this improved P^3 doesn't require the P^3 codes
;strategy to be pre-calculated by the author.
;strategy With the right formula, the simulator does the work for you!

ORG pBegin

;--------------
;THE CORE CLEAR
;--------------

cGate1 equ (cBomb1-19)
cGate2 equ (cBomb1-18)
cBomb2 equ (cBomb1+22)
cBoot  equ 5500

        dat       19      ,   500   ; 1: 1/1
        dat      -4040    ,  4045   ; 2: 2/2
cBomb1  spl #cBomb2-cGate1,    45   ;20: 5/4
        mov     *cGate1   , >cGate1 ; 1: 1/1
        mov     *cBomb2+2 , >cGate2 ; 2: 2/2
        djn.f    -1       , {cGate2 ; 3: 3/3
        dat       1       ,    45   ; 2: 2/2
        spl     #-40      ,    45   ; 3: 3/3

cTCC   mov  cBomb1-1, @cDest
       mov {-1, <cDest
       add #23,  cDest
       spl   1,  cBomb1+4
       mov <cTCC+3, <cDest
cDest  mov {cTCC+1, {cBoot
       mov <cTCC+3, <cDest
       djn @cDest,  #2
       div.f   #0,   cDest

  for 13
    dat 0,0
  rof

;-------
; P^3
;-------

; Here is a handy formula:
;
;     n is any integer such that n is odd and n > 0.
;     X(n) = (n+2) * (n+1) * ((n+1)/2)
;     Y(n) = n * n * (n+2)
;     Z(n) = n * (n+3) * ((n+1)/2)
;     S(n) = n * (n+1) * (n+2)
;     F(n,a,b,c) = (a * X(n) + b * Y(n) + c * Z(n)) modulo S(n)
;
; The following are all true:
;
;     F(n,a,b,c) modulo (n+0) = a modulo (n+0)
;     F(n,a,b,c) modulo (n+1) = b modulo (n+1)
;     F(n,a,b,c) modulo (n+2) = c modulo (n+2)

pN0 equ 9  ; must be odd   ; n+0
pN1 equ (pN0+1)   ; n+1
pN2 equ (pN0+2)   ; n+2
pX  equ (pN2*pN1*(pN1/2))   ; X(n)
pY  equ (pN0*pN0*pN2)    ; Y(n)
pZ  equ (pN0*(pN0+3)*(pN1/2))   ; Z(n)
pS  equ (pN0*pN1*pN2)   ; S(n)

pModOnLoss equ pN1
pModOnWin  equ pN0
pModOnTie  equ pN2
pIfLoss equ pY
pIfWin  equ pX
pIfTie  equ pZ

pAddr equ 333 ; pspace address containing current state

pBegin ldp.a      #0, pMods
       ldp.a  #pAddr, pTable
       mod.ba *pMods, pTable
       stp.b *pTable, #pAddr
pTable jmp }0   , ( 1*pIfLoss +  0*pIfWin +  1*pIfTie) % pS ; state  0
       dat  cTCC, ( 2*pIfLoss +  0*pIfWin +  2*pIfTie) % pS ; state  1
       dat  cTCC, ( 3*pIfLoss +  0*pIfWin +  3*pIfTie) % pS ; state  2
       dat eRazr, ( 4*pIfLoss +  3*pIfWin +  3*pIfTie) % pS ; state  3
       dat eRazr, ( 5*pIfLoss +  3*pIfWin +  4*pIfTie) % pS ; state  4
       dat eRazr, ( 6*pIfLoss +  4*pIfWin +  5*pIfTie) % pS ; state  5
       dat  silk, ( 7*pIfLoss +  6*pIfWin +  0*pIfTie) % pS ; state  6
       dat bCarb, ( 8*pIfLoss +  7*pIfWin +  7*pIfTie) % pS ; state  7
       dat bCarb, ( 9*pIfLoss +  7*pIfWin +  8*pIfTie) % pS ; state  8
       dat bCarb, ( 3*pIfLoss +  8*pIfWin +  9*pIfTie) % pS ; state  9
       dat bCarb, ( 9*pIfLoss +  7*pIfWin +  8*pIfTie) % pS ; state 10
pMods  dat 0, pModOnLoss  ; previous cell can be anything non-zero
silk   spl 1, pModOnWin
       spl 1, pModOnTie

;----------
;MINI PAPER
;----------

       spl   @0,   4340
       mov   }-1, >-1
       mov   {-2, <1
       jmp   @0,  >4483

  for 10
    dat 0,0
  rof

;-----------
;CARBONITE++
;-----------

bDec  equ (bTar-615)
bBoot equ 7000

bBomb dat   >-1, >1
      spl    #0, <bDec
      mov 261, bTar-261*3339  ; original was MOV 197, bTar-197*3500
bTar  add.ab {0, }0
      djn.f  -2, <bDec

bCarb mov  bTar+1,  <bDest
      mov  bTar+0,  <bDest
      mov  bTar-1,  <bDest
bDest mov   bBomb,  *bBoot
      spl  <bDest,  >2000
      mov   bTar-2, @bDest
      mov.ab #-1560,  bDest+bBoot-2+(bDec-bTar)
      div.f  #0,     bDest

  for 2
    dat 0,0
  rof

;-------
; RAZOR
;-------

eStep1  equ   7
eStep2  equ   9
eSelf   equ  13
ePtr    equ (eInc-eStep1-1)
eBoot   equ 1110

eDat    dat    4100     ,  148

eSpl    spl   #1        , }1
eWipe   mov    eSpl     , <ePtr
        mov   >ePtr     , >ePtr
        jmn.f  eWipe    , >ePtr
eInc    sub.x #-eStep2-2,  ePtr
        sne   {ePtr     , <ePtr
        jmz.f  eInc     , <ePtr
        sne    eSpl-1   , >ePtr
        mov.x @eInc     , @eInc
        slt.b @eInc     , #eEnd+3-ePtr
        djn.f  eWipe    , @eInc
        djn    eInc     , #eSelf
eEnd    jmp    eInc     , {eWipe

eRazr   mov {eSrc, <eDest
        mov {eSrc, <eDest
        mov {eSrc, <eDest
        mov {eSrc, <eDest
        djn  eRazr,  #3
        spl @eDest,  {eSrc
eDest   mov  eDat,   @eBoot
eSrc    mov  eEnd+1, <eDest
        div.f  #0,    eDest

END

