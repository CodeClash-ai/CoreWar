;redcode-94
;name hybrid
;assert CORESIZE == 8000
step equ 1031
start   spl     stone
        spl     1
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
stone   mov.i   sb,     1000
        add.ab  #step,  stone
        jmp     stone
sb      spl     #0,     #0
        end     start
