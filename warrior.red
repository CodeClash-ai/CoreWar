;redcode-94nop
;name Nosferatu
;author John Metcalf
;strategy v2 .33c vampire / .33c bomber -> spl/dat clear
;assert CORESIZE == 8000 || CORESIZE == 55440

        for    CORESIZE == 8000
        step   equ 5936 ; 2832 ; 1904
        time   equ 492  ; 492  ; 492
        dec    equ 1710 ; 3438 ; 2500
        rof

        for    CORESIZE == 55440
        step   equ 28144 ; 24208
        time   equ 3463  ; 3463
        dec    equ 23456 ; 25000
        rof

        gate   equ clear-4
        first  equ step*time

        org    vamp+1

bptr    dat    #1,     #11
dptr    spl    #dec,   13
clear   mov    *bptr,  >gate
        mov    *bptr,  >gate
        djn.f  clear,  }dptr

        for    3
        dat    0,0
        rof

vamp    add    inc,    fang
        mov    tnt,    *fang
        jmz.f  vamp,   @fang
        mov    fang,   @fang
        jmz.f  vamp,   trap
        jmp    clear-1,<gate

        for    15
        dat    0,0
        rof

inc     dat    -step,  step
tnt     mov    step,   1
fang    jmp    @trap+first,-first

        for    39
        dat    0,0
        rof

trap    spl    #0,     {0
        spl    {0,     }0
        jmn.a  trap+1, trap

        end

