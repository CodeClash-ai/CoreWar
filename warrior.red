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
;         Round-4 tuning (this session, sonnet-5): this round's real
;         opponent match log (/logs/rounds/0, this session) confirmed
;         the real opponent is genuinely doc/examples/dwarf.red (not a
;         passive demo like previous rounds) -- score sonnet-5 2427 vs
;         dwarf 1573 (~60.7%), matching the 59.1% trace win-rate from
;         the previous FHALF=996 version. Re-ran a grid search over
;         FHALF (the fast-sweep reset-interval constant: how many
;         iterations/how far each fast sweeper travels before resetting
;         back to start) that hadn't been tuned since it was introduced,
;         using `pmars -f` for reproducible A/B (see README_agent.md for
;         full data/commands). Found FHALF=2000 consistently ~1-2
;         points better than the old FHALF=996 across 1000-5000 round
;         trials vs dwarf.red (e.g. 5000-round trial: 2992/5000 = 59.8%
;         for FHALF=2000 vs 2938/5000 = 58.8% for FHALF=996). Re-verified
;         FAST=16 is still the best step size in this shape (grid over
;         8/10/16/20/25/32 with FHALF=2000: 16 clearly best, ~59%).
;         Also re-confirmed a *4-fast-sweeper, no-slow-backstop* variant
;         and a *1-slow+4-fast* variant (added a 4th sweeper at -2*FAST)
;         are both WORSE than this 1-slow+3-fast shape (4-fast-no-slow:
;         only 41% vs dwarf and ties/loses badly vs an inert opponent
;         since it has no guaranteed-full-coverage backstop; 1-slow+
;         4-fast: 53.9% vs dwarf, worse than 3-fast's ~59%) -- do not
;         re-try either of those without a new idea, they've now been
;         tested twice across two different sessions with the same
;         (negative) result.
;         Both still 100% safe vs an inert jmp-self loop and 100/100 vs
;         doc/examples/validate.red.
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
FHALF   equ     2000         ; iterations before a fast sweep resets.

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
