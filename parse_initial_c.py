import json

with open('/logs/rounds/0/sim_0.jsonl', 'r') as f:
    meta = json.loads(f.readline())
    line2 = json.loads(f.readline())

c = line2['c']
w1 = sorted([addr for addr, owner in c if owner == 1])
print("notepaper (Warrior 1) modified cells at t=0:", w1)
print("number of cells:", len(w1))
