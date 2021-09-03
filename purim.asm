IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
paintcircle db 4 ,4 ,4 ,4 ,4 ,4 ,4
			db 4 ,4 ,5 ,5 ,5 ,4 ,4
			db 4 ,5 ,5 ,5 ,5 ,5 ,4
			db 4 ,5 ,5 ,5 ,5 ,5 ,4
			db 4 ,5 ,5 ,5 ,5 ,5 ,4
			db 4 ,4 ,5 ,5 ,5 ,4 ,4
			
			
hamanear db  0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0
		 db  0,0,0,0,0,0,0,0,0,8,8,8,0,0,0,0,0,0,0,0,0
		 db  0,0,0,0,0,0,0,0,8,8,8,8,8,0,0,0,0,0,0,0,0
		 db  0,0,0,0,0,0,0,8,8,8,7,8,8,8,0,0,0,0,0,0,0
		 db  0,0,0,0,0,0,8,8,8,7,7,7,8,8,8,0,0,0,0,0,0
		 db  0,0,0,0,0,8,8,8,7,7,7,7,7,8,8,8,0,0,0,0,0
		 db  0,0,0,0,8,8,8,7,7,7,7,7,7,7,8,8,8,0,0,0,0
		 db  0,0,0,8,8,8,7,7,7,7,7,7,7,7,7,8,8,8,0,0,0
		 db	 0,0,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,0,0
		 db  0,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,0
		 db  8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
		 
		 
		 
palletecolor dw 0
 
 
 place dw ?
 
Matrix dw ?
CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
	call EnterrGraphic
	push 2
	call paintscreen
	push 275
	push 25
	push 56
	call drawp
	call DoDelay
	push 265
	push 5
	push 48
	call drawi
	call DoDelay
	push 255
	push 5
	push 29
	call drawr
	call DoDelay
	push 230
	push 10
	push 34
	call drawyud
	call DoDelay
	push 200
	push 5
	push 3
	call drawbigm
	call DoDelay
	push 160
	push 5
	push 21
	call drawsh
	call DoDelay
	push 150
	push 5
	push 45
	call drawm
	call DoDelay
	push 105
	push 5
	push 67
	call drawhet
	call DoDelay
	push 90
	push 5
	push 64
	call drawsiman
	push 160
	push 120
	call drawcolorpallete
	push 120
	push 100
	push 92
	push 2
	call movhamanear
	
	
	mov ah,1
	int 21h
	call EnterText
	
exit:
	mov ax, 4c00h
	int 21h
	
proc PutMatrixOnScreen
	mov si,[Matrix] ; puts offset of the Matrix to si
@@NextRow:	; loop of cx lines
	push cx ;saves cx of loop
	mov cx, dx ;sets cx for movsb
	rep movsb ; Copy whole line to the screen, si and di increases
	sub di,dx ; returns back to the begining of the line 
	add di, 320 ;go down one line in “screen” by adding 320
	pop cx  ;restores cs of loop
	loop @@NextRow
	ret
endp PutMatrixOnScreen

xpos equ [bp + 10]
ypos equ [bp + 8]
color equ [bp + 6]
bccolor equ [bp + 4]
proc movhamanear
	push bp
	mov bp,sp
	push di
	push cx
	mov di,2
	mov cx,30
@@strtmov:
	push xpos
	push ypos
	push color
	call drawhamanear
	call DoDelay
	push xpos
	push ypos
	push bccolor
	call erasehamanear
	add xpos,di
	loop @@strtmov
	
	pop cx
	pop di
	pop bp
	ret 8
endp movhamanear

color equ [bp + 4]
proc paintscreen
	push bp
	mov bp,sp
	push 0
	push 0
	push 200
	push 320
	push color
	call fullrectangle
	pop bp
	ret 2
endp paintscreen

xpos equ [bp + 8]
ypos equ [bp + 6]
color equ [bp + 4]
proc drawp
	push bp
	mov bp,sp
	push di
	push xpos
	push ypos
	push 5
	push 20
	push color
	call fullrectangle
	mov di,15
	add xpos,di
	mov di,20
	sub ypos,di
	push xpos
	push ypos
	push 20
	push 5
	push color
	call fullrectangle
	mov di,15
	sub xpos,di
	push xpos
	push ypos
	push 5
	push 15
	push color
	call fullrectangle
	push xpos
	push ypos
	push 10
	push 5
	push color
	call fullrectangle
	pop di
	pop bp
	ret 6
endp drawp


xpos equ [bp + 8]
ypos equ [bp + 6]
color equ [bp + 4]
proc drawi
	push bp
	mov bp,sp
	push xpos
	push ypos
	push 25
	push 5
	push color
	call fullrectangle
	pop bp
	ret 6
endp drawi




xpos equ [bp + 8]
ypos equ [bp + 6]
color equ [bp + 4]
proc drawbigm
	push bp
	mov bp,sp
	push cx
	push di
	push si
	push ax
	mov cx, 5
	mov si, 25
	mov di,25
	xor ax,ax
	mov al,1
@@loop:
	push xpos
	push ypos
	push di
	push si
	push color
	call emptyrectangle
	add xpos,ax
	add ypos,ax
	sub di,2
	sub si,2
	loop @@loop
	pop ax
	pop si
	pop di
	pop cx
	pop bp
	ret 6
endp drawbigm



xpos equ [bp + 8]
ypos equ [bp + 6]
color equ [bp + 4]
proc drawyud
	push bp
	mov bp,sp
	push xpos
	push ypos
	push 10
	push 5
	push color
	call fullrectangle	
	pop bp
	ret 6
endp drawyud



xpos equ [bp + 8]
ypos equ [bp + 6]
color equ [bp + 4]
proc drawr
	push bp
	mov bp,sp
	push di
	push xpos
	push ypos
	push 25
	push 5
	push color
	call fullrectangle
	mov di,15
	sub xpos,di
	push xpos
	push ypos
	push 5
	push 15
	push color
	call fullrectangle
	pop di
	pop bp
	ret 6
endp drawr
	


xpos equ [bp + 8]
ypos equ [bp + 6]
color equ [bp + 4]
proc drawsh
	push bp
	mov bp,sp
	push di
	push xpos
	push ypos
	push 20
	push 5
	push color
	call fullrectangle
	mov di,10
	add xpos,di
	push xpos
	push ypos
	push 20
	push 5
	push color
	call fullrectangle
	add xpos,di
	push xpos
	push ypos
	push 20
	push 5
	push color
	call fullrectangle
	mov di,20
	sub xpos,di
	add ypos,di
	push xpos
	push ypos
	push 5
	push 25
	push color
	call fullrectangle
	pop di	
	pop bp
	ret 6
endp drawsh



xpos equ [bp + 8]
ypos equ [bp + 6]
color equ [bp + 4]
proc drawm
	push bp
	mov bp,sp
	push di
	push si
	push xpos
	push ypos
	push 25
	push 5
	push color
	call fullrectangle
	mov di,18
	sub xpos,di
	push xpos
	push ypos
	push 25
	push 5
	push color
	call fullrectangle
	mov cx,12
	mov di,5
	add xpos,di
	mov di,2
	mov si,1
@@loop:
	push xpos
	push ypos
	push 3
	push 3
	push color
	call fullrectangle
	add xpos,si
	add ypos,di
	loop @@loop
	pop si
	pop di
	pop bp
	ret 6
endp drawm



xpos equ [bp + 8]
ypos equ [bp + 6]
color equ [bp + 4]
proc drawhet
	push bp
	mov bp,sp
	push di
	push xpos
	push ypos
	push 5
	push 20
	push color
	call fullrectangle
	push xpos
	push ypos
	push 25
	push 5
	push color
	call fullrectangle
	mov di,15
	add xpos,di
	push xpos
	push ypos
	push 25
	push 5
	push color
	call fullrectangle
	pop di
	pop bp
	ret 6
endp drawhet 





proc drawsiman
	push bp
	mov bp,sp
	push xpos
	push ypos
	push 20
	push 5
	push color
	call fullrectangle
	mov di,24
	add ypos,di
	push xpos
	push ypos
	push 5
	push 5
	push color
	call fullrectangle
	pop bp
	ret 6
	
endp drawsiman











xpos equ [bp + 12]
ypos equ [bp + 10]
linewidth equ [bp + 8]
linelength equ [bp + 6]
color equ [bp + 4]
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
	push color
	call Verticalline
	add xpos,bx
	loop @@Draw
	pop bx
	pop cx
	pop bp
	ret 10
endp fullrectangle





xpos equ [bp + 12]
ypos equ [bp + 10]
linelength equ [bp + 8]
linewidth equ [bp + 6]
color equ [bp + 4]
proc emptyrectangle
	push bp
	mov bp,sp
	push bx
	push di
	mov di,1
	push xpos
	push ypos
	push linelength
	push color
	call Verticalline
	
	push xpos
	push ypos
	push linewidth
	push color
	call Horizontalline
	
	mov bx,ypos
	add bx,linelength	
	push xpos
	push bx
	push linewidth
	push color
	call Horizontalline
	
	mov bx,xpos
	add bx,linewidth
	push bx
	push ypos
	add linelength,di
	push linelength
	push color
	call Verticalline
	pop di
	pop bx 
	pop bp
	ret 10
endp emptyrectangle






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






xpos equ [bp + 10]
ypos equ [bp + 8]
linelength equ [bp + 6]
color equ [bp + 4]

proc Horizontalline
	push bp
	mov bp,sp
	push cx
	push si
	push ax
	push bx
	mov si,linelength
	mov cx,xpos
	mov dx,ypos
@@Draw:
	mov bh,0
	mov al,color
	mov ah,0Ch
	int 10h
	dec si
	inc cx
	cmp si,0
	jnz @@Draw
	
	;Get registers
	pop bx
	pop ax
	pop si
	pop cx
	pop bp
	ret 8
endp Horizontalline







xpos equ [bp + 10]
ypos equ [bp + 8]
linelength equ [bp + 6]
color equ [bp + 4]

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
	mov al,color
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






proc DoDelay
	push cx
	mov cx,200
Delay1:
	push cx
	mov cx,6000
Delay2:
	loop Delay2
	pop cx
	loop Delay1	
	pop cx
	ret 
endp DoDelay





xpos equ [bp + 6]
ypos equ [bp + 4]
proc drawcolorpallete
	push bp
	mov bp,sp
	push cx
	push di
	push si
	xor si,si
	mov di,3
	mov cx,256
@@startpallete:
	push xpos
	push ypos
	push 3
	push 3
	push [palletecolor]
	call fullrectangle	
	add xpos,di
	inc [palletecolor]
	inc si
	cmp si,16
	je @@equal
	jne @@notequal
	
@@equal:
	mov si,0
	add ypos,di
	mov di,48
	sub xpos,di
	mov di,3
@@notequal:
	loop @@startpallete
	pop si
	pop di
	pop cx
	pop bp
	ret 4
endp drawcolorpallete


xpos equ [bp + 8]
ypos equ [bp + 6]
color equ [bp + 4]
proc drawhamanear
	push bp
	mov bp,sp
	push si
	push cx
	push di
	push bx
	push dx 
	push ax
	mov di,xpos
	mov [place],di
	mov di,1
	mov cx,15
	
@@strt:
	push cx
	mov si,di
@@draw:
	mov cx,[place]
	mov dx,ypos
	mov al,color
	mov ah,0Ch
	int 10h
	inc [place]
	mov cx,di
	dec di
	loop @@draw
	add si,2
	mov di,1
	add ypos,di
	sub xpos,di
	mov di,xpos
	mov [place],di
	mov di,si
	pop cx
	loop @@strt
	
	
	mov di,15
	add xpos,di
	mov di,10
	sub ypos,di
	mov cx,7
	mov di,4
	mov color,di
	mov di,xpos
	mov [place],di
	mov di,1
	
@@strt2:
	push cx
	mov si,di
@@draw2:
	mov cx,[place]
	mov dx,ypos
	mov al,color
	mov ah,0Ch
	int 10h
	inc [place]
	mov cx,di
	dec di
	loop @@draw2
	add si,2
	mov di,1
	add ypos,di
	sub xpos,di
	mov di,xpos
	mov [place],di
	mov di,si
	pop cx
	loop @@strt2
	
	
	
	pop ax
	pop dx
	pop bx
	pop di
	pop cx
	pop si
	pop bp
	ret 6
endp drawhamanear

xpos equ [bp + 8]
ypos equ [bp + 6]
color equ [bp + 4]
proc erasehamanear 
	push bp
	mov bp,sp
	push si
	push cx
	push di
	push bx
	push dx 
	push ax
	mov di,xpos
	mov [place],di
	mov di,1
	mov cx,15
	
@@strt:
	push cx
	mov si,di
@@draw:
	mov cx,[place]
	mov dx,ypos
	mov al,color
	mov ah,0Ch
	int 10h
	inc [place]
	mov cx,di
	dec di
	loop @@draw
	add si,2
	mov di,1
	add ypos,di
	sub xpos,di
	mov di,xpos
	mov [place],di
	mov di,si
	pop cx
	loop @@strt
	
	
	
	pop ax
	pop dx
	pop bx
	pop di
	pop cx
	pop si
	pop bp
	ret 6
endp erasehamanear


END start




