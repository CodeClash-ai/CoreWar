# CoreWar bot — teammate notes

## Entry point
- `warrior.red` (repo root) is THE warrior that gets played. Keep it valid `redcode-94`.
- Match config = KOTH '94 standard hill: coresize 8000, 80000 cycles, max length 100.
  Simulate with:
  `./src/pmars -r 400 -s 8000 -p 8000 -c 80000 -l 100 warrior.red OPPONENT.red`
  Output "Results: W L T" = wins losses ties for warrior #1.
- Disassemble/verify layout: add `-A` flag (no -r).

## Opponent (rounds 0 & 1)
- Opponent = "P-space demo by Stefan" = a PASSIVE / IMMORTAL looper (never
  self-terminates). Approximate it with `/tmp/pspace.red` = `jmp loop`.
- Only way to WIN vs it is to overwrite its code with a DAT bomb. A pure paper
  (silk) NEVER kills it and loses everything. A DAT carpet bomber wins.
- Round 1 result: we won 3997-3 (99/100 traced battles). 1 stray loss = P-space
  restart randomness / position variance.

## Current warrior: StoneRing (DAT bomber + imp ring)  [round 2]
- Stone: `add #2667 -> mov.i DAT -> djn.f` sweeps whole core (2667 coprime to 8000).
  Bomb line `dat #2667,#2667` has NON-zero fields so the indirect @bmb never lands
  on our own code -> we never self-destruct -> guaranteed kills vs passive foes.
- NEW: two `spl imp` launch a 3-instruction IMP RING (mov.i 0,4000). Imps are very
  hard to kill, so battles we'd otherwise LOSE vs active bombers/scanners become
  TIES (or wins). This strictly improved every matchup vs the old Stone3037.

## Verified results (400 rounds each, note pmars has position RNG -> ~+-15 variance)
- vs pspace (jmp loop):   400 W / 0 L / 0 T   (PERFECT — this is the real opponent)
- vs step-4 dwarf/bomber: ~190 W / 197 L / 13 T  (was 78-119 with old Stone3037!)
- vs stone (spl bomber):  ~241 W / 18 L / 141 T (was 103-38-59)
- vs silk (paper):        ~395 W / 0 L / 5 T
- vs scan (scanner):      400 W / 0 L / 0 T

## Key gotchas learned (DON'T repeat these)
- `djn.f start,<bomb` loop is CRITICAL. A `jmp start` loop makes mov.i self-target
  and the stone kills itself -> loses even vs the passive demo (41-159). Keep djn.f.
- Bomb MUST have non-zero B-field (`dat #step,#step`), else self-hit.
- Adding a 2nd bomb-per-loop broke the djn offset -> self-destruct (0-400). Don't.
- Some steps break anti-pspace perfection (3667/3989 -> ~40-160). 2667 & 3037 are safe.
  ALWAYS re-test vs /tmp/pspace.red after ANY change; must stay 400-0-0.
- A single imp gets bombed easily; the 3-imp ring block + 2 spls is what survives.

## Improvement ideas for next teammate
1. The bomber is still ~even vs a fast step-4 bomber. A quickscan opener (cmp/sne
   to find + kill enemy fast) could flip that, but keep the anti-pspace DAT sweep.
2. Consider a proper core-clear phase after the sweep to beat replicators harder.
3. Test EVERY change vs /tmp/pspace.red (must be 400-0-0) AND /tmp/bomber.red.
