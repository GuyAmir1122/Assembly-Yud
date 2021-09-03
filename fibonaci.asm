IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
output	 db 	"Enter two numbers", 10 , 13 , "$"
var1	 db		?
var2 	 db 	?
sum 	 db	    0

fibo db 0,1,?,?,?,?,?,?,?,?

shurotoutput db "Enter the amount of lines you want",10,13,"$"
xoutput db "Enter the amount of x you want int each line",10,13,"$"
shurotnum db ?
xnum db ?

abc db ?,?,?,?,?,?,?,?,?,?,?,?,?

MyNums   db   101, 130, 30, 201, 120, -3, 100, 255, 0

CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------

			mov [var1],30
			mov [var2],2
			mov ah,0
			mov al,[var1]
			mov cx,ax			
			mov bl,[var2]
addup:		
			add [sum],bl
			loop addup
			
fiboexe:
			mov cx,7
			mov bx,0
			fiboloop:
			mov al,[fibo + bx]
			add al,[fibo + bx + 1]
			mov [fibo + bx + 2],al
			inc bx
			loop fiboloop
			
malbenexe:
				mov dx ,offset shurotoutput ;ask for amount of lines
				mov ah,9
				int 21h				
				mov ah,1 ;input the lines number
				int 21h
				mov [shurotnum],al
				sub [shurotnum],'0';make it a number
				mov dl, 10
				mov ah, 02h
				int	21h
				mov dl, 13 ;go a line down
				mov ah, 02h
				int	21h
				mov dx ,offset xoutput ;ask for amount of x int each line
				mov ah,9
				int 21h
				mov ah,1 ;input the x number
				int 21h
				mov [xnum],al
				sub [xnum],'0';make it a number
				mov dl, 10
				mov ah, 02h
				int	21h
				mov dl, 13 ;go a line down
				mov ah, 02h
				int	21h
				
				
resetcx:
				mov bh,0
				mov bl,[xnum]
				mov cx,bx ;reset cx to xnum after every loop
printxline:			
				mov dl,"x"
				mov ah,2
				int 21h
				loop printxline ;print x the wanted amount of times
				mov bh,0
				mov bl,[shurotnum]
				mov cx,bx	 ;then put the shurotnum in cx and dec it
				dec [shurotnum]
goalinedown:
				mov dl, 10
				mov ah, 02h
				int	21h
				mov dl, 13 ;go a line down
				mov ah, 02h
				int	21h
				loop resetcx ;go back to the start
				

abcexe:
				mov al,'a' ;move to al the starter letter
				mov bx,0
				mov cx,13 ;amount of letters
loopstart:
				mov [abc + bx],al ;mov the letter to its place
				inc bx
				inc al
				loop loopstart
				
positivesum:
				mov ax,0
				mov bx,-1
startadding:
				inc bx
				cmp [byte MyNums + bx],0
				je exit;if the number equale to 0 exit
				cmp [byte MyNums + bx],100					
				jg addtoal ;if the number is bigger then 100 signd check if its lower then 128
				jmp startadding ;else, go to start and check another number
				
addtoal:
				add al,[byte MyNums + bx] ;add to al
				jmp startadding
exit:
	mov ax, 4c00h
	int 21h
END start


