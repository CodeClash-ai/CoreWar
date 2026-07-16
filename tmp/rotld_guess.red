;redcode-94
;name rotld_guess
;assert CORESIZE == 8000
start   spl     1
        spl     1
        spl     1
paper   spl     @0,     <1031
        mov.i   }paper, >paper
        mov.i   }paper, >paper
        mov.i   }paper, >paper
        spl     @0,     <2032
        mov.i   }paper, >paper
        mov.i   }paper, >paper
        mov.i   }paper, >paper
        spl     @0,     <3035
        mov.i   }paper, >paper
        mov.i   }paper, >paper
        mov.i   }paper, >paper
        spl     @0,     <4036
        mov.i   }paper, >paper
        mov.i   }paper, >paper
        mov.i   }paper, >paper
        spl     @0,     <5039
        mov.i   }paper, >paper
        mov.i   }paper, >paper
        mov.i   }paper, >paper
        jmp     paper,  <7043
        dat.f 0,0
        dat.f 0,0
        dat.f 0,0
        dat.f 0,0
        dat.f 0,0
        dat.f 0,0
        dat.f 0,0
        dat.f 0,0
        end     start
