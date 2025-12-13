;redcode-94
;name Bulldozed
;author Christian Schmidt
;strategy p-warrior
;assert 1

 org think

; ***** ONESHOT *****

step    equ     382
sep     equ     10
stream  equ     7874
scan1   equ     7003
imp     equ     2667
cstart  equ     (last+2-ptr)
oBoot   equ     4223;(50-7950)

ptr     dat.f   bomb1,#0
bomb3   dat.f   <imp,<(2*imp)
inc     dat.f   step,step
bomb2   spl.a   #(bomb3-ptr),cstart
loop    add.f   inc,oscan
        sne.i   *oscan,   @oscan
        add.f   inc,oscan
oscan   sne.i   scan1,scan1+sep
        djn.f   loop, *oscan
        mov.ab  oscan,ptr
bomb1   spl.a   #(bomb2-ptr),cstart
clear   mov.i   *ptr,>ptr
        mov.i   *ptr,>ptr
last    djn.f   clear,<stream

bPtr    dat     last+1, last+oBoot+1
pGo     spl     1
    for 7
        mov.i   {bPtr,       <bPtr
    rof
        djn     loop+oBoot,   #1
dat 0, 0

; **** P-SPACE BRAIN ****

STORE equ 256 ; state storage location

w0 equ dwarf
w1 equ pGo
w2 equ scissor
w3 equ paper

think ldp.a #0, in
 ldp.a #STORE, table
 mod.ba *in, table
 stp.b *table, #STORE
    ;          LL         WW         TT
table jmp }0, 226 ; =(22*10)+ 6=(25* 9)+ 1=(20*11)+ 6
;initial state
 dat w0, 650 ; =(65*10)+ 0=(72* 9)+ 2=(59*11)+ 1
 dat w0, 101 ; =(10*10)+ 1=(11* 9)+ 2=( 9*11)+ 2
 dat w1, 886 ; =(88*10)+ 6=(98* 9)+ 4=(80*11)+ 6
 dat w1, 653 ; =(65*10)+ 3=(72* 9)+ 5=(59*11)+ 4
 dat w1, 104 ; =(10*10)+ 4=(11* 9)+ 5=( 9*11)+ 5
 dat w2, 889 ; =(88*10)+ 9=(98* 9)+ 7=(80*11)+ 9
 dat w2, 656 ; =(65*10)+ 6=(72* 9)+ 8=(59*11)+ 7
 dat w2, 107 ; =(10*10)+ 7=(11* 9)+ 8=( 9*11)+ 8
 dat w3, 630 ; =(63*10)+ 0=(70* 9)+ 0=(57*11)+ 3

 dat w0, 226 ; =(22*10)+ 0=(25* 9)+ 1=(20*11)+ 6
;unreachable

in dat 0, 10 ; must have non-zero b-field in the
previous cell
paper spl 1, 9
      spl 1, 11
      spl 1, >-400

; ***** PAPER *****
pBov    equ     956
pAwa    equ     zero+790
zero    equ     think

        mov.i   <pBo1,          {pBo1
pBo1    spl     zero+pBov,      pEnd
        mov.i   }pBo1,          >pBo2
pBo2    jmp.f   zero+pBov+235,  zero+pBov+235

        spl.b   @0,             >286
        mov.i   }-1,            >-1
        spl.b   @0,             <1040
        mov.i   }-1,            >-1
        spl.b   @0,             }1879
        mov.i   }-1,            >-1
        mov.i   #-3581,         {1
        mov.i   >705,           }-10
pEnd    dat     0,              0

; **** SCISSOR ****

STEP equ 5379
SDIST equ zero+6421;1703;
sgate equ (scan-2)

scissor mov *sclr, @sptr
 mov {sclr, <sptr
 mov {sclr, <sptr
 mov {sclr, <sptr
 mov {sclr, <sptr
 mov {sclr, <sptr
 mov {sclr, <sptr
 mov {sclr, <sptr
 mov {sclr, <sptr
sptr mov.ab #5000, @SDIST
 mov {sclr, <sptr
sjmp djn.f @sptr,  sptr

 dat 0, 0
 dat 0, 0

scan add #STEP, #STEP
mv mov sclr, >scan-1
pscan jmz.f scan, @scan
 slt scan, #sclr+1-scan
chg mov.i @pscan, @mv
chk jmn scan, scan
 mov.f dclr, >chk
 djn.f <chg, {chg
dclr dat 381, sclr+1-sgate
sclr spl #0, {0

; ***** DWARF *****

dstep equ 81
dhop equ 5277
dtime equ 1677
dbmb equ (dend+4)

dwarf mov   dend, @dptr
 mov {dwarf, <dptr
 mov {dwarf, <dptr
dptr mov   datb, *5421
 mov {dwarf, <dptr
 mov {dwarf, <dptr
djmp djn.f @ dptr,  dptr

 dat 0, 0

 spl #0, <dhop+2 ; combines with datb to form a gate
dloop mov dbmb, {(dstep*dtime)+1
 mov dbmb, @dloop ; hit by datb to start clear
 sub #dstep, dloop
dend djn.f dloop, <dhop-2
; DAT 0, 0
; DAT 0, 0
; DAT 0, 0
datb dat <dhop+1,>1

end

