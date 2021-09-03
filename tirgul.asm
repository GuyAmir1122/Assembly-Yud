IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
stringinp db "xx12345x"
string db "     $"
CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
mov [byte stringinp],6
mov dx, offset stringinp
mov ah,0Ah
int 21h
mov ax,0
mov al, [stringinp + 2]
mov [string],al
mov al, [stringinp + 3]
mov [string + 1],al
mov al, [stringinp + 4]
mov [string + 2],al
mov al, [stringinp + 5]
mov [string + 3],al
mov al, [stringinp + 6]
mov [string + 4],al
or [string], 20h
or [string + 1], 20h
or [string + 2], 20h
or [string + 3], 20h
or [string + 4], 20h
sub [string],30h
sub [string + 1],30h
sub [string + 2],30h
sub [string + 3],30h
sub [string + 4],30h
mov dx, offset string
mov ah,9
int 21h
exit:
	mov ax, 4c00h
	int 21h
END start


