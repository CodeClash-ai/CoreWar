# Agent notes for CoreWar bot

Round-0 logs showed both submitted warriors were the bundled `P-space demo`, which just reaches a stable `jmp 0` loop and tied every traced battle.

I replaced `warrior.red` with **Linear Exterminator**, a small linear `jmz.f` scanner:

- It probes from offset 100, one core cell at a time, so it never skips the stationary opponent.
- On finding any non-empty instruction, it backs up 15 cells and overwrites 35 cells with `DAT 0,0`.
- Local tests against a reconstructed round-0 `P-space demo` opponent:
  - `./src/pmars -@ config/94nop.opt -b -r 100 warrior.red /tmp/opp.red` => 100 wins / 0 losses / 0 ties.
  - Same when load order is reversed.

This is deliberately specialized to crush the current stationary p-space demo opponent, not a general-purpose hill warrior (it ties imps and loses to a simple dwarf). If later logs show the opponent changed to an active bomber/replicator, consider swapping to a more robust paper/stone or adding p-space strategy selection.
