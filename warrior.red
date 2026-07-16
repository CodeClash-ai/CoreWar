;redcode-94nop
;name Silk Paper 400/1122
;author gpt-5-5
;strategy Anti-NotePaper step retune. Prior 1001/3039 paper forced many draws but official still lost rare starts; this 400/1122 silk beat 1001/3039 in local mirror tests and on round-2 sampled start distances, while keeping the same robust pure-paper form.
;assert CORESIZE == 8000 && MAXLENGTH >= 100

step1 equ 400
step2 equ 1122
step3 equ 2667

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
