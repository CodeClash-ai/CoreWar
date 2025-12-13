;redcode-94
;name Golden Eye
;author Roy van Rijn
;strategy Satellite papers launching imps and stones
;assert 1

      ORG    qBob

      qA      EQU    1496
      qB      EQU    2746
      qC      EQU    4995
      qD      EQU      750
      qE      EQU      494
      qF      EQU      644
      qG      EQU    5694
      qH      EQU    5550
      qI      EQU    5192

      qHop    EQU    3857

      qOff01  EQU    ((qG * qD) % CORESIZE)
      qOff02  EQU    (((qG-1) * qD) % CORESIZE)
      qOff03  EQU    ((qI * qD) % CORESIZE)
      qOff04  EQU    (((qI-1) * qD) % CORESIZE)
      qOff05  EQU    ((qB * qH) % CORESIZE)
      qOff06  EQU    (((qB-1) * qH) % CORESIZE)
      qOff07  EQU    ((qF * qH) % CORESIZE)
      qOff08  EQU    (((qF-1) * qH) % CORESIZE)
      qOff09  EQU    ((((qC * qD) % CORESIZE) * qH) % CORESIZE)
      qOff10  EQU    (((((qC-1) * qD) % CORESIZE) * qH) % CORESIZE)
      qOff11  EQU    ((((qE * qD) % CORESIZE) * qH) % CORESIZE)
      qOff12  EQU    (((((qE-1) * qD) % CORESIZE) * qH) % CORESIZE)
      qOff13  EQU    ((((qA * qD) % CORESIZE) * qH) % CORESIZE)
      qOff14  EQU    (((((qA-1) * qD) % CORESIZE) * qH) % CORESIZE)
      qOff15  EQU    ((qD * qH) % CORESIZE)
      qOff16  EQU    ((qD * (qH-1)) % CORESIZE)
      qOff17  EQU    qFree
      qOff18  EQU    qD
      qOff19  EQU    (((((qC-1) * qD) % CORESIZE) * (qH-1)) % CORESIZE)

qBob    sne.i  qFound + qOff01,                qFound + qOff01 + qHop
      seq.i  < (qTab2 - 1),                  qFound + qOff02 + qHop
      jmp    qDec0,                          { qDec0
      sne.i  qFound + qOff03,                qFound + qOff03 + qHop
      seq.i  < (qTab2 + 1),                  qFound + qOff04 + qHop
      jmp    qDec0,                          } qDec0
      sne.i  qFound + qOff05,                qFound + qOff05 + qHop
      seq.i  < (qTab1 - 1),                  qFound + qOff06 + qHop
      jmp    qDec0,                          < qDec1
      sne.i  qFound + qOff07,                qFound + qOff07 + qHop
      seq.i  < (qTab1 + 1),                  qFound + qOff08 + qHop
      jmp    qDec0,                          > qDec1
      sne.i  qFound + qOff09,                qFound + qOff09 + qHop
      seq.i  { qTab1,                        qFound + qOff10 + qHop
      jmp    qDec1,                          } qFound + qOff09 - 4
      sne.i  qFound + qOff11,                qFound + qOff11 + qHop
      seq.i  { (qTab1 + 1),                  qFound + qOff12 + qHop
      jmp    qDec1,                          } qDec1
      sne.i  qFound + qOff13,                qFound + qOff13 + qHop
      seq.i  { (qTab1 - 1),                  qFound + qOff14 + qHop
      jmp    qDec1,                          { qDec1
      sne.i  qFound + qOff15,                qFound + qOff15 + qHop
      seq.i  qFound + qOff16,                < qTab2
      jmp    qDec0,                          } qFound + qOff15 - 4
      seq.i  qFound + qOff17,                qFound + qOff17 + qHop
      jmp    qSelect,                        } qFound + qOff17 - 4
      seq.i  qFound + qOff18,                qFound + qOff18 + qHop
      jmp    qSetup,                        } qFound + qOff18 - 4
      sne.i  qFound + qOff19,                qFound + qOff19 + qHop
      jmz.f  qTab2,                          qFound + qOff19 + qHop + 1

qDec1  mul.ab  qTab1,                          qTab1
qDec0  mul.b  qTab2,                          @ qDec1
qSetup  mov.b  @ qDec1,                        qFound

qSelect sne.i  qEmpty,                        @ qFound
      add.ab  # qHop,                        qFound

      qOffset EQU      -70
      qTimes  EQU      18
      qStep  EQU        5


      qFree  EQU      2031

qAttack mov.i  qBomb,                          @ qFound
qFound  mov.i  qBomb,                          } qFree
      add.ab  # qStep,                        qFound
      djn    qAttack,                        # qTimes
      jmp    qTab2

qEmpty  dat.f  0,                              0

      dat.f  qA,                            qB
qTab1  dat.f  qC,                            qD
      dat.f  qE,                            qF

qBomb  dat.f  > qOffset,                      > 1

for 8
      dat 0                  , 0
rof

iStep  equ    2667

pStep1  equ    3698
pStep2  equ    6133

c0      spl    @0              , pStep1
      mov    }-1            , >-1
      mov    <1              , {1
cs      jmz.a  pStep1-pBoo1    , -pBoo1

for 4
      dat 0                  , 0
rof

c0a    spl    @0              , pStep2
      mov    }-1            , >-1
      mov    <1              , {1
csa    jmz.a  pStep2-pBoo2    , -pBoo2

for 4
      dat 0                  , 0
rof

iStart  spl    #0              , {392
      add.x  imp              , 1
      djn.f  imp-(iStep*4)    , <3881
imp    mov.i  #5501            , iStep

for 8
      dat 0                  , 0
rof

stn    spl    #0              , {6869
      mov.i  }1861          , {7687
      add.f  {0              , }0
pEnd    djn.f  @0              , {-2

for 8
      dat 0                  , 0
rof

      dat    0              , qG
qTab2  spl    1              , {qH
      spl    1              , {qI

pBoo1  equ    7262
pBoo2  equ    4691

      mov    <pSt,          {pSt
pSt    spl    pEnd+pBoo1+2,  cs+1

      mov    <iSt,          {iSt
iSt    jmp    imp+pBoo2+2,    csa+1


end
