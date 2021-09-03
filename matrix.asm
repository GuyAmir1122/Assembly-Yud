IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
Matrix1      db   4, 4, 4, 4, 4, 4 
             db   4, 4, 4, 4, 4, 4
             db   4, 4, 6, 6, 6, 4
             db   4, 4, 6, 7, 6, 4
             db   4, 4, 6, 6, 6, 4
             db   4, 4, 4, 4, 4, 4
             db   4, 4, 4, 4, 4, 4

Matrix dw ?
CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------


mov di,160 + 320 * 3  ; start position – 3rd row un the middle
mov cx, offset Matrix1
mov [Matrix] ,cx ; put the bytes offset in Matrix
mov dx,6   ; number of cols  
mov cx, 7  ;number of rows
call putMatrixInScreen

exit:
	mov ax, 4c00h
	int 21h
	
	
proc putMatrixInScreen
    mov si,[matrix] ; puts offset of the Matrix to si
NextRow:	; loop of cx lines
	push cx ;saves cx of loop
	mov cx, dx ;sets cx for movsb
	rep movsb ; Copy whole line to the screen, si and di increases
	sub di,dx ; returns back to the begining of the line 
	add di, 320 ;go down one line in “screen” by adding 320
	pop cx  ;restores cs of loop
	loop NextRow
	ret 
endp putMatrixInScreen
END start


