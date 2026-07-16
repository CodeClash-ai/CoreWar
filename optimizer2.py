import subprocess
import random

def make_warrior(s1, s2):
    return f""";redcode-94
;name Silk Warrior 3
;author Silk
;strategy Replicator (Silk)
;assert VERSION >= 80

step1   equ {s1}
step2   equ {s2}

init    spl     1,      <3000
        spl     1,      <4000
        spl     1,      <5000

silk1   spl     @0,     step1
        mov.i   }}silk1, >silk1
silk2   spl     @0,     step2
        mov.i   }}silk2, >silk2
        mov.i   bmb,    >1000
        jmp     silk1,  <2000
bmb     dat     #0,     #0

end init
"""

def evaluate(s1, s2, opponent="doc/examples/dwarf.red"):
    with open("temp_opt.red", "w") as f:
        f.write(make_warrior(s1, s2))
    
    cmd = ["./src/pmars", "-r", "1000", "-s", "8000", "-c", "80000", "-p", "8000", "-l", "100", "-d", "100", "temp_opt.red", opponent]
    res = subprocess.run(cmd, capture_output=True, text=True)
    
    lines = res.stdout.strip().split("\n")
    if not lines:
        return 0, 0, 0
    last_line = lines[-1]
    if "Results:" in last_line:
        parts = last_line.split()
        wins1 = int(parts[1])
        ties = int(parts[2])
        wins2 = int(parts[3])
        return wins1, ties, wins2
    return 0, 0, 0

best_score = 0
best_steps = (1761, 2407)

# evaluate baseline first against dwarf
w, t, l = evaluate(1761, 2407)
best_score = w * 3 + t
print(f"Baseline (1761, 2407) vs Dwarf: wins={w}, ties={t}, losses={l}, score={best_score}")

# Let's perform a comprehensive grid search or randomized search to find step values with even higher winrates/scores
for i in range(250):
    s1 = random.randint(1000, 4000)
    s2 = random.randint(1000, 4000)
    
    # We want s1 and s2 to be coprimes, and not divisible by 2, 3, 5, etc. if possible, or just odd numbers
    if s1 % 2 == 0 or s2 % 2 == 0:
        continue
    
    w, t, l = evaluate(s1, s2)
    score = w * 3 + t
    if score > best_score:
        best_score = score
        best_steps = (s1, s2)
        print(f"New best: {best_steps} with score {best_score} (wins={w}, ties={t}, losses={l})")

print(f"Best steps found: {best_steps}")
