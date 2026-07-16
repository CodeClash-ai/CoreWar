#!/bin/sh
makew(){ name=$1; shift; cat > tmp/$name.red <<EOF
;redcode-94
;name $name
;assert CORESIZE==8000
EOF
 cat >> tmp/$name.red
}
makew imp <<'EOF'
step equ 2667
start spl 1
      spl 1
      spl 1
      spl 2
      jmp imp
      add #step,-1
imp   mov.i #step,*0
      end start
EOF
makew clear2 <<'EOF'
start spl 1
      spl 1
      spl 1
      spl c2
c1    mov.i bomb, >p1
      djn.f c1, >p1
c2    mov.i bomb, <p2
      djn.f c2, <p2
p1    dat #0,#100
p2    dat #0,#-100
bomb  dat #0,#0
      end start
EOF
makew splclear <<'EOF'
start spl 1
      spl 1
      spl 1
      spl c2
c1    mov.i sb, >p1
      mov.i db, >p1
      jmp c1
c2    mov.i sb, <p2
      mov.i db, <p2
      jmp c2
p1    dat #0,#100
p2    dat #0,#-100
sb    spl #0,#0
db    dat #0,#0
      end start
EOF
makew qbomb <<'EOF'
step equ 1000
start spl b1
      spl b2
      spl b3
      spl b4
      spl b5
      spl b6
      spl b7
      jmp b0
b0    mov.i db, 1000
      add.ab #step, b0
      jmp b0
b1    mov.i db, 2000
      add.ab #step, b1
      jmp b1
b2    mov.i db, 3000
      add.ab #step, b2
      jmp b2
b3    mov.i db, 4000
      add.ab #step, b3
      jmp b3
b4    mov.i db, 5000
      add.ab #step, b4
      jmp b4
b5    mov.i db, 6000
      add.ab #step, b5
      jmp b5
b6    mov.i db, 7000
      add.ab #step, b6
      jmp b6
b7    mov.i db, 8000
      add.ab #step, b7
      jmp b7
db    dat #0,#0
      end start
EOF
for w in tmp/imp.red tmp/clear2.red tmp/splclear.red tmp/qbomb.red; do echo $w; ./src/pmars -b -r 300 $w tmp/rotld_guess.red | tail -1; done
