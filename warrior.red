;redcode-94nop
;name Soldier of Fortune
;author John Metcalf
;strategy .75c Agony-style scanner
;assert CORESIZE==8000

        st    equ 1074 ; 2438 ; 6254
        fi    equ st
        count equ 6
        wptr  equ ptrs-4

        org    scan+1

ptrs    mov.ba #fi+st,   #fi

scan    sub    inc,      ptrs
        sne.x  *ptrs,    @ptrs
        sub.x  inc,      ptrs
        jmz.f  scan,     @ptrs

        slt    ptrs,     #dbmb+9-ptrs
        mov    ptrs,     wptr
        add    #count,   c

wipe    mov    *1,       >wptr
        mov    inc,      >wptr
c       djn    wipe,     #0

        jmn    ptrs,     ptrs

inc     spl    #-2*st,   -st
clear   mov    dbmb,     >wipe+1
        djn.f  clear,    <wipe-4
dbmb    dat    <2667,    9

        end

