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

# Round 2 update (sonnet-5, this session -- real game round numbering, 2nd real session)

## Context
Only `/logs/rounds/0` and `/logs/rounds/1` available (both real, both won
big: sonnet-5 3783/194 and 3779/187 vs opponent "smoothnoodlemap").
`trace.md` for round 1: 95/100 wins, 0 ties, opponent peak procs always
1.0 (never grows) -- i.e. **the real opponent behaves exactly like a
classic single-process dwarf** (matches `doc/examples/dwarf.red`'s
signature precisely, as several earlier sessions' notes assumed/hoped).
The 5 real losses (sims 9, 26, 27, 49, 61) all had the opponent starting
relatively close to us (offsets 937/1925/3155/3485/6717 out of core
8000) -- I confirmed with `pmars -F <offset>` that our win rate at those
*exact* offsets vs `doc/examples/dwarf.red` was noticeably lower
(~55-68%) than the overall ~61% average, i.e. **close-range starts are
a real, reproducible weak point**, not a fluke of those 5 samples.

## What I did
Used `pmars -F <offset>` (fixed opponent start position) for the first
time in this repo's history to directly test the close-range weak point
found above, in addition to the usual `-f` (fixed RNG series) for
general A/B. Wrote reusable bash generator functions (see
`/tmp/gen.sh`/`/tmp/gen2.sh` patterns in git history of this commit if
you want to recreate them -- do NOT persist across sessions, same as
every prior session's /tmp files).

Grid-searched the THIRD fast-sweeper's step size again (last tuned 2
sessions ago, shipped as -25) over a much wider range including small
magnitudes that hadn't been tried before (previous sessions only tried
magnitude >=8). **Found THIRD=-4 is a dramatic, reproducible
improvement over -25**:
- `pmars -f -r 10000` vs dwarf.red: THIRD=-4 -> 7028/10000 (70.3%) vs
  THIRD=-25 -> ~6135/10000 (61.4%, matches prior session's number).
- No-seed reruns (3x `-r 3000`): consistently 68-71% for -4 vs ~61% for
  -25.
- At the 5 close-range offsets from the real losses: -4 wins 70-75%
  each (300 rounds/offset) vs -25's ~55-68% -- **directly addresses the
  diagnosed weak point**, not just general dwarf-matchup average.

**Important safety discovery** (resolves an open question flagged 2
sessions ago about a "sign asymmetry" that a previous agent suspected
might be a `pmars -f` RNG artifact -- it is NOT an artifact, it's a real
bug class): THIRD=+4 (positive, same magnitude as the new shipped -4)
is a **severe self-destruct bug**: loses 0/100 even against a totally
passive inert `jmp self` loop (confirmed via `-T` trace: our own
process dies almost immediately at an address inside our own
instruction block). THIRD=+2 also broken (8/5000 vs dwarf -- deceptive,
looks like "just a bad tuning value" from dwarf-matchup numbers alone,
but the inert-loop check reveals it's actually self-destructing and
occasionally out-surviving dwarf by luck, not a real win rate).
**Lesson for future sessions: a dwarf-matchup win rate alone is NOT
sufficient to validate a new step-size/sign combination -- always also
check 100+ rounds vs a passive/inert opponent (0 losses expected) before
trusting any dwarf-matchup number for it.** The now-shipped THIRD=-4
passes this check cleanly: 50/50 across 10 systematically-spaced fixed
offsets (100 through 7900, 500 total rounds) vs the inert loop, plus
300/300 vs `doc/examples/validate.red`.

Also tried (both proved worse, did NOT ship):
1. Making the existing `fast_b` sweeper step a distinct divisor instead
   of mirroring `-FAST` exactly (tried 4,5,8,10,20,25,32,40 as its own
   independent `BSTEP` constant) -- every value tried was worse than
   just leaving it as `-FAST`. Counter to my initial hypothesis (more
   distinct residue classes should help); empirically, mirroring
   FAST's magnitude from the opposite direction is better than any
   alternative tried. Not fully understood why, flagging as an
   open question rather than a settled explanation.
2. Adding a 4th spl'd fast sweeper (mirroring THIRD with a `+THIRD`
   sweep, 5 total processes) -- worse across the board (~51% vs dwarf,
   worse at every close-range offset too), consistent with multiple
   earlier sessions' findings that 4 total processes (1 slow + 3 fast)
   is a local optimum and a 5th dilutes the shared cycle budget faster
   than it helps.
3. Re-confirmed FAST=16 and FHALF=3000 are still locally optimal with
   the new THIRD=-4 (small grids re-run, no change from prior
   sessions' values).

**Shipped**: `warrior.red` now has `THIRD equ -4` (was `-25`), a single
constant change, but with much more thorough validation than most prior
sessions' constant tweaks (added the close-range `-F` offset checks and
the inert-loop self-destruct check specifically because this session
found evidence those matter more than previously realized). Everything
else (FAST=16, FHALF=3000, HALF=7960, the 1-slow+3-fast/4-process
shape) is unchanged from the previous session.

Final verification of the shipped file:
- Assembles cleanly (`-@ config/94.opt -A warrior.red`).
- 300/300 vs inert loop, 300/300 vs `doc/examples/validate.red`.
- 86/300 wins + 214 ties + 0 losses vs `test_opponents/imp.red`
  (matches prior sessions' numbers almost exactly -- no regression on
  this opponent type).
- vs `doc/examples/dwarf.red`: 2107/3000 (70.2%) with no fixed seed,
  reproduced identically across 2 reruns; 7028/10000 (70.3%) with
  `-f` -- both far above the previous session's ~61%.

## Ideas for next round
1. **Understand *why* THIRD=-4 beats -25 so much, and why mirroring
   FAST exactly beats every distinct-divisor alternative for fast_b**
   -- both findings this session were purely empirical (grid search),
   not derived from first principles. A clearer mechanistic model of
   *why* certain (step, sign, phase) combinations dominate might let
   future sessions search more efficiently than blind grid search, and
   might reveal an even better value that a linear/divisor grid search
   would miss (e.g. some interaction between step size and the fixed
   40-cell size of our own instruction block, or with dwarf.red's
   specific step-4/4-cell-footprint shape that wouldn't generalize to
   a *different* real opponent shape).
2. Now that `pmars -F <offset>` (fixed opponent position) is confirmed
   useful for directly testing specific failure modes found in real
   match traces (used for the first time this session), future
   sessions should use it whenever `/logs/rounds/<latest>/trace.md`
   shows real losses with recorded opponent start offsets -- much more
   targeted than only ever tuning against dwarf.red's *average*
   performance, which is what every session before this one did
   exclusively.
3. Still standing from every prior session: no real scanner
   (read-before-bomb) architecture, no p-space usage, and
   `test_opponents/` still only has `imp.red`. All still bigger/riskier
   rewrites than this session's tuning changes. Given how much
   headroom the THIRD constant alone still had (61%->70% from a single
   value change, after 4+ prior sessions of "diminishing returns"
   constant-tuning notes!), it's worth a skeptical re-grid-search of
   *every* existing constant with wider ranges before assuming
   constant-tuning is really exhausted -- this session's result
   suggests earlier sessions' grid searches may have had blind spots
   (e.g. nobody tried THIRD magnitudes below 8 before this session).
4. `/tmp/gen.sh` (single BSTEP-parameterized variant generator) and
   `/tmp/gen2.sh` (5-process variant generator) used this session do
   NOT persist -- recreate from this file's description or from
   `git show` on this commit's diff if you want them again.

# Round update (sonnet-5, this session -- real game round numbering, fresh session)

## Context
Only `/logs/rounds/0` available this session. Real result: **winner
sonnet-5**, score **sonnet-5 2577 vs smoothnoodlemap6 524** (~83% share
by score). `trace.md` (100 traced battles): sonnet-5 won 61, opponent
won 18, **21 ties** (ties happen when neither side is eliminated by the
80000-cycle limit -- confirmed by checking raw `sim_*.jsonl`: tied
battles run the full `t` up to ~159000-160000, i.e. pmars's half-cycle
counter hitting `2*cycles`).

Key new data point vs all prior sessions' opponents ("dwarf",
"validate", "smoothnoodlemap" round 0/1 which behaved like classic
single-process Dwarf): **this round's opponent ("smoothnoodlemap6") is
a much bigger, higher-process warrior** -- `trace.md` summary line:
avg peak procs **62.2** (vs our own steady 4.0), avg core owned only
6.4% (vs our 38.2%), eliminated 61/100 times (vs us being eliminated
18/100 times). So the opponent is some kind of wide replicator/spawner
that fills lots of processes but doesn't hold much core, quite unlike
the `dwarf.red`-shaped opponents all previous tuning sessions optimized
against. Despite the mismatch with our tuning reference, we still won
solidly (61 vs 18, plus 21 ties) -- our blind carpet-sweep design
apparently generalizes reasonably well to this opponent shape too, it's
just not as lopsided a win as the ~70% we get vs `dwarf.red` locally.

## What I did this session
1. Re-verified `warrior.red` (unchanged from last session: FAST=16,
   THIRD=-4, FHALF=3000, HALF=7960, 1-slow+3-fast/4-process shape) is
   still safe and performing as documented -- no regression:
   - Assembles cleanly.
   - `-f -r 3000` vs `doc/examples/dwarf.red`: 2118/3000 = 70.6% (0
     ties) -- matches prior session's ~70% exactly.
   - `-f -r 300` vs `doc/examples/validate.red`: 300/0/0.
   - `-f -r 300` vs `test_opponents/imp.red`: 101 wins / 0 losses / 199
     ties -- matches prior sessions' numbers (imp.red is a single mover
     that our sweep never manages to definitively finish off within the
     cycle limit if it keeps relocating, but we never lose to it
     either).
2. **Added `test_opponents/swarm.red`**: a new *synthetic* high-
   process-count test opponent (repeatedly `spl`s a fresh copy of its
   own bombing loop so process count grows every iteration, each copy
   also bombs forward by a fixed step) -- specifically built this
   session to give future tuning sessions *something* locally testable
   that's closer in shape (many processes, not a single Dwarf-style
   bomber) to what this round's real opponent trace showed, since we
   still don't have the real opponent's source. **Important caveat:
   this is a crude, made-up stand-in, NOT a reconstruction of the real
   opponent's actual strategy** -- I have no visibility into
   smoothnoodlemap6's actual code, only the aggregate trace stats
   (procs/core-owned/elimination counts). Treat any tuning conclusions
   drawn from `swarm.red` with appropriate skepticism; it mainly tests
   "does our design cope with an opponent that spams many processes",
   not much else.
   - Current `warrior.red` beats `swarm.red` cleanly: 500/0/0 (`-f -r
     500`). So our design isn't inherently vulnerable to "opponent has
     way more processes than us" in isolation -- MARS round-robins
     cycles per-warrior (not globally across all processes of both
     sides), so an opponent spawning hundreds of cheap processes mostly
     just starves *their own* per-process throughput, it doesn't steal
     our cycles. This is probably *part* of why we still win the
     majority of real rounds against this bigger/spammier opponent
     despite never having tuned against anything like it before.
3. Did NOT make any change to `warrior.red` itself this session. Given
   (a) the real result is already strongly positive (83% score share),
   (b) many prior sessions' notes describe constant-tuning as heavily
   diminishing-returns by now, and (c) I don't have the real opponent's
   code to safely validate a *targeted* change against (only a
   made-up, unverified `swarm.red` stand-in) -- risk of a real
   regression from a blind tweak this session seemed to outweigh the
   likely small upside. Prioritized leaving a clean, verified baseline
   plus a slightly better testing tool for whoever tunes next, per the
   "if winning, more testing/documentation may be higher value than
   more tuning" guidance.

## Ideas for next round
1. **Investigate the 21 ties specifically** (higher priority than
   general dwarf-matchup tuning at this point, since dwarf-matchup
   constant tuning has been flat for 3+ sessions and ties are worth
   only 1/3 of a win in the scoring formula `Score = Win%*3 + Draw%`,
   so converting even a few ties to wins is worth more than a small
   win-rate bump elsewhere). Ties = both warriors survive the full
   80000-cycle limit. Look at whether our slow full-core sweep (step 1,
   HALF=7960, one full lap ~7960 iterations *if it never gets its
   pointer cell clobbered*) is simply too slow to ever reach a
   thinly-spread, constantly-relocating swarm-type opponent within
   80000 cycles -- if so, a faster guaranteed-coverage backstop (bigger
   step with a coverage-completing residue-class rotation, or several
   parallel slow sweeps each covering a fraction of core) might convert
   some ties into wins without the process-count downsides earlier
   sessions found from just adding more *fast* sweepers.
2. `test_opponents/swarm.red` (this session) is a rough, made-up
   stand-in, not real opponent code -- if a future session gets a
   `trace.md` with more real ties/losses and recorded start offsets
   (like round-1-session-2's `-F <offset>` methodology, see much
   earlier notes above), prefer debugging directly against those real
   recorded offsets/behavior over further tuning against synthetic
   opponents.
3. Standing ideas from every prior session, still untried: real
   scanner (read-before-bomb) architecture; p-space (`ldp`/`stp`) to
   shrink our in-core footprint. Both bigger rewrites that still
   haven't found a session willing to risk the safe, working baseline
   -- now 3+ real rounds of clean wins in a row (scores/results in
   `/logs/rounds/*/results.json` if more accumulate) suggests the
   current design is solid; any structural rewrite should be prototyped
   and A/B'd very thoroughly (vs `dwarf.red` AND `swarm.red` AND
   `imp.red` AND `validate.red`, all in `test_opponents/`+`doc/examples/`)
   before replacing the shipped `warrior.red`, given how much safe value
   is already banked.

# Round update (sonnet-5, this session -- real trace root-cause + swarm2.red)

## Context
Real logs available: `/logs/rounds/0` and `/logs/rounds/1`, both vs
opponent **smoothnoodlemap6**, both clean wins by score: round0
sonnet-5 2577 vs 524, round1 sonnet-5 2567 vs 517 (~83% score share
both times). `trace.md`/round1: 64 wins / 11 losses / 25 ties (100
traces), opponent avg peak procs 63.4 (a wide spl-replicator), avg core
owned only 7.7%, eliminated 64/100. `warrior.red` is UNCHANGED this
session (see "What I did" below for why) -- still the same
1-slow-sweep + 3-fast-sweep ("TwinSweep") design from prior sessions
(HALF=7960, FAST=16, THIRD=-4, FHALF=3000), still verified safe/strong.

## What I did
1. **First real root-cause analysis of actual losses**, using the raw
   `/logs/rounds/1/sim_*.jsonl` per-cycle traces directly (nobody had
   done this before -- every prior session's notes only used the
   aggregate `trace.md` summary or synthetic `dwarf.red`/`imp.red`
   proxies). Format per line: `{"t":<cycle>,"c":[[addr,owner],...],
   "p":[ip0,ip1],"n":[nprocs0,nprocs1],"d":[alive0,alive1]}` --
   `p` is each warrior's *currently executing instruction address*
   (not a data pointer!), `n` is live process count, `d` is final
   alive/dead flags (only meaningful on last line before the
   `{"winner":...}` line). `c` looks like a rolling window/history of
   recently-touched core cells, not a literal process list -- didn't
   fully pin down its exact semantics, but wasn't needed for the
   analysis below.
2. Grepped `p` at the second-to-last line of every one of the 11 real
   losses. **9 of 11** showed the *opponent's* final IP sitting at a
   near-constant address **7686-7690** regardless of where we (warrior
   1) started (2515, 6468, 5465, 6267, 5076, 7662, 4680, 7124, ...) --
   i.e. opponent loaded at offset 0, and this is offset **-310 to
   -314** relative to their own start (just outside/before their own
   ~100-instruction code block). Meanwhile *our* final IP in those
   same losses always sat close to *our own* start offset (e.g. our
   start 5076 -> final IP 5095; our start 6267 -> final IP 6286, etc.)
   -- i.e. **our own main slow-sweep loop, still near where it started,
   barely having made any progress into the core.**
   **Interpretation**: the opponent is a replicator that spawns ~60
   processes early (confirmed by `n` in the traces, matches trace.md's
   62.2 avg peak procs), most of which die off in the ensuing chaos,
   but it appears to keep (or end up with) one process sitting in a
   defensive/stable loop just outside its own code -- a "guard" -- that
   in these 11 loss cases is the one still alive at the end, while
   *our* last-standing process (usually our un-spl'd main slow sweep,
   since our 3 `spl`'d fast sweepers die off earlier in the chaos) gets
   killed near its own home loop, evidently by early scattered bombing
   from the opponent's swarm before it dies off, or by the guard itself
   if within reach. **Net effect: our losses are mostly "our fast
   sweepers get killed in the early chaotic phase, and then it comes
   down to a coinflip-ish race between our un-spl'd slow sweep (which
   hasn't traveled far yet) and their last survivor" rather than "we
   get outright overwhelmed."** This matches losses happening across a
   wide range of `t` (3588 to 33000+) rather than clustering early or
   late.
3. **Built `test_opponents/swarm2.red`**: an improved synthetic stand-in
   based directly on this finding -- same spl-swarm as the older
   `swarm.red`, PLUS a separate one-shot `spl`'d "guard" process that
   sits in a small fixed-range bombing loop near its own start (mimics
   the "guard survives at a near-constant offset" pattern found above).
   **Important**: current `warrior.red` still beats `swarm2.red` 100%
   (2000/2000, `-f`, 0 losses/ties) -- so this synthetic stand-in,
   while structurally closer to the real trace pattern than plain
   `swarm.red`, still doesn't reproduce the actual ~11% loss rate we
   see for real. **It's a starting point, not a validated proxy yet**
   -- treat any tuning conclusion drawn from it with real skepticism,
   same caveat as `swarm.red` before it. A future session with more
   budget could try tuning `swarm2.red`'s guard to be more aggressive/
   better-placed until it actually reproduces a realistic loss rate
   against our current warrior, THEN use it for real A/B tuning.
4. Discovered a pmars CLI quirk while trying to use `-F <offset>` (used
   successfully by an earlier session per older notes above): **`-F`
   and `-f` cannot be combined in this pmars build** -- passing both
   together silently falls through to the usage/help text (no error
   message, just prints help and exits 0). Use ONE or the other:
   `-F <offset>` alone (position fixed, RNG otherwise free) for
   per-offset checks, or `-f` alone (RNG fixed, position free) for
   general reproducible A/B. Also note `-F` wants a *space-separated*
   token (`-F 2515`), not `-F2515` or `-F$2515` (both of those also
   fall through to usage) -- the `-F $` in the `-help` text is just
   describing the argument as a generic string placeholder, not a
   literal `$` you need to type.
5. Given the above, did NOT change `warrior.red` this session --
   `swarm2.red` isn't yet a validated-enough proxy to safely tune
   against (see caveat in #3), and I didn't have enough remaining
   budget this session to also fix that AND validate a real structural
   change. Prioritized landing the root-cause finding + a better (if
   still imperfect) test tool for whoever picks this up next, per the
   standing "if winning, testing/documentation may be high value"
   guidance -- especially valuable this time since it's the *first*
   session across many rounds of notes to actually look at real
   per-cycle loss traces instead of only synthetic dwarf.red proxies.
6. Also tried (documented as a *negative* result, do not retry as-is):
   a "2 slow (opposite directions, half coverage each) + 2 fast" process
   shape (replacing the 3rd fast sweeper with a second slow sweep) to
   see if halving the slow sweep's time-to-reach-far-cells would help
   with the close/attrition-race loss pattern found above. **First
   attempt had a self-destruct bug**: placed the new backward slow
   sweep's pointer cell at the wrong end of the instruction block
   (bottom, when a *backward*-stepping pointer must sit at the very
   TOP of the block per the long-standing front/back convention --
   see round-0 notes) -- caused 243/300 ties/self-kills even vs a
   totally passive inert loop opponent. Fixed the placement (moved it
   to the top, alongside the other backward-stepping pointer), which
   resolved the self-destruct, but the resulting shape still tested
   clearly WORSE than the current shipped 1-slow+3-fast design vs
   `doc/examples/dwarf.red` (1536/3000 = 51.2% vs the current ~70.6%).
   **Do not retry "2 slow + 2 fast" as a replacement for "1 slow + 3
   fast"** -- the 3rd fast residue-class sweeper is carrying real
   weight against dwarf-shaped opponents that a 2nd slow sweep doesn't
   replace. (Generator script used: `/tmp/gen_2slow2fast.sh FAST FHALF
   outfile` -- does not persist, recreate from this note's description
   if wanted; the key gotcha to preserve is the front/back pointer
   placement convention.)

## Ideas for next round
1. **Highest priority**: improve `swarm2.red` (or build a `swarm3.red`)
   until it actually reproduces something closer to the real ~11%
   loss / 25% tie rate against current `warrior.red`, then use it (not
   `dwarf.red`) as the primary tuning target -- since we now have good
   evidence (this session, see "What I did" #2) that the real
   opponent's shape (wide swarm + a lone late-game guard) is quite
   different from `dwarf.red`'s shape (single static bomber), and all
   of this repo's historical constant-tuning (FAST/THIRD/FHALF/process
   count) was done exclusively against `dwarf.red`. It's possible
   there's a different local optimum for the real opponent's shape
   that nobody has looked for yet, BUT don't just blindly re-tune
   against an unvalidated synthetic proxy -- confirm the proxy's loss
   rate against our current warrior is in a similar ballpark to the
   real ~11-25% first, or the tuning conclusions won't transfer.
2. The concrete failure mode found this session ("our 3 spl'd fast
   sweepers die off early in the chaotic swarm phase, then our lone
   un-spl'd slow sweep -- still near its own start -- loses a race/
   coinflip against the opponent's last survivor") suggests two
   possible structural fixes worth prototyping (both untried):
   (a) Make the fast sweepers *harder to kill early* -- e.g. spread
   their home loop code further from each other and from the main
   slow sweep's home loop, instead of all 4 processes' code living in
   one contiguous ~40-cell block, so a lucky early scattershot from
   the swarm's chaotic bombing phase is less likely to clip more than
   one of them at once.
   (b) Give the slow sweep a head start / higher priority early on
   (e.g. reorder so the slow sweep's `add`+`mov` runs before the 3
   `spl`s, or split it into 2 half-coverage sweeps -- NOT the "2 slow +
   2 fast, drop a fast" shape already tried and found worse this
   session, but potentially "1 slow forward (full coverage, unchanged)
   + 3 fast, but ALSO give the main process's very first few iterations
   priority/a bigger initial step" or similar) so that by the time the
   chaotic early phase resolves down to 1-vs-1, our slow sweep has
   already covered more ground instead of still sitting near its own
   start.
3. Standing ideas from every prior session, still untried: real scanner
   (read-before-bomb) architecture; p-space (`ldp`/`stp`) to shrink our
   in-core footprint (which per idea #2(a) above might now matter more
   than previously thought, given the "early clip kills a spl'd
   process" failure mode found this session).
4. Remember `-F` and `-f` cannot be combined in this pmars build (see
   "What I did" #4) -- use one or the other, not both, or you'll
   silently get a no-op (prints usage, exits 0, easy to miss in a
   script that doesn't check the `Results:` line is actually present).

# Round update (sonnet-5, this session -- big loss, new opponent shape)

## Context
`/logs/rounds/0` this session: **we lost badly** -- score sonnet-5 366
vs opponent **"returnofthelivingdead" 3596** (trace.md: only 10/100
wins, 0 ties, 90 times eliminated). This is a NEW, much more dangerous
opponent shape than anything in this repo's tuning history
(dwarf/validate/smoothnoodlemap*): **avg peak procs 2588.3** (vs our
steady 4), avg core owned 23.0% (less than our 32.1%, yet they still
crush us), and *we* get eliminated 90% of the time while *they* are
eliminated only 10% of the time. All prior sessions' tuning (FAST,
THIRD, FHALF, process-count/shape) was done exclusively against
`dwarf.red`-shaped opponents (1 static process) and simply does not
transfer to this shape -- treat all the win-rate numbers earlier in
this file as basically irrelevant to this new opponent until re-
validated against something that actually reproduces its behavior.

## What I found (analysis)
Grepped `n` (process-count) field across `/logs/rounds/0/sim_*.jsonl`
for the real opponent: process count grows **roughly linearly**, about
+1 process every ~4 cycles from t=0 (NOT exponential doubling -- e.g.
t=42 n=7, t=546 n=128 is a straight-ish line, not a curve) -- consistent
with a single "trunk" spawner process that `spl`s off new independent
bomber/mover children (one every ~4-cycle loop iteration) that then
keep running forever (they do NOT die quickly -- if they did, n would
plateau near a small constant, not climb to thousands). Bombed
addresses in the `c` trace field jump by a large, roughly-constant
step each new spawn (~1000ish) -- looks like a coprime-with-8000 step
used either for the trunk's own spawn-target selection, or for each
child's own bombing pattern, or both; didn't have budget to fully pin
down which.

**Working hypothesis** (not fully confirmed, next session should
verify): a single small "trunk" process keeps spawning cheap,
independent, persistent bomber/mover children spread across widely
different regions of the whole core (via a big coprime step), so
within a few thousand cycles a very large fraction of the 8000-cell
core has SOME live enemy process nearby, making it very likely our own
small, static, fixed-position ~39-cell code block gets found and
overwritten before our own (also fairly slow, single-instance) sweeps
finish covering the *whole* core in return. Because their children
don't depend on the trunk once spawned, killing the trunk (even if we
could do it quickly) probably only stops *further* growth, it doesn't
retroactively kill the already-spawned swarm -- so "race to snipe their
one visible process early" (our historical dwarf-tuned strategy) likely
does NOT generalize to this opponent shape the way it did for dwarf.
Consistent with the trace stats: they're rarely fully eliminated (only
10/100) -- reducing a many-hundreds/thousands-process swarm to
literally zero within the cycle limit is intrinsically hard -- while WE
get fully wiped out 90/100 (our whole design lives in one small
contiguous block; once something paints over that block, all 4 of our
processes die around the same time, since they're all executing
different points of the *same* small loop of instructions).

**Practical implication**: given the asymmetry (they're hard to fully
eliminate, we're easy to fully eliminate), the highest-leverage goal
is probably **surviving to avoid being wiped out** (worth a tie, 1/3 of
a win in the `Score = 3*Win% + Draw%` formula -- see much earlier
session's note on this formula) rather than doggedly trying to force a
full elimination win against a huge swarm, which may be intrinsically
very hard to achieve reliably. Concretely: shrinking/hardening/
splitting our own footprint so we don't die as a single unit is likely
higher-value than any more carpet-bomb step-size tuning.

## What I did this session (small, safe, time-boxed)
Given only a partial step budget left after the analysis above, made
ONE low-risk, mechanical, thoroughly-tested change rather than
attempting a risky structural rewrite blind (no validated local proxy
for this new opponent shape existed, see caveats below):

**Shrunk warrior.red's footprint from 39 to 35 instructions** by
removing the 4 separate `*tmpl` "reset template" cells (`ftmpl`,
`htmpl`, `gtmpl`, `ktmpl`) and replacing each `mov <tmpl>,<cnt>` counter
reset with an equivalent immediate `mov.ab #<N>, <cnt>` (same effect,
one fewer cell read, no extra risk). This is a pure size reduction with
identical logic/semantics -- smaller static target, same behavior.
Verified via `pmars -@ config/94.opt -A warrior.red` (assembles
cleanly, same warnings as before) and `pmars -f` regression vs every
local reference opponent, all matching or improving on pre-change
numbers (no regression found):
- vs inert `jmp self` loop (`/tmp/inert.red`, recreate via the
  one-liner in earlier notes if gone): 300/0/0.
- vs `doc/examples/validate.red`: 300/0/0.
- vs `doc/examples/dwarf.red`: 2009/3000 = 67.0% (matches the
  documented ~67-71% range from before the shrink, i.e. not a
  regression, within normal noise).
- vs `test_opponents/imp.red`: 111 wins/0 losses/189 ties (matches
  prior sessions' numbers).
- vs `test_opponents/swarm2.red`: 300/0/0 (unchanged).
- vs `test_opponents/hydra2.red` (new, see below): 300/0/0.

**Added two new synthetic test opponents** (both explicitly documented
as UNVALIDATED, rough stand-ins -- see big caveat below):
- `test_opponents/hydra.red`: single trunk that `spl`s a *one-shot*
  bomber (writes one bomb, then hits its own `dat` and dies) every
  iteration, stepping its spawn-target by a coprime constant (1001).
  Matches the real trace's *step pattern* but NOT its process-count
  growth (children die immediately here, so `n` stays ~flat -- doesn't
  reproduce the real "peak procs 2588" at all). Our current warrior
  beats this 243/50/7 (81%) with `-f -r300` -- i.e. clearly NOT a hard
  enough proxy, don't trust conclusions from it alone.
- `test_opponents/hydra2.red`: single trunk that `spl`s a *persistent*
  small bomber loop (never dies on its own) every ~4-cycle iteration,
  same coprime spawn-step. Closer in spirit to the "sustained growth"
  real trace pattern, but **still has a known bug**: all spawned
  children share the SAME `cptr` memory cell (redcode doesn't give
  each `spl`'d instance of shared code independent variables for
  free -- a REAL replicator has to copy its own code+data to a fresh
  location per child, which this test stub does not do), so children
  likely stomp on each other and it's still much weaker than intended.
  Our current warrior beats this 300/0/0 (100%) -- again, clearly NOT
  reproducing the real opponent's actual danger level.

  **BOTH synthetic opponents are known-inadequate proxies for the real
  "returnofthelivingdead" shape** -- I could not, within this session's
  remaining budget, build something that actually reproduces even a
  fraction of its ~90%-elimination-rate danger against our current
  warrior. **Do not treat "beats hydra.red/hydra2.red 100%" as
  meaningful validation of anything** -- they're useful only as very
  weak regression smoke-tests (confirms no gross new bug), not as a
  tuning target. A real fix (see below) needs either a much better
  proxy (ideally: a true self-relocating replicator with independent
  per-child state, i.e. actually copy code+data to a new address per
  spawn rather than reusing shared cells) or, better, direct empirical
  testing against real match data once more rounds accumulate.

## Ideas for next round (this is now the TOP priority item, above all
## older standing ideas in this file, which were tuned against a
## different and apparently much less dangerous opponent shape)
1. **Build a real self-relocating replicator test opponent** (actually
   `mov`s a full copy of its own code+data block to a freshly
   computed address, then `spl`s a new process there with correctly
   relocated pointers -- i.e. an authentic CoreWar "silk"/replicator,
   not the shared-variable stubs from this session) to get a
   trustworthy local proxy for "returnofthelivingdead"-shaped
   opponents. This is the single highest-leverage next step -- almost
   everything else is guesswork without it.
2. Given the survive-not-eliminate asymmetry argued above, prioritize
   defensive/structural ideas over more carpet-bomb tuning:
   (a) **Split our footprint** into 2+ pieces that end up physically
   apart in core at runtime (note: a warrior's initial load IS one
   contiguous block, so true separation requires our own code to
   actively `mov` a second copy of some critical piece to a distant
   computed address early in the match and `spl` a process there --
   basically a small-scale self-relocation, not just "reorder the
   source file", which does nothing since load layout is contiguous
   regardless of source order).
   (b) A process that periodically re-validates/repairs damaged
   instructions in our own block from a value known to be correct
   (self-repair) -- only helps if *something* survives to do the
   repairing, so probably needs to be combined with (a).
   (c) A genuinely mobile presence (imp-style relocation of at least
   one process) so we're not a pure sitting target.
3. Standing ideas from every prior session, still untried and possibly
   now MORE relevant given this session's findings: real scanner
   (read-before-bomb) to find and snipe the trunk process specifically
   (caveat: per this session's hypothesis, may only stop future growth,
   not retroactively save us from an already-spawned swarm -- test this
   assumption once a better proxy exists); p-space (`ldp`/`stp`) usage.
4. The footprint-shrink shipped this session (39->35 instructions,
   `ftmpl`/`htmpl`/`gtmpl`/`ktmpl` removed) is safe and verified but is
   a SMALL, incremental mitigation, not a fix for the core structural
   problem diagnosed above -- don't mistake it for having addressed
   the big loss. Treat this round's score (366 vs 3596) as the honest
   baseline to beat, and prioritize idea #1/#2 next session if there's
   enough budget; if not, at minimum keep iterating on a validated
   replicator-shaped test proxy so future sessions aren't flying blind
   the way this one was.

# Round update (sonnet-5, this session -- DualSweep: structural fix for real losses)

## Context
Real logs available: `/logs/rounds/0` and `/logs/rounds/1`, BOTH big
losses to opponent **"returnofthelivingdead"**: round0 sonnet-5 366 vs
3596, round1 sonnet-5 644 vs 3334 (trace.md round1: only 19/100 wins, 1
tie, 80 losses; opponent avg peak procs ~2508, us eliminated 80/100).
This is a much more dangerous opponent than any previous round's
(`dwarf`/`validate`/`smoothnoodlemap*`) -- a huge, fast-growing swarm.
Many real losses happened at VERY low cycle counts (e.g. sim losses at
t=671, 1361, 1583, 1872, 2397, 2692, 2720, 2916, 3017, 3144 in round1's
trace) -- i.e. we were getting wiped out almost immediately, well
before our slow full-core sweep (step 1, ~1 cell/2 cycles) could have
traveled far from its start. Every prior session's notes (see history
above) already diagnosed the likely root cause: **our entire warrior
(all 4 processes: 1 slow sweep + 3 fast sweeps) lives in ONE contiguous
~35-cell block at a single fixed core location. If anything finds and
overwrites that block early, ALL our processes die together, at once,
regardless of how many we have.** Nobody had actually implemented a
fix for this despite it being flagged as the top idea for 4+ sessions
running (always deferred as "bigger/riskier, do it when there's more
budget").

## What I did this session
Implemented the fix: **DualSweep** = the exact same proven TwinSweep
logic (1 slow + 3 fast sweepers, FAST=16/THIRD=-4/FHALF=3000/HALF=7960,
all unchanged, still the same well-tested constants from prior
sessions), PLUS a one-time self-relocation step added at the very
front: before doing anything else, the main process copies its ENTIRE
own instruction block (all ~48 cells, via an explicit cell-by-cell
`mov.i @srcp,@dstp` loop using B-indirect addressing through two
pointer cells incremented by 1 each iteration -- same idiom the
existing sweepers already use for bombing, just applied to copy a
whole block instead of one bomb cell) to a second location `HOPLEN`
(=4000, i.e. core/2, chosen for max separation) cells away, `spl`s a
process there landing directly at the post-replication `start` label
(so the copy never re-replicates -- no runaway/exponential growth,
just exactly 2 origins), then jumps to `start` itself too. From then
on, BOTH origins run a fully independent 4-process TwinSweep, so we
have effectively 8 total processes across 2 physically-separated
~48-cell footprints instead of 4 processes in 1 footprint. Goal:
survive an early, localized attack on ONE footprint by having the
other, physically distant, footprint still alive and fighting.

**Correctness approach**: leaned on the fact that redcode's default
addressing mode (`$`, direct) is always a *relative* displacement from
the currently-executing instruction, so a raw, verbatim cell-by-cell
copy of our whole code block to a new address will behave *identically*
at the new address with NO changes needed to any internal jump/branch
target -- this is the same property that makes a single-instruction
`imp` (`mov.i 0,1`) work at any address. Verified this assumption holds
by testing thoroughly (see below) rather than just trusting the theory.

**Known, accepted tradeoff (found and measured, not a surprise bug)**:
the two origins' own fast/slow sweepers don't know about each other and
will eventually (often quite early -- a step-16 fast sweeper reaches
`HOPLEN`=4000 cells away in only ~250 iterations) bomb over the OTHER
origin's code block too ("friendly fire"), since each sweep still
blindly carpet-bombs everything in its path, friend or foe. This
causes a small, measured regression in the pure `dwarf.red` matchup
(~64-65% vs the old design's ~68-69%, no ties either way) and a couple
of extra losses (still <1%) against very degenerate opponents
(`validate.red`: 15/2000 vs 0/2000 old; `imp.red`: 6/2000 vs 0/2000
old) -- **checked and accepted this cost deliberately**, see numbers
below; did not attempt to fix it further this session (e.g. by having
each origin's sweep somehow skip/avoid the other's footprint) since the
net effect across every other benchmark was strongly positive and I
did not have budget left to also risk a more complex mutual-avoidance
mechanism.

**Validation (using `pmars -f` for reproducible A/B throughout,
double-checked key numbers with plain non-fixed `-r` reruns too)**:
- Assembles cleanly (`-@ config/94.opt -A warrior.red`).
- vs inert `jmp self` loop: 500/500 (0 losses) at 300+ round samples,
  including a 2000-round sample -- confirms the replication step
  itself is NOT a self-destruct bug (this was the first and most
  important thing checked, per the standing lesson in this file about
  always checking new step-size/structural changes against a passive
  opponent before trusting any other number).
- vs `doc/examples/dwarf.red`: ~64-65% (`-f -r 1000`: 666/334/0;
  non-seeded `-r 2000` x3: 1301/699, 1281/719, 1290/710) -- a real but
  small regression from the old TwinSweep's ~68-69% (confirmed
  side-by-side same session: old design got 686/314/0 at `-f -r 1000`,
  1357/643 etc. at non-seeded `-r 2000` x3). Attributed to the
  friendly-fire tradeoff above; accepted given the gains elsewhere.
- **vs old `warrior.red` (TwinSweep) directly, head-to-head**: DualSweep
  wins **75.6%** (378/500 `-f`, 0 self-destructs, only 2 ties) --
  strong direct evidence the new design is a real overall improvement
  over the old one, not just noise.
- vs `test_opponents/swarm.red`, `swarm2.red`, `hydra2.red`: 300/300/300
  (100% each), matching or equal to the old design (no regression on
  these).
- **vs `test_opponents/hydra.red` (the "single spawner + coprime-spread
  one-shot bombers" proxy, closest local stand-in to the real trace's
  observed ~4-cycles-per-new-process linear growth rate from
  `returnofthelivingdead`'s round-0 forensic analysis earlier in this
  file): DualSweep wins 94.3% (283/16/1) vs the OLD design's 76.3%
  (229/69/2) on the exact same opponent, same `-f -r 300` settings.**
  This is the most important number this session -- it's a big,
  reproducible improvement specifically against the opponent shape
  that best approximates our actual real-match nemesis, which is
  exactly the failure mode this change targeted. (Still: `hydra.red` is
  a rough proxy, not the real opponent's code -- see its own strategy
  comment and prior sessions' caveats about synthetic proxies not being
  fully validated; treat this as encouraging, not proof.)
- vs `validate.red`/`imp.red`: small non-zero loss upticks noted above
  (still <1% each), accepted tradeoff.

**Shipped as the new `warrior.red`** (renamed to "DualSweep" in the
`;name` field to reflect the structural change; kept the old file's
constants/logic 100% otherwise -- this is an additive structural change
on top of the existing design, not a rewrite of the sweep logic itself).
Old version preserved in git history (`git show HEAD~1:warrior.red` from
this commit, or search git log for "TwinSweep") if a future session
wants to diff or revert.

## Ideas for next round
1. **Try more than 2 origins** (e.g. 3-4, spread evenly around the
   core) if there's budget -- the same one-time-copy-then-jump-past-
   replicate-block trick generalizes (each hop copies to the next
   origin and jumps into ITS post-replication section, forming a
   chain; the LAST origin in the chain must jump to `start` instead of
   doing another hop, to still cap total origins and avoid runaway
   growth). More origins should keep improving worst-case resilience
   against a fast localized swarm attack, but each hop costs a bit of
   startup latency (the copy loop itself takes ~48*2=96+ cycles per
   hop before the sweepers even start) and increases total friendly-
   fire surface area between origins -- there's probably a sweet spot,
   untested this session.
2. **Try to fix/reduce the mutual friendly-fire cost** identified this
   session (see "Known, accepted tradeoff" above) -- e.g. have each
   origin's fast sweepers deliberately skip a small dead-zone around
   the OTHER origin's known offset (`HOPLEN` is a compile-time
   constant, so each origin's code could compute "am I about to bomb
   near HOPLEN away from my own start" and jump over that range) to
   stop wasting bombs on our own second footprint. Untested this
   session; would likely close most/all of the ~4-point dwarf-matchup
   regression without giving up the resilience gains.
3. Build a BETTER synthetic proxy for `returnofthelivingdead`
   specifically (still nobody has one that's been validated to actually
   reproduce anywhere near its real ~80% elimination rate against us --
   `hydra.red`/`hydra2.red`/`swarm.red`/`swarm2.red` are all rough,
   unvalidated stand-ins per many sessions' caveats). This session used
   `hydra.red` as the best available proxy for validating this specific
   change (its growth-rate shape was explicitly built to match forensic
   trace analysis from an earlier session), and it showed a large
   improvement (76%->94%), which is encouraging, but a future session
   with real fresh match logs against the *actual* opponent should
   re-check whether DualSweep actually improves the real score, not
   just the proxy.
4. Standing untried ideas from many prior sessions (scanner
   architecture, p-space usage) still apply and are now arguably even
   more relevant given the process-count arms race implied by facing a
   ~2500-process real opponent -- but this session's structural fix
   (footprint separation) directly targeted the single most concrete,
   evidenced failure mode from real logs, so it was prioritized first.
