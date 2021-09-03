;
; here write your ID. DOnt forget the name of the file should be your id . asm
; ID  = 14

; For tester:
; Tester name = Guy Amir
; Tester Total Grade = 92

 
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
		  aTom db 13 dup(?)  
		  Letters db 'a'
		  
; Ex2 Variables 
		 ZeroToNine db 10 dup(?)
		 
; Ex3 Variables 
		 ZtoN db 10 dup(?)
				
; Ex4 Variables
		 Array4 db 100 dup(?)
		 
; Ex5 Variables 
		 BufferFrom5 db 1,2,3,4,5,6,7,8,9,10
		 BufferTo5 db 10 dup(?)
		 
; Ex6 Variables
         BufferFrom6 db 50 dup(14)
         BufferTo6 db 50 dup(?)	
		 BufferTo6Len db 0
		 
; Ex7a Variables
         MyLine7 db 1,2,3,4,5,6,7,8,0Dh
		 Line7Length db 0
		 
; Ex7b Variables
         MyWords7 dw 261,262,263,264,0AAAAh,256,260,258,0DDDDh 
		 MyWords7Length db 0
		 
; Ex8 Variables 
		 MyQ8 db 101, 130,30,201, 120, -3,100,255,00h
		 

; Ex9 Variables 
		 MySet9 dw 101,260,30, 201,1204, -3,1000,256,00,0FFFFh
		 Count1 db 0
		 Count2 db 0
		 Count3 db 0
; Ex10 Variables 

; Ex11 Variables 
		 EndGates11 db 11110000b
		 Both78 db 13,10,"both 7 and 8 are false$"	
		 Atleast db 13,10,"at least one of the bits 7 , 8  - true$"
; Ex12 Variables 

; Ex13 Variables 
		 WordNum db "926!"
		 Num13 dw 0
		 
; Ex14a Variables 
		 
; Ex14b Variables 
		 AlValue db ?
; Ex14c Variables 
		 AlValue2 db ?
CODESEG

start:
		mov ax, @data
		mov ds,ax

		; next 5 lines: example how to use ShowAxDecimal (you can delete them)
		;mov al, 73
		;mov ah,0
		;call ShowAxDecimal		 
		;mov ax, 0ffffh
		;call ShowAxDecimal

		

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
		
	 
		 mov ax, 0F70Ch  
 		 call ex14c     ; this will call to ex14b and ex14a
		 ;call ex14a
		 ;call ex14b
	 
	 
	 
	 

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
; Register Usage: cl, si, bl
;================================================
proc ex1
    ; < HERE YOUR ANSWER>
     xor cx, cx
	 mov cl, 0dh
     mov si, 00h
     mov bl, [Letters]

A_M:
     mov [aTom+si], bl
     inc si
     inc bl
     loop A_M
    ret
endp ex1


;================================================
; Description -  Move '0' -> '9'  to variable at DSEG 
; INPUT: None
; OUTPUT: array on Dataseg name : ZeroToNine
; Register Usage: cl, si, bl
;================================================
proc ex2
     xor cx, cx
     mov cl, 0ah
     mov si, 00h
     mov bl, '0'

Z_N:
     mov [ZeroToNine+si], bl
     inc si
     inc bl
     loop Z_N
    ret
endp ex2


;================================================
; Description -  Move 0 -> 9  to variable at DSEG 
; INPUT: None
; OUTPUT: array on Dataseg name : ZtoN
; Register Usage: cl, si, bl
;================================================
proc ex3
     xor cx, cx
     mov cl, 0ah
     mov si, 00h
     mov bl, 0

Z_N2:
     mov [ZtoN+si], bl
     inc si
     inc bl
     loop Z_N2
    ret
endp ex3


	
;================================================
; Description -  Move CCh to Odd cells (number) or cells numbers that can be divide by 7 
; INPUT: None
; OUTPUT: array on Dataseg name : Array4
; Register Usage: cx, si, dl, dh, ax
;================================================
proc ex4
      mov dl, 2
	  mov dh, 7
	  mov si, 0
	  
	  mov cx, 64h

loop_4:
	  inc si
	  mov ax, si
	  div dl
	  cmp ah, 0
	  jne odd_7
	  mov ax, si
	  div dh
	  cmp ah, 0
	  je odd_7
	  loop loop_4
	  jmp ExitLoop_4

odd_7:
	  mov [Array4+si], 0CCh
	  dec cx
	  jmp loop_4
	  
ExitLoop_4:	  
	  
    ret
endp ex4



;================================================
; Description -  Move the series of numbers to a different location
; INPUT: None
; OUTPUT: array on Dataseg name : BufferTo5
; Register Usage: cl, si, bl 
;================================================
proc ex5
     xor cx, cx
     mov cl, 0ah
     mov si, 00h

Buffer5:
     mov bl, [BufferFrom5+si]
     mov [BufferTo5+si], bl
     inc si
     loop Buffer5
	 
    ret
endp ex5




;================================================
; Description -  Move the series of numbers to a different location if they're bigger than 12 + counting the cells
; INPUT: None
; OUTPUT: array on Dataseg name : BufferTo6
; Register Usage: cx, si, bl 
; -3  points - because of line 304 the loop is infinite and the loop should be targeted to Check_6
;================================================
proc ex6
     xor ax, ax  
	 xor bx, bx 
	 xor cx, cx 
	 xor dx, dx
	 
     mov cl, 50
Check_6: 
     mov si, bx 
	 inc bx 
	 cmp [BufferFrom6+si], 12 
	 ja Buffer6 
	 loop Buffer6
	 
Buffer6:
     mov al, [BufferFrom6+si] 
	 mov si, dx 
	 mov [BufferTo6+si], al 
	 inc [BufferTo6Len] 
	 inc dx 
	 dec cx 
	 jmp Check_6
	 
    ret
endp ex6




;================================================
; Description: Count the serie length (Byte)
; INPUT:  None
; OUTPUT:  Line7Length
; Register Usage: al, si
;================================================
proc ex7a

	 mov al, [Line7Length]
	 mov si, 0

Length_7:
     cmp [MyLine7+si], 0Dh
	 jne Counter_7
	 jmp ExitLoop_7

Counter_7:
	 inc al
	 inc si
	 jmp Length_7

ExitLoop_7:
	 mov [Line7Length], al
    ret
endp ex7a




;================================================
; Description: Count the serie length (word)
; INPUT:  None
; OUTPUT:  MyWords7Length
; Register Usage: al, si
;================================================
proc ex7b

	 mov al, [MyWords7Length]
	 mov si, 0

Length_7b:
     cmp [MyWords7+si], 0DDDDh
	 jne Counter_7b
	 jmp ExitLoop_7b

Counter_7b:
	 inc al
	 add si, 2
	 jmp Length_7b

ExitLoop_7b:
	 mov [MyWords7Length], al

    ret
endp ex7b




;================================================
; Description: Sum only the numbers above 100 (signed), then print the result
; INPUT:  None
; OUTPUT:  Sum
; Register Usage: ax, si
;-1 points, line 392, using al instead of ax, the numbers sum could easly be more then 256
;================================================
proc ex8

xor ax, ax
mov si, 0

Check_8:
     cmp [MyQ8+si], 00h
	 je ExitLoop_8
	 cmp [MyQ8+si], 100d
	 jg Bigger_100
	 cmp [MyQ8+si], 100d
	 jle Smaller_100_Signed

Bigger_100:
	 add al, [MyQ8+si]
	 inc si
	 jmp Check_8

Smaller_100_Signed:
	 inc si
	 jmp Check_8

ExitLoop_8:
	 call ShowAxDecimal


    ret
endp ex8




;================================================
; Description: count the positive, negtive and 0s 
; INPUT: None
; OUTPUT:  Count1, Count2, Count3
; Register Usage: ax, si, bx
;================================================
proc ex9
xor ax, ax
mov si, 0

Check_9:
	 mov bx,[MySet9+si]
     cmp [MySet9+si], 0FFFFh
	 je ExitLoop_9
	 cmp [MySet9+si], 0
	 jg Positive
	 cmp [MySet9+si], 0
	 jl Negative

Equal_0:
	 inc [Count3]
	 add si, 2
	 jmp Check_9

Negative:
	 inc [Count2]
	 add si, 2
	 jmp Check_9
	 
Positive:
	 inc [Count1]
	 add si, 2
	 jmp Check_9

ExitLoop_9:
	 
	 
    ret
endp ex9




;================================================
; Description: print to screen the binary value of AL
; INPUT:  None
; OUTPUT:  Binary Value on screen
; Register Usage: cx, bl, al, dl
;================================================
proc ex10
     mov cx, 8
	 mov bl, al
@@NextBit:
	 shl bl, 1
	 jc @@PutOne
	 
	 mov dl, '0'
	 jmp @@PrintBit
			
@@PutOne:
	 mov dl, '1'

@@PrintBit:
	 mov ah, 2
	 int 21h
	 
	 loop @@NextBit
    ret
endp ex10




;================================================
; Description:  check if bit 7, 8 contain 0
; INPUT:  
; OUTPUT:  Msg on screen
; Register Usage: cx, al
;-1 points did the exe with the first and second bits inדtead of the sventh and eighth
;================================================
proc ex11
	 xor cx, cx
     mov al, [EndGates11]
	 
	 
MoveToBit7:
	 shl al, 6

	 mov cl, 2
CheckIf1_Bits78:
	 shl al, 1
	 jc AtLeastOne_11
	 loop CheckIf1_Bits78                                 
	 
	 mov dx, offset Both78
	 mov ah, 9
	 int 21h
	 jmp Exit_11
	 
AtLeastOne_11:
	 mov dx, offset AtLeast
	 mov ah, 9
	 int 21h
		
		
Exit_11:		
    ret
endp ex11




;================================================
; Description: if the value in ds:A000h is between 10-70, put it in ds:B000h
; INPUT: None
; OUTPUT:  
; Register Usage: al 
;================================================
proc ex12

     mov al, [byte ds:0A000h]
	 cmp al, 10d
	 jb Exit_12
	 cmp al, 70d
	 ja Exit_12
	 
Move0B000h:
	 mov [byte ds:0B000h], al
	 
Exit_12:
	 ret
endp ex12




;================================================
; Description: convert ascii to num from a string ending in '!'
; INPUT:  
; OUTPUT:  
; Register Usage: bx, cx, si, di, ax
;-3 points in line 563 wrong jmp, the exe is not working for one digit number, and did mul before sub '0' from al
;================================================
proc ex13
	 xor bx, bx
	 mov si, 0
	 mov di, 10
	 
	 mov cx, 5		
Convert:
	 xor ax,ax
	 mov al, [WordNum + si]
	 cmp al, "!"
	 jz Exit_13
	 mul di
	 inc si
	 sub al, '0'
	 add bx, ax
	 loop Convert
	 
Exit_13:
   	 mov [Num13], bx
	 
	 
    ret
endp ex13




;================================================
; Description: print in hex the 4 lower bits of AL
; INPUT:  
; OUTPUT:  on screen
; Register Usage: bx, al, dl
;================================================
proc ex14a

     xor bx, bx
	 mov bh, al
	 
	 and bh,1111b
	 cmp bh, 9
	 ja Print2
	 
Print1:	 
  	 add bh, '0'
	 mov dl, bh
	 mov ah, 2h
	 int 21h   
	 jmp Exit_14a
	 
Print2:			
	 add bh, 55
	 mov dl, bh
	 mov ah, 2h
	 int 21h  

Exit_14a:
	 
    ret
endp ex14a




;================================================
; Description: print in hex the value of AL
; INPUT:  
; OUTPUT:  
; Register Usage: al
;================================================
proc ex14b
     mov [AlValue], al
	 shr al, 4
	 call ex14a
	 mov al, [AlValue]
	 call ex14a
    ret
endp ex14b




;================================================
; Description: print in hex the value of Ax
; INPUT:  
; OUTPUT:  
; Register Usage: al
;================================================
proc ex14c

     mov [AlValue2], al
	 mov al, ah
	 call ex14b
	 mov al, [AlValue2]
	 call ex14b
	 
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
       mov bx,10  ; the 	
   
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
