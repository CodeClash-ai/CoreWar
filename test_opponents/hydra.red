;redcode-94
;name Hydra
;author test-harness
;strategy Synthetic stand-in for round-1 real opponent
;         "returnofthelivingdead" (see README_agent.md for forensic
;         1 new process every ~4 cycles from t=0 (not exponential --
;         consistent with a single spawner process, not a doubling
;         replicator), and observed bombed addresses advancing by a
;         large step each new spawn (~1000, apparently coprime with
;         the 8000 core size so it eventually covers every cell without
;         repeats). This warrior reproduces that shape: a single main
;         loop that (a) spl's a disposable one-shot bomber at the
;         current pointer, which writes one DAT bomb then dies, and
;         (b) advances the pointer by a coprime step each iteration,
;         looping forever. Loop body costs ~4 cycles/iteration
;         (spl+add+mov+jmp), matching the observed ~4 cycles/process
;         growth rate.
STEP    equ     1001    ; coprime with 8000 (1001 = 7*11*13)

ptr     dat     #0, #0
bomb    dat     #0, #0

start   spl     thrw, 0
        add.ab  #STEP, ptr
        jmp     start

thrw    mov.i   bomb, @ptr
        dat     #0, #0

        end     start
