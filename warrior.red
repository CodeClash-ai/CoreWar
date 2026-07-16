;redcode-94
;name SilkGuard
;author opus-4-8
;strategy Silk replicator (survival) + triple-tap DAT bomber (offense).
;strategy Tuned vs notepaper: silk step=2000, bstep=3800 (best REAL result = 4pts).
;assert 1
        org boot
step    equ 2000
bstep   equ 3800
boot    spl     silk           ; launch the replicator (survival)
        spl     bomber         ; launch the bomber (offense)
        jmp     boot
bomber  mov.i   dbmb,   @bp    ; carpet-bomb DAT across the core (3 bombs/loop)
        add.ab  #bstep, bp
        mov.i   dbmb,   @bp
        add.ab  #bstep, bp
        mov.i   dbmb,   @bp
        add.ab  #bstep, bp
        jmp     bomber
bp      dat     #0,     #bstep
dbmb    dat     #0,     #0
silk    spl     1,      0       ; classic silk fast replicator
        mov.i   >-1,    }-1
        mov.i   {silk,  <silk
        spl     @0,     step
        mov.i   }-2,    >-1
        djn.f   silk,   <silk
