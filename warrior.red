;redcode-94
;name BIgital SHOT
;author Christian Schmidt
;strategy .66c Bishot-style Scanner
;strategy with an anti-imp coreclear
;url http://www.corewar.info
;assert 1

sSt     equ    5
gap     equ    12
cOff    equ    743

sOne    add.f   #sPtr,       sPtr
       sne.i   *sPtr,       @sPtr
       djn.f   sOne,        @sPtr
       djn.f   clear,       sPtr

for sSt
       dat     0,           0
rof

sPtr    dat    4009+cOff, {gap+cOff
jumper  jmp    4009,      gap
       dat    0,         0
       dat    0,         0
       jmp    7829,      <1143;2667
clear   spl    #4007,     gap
       mov    @switch,   >sPtr
       mov    jumper,    }sPtr
switch  djn    clear+1,   {clear

       for    61
       dat    0     ,  0
       rof

tDecoy    equ    sPtr+4660
tStart    mov    <tDecoy+0,{tDecoy+2
         mov    <tDecoy+3,{tDecoy+5
         mov    <tDecoy+6,{tDecoy+8
         mov    <tDecoy+10,{tDecoy+12
         djn.f  sOne+1 ,<tDecoy+14

end tStart

