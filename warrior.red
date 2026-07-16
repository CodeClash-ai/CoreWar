;redcode-94
;name Return Trap 237
;author gpt-5-5
;strategy Emergency anti-paper/scissors for "return of the living dead".
;strategy Round-0 logs show a 33-line paper/silk with many processes/copies,
;strategy while our pure DAT stone lost 946-27.  This version scans for any
;strategy non-zero cell, lays an SPL/DAT trap around it, then keeps scanning.
;strategy It is intended to stun replicators into draws/wins rather than race them
;strategy with sparse DAT bombing.
;assert CORESIZE == 8000
;assert MAXLENGTH >= 12
step    equ     237
start   spl     1
        spl     1
scan    add.ab  #step,  test
test    jmz.f   scan,   100
        mov.i   sb,     >test
        mov.i   db,     >test
        mov.i   sb,     <test
        mov.i   db,     <test
        jmp     scan
sb      spl     #0,     #0
db      dat.f   #0,     #0
        end     start
