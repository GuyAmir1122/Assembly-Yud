IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
num1 db 10
num2 db 20
sum db 0
CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
mov bh, [num1]
add bh, [num2]
mov [sum], bh 
exit:
	mov ax, 4c00h
	int 21h
END start


