;redcode
;name Medusa's v7X
;author W. Mintardjo
;strategy Medusa's is based on Agony 2.4b which was a cmp-scanner with
;strategy SPL carpet bombing
;strategy Version history
;strategy Agony 2.4b: The origin of this program
;strategy v1	    : Agony 2.4b with Anti-IMP
;strategy v1.1	    : Better Anti-IMP. Faster core-clear
;strategy v2        : Bombing structure redesigned
;strategy           - Shorter line, shorter bombing, more accuracy
;strategy v2+	    : Constants modified
;strategy v3	    : Increase endurance with B-protection for the constants
;strategy v4	    : DJN triggers core-clear. Longer scanning
;strategy           : Another SPL. Can't miss opponent
;strategy v5	    : Return to v3. v4 has more ties due to its long scanning
;strategy           : Bomb with SPLs/JMP -1. Can't miss and trap opponent
;strategy           : Increase endurance with B-protection for the code
;strategy v6        : Change constants. More B-protection
;strategy v7        : Fix a little bug from v6
;strategy Submitted : Mon Mar 15 19:19:18 PST 1993

CDIST   equ 12
IVAL    equ 28
FIRST   equ scan-OFFSET+IVAL
OFFSET  equ 5324
n       equ 1

redo    mov #CDIST+n,count
scan    sub data,@split
comp    cmp FIRST-CDIST,FIRST
        slt #data-comp+1+CDIST+1+n,@split
        djn scan,<FIRST+163
        mov jump,@comp
split   mov bomb,<comp
count   djn split,#CDIST+n
        add #CDIST+n,@split
        jmz redo,redo-2
bomb    spl 0, <0-IVAL+1
incr    mov data, <count
jump    jmp incr, <0-IVAL-1
data    DAT <0-IVAL, <0-IVAL

        end comp
