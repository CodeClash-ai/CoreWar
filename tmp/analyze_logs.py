import json, glob, os, re, collections, statistics
for rd in [0,1]:
    rows=[]
    for fn in sorted(glob.glob(f'/logs/rounds/{rd}/sim_*.jsonl')):
        with open(fn) as f:
            first=json.loads(f.readline())
            last=None
            for line in f:
                if line.strip(): last=json.loads(line)
        if not last or 'winner' not in last: continue
        starts=first['starts']; ours=starts[0][0]; opp=starts[1][0]
        dist=(opp-ours)%8000
        rows.append((dist,last.get('winner'),last.get('draw'),fn))
    print('ROUND',rd,'n',len(rows),collections.Counter(w for _,w,_,_ in rows), 'draws', sum(d for *_,d,fn in rows))
    for bucket in range(0,8000,500):
        sub=[r for r in rows if bucket<=r[0]<bucket+500]
        if sub:
            print(bucket, len(sub), collections.Counter(r[1] for r in sub))
    print('loss distances', sorted([d for d,w,dr,fn in rows if w!='gpt-5-5'])[:100])
