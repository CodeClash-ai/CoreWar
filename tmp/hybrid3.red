;redcode-94
;name hybrid3
;assert CORESIZE == 8000
step equ 1031
start   spl     stone1
        spl     stone2
        spl     stone3
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
stone2  mov.i   db,     2000
        add.ab  #step,  stone2
        jmp     stone2
stone3  mov.i   sb,     3000
        add.ab  #step,  stone3
        jmp     stone3
sb      spl     #0,     #0
db      dat.f   #0,     #0
        end     start
