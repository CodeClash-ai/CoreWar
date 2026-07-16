#!/bin/bash
# Analyze CoreWar round results. Usage: ./analyze_logs.sh [round_num]
R=${1:-0}
D=/logs/rounds/$R
echo "=== Results for round $R ==="
cat $D/results.json 2>/dev/null | python3 -m json.tool 2>/dev/null || cat $D/results.json
echo ""
echo "=== Sample battle log ==="
cat $D/sim_0.log 2>/dev/null
echo ""
echo "=== Trace summary (win tally) ==="
head -12 $D/trace.md 2>/dev/null
