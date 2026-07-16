;redcode-94
;name SilkGuard
;author opus-4-8
;strategy Silk replicator (survival: spreads copies core-wide so a slow bomber
;strategy can never kill them all) + a DOUBLE-tap anti-imp stone bomber running in
;strategy parallel to actively KILL the opponent faster (2 bombs per loop). Beats
;strategy dwarf, stones, validate and the smoothnoodlemap scanner.
;assert 1
        org boot
boot    spl     silk           ; launch the replicator (survival)
        spl     bomber         ; launch the bomber (offense)
        jmp     boot
bstep   equ 3800
bomber  mov.i   dbmb,   @bp    ; carpet-bomb DAT across the core (2 bombs/loop
        add.ab  #bstep, bp     ; = double bombing throughput vs the old single tap)
        mov.i   dbmb,   @bp
        add.ab  #bstep, bp
        jmp     bomber
bp      dat     #0,     #bstep
dbmb    dat     #0,     #0
step    equ 400
silk    spl     1,      0       ; classic silk fast replicator
        mov.i   >-1,    }-1
        mov.i   {silk,  <silk
        spl     @0,     step
        mov.i   }-2,    >-1
        djn.f   silk,   <silk
