;redcode-94nop
;name Bloodlust
;author John Metcalf
;strategy vampire
;assert CORESIZE==800 || CORESIZE == 8000

        for CORESIZE == 8000
        step   equ 4395
        rof

        for CORESIZE == 800
        step   equ 465
        rof

        half   equ (CORESIZE/2)
        trap   equ (mid+half+step)
        fang   equ (mid+half-step)
        gate   equ (bptr-3)

        org    start

bptr    dat    19,         1
        spl    #21,        0

        dat    0,0

vamp    add    inc,        fang
        mov    fang,       @fang
        jmz.f  vamp,       *fang
        mov    fang,       *fang
mid     jmz.f  vamp,       trap

inc     spl    #-step,     <step
clear   mov    @bptr+1,    }gate
        mov    @bptr,      }gate
        djn.f  clear,      }inc

        for    MAXLENGTH-18
        dat    0,0
        rof

pit     spl    #0,         {0
vbomb   jmp    >half,      >half+step*2

start   mov    pit,        trap
        mov    pit,        trap+1
        mov    vbomb,      fang
        djn.f  vamp+1,     {-2384

        end

