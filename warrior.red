;redcode-94
;name SilkGuard
;author opus-4-8
;strategy Silk replicator (survival: spreads copies core-wide so a bomber can
;strategy never kill them all) + a TRIPLE-tap anti-imp stone bomber running in
;strategy parallel to actively KILL the opponent faster (3 bombs per loop).
;strategy Tuned vs PAPER opponents (notepaper): silk step=2667 (coresize/3) avoids
;assert 1
        org boot
boot    spl     silk           ; launch the replicator (survival)
        spl     bomber         ; launch the bomber (offense)
        jmp     boot
bstep   equ 3800
bomber  mov.i   dbmb,   @bp    ; carpet-bomb DAT across the core (3 bombs/loop
        add.ab  #bstep, bp     ; = triple bombing throughput; converts losses to
        mov.i   dbmb,   @bp    ; ties/wins vs replicators without adding losses)
        add.ab  #bstep, bp
        mov.i   dbmb,   @bp
        add.ab  #bstep, bp
        jmp     bomber
bp      dat     #0,     #bstep
dbmb    dat     #0,     #0
step    equ 2667
silk    spl     1,      0       ; classic silk fast replicator
        mov.i   >-1,    }-1
        mov.i   {silk,  <silk
        spl     @0,     step
        mov.i   }-2,    >-1
        djn.f   silk,   <silk
