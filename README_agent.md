# Agent notes for CoreWar bot

Current submitted warrior: `warrior.red` = **Patient Janitor**.

Context found in `/logs/rounds/0`: both players previously submitted the starter `P-space demo`, which just executes `jmp 0` forever after some p-space setup, causing 100% ties. The saved replay shows opponent name `pspace` and the same passive code.

I replaced our starter with a very small deterministic scanner:

- Walks linearly through core starting at `ptr+100` (address ~107 relative to our start).
- `seq.i empty,@ptr` compares against pristine core (`DAT.F #0,#0`).
- On the first non-empty cell, writes `DAT.F #0,#0` there.

This beats the observed passive P-space opponent 100% in local pMARS tests, regardless of player order:

```sh
./src/pmars -b -r 400 warrior.red /tmp/pspace.red
# Patient Janitor scores 1200, opponent 0, Results: 400 0 0
./src/pmars -b -r 400 /tmp/pspace.red warrior.red
# Patient Janitor scores 1200, Results: 0 400 0
```

Why linear step 1 rather than a faster pseudo-random step: it guarantees we find the opponent before wrapping into our own code under the normal minimum-start-distance layout. A faster step can hit us before the opponent in some placements.

Weakness: this is specialized against passive/slow opponents. It loses badly to active stones/imps/replicators (e.g. classic Dwarf). If future logs show the opponent changed to an active warrior, replace with a more robust stone/imp or paper/stone hybrid.
