;redcode
;name Trinity
;author Matt Hastings

start mov s7,<ptr3
      mov s6,<ptr3
      mov s5,<ptr3
arb   mov s4,<ptr3
      mov s3,<ptr3
arb2  mov s2,<ptr3
      mov s1,<ptr3
      mov b1,arb2+300+5
      mov b1,arb2+300+3
      mov r4,<ptr2
      mov r3,<ptr2
      mov r2,<ptr2
      mov r1,<ptr2
      mov ro,<ptr2
      mov rm,<ptr2
      mov t1,arb2+324
      mov t2,arb2+325
      mov s5a,<ptr1
      mov s4a,<ptr1
      mov s3,<ptr1
      mov s2a,<ptr1
      mov s1,<ptr1
      spl start+300
      jmp start+300-5168
ptr2  dat #0,#arb+306-2584
ptr1  dat #0,#start+305-5168
ptr3  dat #0,#start+307
      dat #0,#0
s1    add 3,1
s2    mov <-2587-1-8, +2585-1
s3    djn -2,#499
s4    spl -2584,+2584
s4a   spl 2584,-2584
s2a   mov <2580-8,-2584
s5    spl 0,-1
s5a   jmp 5168,0
s6    mov 5,<4
s7    jmp -1,0
b1    dat #0, #-5
rm    spl 0,0
ro    mov 3,      @3
r1    add 3,      3
r2    jmp -2,     0
r3    jmp rm+2584+2+24+948+4, -4-948
r4    dat #948,   #-948
t1    spl 0,0
t2    jmp -1,0
