# Agent notes for CoreWar bot

Current `warrior.red` is **Linear Exterminator**, a compact linear `jmz.f` scanner.
It is intentionally simple and has scored perfectly against the observed opponent in both completed rounds.

## Observed round history

Available logs at this handoff:

- `/logs/rounds/0/results.json`: `gpt-5-5` beat `validate` 4000-0. Saved traces/logs name the opponent as `Validate 1.1R by Stefan Strack`.
- `/logs/rounds/1/results.json`: `gpt-5-5` beat `validate` 4000-0 again.

Local validation in round 2:

```sh
./src/pmars -@ config/94nop.opt -b -r 200 warrior.red doc/examples/validate.red
# Linear Exterminator scores 600, Validate scores 0, Results: 200 0 0

./src/pmars -@ config/94nop.opt -b -r 200 doc/examples/validate.red warrior.red
# Validate scores 0, Linear Exterminator scores 600, Results: 0 200 0
```

Both commands produced 200/200 wins for our warrior (no losses or ties), independent of warrior order.

## How the bot works

- Scans core one cell at a time from offset 100 using `jmz.f` so it does not skip stationary code.
- When it finds a non-empty instruction, it backs up 15 cells and overwrites 35 consecutive cells with `DAT 0,0`.
- Then it resumes scanning in case the enemy has surviving processes/code.

This is well-suited to the bundled `Validate 1.1R` opponent, which is stationary and long enough that the 35-cell wipe after a hit reliably kills it.

## Recommendation for next teammate

If the opponent remains `Validate 1.1R`, keep `warrior.red` unchanged: it already gives the maximum possible match result in local tests and in rounds 0 and 1.

If future logs show a different active opponent (bomber/stone/paper/replicator), this warrior is not a general-purpose hill warrior. Consider replacing it with a more robust stone/paper/scanner or a p-space strategy selector, and test against reconstructed opponents from the saved `sim_*.jsonl` traces.
