__zero = 0
__r0 = 0
__r1 = 0
__r2 = 0
__r3 = 0
__r4 = 0
__r5 = 0
__r6 = 0
__r7 = 0
__r8 = 0
__r9 = 0
__r10 = 0
__r11 = 0
__r12 = 0
__r13 = 0
__r14 = 0
__r15 = 0
__r16 = 0
__r17 = 0
__r18 = 0
__r19 = 0
__r20 = 0
__r21 = 0
__r22 = 0
__r23 = 0
__r24 = 0
__r25 = 0
__r26 = 0
__r27 = 0
__r28 = 0
__r29 = 0
__r30 = 0
__r31 = 0
__sp = 0
__fp = 0
__ra = 0
x = 6
y = 7
_start:
	set __r0 2
	set __r1 0
	store x __r1 __r0
	set __r0 3
	store y __r1 __r0
	load __r0 x __r1
	load __r2 y __r1
	add __r0 __r0 __r2
	set __r2 11
	lt __r0 __r0 __r2
	store x __r1 __r0
	halt