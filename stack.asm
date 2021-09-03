IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
arr db 87,45,34,2,15

arr2 db 75,107,84,92,89,68,94,76

CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------	
;ex1
	;push offset arr
	;push 5
	;call PrintArr
;ex2
	;push 3
	;push 4
	;push 5
	;call pitagoras

;ex3
	;push offset arr2
	;push 8
	;call PrintArr
	;push offset arr2
	;push 8
	;call Findme
	;push offset arr2
	;push 8
	;call PrintArr
;ex4
	push offset arr2
	push 8
	call SortArr
	push offset arr2
	push 8
	call PrintArr
	
	
exit:
	mov ax, 4c00h
	int 21h
	
proc PrintArr
	push bx
	mov bp,sp	
	mov bx,[bp + 6] ;the addres
	push si
	push ax ;save the registers
	push cx
	xor ax,ax
	mov cx, [bp + 4] ;amount of numbers
	mov si,0
@@print:
	mov al,[bx + si] ;the number to print
	call ShowAxDecimal
	inc si
	loop @@print
	call newline
	pop cx
	pop ax
	pop si
	pop bx
	ret 4
endp PrintArr
	
	
proc newline
	mov dl,13
	mov ah,2
	int 21h
	mov dl,10
	mov ah,2
	int 21h
	ret
endp newline




num1 equ [bp + 8]
num2 equ [bp + 6]
num3 equ [bp + 4]
mul1 equ [bp - 2]
mul2 equ [bp - 4]
mul3 equ [bp - 6]
proc pitagoras
	push bp
	mov bp,sp
	sub sp,6
	push ax
	mov al,num1
	mul al 
	mov mul1,ax
	mov al,num2
	mul al
	mov mul2,ax
	mov al,num3
	mul al
	mov mul3,ax
	mov ax,mul1
	add ax,mul2
	cmp ax,mul3
	je @@ax1
	mov ax,0
@@ax1:
	mov ax,1
	pop ax
	add sp,6
	pop bp
	ret 6
endp pitagoras

Min equ [bp - 2];the lowest number
Minaddres equ [bp -4];the lowest numbers addres
proc Findme
	push bp
	mov bp,sp
	sub sp,4
	push si
	push cx
	push bx ;save registers
	push ax
	push di
	mov cx, [bp + 4];amount of numbers
	mov di,255 ;max number
	mov Min,di
	mov si,[bp + 6];the start of the array
	mov bx,0
@@startscheck:
	xor ax,ax
	mov al,[si + bx]
	cmp ax,Min ;if the number lower then the Min
	jb @@min ;jmp
	inc bx ;else inc bx and loop
	loop @@startscheck
	jmp @@end
@@min:
	mov Min, ax ;if jmp, mov to Min the number
	mov di,si ;mov to di the addres of the the array
	add di,bx ;add to di the place of the number in the array
	mov Minaddres,di ;mov to Minaddres the addres of the number
	inc bx
	loop @@startscheck
@@end:
	mov bl,[si] ;take the first number in the array
	mov di, Minaddres ;and the addres of the lowest number
	mov [di], bl ;put the first number int the place of the lowest number
	mov bl, Min 
	mov [si],bl ;put the lowewst number in the first place
	pop di
	pop ax
	pop bx
	pop cx
	pop si
	add sp,4
	pop bp
	ret 4
endp Findme

proc SortArr
	push bp
	mov bp,sp
	push cx
	push si
	mov si,[bp + 6]
	mov cx,[bp + 4]
@@strt:
	push si
	push cx
	call Findme
	inc si
	loop @@strt
	pop si
	pop cx
	pop bp
	ret
endp SortArr

proc ShowAxDecimal
       push ax
	   push bx
	   push cx
	   push dx
	   
	   ; check if negative
	   test ax,08000h
	   jz PositiveAx
			
	   ;  put '-' on the screen
	   push ax
	   mov dl,'-'
	   mov ah,2
	   int 21h
	   pop ax

	   neg ax ; make it positive
PositiveAx:
       mov cx,0   ; will count how many time we did push 
       mov bx,10  ; the divider
   
put_mode_to_stack:
       xor dx,dx
       div bx
       add dl,30h
	   ; dl is the current LSB digit 
	   ; we cant push only dl so we push all dx
       push dx    
       inc cx
       cmp ax,9   ; check if it is the last time to div
       jg put_mode_to_stack

	   cmp ax,0
	   jz pop_next  ; jump if ax was totally 0
       add al,30h  
	   mov dl, al    
  	   mov ah, 2h
	   int 21h        ; show first digit MSB
	       
pop_next: 
       pop ax    ; remove all rest LIFO (reverse) (MSB to LSB)
	   mov dl, al
       mov ah, 2h
	   int 21h        ; show all rest digits
       loop pop_next
		
	   mov dl, ','
       mov ah, 2h
	   int 21h
   
	   pop dx
	   pop cx
	   pop bx
	   pop ax
	   
	   ret
endp ShowAxDecimal
	
END start


