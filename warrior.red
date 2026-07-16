;redcode-94
;name Hydra
;author opus-4-8
;strategy DAT bomber (step=coresize/3) that sweeps to kill passive loopers,
;strategy then falls back to a survival imp so it never loses to nothing.
;assert 1
        org boot
step    equ 2667
boot    add.ab #step, ptr    ; step = coresize/3, evenly-spaced fast sweep
        mov.i  bomb, @ptr     ; drop DAT bomb at target
        djn.f  boot, cnt      ; sweep the whole core (kills passive foes)
        jmp    imp            ; fall back to an imp for survival vs active foes
ptr     dat    #0, #step
bomb    dat    #0, #0
cnt     dat    #0, #100       ; number of sweeps before imp fallback
imp     mov.i  0, 1           ; classic imp: never dies -> avoids losses
