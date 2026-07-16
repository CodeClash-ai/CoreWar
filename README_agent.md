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

# Round 2 update (sonnet-5)

## Context
- Round 0: tie (both sides were the placeholder demo warrior).
- Round 1: TwinSweep (FAST=4 fast-sweep step) beat the real opponent
  ("pspace") 100/100 in the traced sample, final score 4000-0. The
  opponent that round behaved like a totally passive single-process
  warrior (avg peak procs 1.0, 0% core owned, eliminated in all 100
  traces) -- i.e. they likely hadn't replaced their own placeholder demo
  yet. This may or may not still be true in round 2; treat "we crush an
  inert/naive opponent" as necessary but not sufficient for future
  rounds, since a real opponent bot would behave very differently.

## What I did this round
Investigated the previous agent's open question ("we lose to classic
Dwarf, 88/200"). Root-caused and fixed a real tuning issue, not just
cosmetic:
- The "fast" sweepers advance by `FAST` cells per iteration and run for
  `FHALF` iterations before resetting. The reset subtracts exactly
  `FHALF*FAST` from the pointer field, so the *net* displacement per
  lap is always an exact no-op (safe) -- BUT the intermediate pointer
  value during the lap can pass through absolute offset 0 relative to
  the pointer cell's own address. If `FAST` divides evenly into the
  core size (8000), that crossing always lands exactly back on the
  pointer's own `dat` cell (harmless self-bomb of a `dat #0,#0` cell
  with more `dat #0,#0`). If `FAST` does *not* divide 8000 evenly (e.g.
  the previous value tried, 17), the crossing lands on an arbitrary
  offset -- which can be *inside our own executable code block* and
  self-kill us. I confirmed this empirically: `FAST=17` occasionally
  *loses to a completely inert single-instruction opponent*
  (`/tmp/inert.red`, a `jmp start` loop) -- 9/50 losses purely from
  self-destruction, with 0 losses for divisor values of FAST.
  **Rule for future tuning: `FAST` (and any sweep step size sharing the
  reset-by-subtraction pattern used here) must be a divisor of the core
  size (8000 = 2^6 * 5^3; safe values include 2,4,5,8,10,16,20,25,32,
  40,50,64,80,100,125,...). Non-divisor step sizes are NOT just "less
  efficient", they are an active self-destruct bug.**

  Grid-searched divisor values of FAST from 4 up to 100 (100-300 rounds
  each vs `doc/examples/dwarf.red`, plus a 30-50 round sanity check vs
  the inert loop to catch self-hits). Results (win-rate vs Dwarf, out of
  the totals actually run):
  - FAST=4  (original): ~44% (66/150)
  - FAST=8:  47% (70/150)
  - FAST=10: 37% (55/150)
  - FAST=16: ~48-53% (96/200, 80/150, 84/150 across separate runs --
    noisy but consistently the best divisor found, and only one with
    zero self-hits/ties observed across all inert-loop sanity checks)
  - FAST=20/25/32/40/50/64/80/100: all worse than 16, decreasing
    monotonically as FAST grows past 16 (~45%->35%).

  Changed `warrior.red`'s `FAST` constant from 4 to **16**. This is a
  small, low-risk, well-tested tuning change (single constant), verified:
  - Still assembles cleanly (`-@ config/94.opt -A warrior.red`).
  - Still beats the inert-loop sanity check 100% (50/50, 0 losses/ties).
  - Improves the Dwarf matchup from ~37-44% win rate to ~48-53% (still
    not a clear favorite against Dwarf specifically, see Ideas below).

## Ideas for next round (didn't have step budget to try these myself)
1. We are still only ~50/50 against a classic Dwarf-style small bomber.
   Dwarf's whole footprint is 4 instructions; ours is ~40+. A real
   scanner (read-before-bombing, e.g. `seq.i @ptr, ztmpl` against a
   fixed all-zero template cell to test "is this still empty core"
   before spending a `mov` on it) doesn't actually save cycles per step
   (same 3-instruction-per-step cost as blind carpet bombing here), so
   it's not a free win -- the real lever is either (a) shrinking our own
   footprint so we're a smaller target, or (b) using p-space
   (`ldp`/`stp`, referenced in `doc/redcode/opcodes.md`, and this
   ruleset's `config/94.opt` supports it -- see the still-present
   P-space demo boilerplate on `human/pspace` branch / git history) to
   move some state out of core entirely.
2. Try applying the "FAST must divide 8000" rule to make the *slow*
   sweep step something other than 1 too (currently forced to step 1
   for full coverage without gaps) -- e.g. two slower sweepers at step 2
   covering interleaved residues, freeing cycles for more/faster
   scanners. Would need care to keep full coverage.
3. Build a couple of small reference opponents beyond `dwarf.red`
   (e.g. a simple imp ring, a simple replicator) under a
   `test_opponents/` dir for regression testing -- still hasn't been
   done across 2 rounds now, would meaningfully derisk tuning changes
   like the one made this round.
4. The `human/pspace` git branch in this repo is NOT the real opponent's
   code -- I checked, it's just a mirror of our own team's history
   (same TwinSweep commits appear there under a "pspace" label). Don't
   waste time trying to read opponent strategy from it.

# Round 1 update (sonnet-5, this session)

## Context
Only `/logs/rounds/0` was available this session (score: sonnet-5 4000,
opponent "validate" 0 -- turned out to be the ships-with-pmars
`doc/examples/validate.red` ICWS88 compliance-test warrior, a
near-passive single-process program; we killed it 100/100 in the traced
sample). No log data yet on a "real" adversarial opponent's strategy --
treat that clean sweep as encouraging but not diagnostic.

## What I did
Took the previous round's open item ("~50-52% vs classic Dwarf, not a
clear favorite") and ran a process-allocation experiment instead of more
step-size tuning (which earlier agents had already grid-searched
thoroughly for the divisor-safety rule -- see round-2 notes above, still
correct and unchanged: FAST must divide 8000).

Tried these process-count/allocation variants (all step sizes/margins
otherwise same as the FAST=16 baseline), each checked for (a) 100/100
safety vs an inert `jmp start` loop and (b) win rate vs
`doc/examples/dwarf.red` over 300-500 rounds:
- Baseline (2 slow + 2 fast = 4 procs, the shipped round-2 warrior):
  ~50-53% vs Dwarf (252/500, 158/300 in two separate runs).
- 2 procs, slow-only (both directions, no fast sweepers): ~40% vs Dwarf
  (120/300) -- confirms fast sweepers matter a lot, not just coverage.
- 6 procs (2 slow + 2 fast@16 + 2 fast@64): ~45% vs Dwarf (135/300) --
  *worse* than the 4-proc baseline. More processes dilutes the shared
  cycle budget faster than the extra coverage helps.
- 3 procs (2 slow + 1 fast, dropping one fast direction): ~54% vs Dwarf
  (272/500) -- slightly better than baseline.
- **3 procs (1 slow forward-only, full HALF=core-margin, + 2 fast in
  opposite directions): ~54-62% vs Dwarf across three separate 500-round
  runs (308/500, 287/500, 271/500) -- clearly the best variant found,
  and the one now shipped as `warrior.red`.** Rationale: the fast
  sweepers are what actually race and beat a small fast opponent like
  Dwarf; giving them 2 of the 3 total processes (instead of splitting
  evenly 2 slow/2 fast) means they get a much bigger share of the cycle
  budget MARS round-robins across active processes, at the cost of the
  full-coverage guarantee taking ~2x longer in wall-clock cycles (now
  one process sweeping ~7960 cells instead of two processes each
  sweeping ~3990) -- but that backstop kill was rarely the deciding
  factor anyway; the earlier fast-vs-fast race was.
  Verified this final version: still 100/100 safe vs inert loop, still
  100/100 vs `validate.red`, and 271-308/500 (54-62%) vs Dwarf across
  reruns (noisy but consistently >50%, unlike the old baseline's
  ~50-52% which was sometimes *below* 50%).

## Ideas for next round (didn't have step budget to try these myself)
1. This round only tuned *process count/allocation*, not step sizes,
   for the new 1-slow/2-fast shape. Worth re-running the FAST/FHALF
   grid search (per round-2 notes) specifically for this shape --
   might shift the optimum since the cycle-budget-per-process changed.
2. Still just one real reference opponent (`dwarf.red`) to test against.
   Building small reference imp-ring / replicator / basic-scanner
   opponents under `test_opponents/` (suggested 2 rounds running now)
   would help derisk future tuning -- if the real opponent this round
   turns out to be scanner-based rather than bomber-based, our whole
   sweep-based design might behave very differently and none of this
   round's Dwarf-based tuning would transfer.
3. Consider a real p-space or core-clear "stone" defense, or process
   self-check/re-copy (see round-1 idea #4 above), since we still have
   0 defensive mechanism against getting sniped early by a fast
   scanner-bomber -- untested this round, no reference scanner opponent
   available locally to check against.
4. Note for whoever tunes next: /tmp files from this session
   (`/tmp/baseline.red`, `/tmp/v4_3proc.red`, `/tmp/v5_1slow2fast.red`,
   `/tmp/inert.red`) will NOT persist to your session (fresh shell each
   round) -- recreate the inert-loop sanity check file if you want it
   (see round-1 notes above for the one-liner), and recreate any
   baseline you want to diff against from git history
   (`git log -- warrior.red`) instead of /tmp.

# Round 2 update (sonnet-5, this session #2)

## Context
- Confirmed via `/logs/rounds/0/results.json` and `/logs/rounds/1/results.json`:
  real matches so far have been 4000-0 sonnet-5 vs an opponent named
  "validate" in both prior rounds, and the trace data
  (`/logs/rounds/1/trace.md`) shows it's still just the ships-with-pmars
  `doc/examples/validate.red` demo (peak procs 1, eliminated 100/100 in
  the traced sample). So the real opponent has been totally passive both
  rounds -- but there's no guarantee that holds for round 3+, so treat
  Dwarf-matchup tuning as the useful signal for "a real, moving
  opponent" rather than assuming validate.red stays passive forever.

## What I did
1. **Found `pmars -f` (fixed starting-position series)** -- IMPORTANT
   discovery for future tuning: without `-f`, `pmars -r N` uses a
   time-based RNG seed, so re-running the *exact same* two warriors with
   the *exact same* `-r N` gives visibly different `Results: W L T` each
   time (I measured swings of +/-20 wins out of 300 just from rerunning
   the identical command back-to-back). This means **all prior rounds'
   win-rate numbers in this file (e.g. "54-62% vs Dwarf") are noisier
   than they looked** -- they were likely never using a fixed seed
   either. Adding `-f` makes results exactly reproducible across
   reruns of the same warrior files, which makes A/B comparisons between
   two candidate warriors *far* more trustworthy (same command run twice
   in a row now gives bit-identical `Results:` lines). **Recommend always
   using `-f` for any future tuning/A-B testing in this repo.**
2. Re-validated the FAST grid search from round-2-session-1 using `-f`
   (300 rounds, vs `doc/examples/dwarf.red`): confirmed FAST=16 is still
   the best single divisor-of-8000 step size (tried 4,5,8,10,16,20,25,
   32,40 -- 16 wins by a clear margin every time under `-f`, consistent
   with the earlier non-`-f` grid search's conclusion, so that finding
   holds up).
3. Tried a structural change kept within the same process-count budget
   (3 spawned `spl` processes + 1 main, matching last round's "1
   slow + 2 fast" shape): **added a third fast sweeper** with step
   `2*FAST=32` (also a divisor of 8000, so still safe per the
   established divisor rule) alongside the existing `+FAST`/`-FAST`
   pair, so there are now 3 fast residue-class sweeps racing a small
   opponent instead of 2, still just 1 slow full-coverage backstop.
   Under `-f` with 1000 rounds vs `doc/examples/dwarf.red`:
   - Previous (1 slow + 2 fast, FAST=16): **572/1000 (57.2%)**
   - New (1 slow + 3 fast, FAST=16, third at step 2*FAST=32): **591/1000
     (59.1%)**
   Reproducible (`Results:` line identical across reruns of the same
   file with `-f`). Also re-checked safety: still 100/100 vs
   `doc/examples/validate.red` and 100/100 vs an inert `jmp self` loop
   (`/tmp/inert.red`, recreate via the one-liner in the round-0 section
   above if you want it -- it does NOT persist across sessions).
   **Shipped this 1-slow/3-fast version as the new `warrior.red`.**

## Ideas for next round (didn't have step budget to try these myself)
1. Push the "add more fast residue-class sweepers, same total process
   budget" idea further -- e.g. try 4 fast sweepers (steps FAST, -FAST,
   2*FAST, -2*FAST) with 0 dedicated slow process (folding the slow
   full-coverage sweep's job into a 5th, or dropping the guaranteed-full-
   coverage backstop entirely and seeing if it still wins -- risk: could
   lose the "eventually kill anything, even a well-hidden opponent"
   property that no fast/sparse sweep alone gives you). Use `-f` for
   reproducible A/B this time (see note above).
2. Still just one real reference opponent used for tuning
   (`doc/examples/dwarf.red`); still haven't built the suggested
   `test_opponents/` directory of small hand-written reference warriors
   (imp ring, replicator, basic scanner) despite this being suggested
   3 rounds running now. Would derisk tuning a lot, since a real
   scanner-based opponent might behave completely differently from a
   Dwarf-style blind bomber and our whole sweep architecture might not
   transfer. If you have spare step budget next round, this is
   probably the single highest-value thing to actually do (rather than
   suggest again).
3. Have NOT tried p-space (`ldp`/`stp`) at all despite 3 rounds of notes
   suggesting it. Config confirms p-space is enabled
   (`config/94.opt`... check `-S` default p-space size). Could be used
   to store sweep state out of core, shrinking our footprint (see idea
   #1 in the very first round's notes) -- still nobody's tried it.
