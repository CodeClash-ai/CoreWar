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

## Round 2 update by gpt-5-5

Observed `/logs/rounds/1/results.json`: the experimental **Smooth Noodle Net 309x24** scored **583-404**, worse than round 0's **667-326** with the older 187x20 stone.  The saved trace sample for round 1 was 63 wins / 36 losses / 1 draw, but the full score regressed clearly.

Change made: reverted `warrior.red` to a lightly renamed/commented **Smooth Dwarf Sweeper 187x20r** (20 parallel 3-instruction DAT stones, step 187, length 81).  This is the exact family that produced the stronger round-0 score against `smoothnoodlemap6`; shorter length may matter because Smooth's silk overwrites/copies fewer of our cells.

Validation this round:

```sh
./src/pmars -A warrior.red
./src/pmars -b -r 2000 warrior.red tmp/smooth6_guess.red      # rough guess only: about even
./src/pmars -b -r 2000 warrior.red tmp/smooth_exactish.red    # 1881 119 0
./src/pmars -b -r 2000 warrior.red doc/examples/dwarf.red     # 2000 0 0
```

I also added `tmp/analyze_logs.pl` to summarize saved JSONL traces by round, winner, and start-distance buckets, e.g. `./tmp/analyze_logs.pl 0 1`.  It confirms the sample trace tallies (round0 58/42, round1 63/36/1) but remember full `results.json` is more important.

Future ideas: if 187x20r still underperforms, consider not just step changes but a genuinely anti-paper qscan/spl/dat clear; crude local `tmp/smooth6_guess.red` was not predictive enough to trust for final selection.

## Round 1 update vs returnofthelivingdead by gpt-5-5

Actual `/logs/rounds/0/results.json` for this match is **bad** for the inherited anti-Smooth DAT stone: `returnofthelivingdead` 946, `gpt-5-5` 27. Opponent banner in logs: `return of the living dead by nandor sieben`, length 33. Saved traces show it very rapidly creates many copies/processes at ~1000-cell offsets (classic paper/silk style), so sparse DAT stones are the wrong matchup.

I replaced `warrior.red` with **Return Trap 237**, a small SPL/DAT scanner/trapper:

- `jmz.f` scans by step 237 for non-zero cells.
- On contact it places `spl #0,#0` and `dat #0,#0` around the target, then resumes scanning.
- Goal is to stun/contain the paper and convert losses into draws/wins.

Crude local tests against our old stone are not representative of the opponent but sanity check assembly:

```sh
./src/pmars -A warrior.red
./src/pmars -b -r 500 warrior.red tmp/anti1.red   # mostly draws vs a simple SPL/DAT bomber
```

Future teammates: use the JSONL traces to infer/reconstruct the 33-line `return of the living dead` paper if possible. A better specialized anti-paper would likely be a robust B-scanner/pit-trapper or two-pass SPL/DAT core clear. Do not revert to the Smooth-specific 187x20 unless opponent changes back.

## Round 2 update vs returnofthelivingdead by gpt-5-5

Actual `/logs/rounds/1/results.json`: **Return Trap 237 regressed badly** vs the 33-line `return of the living dead` paper: opponent 863, us 7.  Saved traces: 92 opponent wins / 8 ties / 0 us wins.  The scanner's process count stayed tiny and it only overwrote cells near its scan pointer; the paper was already spreading faster than we could trap.

Trace pattern to preserve for future work:

- Opponent writes relative to its own start immediately at `0,1,2,...` and at copy offsets `+1031,+2032,+3035,+4036,+5039,+6040,+7043` (roughly 1000/1031 lattice).  Later copies keep adjacent active triplets such as `... 5943,5944,5945 ...`.
- It is a very fast silk/paper with max processes in the thousands; simple DAT stones and the round-1 scanner both lose.

Change made this round:

- Replaced `warrior.red` with **Living Dead Lattice 1031**.
- It is 8 parallel tiny bombers laying alternating `spl #0,#0` and `dat #0,#0` on step **1031** from phases 1000/2000/3000/4000.  Rationale: attack the opponent's observed replication lattice directly and, more importantly, create many SPL/DAT carpets to turn losses into ties.
- Local crude approximation `tmp/rotld_guess.red` was added (do not over-trust it).  Against that guess the old scanner had very poor results; this lattice bomber was still not winning but produced many more ties in local tests (e.g. 36/165/799 over 1000 with candidate as warrior 1).  Against `tmp/smooth6_guess.red` it also mostly ties, so it is at least a plausible anti-paper direction.

Future ideas:

- If this improves full score, tune lattice phases/step.  Try more phases or a mix of 1031 and 1001/1003/997, but keep lots of SPL carpets.
- If it fails, consider a known-style anti-paper: multi-pass SPL/SPL/DAT coreclear or a stone+imp that cannot be killed quickly.  The opponent-specific reconstruction remains the highest-value task.
