# Agent notes for CoreWar bot

Current submitted warrior: `warrior.red` = **Dwarf Sweeper 3039x12**.

Round/opponent context:

- `/logs/rounds/0/results.json`: opponent is `dwarf`; our old `Maximum Carpet Janitor` lost 279-721.
- Round 1 changed to anti-Dwarf `Dwarf Sweeper 3039x4`; `/logs/rounds/1/results.json` won 998-2 against `dwarf`.
- The replay/log names continue to identify the opponent as the classic 4-line Dwarf by A. K. Dewdney:
  `add #4,bmb; mov bmb,@bmb; jmp start; bmb dat #0,#0` (see `doc/examples/dwarf.red`).

Current strategy:

- Matchup-specialized anti-Dwarf stone, not a general hill warrior.
- Runs twelve 3-instruction DAT bombing loops, launched with `spl`, using step **3039** (coprime to 8000 and empirically very favorable against Dwarf's step-4 bombing pattern).
- Compared with the Round-1 4-loop version, 12 loops add enough redundancy to remove the rare phase losses seen in random/exhaustive tests while staying well under the 100-instruction length limit.

Validation run after the Round-2 edit:

```sh
./src/pmars -A warrior.red
./src/pmars -b -r 10000 warrior.red doc/examples/dwarf.red
# Dwarf Sweeper 3039x12 scores 30000, Dwarf scores 0, Results: 10000 0 0
./src/pmars -b -r 10000 doc/examples/dwarf.red warrior.red
# Dwarf scores 0, Dwarf Sweeper 3039x12 scores 30000, Results: 0 10000 0
./src/pmars -b -P warrior.red doc/examples/dwarf.red
# Dwarf Sweeper 3039x12 scores 46806, Dwarf scores 0, Results: 15602 0 0
./src/pmars -b -P doc/examples/dwarf.red warrior.red
# Dwarf scores 0, Dwarf Sweeper 3039x12 scores 46806, Results: 0 15602 0
```

Other experiments/history:

- Round-1 3039x4 was already strong but had rare losses: exhaustive fixed-position test was 15550 wins / 52 losses (depending on ordering), and round score was 998-2.
- Quick tests this round with 8 loops still had 6 exhaustive fixed-position losses, while 12+ loops had 0 losses vs `doc/examples/dwarf.red` under current pMARS settings.
- A simple silk from `doc/corewar-glossary.html` beat Dwarf about 76% wins but was worse than the anti-Dwarf stones.

Caution for future teammates:

- If logs continue to show `dwarf`, keep this or tune around it; it appears perfect against the local classic Dwarf over all legal fixed starts.
- If the opponent changes to `validate`, the very old DAT carpet had a perfect result, while anti-Dwarf stones were only moderately good.
- If the opponent becomes an active general warrior, replace this with a more balanced paper/stone/imp hybrid; this file is deliberately opponent-specific and will not be robust on a mixed hill.
