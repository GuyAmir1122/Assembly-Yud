IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
;ex1
num dw 8

num2 db 11

;ex2
firstnum dw 74

secondnum dw 94


addres dw ?

CODESEG
start:
	mov ax, @data
	mov ds, ax
	
; --------------------------
; Your code here
; --------------------------

;ex1
	mov si,9
	mov cx,4
@@startpront:
	mov di,cx
	mov cx,si
	call printwithreg
	inc si
	mov cx,di
	loop @@startpront
	
	

	call newline



	mov cx,4
@@printwithvar:
	mov si,cx
	call printwithnum
	inc [num2]
	mov cx,si
	loop @@printwithvar



	call newline



	mov cx,4
@@print:
	mov si,cx
	push [num]
	call printnums
	inc [num]
	mov cx,si
	loop @@print


;ex2

	call newline
	
	push [firstnum]
	push [secondnum]
	call wichnumber



exit:
	mov ax, 4c00h
	int 21h

proc printwithreg
	xor ax,ax
	mov bl,10
	mov bh,1
	
@@startprint:
	cmp bh,10 ;if one digit dont jump
	jae @@twodigits ;else jump
	mov dl,bh
	add dl,'0' ;print digit
	mov ah,2
	int 21h
	jmp @@inc
@@twodigits:
	xor ax,ax
	mov al,bh ;seperate the digits
	div bl
	mov dl,al ;take the tens
	add dl,'0' ;print first digit
	mov ah,2
	int 21h
	
	xor ax,ax
	mov al,bh ;seperate again
	div bl
	
	mov dl,ah ;and take the ones
	add dl,'0' ;print second digit
	mov ah,2
	int 21h
@@inc:
	inc bh
	loop @@startprint
	call newline
	ret
endp printwithreg




proc printwithnum
	xor ax,ax
	mov bl,10
	mov bh,1
	xor cx,cx
	mov cl,[num2]
@@startprint:
	cmp bh,10 ;if one digit dont jump
	jae @@twodigits ;else jump
	mov dl,bh
	add dl,'0' ;print digit
	mov ah,2
	int 21h
	jmp @@inc
@@twodigits:
	xor ax,ax
	mov al,bh ;seperate the digits
	div bl
	mov dl,al ;take the tens
	add dl,'0' ;print first digit
	mov ah,2
	int 21h
	
	xor ax,ax
	mov al,bh ;seperate again
	div bl
	
	mov dl,ah ;and take the ones
	add dl,'0' ;print second digit
	mov ah,2
	int 21h
@@inc:
	inc bh
	loop @@startprint
	call newline
	ret
endp printwithnum




	
proc printnums
	pop [addres]
	pop cx
	xor ax,ax
	mov bl,10
	mov bh,1
	
startprint:
	cmp bh,10 ;if one digit dont jump
	jae @@twodigits ;else jump
	mov dl,bh
	add dl,'0' ;print digit
	mov ah,2
	int 21h
	jmp @@inc
@@twodigits:
	xor ax,ax
	mov al,bh ;seperate the digits
	div bl
	mov dl,al ;take the tens
	add dl,'0' ;print first digit
	mov ah,2
	int 21h
	
	xor ax,ax
	mov al,bh ;seperate again
	div bl
	
	mov dl,ah ;and take the ones
	add dl,'0' ;print second digit
	mov ah,2
	int 21h
@@inc:
	inc bh
	loop startprint
	call newline
	push [addres]
	ret
endp printnums



proc wichnumber

	pop [addres]
	pop bx
	pop ax
	cmp ax,bx
	ja @@first
	jb @@second
	mov dl,'C'
	mov ah,2
	int 21h
	jmp @@end
@@first:
	mov dl,'A'
	mov ah,2
	int 21h
	jmp @@end
@@second:
	mov dl,'B'
	mov	ah,2
	int 21h
	
@@end:
	push [addres]
	ret
	endp wichnumber






proc newline
	mov dl,13
	mov ah,2
	int 21h
	mov dl,10
	mov ah,2
	int 21h
	ret
endp newline










END start



