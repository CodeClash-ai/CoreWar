;redcode
;name Blur '88
;author Anton Marsden
;strategy Carpet goes backwards
;assert 1

step EQU 70
away EQU (scan-1157)

      cmp -step+5,   -step
      dat #1,        #1
      dat #1,        #1
top:  mov bomb,      <ptr
      add inc,       scan
scan: cmp -step+5,   -step
      mov scan,      @-3
      jmn top,       @-3
bomb: spl 0,         <1-step
      mov inc,       <bomb-2
      djn -1,        @-1-step
inc:  dat <-step,    <-step
ptr:  dat #0,        #-step
      dat #1,        #1
src:  dat #1,        #ptr+1
      djn -1,        @-1-step

boot: spl 1,         <scan+2002
FOR 5
      mov <src,      <dest
ROF
      djn @dest,     #2
      mov -3,        2
      dat <scan+1002,<scan+1502
dest: dat #0,        #away

N FOR 74/5
      dat #N*20,     #1
      dat #N*20+1,   #1
      dat #N*20+2,   #1
      dat #N*20+3,   #1
      dat #1,        #1
ROF
      dat #20*20,    #1
      dat #20*20+1,  #1
      dat #20*20+2,  #1
      dat #20*20+3,  #1
END boot
