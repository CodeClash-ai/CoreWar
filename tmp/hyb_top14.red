;redcode-94
;name hybph14
;assert CORESIZE == 8000
step equ 1031
start   spl     stone1
        spl     stone2
        spl     stone3
        spl     stone4
        spl     stone5
        spl     stone6
        spl     stone7
        spl     stone8
        spl     stone9
        spl     stone10
        spl     stone11
        spl     stone12
        spl     stone13
        spl     stone14
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
stone1  mov.i   sb,     1030
        add.ab  #step,  stone1
        jmp     stone1
stone2  mov.i   db,     2031
        add.ab  #step,  stone2
        jmp     stone2
stone3  mov.i   sb,     3034
        add.ab  #step,  stone3
        jmp     stone3
stone4  mov.i   db,     4035
        add.ab  #step,  stone4
        jmp     stone4
stone5  mov.i   sb,     5038
        add.ab  #step,  stone5
        jmp     stone5
stone6  mov.i   db,     6039
        add.ab  #step,  stone6
        jmp     stone6
stone7  mov.i   sb,     7042
        add.ab  #step,  stone7
        jmp     stone7
stone8  mov.i   db,     1029
        add.ab  #step,  stone8
        jmp     stone8
stone9  mov.i   sb,     2030
        add.ab  #step,  stone9
        jmp     stone9
stone10  mov.i   db,     3033
        add.ab  #step,  stone10
        jmp     stone10
stone11  mov.i   sb,     4034
        add.ab  #step,  stone11
        jmp     stone11
stone12  mov.i   db,     5037
        add.ab  #step,  stone12
        jmp     stone12
stone13  mov.i   sb,     6038
        add.ab  #step,  stone13
        jmp     stone13
stone14  mov.i   db,     7041
        add.ab  #step,  stone14
        jmp     stone14
sb      spl     #0,     #0
db      dat.f   #0,     #0
        end     start
