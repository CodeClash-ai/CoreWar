# Agent Notes (Core War)

## Game setup
- Entry point: `warrior.red` (this is OUR bot, name "opus-4-8" in logs).
- Match: pMARS '94 standard. coresize=8000, cycles=80000, maxprocesses=8000, maxlength=100.
- Run pMARS locally: `./src/pmars -r 100 -s 8000 -c 80000 -p 8000 -l 100 warrior.red <opponent.red>`
  - Output "Results: A B T" = A wins for warrior1, B wins for warrior2, T ties.
  - Scoring: WIN = 3 pts, TIE = 1 pt, LOSS = 0. So WINS >> ties. Prefer killing the opponent.

## Opponent (round 0 / round 1)
- Opponent "pspace" was the DEFAULT P-space demo warrior: it just does `jmp 0` (loops forever, self-ties).
  It NEVER dies on its own -> the only way to beat it is to BOMB it (win, 3pts), else you tie (1pt).

## Current bot: `warrior.red` = "Sweeper"
- A DAT bomber with step = 2667 (~coresize/3). Sweeps 3 evenly spaced points fast, so it
  reliably lands a DAT on the tiny 4-cell passive demo. Scores 100-0 vs the demo.
- CAVEAT: step 2667 is tuned for PASSIVE opponents. It is weaker vs active bombers/scanners
  (loses to a simple dwarf ~62/38, loses to a stone). If a FUTURE opponent is active, replace with
  a more robust warrior (a proper stone bomber with anti-imp step ~3037 + core clear, or a working
  silk replicator).

## Things I tried that FAILED (don't repeat blindly)
- Silk/paper replicators: my hand-written versions had wrong address arithmetic and lost badly.
  If you attempt a replicator, verify it self-replicates in a solo run first (`pmars -r 1 warrior.red`
  and watch process count grow) before trusting it.
- SPL "carpet" bombs vs the passive demo => everything TIES (0-0-100). Ties are only 1pt; a DAT
  bomber that WINS (3pts) is strictly better vs a passive looper.

## Quick step-tuning tool
for step in 3037 2667 3359 4001; do
  # edit /tmp/b.red with that step, run pmars, grep Results
done
Steps that hit passive demo well: 2667 (perfect 100-0). Bad: small steps (self-bomb).

## Suggested next improvements
1. Confirm the opponent for your round from /logs/rounds/<n>/results.json + sim_*.log.
2. If opponent is still passive -> keep Sweeper (guaranteed 3pts/round wins).
3. If opponent becomes active -> build & TEST a robust dual-purpose warrior before submitting.

## ROUND 2 UPDATE (opus-4-8)
- Confirmed opponent still PASSIVE (round 1: won 3996-4). pspace = single `jmp 0` looper.
- Replaced Sweeper with **Hydra** (warrior.red): same 2667 DAT sweep (100-0 vs pspace) BUT after
  sweeping the core it `jmp imp` -> classic imp (`mov.i 0,1`) as a survival fallback.
  - Rationale: strictly safer than pure Sweeper. Still 100-0 vs passive; does BETTER vs active
    foes (vs a dwarf: Hydra 34 wins vs Sweeper's 15). Beats old Sweeper head-to-head 53-47.
- Still WEAK vs dwarf-style bombers overall (34-66) - the lone imp doesn't survive heavy bombing.
  If opponent ever turns into an aggressive bomber/scanner, build a proper imp-SPIRAL (3 imps
  spaced coresize/3 apart) + core-clear, and TEST it (must keep 100-0 vs pspace).
- Test harness (verified working):
    ./src/pmars -r 100 -s 8000 -c 80000 -p 8000 -l 100 warrior.red /tmp/pspace.red
    # /tmp/pspace.red = ;redcode \n jmp 0   (recreate it; it's outside /workspace)

## ROUND 3 UPDATE (opus-4-8)
- Opponent CONFIRMED = "validate" (Validate 1.1R by Stefan Strack). Source is at
  doc/examples/validate.red -> test directly: 
    ./src/pmars -r 100 -s 8000 -c 80000 -p 8000 -l 100 warrior.red doc/examples/validate.red
- Round 0 result: won 3997-3 (100-0 in traced battles). Our DAT sweep kills validate reliably.
- IMPROVED Hydra: kept the 2667 DAT sweep BUT (a) shortened sweep to cnt=50 so imps launch
  early, and (b) replaced the single lone imp with a proper 3-way SPL imp SPIRAL (imp1/2/3).
  Results (r=100) vs test warriors:
    validate: 100-0 (unchanged, still perfect vs the real opponent)
    stone(3037 bomber): 100-0  (OLD Hydra LOST to stones -> big improvement)
    dwarf: ~37-63 (was 33-67, marginal improvement; dwarf still beats us)
    imp: ~9-0-91 (mostly ties, fine)
    beats OLD Hydra head-to-head 51-49
- Test opponents I created live in /tmp (recreate if needed): imp.red, stone.red.
- REMAINING WEAKNESS: fast in-fighting bombers like dwarf still win (~37-63). The imp spiral
  survives but doesn't kill fast bombers. If opponent EVER changes to an aggressive bomber,
  build a proper scanner (e.g. a quickscan+bomber) and TEST -- but keep 100-0 vs validate.

## ROUND 2 UPDATE #2 (opus-4-8) -- KEPT Hydra, verified optimal vs validate
- Opponent CONFIRMED = "validate" (won round 0: 3997-3, round 1: 3993-7). Passive self-tie warrior.
- Verified current Hydra vs validate over 500 rounds: 498-2 (and swapped 499-1). The ~0.2% loss
  is unavoidable random-start noise and MATCHES the real match scores (~7/4000). Essentially optimal.
- EXPERIMENTS I RAN (none beat current Hydra -> kept it as-is):
  - hydra2/hydra3/hydra4: added a CONTINUOUS offensive bomber after the sweep. Keeps 100-0 vs
    validate, but over 250 rounds hydra3 LOST head-to-head to current Hydra (109-141) and was
    IDENTICAL vs dwarf (98-152 vs 99-151). The initial 53-47 "win" was just noise. NOT an improvement.
  - Pure continuous bomber (no sweep-stop): LOSES to validate 29-71 (never reliably lands the
    kill because validate self-ties/loops -- you MUST do the fast 2667/cnt50 sweep + STOP to kill it).
  - More imps (5-way spiral): hurt validate (99 vs 100), no help vs dwarf. Rejected.
  - Hand-rolled SEQ scanner: broken (lost 1-99 vs validate). Scanners are hard to hand-write here;
    if a teammate wants one, TEST solo behaviour first.
- FUNDAMENTAL TENSION (documented for future teammates): to kill validate you must bomb-then-STOP
  and survive with imps; to beat an ACTIVE bomber (dwarf/stone) you must bomb CONTINUOUSLY. These
  conflict. Current Hydra optimizes for the ACTUAL opponent (validate) = correct choice while
  opponent stays passive. If opponent EVER becomes an active bomber, a proper tested scanner or
  fast bomber+coreclear is needed (accepting we may lose the perfect validate score).
- CONCLUSION: No code change this round. Hydra is proven and optimal vs the real opponent.

## ROUND (opponent CHANGED to DWARF) UPDATE (opus-4-8)
- !!! OPPONENT IS NO LONGER PASSIVE. Round 0 results.json shows opponent = **dwarf**
  (A.K. Dewdney's classic slow sequential DAT bomber, step=4). Source: doc/examples/dwarf.red
- OLD Hydra LOST 2602-1398 (34-66 in traced battles) -- exactly the weakness prior notes warned of.
- REPLACED warrior.red with **SilkGuard**: a silk REPLICATOR (survival) + parallel STONE bomber
  (offense, bstep=3800). Rationale below.
  - Silk replicator spreads copies core-wide so a slow bomber can NEVER kill them all in 80k cycles
    => essentially 0 losses (guaranteed win-on-points via ties even if we don't kill).
  - Added parallel stone bomber to convert many of those ties into KILLS (3pts vs 1pt).
- MEASURED (pmars -r N):
    vs dwarf   (r=2000): 390 W /  19 L / 1591 T  -> 2761 vs 1648  (CLEAR WIN)
    vs validate(r=500):  497 W /   2 L /    1 T  (near perfect; handles passive foe too)
    vs stone   (r=500):  465 W /  35 L           (crushes stones)
    vs old Hydra(r=500): 310 W / 189 L           (beats our previous bot)
- Test harness: ./src/pmars -r 500 -s 8000 -c 80000 -p 8000 -l 100 warrior.red doc/examples/dwarf.red
- TUNING NOTES: silk step=400 spreads well; bomber bstep=3800 maximized dwarf kills w/ few losses.
  Pure silk (no bomber) = 0 losses but far fewer kills (48/500 vs 85/500). The bomber is worth the
  ~2/500 extra losses for ~37/500 extra wins.
- IF OPPONENT CHANGES AGAIN: SilkGuard is robust vs passive (validate), slow bombers (dwarf),
  and fast bombers (stone). It should be a safe default. If a NEW aggressive scanner appears,
  re-tune bstep or verify losses stay low, but keep the replicator core for survival.
