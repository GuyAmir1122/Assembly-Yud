IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
;targil 1
var1 db 15
var2 db 17
;targil 3
numinp db "xx12x" ,10,13,'$'
numout db "xx" ,10,13,'$'
num db ?
smal db "Small" ,10,13, '$'
mid db "Medium" ,10,13,'$'
big db "Big" ,10,13,'$'
equal db "Equal" ,10,13,'$'
;targil 4
numinp2 db "xx1x" ,10,13
charinp db "xx1x" ,10,13

CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
targil1:

mov dl,[var1] 
cmp dl,[var2] ;compare the two vars
ja Above1 ;if var1 is bigger go to Above1
jb Above2 ;if var2 is bigger go to Above2
Above1:
mov ax,1 ;put 1 in ax
jmp targil2 ;end the targil
Above2:
mov ax,0 ;put 0 in ax

targil2:
mov ax,1 ;put a number in ax
cmp ax,0 ;compare it to 0
jge axbigger ;if ax is bigger or equal to 0 jump to axbigger
jl targil3 ;else, end the targil
axbigger:
dec ax ;decrease ax


targil3:
mov [byte numinp],3
mov dx,offset numinp ;insert a num
mov ah,0ah
int 21h
sub [numinp + 2],'0' ;change to the number 
sub [numinp + 3],'0' ;change to the number 
mov al,[numinp + 2] ;move the asarot digit to al
mov bl,10
mul bl ;mul it by 10
add al,[numinp+3] ;add to it the other digit
mov [num],al ;mov the number to num
cmp [num],50 ;compare to 50
jbe less50 ;if less or equal jump to less50
ja above50 ;if above jump to above50
less50:
mov dx ,offset smal
mov ah,9 ;print small
int 21h
jmp finish ;jump to the second section
above50:
cmp [num],75 ;cmp to 75
jb between ;if between 50 and 75 jump to between
ja bigger ; if bigger jump to bigger
je same ;if equal jump to same
between: 
mov dx, offset mid
mov ah,9 ;print medium and jump to the second section
int 21h
jmp finish ;
bigger:
mov dx ,offset big
mov ah,9 ;print big and jump to the second section
int 21h
jmp finish
same:
mov dx ,offset equal ;print equal and jump to the second section
mov ah,9
int 21h
finish:
mov al,[numinp + 2]
mul [numinp + 3] ;mul the digits
cmp al,10 ;compare to 10
jae twodigits ;if bigger or equal jump to twodigits
jb onedigit ;if smaller jump to onedigit
twodigits:
mov bl,10 
div bl ;seperate the digits
add al,'0' ;change to char
add ah,'0' ;change to char
mov [numout],al 
mov [numout + 1],ah ;move the digits to a var
mov dx, offset numout ;print the var
mov ah,9
int 21h
jmp finish1 ;jump to end
onedigit:
mov bl,10 
div bl ;seperate the digit from the 0
add ah,'0' ;change to char
mov dl,ah ;print the char
mov ah,2
int 21h
finish1:

targil4:
mov [byte numinp2],2
mov dx, offset numinp2
mov ah,0ah
int 21h ;input number
mov [byte charinp],2
mov dx, offset charinp
mov ah,0ah
int 21h ;input char
sub [numinp2 + 2],'0' ;change to the number
checknum:
cmp [numinp2 + 2],0 ;checking the number
je finish2 ;if equal to 0 finish
ja print ;if above 0 print another char
print:
mov dl,[charinp + 2]
mov ah,2 ; print the input char
int 21h
dec [numinp2 + 2]
jmp checknum ;jump to check the number again
finish2:
exit:
	mov ax, 4c00h
	int 21h
END start


