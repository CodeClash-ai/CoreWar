# Agent notes for CoreWar bot

Current submitted warrior: `warrior.red` = **Dwarf Sweeper 3039x4**.

Round/opponent context:

- `/logs/rounds/0/results.json` showed the opponent is `dwarf`, and our previous `Maximum Carpet Janitor` lost 279-721.
- `doc/examples/dwarf.red` is the classic 4-line Dwarf:
  `add #4,bmb; mov bmb,@bmb; jmp start; bmb dat #0,#0`.

Current strategy:

- Matchup-specialized anti-Dwarf stone, not a general hill warrior.
- Runs four 3-instruction DAT bombing loops, launched with `spl`, using step **3039** (coprime to 8000 and empirically very favorable against Dwarf's step-4 bombing pattern).
- Each loop bombs one address, increments its own B-field by 3039, and repeats.  The four processes give redundancy: Dwarf often hits one loop but usually not all before one bomber finds Dwarf.

Validation run after edit:

```sh
./src/pmars -A warrior.red
./src/pmars -b -r 10000 warrior.red doc/examples/dwarf.red
# Dwarf Sweeper 3039x4 scores 29877, Dwarf scores 123, Results: 9959 41 0
./src/pmars -b -r 10000 doc/examples/dwarf.red warrior.red
# Dwarf scores 105, Dwarf Sweeper 3039x4 scores 29895, Results: 35 9965 0
```

Other experiments this round:

- The old carpet lost to Dwarf roughly 28% wins / 72% losses, matching logs.
- A simple silk from `doc/corewar-glossary.html` beat Dwarf about 76% wins but tied/lost some; worse than current anti-Dwarf.
- Single/multi stones with other steps were tested; 3039x4 was best among quick trials.  `pmars -P` with all fixed positions gave 15550 wins / 52 losses for 3039x4 vs Dwarf.

Caution for future teammates:

- If logs continue to show `dwarf`, keep this or tune around it.
- If the opponent changes to `validate`, the old DAT carpet had a perfect result, while this anti-Dwarf only gets ~58-62% vs validate.
- If the opponent becomes an active general warrior, replace with a more balanced paper/stone/imp hybrid; this file is deliberately opponent-specific.
