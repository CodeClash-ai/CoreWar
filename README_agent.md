# Agent notes (round 1)

## What I found
- `warrior.red` at repo root is the bot entry point (redcode-94, core=8000,
  cycles=80000, maxlen=100, matches `config/94.opt`).
- Round 0's log (`/logs/rounds/0`) showed an all-tie result because
  `warrior.red` was still the unmodified starter demo (`;name P-space demo`)
  -- it just sits in an infinite `jmp` loop and never fights. Both sides in
  that log appear to be this same inert demo.

## What I did
Replaced `warrior.red` with "TwinSweep": a multi-process dwarf-style core
bomber.
- 2 "slow" sweepers (step 1) go outward from our own code in opposite
  directions (+1/-1), each stopping after `HALF=3990` steps (a bit under
  core/2) so between the two of them they cover ~99.75% of the 8000-cell
  core exactly once, *without ever re-entering our own instructions*
  (important bug I hit and fixed: the bomb/pointer cells must sit at the
  very front/back of your own instruction block, otherwise your first
  bombing steps walk back through your own code and kill yourself -- see
  git history / this file's earlier version for the failure mode).
- 2 "fast" sweepers (step `FAST=4`) launched the same way, to close
  distance to nearby small targets faster (a plain step-1 sweep is slow
  vs. e.g. classic `Dwarf`, which moves 4 cells/iteration for the same
  cycle cost -- see Analysis below).
- All 4 sweeps auto-reset and repeat forever (never idle), and never risk
  self-hit because they stop well before completing a lap.

Tested locally with `src/pmars` (already built) against:
- `doc/examples/dwarf.red` (classic Dwarf, step-4 single bomber)
- a hand-made inert "jmp self" warrior (`/tmp/old_demo.red`, recreate it
  if needed -- see below) as a stand-in for a totally passive opponent.

Commands used (from `/workspace`):
```
./src/pmars -@ config/94.opt -A warrior.red        # assemble-only check
./src/pmars -@ config/94.opt -r 200 -b warrior.red doc/examples/dwarf.red
```

Results (out of 200 rounds unless noted):
- vs inert "jmp self" loop: TwinSweep wins 100%.
- vs classic Dwarf: TwinSweep currently *loses* the majority
  (88 wins / 112 losses in my last run). Improved a lot from an earlier,
  buggy version (which lost ~2:18) after fixing the self-overwrite bug,
  and after adding the "fast" step-4 sweepers (was 67/133 with step-1
  only), but is still behind.

## Analysis / why we still lose to Dwarf, and ideas for next round
Core War timing insight: `add`+`mov` costs 2 cycles regardless of step
size. A step-N bomber covers N cells of *distance* per 2 cycles, so a
bigger step reaches a far-away target faster in wall-clock cycles, at the
cost of only hitting 1-in-N cells (coverage). Our own instruction block is
a contiguous run of ~19-38 cells, a fairly large/easy target, while
Dwarf's footprint is only 4 cells. Even though our sweep eventually
covers ~all of the core and Dwarf only ever covers 1/4 of it, Dwarf can
often reach *some* cell in our contiguous block faster (distance/4
iterations) than our step-1 sweep can reach Dwarf's tiny footprint
(distance iterations). The step-4 "fast" sweepers I added help but
apparently aren't enough yet.

Ideas to try next (didn't have steps left to try these myself):
1. Shrink our own instruction footprint (fewer, more compact
   instructions) so we're a smaller target for opponents' bombers.
   Splitting our code into several small chunks scattered further from
   the bomb pointers, or using p-space to store state instead of dat
   cells, could help.
2. Make the "fast" scanners even faster (bigger step, e.g. 8-16) launched
   first / with priority, since the earliest hits matter most while both
   sides' processes are still few.
3. Consider a real scanner (`seq`/`cmp` probes) to detect the opponent's
   actual location before committing to a full-core carpet bomb, rather
   than carpet-bombing blindly - this is the standard "scanner + bomber"
   architecture and would likely beat both Dwarf and passive loopers
   easily, but takes more careful implementation/testing time than I had
   left this round.
4. Add a self-check: after `spl`, verify our own core region hasn't been
   damaged (re-copy from a template) -- cheap insurance against getting
   sniped early.
5. Test against more/varied opponents beyond Dwarf (only one reference
   warrior ships in `doc/examples/`). Consider writing a couple of
   simple reference opponents (imp ring, silk/vampire, scanner) into
   `/workspace/test_opponents/` for regression testing across rounds.

## Useful facts / gotchas
- `src/pmars` is prebuilt in this repo; no need to `make` (but `make -C
  src` should work if you need to rebuild after touching `src/*.c`).
- Assemble-check only: `./src/pmars -@ config/94.opt -A warrior.red`
- Run N rounds headless: `./src/pmars -@ config/94.opt -r N -b
  warrior.red <opponent.red>` -- prints `Results: winsA winsB ties`.
- `-F <addr>` fixes warrior 2's start offset (useful for deterministic
  debugging); combine with `-T <file>` to get a battle trace
  (`e/w/s/x/D` events per docs comment in `src/tracedisp.c`) which is
  much more informative than pmars's default (name-only) output, since
  `-b` suppresses source listings.
- Trace event `x <cycle> <warriorIdx> <tasksLeft> <addr>` = a process of
  that warrior died (hit a DAT) at `<addr>`. If `<addr>` falls inside your
  own warrior's loaded range, you have a self-overwrite bug (this is
  exactly the bug I found and fixed this round).
- `config/94.opt` is the ruleset actually used by the match harness
  (confirmed by matching `core`/`cycles` fields in
  `/logs/rounds/0/sim_0.jsonl` header: `core=8000, cycles=80000`).
- The opponent this round is named "pspace" in match metadata; I don't
  know its real strategy (round-0 logs only show the placeholder demo).
