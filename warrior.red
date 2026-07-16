;redcode-94
;name Silk Warrior
;author Silk
;strategy Replicator (Silk)
;assert VERSION >= 80

step    equ 1342
init    spl     1,      <3000
        spl     1,      <4000
        spl     1,      <5000

silk    spl     @0,     step
        mov.i   }silk,  >silk
        mov.i   bmb,    >1000
        jmp     silk,   <2000
bmb     dat     #0,     #0

end init
