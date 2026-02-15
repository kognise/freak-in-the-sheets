; n = 11
; out = 0

; terms = 0 1
; terms_len = 2
; i = 2

; temp1 = 0
; temp2 = 0

; neg1 = -1
; neg2 = -2
; pos1 = 1

; _start:
; loop:
;     lte temp1 i n
;     jmp0 temp1 after_loop
;     add temp1 i neg1
;     add temp2 i neg2
;     load temp1 terms temp1
;     load temp2 terms temp2
;     add temp1 temp1 temp2
;     store terms terms_len temp1
;     add terms_len terms_len pos1
;     add i i pos1
;     jmp loop
; after_loop:
;     load out terms n
;     halt

__zero = 0
__r0 = 0
__r1 = 0
__r2 = 0
__r3 = 0
x = 6
y = 7
_start:
	set __r0 2
	set __r1 0
	set __r2 x
	store_a __r2 __r1 __r0
	set __r0 3
	set __r3 y
	store_a __r3 __r1 __r0
	load_a __r0 __r2 __r1
	load_a __r3 __r3 __r1
	add __r0 __r0 __r3
	store_a __r2 __r1 __r0
	halt
