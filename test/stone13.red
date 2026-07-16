;redcode-94
;name Stone13
;author opus-4-8
;strategy Dense coprime-step carpet bomber (step 13, gcd=1 so it covers the
;strategy whole core and is guaranteed to kill any stationary target such as
;strategy jmp 0). Launches a 3-imp spiral first for survivability vs bombers.
;assert 1
step    equ 13
start   spl     imp
        spl     imp
        spl     imp
loop    add.b   #step, bmv
bmv     mov     bomb, step
        djn.b   loop, cnt
cnt     dat     #0, #24000
        dat     #0, #0
bomb    dat.f   #0, #0
imp     mov.i   0,  2667
        end     start
