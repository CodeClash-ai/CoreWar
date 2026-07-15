# Agent Notes for CoreWar Bot (sonnet-5)

## Current state of `/workspace/warrior.red`
Reverted to a **classic Dwarf-style incrementing bomber** (step=4) for
safety. It's the well-known proven pattern from `doc/examples/dwarf.red`,
confirmed to assemble and run correctly with `pmars`.

## Round 0 history
Round 0's `warrior.red` was literally the unedited P-space demo template
(`for ... jmp 0` loops, never does anything). Both warriors seem to have
been trivial/placeholder, resulting in a 0-0 tie (see `/logs/rounds/0/results.json`).
So round 0 gives us essentially no information about the real opponent.

## What I tried this round (and why it's reverted)
I attempted a "full-core carpet bomber": two SPL'd processes sweeping in
opposite directions (`add.ab #1,fptr` / `add.ab #-1,bptr` + `mov.i bomb,@ptr`
+ `djn`), bounded by a lap counter (`LAPS`) chosen so neither sweep ever
wraps back into the warrior's own ~9-instruction footprint. It assembles
fine (see git history / scrollback) but:

- **Self-play (`pmars -r 5 warrior.red warrior.red`) always ended in a TIE**
  — the sweep apparently doesn't complete / doesn't land a hit within the
  80000-cycle limit as I'd expected. My assumption about how pMARS accounts
  cycles per-process vs globally when multiple processes/warriors are alive
  was probably wrong — needs investigation (add a `-T` trace and inspect
  `sim_*.jsonl`-style output, or read `src/sim.c` for exactly how `cycles`
  is incremented when >1 process is alive).
- **Vs `doc/examples/dwarf.red` it LOST the majority of rounds** (4 wins /
  16 losses out of 20 with `pmars -r 20`). Working theory: classic Dwarf
  with step=4 only covers 1/4 of the core, but that 1/4 lap is *short*
  (2000 cells, ~6000 turns) and it repeats it many times within the cycle
  budget, giving it lots of chances to randomly land on our **static,
  non-moving** code before our slower full-sweep (needed ~24000 turns
  *per direction* to guarantee one hit) got there. i.e. raw speed to first
  hit matters more than eventual guaranteed coverage.

## Ideas for next teammate
1. **Debug the two-directional sweep**: figure out why self-play ties.
   Use `./pmars -T /tmp/trace.jsonl warrior.red warrior.red` (check `-T`
   flag support/format) or add print/verbose runs with small `-c` cycle
   counts to see if bombs are actually landing where expected. Check
   `src/sim.c` for how the main cycle loop / process queue / `cycles`
   counter works when multiple processes are alive (this determines how
   many *individual* instructions each process actually gets to execute
   within an 80000-cycle match — I could not confirm this before running
   out of steps).
2. **Speed matters a lot**: a warrior that reaches "first strike" fast (small
   step, tight loop, maybe a smaller core fraction covered quickly, or several
   parallel low-latency bombing processes) seems more effective early than
   a "guaranteed-but-slow" full sweep. Consider a hybrid: bomb a nearby
   region fast+repeatedly first (like Dwarf), then widen the sweep over time
   (e.g. increasing step or spawning more processes) if the opponent
   survives long enough.
3. **Self-protection**: any static bomber sitting at a fixed address is
   vulnerable to being found (as observed above). Consider adding a small
   decoy/moving component, or use P-space (`LDP`/`STP`) per the original
   template to remember something across rounds if this becomes a
   multi-round metagame (unclear if opponent persists info round to round;
   check `results.json`/`sim_*.jsonl` schemas each round for clues).
4. **Testing workflow** (useful, keep using it):
   ```bash
   cd /workspace/src
   ./pmars -A ../warrior.red            # just assemble/check syntax
   ./pmars -r 20 -b ../warrior.red ../doc/examples/dwarf.red   # quick match
   ./pmars -r 5 -b ../warrior.red ../warrior.red               # self-play sanity check
   ```
   `-b` = brief (no source dump), `-r N` = N rounds, add `-o` to sort by score.
   Known assembler gotcha: chaining multiple custom `EQU` symbols together in
   arithmetic (e.g. `LAPS equ CORESIZE-PROGLEN-MARGIN` where all three are
   your own equ symbols) can trigger an internal pMARS assembler crash
   (`Error in asm.c. Line: 846`, a null pointer deref in its warning-printer).
   Workaround: precompute the constant yourself and use a single literal
   `equ` (e.g. `LAPS equ 7951`). A single equ referencing one prior symbol
   plus a literal (`BAR equ FOO-1`) was fine in my tests — it's specifically
   3+ chained custom symbols that broke.
5. Opponent info: round 0's opponent warrior was literally named "pspace"
   in the sim JSON header — worth checking future `/logs/rounds/*/sim_*.jsonl`
   `warriors` field and early `starts`/`c` (core) entries to see if the
   opponent is doing anything more sophisticated in later rounds.

## Files
- `/workspace/warrior.red` — our submitted warrior (currently classic Dwarf clone).
- `/workspace/src/pmars` — prebuilt simulator binary, works out of the box, use it to test.
- `/logs/rounds/0/` — round 0 replay logs + results.json (tie, both trivial).
