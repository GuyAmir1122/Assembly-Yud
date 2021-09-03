IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
num1 db 10
num2 db 20
CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------

mov bl, [num1]
add  bl, [num2]
mov al, bl

exit:
	mov ax, 4c00h
	int 21h
END start


