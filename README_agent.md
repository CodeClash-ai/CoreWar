# CoreWar bot — teammate notes

## Entry point
- `warrior.red` (repo root) is THE warrior that gets played. Keep it valid `redcode-94`.
- Match config = KOTH '94 standard hill: coresize 8000, 80000 cycles, max length 100,
  ~200 rounds (see `config/94.opt`). Simulate with:
  `./src/pmars -r 200 -@ config/94.opt warrior.red OPPONENT.red`
  Output "Results: W L T" = wins losses ties for warrior #1.

## Opponent
- Round 0 opponent = "pspace" = the stock `warrior.red` demo (P-space demo by Stefan),
  which is just `jmp 0` looping forever — passive & IMMORTAL (never self-terminates).
  => Only way to score a WIN vs it is to overwrite its instruction with a DAT.
  A SPL bomb only TIES it (jams it into eternal spawning but doesn't kill).

## Current warrior: Stone3037 (DAT carpet bomber)
- step=3037 is coprime to 8000 => bomb pointer sweeps the entire core.
- CRITICAL FIX: bomb line is `dat #step,#step` (NON-zero B-field). With a zero
  B-field, `mov.i bomb,@bmb` eventually self-targets and the stone kills ITSELF,
  causing losses even vs the passive demo. Non-zero fields + `djn.f` avoid this.
- Result: 200-0-0 vs the demo. ~125-75 vs a plain step-4 dwarf, ~78-120 vs a
  fast dwarf (loses to strong bombers — see improvement ideas).

## Verified results (200 rounds each)
- vs demo (jmp 0):        200 W / 0 L / 0 T   (perfect)
- vs step-4 dwarf:        125 W / 75 L
- vs fast bomber:         ~78 W / 120 L       (weak spot)

## Tuning notes / gotchas learned
- Hand-written silk/paper replicators kept dying (buggy) — didn't have a
  working one. If you attempt one, TEST it (`-r 20` vs `/tmp` opponent) before shipping.
- A bomber self-destructs unless its indirect bomb never lands on its own code.
  The `dat #step,#step` trick + djn.f fixed that here.
- SPL-carpet ties the passive demo (bad, we want kills). DAT-carpet wins.
- Steps tried vs demo: 3037->200W, 3999->200W, 3039->193W, 4001->155W, 5333->1W.

## Improvement ideas for next teammate
1. Add a second phase: after the bombing sweep, do a tight core-CLEAR to also
   beat replicators/papers (currently our weak spot is fast bombers/papers).
2. Consider a scanner (cmp/sne) to locate & kill precisely, or a quickscan opener.
3. Add an imp (`mov.i 0,step`) as a tie-breaker so we never LOSE (imps are hard
   to kill) — trade some wins for far fewer losses.
4. Test any change against BOTH the demo and `/tmp` bombers before submitting.
