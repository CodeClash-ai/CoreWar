;redcode-94nop
;name White Mist
;author John Metcalf
;strategy vampire/imp
;assert CORESIZE==8000

        org    start

        step   equ 3345

inc     spl    #step,     <-step
vampire mov    fang,      @fang
        sub    inc,       fang
        djn.f  vampire,   *fang

        for    5
        dat    0,0
        rof

trap    mov    bomb+1,    <vampire-4
        spl    trap
        jmp    trap+1
bomb    dat    <5334,     <2667

        for    3
        dat    0,0
        rof

fang    jmp    trap-vampire-step,<vampire+step

        for    65
        dat    0,0
        rof

        istep  equ 2667
        iboot  equ imp+1000

start   spl    vampire-1,     <1450
        mov    imp,           iboot
        spl    8,             <1550
        spl    4,             <1650
        spl    2,             <1750
        jmp    iboot,         <1850
        jmp    iboot+istep,   <1950
        spl    2,             <2050
        jmp    iboot+istep*2, <2150
        jmp    iboot+istep*3, <2250
        spl    4,             <2350
        spl    2,             <2450
        jmp    iboot+istep*4, <2550
        jmp    iboot+istep*5, <2650
        spl    2,             <2750
        jmp    iboot+istep*6, <2850
        jmp    vampire-1,     <2950

imp     mov.i  #1,        istep

        end

