;redcode
;name Lithobolia C yvfp
;author Steve Gunnell
;strategy Stone throwing devil to you :p
;strategy Launch many simple stones and a paper.
;strategy Stole a qscan from John.
;assert CORESIZE==8000

; qscan - 36 scans in 48 instructions

QGAP	equ	1168

qfirst	equ	(qp2+2*qstep)
qdist	equ	qfirst+QGAP
qstep	equ	(QGAP+QGAP)

qi	equ	5
qr	equ	10

qbomb	dat	<qi/2-qi*qr, <qi*qr-qi/2

qa	equ	qstep*16
qb	equ	qstep*5+2
qc	equ	qstep*10
qd	equ	qstep*2
qe	equ	qstep*1

qscan	cmp	qdist+qc, qfirst+qc
	jmp	qfast, <qa
	cmp	qdist+qe+qd, qfirst+qe+qd
qp1	jmp	<qfast, <qc
qp2	cmp	qdist, qfirst
qp3	jmp	qskip, <qe

	cmp	qdist+qb, qfirst+qb
q1	djn	qfast, #qp1

	cmp	qdist+qd+qc, qfirst+qd+qc
	jmp	qslow, <qfirst+qd+qc+4
	cmp	qdist+qd+qb, qfirst+qd+qb
x1	jmp	qslow, <q1
	cmp	qdist+qc+qc, qfirst+qc+qc
q2	djn	qslow, #qp2
	cmp	qdist+qd, qfirst+qd
	jmp	qslow, <qfast
	cmp	qdist+qa, qfirst+qa
	jmp	q1, <q1

	cmp	qdist+qa+qd, qfirst+qa+qd
	jmp	x1, <q1
	cmp	qdist+qc+qb, qfirst+qc+qb
	jmp	q2, <q1
	cmp	qdist+qe+qd+qc,qfirst+qe+qd+qc
	jmp	qslower, <qfirst+qe+qd+qc+4
	cmp	qdist+qd+qd+qc,qfirst+qd+qd+qc
q3	djn	qslower, #qp3

	jmz	warr, qdist+qe+qd+qc+10

qslower	add @q3, @qslow
qslow	add @q2, qkil
qfast	add @q1, @qslow

qskip	cmp <qdist+qstep+50, @qkil
	jmp	qloop, <1234

	add	#qdist-qfirst, qkil
qloop	mov qbomb, @qkil
qkil	mov <qfirst+qstep+50, <qfirst
	sub #qi, @qloop
	djn qloop, #qr+2

MARK	equ	4573
HOP	equ	992
FIRST	equ	warr+6247
GAP	equ	10
STEP	equ	2190
PAPER1	equ	2302
PAPER2	equ	2949
PAPER3	equ	4368

warr	spl	24	,<MARK
	spl	12	,<MARK*2
	spl	6	,<MARK*3
	mov	D	,<4
	mov	C	,<3
	mov	B	,<2
	mov	A	,<1
	jmp	@0	,FIRST
	mov	D	,<4
	mov	C	,<3
	mov	B	,<2
	mov	A	,<1
	jmp	@0	,FIRST+HOP
	spl	6	,<MARK*4
	mov	D	,<4
	mov	C	,<3
	mov	B	,<2
	mov	A	,<1
	jmp	@0	,FIRST+(HOP*2)
	mov	D	,<4
	mov	C	,<3
	mov	B	,<2
	mov	A	,<1
	jmp	@0	,FIRST+(HOP*3)
	spl	12	,<MARK*5
	spl	6	,<MARK*6
	mov	D	,<4
	mov	C	,<3
	mov	B	,<2
	mov	A	,<1
	jmp	@0	,FIRST+(HOP*4)
	mov	D	,<4
	mov	C	,<3
	mov	B	,<2
	mov	A	,<1
	jmp	@0	,FIRST+(HOP*5)
	spl	paper	,<MARK*7
	mov	D	,<4
	mov	C	,<3
	mov	B	,<2
	mov	A	,<1
	jmp	@0	,FIRST+(HOP*6)
ptr	equ	(A-GAP-1)
A	spl	0	,<qscan
B	mov	C	,<C
C	mov	<C	,<0-(HOP*2/3)
D	djn	A	,<qscan


paper	spl	1	,<MARK*8
	mov	-1	,0
	spl	1	,<MARK*9
	mov	<12	,<2
	mov	<11	,<1
	spl	@0	,PAPER1
	mov	#10	,-1
mov	<-2	,<1
	spl	@0	,PAPER2

IMPN	equ	2667
	mov	<6	,<1
	spl	@0	,PAPER3
	spl	0	,<MARK
	add	#IMPN	,1
	jmp	@0	,imp-IMPN*6
imp	mov	0	,IMPN

      end     qscan

