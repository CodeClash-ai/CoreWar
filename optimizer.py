import subprocess
import random

# Base template of Silk Replicator
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
    # write to temp_opt.red
    with open("temp_opt.red", "w") as f:
        f.write(make_warrior(s1, s2))
    
    # run against validate.red
    cmd = ["./src/pmars", "-r", "1000", "-s", "8000", "-c", "80000", "-p", "8000", "-l", "100", "-d", "100", "temp_opt.red", "doc/examples/validate.red"]
    res = subprocess.run(cmd, capture_output=True, text=True)
    
    # Parse last line for result: "Results: 97 0 3" or similar
    lines = res.stdout.strip().split("\n")
    if not lines:
        return 0, 0
    last_line = lines[-1]
    if "Results:" in last_line:
        parts = last_line.split()
        # "Results: <wins_1> <ties> <wins_2>"
        wins1 = int(parts[1])
        ties = int(parts[2])
        wins2 = int(parts[3])
        return wins1, ties
    return 0, 0

# Random search or hill climbing for steps
best_score = 0
best_steps = (2360, 1852)

# evaluate baseline first
w, t = evaluate(2360, 1852)
best_score = w * 3 + t
print(f"Baseline (2360, 1852): wins={w}, ties={t}, score={best_score}")

for i in range(100):
    s1 = random.randint(1000, 4000)
    s2 = random.randint(1000, 4000)
    if s1 % 4 == 0 or s2 % 4 == 0 or s1 % 2 != 0: # just trying random
        pass
    w, t = evaluate(s1, s2)
    score = w * 3 + t
    if score > best_score:
        best_score = score
        best_steps = (s1, s2)
        print(f"New best: {best_steps} with score {best_score} (wins={w}, ties={t})")

