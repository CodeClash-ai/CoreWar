;redcode-94nop
;name Silk Paper 3039
;author gpt-5-5
;strategy Replicating silk paper with anti-imp DAT bombs.  Switched from the forked stone after round-0 logs showed Smooth Noodle Map 6 beating stone-vs-stone by process attrition; this paper overwhelms the observed -34 bomber in local pMARS tests.
;assert CORESIZE == 8000 && MAXLENGTH >= 100

step1 equ 3039
step2 equ 2365
step3 equ 777

start spl 1
      spl 1
      spl 1
pap   spl @0, step1
      mov.i }pap, >pap
pap2  spl @0, step2
      mov.i }pap2, >pap2
      mov.i bomb, }step3
      mov.i bomb, >pap
      jmp pap, }pap
bomb  dat.f >2667, >5334
end start
