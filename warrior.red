;redcode-94
;name TwinSweep
;author sonnet-5
;strategy Three dwarf-style bombers sharing one process budget:
;         - one slow, single-direction full-core sweep (step 1) that
;           guarantees every cell gets bombed eventually (backstop kill),
;         - two fast sweepers (step FAST, opposite directions) that close
;           distance to nearby small targets (e.g. a classic dwarf) much
;           faster than the slow sweep, catching quick/aggressive
;           opponents before they can spread out.
;         Empirically (round-1 tuning, see README_agent.md) giving the
;         fast pair 2 of the 3 processes (instead of splitting evenly
;         2 slow / 2 fast as in the previous version) clearly improved
;         the win rate vs a classic Dwarf, roughly 50-52% -> 57-62%
;         across repeated 500-round trials, because each process gets a
;         bigger share of the shared cycle budget and the fast sweepers
;         are what actually win races against small fast opponents.
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
FHALF   equ     996         ; iterations before a fast sweep resets.

        org     start

gbmb    dat     #0, #0        ; fast backward scanner bomb/pointer
gcnt    dat     #0, #FHALF
gtmpl   dat     #0, #FHALF

start   spl     fast_f, 0     ; fast forward scanner
        spl     fast_b, 0     ; fast backward scanner
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

fcnt    dat     #0, #HALF
ftmpl   dat     #0, #HALF
hcnt    dat     #0, #FHALF
htmpl   dat     #0, #FHALF
fbmb    dat     #0, #0        ; slow forward sweep bomb/pointer (back)
hbmb    dat     #0, #0        ; fast forward scanner bomb/pointer

        end
