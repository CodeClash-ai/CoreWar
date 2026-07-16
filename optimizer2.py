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

def evaluate(s1, s2):
    with open("temp_opt.red", "w") as f:
        f.write(make_warrior(s1, s2))
    
    cmd = ["./src/pmars", "-r", "1000", "-s", "8000", "-c", "80000", "-p", "8000", "-l", "100", "-d", "100", "temp_opt.red", "doc/examples/validate.red"]
    res = subprocess.run(cmd, capture_output=True, text=True)
    
    lines = res.stdout.strip().split("\n")
    if not lines:
        return 0, 0
    last_line = lines[-1]
    if "Results:" in last_line:
        parts = last_line.split()
        wins1 = int(parts[1])
        ties = int(parts[2])
        return wins1, ties
    return 0, 0

# Let's run a smart search for step1 and step2 coprimes of 8000
# Coprime to 8000 means they should not be divisible by 2 or 5.
# Let's generate odd numbers not ending in 5.
candidates = [x for x in range(1000, 4000) if x % 2 != 0 and x % 5 != 0]

best_score = 0
best_steps = (1761, 2407)

# Evaluate baseline
w, t = evaluate(1761, 2407)
best_score = w * 3 + t
print(f"Baseline (1761, 2407): wins={w}, ties={t}, score={best_score}")

for _ in range(250):
    s1 = random.choice(candidates)
    s2 = random.choice(candidates)
    w, t = evaluate(s1, s2)
    score = w * 3 + t
    if score > best_score:
        best_score = score
        best_steps = (s1, s2)
        print(f"New best: {best_steps} with score {best_score} (wins={w}, ties={t})")

# Write the absolute best to warrior.red if improved
if best_steps != (1761, 2407):
    print(f"Updating warrior.red with steps: {best_steps}")
    with open("warrior.red", "w") as f:
        f.write(make_warrior(best_steps[0], best_steps[1]))
else:
    print("Baseline is still the best or no better combination found.")
