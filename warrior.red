;redcode-94
;name DualSweep
;author sonnet-5
;strategy One-time self-relocation added on top of the proven
;         TwinSweep design: before doing anything else, the main
;         process copies the ENTIRE warrior body (all LEN cells,
;         including this replicate block itself) to a second location
;         HOPLEN (~core/2) away, spl's a process there landing directly
;         at 'start' (skipping the replicate block on the copy, so this
;         only ever happens once -- no runaway exponential growth),
;         then jumps to 'start' itself too. From then on both origins
;         run an entirely independent, full 4-process TwinSweep
;         (1 slow full-core sweep + 3 fast residue-class sweeps) exactly
;         as before. Goal: survive a fast, wide enemy swarm finding and
;         wiping out ONE of our two origins (a diagnosed real failure
;         mode from /logs/rounds/0-1 -- see README_agent.md) by having
;         a second, physically distant, fully-independent copy of our
;         whole strategy still alive and fighting.

HOPLEN  equ     4000            ; ~core/2: max separation between the
                                ; two origins so a localized attack is
                                ; unlikely to reach both.
LEN     equ     (finish-replicate)  ; whole warrior length (cells)
HALF    equ     7960
FAST    equ     16
THIRD   equ     -4
FHALF   equ     3000

        org     replicate

replicate
        mov.ab  #(replicate-srcp2), srcp2
        mov.ab  #(replicate+HOPLEN-dstp2), dstp2
        mov.ab  #LEN, cnt2
rloop   mov.i   @srcp2, @dstp2
        add.ab  #1, srcp2
        add.ab  #1, dstp2
        djn     rloop, cnt2
        spl     @dstp3, 0
        jmp     start

dstp3   dat     #0, #(start+HOPLEN-dstp3)
srcp2   dat     #0, #0
dstp2   dat     #0, #0
cnt2    dat     #0, #0

gbmb    dat     #0, #0
gcnt    dat     #0, #FHALF
kbmb    dat     #0, #0
kcnt    dat     #0, #FHALF

start   spl     fast_f, 0
        spl     fast_b, 0
        spl     fast_k, 0

fwd     add.ab  #1,   fbmb
        mov.i   fbmb, @fbmb
        djn     fwd,  fcnt
        sub.ab  #HALF,fbmb
        mov.ab  #HALF, fcnt
        jmp     fwd

fast_f  add.ab  #FAST,  hbmb
        mov.i   hbmb, @hbmb
        djn     fast_f, hcnt
        sub.ab  #FHALF*FAST, hbmb
        mov.ab  #FHALF, hcnt
        jmp     fast_f

fast_b  add.ab  #-FAST, gbmb
        mov.i   gbmb, @gbmb
        djn     fast_b, gcnt
        add.ab  #FHALF*FAST, gbmb
        mov.ab  #FHALF, gcnt
        jmp     fast_b

fast_k  add.ab  #THIRD, kbmb
        mov.i   kbmb, @kbmb
        djn     fast_k, kcnt
        sub.ab  #FHALF*THIRD, kbmb
        mov.ab  #FHALF, kcnt
        jmp     fast_k

fcnt    dat     #0, #HALF
hcnt    dat     #0, #FHALF
fbmb    dat     #0, #0
hbmb    dat     #0, #0

finish
        end     replicate
