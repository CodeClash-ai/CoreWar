;redcode-94
;name QuadSweep
;author sonnet-5
;strategy Generalizes DualSweep's one-time self-relocation (2 origins)
;         to a short 4-origin replication CHAIN (see README_agent.md
;         round-3/4 notes): origin K copies its whole body to
;         origin K + HOPLEN and spl's a child there landing straight
;         at 'start' skip... actually at 'replicate' so the child can
;         continue the chain itself (decrementing hopsleft), while
;         origin K also continues on to 'start' immediately. This
;         keeps chain latency low (only 3 sequential hops to reach the
;         4th/last origin, unlike the abandoned 16-origin HydraSweep
;         prototype which needed 15 sequential hops and started its
;         last origins' sweeps too late -- see README_agent.md
;         "HydraSweep prototype, NOT shipped" section for the
;         diagnosed regression). Each of the 4 origins then runs the
;         exact same, already-validated 4-process TwinSweep (1 slow
;         full-core sweep + 3 fast residue sweeps) as DualSweep -- NOT
;         the sector-bounded sweep also prototyped last round, to
;         isolate "more origins, less chain latency" as the only
;         change from the previous (692-score) DualSweep baseline.
;         Rationale: real match logs (/logs/rounds/0-3) show the real
;         opponent ("returnofthelivingdead") is a massive, fast,
;         sustained-growth swarm (avg peak procs ~2900, reaches
;         hundreds of processes within a few hundred cycles -- see
;         forensic trace analysis in README_agent.md). DualSweep's 2
;         origins get overwhelmed/found too easily; 4 independent,
;         physically-separated origins (each with its own full 4-
;         process TwinSweep) should be harder to wipe out entirely
;         and reach fighting strength almost as fast (only 1 extra
;         hop-latency vs DualSweep's 1 hop).

MAXGEN  equ     4               ; total origins (chain length)
HOPLEN  equ     2000            ; core/MAXGEN: spacing between origins
LEN     equ     (finish-replicate)  ; whole warrior length (cells)
HALF    equ     7960
FAST    equ     16
THIRD   equ     -4
FHALF   equ     3000

        org     replicate

replicate
        djn     hop, hopsleft
        jmp     start
hop
        mov.ab  #(replicate-srcp2), srcp2
        mov.ab  #(replicate+HOPLEN-dstp2), dstp2
        mov.ab  #LEN, cnt2
rloop   mov.i   @srcp2, @dstp2
        add.ab  #1, srcp2
        add.ab  #1, dstp2
        djn     rloop, cnt2
        spl     @dstp3, 0
        jmp     start

dstp3   dat     #0, #(replicate+HOPLEN-dstp3)
srcp2   dat     #0, #0
dstp2   dat     #0, #0
cnt2    dat     #0, #0
hopsleft dat    #0, #MAXGEN

gbmb    dat     #0, #0
gcnt    dat     #0, #FHALF
kbmb    dat     #0, #0
kcnt    dat     #0, #FHALF

start   spl     fast_f, 0
        spl     fast_b, 0
        spl     fast_k, 0

fwd     add.ab  #1,   fbmb
        mov.i   fbmb, @fbmb
        djn     fwd,  fcnt
        sub.ab  #HALF,fbmb
        mov.ab  #HALF, fcnt
        jmp     fwd

fast_f  add.ab  #FAST,  hbmb
        mov.i   hbmb, @hbmb
        djn     fast_f, hcnt
        sub.ab  #FHALF*FAST, hbmb
        mov.ab  #FHALF, hcnt
        jmp     fast_f

fast_b  add.ab  #-FAST, gbmb
        mov.i   gbmb, @gbmb
        djn     fast_b, gcnt
        add.ab  #FHALF*FAST, gbmb
        mov.ab  #FHALF, gcnt
        jmp     fast_b

fast_k  add.ab  #THIRD, kbmb
        mov.i   kbmb, @kbmb
        djn     fast_k, kcnt
        sub.ab  #FHALF*THIRD, kbmb
        mov.ab  #FHALF, kcnt
        jmp     fast_k

fcnt    dat     #0, #HALF
hcnt    dat     #0, #FHALF
fbmb    dat     #0, #0
hbmb    dat     #0, #0

finish
        end     replicate
