;redcode
;name Hordes of Microwarriors
;author David Moore
;strategy Launch hordes of microwarriors
;assert CORESIZE == 8000

spl 1, 0
spl 1, 0
mov -1, 0

spl 0, <2
mov 0, <1
mov 4, 978
add #2201, @-2
mov -4, @-2
jmp @-3, 0
djn -2, #6970

end

