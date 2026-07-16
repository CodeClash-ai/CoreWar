;redcode-94
;name Smooth Approx
;author inferred
;assert CORESIZE == 8000
start   add.ab  #-34, bmb
        mov.i   bmb, @bmb
        jmp     start
        for 82
        dat.f   #0,#0
        rof
bmb     dat.f   #0,#-176
        end start
