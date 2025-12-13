;redcode-94nop
;name Unpit
;author P. Kline
;assert 1==1
;strategy vamping with unpit

step   equ    7389
first  equ    (unpit+step*491)

vamp   sub.x  incr         ,}unpit
       mov    fang         ,*fang
       mov    {unpit       ,@fang
       jmz.f  0            ,unpit
       jmp    wipes        ,<wipeg

   for 11
       dat    0            ,0
   rof
wipeg  dat    0            ,0
wiped  dat    1            ,#8
wipes  spl    #3600        ,#wipen-wipeg
       mov    *wiped       ,>wipeg
       mov    *wiped       ,>wipeg
       djn.f  -2           ,}wipes
       dat    0            ,0
wipen  dat    0            ,0

   for 88-CURLINE
       dat    0            ,0
   rof
fang   jmp    >unpit-first ,>first
unpit  dat    0            ,0
incr   dat    #step        ,#-step

   for 5
       dat    0            ,0
   rof
ps     equ    (2916)
airbag spl    2            ,{unpit+ps+step
       spl    1            ,{unpit+ps+step*2
       djn.f  {vamp+3      ,{unpit+ps

       end    airbag
