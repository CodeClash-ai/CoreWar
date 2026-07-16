;redcode-94nop
;name c400
;assert CORESIZE==8000 && MAXLENGTH>=100
step1 equ 400
step2 equ 1122
step3 equ 2667
start spl 1
 spl 1
 spl 1
pap spl @0, step1
 mov.i }pap, >pap
pap2 spl @0, step2
 mov.i }pap2, >pap2
 mov.i bomb, }step3
 mov.i bomb, >pap
 jmp pap, }pap
bomb dat.f >2667, >5334
end start
