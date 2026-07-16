;redcode-94
;name test lattice 20
;assert CORESIZE == 8000
step equ 1031
start   spl b1
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
        spl b12
        spl b13
        spl b14
        spl b15
        spl b16
        spl b17
        spl b18
        spl b19
        jmp b0
b0      mov.i sb, 0
        add.ab #step, b0
        jmp b0
b1      mov.i db, 400
        add.ab #step, b1
        jmp b1
b2      mov.i sb, 800
        add.ab #step, b2
        jmp b2
b3      mov.i db, 1200
        add.ab #step, b3
        jmp b3
b4      mov.i sb, 1600
        add.ab #step, b4
        jmp b4
b5      mov.i db, 2000
        add.ab #step, b5
        jmp b5
b6      mov.i sb, 2400
        add.ab #step, b6
        jmp b6
b7      mov.i db, 2800
        add.ab #step, b7
        jmp b7
b8      mov.i sb, 3200
        add.ab #step, b8
        jmp b8
b9      mov.i db, 3600
        add.ab #step, b9
        jmp b9
b10      mov.i sb, 4000
        add.ab #step, b10
        jmp b10
b11      mov.i db, 4400
        add.ab #step, b11
        jmp b11
b12      mov.i sb, 4800
        add.ab #step, b12
        jmp b12
b13      mov.i db, 5200
        add.ab #step, b13
        jmp b13
b14      mov.i sb, 5600
        add.ab #step, b14
        jmp b14
b15      mov.i db, 6000
        add.ab #step, b15
        jmp b15
b16      mov.i sb, 6400
        add.ab #step, b16
        jmp b16
b17      mov.i db, 6800
        add.ab #step, b17
        jmp b17
b18      mov.i sb, 7200
        add.ab #step, b18
        jmp b18
b19      mov.i db, 7600
        add.ab #step, b19
        jmp b19
sb spl #0,#0
db dat.f #0,#0
end start
