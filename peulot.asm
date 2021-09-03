IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
;1
var db 34,45,12,25
;2
var1 db 78
var2 db 120
sum db ?
;3
sub1 db 9,8,7,6
sub2 db 6,7,8,9
sub3 db ?,?,?,?
;4
mul1 db 20,43,12,5
mul2 db 18,2,24,56
mul3 dw ?
 
CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
;1
mov ax,0
add al, [var]
add al, [var + 1]
add al, [var + 2]
add al, [var + 3]
;2
mov ax,0
add al,[var1]
add al,[var2]
mov [sum],al
;3
mov ax,0
mov al, [sub1]
sub al, [sub2]
mov [sub3],al
mov al, [sub1 + 1]
sub al, [sub2 + 1]
mov [sub3 + 1],al
mov al, [sub1 + 2]
sub al, [sub2 + 2]
mov [sub3 + 2],al
mov al, [sub1 + 3]
sub al, [sub2 + 3]
mov [sub3 + 3],al
;4
mov ax,0
mov al, [mul1]
imul [mul2]
add [mul3],ax
mov al, [mul1 + 1]
imul [mul2 + 1]
add [mul3],ax
mov al, [mul1 + 2]
imul [mul2 + 2]
add [mul3],ax
mov al, [mul1 + 3]
imul [mul2 + 3]
add [mul3],ax


exit:
	mov ax, 4c00h
	int 21h
END start


