# CoreWar Bot - Agent Notes

## Entry point
- `warrior.red` is the bot submitted each round. It is a Redcode '94 warrior.
- Match settings (from config/94.opt, confirmed by logs):
  coresize 8000, cycles 80000, max processes 8000, max length 100, standard '94.
- The compiled simulator is `./src/pmars`. Test with:
  `./src/pmars -r 50 -s 8000 -c 80000 -p 8000 -l 100 warrior.red OPPONENT.red`
  Output line "Results: W L T" is for the FIRST warrior (wins losses ties).
  Score: win=3pts, tie=1pt (standard KOTH).

## Round 0 (before my edits)
- Both teams shipped the default "P-space demo" warrior => 100% ties, 0-0.
- Opponent name "pspace" — currently passive/non-competitive default warrior.

## My change (round 1)
Replaced the demo with **Silkweaver**, a silk-style self-replicating "paper".
- SPL step tuned to 2667 (tested 2000..4500). Smaller step = more resilient to
  dedicated bombers; 2667 is best balance.
- Test results (50 rounds each, W-L-T for Silkweaver):
  - vs demo warrior: wins big (~decisive)
  - vs imp: 22-0-28 (NEVER loses to imps — important)
  - vs scanner (Blur): ~even/slightly ahead
  - vs strong bomber (dwarf step): loses ~66-84 (papers' main weakness)

## Known weaknesses / ideas for next teammate
- A well-tuned bomber/stone can beat a pure paper. If the opponent switches to a
  bomber, consider:
  1. Paper+Stone hybrid (replicate + carpet bomb).
  2. A proper scanner (my quick attempts at scanners underperformed — needs work).
  3. Adding an imp-launcher for tie insurance.
- Test any change against /tmp opponents by rebuilding them, OR keep opponent
  warriors in a `test_opponents/` dir (create it).
- Use `./analyze_logs.sh N` to inspect round N's results/trace in /logs/rounds/N.

## Key insight
Robustness (never losing) matters as much as winning. Silk never loses to imps
and beats passive warriors — a safe baseline. Improve aggression only if the
opponent proves to run an active bomber.

## Round 2 (opus-4-8 team)
- Opponent still ran the passive "P-space demo by Stefan" (assembles to `jmp 0`,
  stationary at cell 0, never attacks). Round 1 we won 2212 vs 4.
- Round 1 issue: 42% of battles were TIES (silk filled core but didn't kill the
  single stationary opp process before cycle limit).
- Tuned Silkweaver SPL step from 2667 -> **3600**. Larger step spreads copies
  wider/faster so the paper covers the opponent's cell more reliably.
  Big-sample results vs demo (pmars, coresize 8000):
    step=2667: ~583-2-415 /1000
    step=2900: ~599-6-395 /1000
    step=3600: ~640-4-350 /1000  (BEST, +10% win rate, converts ties to wins)
  Imp-safety preserved (0 losses vs imp at 3600).
- Tuning method: sweep step, run `pmars -r 1000+` vs test_opponents/pspace_demo.red
  AND test_opponents/imp.red (never lose to imp). Watch run-to-run variance;
  average 3 runs before deciding.

## Ideas if opponent upgrades
- Paper still loses to a dedicated bomber (d4: ~130-170). If logs show the
  opponent switched to an active bomber/scanner, revisit a paper+stone hybrid
  (my quick hybrid attempt underperformed - the stone slows the paper). A proper
  imp-gate or well-tuned scanner would help, but needs careful work.
