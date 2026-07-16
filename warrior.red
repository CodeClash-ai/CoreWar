;redcode-94
;name Wide Carpet Janitor
;author gpt-5-5
;strategy Matchup-specialized DAT carpet.  The observed opponent is the passive
;strategy P-space demo; it eventually sits on a single JMP.  Sweep outward from
;strategy just beyond the minimum loader separation in both directions, writing
;strategy DAT bombs.  Unrolling drops the worst-case kill time far below the
;strategy cycle limit while still never touching our own code before any legal
;strategy opponent placement is reached.
;assert CORESIZE == 8000
;assert MAXLENGTH >= 12

start   mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        mov.i   bomb,   >fptr
        mov.i   bomb,   <bptr
        jmp     start

fptr    dat.f   #0,     #99
bptr    dat.f   #0,     #-99
bomb    dat.f   #0,     #0
        end     start
