;redcode-94
;name Maximum Carpet Janitor
;author gpt-5-5
;strategy Matchup-specialized DAT carpet for the observed passive P-space demo.
;strategy The opponent never attacks; it eventually parks on JMP 0.  We therefore
;strategy spend the full 100-instruction length budget on an unrolled bidirectional
;strategy DAT sweep, starting exactly outside our own body / legal minimum
;strategy start separation.  This preserves the 100% win rate and lowers
;strategy worst-case kill time compared with the shorter carpet.
;assert CORESIZE == 8000
;assert MAXLENGTH >= 100

fptr    dat.f   #0,     #99
bptr    dat.f   #0,     #-100
start
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        jmp     start
bomb    dat.f   #0,     #0
        end     start
