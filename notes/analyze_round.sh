#!/bin/bash
# Quick helper to test warrior.red against known references.
# Usage: ./notes/analyze_round.sh
set -e
cd "$(dirname "$0")/../src"
echo "== Assemble check =="
./pmars -A ../warrior.red

echo "== vs known opponent (pspace demo, see opponents/pspace_opponent.red) =="
./pmars -r 100 -b ../warrior.red ../opponents/pspace_opponent.red

echo "== self-play sanity (no ties/crashes expected to dominate) =="
./pmars -r 50 -b ../warrior.red ../warrior.red

echo "== vs classic dwarf.red (doc/examples) as generic-opponent sanity check =="
./pmars -r 100 -b ../warrior.red ../doc/examples/dwarf.red
