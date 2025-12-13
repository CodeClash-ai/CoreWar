;redcode-94nop
;name One bite
;author inversed
;strategy q^i -> One-hit vampire with airbag
;assert (CORESIZE==8000) && (MAXPROCESSES==8000)

;     Vampiring  is a strategy  that  is rarely  used  nowadays,  but  has a big
; potential.  One bite (pushed  off at the age of 101 @ 94nop)  is an attempt to
; make a modern vampire. It is a pure vampire in the sense that it does not uses
; scanning  and only throws  jmp bombs at .33c.  It may not seem like much,  but
; other advantages (airbag, slim profile) compensate for low speed.
;     Enemy is vamped into djn #0, #0 pit. When main loop detects that the enemy
; process  has been trapped,  it jumps to SSD clear that immediately  overwrites
; the pit with spl carpet.  When fighting a scanner,  there is a chance that SSD
; clear has been found and overwritten  with SPLs.  Even in this case,  One bite
; may  still get a win if it manages  to hit the enemy,  as the trapped  process
; will eventually fall through the djn pit and die.
;     Step that forms a pattern  where bombs are 7 cells apart is used,  because
; we  don't want  to accidentally  stun  ourselves  if djn  in the  clear  falls
; through, and that requires a gap of 6 cells between jmp bombs.

;-------Vamp-------------------------------
step	equ	2511	;mod~7
time	equ	1180
phaze	equ	step*time

;-------Clear------------------------------
safe	equ	14
djs	equ	260
zclear	equ	(gap1+gap2+gap3+clen+clen-4)
cptr	equ	(bptr-gap1-1)

;-------Boot-------------------------------
gap1	equ	5
gap2	equ	17
gap3	equ	13

clen	equ	5
bdist	equ	2488
total	equ	(clen+clen+gap2+gap3+2)
btweak	equ	(-btab+pit+gap2-clen-1)
relptr	equ	(inc+clen+gap3)
relpit	equ	(relptr+1)

;------qScan-------------------------------
qbstep	equ	7
qbhop	equ	-87
qbcnt	equ	20
qxa	equ	2086
qxb	equ	2512
qa1	equ	5354
qa2	equ	5514
qb1	equ	6352
qb2	equ	4163
qstep	equ	2379
nil	equ	(-CURLINE-1)

;-------Misc-------------------------------
x0	equ	bptr
org	qgo

;------------------------------------------

bptr	dat	1,	safe
cs0	spl	#djs,	zclear
clear	mov	*bptr,	>cptr
	mov	*bptr,	>cptr
	djn.f	clear,	}cs0

inc	nop	#-step,		step
loop	add	inc,		relptr
	mov	<relpit,	@relptr
	jmn	loop,		>relpit
	jmp	cs0-gap2,	0

ptr	jmp	phaze,	pit-phaze
pit	djn	#0,	#0

copy	mov	<btab,		{bootptr
	mov	<btab,		{bootptr
	mov	<btab,		{bootptr
boot	mov	<btab,		{bootptr
	mov	<btab,		{bootptr
	sub.ba	}btab,		bootptr
	djn	copy,		#3

	add.a	#btweak,	bootptr

	nop	0,	gap3
	spl	1,	gap2
btab	spl	-2,	pit+1

bootptr	jmp	x0+bdist+total,	}0

	;				--------~~~~~~~~([ instant ])~~~~~~~~--------				;
qgo	sne	found+qxa					,	found+qxb
	seq	found+qxa+qstep					,	found+qxb+qstep
	jmp	decide,	0

	;				--------~~~~~~~~([+0 cycles])~~~~~~~~--------				;
	sne	found+qxa*qa2					,	found+qxb*qb2
	seq	found+qxa*qa2+qstep				,	found+qxb*qb2+qstep
	jmp	dec0de,	0

	sne	found+qxa*qa1					,	found+qxb*qb1
	seq	found+qxa*qa1+qstep				,	found+qxb*qb1+qstep
	jmp	dec0de,	<dec1

	sne	found+qxa*(qa2-1)				,	found+qxb*(qb2-1)
	seq	found+qxa*(qa2-1)+qstep				,	found+qxb*(qb2-1)+qstep
	djn.f	dec0de,	qtab

	sne	found+(qxa-1)*qa2				,	found+(qxb-1)*qb2
	seq	found+(qxa-1)*qa2+qstep				,	found+(qxb-1)*qb2+qstep
	djn.f	dec0de,	found

	;				--------~~~~~~~~([+1 cycle ])~~~~~~~~--------				;
	sne	found+qxa*((qa2*qb2)%CORESIZE)			,	found+qxb*((qa2*qb2)%CORESIZE)
	seq	found+qxa*((qa2*qb2)%CORESIZE)+qstep		,	found+qxb*((qa2*qb2)%CORESIZE)+qstep
	jmp	dec1,	0

	sne	found+qxa*(((qa2+1)*qb2)%CORESIZE)		,	found+qxb*(((qa2+1)*qb2)%CORESIZE)
	seq	found+qxa*(((qa2+1)*qb2)%CORESIZE)+qstep	,	found+qxb*(((qa2+1)*qb2)%CORESIZE)+qstep
	jmp	dec1,	}qtab

	sne	found+qxa*((qa2*(qb2-1))%CORESIZE)		,	found+qxb*((qa2*(qb2-1))%CORESIZE)
	seq	found+qxa*((qa2*(qb2-1))%CORESIZE)+qstep	,	found+qxb*((qa2*(qb2-1))%CORESIZE)+qstep
	jmp	dec1,	<qtab

	jmp	boot,	0

dec1	mul.x	qtab,	qtab
dec0de	mul	@dec1,	found

	;decide - 1 + 0.5 + 1 + 0.5 = 3 cycles (average)
decide	sne	*found,	@found
	add	qinc,	found
	seq	nil,	*found
	mov.x	found,	found

qbloop	mov	qbomb,		@found
found	mov	qxa,		}qxb
	add	#qbstep,	found
	djn	qbloop,		#qbcnt
	jmp	boot,		0
qbomb	dat	>qbhop,		>1

	dat	qa1,	qb1
qtab	dat	qa2,	qb2

qinc	dat	qstep,	qstep
