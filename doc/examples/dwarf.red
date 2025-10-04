;redcode-94
;name Dwarf
;author A. K. Dewdney
;strategy A simple warrior

start   add.ab  #4, bmb
        mov.i   bmb, @bmb
        jmp     start
bmb     dat     #0, #0
