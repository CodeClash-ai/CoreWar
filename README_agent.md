# Agent Notes (CoreWar)

## Game setup
- Entry point: `warrior.red` (Redcode-94). This is the file that plays each match.
- Hill config: `config/94.opt` -> core 8000, 80000 cycles, max length 100, 8000 procs.
- Simulator is prebuilt: `./src/pmars`. Rebuild with `make -C src` if needed.
- The match runs ~2000 battles both orderings; winner = higher total wins.

## How to test locally
Save opponent to `test/opponent_pspace.red` (already there = the opponent so far,
a stationary imp `jmp 0`). Then:
```
./src/pmars -r 200 -@ config/94.opt warrior.red test/opponent_pspace.red | tail -3
```
"Results: W L T" is from warrior.red's perspective (wins losses ties).

## Opponent seen (round 0)
- "pspace" = the P-space demo warrior, which reduces to a STATIONARY imp `jmp 0`
  (one cell, never moves, never attacks). Round 0 was a 0-0 Tie because both bots
  were the useless demo.

## Current warrior: Stone10 (bomber + imp)
- SPLits into 2 moving imps (`mov.i 0, 2667`) for survivability.
- Bomber sweeps the WHOLE core ~3x with DAT bombs using coprime step 2365
  (coprime with 8000 => hits every cell, guaranteed to kill any STATIONARY target).
- After ~24000 bomb iterations the bomber terminates cleanly (falls into a DAT),
  so it stops bombing its own imps. Surviving imps carry the game.
- vs current opponent: ~148-52 over 200 rounds (strong win).

## Tuning notes / dead ends tried
- Pure carpet/dwarf bombers (step 1 or 4) LOSE to the stationary imp: they bomb
  their own single process before covering the enemy cell, or miss the cell
  entirely (non-coprime step).
- More imps launched ADJACENT interfere and hurt (3 imps + short sweep = 50-150, bad).
- 2 imps + ~24000 sweep is the sweet spot found so far.
- A pure Silk replicator (paper) only TIES (can't kill the single enemy cell).

## Ideas for future rounds (if opponent changes)
- If opponent becomes a scanner/bomber, add a decoy or make the warrior harder to
  scan (spread components, use SPL carpet). Consider a proper imp-gun for defense.
- If opponent becomes a paper (replicator), a fast bomber/vampire may be needed;
  imps + core clear help too.
- Test against previous versions in /tmp or copy them into test/ before submitting.
- Key metric: maximize (wins - losses); ties are worth little.

## ROUND 2 UPDATE (Stone13) — big win vs current opponent
- KEY DISCOVERY: opponent (git branch human/pspace) reduces to STATIONARY `jmp 0`.
  Round-1 Stone10 used step=2365 which has gcd(2365,8000)=5 -> only hits 1/5 of
  core, missing the enemy 4/5 of first pass. That gave only ~71% wins (355/500).
- FIX: use a SMALL COPRIME step. gcd(step,8000)=1 covers the whole core; a SMALL
  step bombs densely & fast. step=13 => 2000-0 vs jmp 0 (perfect).
- Kept 3-imp spiral (spl imp x3, mov.i 0,2667) launched FIRST for survivability
  vs a possible future bomber opponent.
- Tradeoff measured: tiny step loses to real small-step bombers (vs dwarf ~96-204).
  Acceptable because live opponent is jmp 0. If opponent switches to a bomber/
  scanner, RAISE the step (bigger step = better vs bombers, slightly worse vs
  stationary) or add a proper imp-gun / core-clear.
- Analysis: opponent warrior source is `git show human/pspace:warrior.red`
  (P-space demo, all branches -> jmp 0). Live test file: test/opponent_pspace.red.
- Quick sweep tool: loop over `step equ N` with sed and run pmars vs both
  test/opponent_pspace.red (jmp0) and doc/examples/dwarf.red (bomber baseline).
