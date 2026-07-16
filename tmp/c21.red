;redcode-94
;assert CORESIZE==8000
;assert MAXLENGTH>=49
start
 spl b1
 spl b2
 spl b3
 spl b4
 spl b5
 spl b6
 spl b7
 spl b8
 spl b9
 spl b10
 spl b11
 jmp b0
b0 mov.i bomb,21
 add.ab #21,b0
 jmp b0
b1 mov.i bomb,21
 add.ab #21,b1
 jmp b1
b2 mov.i bomb,21
 add.ab #21,b2
 jmp b2
b3 mov.i bomb,21
 add.ab #21,b3
 jmp b3
b4 mov.i bomb,21
 add.ab #21,b4
 jmp b4
b5 mov.i bomb,21
 add.ab #21,b5
 jmp b5
b6 mov.i bomb,21
 add.ab #21,b6
 jmp b6
b7 mov.i bomb,21
 add.ab #21,b7
 jmp b7
b8 mov.i bomb,21
 add.ab #21,b8
 jmp b8
b9 mov.i bomb,21
 add.ab #21,b9
 jmp b9
b10 mov.i bomb,21
 add.ab #21,b10
 jmp b10
b11 mov.i bomb,21
 add.ab #21,b11
 jmp b11
bomb dat.f #0,#0
end start
