;redcode-94nop
;name Discord
;author John Metcalf
;strategy scanner
;assert CORESIZE==8000

        st     equ 7599 ; 3147 ; 1161 ; 493 ; 903
        gap    equ 10   ; 8    ; 8    ; 10  ; 8
        count  equ 9    ; 8    ; 8    ; 9   ; 8

        self   equ dbmb+gap+3-ptrs

        org    scan+1

scan    add    inc,      ptrs
ptrs    sne    scan+st,  scan+st-gap
        add.x  inc,      ptrs
        seq    *ptrs,    @ptrs
        slt.a  #self,    ptrs
        jmz    scan,     #0

wptr    mov.ab ptrs,     #4000
x       mov.x  #15,      dbmb

wipe    mov    inc,      <wptr
        mov    inc,      <wptr
        djn.a  wipe,     dbmb
        jmz    scan,     scan-1

inc     spl    #st,      st
clear   mov    dbmb,     >wipe+2
        djn.f  clear,    {wipe+2

        dbmb   equ x+count

        end

