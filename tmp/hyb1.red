;redcode-94
;name hyb1
;assert CORESIZE == 8000
step equ 1031
start   spl     stone1
        spl     1,      <1031
        spl     1,      <1030
        spl     1,      <1029
paper   spl     @0,     <2032
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
        spl     @0,     <6040
        mov.i   }paper, >paper
        mov.i   }paper, >paper
        mov.i   }paper, >paper
        spl     @0,     <7043
        mov.i   }paper, >paper
        mov.i   }paper, >paper
        mov.i   }paper, >paper
        jmp     paper,  <7043
stone1  mov.i   sb,     1000
        add.ab  #step,  stone1
        jmp     stone1
sb      spl     #0,     #0
db      dat.f   #0,     #0
        end     start
