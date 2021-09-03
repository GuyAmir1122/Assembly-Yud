IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
num1 db ?
num2 db "?$"
input db "xx1234x"
BigStr db "xx1234x"
SmallStr db "????$"

CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
;2
mov ah, 1h
int 21h
mov [num1],al
mov ah, 1h
int 21h
mov [num2], al
sub [num1],30h
sub [num2],30h
mov al,[num1]
mul [num2]
add al,30h
mov dl, al  
mov ah, 2
int 21h

;3
mov ah, 1h
int 21h
mov [num1],al
mov ah, 1h
int 21h
mov [num2], al
sub [num1],30h
sub [num2],30h
mov al,[num1]
mul [num2]
add al,30h
mov [num2],al
mov dx,offset num2
mov ah, 9
int 21h

;4
mov [input],5 
mov dx, offset input
mov ah, 0Ah     
int 21h
mov dl, [input + 5]  
mov ah, 2
int 21h
mov dl, [input + 4]   
mov ah, 2
int 21h
mov dl, [input + 3]   
mov ah, 2
int 21h
mov dl, [input + 2]   
mov ah, 2
int 21h

;5
mov [BigStr],5 
mov dx, offset BigStr
mov ah, 0Ah     
int 21h
or [BigStr + 2], 00100000b
mov bl,[BigStr +2]
mov [SmallStr],bl
or [BigStr + 3], 00100000b
mov bl,[BigStr +3]
mov [SmallStr + 1],bl
or [BigStr + 4], 00100000b
mov bl,[BigStr +4]
mov [SmallStr + 2],bl
or [BigStr + 5], 00100000b
mov bl,[BigStr +5]
mov [SmallStr + 3],bl
mov dx, offset SmallStr  
mov ah, 9
int 21h


exit:
	mov ax, 4c00h
	int 21h
END start


