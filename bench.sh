#!/bin/sh
makewar(){ kind=$1; step=$2; off=$3; cat > tmp.red <<EOR
;redcode-94nop
;name $kind-$step-$off
;assert CORESIZE==8000
start spl 0
      mov.i bomb, @ptr
      add.ab #$step, ptr
      jmp -2
ptr   dat #0, #$off
bomb  dat #0, #0
end start
EOR
}
for step in 3 7 13 17 21 37 47 73 97 127 3039 3044; do for off in 0 10 50 100 500 1000 2000 4000; do makewar s $step $off; res=$(./src/pmars -@ config/94nop.opt -b -r 100 tmp.red doc/examples/dwarf.red 2>/dev/null | tail -1); python3 - <<PY
import re
s='$res'; m=re.search(r'Results: (\d+) (\d+) (\d+)',s); w,l,t=map(int,m.groups()); print('$step $off',w*3+t,l*3+t,w,l,t)
PY
done; done | sort -k3 -nr | head -20
