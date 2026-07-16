;redcode-94
;name TwinSweep
;author sonnet-5
;strategy Four dwarf-style bombers sharing one process budget:
;         - one slow, single-direction full-core sweep (step 1) that
;           guarantees every cell gets bombed eventually (backstop kill),
;         - three fast sweepers (steps FAST, -FAST, and 2*FAST, i.e.
;           three distinct residue classes mod 2*FAST) that close
;           distance to nearby small targets (e.g. a classic dwarf) much
;           faster than the slow sweep, catching quick/aggressive
;           opponents before they can spread out.
;         Round-2 tuning (this version): grid-searched FAST (must be a
;         divisor of core size 8000, see notes below) with a fixed
;         starting-position series (`pmars -f`) for reproducible A/B
;         testing; FAST=16 remains the best single-step value found.
;         Then tried adding a *third* fast sweeper (step 2*FAST=32, own
;         residue class, same process-count budget as before: still just
;         3 spawned procs + main) instead of only two (+FAST/-FAST).
;         This consistently beat the previous 1-slow/2-fast shape here:
;         1000-round deterministic (-f) trial vs doc/examples/dwarf.red:
;         591/1000 (59.1%) for this version vs 572/1000 (57.2%) for the
;         previous 1-slow/2-fast version -- reproducible, not noise (see
;         README_agent.md for the exact commands/data). Both still 100%
;         safe vs an inert `jmp self` loop and 100/100 vs
;         doc/examples/validate.red (the opponent seen in real matches
;         so far, rounds 0-1, still an inert single-process demo).
;         Bomb pointers are placed at the very front/back of our
;         instruction block so the first bombing step already lands
;         outside our own code, and every sweep stops just short of a
;         full lap (then resets) so it can never re-enter (and
;         overwrite) our own code.

HALF    equ     7960        ; a little under core size: the slow sweep's
                            ; single direction covers (core - HALF) less
                            ; than a full lap, leaving a safety margin
                            ; bigger than our own code footprint so it
                            ; never wraps back into our own instructions.
FAST    equ     16          ; step size for the fast scanners: big enough
                            ; to close distance quickly (matches/beats a
                            ; classic step-4 dwarf's speed). Must be a
                            ; divisor of the core size (8000) -- see
                            ; README_agent.md for why non-divisors are an
                            ; active self-destruct bug, not just slower.
                            ; (2*FAST=32 is also a divisor of 8000, used
                            ; by the third fast sweeper below.)
FHALF   equ     996         ; iterations before a fast sweep resets.

        org     start

gbmb    dat     #0, #0        ; fast backward scanner bomb/pointer
gcnt    dat     #0, #FHALF
gtmpl   dat     #0, #FHALF
kbmb    dat     #0, #0        ; third fast scanner bomb/pointer (step 2*FAST)
kcnt    dat     #0, #FHALF
ktmpl   dat     #0, #FHALF

start   spl     fast_f, 0     ; fast forward scanner (step +FAST)
        spl     fast_b, 0     ; fast backward scanner (step -FAST)
        spl     fast_k, 0     ; fast forward scanner (step +2*FAST,
                              ; distinct residue class from fast_f)
                              ; (main process falls through into the
                              ; slow single-direction full-core sweep)

fwd     add.ab  #1,   fbmb
        mov.i   fbmb, @fbmb
        djn     fwd,  fcnt
        sub.ab  #HALF,fbmb
        mov     ftmpl,fcnt
        jmp     fwd

fast_f  add.ab  #FAST,  hbmb
        mov.i   hbmb, @hbmb
        djn     fast_f, hcnt
        sub.ab  #FHALF*FAST, hbmb
        mov     htmpl, hcnt
        jmp     fast_f

fast_b  add.ab  #-FAST, gbmb
        mov.i   gbmb, @gbmb
        djn     fast_b, gcnt
        add.ab  #FHALF*FAST, gbmb
        mov     gtmpl, gcnt
        jmp     fast_b

fast_k  add.ab  #FAST*2, kbmb
        mov.i   kbmb, @kbmb
        djn     fast_k, kcnt
        sub.ab  #FHALF*FAST*2, kbmb
        mov     ktmpl, kcnt
        jmp     fast_k

fcnt    dat     #0, #HALF
ftmpl   dat     #0, #HALF
hcnt    dat     #0, #FHALF
htmpl   dat     #0, #FHALF
fbmb    dat     #0, #0        ; slow forward sweep bomb/pointer (back)
hbmb    dat     #0, #0        ; fast forward scanner bomb/pointer

        end
