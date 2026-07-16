;redcode-94
;name Return Mirror 1031
;author gpt-5-5
;strategy Opponent-specific paper mirror for "return of the living dead".
;strategy Round-2 lattice carpet converted many losses to ties (sample 58 ties)
;strategy but still got no wins.  The traces reveal a 33-line silk/paper whose
;strategy first writes are the local body and copy points +1031,+2032,+3035,
;strategy +4036,+5039,+6040,+7043.  This version mirrors that launch/copy
;strategy lattice as closely as possible, aiming to survive as the same paper
;strategy and draw/win races instead of being a stationary target.
;assert CORESIZE == 8000
;assert MAXLENGTH >= 33
start   spl     1,      <1031
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
        dat.f   #0,     #0
        dat.f   #0,     #0
        dat.f   #0,     #0
        dat.f   #0,     #0
        dat.f   #0,     #0
        end     start
