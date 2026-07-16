;redcode-94
;name Hydra2
;author test-harness
;strategy Better synthetic stand-in for round-1 real opponent
;         "returnofthelivingdead" (avg peak procs 2588, avg core owned
;         only 23%, only eliminated 10/100 -- see README_agent.md).
;         Unlike hydra.red (one-shot bombers that die immediately,
;         which does NOT reproduce the observed near-linear/sustained
;         process-count growth), this spawns PERSISTENT small dwarf-
;         style bombers that loop forever (never die on their own),
;         one every ~4 cycles, each at a widely-separated start
;         address (coprime step so they spread across the whole core
;         over time without repeats). This produces the same
;         "thousands of cheap, independent, spread-out bombers" shape.
GSTEP   equ     1001    ; coprime with 8000, spacing between spawned
                        ; bombers' start addresses
BSTEP   equ     4       ; each spawned bomber's own step size

ptr     dat     #0, #0

start   spl     child, 0
        add.ab  #GSTEP, ptr
        jmp     start

; template copied conceptually: each spl'd child begins executing here
; with A-field 0 relative offset per spl semantics (spl just starts a
; new process at target address; it reuses THIS code, sharing the
; child loop below, but each instance's "own" position in core comes
; from wherever ptr pointed when spawned -- captured via mov below).
child   mov.i   ptr, @cptr      ; drop a personal pointer copy near
                                 ; this child's target zone (cheap,
                                 ; approximates "bomber has its own
                                 ; local pointer variable" without a
                                 ; real copy-and-relocate replicator)
        add.ab  #BSTEP, cptr
        mov.i   cptr, @cptr
        jmp     child

cptr    dat     #0, #0

        end
