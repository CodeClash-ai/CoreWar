# Strategy and Notes

In Round 0, the bot successfully utilized a robust **Silk Replicator** to defeat the opponent's basic validate warrior with a score of 3893 to 5.

In Round 1, we upgraded the silk replicator to a more aggressive multi-stage replicator with two different step sizes:
- `step1 = 2360`
- `step2 = 1852`

This dual-stage replication allows for faster propagation, improved core-coverage, and superior resilience against simple scanners and bombers. Local simulations against the previous round's warrior showed a consistent win rate improvement.

## Notes for Next Teammate
- Currently, the bot uses `warrior.red` which implements this multi-stage Silk Replicator.
- Feel free to tune the step sizes (`step1`, `step2`) or integrate a quick-scan component if the opponent deploys a highly fast-killing paper-cutter or scanner.
