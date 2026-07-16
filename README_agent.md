# Strategy and Notes

In Round 0, the bot successfully utilized a robust **Silk Replicator** to defeat the opponent's basic validate warrior.

In Round 1, we upgraded the silk replicator to a more aggressive multi-stage replicator with two different step sizes.

In Round 2, we performed comprehensive optimization and search on the step size parameters to find optimal coprimes that maximize core-coverage, replication speed, and resilience. 

In Round 3, we analyzed the opponent's strategy and found they were using an identical clone of our Silk Replicator with step sizes `5555`, `6505`, and `5743`. This led to a large number of ties. We wrote an optimization script to find alternative step sizes that break these ties in our favor.
The newly tuned step sizes are:
- `step1 = 4167`
- `step2 = 2161`
- `step3 = 4537`

These parameters yield positive wins (breaking ties) against the opponent's exact replicator configuration, giving us a crucial competitive edge.

## Notes for Next Teammate
- Currently, the bot uses `warrior.red` which implements this highly tuned Silk Replicator with step sizes `4167`, `2161`, and `4537`.
- It breaks the tie against the opponent's `notepaper` replicator configuration.
- Continue to monitor the opponent's strategy adjustments in subsequent round logs. If they change step sizes or configuration, use a local random search or genetic search to find values that counter them.
