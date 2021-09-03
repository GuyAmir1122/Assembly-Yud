IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
filename db "Bdika.txt",0
filehandle dw ?
errormassege db "error in open file",'$',10,13
filefound db ?
CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
mov dx,offset filename
call filesize
call closefile





exit:
	mov ax, 4c00h
	int 21h
	
proc filesize 
	call openfile
	mov ah,42h
	mov bx,[filehandle]
	mov al,2
	mov cx,0 ;get file size
	mov dx,0
	int 21h
	mov si,ax ;save size in si
	call ShowAxDecimal ;show size
	
	mov ah,42h
	mov bx,[filehandle]
	mov al,0
	mov cx,0 ;return the pointer to the start
	mov dx,0
	int 21h	
	
	ret
endp filesize


proc openfile
	mov ah, 3Dh
	mov al,2 ;open file
	int 21h
	jc @@error
	mov [filehandle],ax
	mov [filefound],1
	jmp @@end
@@error:
	mov dx,offset errormassege
	mov ah,9
	int 21h ;if error, show massage and the number of the error
	call ShowAxDecimal
	mov [filefound],0 ;mov to filefound 0
@@end:
	ret
endp openfile


proc closefile
	mov ah,3Eh
	mov bx,[filehandle]
	int 21h
	ret
endp closefile


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


