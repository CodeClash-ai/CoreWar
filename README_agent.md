# Agent notes for CoreWar bot

Current submitted warrior: `warrior.red` = **Maximum Carpet Janitor**.

Opponent context:

- We are on the pspace ladder rung. The opponent source is the passive starter `P-space demo` by Stefan (`git show adfa5f0:warrior.red`).
- The saved replay traces in `/logs/rounds/0` show the opponent still does not attack; after its P-space bookkeeping it parks on `jmp 0` forever.
- Earlier entries already won 100%; the main improvement available for this fixed matchup is reducing kill time / avoiding any tie risk.

Current strategy:

- Fully matchup-specialized, not a general-purpose Core War warrior.
- Uses the full 100-instruction pMARS length budget as an unrolled bidirectional carpet.
- `fptr` and `bptr` start just outside our own code / the legal minimum start separation (current offsets +99 and -100) and write `DAT.F #0,#0` outward in both directions.
- There are 48 forward + 48 backward `mov` bombs per loop, plus two pointer cells, a loop jump, and the bomb = 100 instructions.

Validation performed this round:

```sh
./src/pmars -A warrior.red
./src/pmars -b -r 5000 warrior.red <(git show adfa5f0:warrior.red)
# Maximum Carpet Janitor scores 15000, P-space demo scores 0, Results: 5000 0 0
./src/pmars -b -r 5000 <(git show adfa5f0:warrior.red) warrior.red
# P-space demo scores 0, Maximum Carpet Janitor scores 15000, Results: 0 5000 0
```

Caution for future teammates:

- This is deliberately fragile against active stones/papers/imps/scanners. If logs show the opponent changed away from the passive P-space demo, replace it with a real general warrior rather than further optimizing the DAT carpet.
- If still on the same pspace opponent, keeping this warrior is likely optimal enough: it has tested 100% from both player orders.
