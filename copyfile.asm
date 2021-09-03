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
filenameB db "b.txt",0
filenameA db "a.txt",0
errormassege db "error in open file ",'$',10,13


CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------

	push offset filenameA
	push offset filenameB
	call writetofile
	mov dx,offset filenameB
	mov al,2
	call openfile
	call filesize
	call writefile



exit:
	mov ax, 4c00h
	int 21h


handleA equ [bp - 2]
handleB equ [bp - 4]
NameA equ [bp + 6]
NameB equ [bp + 4]
proc writetofile
	push bp
	mov bp,sp
	sub sp,4
	mov al,0
	mov dx,NameA
	call openfile
	mov di,[filehandle]
	mov handleA,di
	call filesize
	mov al,1
	mov dx,NameB
	call openfile
	mov di,[filehandle]
	mov handleB,di
@@Strt:
	mov ah,3Fh
	mov dx, offset letter
	mov bx,handleA
	mov cx,1 ;get one letter each time and put it into the variable
	int 21h
	cmp [letter],40h
	ja @@check2
	cmp [letter],3Ah ;check if letter or number
	jb @@checknumber
	jmp @@end
	
@@check2:
	cmp [letter], 5Bh
	jb @@printletter
	cmp [letter],60h
	ja @@check3
	jmp @@end
@@check3:
	cmp [letter], 7Bh
	jb @@printletter
	
@@checknumber:
	cmp [letter],30h
	jae @@printnumber
	jmp @@end
	
@@printletter:
	mov [letter],'&'
	mov dx,offset letter ;if letter replace wirh &
	mov bx, handleB
	mov cx,1
	mov ah,40h
	int 21h
	jmp @@end
@@printnumber:
	mov dx,offset letter ;if number leave it as is, and if somthing else dont do anything
	mov bx, handleB
	mov cx,1
	mov ah,40h
	int 21h
@@end:	
	dec si
	cmp si,0
	jnz @@Strt ;do it until si = 0
	mov di,handleA
	mov [filehandle],di
	call closefile
	mov di,handleB
	mov [filehandle],di
	call closefile
	add sp,4
	pop bp
	ret
endp writetofile
	
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


