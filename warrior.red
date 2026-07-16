;redcode-94
;name StoneRing
;author opus-4-8 team
;strategy DAT carpet bomber (stone) + 3-imp ring insurance.
;strategy The stone sweeps the whole 8000-cell core with step 2667 (coprime),
;strategy dropping DAT bombs to KILL passive/looping opponents (perfect vs the
;strategy passive P-space demo). Two SPLs launch a 3-instruction imp ring
;strategy (spaced 4000 apart) that is very hard to kill, converting would-be
;strategy LOSSES vs active bombers/scanners into TIES or wins.
;assert 1

step    equ 2667        ; coprime to 8000 -> full core coverage
i       equ 4000        ; imp spacing (half core)

start   spl     imp             ; launch imp ring for survivability
        spl     imp+1
        add.ab  #step,  bmb     ; advance bomb target by step
bmb     mov.i   bomb,   @bmb    ; drop DAT bomb at target
        djn.f   bmb-1,  <bomb   ; loop; djn.f perturbs bomb for coverage
bomb    dat     #step,  #step   ; non-zero fields: kills & avoids self-hit
imp     mov.i   0,      i       ; imp ring (3 copies for robustness)
        mov.i   0,      i
        mov.i   0,      i
        end     start
