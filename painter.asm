IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------

WhiteScreen db 64000 dup (15)
matrix dw ?
color db 0
endgame db 0
palletecolor dw 0
painter db "PAINTER$"
GameOver db "GAME OVER$"
CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
	call Init
	call ShowMouse
@@Strt:
	call ReadInput
	cmp [endgame],1
	je @@sof
	jmp @@Strt
	
@@sof:
	mov ah,2
	mov bh,0h
	mov dh,0
	mov dl,160
	int 10h
	mov dx, offset GameOver
	mov ah,9
	int 21h
	call EnterText
exit:
	mov ax, 4c00h
	int 21h
	
;reset mouse, SetGraphic, paint scrin and write painter at the middle,and draws the color pallete to choose colors from
proc Init
	call ResetMouse
	call EnterrGraphic
	mov cx,200
	mov dx,320
	mov di,0
	mov bx,offset WhiteScreen
	mov [matrix],bx
	call putMatrixInScreen
	mov ah, 2
    mov bh, 0
    mov dh, 0 ;ypos
    mov dl, 15 ;xpos
    int 10h
    mov dx, offset painter
    mov ah,9
    int 21h
	push 0
	push 180
	call drawcolorpallete
	ret
endp Init



;check mouse click or if Esc was press
proc ReadInput
	mov ax,3
	int 33h
	cmp bx,2
	je @@ChangeColor
	cmp bx,1
	je @@DrawPoint
	jmp @@CheckEsc
@@ChangeColor:
	shr cx,1
	call HideMouse
	mov ah,0Dh
	mov bh,0
	int 10h
	mov [color],al
	call ShowMouse
	jmp @@CheckEsc
	
@@DrawPoint:
	call HideMouse
	shr cx,1
	call DrawPoint
	call ShowMouse
@@CheckEsc:
	mov ah,1
	int 16h
	jnz @@Check
	jz @@finish
	
	
@@Check:
	cmp ah,1
	je @@endgame
	jmp @@finish

@@endgame:
	mov [endgame],1
	
@@finish:		
	ret
endp ReadInput
	
	
	
;draw a point with cx,dx, cordinates
proc DrawPoint
	mov ah,0Ch
	mov al,[color]
	mov bh,0H
	int 10h
	ret
endp DrawPoint
	
	
;reapears the mouse
proc ShowMouse
	mov ax,1
	int 33h
	ret
endp ShowMouse


;dissapear the mouse
proc HideMouse
	mov ax,2
	int 33h
	ret
endp HideMouse


;reset mouse
proc ResetMouse
	mov ax,0
	int 33h
	ret
endp ResetMouse


	
;draw the color pallete at the wanted cordinate	
xpos equ [bp + 6]
ypos equ [bp + 4]
proc drawcolorpallete
	push bp
	mov bp,sp
	push cx
	push di
	push si
	xor si,si
	mov di,16
	mov cx,40
@@startpallete:
	push xpos
	push ypos
	push 10
	push 16
	push [palletecolor]
	call fullrectangle	
	add xpos,di
	inc [palletecolor]
	inc si
	cmp si,20
	je @@equal
	jne @@notequal
	
@@equal:
	mov si,0
	mov di,10
	add ypos,di
	mov di,0
	mov xpos,di
	mov di,16
@@notequal:
	loop @@startpallete
	pop si
	pop di
	pop cx
	pop bp
	ret 4
endp drawcolorpallete




; in dx how many cols 
; in cx how many rows
; in matrix - the bytes
; in di start byte in screen (0 64000 -1)

proc putMatrixInScreen
	push es
	push ax
	push si
	
	mov ax, 0A000h
	mov es, ax
	cld ; for movsb direction si --> di
	
	
	mov si,[matrix]
	
NextRow:	
	push cx
	
	mov cx, dx
	rep movsb ; Copy whole line to the screen, si and di advances in movsb
	sub di,dx ; returns back to the begining of the line 
	add di, 320 ; go down one line by adding 320
	
	
	pop cx
	loop NextRow
	
		
	pop si
	pop ax
	pop es
    ret
endp putMatrixInScreen




xpos equ [bp + 12]
ypos equ [bp + 10]
linewidth equ [bp + 8]
linelength equ [bp + 6]
color1 equ [bp + 4]
proc fullrectangle
	push bp
	mov bp,sp
	push cx
	push bx
	xor bx,bx
	mov bl,1
	mov cx,linelength
@@Draw:
	push xpos
	push ypos
	push linewidth
	push color1
	call Verticalline
	add xpos,bx
	loop @@Draw
	pop bx
	pop cx
	pop bp
	ret 10
endp fullrectangle




xpos equ [bp + 10]
ypos equ [bp + 8]
linelength equ [bp + 6]
color1 equ [bp + 4]

proc Verticalline
	push bp
	mov bp,sp
	push cx
	push si
	push ax
	push bx
	mov si,linelength
	mov bh,0
	mov cx,xpos
	mov dx,ypos
@@Draw:
	mov al,color1
	mov ah,0Ch
	int 10h
	dec si
	inc dx
	cmp si,0
	jnz @@Draw
	
	;Get registers
	pop bx
	pop ax
	pop si
	pop cx
	pop bp
	ret 8
endp Verticalline




proc EnterrGraphic
	mov ax,13h
	int 10h
	ret 
endp EnterrGraphic

proc EnterText
	mov ax,2
	int 10h
	ret
endp EnterText




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


