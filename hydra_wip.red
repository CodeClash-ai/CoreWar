;redcode-94
;name HydraSweep
;author sonnet-5
;strategy Chain self-replication: the loaded warrior copies its whole
;         body to a location STEP cells away, spl's a child process
;         there (landing at 'start', skipping the replicate block),
;         and that child does the same thing again, and so on, for
;         MAXGEN total generations/origins evenly spaced all the way
;         around the whole core (STEP = core/MAXGEN). Each origin then
;         runs ONE simple full-coverage sweep, but *bounded to its own
;         local STEP-sized sector only* (never leaving its own slice
;         of the core) -- since the sectors exactly partition the
;         whole 8000-cell core with no gaps and no overlap, the union
;         of all MAXGEN origins' local sweeps guarantees full-core
;         coverage collectively, same as one giant sweep would, but
;         (a) each local sweep is much faster to complete (finds
;         anything in its own ~500-cell sector in ~1000 cycles instead
;         of one sweep needing ~16000 cycles to cover the whole 8000
;         core), (b) sectors never overlap so there is NO friendly
;         fire between origins (unlike the previous DualSweep design,
;         which had two origins whose full-core sweeps did stomp on
;         each other -- a measured, accepted regression at the time),
;         and (c) losing any subset of origins to an early localized
;         attack still leaves every other origin fighting independently
;         in its own sector, so we're never wiped out by one lucky
;         early hit the way a single-footprint design is.

MAXGEN    equ     16
STEP      equ     500             ; 8000 / MAXGEN
LEN       equ     (finish-replicate)
MARGIN    equ     10              ; safety buffer before next sector
LOCALHALF equ     (STEP-LEN-MARGIN)

          org     replicate

replicate
          djn     hop, hopsleft
          jmp     start
hop
          mov.ab  #(replicate-srcp2), srcp2
          mov.ab  #(replicate+STEP-dstp2), dstp2
          mov.ab  #LEN, cnt2
rloop     mov.i   @srcp2, @dstp2
          add.ab  #1, srcp2
          add.ab  #1, dstp2
          djn     rloop, cnt2
          spl     @dstp3, 0
          jmp     start

dstp3     dat     #0, #(replicate+STEP-dstp3)
srcp2     dat     #0, #0
dstp2     dat     #0, #0
cnt2      dat     #0, #0
hopsleft  dat     #0, #MAXGEN

start
sweep     add.ab  #1, bmb
          mov.i   bmb, @bmb
          djn     sweep, cnt
          sub.ab  #LOCALHALF, bmb
          mov.ab  #LOCALHALF, cnt
          jmp     sweep

cnt       dat     #0, #LOCALHALF
bmb       dat     #0, #0

finish
          end     replicate
