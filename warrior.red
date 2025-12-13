;redcode-94
;name Evol Cap 6.6
;author John Wilkinson
;strategy minimal kill++, maximal survival
;strategy Made slight change in basic engine, and optimized boot
;strategy towards getting away from qscans...
;assert 1

d       equ 1143
r       equ 15
i       equ 200
stinc    equ 190
BOOT_DIST equ 2600
BOOT_DIST2 equ 2924

org start

for 30
dat imp*3457, -imp*2359
rof

imp:       mov.i  #d, *0
jclr:      dat    >2667, 370

bootptr:   nop    evol+4, evol+BOOT_DIST+4

evol:      spl    #0,   <2
           add.a  #d,   1
           jmp    evol+i-d*8, >-5000
           dat    0,    0

start:     mov.i  imp,  evol+BOOT_DIST+i
           mov.i  jclr, evol+BOOT_DIST2+33+5

           spl.i  1, >-1250
           spl.i  1, >-1400
           mov.i  {bootptr, <bootptr
           spl.i  1, >1250

           mov.i  {jptr, <jptr
           spl    @bootptr, >1400
           jmp    @jptr, <bootptr

for 20
dat imp*3457, -imp*2359
rof

juliet: spl #445, >-445
        spl #0, >-446
        mov {445-1, -445+2
        add -3, -1
        djn.f -2, <-2667-350
        mov 33, >-350
        djn.b 1, <-800
        dat 0,    0

jptr:   nop    0, evol+BOOT_DIST2+8

for 25
dat imp*3457, -imp*2359
rof
