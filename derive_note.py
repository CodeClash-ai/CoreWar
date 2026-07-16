#!/usr/bin/env python3
import json, glob, collections
for fn in sorted(glob.glob('/logs/rounds/0/sim_*.jsonl'))[:3]:
    with open(fn) as f:
        header=json.loads(f.readline())
        rec=json.loads(f.readline())
    own=[a for a,w in rec['c'] if w==0]
    print(fn, 'start0', header['starts'][0], 'count',len(own))
    print(sorted(own))
