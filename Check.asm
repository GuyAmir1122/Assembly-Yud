IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------

CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
Xpos equ [bp + 2]
@@Starter:

@@End:

exit:
	mov ax, 4c00h
	int 21h
	

END start


