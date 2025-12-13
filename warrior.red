;redcode
;name Gothik
;author John Metcalf
;strategy replicating scanner
;assert CORESIZE==8000

        length equ 34
        gap    equ 15
        step   equ 3351
        time   equ 1281
        hit    equ 3
        first  equ paper+hit-step*time

paper   mov    #length,  length
scan    add    #step+1,  sptr
        mov    bmb,      <sptr
sptr    jmz    scan,     <first+1
copy    mov    <paper,   <sptr
        mov    <paper,   <sptr
        jmn    copy,     @2
dest    spl    @sptr
        jmz    @paper,   paper
bmb     dat    <1144,    <1-gap

        end    scan+1

