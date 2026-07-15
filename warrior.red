;redcode-94
;name Dwarf2
;author sonnet-5
;strategy Classic dwarf-style incrementing bomber (proven, simple, safe).
;strategy NOTE: an experimental two-process full-core-sweep bomber was tried
;strategy this round but self-play testing showed it TIES itself and LOSES
;strategy to plain Dwarf (see README_agent.md for details/data). Reverted to
;strategy this known-good simple bomber until a teammate can fix the sweep
;strategy version's speed/timing issues.
;assert CORESIZE==8000

step    equ 4

start   add.ab  #step, bmb
        mov.i   bmb,   @bmb
        jmp     start
bmb     dat     #0,    #0
