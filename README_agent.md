# Agent notes for CoreWar bot

Current entry is `warrior.red`: **Forked Stutter Stone**.

Context from logs available this round:

- `/logs/rounds/0/results.json`: `gpt-5-5` 3999, opponent `smoothnoodlemap` 1.
- Replay logs showed opponent name `Smooth Noodle Map by Matt Hastings` and our previous entry `Stutter Stone mk2` winning essentially all stored battles (one stored fixed-position batch looked like a loss in order, but official aggregate was a huge win).
- The replay trace suggests Smooth Noodle Map is a small stone/bomber: opponent code appears at addresses 0..2 and drops bombs stepping backwards by 34 (`7875, 7841, 7807, ...`). I made `smooth_guess.red` as a local approximation only; it is not the submitted entry.

Change made this round:

- Replaced the tiny 6-line SPL stone with a 14-line forked version:
  - Keeps the original resilient `spl 0` DAT stone with step `+3` and pointer `#100`.
  - Adds two early helper DAT bombing loops stepping `-34` from far offsets `3999` and `3998`.
- Rationale: still crushes the observed Smooth-style stone, and in local tests it scored much better than the old stone against `doc/examples/dwarf.red` too.

Representative local tests (`./src/pmars -@ config/94nop.opt -b`):

- New `warrior.red` vs `doc/examples/dwarf.red`, 20k rounds: 16596 wins / 56 losses / 3348 ties, score 53136-3516.
- Old stutter stone vs Dwarf in the same test run: 13356 wins / 383 losses / 6261 ties, score 46329-7410.
- New warrior vs local `smooth_guess.red`, 20k rounds: 19974 wins / 26 losses / 0 ties.
- A two-stone variant (`multistone.red`) did even better vs `smooth_guess` but worse vs Dwarf; I kept the more robust forked hybrid.

Scratch files in the repo (`hybrid.red`, `hybrid1.red`, `multistone.red`, `smooth_guess.red`, etc.) are experimental. The game entry should be `warrior.red`.

Caveat: this remains specialized for simple bombers/stones. If future logs show a scanner, paper, or imp opponent, reassess rather than assuming this is optimal.

Round 2 note:
- Official round 1 was again an overwhelming win: 3998 vs 1; stored traces were 100/100 wins, opponent still the same simple -34 bomber.
- Kept the Forked Stutter Stone structure. Tiny tweak: main stone pointer changed from #100 to #200 after local fixed-series tests vs SmoothGuess/SmoothExactGuess showed equal or slightly fewer losses for #200 in small samples, while preserving the two anti -34 helper streams.
- Be careful with long pmars -r values: above ~65k rounds the Results counter overflows signed output; use <=40000 per run.

Round 1 update (current work):
- Official `/logs/rounds/0/results.json` for this matchup is **loss**: gpt-5-5 1236, smoothnoodlemap6 1514. Stored traces: Smooth Noodle Map 6 beat Forked Stutter Stone 45-26 with 29 ties.
- Observed opponent is still a very small bomber/stone-like warrior, but version 6 appears much stronger in stone-vs-stone attrition. The old forked stone often leaves Smooth with 1-2 live processes that kill our remaining process around cycle ~16k.
- I replaced `warrior.red` with `Silk Paper 3039`, a compact silk-style replicator:
  - steps 3039 / 2365 plus anti-imp DAT bombing at 777
  - local pMARS vs `smooth_exact.red` (our approximation of the earlier Smooth bomber): 993/7/0 over 1000 rounds.
  - local pMARS vs `doc/examples/dwarf.red`: 944/49/7 over 1000 rounds.
  - local vs the previous forked `warrior.red` before replacement was about 188/7/5 over 200 for this step set (paper crushes our stone).
- Caveat: `smooth_exact.red` is only an approximation from earlier notes/logs; if the real Smooth Noodle Map 6 is a scanner/scissors tuned to kill papers, reconsider. But based on traces it behaves like a bomber, and paper should be the right rock-paper-scissors response.
- Added `analyze_logs.awk` for quick replay winner counts without Python (`awk -f analyze_logs.awk /logs/rounds/0/sim_*.jsonl`).

Round 2 update:
- Official round 1 (after switching to `Silk Paper 3039`) was a huge win: `/logs/rounds/1/results.json` gpt-5-5 3585 vs smoothnoodlemap6 66; stored traces 90 wins / 2 losses / 8 draws.
- The rare losses/draws were very late, with Smooth still running a small -34 bomber around 7686..7689 while paper fragments sometimes only tied or got erased.
- I changed `warrior.red` to **Silk PaperStone 3039**: same 3039/2365/777 silk paper, plus a parallel `spl 0` DAT bombing loop stepping `-34` from #3999. This is intended to preserve the paper's strong matchup while directly sweeping the observed Smooth bomber's stride.
- Local checks (opponent approximation only): vs `smooth_exact.red`, 10000 random rounds gave around 9930 wins / 21 losses / 49 ties for PaperStone vs about 9908/89/3 for pure paper in one adjacent run; fixed 8000 series also favored PaperStone on SmoothExact. It is worse than pure paper vs generic Dwarf, but the official opponent is still Smooth Noodle Map 6, so I accepted the specialization.
- If future logs show the opponent changed away from the -34 stone/bomber, reconsider this hybrid; pure `Silk Paper 3039` from previous README may be more generally robust.

Round 1 update vs `returnofthelivingdead`:
- Official `/logs/rounds/0/results.json`: we won but not dominantly, 1841 vs 969. Stored trace aggregate: 52 wins / 26 losses / 22 draws for previous `Silk PaperStone 3039`.
- Opponent is **return of the living dead by Nandor Sieben**, and replay snapshots show it is a fast paper/replicator, not Smooth's stone. At t=0 it has many copies spaced roughly +1001/+1002/+1003, so the old anti-(-34)-stone component is wasted and sometimes leaves us weak in paper-vs-paper endgames.
- I replaced `warrior.red` with pure `Silk Paper 1800/3740` (same as existing scratch `paper2.red`):
  - `step1=1800`, `step2=3740`, `step3=3044`, bomb `dat.f >2667, >5334`.
  - No parallel stone, so all early processes are devoted to replication.
- Local checks (only approximations, but directionally useful):
  - New pure paper vs previous submitted `paperstone2.red`: 222/181/597 over 1000, score 1263-1140 (better in mirror/paper fight).
  - New pure paper vs `rotld_guess.red` (rough guess from traces using +1001/+1002/+1003 paper spacing): 670/184/146 over 1000, score 2156-698.
  - New pure paper still beats `smooth_exact.red` 987/12/1 and Dwarf 837/114/49 over 1000, so it should not give up too much if opponent reverts to a stone.
- Added scratch files `rotld_guess.red`, `scan_spl.red`, `ptmp.red`, `bench_papers.sh`; entry remains `warrior.red`.

Round 2 current note (after reviewing `/logs/rounds/1`):
- Official round 1 with `Silk Paper 1800/3740` was stronger than round 0: 2879 vs 802; sampled traces 68 wins / 22 losses / 10 draws.
- Opponent remains `returnofthelivingdead`, a fast paper/replicator with early copy spacing around +1001/+1002/+1003. No evidence of a scanner/stone switch.
- I tested alternate pure paper step sets against `rotld_guess.red` and the observed round-1 start-distance sample. Some variants (`3510/2200/777`, `2500/3740/3044`, `1001/3039/2667`) looked competitive in tiny approximation tests, but results were inconsistent by order and most lost head-to-head to the current `1800/3740/3044` paper. Because the official result is already strong and the approximation is crude, I left `warrior.red` unchanged.
- Useful command for comparing a candidate against observed start-distance distribution (candidate first):
  `perl -MJSON::PP -e 'for $f (@ARGV){open F,$f; $h=<F>; $o=decode_json($h); @s=@{$o->{starts}}; print (($s[1][0]-$s[0][0]+8000)%8000),"\n"}' /logs/rounds/1/sim_*.jsonl > distances.txt`
  then run pmars with `-F $distance candidate.red rotld_guess.red` and aggregate `Results:`.
- Keep current entry unless future logs show the opponent has adapted; if so, consider testing scissors/SPL-clear approaches, but simple oneshots tried so far lost badly to our paper and the guess.

Round 1 update vs `notepaper`:
- Official `/logs/rounds/0/results.json`: severe loss, notepaper 756 vs gpt-5-5 1. Sampled traces: 17 notepaper wins / 83 draws / 0 wins for our `Silk Paper 1800/3740`. Opponent appears as **Note Paper by Scott Nelson**, length 98, a strong paper/replicator. Snapshots show many early copies/clusters around our old paper's locations; this is no longer the previous `returnofthelivingdead` matchup.
- I could not recover the exact Note Paper source from the workspace/logs. Simple scanners/clears in scratch files (`oneshot.red`, `scan_spl.red`, `clear*.red`) performed badly against our paper variants, so switching to naive scissors looked unsafe.
- I replaced `warrior.red` with `Silk Paper 1001/3039` (same as scratch `p1001.red`): first silk step 1001, second 3039, bomb offset 2667. This is a pure paper intended for paper-vs-paper fighting; +1001 matches common paper spacing seen in earlier opponents and tested better than the old 1800/3740 entry in local head-to-head.
- Local pMARS checks (approximations only, because Note Paper source is unknown):
  - new `warrior.red` vs old `paper2.red` / 1800-3740: about 345/301/354 over 1000 when new is first, and old-vs-new gave 296/324/380 (new still ahead as second).
  - new vs `doc/examples/dwarf.red`: 880/118/2 over 1000 (still beats simple stones).
  - new vs `p3039.red`: 324/304/372 over 1000.
- This is only a modest evidence-based improvement; if future logs still show Note Paper dominating, try to infer more of its 98-line source from replay snapshots or build a proper anti-paper/scissors warrior rather than relying on pure paper step tuning.
