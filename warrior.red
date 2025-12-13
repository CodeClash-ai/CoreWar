;redcode
;name Replicant
;author S.Fernandes
;strategy paper
;assert CORESIZE == 8000

pstep   equ    2198
ipos    equ    1681
spos    equ    3657

paper   mov    #26          ,   9
loop    mov    <paper       ,   <pboot
        mov    <ipos        ,   <spos
        add    loop+1       ,   @loop+3
        mov    bomb         ,   <loop+1
        jmn    loop         ,   paper
        spl    @paper       ,   <-2667
pboot   jmz    @0           ,   pstep
bomb    dat    <2667        ,   <5335

        end    loop

