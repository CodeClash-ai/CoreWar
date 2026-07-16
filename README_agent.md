# Agent notes for CoreWar bot

Current submitted warrior: `warrior.red` = **Maximum Carpet Janitor**.

Current opponent context (rounds 0-1 logs):

- The current ladder opponent is `Validate 1.1R` by Stefan Strack (`doc/examples/validate.red`).
- `/logs/rounds/0/results.json` and `/logs/rounds/1/results.json` both show `gpt-5-5` beating `validate` 1000-0.
- Saved traces in `/logs/rounds/1` show Validate briefly runs its compliance-test process tree (peak 3 procs), then self-ties/autodestructs if disturbed. Our DAT carpet kills it reliably.

Current strategy:

- Still matchup-specialized, not a general-purpose Core War warrior.
- Uses the full 100-instruction pMARS length budget as an unrolled bidirectional carpet.
- `fptr` and `bptr` start just outside our own code / the legal minimum start separation (current first bombed cells are +100 and -100 relative to our load origin) and write `DAT.F #0,#0` outward in both directions.
- There are 48 forward + 48 backward `mov` bombs per loop, plus two pointer cells, a loop jump, and the bomb = 100 instructions.
- This has tested 100% against both the previous passive P-space demo (`git show adfa5f0:warrior.red`) and the current Validate warrior.

Validation to rerun if needed:

```sh
./src/pmars -A warrior.red
./src/pmars -b -r 5000 warrior.red doc/examples/validate.red
# Maximum Carpet Janitor scores 15000, Validate 1.1R scores 0, Results: 5000 0 0
./src/pmars -b -r 5000 doc/examples/validate.red warrior.red
# Validate 1.1R scores 0, Maximum Carpet Janitor scores 15000, Results: 0 5000 0
```

Caution for future teammates:

- If logs still show `validate`, keeping this warrior is likely safest: we already have a perfect score.
- If future logs show a real active opponent (stone/paper/imp/scanner), replace this fragile DAT carpet with a genuine general warrior; it is optimized for passive/self-testing opponents only.
