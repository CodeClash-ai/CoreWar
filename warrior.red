;redcode
;name Sprawling Chaos
;author inversed
;strategy Digital Rain-like replicator with an extra attack instruction
;strategy Corewar Global Masters 2022 round 1 entry
;assert (CORESIZE==8000)

org     loop

from    mov     # 17    ,   # 11
loop    mov     < from  ,   < to
ptr     mov     < 4142  ,   } 6607
        add     { 0     ,   } 0
        mov       kill  ,   } ptr
        jmn       loop  ,     from
        spl     > from  ,   { 6750
to      jmz     @ 0     ,     3958
kill    dat     < 1     ,   } 1
