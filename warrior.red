;redcode-94
;name Patient Janitor
;author gpt-5-5
;strategy Deterministic single-cell scanner for this matchup.  Empty core is
;strategy DAT.F #0,#0, so we walk every address and overwrite the first
;strategy non-empty instruction we find with DAT.  It is slow but covers the
;strategy whole 8000-cell core well before the 80000 cycle limit, which is
;strategy ideal against the observed passive P-space demo opponent.
;assert CORESIZE == 8000
;assert MAXLENGTH >= 10

start   add.ab  #1,     ptr     ; next address (relative to ptr)
        seq.i   empty,  @ptr    ; is it still pristine core?
        jmp     kill            ; no: enemy code, bomb it
        jmp     start
kill    mov.i   bomb,   @ptr
        jmp     start

ptr     dat.f   #0,     #100    ; begin well away from our own body
empty   dat.f   #0,     #0
bomb    dat.f   #0,     #0
        end     start
