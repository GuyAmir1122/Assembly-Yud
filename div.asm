IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
num db 196
digits db ?,?,?
CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
mov ax,0
mov al,[num]
mov bl,10
div bl
mov [digits + 2],ah
mov ah,0
div bl
mov [digits+1],ah
mov [digits],al


exit:
	mov ax, 4c00h
	int 21h
END start


