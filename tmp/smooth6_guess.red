;redcode-94
;name Smooth6Guess
;assert CORESIZE == 8000
src     spl     1
        spl     1
        spl     1
paper   spl     @0,     <-309
        mov.i   }paper, >paper
        mov.i   }paper, >paper
        mov.i   }paper, >paper
        mov.i   }paper, >paper
        mov.i   }paper, >paper
        jmp     paper,  <-251
        for 90
        dat.f 0,0
        rof
        end src
