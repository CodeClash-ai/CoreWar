;redcode-94
;name Silk Warrior 3
;author Silk
;strategy Replicator (Silk)
;assert VERSION >= 80

step1   equ 1897
step2   equ 6057
step3   equ 5011

init    spl     1,      <3445
        spl     1,      <5005
        spl     1,      <5366

silk1   spl     @0,     step1
        mov.i   }silk1, >silk1
silk2   spl     @0,     step2
        mov.i   }silk2, >silk2
silk3   spl     @0,     step3
        mov.i   }silk3, >silk3
        mov.i   bmb,    >1000
        jmp     silk1,  <2000
bmb     dat     #0,     #0

end init
