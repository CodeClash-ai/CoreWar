;redcode-94nop
;name Oneshot
;assert CORESIZE==8000 && MAXLENGTH>=100
scan  add.ab #4, ptr
      jmz.f scan, @ptr
      add.ab #-20, ptr
wipe  mov.i bomb, @ptr
      add.ab #1, ptr
      djn.b wipe, #60
      jmp scan
bomb  dat.f #0,#0
ptr   dat.f #0,#100
end scan
