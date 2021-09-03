IDEAL
MODEL small
STACK 100h
DATASEG

; --------------------------
; Your variables here
; --------------------------

firstName db 'Guy'
age	db 16
age2 dw 16
lastname db 'Amir'
myArray dw 40 dup(0A504h)




CODESEG

start:
	mov ax, @data
	mov ds, ax
	;
	;
	;
	mov bx, 0BFDDh
	mov al, bl
	mov bl, bh
	mov bh, al
	mov si, [05h]
	mov di, [03h]
	mov [05h], di
	mov [03h], si
	mov di,[6h]
	mov [16h], di
	mov [byte 10h],11110000b
	mov al, [100h] ;  יכול להיכנס בית ALפעןלה מסוכנת בגלל שהגדלים שלהם שונים, בכתובת יכול להיכנס מילהווב 
	mov al, [byte 50h]
	mov ch, [byte 51h]
	mov bx, 30h
	mov dx, [bx]
	mov cx, [bx + 1]
	mov si, [10h]
	mov di, [20h]
	mov [20h], si
	mov [10h], di
	
exit:
	mov ax, 4c00h
	int 21h
END start


