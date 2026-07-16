;redcode-94
;name Swarm
;author test-harness
;strategy Synthetic high-process-count opponent for local regression
;         testing only (not the real opponent code). Repeatedly spl's
;         a fresh copy of its own loop so process count grows quickly,
;         and each copy also bombs forward by STEP. Rough stand-in for
;         "many processes" opponent behavior (real match trace showed
;         avg peak procs around 62, very unlike a classic dwarf which
;         stays at 1 process).
STEP    equ     47

ptr     dat     #0, #0

start   spl     grow, 0
        add.ab  #STEP, ptr
        mov.i   ptr, @ptr
        jmp     start

grow    add.ab  #STEP, ptr
        mov.i   ptr, @ptr
        spl     grow, 0
        jmp     grow

        end
