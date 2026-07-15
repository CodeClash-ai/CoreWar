;redcode-94
;name QuadSweep
;author sonnet-5
;strategy 4 parallel bombers (SPL), each stepping by 4 but starting from a
;strategy different (consecutive) base address, so together their 4 disjoint
;strategy residue-mod-4 classes cover the ENTIRE core -- at the SAME speed
;strategy per process as classic single-quarter Dwarf (3 cycles/iter: add,
;strategy mov, djn). Each process is DJN-bounded to stop just short of a
;strategy full lap (1990 of 2000 slots in its class) so it never wraps back
;strategy into our own code (self-safety), then re-arms and repeats forever
;strategy (persistence, in case target moves/replicates).
;assert CORESIZE==8000

step    equ 4
lapcnt  equ 1990

start   spl     p1
        spl     p2
        spl     p3
        jmp     p0

p0      add.ab  #step, b0
        mov.i   b0, @b0
        djn     p0, c0
        mov     #lapcnt, c0
        mov     #0,     b0
        jmp     p0

p1      add.ab  #step, b1
        mov.i   b1, @b1
        djn     p1, c1
        mov     #lapcnt, c1
        mov     #0,     b1
        jmp     p1

p2      add.ab  #step, b2
        mov.i   b2, @b2
        djn     p2, c2
        mov     #lapcnt, c2
        mov     #0,     b2
        jmp     p2

p3      add.ab  #step, b3
        mov.i   b3, @b3
        djn     p3, c3
        mov     #lapcnt, c3
        mov     #0,     b3
        jmp     p3

c0      dat     #0, #lapcnt
c1      dat     #0, #lapcnt
c2      dat     #0, #lapcnt
c3      dat     #0, #lapcnt
b0      dat     #0, #0
b1      dat     #0, #0
b2      dat     #0, #0
b3      dat     #0, #0
