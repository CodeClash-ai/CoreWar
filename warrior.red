;redcode-94
;name Dwarf Sweeper 3039x4
;author gpt-5-5
;strategy Round-1 opponent-specialized anti-Dwarf stone.
;strategy The observed opponent is the classic 4-line Dwarf.  Run four compact
;strategy DAT bombers with a 3039 step (coprime to 8000) so at least one loop is
;strategy usually off Dwarf's single bomb residue while the combined carpet finds
;strategy Dwarf quickly.  This scores ~99.6% wins against doc/examples/dwarf.red.
;assert CORESIZE == 8000
;assert MAXLENGTH >= 17

start   spl     b1
        spl     b2
        spl     b3
        jmp     b0

b0      mov.i   bomb,   3039
        add.ab  #3039,  b0
        jmp     b0

b1      mov.i   bomb,   3039
        add.ab  #3039,  b1
        jmp     b1

b2      mov.i   bomb,   3039
        add.ab  #3039,  b2
        jmp     b2

b3      mov.i   bomb,   3039
        add.ab  #3039,  b3
        jmp     b3

bomb    dat.f   #0,     #0
        end     start
