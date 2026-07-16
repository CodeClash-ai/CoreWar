import subprocess
import random
import sys

def make_warrior(s1, s2, s3):
    return f""";redcode-94
;name Silk Warrior 3
;author Silk
;strategy Replicator (Silk) with optimized step sizes
;assert VERSION >= 80

step1   equ {s1}
step2   equ {s2}
step3   equ {s3}

init    spl     1,      <3445
        spl     1,      <5005
        spl     1,      <5366

silk1   spl     @0,     step1
        mov.i   }}silk1, >silk1
silk2   spl     @0,     step2
        mov.i   }}silk2, >silk2
silk3   spl     @0,     step3
        mov.i   }}silk3, >silk3
        mov.i   bmb,    >1000
        jmp     silk1,  <2000
bmb     dat     #0,     #0

end init
"""

def evaluate(s1, s2, s3, rounds=200):
    with open("temp_opt.red", "w") as f:
        f.write(make_warrior(s1, s2, s3))
    
    cmd = ["./src/pmars", "-r", str(rounds), "-s", "8000", "-c", "80000", "-p", "8000", "-l", "100", "-d", "100", "temp_opt.red", "notepaper.red"]
    res = subprocess.run(cmd, capture_output=True, text=True)
    
    lines = res.stdout.strip().split("\n")
    if not lines:
        return 0, 0, 0
    last_line = lines[-1]
    if "Results:" in last_line:
        parts = last_line.split()
        # Results: wins_temp losses_temp ties
        # wait, the order of results output from pmars:
        # Program 1 scores X
        # Program 2 scores Y
        # Results: wins_of_prog1 wins_of_prog2 ties
        # Since temp_opt is prog1, wins is parts[1], losses is parts[2], ties is parts[3]
        try:
            w = int(parts[1])
            l = int(parts[2])
            t = int(parts[3])
            return w, l, t
        except Exception:
            pass
    return 0, 0, 0

# Test current baseline first
w, l, t = evaluate(4167, 2161, 4537, rounds=1000)
print(f"Current warrior.red (4167, 2161, 4537) against Notepaper (1000 rounds): wins={w}, losses={l}, ties={t}")

candidates = [x for x in range(1000, 8000) if x % 2 != 0 and x % 5 != 0]

best_diff = -9999
best_steps = None
results_list = []

print("Starting random search of 2000 iterations...")
for i in range(2000):
    s1 = random.choice(candidates)
    s2 = random.choice(candidates)
    s3 = random.choice(candidates)
    w, l, t = evaluate(s1, s2, s3, rounds=200)
    diff = w - l
    if diff > best_diff or (diff == best_diff and w > 0):
        best_diff = diff
        best_steps = (s1, s2, s3)
        print(f"Iter {i}: New best steps {best_steps} with diff {diff} (wins={w}, losses={l}, ties={t})")
    if diff >= 0:
        results_list.append((diff, w, l, t, s1, s2, s3))

print("\nRunning verification on top candidates with 2000 rounds...")
results_list.sort(key=lambda x: (x[0], x[1]), reverse=True)
top_candidates = results_list[:20]

# Also verify the baseline
top_candidates.append((0, 0, 0, 0, 4167, 2161, 4537))

verified_results = []
for diff, w, l, t, s1, s2, s3 in top_candidates:
    vw, vl, vt = evaluate(s1, s2, s3, rounds=2000)
    vdiff = vw - vl
    verified_results.append((vdiff, vw, vl, vt, s1, s2, s3))
    print(f"Verify ({s1}, {s2}, {s3}): wins={vw}, losses={vl}, ties={vt}, diff={vdiff}")

verified_results.sort(key=lambda x: (x[0], x[1]), reverse=True)
best_vdiff, best_vw, best_vl, best_vt, bs1, bs2, bs3 = verified_results[0]
print(f"\nABSOLUTE BEST: ({bs1}, {bs2}, {bs3}) with diff {best_vdiff} (wins={best_vw}, losses={best_vl}, ties={best_vt})")

# Write to warrior.red
with open("warrior.red", "w") as f:
    f.write(make_warrior(bs1, bs2, bs3))
print("Wrote best to warrior.red!")
