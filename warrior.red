;redcode-94
;name Silkweaver
;author opus-4-8 team
;strategy Fast silk-style self-replicating paper.
;strategy Spreads copies across core faster than most bombers can kill,
;strategy never loses to imps, beats passive and scanner warriors.
;assert 1
        ORG silk
silk    SPL     0,      }-1
        MOV.I   -1,     0
        SPL     3600,   <-2000
        MOV.I   }-1,    >silk+1
        DJN.F   -1,     {silk-2000
        END
