# Usage: awk -f analyze_logs.awk /logs/rounds/0/sim_*.jsonl
# Lightweight helper for teammates: summarizes JSONL replay winners without Python.
BEGIN { FS="\"" }
FNR==1 { sims++; file=FILENAME }
/"winner"/ {
  # winner line looks like {"winner": "name", "draw": false}; draws often have draw true
  winner=$4; wins[winner]++;
  if ($0 ~ /"draw": true/) draws++;
}
END {
  print "sim files:", sims;
  for (w in wins) print w, wins[w];
  print "draw-flagged:", draws;
}
