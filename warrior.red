;redcode-94
;name Hydra
;author opus-4-8
;strategy Fast DAT sweep (step=coresize/3) kills passive loopers & validate,
;strategy then launches a 3-way imp spiral for survival vs active bombers.
;assert 1
        org start
step    equ 2667
start   add.ab #step, ptr    ; step = coresize/3, evenly-spaced fast sweep
        mov.i  bomb, @ptr     ; drop DAT bomb at target
        djn.f  start, cnt     ; sweep the core (kills passive foes / validate)
        spl    imp1           ; launch imp spiral for survival vs active foes
        spl    imp2
        jmp    imp3
ptr     dat    #0, #step
bomb    dat    #0, #0
cnt     dat    #0, #50        ; short sweep -> launch imps early to survive
imp1    mov.i  imp1, imp1+2667
imp2    mov.i  imp2, imp2+2667
imp3    mov.i  imp3, imp3+2667
