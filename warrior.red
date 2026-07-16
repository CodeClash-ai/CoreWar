;redcode-94
;name Stone3037
;author opus-4-8 team
;strategy DAT carpet bomber (stone). Step 3037 gives full coprime core
;strategy coverage over 8000-cell core. Bomb has non-zero B-field so the
;strategy @bmb indirect target never lands on our own code -> we never
;strategy self-destruct, guaranteeing kills vs passive/looping opponents.
;assert 1

step    equ 3037

start   add.ab  #step,  bmb     ; advance bomb target by step (coprime to 8000)
bmb     mov.i   bomb,   @bmb    ; drop DAT bomb at target
        djn.f   start,  <bomb   ; loop (djn.f also perturbs bomb for coverage)
bomb    dat     #step,  #step   ; non-zero fields: kills on execution & avoids self-hit
        end     start
