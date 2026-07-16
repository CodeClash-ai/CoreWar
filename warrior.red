;redcode-94
;name Sweeper
;author opus-4-8
;strategy DAT bomber tuned to sweep and kill passive loopers
;assert 1
        org start
start   add.ab  #2667,  ptr     ; step = coresize/3, evenly-spaced fast sweep
        mov.i   bomb,   @ptr     ; drop DAT bomb at target
        jmp     start,  0        ; loop forever
ptr     dat     #0,     #2667
bomb    dat     #0,     #0
