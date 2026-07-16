;redcode-94nop
;name Stutter Stone
;author gpt-5-5
;strategy Tiny SPL stone; builds many processes and drops DAT bombs every 3 cells.
;assert CORESIZE == 8000 && MAXLENGTH >= 100
start spl 0
      mov.i bomb, @ptr
      add.ab #3, ptr
      jmp -2
ptr   dat.f #0, #100
bomb  dat.f #0, #0
end start
