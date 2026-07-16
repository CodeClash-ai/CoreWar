# Agent notes for CoreWar bot

Current submitted warrior: `warrior.red` = **Smooth Dwarf Sweeper 187x20**.

Round/opponent context:

- The actual opponent in logs is `smoothnoodlemap`, banner `Smooth Noodle Map by Matt Hastings`.
- Our anti-Dwarf family has been winning strongly:
  - `/logs/rounds/0/results.json`: gpt-5-5 973, smoothnoodlemap 27.
  - `/logs/rounds/1/results.json`: gpt-5-5 984, smoothnoodlemap 16.
- Trace inference: opponent is a one-process backwards Dwarf-like bomber, length 86. It executes approximately:
  `add.ab #-34, ptr; mov.i bomb, @ptr; jmp start; ptr/bomb ...` and bombs addresses decreasing by 34.
- Round-1/previous warrior was `Smooth Dwarf Sweeper 187x12` and had only 2 losses in the 100 saved round-1 traces.

Current strategy:

- Matchup-specialized anti-Smooth/Dwarf stone, not a general hill warrior.
- Runs twenty independent 3-instruction DAT bombing loops, launched by `spl`, all with bombing step **187**.
- 187 remains perfect in local tests against classic `doc/examples/dwarf.red` under random and exhaustive `-P` starts, while also being very strong against inferred Smooth variants.
- Increasing from 12 to 20 loops uses 81 instructions (under the 100 limit) and is intended to add process redundancy against rare phases where Smooth kills all loops.

Useful local validation run this round:

```sh
./src/pmars -A warrior.red
./src/pmars -b -r 10000 warrior.red doc/examples/dwarf.red
# Results: 10000 0 0
./src/pmars -b -P warrior.red doc/examples/dwarf.red
# Results: 15602 0 0
```

Approximation files left in `tmp/`:

- `tmp/smooth_approx.red`: simple inferred Smooth with early pointer (perfectly beaten by 187x20 in local random tests).
- `tmp/smooth_exactish.red`: alternative pointer placement matching observed early trace more closely; 187x20 wins about 94% random and 14732/15602 under `-P` against it. This approximation is imperfect; actual match logs were better (984-16 with 187x12).
- `tmp/stone187x*.red`, `tmp/c*.red`, `tmp/t*.red`: generated test stones for step/loop experiments.

Caution for future teammates:

- If logs still show `smoothnoodlemap`, keep/tune this specialized DAT-stone family. Steps 187, 73, 229, 263 were explored; 187 was the safest across Smooth approximation plus classic Dwarf.
- If opponent changes to a replicator/paper or general hill warrior, replace this with a more balanced paper/stone/imp hybrid; this warrior is deliberately opponent-specific.

## Round 1 update by gpt-5-5

Important correction from the actual `/logs/rounds/0` for this match:

- Opponent is `smoothnoodlemap6`, not the older Dwarf-like `smoothnoodlemap` described above.
- Score with the previous `Smooth Dwarf Sweeper 187x20` was still winning but much closer: results.json says **667-326** (saved trace tally 58-42).
- The trace is paper/silk-like. Early opponent-owned writes relative to opponent start include `-309..-313`, then further copies separated by large silk offsets. This suggests Smooth Noodle Map 6 is a replicator beginning with a ~309-cell copy, not a simple backwards dwarf.

Change made this round:

- Replaced `warrior.red` with **Smooth Noodle Net 309x24**: 24 parallel DAT stones, all bombing with step **309**, length 97 (under MAXLENGTH 100).
- Rationale: against a local rough silk approximation (`tmp/smooth6_guess.red`) the old 187x20 scored about 461/494/45 in 1000 random rounds, while 309x24 scored about 2820/2055/125 in 5000 (roughly 57.8% wins). It also remains strong against the earlier `tmp/smooth_exactish.red` dwarf approximation (4453/547/0 in 5000).
- Classic Dwarf matchup is slightly worse than 187 but still strong (local test for generated 309x24 was ~4929/71/0 in 5000 random; exhaustive -P had 15380/222/0).

Files/tools:

- `tmp/smooth6_guess.red` is only a crude guessed silk based on trace addresses; do not over-trust it, but it is useful for step/loop experiments.
- `tmp/genmix.sh` and `tmp/test_steps.sh` generate quick test warriors. They are rough scratch tools.

Future teammate advice:

- If logs after this round show 309x24 improved against `smoothnoodlemap6`, continue tuning anti-silk DAT-stone steps around the trace-derived offsets (`309`, maybe mixtures with `103`, `187`, `229`, `263`).
- If 309x24 regresses, revert to the previous 187x20 from git/notes above, or try a mixed 309/103/187 stone (`tmp/mixA.red`, `tmp/mixB.red` from this round tested similarly to pure 309 on the crude approximation).
