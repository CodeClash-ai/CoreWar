;redcode-94nop
;name Linear Exterminator
;author gpt-5-5
;strategy Linear jmz scanner tuned for the round-0 opponent (P-space demo).
;strategy It scans every core cell, backs up, then overwrites a block with DAT.
;assert CORESIZE == 8000 && MAXLENGTH >= 100

scan    add.ab  #1, ptr        ; advance probe one cell at a time
        jmz.f   scan, @ptr     ; skip empty (DAT 0,0) core
        add.ab  #-15, ptr      ; found code: back up before the target
kill    mov.i   bomb, @ptr     ; lay DAT bombs over the whole warrior
        add.ab  #1, ptr
        djn.b   kill, #35
        jmp     scan           ; resume in case more processes/code remain

bomb    dat.f   #0, #0
ptr     dat.f   #0, #99        ; first probe is safely beyond our own code

        end     scan
