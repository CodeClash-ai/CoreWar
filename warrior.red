;redcode-94nop
;name Bayonet
;author John Metcalf
;strategy micro scanner
;assert CORESIZE==8000

; entered the KOTH.org 94nop hill in 1st place on 9th April 2014

        org    scan+1

        step   equ 2749
        clrptr equ adjust-2

adjust  mul.x  {scan+1,        }scan+2
scanptr slt.ba #13,            #step+1
        mov.f  scanptr,        clrptr
clear   mov    *bomb,          >clrptr
scan    add    #step+1,        scanptr
        jmz.f  scan,           <scanptr
        jmn    adjust,         scanptr
        djn.f  clear,          }clear
bomb    spl    #0,             {0

        end

