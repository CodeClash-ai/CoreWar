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

## ROUND 2 UPDATE #3 (opus-4-8) -- opponent still DWARF, KEPT SilkGuard (no change)
- Opponent CONFIRMED = dwarf again (round 0 loss 2602-1398 with OLD Hydra; round 1 WON 668-35
  with SilkGuard). sim_0.jsonl header: {"0":"opus-4-8","1":"dwarf"}.
- Current warrior = SilkGuard (silk step=400, bomber bstep=3800). VERIFIED unchanged & optimal.
- EXPERIMENTS this round (ALL within run-to-run NOISE, none reliably beat current -> kept as-is):
  - bstep sweep {50,2667,3037,3359,3400,3600,3800,4001}: paired r=3000 runs show 3800 vs 3400
    are IDENTICAL (~4040 pts, ~535W/32L/2430T). Differences between steps are pure variance.
  - silk step sweep {300..3033}: step=1000/1100 looked slightly higher (2707 vs 2692) BUT had
    MORE losses (37 vs 14) which RAISES dwarf's score. Net neutral. step=400 is clean & proven.
  - TWO parallel bombers: WORSE (125 losses -- bombers overwrite own silk).
  - Extra `spl 1,0` in silk (faster fork): BROKE offset timing -> mostly ties (102W/0L/1398T). BAD.
  - Pure silk (no bomber): 113W/0L/887T = 1226 pts. SilkGuard's bomber adds ~77 wins -> 1374 pts.
    The bomber IS worth it. Keep it.
- ROBUSTNESS re-verified (r=500): vs validate 494-4-2, vs stone 464-36-0. SilkGuard is a safe
  all-rounder vs passive, slow-bomber, and fast-bomber opponents.
- CONCLUSION: No code change. SilkGuard is proven (real match 668-35) and tuning gains are noise.
  If opponent EVER becomes a REPLICATOR or SCANNER (silk-vs-silk = tie-fest, scanner may hunt our
  copies), THEN build a proper anti-replicator (e.g. vampire/pit-trap or a bomber with SPL bombs)
  and TEST -- but that is not the current matchup.

## ROUND (opponent CHANGED to SMOOTH NOODLE MAP) UPDATE (opus-4-8)
- !!! NEW OPPONENT = **smoothnoodlemap** ("Smooth Noodle Map" by Matt Hastings) = a SCANNER-BOMBER.
  From sim traces it scans/bombs with a small step (~34), owns ~15% core, ~1 process.
- Round 0 result: WON 3834-161 (traced: 95 wins / 5 losses / 0 ties). SilkGuard crushes it: our
  silk copies spread core-wide faster than its scanner can hunt them; parallel bomber lands kills.
- NO source available locally. I reconstructed an approx scanner in /tmp/snm2.red (SPL-bomb scanner,
  step 34) that reproduces the ~5% loss rate -> use it to sanity-test but it is NOT the exact foe.
- EXPERIMENTS this round (ALL noise or regressions -> KEPT SilkGuard unchanged):
  - silk step {300,400,500,800,2667}: at 1500 rounds step=400 (current) WINS MOST (995 vs 925 for
    500). Earlier 400-round result favoring 500 was pure noise. step=400 also best vs validate (395-4
    vs 386-9). KEEP 400.
  - bstep {2667,3037,3359,3800,4001,5333, coprime vs not}: all within noise (~975-1010 wins). gcd
    with 8000 doesn't matter (bomber loops many times in 80k cycles). KEEP 3800.
  - TWO parallel bombers (offset 4000): MUCH WORSE (739 vs 982 wins) -- bombers overwrite own silk,
    confirming prior notes. Single bomber is correct.
- CONCLUSION: NO code change. SilkGuard is proven vs this scanner (real 3834-161 = 95%+) and every
  tested variation is noise or a regression. Backup at /tmp during my session; warrior.red unchanged.
- IF OPPONENT CHANGES to a REPLICATOR (silk-vs-silk tie-fest) or a very fast quickscan that hunts
  copies: consider an anti-replicator (SPL-carpet/vampire) but TEST solo first and keep silk core.

## ROUND 2 (this session) UPDATE #4 (opus-4-8) -- opponent STILL smoothnoodlemap, KEPT SilkGuard
- Confirmed opponent = smoothnoodlemap in ALL 100 traced battles of round 1 (grep of sim headers).
- Round 0 WON 3834-161, Round 1 WON 3851-143. Traced round1 battles: 95 WIN / 5 LOSS / 0 TIE.
- Analyzed the 5 LOSS traces (sim_19,70,86,87,94): ALL have opponent spawning CLOSE to us
  (dist ~158-3300, opp starts 7842/6540/7468/4874/5202 vs us at 0). Our process count grows to
  ~283 then COLLAPSES to death ~t=7000 -> the scanner+bomber finds & clears our concentrated silk
  before it spreads enough. This is the fundamental close-spawn weakness; hard to fix.
- EXPERIMENTS this round (vs /tmp/snm2.red reconstruction, r=500-1000; ALL noise or regressions):
  - +imp launcher (2667): fewer losses (2 vs 10) BUT fewer wins (more ties) -> WORSE (imp doesn't kill).
  - bstep 3359 vs 3800: identical (noise).
  - boot reorder (silk first, no re-loop): WORSE (461 vs 511 wins).
  - silk step=800: clearly WORSE (572 vs 671 wins, more ties).
- NOTE: /tmp/snm2.red reconstruction is TOO tie-heavy (gives ~320W/15L/165T vs real 95W/5L) so it
  under-rewards kills. Real opponent dies far more easily than the reconstruction. Trust the REAL
  match scores over the reconstruction. Every large-N experiment still points to step=400/bstep=3800.
- CONCLUSION: NO code change. SilkGuard (step=400, bstep=3800) is proven optimal (95%+ real wins) and
  matches all prior teammates' 1500-round conclusions. Robustness re-verified this round:
  vs dwarf 91-8-401, vs validate 492-6-2.

## ROUND (opponent = smoothnoodlemap6) UPDATE -- DOUBLE-TAP BOMBER (opus-4-8)
- Opponent = smoothnoodlemap6 (Smooth Noodle Map 6, Matt Hastings). It's a bidirectional
  sequential bomber/scanner (traces: warrior 1 starts ~2175 & ~1866, two threads spreading
  in opposite directions). Round 0 with OLD single-tap SilkGuard: WON 3027W-170L-803T.
  Note the 803 TIES = the improvement opportunity (a tie gives opp points; a kill converts it).
- CHANGE: bomber now drops **2 DAT bombs per loop** (double bombing throughput) instead of 1.
  Same silk core (step=400) and same bstep=3800. This just makes the offense kill faster ->
  converts ties into wins without adding losses.
- VERIFIED (pmars -r 400, NEW vs OLD /tmp/current.red = single-tap):
    NEW beats OLD head-to-head BOTH orders (219-135 and 211-140 for NEW).
    vs dwarf:   NEW 116-2  vs OLD ~51-3   (BIG improvement -- kills the slow bomber far more)
    vs validate:NEW 395-0  vs OLD 295-4   (perfect now)
    vs pspace:  399-1      vs snm-recon:  344-2   (low losses everywhere)
- Tuning tried: 3 bombs/loop (v3) = no better, slightly worse vs validate. bstep sweep
  {800,2667,3037,3800} on snm-recon => 3800 still best (800 clearly worse). KEEP 3800, 2 taps.
- CAVEAT: my /tmp/snm.red reconstruction is a step-34 scanner and is KNOWN-unreliable (per prior
  notes it under-rewards kills / too tie-heavy). Trust the mirror-match + dwarf/validate results
  and the REAL match score. The 2-tap change is strictly faster offense with no downside seen.
- If opponent changes to a REPLICATOR (silk-vs-silk tie-fest), an anti-replicator (SPL-carpet or
  vampire) may be needed -- but TEST solo first and keep the silk survival core.
