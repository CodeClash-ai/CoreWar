;redcode
;name Agony 3.1
;author Stefan Strack
;strategy Small-interval CMP scanner that bombs with a SPL 0 carpet.
;strategy 2.0: smaller
;strategy 2.1: larger, but should tie less; changed scan constants
;strategy 2.2a: smaller
;strategy 2.3a: mutagenizes core
;strategy 2.4: smaller CMP interval, spends less time bombing
;strategy 2.4b: mutagenize constant optimized
;strategy 3.0: long scan with anti-imp constants (a la Charon v8.0+)
;strategy 3.1: zero bfield bombs again; more robust
;strategy Submitted: Tue Feb  2 00:56:45 CST 1993

CDIST   equ 12
IVAL    equ 42
FIRST   equ scan+OFFSET+IVAL
OFFSET  equ (2*IVAL)
DJNOFF  equ -431

scan    sub incr,comp
comp    cmp FIRST-CDIST,FIRST
        slt #incr-comp+CDIST+(bptr-comp)+1,comp
        djn scan,<FIRST+DJNOFF
        mov #CDIST+(bptr-comp)+1,count
        mov comp,bptr
bptr    dat #0
split   mov bomb,<bptr
count   djn split,#0
        jmn scan,scan
bomb    spl 0
        mov incr,<count
incr    dat <0-IVAL,<0-IVAL

        end comp
