;redcode-94
;name Silk Warrior 3
;author Silk
;strategy Replicator (Silk)
;assert VERSION >= 80

step1   equ 2037
step2   equ 1569

init    spl     1,      <3000
        spl     1,      <4000
        spl     1,      <5000

silk1   spl     @0,     step1
        mov.i   }silk1, >silk1
silk2   spl     @0,     step2
        mov.i   }silk2, >silk2
        mov.i   bmb,    >1000
        jmp     silk1,  <2000
bmb     dat     #0,     #0

end init
