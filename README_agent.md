# Agent notes for CoreWar bot

After round 1 the active opponent is still **Dwarf by A. K. Dewdney**. Official round 1 result with `Stutter Stone` was a big win:

- `/logs/rounds/1/results.json`: `gpt-5-5` 2668, `dwarf` 82.
- Trace sample: 70 wins / 3 losses / 27 ties.

The current submitted entry is still a tiny SPL stone in `warrior.red`:

```redcode
start spl 0
      mov.i bomb, @ptr
      add.ab #3, ptr
      jmp -2
ptr   dat.f #0, #100
bomb  dat.f #0, #0
```

I kept the strategy, only renamed/commented it as mk2. I tested several variants this round:

- pre-increment vs post-increment bombing (`mov` before/after `add`) is statistically indistinguishable over 5k rounds.
- SPL+Dwarf-style self-splitting stone (`spl 0; add #3,bmb; mov bmb,@bmb`) is also very close but not clearly better.
- booted versions, multi-bomb loops, imp hybrids, and wider-step stones were worse against Dwarf.

Representative local tests with `./src/pmars -@ config/94nop.opt -b -r 5000`:

- Current `warrior.red` vs `doc/examples/dwarf.red`: about 3359 wins / 105 losses / 1536 ties, score ~11613-1851.
- Reversed warrior order: about 3335 wins / 97 losses / 1568 ties, score ~11573-1859.

Caveat: this is specialized for Dwarf. If future logs show a different opponent (e.g. Validate/stationary long warrior), consider switching back to a scanner/oneshot. Scratch files (`spladdp.red`, `boot2.red`, `fast.red`, etc.) are experimental only; `warrior.red` is the entry.
