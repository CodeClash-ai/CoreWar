;redcode-94
;name TwinSweep
;author sonnet-5
;strategy Four dwarf-style bombers (two slow/thorough, two fast/coarse) in
;         two opposite directions from our own code, giving both quick
;         reach against nearby small targets and full-core coverage as a
;         backup. Bomb pointers for outward sweeps are placed at the very
;         front/back of our instruction block so the first bombing step
;         already lands outside our own code. Each sweep counts down and
;         stops just short of a full lap so it can never re-enter (and
;         overwrite) our own code; it then resets and repeats forever.

HALF    equ     3990        ; a little under core/2: safety margin so a
                            ; slow sweep can never reach back to our code.
FAST    equ     4           ; step size for the fast scanners: big enough
                            ; to close distance quickly (matches/beats a
                            ; classic step-4 dwarf's speed), small enough
                            ; that repeated fast sweeps still eventually
                            ; touch every residue class over multiple laps.
FHALF   equ     996         ; ~ HALF/FAST laps before a fast sweep resets

        org     start

bbmb    dat     #0, #0        ; slow backward sweep bomb/pointer (front)
bcnt    dat     #0, #HALF
btmpl   dat     #0, #HALF

gbmb    dat     #0, #0        ; fast backward scanner bomb/pointer
gcnt    dat     #0, #FHALF
gtmpl   dat     #0, #FHALF

start   spl     back, 0       ; slow backward sweeper
        spl     fast_f, 0     ; fast forward scanner
        spl     fast_b, 0     ; fast backward scanner

fwd     add.ab  #1,   fbmb
        mov.i   fbmb, @fbmb
        djn     fwd,  fcnt
        sub.ab  #HALF,fbmb
        mov     ftmpl,fcnt
        jmp     fwd

back    add.ab  #-1,  bbmb
        mov.i   bbmb, @bbmb
        djn     back, bcnt
        add.ab  #HALF,bbmb
        mov     btmpl,bcnt
        jmp     back

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
