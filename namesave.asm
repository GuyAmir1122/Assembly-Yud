IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
currentname db "xx00000000000000000000x"
letter db ?
filehandle dw ?
filefound db ?
newline2 db 10,13
filename db "names.txt",0
errormassege db "error in open file ",'$',10,13
massage db "Enter Name$"
CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
	call GetNames
	mov dx,offset filename
	mov al,0
	call openfile
	call filesize
	call writefile
	call closefile
exit:
	mov ax, 4c00h
	int 21h
proc GetNames
	push cx
	push si
	push ax;save registers
	push dx
	push bx
	push bp
	mov bp,sp
	mov al,1
	mov dx,offset filename ;open file
	call openfile
	mov ah,42h
	mov al,2
	mov bx,[filehandle] ;mov the pointer
	mov cx,0
	mov dx,0
	int 21h
@@Strt:
	call newline
	mov dx,offset massage
	mov ah,9 ;ask for names
	int 21h
	call newline
	mov [currentname],21
	mov dx, offset currentname ;put name in varuable
	mov ah,0Ah
	int 21h
	xor bx,bx
	mov bl,[currentname + 1]
	push bx ;get amount of charaters
	mov di,[bp - 2]
	mov si,2 ;first character
	cmp di,3 ;if 3 characters check if equal to "end"
	je @@checkend
	jmp @@read ;else jmp to read
@@checkend:
	cmp [currentname + 2],'e'
	je @@check2
	jmp @@read
@@check2:
	cmp [currentname + 3],'n'
	je @@check3
	jmp @@read
@@check3:
	cmp [currentname + 4],'d'
	je @@end ;if equal to end jmp to end
@@read:
	mov bl,[currentname + si]
	mov [letter],bl ;mov the letter into varuable
	mov dx,offset letter ;mov the varuable into the file
	mov bx,[filehandle]
	mov cx,1
	mov ah,40h
	int 21h
	mov cx,di
	dec di ;repeat amount of letters
	inc si
	loop @@read
	pop di
	mov dx,offset newline2 ;mov newline into the file
	mov bx,[filehandle]
	mov cx,2
	mov ah,40h
	int 21h
	jmp @@Strt
	@@end:
	pop bx 
	pop dx
	pop ax
	pop si ;pop to registers
	pop cx
	pop bp
	pop di
	call closefile ;close file
	ret
endp GetNames

	
 proc writefile
	;call filesize ;get amount of letter
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
	;call openfile
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
	mov ah, 3Dh ;open file
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


