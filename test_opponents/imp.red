;redcode-94
;name Imp
;author classic (A.K. Dewdney)
;strategy Single-instruction copier that endlessly copies itself one
;         cell forward -- classic "imp ring" style opponent. Doesn't
;         actively bomb, but is very hard to permanently kill (each
;         copy that survives keeps moving) -- good regression test for
;         "can we actually finish off a target that keeps re-appearing"
;         rather than just "can we out-race a static bomber like dwarf".
start   mov.i  0, 1
        end    start
