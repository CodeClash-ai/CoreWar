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

# Round 4 update (sonnet-5, this session)

## Context
- This session only had `/logs/rounds/0` available, but it's genuinely
  informative this time: `results.json` shows the real opponent is
  named "dwarf" and the score was sonnet-5 2427 vs dwarf 1573 (~60.7%
  share), and `trace.md` confirms the opponent literally IS
  `doc/examples/dwarf.red` (41 wins / 100, avg peak procs 1.0 -- classic
  single-process dwarf signature) matching this repo's long-standing
  Dwarf-matchup tuning target. So all the previous rounds' "vs
  dwarf.red" tuning work was directly on-target, not just a proxy.

## What I did
Re-ran the FHALF grid search (the fast-sweep reset-interval constant)
for the current 1-slow+3-fast shape -- flagged as not-yet-done in
round-3's notes. Using `pmars -f` for reproducible A/B (1000-5000 rounds
each vs `doc/examples/dwarf.red`):
- FHALF=996 (previous, from round-2 tuning of an older 1-slow+2-fast
  shape): ~58.8% (2938/5000 in the largest trial run this session).
- Grid over 250/500/750/996/1500/2000/2500/3000/4000/5000/6000/8000:
  best found was **FHALF=2000, ~59.8%** (2992/5000), consistently ~1-2
  points ahead of 996 across repeated trials at different sample sizes
  (1000, 2000, 3000, 5000 rounds all agreed on the ranking). Values much
  above/below 2000 (e.g. 250, 750) were clearly worse; values from
  1500-6000 were all roughly tied/noisy but 2000 was consistently on
  top or near-top.
  **Changed `FHALF` from 996 to 2000 in `warrior.red`.**
- Re-verified FAST=16 is still the best step size for this shape with
  the new FHALF=2000 (grid over 8/10/16/20/25/32, 1500 rounds each): 16
  wins clearly (890/1500 = 59.3%), consistent with all prior rounds'
  findings -- no change needed here, just confirmed still valid.
- Re-tried two structural variants suggested in round-3's "ideas for
  next round" list (both had already been *suggested* but not actually
  tried before this session):
  1. **4 fast sweepers (steps FAST, -FAST, 2*FAST, -2*FAST), 0 dedicated
     slow backstop.** Result: bad. Only 41.2%/1000 vs dwarf (worse than
     the 1-slow+3-fast baseline's ~59%), AND unsafe/inefficient vs a
     totally passive opponent (only 7/50 wins, 43/50 *ties* vs an inert
     `jmp self` loop within the 80000-cycle limit, because there's no
     guaranteed-full-coverage process left to eventually finish off a
     target that never gets hit by the sparse fast residue classes).
     **Do not retry this shape** -- the guaranteed-coverage slow sweep
     is load-bearing, not just a "backstop that rarely matters."
  2. **1 slow + 4 fast (added a 4th sweeper at -2*FAST to the existing
     3-fast baseline, 5 total processes).** Result: also worse, 53.9%
     vs dwarf (1000 rounds) -- confirms the round-1-session's earlier
     general finding that adding *more* processes past the current
     4-total (1 main-slow + 3 spl'd-fast) shape dilutes the shared
     cycle budget faster than the extra coverage helps, for this
     opponent. **Do not retry adding a 4th/5th process to this shape
     either** without a genuinely different idea (e.g. making one of
     the existing processes cheaper per iteration, not adding more).
- Final shipped change this round: **only the FHALF 996->2000 tuning**,
  a single-constant change, verified: assembles cleanly, 100/100 (50/50
  in this session) safe vs inert-loop, 100/100 (50/50) safe vs
  `doc/examples/validate.red`, and 1173/2000 (58.7%) vs
  `doc/examples/dwarf.red` in a final fresh 2000-round check after
  editing the file (matches the grid-search trend, small but real and
  reproducible improvement over the old 996 baseline).

## Ideas for next round (didn't have step budget to try these myself)
1. Our win rate vs classic Dwarf has now plateaued around 58-60% across
   several rounds of constant-tuning (FAST, FHALF, process count/shape
   all separately grid-searched at this point with diminishing returns
   each time). Further meaningful gains almost certainly require a
   *structural* change, not another constant tweak. The two biggest
   untried ideas, still standing after 4 rounds of notes suggesting
   them:
   (a) A real scanner (read-before-bomb, e.g. `seq`/`cmp` against a
   known-blank template) to detect the opponent's actual code location
   *before* committing cycles to bombing it, instead of blind carpet
   sweeps -- this is the standard scanner+bomber CoreWar architecture
   and generally beats simple bombers by a wide margin, not just ~59%.
   (b) p-space (`ldp`/`stp`) usage, confirmed enabled by `config/94.opt`
   -- could store sweep counters/state in p-space instead of core `dat`
   cells, shrinking our in-core footprint (currently 40 instructions vs
   Dwarf's 4) and making us a smaller target.
   Both are bigger, riskier rewrites than anything tried in rounds 1-4
   so far (all of which were safe, incremental, well-tested constant/
   shape tweaks on top of the same core "TwinSweep" design) -- worth
   attempting in a round with a fuller step budget, prototyping in
   `/tmp` first and A/B testing with `pmars -f` before replacing
   `warrior.red`, exactly as done every round so far.
2. Still no `test_opponents/` directory of hand-written reference
   warriors beyond the one that ships with pmars
   (`doc/examples/dwarf.red`, `validate.red`) -- suggested every round
   since round 1, still not done. If the real opponent ever switches
   strategies (e.g. becomes a scanner instead of a dwarf clone), our
   whole multi-round tuning history here would need to be re-validated
   against a different reference, and having a small local zoo of
   opponents (imp ring, one-shot bomber, basic scanner) would make that
   much faster to check.

# Round 2 update (sonnet-5, this session, actual real-round numbering)

## Context
- Real match logs available this session: `/logs/rounds/0` and
  `/logs/rounds/1` only (despite this repo's README history having
  several earlier "Round N" sections from prior sessions with higher
  N -- those numbers do NOT correspond to real game rounds played;
  ignore the numbering, just read chronologically). Both real rounds:
  opponent named **"dwarf"**, and both matched `doc/examples/dwarf.red`
  behavior per earlier sessions' trace analysis. Scores: round 0
  sonnet-5 2427 vs dwarf 1573 (~60.7%), round 1 sonnet-5 2354 vs dwarf
  1646 (~58.9%). So the real opponent has been a stable, known
  quantity (classic Dwarf) for both real rounds so far -- makes
  Dwarf-matchup tuning a trustworthy proxy, unlike earlier sessions
  that had to guess.

## What I did
No pmars rebuild needed (`src/pmars` prebuilt, still works). No
`python3` in this environment (only `perl`/`awk`/`bash`) -- if you want
a variant generator script, write it in bash (see below) or perl, not
python.

Picked up the standing "Ideas for next round" item about re-grid-
searching constants that hadn't been revisited in a while, specifically
the **THIRD fast-sweeper's step size/sign** (the 3rd of 3 "fast"
residue-class sweepers alongside the always-present +FAST/-FAST pair;
had been hardcoded to `+2*FAST` = +32 since introduced, never tuned
independently). Used `pmars -f` throughout for reproducible A/B (see
prior session's note on why this matters -- confirmed still true, and
still the right way to test here).

Wrote a bash variant-generator (saved as `/tmp/gen_variant.sh` this
session -- does NOT persist, recreate from the heredoc pattern below if
you want it) that takes `(FAST, THIRD, FHALF)` and emits a full
`warrior.red`-shaped file, so grid searches are one-liners:
```bash
source /tmp/gen_variant.sh   # defines gen_variant() function
gen_variant 16 -25 3000 /tmp/candidate.red
./src/pmars -@ config/94.opt -f -r 8000 -b /tmp/candidate.red doc/examples/dwarf.red
```
(Recreate `/tmp/gen_variant.sh` from git history of this commit's
`warrior.red` structure if it's gone -- it's just the current
warrior.red's body with `$fast`/`$third`/`$fhalf` shell variables
spliced into the FAST/THIRD/FHALF equ lines.)

Grid-searched THIRD over divisors of 8000 (required for safety, see
many earlier rounds' notes -- confirmed again this session: THIRD=8
caused 112 ties out of 3000 rounds even vs Dwarf, i.e. non-negligible
self-inflicted stalemates; **always check `-r 3000+ -f` includes 0
ties before trusting a THIRD/FAST value**), both signs, magnitudes
8..200:
- Old baseline (THIRD=+32): 59.2-59.4% vs dwarf.red (consistent across
  3000/5000/20000-round trials).
- **THIRD=-25 (opposite sign AND different magnitude from the old
  +32): 60.7-61.8% vs dwarf.red**, consistently ~2 points better than
  the old baseline across every sample size tried (3000, 6000, 8000,
  10000, 15000, 20000 rounds, all with `-f` so exactly reproducible).
  This was the single best value found in a fairly wide sweep (tried
  -8,-20,-25,-32,-40,-50,-64,-80,-100,-125,-160,-200 and their positive
  counterparts) -- negative signs were consistently better than their
  positive-magnitude counterparts in every pair tested (e.g. -25 beat
  +25 by ~4 points, -40 beat +40 by ~2 points), which I don't have a
  first-principles explanation for (the sweep should be symmetric by
  construction; my best guess is it's an interaction with `pmars`'s
  RNG/placement-order details under a fixed `-f` seed sequence rather
  than a "real" direction preference -- **if you have spare budget,
  worth double-checking this holds under a different/newer `-f` seed
  or with plain non-fixed `-r` averaged over many repeated runs**,
  since all my numbers this session came from the same seed sequence).
- Re-confirmed FAST=16 still optimal with THIRD=-25 (grid over
  10/16/20/32, 8000 rounds each: 16 wins clearly, 60.7% vs 49-54% for
  the others).
- Lightly re-checked FHALF (reset interval) with THIRD=-25, FAST=16:
  1000/1500/2000/2500/3000/4000, 8000 rounds each -- all clustered
  60.4-61.8%, quite flat/noisy, but 3000 was on top in both an 8000-
  round and a follow-up 15000-round confirmation (61.8% vs 2000's
  61.4%). Small, low-confidence gain; shipped anyway since it's free
  (single-constant change, no downside found).

**Shipped**: `warrior.red` now has `THIRD equ -25` (was `+32` via
`2*FAST`) and `FHALF equ 3000` (was `2000`), everything else unchanged
from the previous session's structure (1 slow full-core backstop + 3
fast residue-class sweepers, 4 total processes -- this shape itself was
re-validated as the local optimum by 2+ earlier sessions' process-
count experiments, not re-tried this session; see round-3/4 sections
above for that data if you want to revisit it).

Final verification of the shipped file (not just the /tmp candidate):
- `./src/pmars -@ config/94.opt -A warrior.red` -- assembles cleanly
  (1 pre-existing `;assert` warning, harmless, present since round 1).
- 300/300 vs an inert `jmp start` loop (recreate via the one-liner in
  the round-0 section above -- still doesn't persist across sessions).
- 300/300 vs `doc/examples/validate.red`.
- 3072/5000 (61.4%) vs `doc/examples/dwarf.red` with `-f`, matching the
  /tmp candidate's numbers exactly (confirms the copy into warrior.red
  didn't introduce any transcription bugs).

## Ideas for next round
1. **Sanity-check the sign asymmetry finding (THIRD negative beating
   positive) isn't a fixed-seed artifact.** I only tested with `pmars
   -f`, which fixes the RNG seed sequence identically across runs (great
   for A/B reproducibility, but if the asymmetry itself is a seed
   artifact rather than a real effect, it might not hold in the actual
   scored match, which almost certainly does NOT use a fixed seed).
   Quick check: run the same THIRD=+25 vs THIRD=-25 comparison several
   times *without* `-f` (plain `-r 5000`, repeated 3-5 times) and see if
   -25 still comes out ahead on average, not just under one fixed seed
   sequence. If it doesn't hold up, the THIRD=-25 change may need
   reverting or re-deriving less naively.
2. Same standing ideas from every prior session, still untried:
   (a) real scanner (read-before-bomb) architecture instead of blind
   carpet sweeps, (b) p-space (`ldp`/`stp`) usage to shrink our in-core
   footprint, (c) a `test_opponents/` directory of hand-written
   reference warriors beyond `dwarf.red`/`validate.red` so tuning isn't
   100% reliant on one reference opponent matching the real one by
   luck (it has, for 2 rounds running, but that's not guaranteed to
   continue). All three are bigger/riskier rewrites that still haven't
   found a session with enough spare budget to prototype safely -- next
   session, if you have >15 steps free after routine verification,
   consider spending them here instead of another constant-tuning
   pass, since constant-tuning gains have shrunk to ~1-2 points per
   session for a while now (this session: +2 points; round before:
   +1-2 points; the one before that: also +1-2 points -- clearly
   diminishing returns on this axis specifically).
3. `python3` is NOT available in this environment (checked this
   session) -- only `perl`/`awk`/`bash`. Don't waste a step trying it;
   use bash heredocs (see `/tmp/gen_variant.sh` pattern above) or perl
   for any future generator/analysis scripts.

# Round "1" update (sonnet-5, this session -- real game round numbering)

## Context
Only `/logs/rounds/0` was available this session. Real result:
`results.json` shows **winner sonnet-5**, score **sonnet-5 3783 vs
smoothnoodlemap 194** -- a big, clean win. `trace.md` (100 traced
battles): sonnet-5 won **97/100**, 0 ties, lost only 3 (sims 0, 16, 79).
Opponent name is **"smoothnoodlemap"** (NOT "dwarf"/"validate" like
prior sessions' logs suggested for earlier rounds -- this is a
different, real opponent). Confirmed via `starts` field in the raw
`sim_*.jsonl` traces that the opponent's assembled warrior is **86
instructions** (much bigger than any of our tuning reference opponents
`dwarf.red`(4)/`validate.red`/`imp.red`(1) -- so it's presumably a
real, nontrivial bot, not a simple demo), while ours is 39 instructions
(matches `warrior.red`'s current TwinSweep build). Despite being a
much bigger, presumably more sophisticated program, it still loses to
our blind-carpet-bomber sweep 97% of the time.

The 3 losses (sims 0/16/79) all happened relatively early (t=7350,
similar range for the others) and all at opponent starting distances
fairly close to us (opponent loaded at offset 7247/6329/4227 vs our
offset 0 -- i.e. within roughly half the core or less). Did not have
step budget this session to fully decode the jsonl per-cycle trace
format (it's produced by the outer game harness, not by anything in
`src/*.c` in this repo -- grepped, not found, so don't waste a step
looking for a "spec" for it locally) to root-cause exactly how those 3
losses happened; flagging as an open item below rather than guessing.

## What I did this session
Given the very strong existing result (already winning ~97%), treated
this as a "verify + document + light regression-proof" session rather
than a risky rewrite, per the standing advice in these notes ("if
you're already winning, more testing/documentation may be higher value
than more tuning"):

1. Re-verified the current shipped `warrior.red` (TwinSweep, 1 slow +
   3 fast sweepers, FAST=16/THIRD=-25/FHALF=3000, unchanged from last
   session) still assembles cleanly and is still safe/strong against
   every local reference opponent, using `pmars -f` for reproducibility:
   - vs `doc/examples/dwarf.red`: 313/500 (62.6%) -- consistent with
     (slightly above) the ~61.4% found in prior sessions' larger-n grid
     searches; no regression.
   - vs `doc/examples/validate.red`: 200/200, 0 losses/ties.
   - vs an inert `jmp self` loop (recreated at `/tmp/inert.red`, does
     NOT persist -- recreate via the one-liner if you need it again):
     200/200, 0 losses/ties.
   - vs a newly-added `test_opponents/imp.red` (see below): 70 wins /
     0 losses / 130 ties out of 200. **Never loses to Imp, but ties a
     lot** -- expected and OK, not a regression: a lone imp just keeps
     relocating itself every cycle forever and there's no in-repo
     "detect and permanently pin down a mover" logic yet (see hills.md
     scoring: draw is worth 1/3 of a win, so this is still much better
     than losing, just not as good as a clean kill).
2. **Finally created `test_opponents/` (suggested unactioned for 5+
   prior sessions' notes)**, currently containing `imp.red`: a classic
   single-instruction self-copying "imp" (`mov.i 0,1` loop). This is a
   qualitatively different opponent shape from `dwarf.red` (moves every
   cycle instead of sitting still bombing) and is a good cheap sanity
   check for "does our sweep design cope with a *moving* target, not
   just a static bomber" -- recommend keeping this file and adding to
   it (a simple scanner, a small replicator) in future sessions if you
   have spare budget; it's cheap insurance for future tuning sessions.
3. Confirmed (via `hills.md`) the actual meta-scoring formula used to
   turn win/draw/loss rates into a score, since no prior session's
   notes had pinned this down explicitly: **`Score = Win% * 3 + Draw%`**
   (matches pmars's own per-match `-r N` "scores" output exactly, e.g.
   the imp test above: 70 wins*3 + 130 draws*1 = 340, matching the
   printed "TwinSweep... scores 340"). Useful for future tuning:
   **draws are worth 1/3 of a win, and losses are worth 0** -- so if a
   future change trades some wins for draws (e.g. a "safer" but less
   aggressive strategy), do the arithmetic explicitly rather than just
   eyeballing win-rate %, since Score = 3W+D is not the same ranking as
   raw win-rate once draws are involved.

## Ideas for next round
1. **Root-cause the 3 real losses from `/logs/rounds/0`** (sims 0, 16,
   79) properly if a future session has a jsonl-trace-decoding tool
   (or just more patience) -- would be the highest-value next step
   since we now have concrete real-opponent loss examples to learn
   from, unlike most prior sessions which only had synthetic `dwarf.red`
   data. All 3 losses happened early (~t=7350 in sim_0) with the
   opponent starting relatively close to us (within ~half the core) --
   consistent with the standing hypothesis (multiple prior sessions'
   notes) that our large contiguous 39-cell footprint at a fixed
   position is vulnerable to being found and bombed quickly by a
   nearby, competent opponent before our own sweeps reach them. Still
   nobody has tried the "shrink our footprint" or "add a scanner"
   ideas suggested every session since round 1 of this repo's history
   -- given we now have real evidence (not just Dwarf-matchup
   extrapolation) that early/close losses are the actual failure mode,
   this is probably worth prioritizing over more constant-tuning.
2. Opponent this session ("smoothnoodlemap") was a real, 86-instruction
   bot, unlike some earlier sessions' logs (which per older notes in
   this file were sometimes literally `doc/examples/validate.red`/
   `dwarf.red` demos) -- so the opponent identity/behavior can change
   between rounds. Don't assume next round's opponent behaves like this
   round's; re-check `/logs/rounds/<latest>/trace.md` and
   `results.json` fresh each session before trusting old assumptions.
3. Continue building out `test_opponents/` (only `imp.red` so far) --
   a simple one-shot scanner/bomber and a small replicator would round
   out coverage of the main CoreWar archetypes (mover, bomber,
   scanner, replicator) for regression testing.
4. No changes were made to `warrior.red` itself this session (only
   `test_opponents/imp.red` added + this note) -- the existing
   TwinSweep design/constants are unchanged and already verified safe.
   If you pick up idea #1 above, prototype in `/tmp` and A/B against
   `doc/examples/dwarf.red` + `test_opponents/imp.red` + the real
   `/logs/rounds/<latest>` trace data (if by then there's more than
   one real round of data to compare against) before replacing
   `warrior.red`, per this repo's established (and so far
   successful -- 2 real rounds won cleanly) practice.
