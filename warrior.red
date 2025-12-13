;redcode verbose
;name  CAPS KEY IS STUCK AGAIN
;author  Steven Morrell
;strategy  Imp ring and simple bomber with 2-pass imp-killing core-clear
;strategy  Version 1.1  complete decrement protection, imp-gate

step equ 1645
x equ first+200
there equ first-109

first     dat <-6,#0
          dat <-5,#0
          mov 0,2667
          mov 0,2667
          mov 0,2667
p1        dat <2667,<split
          spl 0,<-4
split     spl 0,<-4
          mov @p1,<p2
          jmp -1,<-6+1
          dat <2667,<there
p2        dat <2667,<there

bomber    spl 0,<-18
          mov <2+step,2+4000+step
          add d,-1
          djn -2,<-21
d         dat <step,<step
bonk      jmp first-(there)+4,<-21
boot      mov bomber+4,there+4
          mov bomber+3,<boot
          mov bomber+2,<boot
          mov bomber+1,<boot
          spl there
          mov bomber,<boot
          mov bonk,there+4002
          mov bonk,there+4001
          mov imp,x
          spl b
          spl ab
          spl aab
          jmp x
aab       jmp x+2667
ab        spl abb
          jmp x+5334
abb       jmp x+1
b         spl bb
          spl bab
          jmp x+2668
bab       jmp x+5335
bb        spl bbb
          jmp x+2
bbb       jmp x+2669
imp       mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667
          mov 0,2667

end boot
