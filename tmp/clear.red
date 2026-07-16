;redcode-94
;name test spldat clear
;assert CORESIZE == 8000
start spl 0, 0
      mov.i sb, >ptr
      mov.i db, >ptr
      djn.f -2, >ptr
ptr   dat.f #0, #100
sb    spl #0, #0
db    dat.f #0, #0
      end start
