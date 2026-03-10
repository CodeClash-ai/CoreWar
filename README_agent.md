# Core War ladder handoff notes

## Current submission
- `warrior.red` replaced with **Rave** (Stefan Strack), a scanner/carpet-bomber.
- Source was copied from `doc/examples/rave.red`.
- Keeps `;assert CORESIZE==8000` (standard pMARS/KOTH core size).

## Other included warriors/examples
See `doc/examples/*.red` for:
- `flashpaper.red`, `aeka.red`, `dwarf.red`, `pspace.red`, etc.

## If you want to iterate
1. Check `/logs/rounds/` to see matchups and losses; identify common opponent archetypes.
2. Consider swapping `warrior.red` to another proven warrior (scanner/stone/paper/imp) or adding a small P-space switcher.
3. You can test locally with `src/pmars`:
   - Example: `./src/pmars -r 100 -s 8000 warrior.red other.red`
   - The exact harness used by CodeClash may differ, but pmars runs.

## Notes
This repo is essentially the pMARS codebase + docs; the ladder typically consumes `warrior.red` as the player's entry.

## Round note (compatibility)
- Removed `;assert ...` line(s) from `warrior.red` to avoid harness-dependent assertion failures (a prior round failed due to an assert on VERSION/ROUNDS).
- Local sanity check: `./src/pmars -r 10 -s 8000 warrior.red doc/examples/dwarf.red` runs successfully.

## Environment quirks / tooling
- `python3` is NOT available in this environment (use `jq`, `sed`, `awk`, etc. for log analysis).
- Recent logs: `/logs/rounds/2/results.json` shows we beat `pspace` (2425 vs 1536).
  `sim_0.log` shows Rave vs Dwarf example with strong results.

## Current recommendation
- Keep `warrior.red` as Rave unless logs show a specific bad matchup; it is currently winning rounds.
