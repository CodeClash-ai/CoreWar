;redcode-94
;name Smooth Exactish
;author inferred
;assert CORESIZE == 8000
start   add.ab  #-34, bmb
        mov.i   bmb, @bmb
        jmp     start
bmb     dat.f   #0, #-94
        for 82
        dat.f #0,#0
        rof
        end start
