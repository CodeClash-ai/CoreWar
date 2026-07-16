;redcode-94
;name Swarm2
;author test-harness
;strategy Improved synthetic stand-in for the real opponent
;         "smoothnoodlemap6" (see README_agent.md round-2 session-2
;         notes for the forensic trace analysis this is based on).
;         Real match traces (/logs/rounds/1/sim_*.jsonl) show: (a) the
;         opponent spawns MANY processes early (peak ~62) that spread
;         out and bomb broadly but don't hold much core (~6-8% core
;         owned), consistent with a wide spl-replicator; (b) in the
;         specific traced LOSSES (11/100), both sides had attrited down
;         to exactly 1 process each by the end, and the opponent's
;         final surviving process was almost always sitting at a FIXED
;         address ~310-314 cells before their own load address (e.g.
;         loaded at 0, guard's loop code around 7686-7690) -- i.e. a
;         static defensive "guard" loop that is NOT part of the mass
;         spl-swarm, positioned just outside their own code block on
;         the side a full-core sweep would first arrive from. This
;         synthetic opponent reproduces both traits: `grow` spl-spawns
;         copies like the original swarm.red, AND a separate `guard`
;         process (spl'd once at start, never respawned) sits in a
;         tight self loop bombing its own immediate neighborhood only
;         (small fixed range) -- rough approximation, NOT the real
;         opponent's actual code (we still don't have that). Use this
;         to A/B test whether structural changes to warrior.red help
;         or hurt against "many cheap attackers + 1 static guard"
;         shaped opponents, since that shape is a better local proxy
;         than plain swarm.red (which our current warrior already
;         beats 100/100 trivially and thus has ~zero discriminating
;         power for tuning decisions).
STEP    equ     47
GSTEP   equ     3

ptr     dat     #0, #0
gptr    dat     #0, #0

start   spl     grow, 0
        spl     guard, 0
        add.ab  #STEP, ptr
        mov.i   ptr, @ptr
        jmp     start

grow    add.ab  #STEP, ptr
        mov.i   ptr, @ptr
        spl     grow, 0
        jmp     grow

guard   add.ab  #GSTEP, gptr
        mov.i   gptr, @gptr
        djn     guard, gcnt
        sub.ab  #40*GSTEP, gptr
        mov     gtmpl, gcnt
        jmp     guard

gcnt    dat     #0, #40
gtmpl   dat     #0, #40

        end
