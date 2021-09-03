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

mov [word cs:0], 0D1E0h
; The oppcode of the first command changed, it is now a different command
exit:
	mov ax, 4c00h
	int 21h
END start


