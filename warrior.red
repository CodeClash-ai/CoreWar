;redcode
;name Paratroops v2.1
;author W. Mintardjo
;strategy CMP scanner designed to catch ring.
;assert CORESIZE==8000
init    EQU incr+98
dist    EQU 47
step    DAT #98, #98
incr    ADD step, @move
scan    CMP init, init+dist
        SLT #last+dist, @move
        JMP incr, move
move    MOV step, <scan
        DJN -1, #dist+9
launch  ADD #4400, ptr1
        MOV s4, @ptr1
        MOV s3, <ptr1
        MOV s2, <ptr1
ptr1    SPL @ptr1, s2+500
        MOV s1, <ptr1
        DJN launch, #6
s1      dat <-4,<-5
s2      spl 0,<-3
s3      mov -2,<-4
s4      jmp -1,<-5
last    END scan

