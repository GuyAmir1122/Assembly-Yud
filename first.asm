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
	mov ax,1234h
	mov al, 0ABh
	mov bx, 0ABCDh
	mov ch, 0EEh
	mov dl, 0BBh
	mov dh, ch
	mov ah, dl
	mov cx,bx
	mov ah,al
	
	exit:
	mov ax, 4c00h
	int 21h
END start


