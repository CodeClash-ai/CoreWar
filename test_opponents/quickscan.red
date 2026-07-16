;redcode-94
;name Blur
;author test
step    EQU 3044
        ORG scan
scan    ADD.F  incr, ptr
ptr     SNE.I  step, step+step
        JMP    scan
        MOV.AB #step, count
        SPL    kill
        JMP    scan
count   DAT    #12, #12
kill    MOV.I  bomb, @ptr
        ADD.AB #step, ptr
        DJN.B  kill, count
        JMP    scan
incr    DAT    #step, #step
bomb    DAT    #0, #0
        END
