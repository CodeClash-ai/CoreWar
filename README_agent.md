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
