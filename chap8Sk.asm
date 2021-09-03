;
; here write your ID. DOnt forget the name of the file should be your id . asm
; ID  = 

; For tester:
; Tester name = 
; Tester Total Grade = 

 
;---------------------------------------------
; 
; Skelatone Solution for Chapter 8 Work
;  
;----------------------------------------------- 


IDEAL

MODEL small

	stack 256
DATASEG
		 
		 ; Ex1 Variables 
		  aTom db 13 dup(?)  ; example to varible for exercise 1
			
		  
		 ; Ex2 Variables 
		 numbers db 9 dup(?)
		 
		 
		 ; Ex3 Variables 
		 ninenums db 10 dup(?)
		 
		 ;Ex4 Variables
		 Array4 db 100 dup(0FFh)
		 
		 ;Ex5 Variables
		 BufferFrom5 db 10,65,34,76,100,120,43,28,94,12
		 BufferTo5 db 10 dup(?)
		 
		 ;Ex6 Variables
		 BufferFrom6 db 5 dup (1,13,24,57,-5,-13,12,99,125,1)
		 BufferTo6 db 50 dup (?)
		 BufferTo6Len db ?
		 ;Ex7 Variables
		 MyLine7 db 5,76,23,84,-6,-23,0DH
		 Line7Length db ?
		 ;Ex7b Variables
		 MyWords7 dw 100,321,65,-28,65,190,0DDDDh
		 MyWords7Length db ?
		 
		 ;Ex8 Variables
		 MyQ8   db   101, 130, 30, 201, 120, -3, 100, 255, 00H
		 
		 ;Ex9 Variables
		 Count1 db ?
		 Count2 db ?
		 Count3 db ?
		 MySet9 dw 10000,-2400,0,700,6510,-46,98,0,0FFFFh
		 
		 ;Ex10 Variables		
		 
		 
		 ; Ex11 Variables 
		 EndGates11 db 01111111b
		 false db "both 7 and 8 are false$"
		 true db "at least one of the bits 7 , 8  - true$"
		  ;Ex12 Variables
		  
		  
		 ;Ex13 Variables
		 WordNum13 dw 0
		 Number db "33000!"
		 
		 ;Ex14 Variables
		 check db 00000000b
		
		 
		 
		 
CODESEG

start:
		mov ax, @data
		mov ds,ax

		

		

		;call ex1
	 
		;call ex2
	 
		;call ex3
	 
		;call ex4
		
		;call ex5
	 
		;call ex6
	 
		;call ex7a
		
		;call ex7b
	 
		;call ex8
	 
		;call ex9
	 
		;call ex10
	 
		;call ex11
	 
		;call ex12
	 
		;call ex13
	 	 
		;call ex14a
		
		;call ex14b
		
		; mov ax 0F70Ch  
 		;call ex14c     ; this will call to ex14b and ex14a
	 
	 
	 
	 

exit:
		mov ax, 04C00h
		int 21h

		
		
;------------------------------------------------
;------------------------------------------------
;-- End of Main Program ... Start of Procedures 
;------------------------------------------------
;------------------------------------------------





;================================================
; Description -  Move 'a' -> 'm'  to variable at DSEG 
; INPUT: None
; OUTPUT: array on Dataseg name : aTom
; Register Usage: al,bx,cx
;================================================
proc ex1
			mov al,'a' ;move to al the starter letter
			mov bx,0
			mov cx,13 ;amount of letters
loopstart:
			mov [aTom + bx],al ;mov the letter to its place
			inc bx
			inc al
			loop loopstart    

    ret
endp ex1









;================================================
; Description -  move char 0 - 9 to variable
; INPUT:  none
; OUTPUT:  array on dataseg
; Register Usage:  al,si,cx
;================================================
proc ex2
	xor ax,ax
    mov al,'0' ;starter number
	mov si,0 ;the first adress
	mov cx,9 ;number of numbers
numloop:
		mov [numbers + si],al ;insert the number to the arrary
		call ShowAxDecimal ;print the bnumber
		inc al ;inc the number
		inc si ;inc the adress
		loop numloop 
	
    ret
endp ex2




;================================================
; Description: move 0 - 9 to variable
; INPUT:  none
; OUTPUT:  the numbers
; Register Usage: al,si,cx
;================================================
proc ex3
	xor ax,ax
    mov al,0 ;starter number
	mov si,0 ;the first adress
	mov cx,10 ;number of numbers
numbersloop:
		mov [ninenums + si],al ;insert the number to the arrary
		call ShowAxDecimal ;print the bnumber
		inc al ;inc the number
		inc si ;inc the adress
		loop numbersloop 

		
    ret
endp ex3




;================================================
; Description:put in every adress wich divide int 2 or 7
; INPUT: none 
; OUTPUT: none 
; Register Usage: cx,bl,bh,ax,si
;================================================
proc ex4
	xor ax,ax
	mov si,0
	mov bh,7
	mov bl,2
	mov cx,100
startcheck:
	mov ax,si
	div bh 
	cmp ah,0
	je insert
	mov ax,si
	div bl
	cmp ah,0		
	jne insert
	inc si
	loop startcheck
insert:
	mov [Array4 + si],0CCh
	inc si
	loop startcheck
	
      
    ret
endp ex4




;================================================
; Description: we are moving 10 a series of number from one place to another
; INPUT: none
; OUTPUT: none
; Register Usage: cx,si,ax
;================================================
proc ex5
     
	 mov cx, 10 ;times of loop
	 mov si,0 ;starter place
	 xor ax,ax
startmoving:
	mov al,[BufferFrom5 + si] ;get the number
	call ShowAxDecimal
	mov [BufferTo5 + si],al ;and put it to its place
	 inc si ;increase the place
	 loop startmoving
    ret
endp ex5




;================================================
; Description: we move positive numbers from one array to another and save the amount of numbers wich moved
; INPUT: none 
; OUTPUT:  numbers above 12
; Register Usage: ax,cx,si,bx
;================================================
proc ex6
      xor ax,ax
	  mov cx ,50
	  xor si,si
	  xor bx,bx
startcheck12:
	  cmp [BufferFrom6 + si],12	  
	  jle notabove12
above12:
	  mov al,[BufferFrom6 + si]
	  mov [BufferTo6 + bx],al
	  inc bx
	  call ShowAxDecimal
notabove12:
	  inc si
	  loop startcheck12
    ret
endp ex6




;================================================
; Description: check amount of numbers in a giveb series and put it un a certain varuable
; INPUT:  none
; OUTPUT:  the length of the series
; Register Usage: ax,si
;================================================
proc ex7a
      xor ax,ax
	  xor si,si
startcaculate:
	cmp [MyLine7 + si],13
	je equal13 ;if equal to 13 end the loop and print
	mov al,[MyLine7 + si] ;else, inc the varuable and keep checking
	inc [Line7Length]
	inc si
	jmp startcaculate
equal13:
	xor ax,ax
	mov al,[Line7Length]
	  call ShowAxDecimal
    ret
endp ex7a




;================================================
; Description: check amount of numbers in a giveb series and put it un a certain varuable
; INPUT:  none
; OUTPUT:  the length of the series
; Register Usage: ax,si
;================================================
proc ex7b
      xor ax,ax
	  xor si,si
startcaculatewords:
	cmp [MyWords7 + si],0DDDDh
	je equalDDDD ;if equal to DDDD end the loop and print
	mov ax,[MyWords7 + si] ;else, inc the varuable and keep checking
	inc [MyWords7Length]
	add si,2
	jmp startcaculatewords
equalDDDD:
	xor ax,ax
	mov al,[MyWords7Length]
	  call ShowAxDecimal
	  
    ret
endp ex7b




;================================================
; Description: add the numbers that are above 100 till you get 0 
; INPUT:  none
; OUTPUT:  the sum
; Register Usage: ax,si
;================================================
proc ex8     
		xor ax,ax
		mov si,-1
calculate:
		inc si
		cmp [MyQ8 + si],0
		je done;if the number equale to 0 exit
		cmp [MyQ8 + si],100					
		jg addtoal ;if the number is bigger then 100 signd check if its lower then 128		
		jmp calculate ;else, go to start and check another number
				
addtoal:
		add al,[MyQ8 + si] ;add to al
		jmp calculate
done:
	mov ah,0
	call ShowAxDecimal
	  
    ret
endp ex8




;================================================
; Description: check if numbers (word) below above or equal and if equal add to count3 if below add to count2 if above add to count1 till you get FFFF
; INPUT:  none
; OUTPUT:  the amount in each count
; Register Usage: ax,si
;================================================
proc ex9
      xor ax,ax
	  xor si,si
check9:
	cmp [MySet9 + si],0FFFFH 
	je end9
	cmp [MySet9 + si],0
	jl lower
	je equal0
	jg greater
lower:
	inc [Count2]
	add si,2
	jmp check9
equal0:
	inc [Count3]
	add si,2
	jmp check9
greater:
	inc [Count1]
	add si,2
	jmp check9
	
end9:
	mov al,[Count1]
	call ShowAxDecimal
	mov al,[Count2]
	call ShowAxDecimal
	mov al,[Count3]
	call ShowAxDecimal
    ret
endp ex9




;================================================
; Description:prints al in Binary
; INPUT:  none
; OUTPUT:  the number in binary
; Register Usage: ax,bx,cx,dx
;================================================
proc ex10
    xor ax,ax
	mov cx,8
	mov al,98
	mov bl,al
@@startloop:
	shl bl,1
	jc @@one
@@zero:
	mov dl,'0' ;if zero mov 0 to dl
	jmp @@print
@@one:
	mov dl,'1' ;else mov 1 to dl
@@print:
	mov ah,2 ;print the number
	int 21h
	loop @@startloop ;back to start 8 times
	mov dl,'B' ;print B
	mov ah,2
	int 21h
    ret
endp ex10




;================================================
; Description: checks if the bits 7 and 8 are 0, if both 0 say somthing,else say somthing else
; INPUT:  none
; OUTPUT:  true sentence, or false sentence
; Register Usage: ax,cx,dx,
;================================================
proc ex11
      xor ax,ax
	  mov cx,2
@@startloop:
	shl [EndGates11],1 ;check if 1
	jc @@true ;jump to true if 1
	loop @@startloop ;else do it again
@@false:
	mov dx,offset false ;if didnt jump write false
	mov ah,9
	int 21h
	jmp @@end
@@true: ;if jumped write true
	mov dx,offset true
	mov ah,9
	int 21h
@@end:
    ret
endp ex11




;================================================
; Description:check if in the address there is a value between 10-70 if it is, move to another address, else dont move it to there
; INPUT:  none
; OUTPUT:  none
; Register Usage: ax,bx 
;================================================
proc ex12
	xor ax,ax
	xor bx,bx
	mov bx,80
    mov [0A000H],bx
	mov bx,70
	cmp [0A000H],bx ;if above 70 jmp to end
	ja @@end
	mov bx,10
	cmp [0A000H],bx ;if below 10 jmp to end, else move the number
	jb @@end
	mov bl,[0A000H]
	mov [0B000H],bl
@@end:
    ret
endp ex12




;================================================
; Description:take a string of numbers, turn it into the number its self and put it into a variable
; INPUT:  none
; OUTPUT:  none
; Register Usage: ax,bx,cx,dx,si
;================================================
proc ex13
     xor ax,ax
	 xor si,si
	 xor dx,dx
	 mov bx,10
	 mov cx,5
@@startloop:
	cmp [number + si],'!' ;if ! end the loop
	je @@end
	cmp si,0 
	ja @@above ;only from the second number mul by 10
	je @@continue ;in the first numbers jmp to the rest
@@above:
	mul bx
	mov [WordNum13],ax
@@continue:
	mov dl,[number + si]
	sub dl,'0' ;turn the number char into a number
	add [WordNum13],dx ;add it to the variable
	inc si
	mov ax,[WordNum13]
	loop @@startloop
	
@@end:
    ret
endp ex13




;================================================
; Description:prints the lower nibble of al in hexadecimal
; INPUT:  none
; OUTPUT:  the letter
; Register Usage: ax,bx,cx,dl
;================================================
proc ex14a
    mov al, 56h	 ;the starter number
	mov cx,4 
	mov bl,00000001b ;the number we or the checker with
strtshl:	
	shr al,1 
	jc @@one 
	
@@zero: ;if zero
	shl bl,1 ;just shl bl so the currebt bit in the checker will stay zero, and the one in bl movw to the next bit
	loop strtshl
	jmp @@print
	
@@one:	;if one
	or [check],bl ;or the checker with bl 
	shl bl,1 ;and shl bl, so the one will be in the next bit
	loop strtshl
	
	 
@@print:
	cmp [check],10
	jb @@printnumber ;if lower then 10 jmp to printnumber 
	add [check],55 ;if not, add 55 to make it a letter 
	jmp @@hadpasa ;and jmp to hadpasa
	
@@printnumber:
	add [check],'0' ;add 30h to make it a char
	
@@hadpasa:
	mov dl,[check] ;print the char
	mov ah,2
	int 21h
	
    ret
endp ex14a




;================================================
; Description: prints the value of al in hexadecimal
; INPUT:  none
; OUTPUT:  the value of al in hexadecimal
; Register Usage: ax,bx,cx,dx,si
;================================================
proc ex14b
    mov al, 0E6h	 ;the starter number 	
	mov dh,al ;use dh instead of al because psika 02 changes al
	mov si,2 ;amount of characters to print
@@start:
	mov cx,4
	mov bl,10000000b ;the number we "or" the checker with
	mov [check],00000000b	;starter check	
@@strtshl:	
	shl dh,1 
	jc @@one 
	
@@zero: ;if carry is zero
	shr bl,1 ;just shl bl so the currebt bit in the checker will stay zero, and the one in bl movw to the next bit
	loop @@strtshl
	jmp @@print
	
@@one:	;if carry is one
	or [check],bl ;or the checker with bl 
	shr bl,1 ;and shl bl, so the one will be in the next bit
	loop @@strtshl
	
	 
@@print:
	shr [check],4 ;put the number in the right nibble
	cmp [check],10
	jb @@printnumber ;if lower then 10 jmp to printnumber 
	add [check],55 ;if not, add 55 to make it a letter 
	jmp @@hadpasa ;and jmp to hadpasa
	
@@printnumber:
	add [check],'0' ;add 30h to make it a char	
@@hadpasa:	
	mov dl,[check] ;print the char
	mov ah,2
	int 21h
	mov cx,si
	dec si
	loop @@start
    ret
endp ex14b




;================================================
; Description: prints the value of ax in hexadecimal
; INPUT:  none
; OUTPUT:  the value of ax in hexadecimal
; Register Usage: ax,bx,cx,dx,si,di
;================================================
proc ex14c
    mov ax, 0F70Chh ;the starter number 	
	mov di,ax ;use di instead of al because psika 02 changes ax
	mov si,4 ;amount of characters to print
@@start:
	mov cx,4
	mov bl,10000000b ;the number we "or" the checker with
	mov [check],00000000b	;starter check	
@@strtshl:	
	shl di,1 
	jc @@one 
	
@@zero: ;if carry is zero
	shr bl,1 ;just shl bl so the currebt bit in the checker will stay zero, and the one in bl movw to the next bit
	loop @@strtshl
	jmp @@print
	
@@one:	;if carry is one
	or [check],bl ;or the checker with bl 
	shr bl,1 ;and shl bl, so the one will be in the next bit
	loop @@strtshl
	
	 
@@print:
	shr [check],4 ;put the number in the right nibble
	cmp [check],10
	jb @@printnumber ;if lower then 10 jmp to printnumber 
	add [check],55 ;if not, add 55 to make it a letter 
	jmp @@hadpasa ;and jmp to hadpasa
	
@@printnumber:
	add [check],'0' ;add 30h to make it a char	
@@hadpasa:	
	mov dl,[check] ;print the char
	mov ah,2
	int 21h
	mov cx,si
	dec si
	loop @@start
    ret
endp ex14c












;================================================
; Description - Write on screen the value of ax (decimal)
;               the practice :  
;				Divide AX by 10 and put the Mod on stack 
;               Repeat Until AX smaller than 10 then print AX (MSB) 
;           	then pop from the stack all what we kept there and show it. 
; INPUT: AX
; OUTPUT: Screen 
; Register Usage: AX  
;================================================
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
