IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
letter db ?
filehandle dw ?
filefound db ?
filename db "Bdika.txt",0
errormassege db "error in open file",'$',10,13



CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
	mov dl,'>'
	mov ah,2
	int 21h
	call newline
	mov dx,offset filename
	call writefile
	call closefile
	mov dl,'<'
	mov ah,2
	int 21h
exit:
	mov ax, 4c00h
	int 21h
	
proc writefile
	call filesize ;get amount of letter
@@start:
	mov ah,3Fh
	mov dx, offset letter
	mov bx,[filehandle]
	mov cx,1 ;get one letter each time and put it into the variable
	int 21h
	mov dl,[letter] ;print the variable
	mov ah,2
	int 21h
	mov cx,si ;mov to cx the amount of letter left
	dec si ;dec one letter
	loop @@start
	ret
endp writefile



proc filesize 
	call openfile
	mov ah,42h
	mov bx,[filehandle]
	mov al,2
	mov cx,0 ;get file size
	mov dx,0
	int 21h
	mov si,ax ;save size in si	
	
	mov ah,42h
	mov bx,[filehandle]
	mov al,0
	mov cx,0 ;return the pointer to the start
	mov dx,0
	int 21h

@@end:
	
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

proc newline
	mov dl,13
	mov ah,2
	int 21h
	mov dl,10
	mov ah,2
	int 21h
	ret
endp newline

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


