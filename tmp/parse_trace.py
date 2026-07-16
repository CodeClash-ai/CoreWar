import json,glob,collections,sys
for rd in [0,1]:
 print('ROUND',rd)
 for fn in sorted(glob.glob(f'/logs/rounds/{rd}/sim_*.jsonl'))[:5]:
  with open(fn) as f:
   first=json.loads(f.readline()); s0,l0=first['starts'][0]; s1,l1=first['starts'][1]
   print(fn,'starts',first['starts'])
   for i,line in zip(range(1,8),f):
    o=json.loads(line); print(' t',o.get('t'),'p',[(x-s0)%8000 for x in o.get('p',[])], 'n',o.get('n'),'d',o.get('d'))
    cs=[((a-s0)%8000,w) for a,w in o.get('c',[]) if w==0]
    print('  own0',cs[:50])
   print()
