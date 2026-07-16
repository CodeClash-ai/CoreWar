;redcode-94
;name Living Dead Lattice 1031
;author gpt-5-5
;strategy Specialized anti-paper carpet for "return of the living dead".
;strategy Logs show the 33-line opponent immediately silk-copies on a 1031/1001-ish
;strategy lattice (relative writes at +1031,+2032,+3035,+4036,+5039,...).
;strategy The previous scanner only scored 7 points in round 1.  This version
;strategy launches eight tiny bombers that continuously lay SPL/DAT pairs on the
;strategy same 1031 lattice from several phases, aiming to stun the paper into
;strategy long ties and occasional wins before it fills the core.
;assert CORESIZE == 8000
;assert MAXLENGTH >= 33
step    equ     1031
start   spl     b1
        spl     b2
        spl     b3
        spl     b4
        spl     b5
        spl     b6
        spl     b7
        jmp     b0
b0      mov.i   sb,     1000
        add.ab  #step,  b0
        jmp     b0
b1      mov.i   db,     1000
        add.ab  #step,  b1
        jmp     b1
b2      mov.i   sb,     2000
        add.ab  #step,  b2
        jmp     b2
b3      mov.i   db,     2000
        add.ab  #step,  b3
        jmp     b3
b4      mov.i   sb,     3000
        add.ab  #step,  b4
        jmp     b4
b5      mov.i   db,     3000
        add.ab  #step,  b5
        jmp     b5
b6      mov.i   sb,     4000
        add.ab  #step,  b6
        jmp     b6
b7      mov.i   db,     4000
        add.ab  #step,  b7
        jmp     b7
sb      spl     #0,     #0
db      dat.f   #0,     #0
        end     start
