;redcode
;name ttti
;author nandor sieben
;assert 1

d        equ 1143
s        equ 571
offset   dat #5138 ,#-5138
twill    spl 0
         sub offset,1
         mov <0,0
         jmp -2,0

        dat #0
        dat #0

start
	spl twill
        spl twill
        mov imp,imp+s
        spl 1
        spl 16
        spl 8
        spl 4
        spl 2
        jmp imp+(d*0)
        jmp imp+(d*1)
        spl 2
        jmp imp+(d*2)
        jmp imp+(d*3)
        spl 4
        spl 2
        jmp imp+(d*4)
        jmp imp+(d*5)
        spl 2
        jmp imp+(d*6);+s
        jmp imp+(d*7);+s

        spl 8
        spl 4
        spl 2
        jmp imp+(d*8);+s
        jmp imp+(d*9);+s
        spl 2
        jmp imp+(d*10);+s
        jmp imp+(d*11);+s
       spl twill
       spl twill
       spl twill
        jmp twill
        dat #0

imp     mov 0,1143
        end start
