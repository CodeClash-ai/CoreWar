;redcode
;name Elemental Dust 2
;author John Metcalf
;strategy vampire/imp
;assert CORESIZE==8000

        step equ 644   ; 2508
        boot equ 3054  ; 3225
        dpos equ 4526  ; 1214
        idist equ 6619 ; 6114
        istep equ 2667

vdest   mov vampire+3, vampire+boot+3
        mov vampire+2, <vdest
        mov vampire+1, <vdest
        mov vampire,   <vdest
        mov fang,      fang+boot
        mov inc,       inc+boot
tdest   mov trap+3,    trap+boot+3
        mov trap+2,    <tdest
        mov trap+1,    <tdest
        mov trap,      <tdest
        spl vampire+boot,<4350

        mov imp,       imp+idist
        spl 8,         <4450
        spl 4,         <4550
        spl 2,         <4650
        jmp imp+idist, <4750
        jmp imp+idist+istep*1,<4850
        spl 2,         <4950
        jmp imp+idist+istep*2,<5050
        jmp imp+idist+istep*3,<5150
        spl 4,         <5250
        spl 2,         <5350
        jmp imp+idist+istep*4,<5450
        jmp imp+idist+istep*5,<5550
        jmp vampire+boot,<5650

imp     mov 0,         istep

vampire spl 0,         <2-fang
vloop   mov fang,      @fang
        add inc,       @vloop
        djn vloop,     <dpos

        for 12
        dat #trap,     #1
        rof

fang    jmp trap-vloop-step,<vloop-fang+step

        for 10
        dat #trap,     #1
        rof

trap    mov bomb,      <vampire-27
        spl trap
        jmp @trap+1
bomb    dat <2667,     <vampire+fang-trap

        for 9
        dat #trap,     #1
        rof

inc     dat <-step,    <step

        for MAXLENGTH-CURLINE
        dat #trap,     #1
        rof

        end
