IDEAL
MODEL small
BMP_WIDTH = 260
BMP_HEIGHT = 194

BMP_SMALL_WIDTH = 150
BMP_SMALL_HEIGHT = 111


YesNo_WIDTH = 75
YesNo_HEIGHT = 40

ScreenWidth = 320
ScreenHeight = 100

STACK 100h

FILE_NAME_IN  equ 'bin.bmp'
FILE_NAME_SMALL  equ 'binsml.bmp'
YesNo_Name  equ 'YesNo.bmp'



DATASEG
; --------------------------
; Your variables here
; --------------------------
	RndCurrentPos dw 0
	
	ScrLine 	db 320 dup (0)  ; One picture line read buffer

	;BMP File data
	FileName 	db FILE_NAME_IN ,0
	FileHandle	dw ?
	Header 	    db 54 dup(0)
	Palette 	db 400h dup (0)
	
	FileName1 	db FILE_NAME_SMALL ,0
	FileName2 	db YesNo_Name ,0
	BmpFileErrorMsg    	db 'Error At Opening Bmp File ',FILE_NAME_IN, 0dh, 0ah,'$'
	ErrorFile           db 0
			  
	
	BmpLeft dw ?
	BmpTop dw ?
	BmpColSize dw ?
	BmpRowSize dw ?
	
	WhiteMatrix db   BMP_SMALL_WIDTH*BMP_SMALL_HEIGHT dup (246) 
	WhiteScreen db 32000 dup (246)
	WhiteScreen2 db 3200 dup (246)
	
	matrix dw ?
	palletecolor dw 0
	points db 0
	time db 20		
	writepoints db "Points:$"
	writetime db "Time:$"
	color db ?
	timecount db 0
	yes db ?
	
CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------



Before:
	mov [yes],0
	call Init
	
@@strt:
	push cx
	call SetPhotoPlace
	call DrawPhoto
	cmp [ErrorFile],1
	je exitError
	call ShowTime
	mov cx,47
	mov bl,[points]
@@Delay:	
	call CheckMousePress
	call DoDelay
	cmp bl,[points]
	jne @@AfterDelay
	loop @@Delay
	jmp @@Erase
@@AfterDelay:
	push cx
	call DoDelay
	pop cx
	loop @@AfterDelay
@@Erase:
	call ErasePhoto
	pop cx
	sub [time],1
	call Check10Sec
	cmp [time],0
	je exit
	jmp @@strt
	
	

	
	jmp exit
exitError:
	mov ax,2
	int 10h
	
    mov dx, offset BmpFileErrorMsg
	mov ah,9
	int 21h
	
exit:
	call HideMouse
	call BlackScreen
	call ShowMouse
	call DrawYes
	cmp [ErrorFile],1	
	je exitError
	call RegisterYes
@@CheckYes:
	cmp [yes],1
	je Before
	cmp [yes],2
	je @@EndGame
	jmp @@CheckYes
	
@@EndGame:
	call HideMouse
	call BlackScreen
	call ShowMouse
	mov ah,7
	int 21h
	
	mov ax,2
	int 10h

	
	mov ax, 4c00h
	int 21h
	
	
	
;reset mouse, draw background, sets graphics, sets cx for loop
proc Init
	call ResetMouse
	call SetGraphic
	mov cx,100
	mov dx,320
	mov di,0
	mov bx,offset WhiteScreen
	mov [matrix],bx
	call putMatrixInScreen
	mov cx,100
	mov dx,320 
	mov di,32000
	call putMatrixInScreen
	call ShowPoints
	call ShowMouse
	ret
endp Init

;draw the photo with current cordinats
proc DrawPhoto
	call HideMouse
	mov [BmpColSize], BMP_SMALL_WIDTH
	mov [BmpRowSize] ,BMP_SMALL_HEIGHT
	mov dx, offset FileName1
	call OpenShowBmp 
	call ShowMouse
	ret
endp DrawPhoto

proc DrawYes
	
	mov [BmpTop],90
	mov [BmpLeft],120
	mov [BmpColSize], YesNo_WIDTH
	mov [BmpRowSize] ,YesNo_HEIGHT
	mov dx, offset FileName2
	call HideMouse
	call OpenShowBmp
	call ShowMouse
	ret
endp DrawYes

;sets new cordinats to the photo
proc SetPhotoPlace
	mov bx,0
	mov dx,170
	call RandomByCsWord
	mov [BmpLeft],ax
	
	mov bx,15
	mov dx,89
	call RandomByCsWord
	mov [BmpTop],ax
	ret
endp SetPhotoPlace


;delets the photo with background color
proc ErasePhoto
	call HideMouse
	mov ax,[BmpTop]
	mov di,320
	mul di
	add ax,[BmpLeft]
	mov cx,BMP_SMALL_HEIGHT
	mov dx,BMP_SMALL_WIDTH
	add ax,320  
	mov di,ax
	mov bx,offset WhiteMatrix
	mov [matrix], bx
	call putMatrixInScreen
	call ShowMouse
	ret 
endp ErasePhoto



proc CheckMousePress
	push bx
	push cx
	mov ax,3
	int 33h
	shr cx,1
	cmp bx,1
	je @@CheckColor
	jmp @@EnD
@@CheckColor:
	call HideMouse
	mov ah,0Dh
	mov bh,0
	int 10h
	mov [color],al
	call ShowMouse
	cmp [color],246
	jne @@AddPoint
	jmp @@End
@@AddPoint:
	mov al,1
	add [points],al
	call ShowPoints
	call OpenSpeaker
	Call MakeSoundD
	call DoDelay100
	call CloseSpeaker
@@EnD:
	pop cx
	pop bx
	ret
endp CheckMousePress

proc CheckMouseYes  far
	shr cx,1	
	
@@KeepCheck:
	cmp dx,90
	jae @@yesno
	jmp @@End
@@yesno:
	cmp dx,130
	jbe @@CheckYesNo
	jmp @@End
@@CheckYesNo:
	cmp cx,157
	jbe @@yes1
	
@@no:
	cmp cx,195
	jbe @@no2
	jmp @@End
	
@@yes1:
	cmp cx,120
	jae @@yes2
	jmp @@End
	
	
	
@@yes2:
	mov [yes],1
	mov [time],20
	mov [points],0
	jmp @@End
@@no2:
	mov [yes],2
@@End:
	ret
endp CheckMouseYes

proc RegisterYes  

push ds
pop  es	 
mov ax, seg CheckMouseYes 
mov es, ax
mov dx, offset CheckMouseYes   ; ES:DX ->Far routine
     mov ax,0Ch             ; interrupt number
     mov cx,02h              
     int 33h                
	ret
endp RegisterYes

;draw points
proc ShowPoints
	mov ah, 2
    mov bh, 0
    mov dh, 0 ;ypos
    mov dl, 15 ;xpos
    int 10h
    mov dx, offset writepoints
    mov ah,9
    int 21h
	xor ax,ax
	mov al,[points]
	call printAxDec
	ret
endp ShowPoints

;draw time left
proc ShowTime
	mov ah, 2
    mov bh, 0
    mov dh, 0 ;ypos
    mov dl, 25 ;xpos
    int 10h
    mov dx, offset writetime
    mov ah,9
    int 21h
	xor ax,ax
	mov al,[time]
	call printAxDec
	ret
endp ShowTime


;checks if the seconds are under 10, if not does nothing, if yes, retype the seconds
proc Check10Sec
	cmp [time],9
	je @@retype
	jmp @@End
@@retype:
	mov cx,10
	mov dx,320
	mov di,0
	mov bx,offset WhiteScreen2
	mov [matrix],bx
	call putMatrixInScreen
	call ShowPoints
	call ShowTime
@@End:
	ret
endp Check10Sec

proc DecTime
	push ax
	push bx
	mov al,[timecount]
	mov bl,2
	div bl
	cmp ah,0
	je @@Dec
	jmp @@End
@@Dec:
	sub [time],1
@@End:
	pop bx
	pop ax
	ret
endp DecTime

proc ResetMouse
	mov ax,0
	int 33h
	ret
endp ResetMouse

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

	; input dx FileName
proc OpenShowBmp near
	
	 
	call OpenBmpFile
	cmp [ErrorFile],1
	je @@ExitProc
	
	call ReadBmpHeader
	
	call ReadBmpPalette
	
	call CopyBmpPalette
	
	call  ShowBmp
	
	 
	call CloseBmpFile

@@ExitProc:
	ret
endp OpenShowBmp

 

; input dx filename to open
proc OpenBmpFile	near						 
	mov ah, 3Dh
	xor al, al
	int 21h
	jc @@ErrorAtOpen
	mov [FileHandle], ax
	jmp @@ExitProc
	
@@ErrorAtOpen:
	mov [ErrorFile],1
@@ExitProc:	
	ret
endp OpenBmpFile

; input [FileHandle]
proc CloseBmpFile near
	mov ah,3Eh
	mov bx, [FileHandle]
	int 21h
	ret
endp CloseBmpFile


; Read and skip first 54 bytes the Header
proc ReadBmpHeader	near					
	push cx
	push dx
	
	mov ah,3fh
	mov bx, [FileHandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	
	pop dx
	pop cx
	ret
endp ReadBmpHeader

; Read BMP file color palette, 256 colors * 4 bytes (400h)
; 4 bytes for each color BGR (3 bytes) + null(transparency byte not supported)	
proc ReadBmpPalette near 		
	push cx
	push dx
	
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	
	pop dx
	pop cx
	
	ret
endp ReadBmpPalette


; Will move out to screen memory the pallete colors
; video ports are 3C8h for number of first color (usually Black, default)
; and 3C9h for all rest colors of the Pallete, one after the other
; in the bmp file pallete - each color is defined by BGR = Blue, Green and Red
proc CopyBmpPalette		near					
										
	push cx
	push dx
	
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0  ; black first							
	out dx,al ;3C8h
	inc dx	  ;3C9h
CopyNextColor:
	mov al,[si+2] 		; Red				
	shr al,2 			; divide by 4 Max (max is 63 and we have here max 255 ) (loosing color resolution).				
	out dx,al 						
	mov al,[si+1] 		; Green.				
	shr al,2            
	out dx,al 							
	mov al,[si] 		; Blue.				
	shr al,2            
	out dx,al 							
	add si,4 			; Point to next color.(4 bytes for each color BGR + null)				
								
	loop CopyNextColor
	
	pop dx
	pop cx
	
	ret
endp CopyBmpPalette

 
proc ShowBMP 
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpRowSize lines in VGA format),
; displaying the lines from bottom to top.
	push cx
	
	mov ax, 0A000h
	mov es, ax
	
	mov cx,[BmpRowSize]
	
 
	mov ax,[BmpColSize] ; row size must dived by 4 so if it less we must calculate the extra padding bytes
	xor dx,dx
	mov si,4
	div si
	cmp dx,0
	mov bp,0
	jz @@row_ok
	mov bp,4
	sub bp,dx

@@row_ok:	
	mov dx,[BmpLeft]
	
@@NextLine:
	push cx
	push dx
	
	mov di,cx  ; Current Row at the small bmp (each time -1)
	add di,[BmpTop] ; add the Y on entire screen
	
 
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	mov cx,di
	shl cx,6
	shl di,8
	add di,cx
	add di,dx
	 
	; small Read one line
	mov ah,3fh
	mov cx,[BmpColSize]  
	add cx,bp  ; extra  bytes to each row must be divided by 4
	mov dx,offset ScrLine
	int 21h
	; Copy one line into video memory
	cld ; Clear direction flag, for movsb
	mov cx,[BmpColSize]  
	mov si,offset ScrLine
	rep movsb ; Copy line to the screen
	
	pop dx
	pop cx
	 
	loop @@NextLine
	
	pop cx
	ret
endp ShowBMP 



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



proc BlackScreen
	push 0
	push 0
	push 200
	push 320
	push 0
	call fullrectangle
	ret
endp BlackScreen
	

; delay of 10 mSec
proc DoDelay
	push cx
	mov cx, 10
	Delay1:
		push cx
		mov cx, 6000
		Delay2:
			loop Delay2
		pop cx
	loop Delay1
	pop cx
	ret
endp DoDelay

; delay of 100 mSec
proc DoDelay100
	push cx
	mov cx, 100
	@@Delay1:
		push cx
		mov cx, 6000
		@@Delay2:
			loop @@Delay2
		pop cx
	loop @@Delay1
	pop cx
	ret
endp DoDelay100

proc  SetGraphic
	mov ax,13h   ; 320 X 200 
				 ;Mode 13h is an IBM VGA BIOS mode. It is the specific standard 256-color mode 
	int 10h
	ret
endp 	SetGraphic



;put some data in Code segment in order to have enough bytes to xor with 
	SomeRNDData	    db 227	,111	,105	,1		,127
					db 234	,6		,116	,101	,220
					db 92	,60		,21		,228	,22
					db 222	,63		,216	,208	,146
					db 60	,172	,60		,80		,30
					db 23	,85		,67		,157	,131
					db 120	,111	,105	,49		,107
					db 148	,15		,141	,32		,225
					db 113	,163	,174	,23		,19
					db 143	,28		,234	,56		,74
					db 223	,88		,214	,122	,138
					db 100	,214	,161	,41		,230
					db 8	,93		,125	,132	,129
					db 175	,235	,228	,6		,226
					db 202	,223	,2		,6		,143
					db 8	,147	,214	,39		,88
					db 130	,253	,106	,153	,147
					db 73	,140	,251	,32		,59
					db 92	,224	,138	,118	,200
					db 244	,4		,45		,181	,62
					


; Description  : get RND between any bl and bh includs (max 0 -255)
; Input        : 1. Bl = min (from 0) , BH , Max (till 255)
; 			     2. RndCurrentPos a  word variable,   help to get good rnd number
; 				 	Declre it at DATASEG :  RndCurrentPos dw ,0
;				 3. EndOfCsLbl: is label at the end of the program one line above END start		
; Output:        Al - rnd num from bl to bh  (example 50 - 150)
; More Info:
; 	Bl must be less than Bh 
; 	in order to get good random value again and agin the Code segment size should be 
; 	at least the number of times the procedure called at the same second ... 
; 	for example - if you call to this proc 50 times at the same second  - 
; 	Make sure the cs size is 50 bytes or more 
; 	(if not, make it to be more) 
proc RandomByCs
    push es
	push si
	push di
	
	mov ax, 40h
	mov	es, ax
	
	sub bh,bl  ; we will make rnd number between 0 to the delta between bl and bh
			   ; Now bh holds only the delta
	cmp bh,0
	jz @@ExitP
 
	mov di, [word RndCurrentPos]
	call MakeMask ; will put in si the right mask according the delta (bh) (example for 28 will put 31)
	
RandLoop: ;  generate random number 
	mov ax, [es:06ch] ; read timer counter
	mov ah, [byte cs:di] ; read one byte from memory (from semi random byte at cs)
	xor al, ah ; xor memory and counter
	
	; Now inc di in order to get a different number next time
	inc di
	cmp di,(EndOfCsLbl - start - 1)
	jb @@Continue
	mov di, offset start
@@Continue:
	mov [word RndCurrentPos], di
	
	and ax, si ; filter result between 0 and si (the nask)
	cmp al,bh    ;do again if  above the delta
	ja RandLoop
	
	add al,bl  ; add the lower limit to the rnd num
		 
@@ExitP:	
	pop di
	pop si
	pop es
	ret
endp RandomByCs


; Description  : get RND between any bl and bh includs (max 0 -255)
; Input        : 1. BX = min (from 0) , DX, Max (till 64k -1)
; 			     2. RndCurrentPos a  word variable,   help to get good rnd number
; 				 	Declre it at DATASEG :  RndCurrentPos dw ,0
;				 3. EndOfCsLbl: is label at the end of the program one line above END start		
; Output:        AX - rnd num from bx to dx  (example 50 - 1550)
; More Info:
; 	BX  must be less than DX 
; 	in order to get good random value again and again the Code segment size should be 
; 	at least the number of times the procedure called at the same second ... 
; 	for example - if you call to this proc 50 times at the same second  - 
; 	Make sure the cs size is 50 bytes or more 
; 	(if not, make it to be more) 
proc RandomByCsWord
    push es
	push si
	push di
 
	
	mov ax, 40h
	mov	es, ax
	
	sub dx,bx  ; we will make rnd number between 0 to the delta between bl and bh
			   ; Now bh holds only the delta
	cmp dx,0
	jz @@ExitP
	
	push bx
	
	mov di, [word RndCurrentPos]
	call MakeMaskWord ; will put in si the right mask according the delta (bh) (example for 28 will put 31)
	
@@RandLoop: ;  generate random number 
	mov bx, [es:06ch] ; read timer counter
	
	mov ax, [word cs:di] ; read one word from memory (from semi random bytes at cs)
	xor ax, bx ; xor memory and counter
	
	; Now inc di in order to get a different number next time
	inc di
	inc di
	cmp di,(EndOfCsLbl - start - 2)
	jb @@Continue
	mov di, offset start
@@Continue:
	mov [word RndCurrentPos], di
	
	and ax, si ; filter result between 0 and si (the nask)
	
	cmp ax,dx    ;do again if  above the delta
	ja @@RandLoop
	pop bx
	add ax,bx  ; add the lower limit to the rnd num
		 
@@ExitP:
	
	pop di
	pop si
	pop es
	ret
endp RandomByCsWord

; make mask acording to bh size 
; output Si = mask put 1 in all bh range
; example  if bh 4 or 5 or 6 or 7 si will be 7
; 		   if Bh 64 till 127 si will be 127
Proc MakeMask    
    push bx

	mov si,1
    
@@again:
	shr bh,1
	cmp bh,0
	jz @@EndProc
	
	shl si,1 ; add 1 to si at right
	inc si
	
	jmp @@again
	
@@EndProc:
    pop bx
	ret
endp  MakeMask


Proc MakeMaskWord    
    push dx
	
	mov si,1
    
@@again:
	shr dx,1
	cmp dx,0
	jz @@EndProc
	
	shl si,1 ; add 1 to si at right
	inc si
	
	jmp @@again
	
@@EndProc:
    pop dx
	ret
endp  MakeMaskWord



; get RND between bl and bh includs
; output al - rnd num from bl to bh
; the distance between bl and bh  can't be greater than 100 
; Bl must be less than Bh 
proc RndBlToBh  ; by Dos  with delay
	push  cx
	push dx
	push si 


	mov     cx, 1h
	mov     dx, 0C350h
	mov     ah, 86h
	int     15h   ; Delay of 50k micro sec
	
	sub bh,bl
	cmp bh,0
	jz @@EndProc
	
	call MakeMask ; will put in si the right mask (example for 28 will put 31)
RndAgain:
	mov ah, 2ch   
	int 21h      ; get time from MS-DOS
	mov ax, dx   ; DH=seconds, DL=hundredths of second
	and ax, si  ;  Mask for Highst num in range  
	cmp al,bh    ; we deal only with al (0  to 100 )
	ja RndAgain
 	
	add al,bl

@@EndProc:
	pop si
	pop dx
	pop cx
	
	ret
endp RndBlToBh

proc OpenSpeaker

	in al,61h
	or al,00000011b
	out 61h,al
	mov al,0B6h
	out 43h,al
	ret
endp OpenSpeaker


proc CloseSpeaker 

	in al,61h
	and al,11111100b
	out 61h,al
	ret
endp CloseSpeaker

proc MakeSoundD

	mov al,0FDh
	out 42h,al
	mov al,0Fh
	out 42h,al
	ret 
endp MakeSoundD

proc MakeSoundC

	mov al,10h
	out 42h,al
	mov al,0D0h
	out 42h,al
	ret 
endp MakeSoundC

	 
proc printAxDec  
	   
       push bx
	   push dx
	   push cx
	           	   
       mov cx,0   ; will count how many time we did push 
       mov bx,10  ; the divider
   
put_next_to_stack:
       xor dx,dx
       div bx
       add dl,30h
	   ; dl is the current LSB digit 
	   ; we cant push only dl so we push all dx
       push dx    
       inc cx
       cmp ax,9   ; check if it is the last time to div
       jg put_next_to_stack

	   cmp ax,0
	   jz pop_next_from_stack  ; jump if ax was totally 0
       add al,30h  
	   mov dl, al    
  	   mov ah, 2h
	   int 21h        ; show first digit MSB
	       
pop_next_from_stack: 
       pop ax    ; remove all rest LIFO (reverse) (MSB to LSB)
	   mov dl, al
       mov ah, 2h
	   int 21h        ; show all rest digits
       loop pop_next_from_stack

	   pop cx
	   pop dx
	   pop bx
	   
       ret
endp printAxDec 


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

  

 
; int 15h has known bug dont use it.
proc timeAx
    push  cx
	push dx
	
 	mov     cx, 0h
	mov     dx, 0C350h
	mov     ah, 86h
	int     15h   ; Delay of 50k micro sec

	
	
    mov ah, 2ch   
	int 21h      ; get time from MS-DOS
	mov ax, dx   ; DH=seconds, DL=hundredths of second
	
	pop dx
	pop cx
	
    ret	
endp timeAx


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

EndOfCsLbl:
END start


