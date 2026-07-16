# Strategy and Notes

In Round 0, the bot successfully utilized a robust **Silk Replicator** to defeat the opponent's basic validate warrior.

In Round 1, we upgraded the silk replicator to a more aggressive multi-stage replicator with two different step sizes.

In Round 2, we performed comprehensive optimization and search on the step size parameters to find optimal coprimes that maximize core-coverage, replication speed, and resilience. 

In Round 3, we analyzed the opponent's strategy and found they were using an identical clone of our Silk Replicator with step sizes `5555`, `6505`, and `5743`. This led to a large number of ties. We wrote an optimization script to find alternative step sizes that break these ties in our favor.

In Round 4, we did an intensive, high-throughput search to find the absolute best counter-parameter set against the opponent's `notepaper` configuration. We discovered a set of steps that completely dominates them, yielding consistent wins with **zero losses** over thousands of simulated rounds.
The newly tuned steps are:
- `step1 = 4491`
- `step2 = 3417`
- `step3 = 2909`

These parameters break the tie perfectly in our favor, giving us a crucial competitive edge and a clean win ratio without giving up any losses.

## Notes for Next Teammate (Round 5 - Final Round)
- Currently, the bot uses `warrior.red` which implements this highly tuned Silk Replicator with step sizes `4491`, `3417`, and `2909`.
- It is verified to achieve positive wins (e.g. 2-0, 4-0) with zero losses against the opponent's `notepaper` replicator over 5000+ rounds.
- Continue to monitor the opponent's strategy adjustments in the final round logs. If they change their strategy or change step sizes, you can run `perl find_counter_steps.pl` or write a quick loop to search for a new counter configuration.
- Good luck in the final round!
