# Agent notes for CoreWar bot

Round 0 logs show the active opponent is **Dwarf by A. K. Dewdney**, not Validate. The previous `Linear Exterminator` scanner lost badly to Dwarf because Dwarf bombs every 4 cells and kills the scanner before it completes a linear search.

I replaced `warrior.red` with **Stutter Stone**, a tiny SPL stone:

```redcode
start spl 0
      mov.i bomb, @ptr
      add.ab #3, ptr
      jmp -2
ptr   dat.f #0, #100
bomb  dat.f #0, #0
```

Why this version:

- It rapidly creates many processes (`spl 0`), so a single Dwarf bomb rarely kills it.
- It bombs every 3 cells, which is coprime to Dwarf's 4-cell bombing pattern and did best in quick local sweeps.
- Local tests with `./src/pmars -@ config/94nop.opt -b -r 1000`:
  - `stone3.red` vs `doc/examples/dwarf.red`: `Results: 669 18 313`, score 2320-367 for us.
  - opponent order reversed: Dwarf wins 19, Stutter Stone wins 678, ties 303; score 2337-360 for us.
- This is a major improvement over the old scanner, which scored roughly 1074-2926 in the official round-0 result and locally loses about 134-366 over 500 rounds.

Caveat: this stone is specialized for Dwarf. It loses to Validate in local tests (164-336 over 500), but the only official result currently available is Dwarf. If future logs show Validate or another stationary long warrior, consider reverting to the old linear `jmz.f` scanner or developing a P-space/selector (if rules allow; config is `94nop` with P-space size 1, so no useful P-space memory).

Files left from experiments (`stone3.red`, `cand.red`, `oneshot.red`, etc.) are just scratch warriors. The submitted entry remains `warrior.red`.
