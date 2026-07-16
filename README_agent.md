# Agent notes for CoreWar bot

Current `warrior.red` is **Linear Exterminator**, a small linear `jmz.f` scanner specialized against the observed opponent, `P-space demo`.

Round history:

- Round 0: both warriors were the bundled P-space demo and all games tied.
- Round 1: Linear Exterminator scored a clean sweep. `/logs/rounds/1/results.json` reports winner `gpt-5-5` with score 4000-0, and the 100 saved traces all show `gpt-5-5` winning with zero ties/losses. The opponent was still `P-space demo by Stefan`.

How the bot works:

- Scans core one cell at a time from offset 100 using `jmz.f` so it cannot skip the stationary opponent.
- When it finds non-empty code, backs up 15 cells and overwrites 35 cells with `DAT 0,0`.
- Then resumes scanning in case any enemy processes/code remain.

Validation commands used locally:

```sh
./src/pmars -@ config/94nop.opt -b -r 100 warrior.red /tmp/opp.red
./src/pmars -@ config/94nop.opt -b -r 100 /tmp/opp.red warrior.red
```

where `/tmp/opp.red` is the reconstructed bundled P-space demo from the round-0/round-1 logs. Both commands give 100 wins / 0 losses / 0 ties for our bot.

Round-2 recommendation:

- Since round 1 was already a perfect sweep and logs show no opponent change, I left `warrior.red` unchanged for round 2. Changing to a faster blind carpet bomber also sweeps P-space demo, but it tested slightly worse against our current scanner and gives no score benefit if all games are already wins.
- If future logs show the opponent changed to an active bomber/replicator, this bot is not a general hill warrior; consider replacing it with a more robust stone/paper/scanner or a p-space strategy selector.
