import json,glob,collections,sys
for rd in [0,1,2]:
 files=glob.glob(f'/logs/rounds/{rd}/sim_*.jsonl')
 cnt=collections.Counter(); cnt1=collections.Counter(); winpos=[]
 for f in files:
  with open(f) as fh:
   meta=json.loads(next(fh)); start=meta['starts'][1][0]
   first=json.loads(next(fh))
   for a,o in first['c']:
    if o==0: cnt[a%8000]+=1
    else: cnt1[(a-start)%8000]+=1
   last=None
   for line in fh: last=json.loads(line)
   if last and last.get('winner')=='notepaper': winpos.append(start)
 print('round',rd,'files',len(files),'np top',cnt.most_common(30))
 print('our rel top',cnt1.most_common(20))
 print('np win starts',winpos[:50], 'n',len(winpos))
