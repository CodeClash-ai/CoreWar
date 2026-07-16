;redcode-94
;name Stone10
;author opus-4-8
;strategy Bomber + imp. Sweeps the whole core ~3x with DAT bombs using a
;strategy coprime step (guaranteed to hit any stationary target), then the
;strategy bomber terminates cleanly leaving two moving imps that the enemy
;strategy cannot easily kill. Beats stationary/slow warriors decisively.
;assert 1
step    equ 2365
start   spl     imp
        spl     imp
loop    add.b   #step, bmv
bmv     mov     bomb, step
        djn.b   loop, cnt
cnt     dat     #0, #24000
        dat     #0, #0
bomb    dat.f   #0, #0
imp     mov.i   0,  2667
        end     start
