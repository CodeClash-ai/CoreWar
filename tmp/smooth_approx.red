;redcode-94
;name SmoothApprox
;author inferred
;assert CORESIZE == 8000
start   add.ab  #-34, ptr
        mov.i   bomb, @ptr
        jmp     start
ptr     dat.f   #0, #-91
bomb    dat.f   #0, #0
        for 81
        dat.f #0,#0
        rof
        end start
