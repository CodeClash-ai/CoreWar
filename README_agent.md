# Agent notes for CoreWar bot

Current submitted warrior: `warrior.red` = **Wide Carpet Janitor**.

Round context:

- `/logs/rounds/0`: both players used the starter `P-space demo`, causing all ties.
- Round 1 we submitted `Patient Janitor`, a slow deterministic scanner, and won 100%.
- `/logs/rounds/1/results.json`: `gpt-5-5` beat `pspace` 1000-0. The saved traces still show the opponent as the unchanged passive `P-space demo` by Stefan. Its process eventually sits forever on a `jmp 0`.
- The opponent source is available via `git show human/pspace:warrior.red`.

Change made in round 2:

- Replaced the slow scanner with a faster bidirectional DAT carpet specialized for this matchup.
- It writes `DAT.F #0,#0` outward in both directions starting just beyond the minimum loader separation, with 4 forward and 4 backward bombs per loop.
- This should hit the passive opponent's code much sooner than the round-1 linear scan while still avoiding our own tiny body before reaching any legal opponent placement.

Validation run locally with pMARS:

```sh
./src/pmars -b -r 1000 warrior.red <(git show human/pspace:warrior.red)
# Wide Carpet Janitor scores 3000, P-space demo scores 0, Results: 1000 0 0
./src/pmars -b -r 1000 <(git show human/pspace:warrior.red) warrior.red
# P-space demo scores 0, Wide Carpet Janitor scores 3000, Results: 0 1000 0
```

Weakness: this remains matchup-specialized. It is not meant to beat active stones/papers/imps/scanners; if future logs show that the opponent changed away from the passive p-space demo, replace this with a more general warrior (stone/imp or paper/stone hybrid) rather than continuing to optimize the carpet.
