IDEAL
MODEL small

MOVE_SIDE = 22
MOVE_UP = 22


BOARD_WIDTH = 200
BOARD_HEIGHT = 200

PLAYER_WIDTH = 15
PLAYER_HEIGHT = 15




STACK 100h

REDP_NAME  equ 'RedP.bmp'
GREENP_NAME  equ 'GreenP.bmp'
EMPTY_SPOT equ 'Empty.bmp'
YELLOW_SPOT equ 'Yellow.bmp'
BLUE_SPOT equ 'Blue.bmp'
WALL_BUTTON equ 'Button.bmp'
X_BUTTON equ 'XButton.bmp'
GAME_OPENING equ 'Opening.bmp'
DATASEG
; --------------------------
; Your variables here
; --------------------------
	GreenPName 	db GREENP_NAME ,0
	RedPName 	db REDP_NAME ,0
	EmptyName 	db EMPTY_SPOT ,0
	YellowName 	db YELLOW_SPOT ,0
	BlueName 	db BLUE_SPOT ,0
	WallButtonName db WALL_BUTTON ,0
	XButtonName db X_BUTTON ,0
	Opening db GAME_OPENING ,0
	WallButton db 0
	YellowOn db 0	
	IsWallPressed db 0
	GreenWalls dw 10
	RedWalls dw 10
	RedX dw 92
	RedY dw 180
	GreenX dw 92
	GreenY dw 4
	YellowX dw 0
	YellowY dw 0
	LastWallX dw 0
	LastWallY dw 0
	CheckWallX dw 0
	CheckWallY dw 0
	GreenWallsLeftX dw 215
	GreenWallsLeftY dw 10
	RedWallsLeftX dw 215
	RedWallsLeftY dw 120
	LastWallShape db 'H'
	IsDemiWallDrawn db 0
	Turn db 'R'
	GPPlace dw 8
	RPPlace dw 280
	GameOver db 0
	FileHandle	dw ?
	Header 	    db 54 dup(0)
	Palette 	db 400h dup (0)
	BmpFileErrorMsg    	db 'Error At Opening Bmp File', 0dh, 0ah,'$'
	ErrorFile           db 0			  	
	BmpLeft dw ?
	BmpTop dw ?
	BmpColSize dw ?
	BmpRowSize dw ?
	ScrLine 	db 320 dup (0)  ; One picture line read buffer
	matrix dw ?
	palletecolor dw 0	
	BlackMatrix db 32000 dup (0)
	GrayMatrix db 24000 dup (248)
	presskey db "press any key to start playing$"
	RPWon db "Congrats! The Red Player Won!$"
	GPWon db "Congrats! The Green Player Won!$"
	Seperation db 100 dup (?)
	 
	Board db 'E',' ','E',' ','E',' ','E',' ','G',' ','E',' ','E',' ','E',' ','E'
		  db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
		  db 'E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E'
		  db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
		  db 'E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E'
		  db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
		  db 'E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E'
		  db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
		  db 'E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E'        ;the array that represents the board throught the game
		  db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
		  db 'E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E'
		  db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
		  db 'E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E'
		  db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
		  db 'E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E',' ','E'
		  db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
		  db 'E',' ','E',' ','E',' ','E',' ','R',' ','E',' ','E',' ','E',' ','E' 
		  
	Seperation2 db 100 dup (?)
CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
	
	call Init
	call RegisterMousePressMove
@@Move:
	call IsGameOver
	cmp [GameOver],1
	je exit
	jmp @@Move
exit:
	call BlackScreen
	call SetText
	call ShowMouse
	
	mov ax, 4c00h
	int 21h
	
	
	
	
;Prepares the game so all things are in place and ready to use
proc Init
	call HideMouse
	call SetGraphic
	call DrawOpening
	call printpress
	mov ah,1
	int 21h
	call DrawBlock
	call DrawBoard
	call DrawXButton
	call DrawWallButton
	call PrepareBoard
	
	call DrawRP
	call DrawGP
	call DrawGreenWallsLeft
	call DrawRedWallsLeft
	call ShowMouse
	ret
endp Init
	
	
;Draws the board with OpenShowBmp 
proc DrawBoard
	push 0
	push 0
	push 200
	push 200
	push 6
	call fullrectangle
	ret
endp DrawBoard	



proc DrawWallButton
	call HideMouse
	mov [BmpLeft],220
	mov [BmpTop],95
	mov [BmpColSize], 80
	mov [BmpRowSize] ,15
	mov dx, offset WallButtonName
	call OpenShowBmp 
	call ShowMouse
	ret
endp DrawWallButton


;checks if the wall button got pressed, and turns it off or on
proc CheckIfWallButtonPressed
	cmp [Turn],'R'
	je @@CheckRedWalls
@@CheckGreenWalls:
	cmp [GreenWalls],0
	je @@Exit
	jmp @@CheckButtonPress
@@CheckRedWalls:	
	cmp [RedWalls],0
	je @@Exit
	
@@CheckButtonPress:	
	cmp cx,220
	jae @@SecondCheck
	jmp @@Exit
@@SecondCheck:
	cmp cx,300
	jbe @@ThirdCheck
	jmp @@Exit
@@ThirdCheck:
	cmp dx,95
	jae @@FourthCheck
	jmp @@Exit
@@FourthCheck:
	cmp dx,110
	jbe @@ButtonPressed
	jmp @@Exit
@@ButtonPressed:
	cmp [WallButton],1
	je @@Move0
	mov [WallButton],1
	cmp [Turn],'R'
	je @@EraseRedYellow
	call EraseGreenYellows
	jmp @@Exit
@@EraseRedYellow:
	call EraseRedYellows
	jmp @@Exit
@@Move0:
	mov [WallButton],0
	
@@Exit:
	ret
endp CheckIfWallButtonPressed


;draws the squers on the board
proc PrepareBoard
	push cx
	push di
	push si
	mov di,4
	mov si,4
	mov cx,81
@@Strt:
	push di
	push si
	call EraseYellow
	cmp di,180
	je @@ResetX
	 add di,22
	 loop @@Strt
	 jmp @@End
@@ResetX:
	add si,22
	mov di,4
	loop @@Strt
@@End:
	 pop si
	 pop di
	 pop cx
	 ret
endp PrepareBoard
	
	
	
;Draws the Red player at the wanted position with the variables RedX and RedY
proc DrawRP
	push ax
	call HideMouse
	mov ax,[RedX]
	mov [BmpLeft],ax
	mov ax,[RedY]
	mov [BmpTop],ax
	mov [BmpColSize], PLAYER_WIDTH
	mov [BmpRowSize] ,PLAYER_HEIGHT
	mov dx, offset RedPName
	call OpenShowBmp 
	call ShowMouse
	pop ax
	ret
endp DrawRP



;Draws the Red player at the wanted position with the variables RedX and RedY
proc DrawGP
	push ax
	call HideMouse
	mov ax,[GreenX]
	mov [BmpLeft],ax
	mov ax,[GreenY]
	mov [BmpTop],ax
	mov [BmpColSize], PLAYER_WIDTH
	mov [BmpRowSize] ,PLAYER_HEIGHT
	mov dx, offset GreenPName
	call OpenShowBmp 
	call ShowMouse
	pop ax
	ret 
endp DrawGP


;Draws the Red player at the wanted position with the variables RedX and RedY
proc EraseRP
	push ax
	call HideMouse
	mov ax,[RedX]
	mov [BmpLeft],ax
	mov ax,[RedY]
	mov [BmpTop],ax
	mov [BmpColSize], PLAYER_WIDTH
	mov [BmpRowSize] ,PLAYER_HEIGHT
	mov dx, offset EmptyName
	call OpenShowBmp 
	call ShowMouse
	pop ax
	ret
endp EraseRP


;Draws the Red player at the wanted position with the variables RedX and RedY
proc EraseGP
	push ax
	call HideMouse
	mov ax,[GreenX]
	mov [BmpLeft],ax
	mov ax,[GreenY]
	mov [BmpTop],ax
	mov [BmpColSize], PLAYER_WIDTH
	mov [BmpRowSize] ,PLAYER_HEIGHT
	mov dx, offset EmptyName
	call OpenShowBmp 
	call ShowMouse
	pop ax
	ret 
endp EraseGP



;Draws a yellow square with openshowbmp according to the X and Y you push
Xpos equ [bp + 6]
Ypos equ [bp + 4]
proc DrawYellow
	push bp
	mov bp,sp
	push ax
	push dx
	call HideMouse
	mov ax,Xpos
	mov [BmpLeft],ax
	mov ax,Ypos
	mov [BmpTop],ax
	mov [BmpColSize], PLAYER_WIDTH
	mov [BmpRowSize] ,PLAYER_HEIGHT
	mov dx, offset BlueName
	call OpenShowBmp 
	call ShowMouse
	pop dx
	pop ax
	pop bp
	ret 4
endp DrawYellow	


;draws the yellows according to where the player can move
GreenX1 equ [bp + 6]
GreenY1 equ [bp + 4]
proc DrawGreenYellows
	push bp
	mov bp,sp
	@@GCheckFromRight:	
		mov si,[GPPlace]
		cmp [Board + si + 1],' '    
		je @@GCheckRightEmpty
		jmp @@GCheckFromLeft
	@@GCheckRightEmpty:
		cmp [Board + si + 2],'E'    
		je @@GDrawFromRight
		jmp @@GCheckFromLeft
	@@GDrawFromRight:
		mov di,GreenX1
		add di,22
		push di
		push GreenY1
		call DrawYellow

	@@GCheckFromLeft:
		mov si,[GPPlace]
		cmp [Board + si - 1],' '    
		je @@GCheckLeftEmpty
		jmp @@GCheckFromUp
	@@GCheckLeftEmpty:
		cmp [Board + si - 2],'E'    
		je @@GDrawFromLeft
		jmp @@GCheckFromUp
	@@GDrawFromLeft:
		mov di,GreenX1
		sub di,22
		push di
		push GreenY1
		call DrawYellow
		
	@@GCheckFromUp:
		mov si,[GPPlace]
		cmp [Board + si - 17],' '    
		je @@GCheckUpEmpty
		jmp @@GCheckFromDown
	@@GCheckUpEmpty:
		cmp [Board + si - 34],'E'    
		je @@GDrawFromUp
		jmp @@GCheckFromDown
	@@GDrawFromUp:
		mov di,GreenY1
		sub di,22
		push GreenX1
		push di
		call DrawYellow
		
	@@GCheckFromDown:
		mov si,[GPPlace]
		cmp [Board + si + 17],' '    
		je @@GCheckDownEmpty
		jmp @@CheckMoveAboveOtherPlayer
	@@GCheckDownEmpty:
		cmp [Board + si + 34],'E'    
		je @@GDrawFromDown
		jmp @@CheckMoveAboveOtherPlayer
	@@GDrawFromDown:
		mov di,GreenY1
		add di,22
		push GreenX1
		push di
		call DrawYellow
		
@@CheckMoveAboveOtherPlayer:
		
	@@GCheckFromRightAbove:	
		mov si,[GPPlace]
		cmp [Board + si + 1],' '    
		je @@GCheckRightEmpty2
		jmp @@GCheckFromLeftAbove
	@@GCheckRightEmpty2:
		cmp [Board + si + 2],'R'    
		je @@CheckWallBeyondRight
		jmp @@GCheckFromLeftAbove
	@@CheckWallBeyondRight:
		cmp [Board + si + 3],' '    
		je @@GCheckRightEmpty3
		jmp @@GCheckFromLeftAbove
	@@GCheckRightEmpty3:
		cmp [Board + si + 4],'E'    
		je @@GDrawFromRightAbove
		jmp @@GCheckFromLeftAbove
	@@GDrawFromRightAbove:
		mov di,GreenX1
		add di,44
		push di
		push GreenY1
		call DrawYellow
		jmp @@Exit
		
	@@GCheckFromLeftAbove:	
		mov si,[GPPlace]
		cmp [Board + si - 1],' '    
		je @@GCheckLeftEmpty2
		jmp @@GCheckFromUpAbove
	@@GCheckLeftEmpty2:
		cmp [Board + si - 2],'R'    
		je @@CheckWallBeyondLeft
		jmp @@GCheckFromUpAbove
	@@CheckWallBeyondLeft:
		cmp [Board + si - 3],' '    
		je @@GCheckLeftEmpty3
		jmp @@GCheckFromUpAbove
	@@GCheckLeftEmpty3:
		cmp [Board + si - 4],'E'    
		je @@GDrawFromLeftAbove
		jmp @@GCheckFromUpAbove
	@@GDrawFromLeftAbove:
		mov di,GreenX1
		sub di,44
		push di
		push GreenY1
		call DrawYellow
		jmp @@Exit
		
	@@GCheckFromUpAbove:	
		mov si,[GPPlace]
		cmp [Board + si - 17],' '    
		je @@GCheckUpEmpty2
		jmp @@GCheckFromDownAbove
	@@GCheckUpEmpty2:
		cmp [Board + si - 34],'R'    
		je @@CheckWallBeyondUp
		jmp @@GCheckFromDownAbove
	@@CheckWallBeyondUp:
		cmp [Board + si - 51],' '    
		je @@GCheckUpEmpty3
		jmp @@GCheckFromDownAbove
	@@GCheckUpEmpty3:
		cmp [Board + si - 68],'E'    
		je @@GDrawFromUpAbove
		jmp @@GCheckFromDownAbove
	@@GDrawFromUpAbove:
		mov di,GreenY1
		sub di,44
		push GreenX1
		push di
		call DrawYellow
		jmp @@Exit
		
		@@GCheckFromDownAbove:	
		mov si,[GPPlace]
		cmp [Board + si + 17],' '    
		je @@GCheckDownEmpty2
		jmp @@CheckMoveDiagonalToOtherPlayer
	@@GCheckDownEmpty2:
		cmp [Board + si + 34],'R'    
		je @@CheckWallBeyondDown
		jmp @@CheckMoveDiagonalToOtherPlayer
	@@CheckWallBeyondDown:
		cmp [Board + si + 51],' '    
		je @@GCheckDownEmpty3
		jmp @@CheckMoveDiagonalToOtherPlayer
	@@GCheckDownEmpty3:
		cmp [Board + si + 68],'E'    
		je @@GDrawFromDownAbove
		jmp @@CheckMoveDiagonalToOtherPlayer
	@@GDrawFromDownAbove:
		mov di,GreenY1
		add di,44
		push GreenX1
		push di
		call DrawYellow
		jmp @@Exit
		
		
@@CheckMoveDiagonalToOtherPlayer:		
		
	@@GCheckFromRightDiagonal:    
        mov si,[GPPlace]
        cmp [Board + si + 1],' '    
        je @@GCheckRightEmpty4
        jmp @@GCheckFromLeftDiagonal
    @@GCheckRightEmpty4:
        cmp [Board + si + 2],'R'    
        je @@CheckWallBeyondRight2
        jmp @@GCheckFromLeftDiagonal
    @@CheckWallBeyondRight2:
        cmp [Board + si + 3],'W'    
        je @@CheckIfCanMoveDiagonale
        jmp @@GCheckFromLeftDiagonal
    @@CheckIfCanMoveDiagonale:
        cmp [Board + si + 2 - 17],'W'
        je @@CheckOtherDiagonal        
        cmp [Board + si + 2 - 34],'E'
        jne @@CheckOtherDiagonal
		
        mov di,GreenX1
        add di,22
        push di
        
        mov di,GreenY1
        sub di,22
        push di
        call DrawYellow
        
    @@CheckOtherDiagonal:
		mov si,[GPPlace]
        cmp [Board + si + 2 + 17],'W'
        je @@GCheckFromLeftDiagonal
        cmp [Board + si + 2 + 34],'E'
        jne @@GCheckFromLeftDiagonal
        mov di,GreenX1
        add di,22
        push di
        
        mov di,GreenY1
        add di,22
        push di
        call DrawYellow
        jmp @@Exit
        
        
    @@GCheckFromLeftDiagonal:    
        mov si,[GPPlace]
        cmp [Board + si - 1],' '    
        je @@GCheckLeftEmpty4
        jmp @@GCheckFromUpDiagonal
    @@GCheckLeftEmpty4:
        cmp [Board + si - 2],'R'    
        je @@CheckWallBeyondLeft2
        jmp @@GCheckFromUpDiagonal
    @@CheckWallBeyondLeft2:
        cmp [Board + si - 3],'W'    
        je @@CheckIfCanMoveDiagonale2
        jmp @@GCheckFromUpDiagonal
    @@CheckIfCanMoveDiagonale2:
        cmp [Board + si - 2 - 17],'W'
        je @@CheckOtherDiagonal2    
        cmp [Board + si - 2 - 34],'E'
        jne @@CheckOtherDiagonal2
        mov di,GreenX1
        sub di,22
        push di
        
        mov di,GreenY1
        sub di,22
        push di
        call DrawYellow
        
    @@CheckOtherDiagonal2:
		mov si,[GPPlace]
        cmp [Board + si - 2 + 17],'W'
        je @@GCheckFromUpDiagonal
        cmp [Board + si - 2 + 34],'E'
        jne @@GCheckFromUpDiagonal
        mov di,GreenX1
        sub di,22
        push di
        
        mov di,GreenY1
        add di,22
        push di
        call DrawYellow
        jmp @@Exit
    
    @@GCheckFromUpDiagonal: 
		mov si,[GPPlace]
        cmp [Board + si - 17],' '    
        je @@GCheckUpEmpty5
        jmp @@GCheckFromDownDiagonal
    @@GCheckUpEmpty5:
        cmp [Board + si - 34],'R'    
        je @@CheckWallBeyondUp3
        jmp @@GCheckFromDownDiagonal
    @@CheckWallBeyondUp3:
        cmp [Board + si - 51],'W'    
        je @@CheckIfCanMoveDiagonale3
        jmp @@GCheckFromDownDiagonal
    @@CheckIfCanMoveDiagonale3:
        cmp [Board + si - 34 - 1],'W'
        je @@CheckOtherDiagonal3   
        cmp [Board + si - 34 - 2],'E'
        jne @@CheckOtherDiagonal3
        mov di,GreenX1
        sub di,22
        push di
        
        mov di,GreenY1
        sub di,22
        push di
        call DrawYellow
        
    @@CheckOtherDiagonal3:
		mov si,[GPPlace]
        cmp [Board + si - 34 + 1],'W'
        je @@GCheckFromDownDiagonal
        cmp [Board + si - 34 + 2],'E'
        jne @@GCheckFromDownDiagonal
        mov di,GreenX1
        add di,22
        push di
        
        mov di,GreenY1
        sub di,22
        push di
        call DrawYellow
        jmp @@Exit
		
	@@GCheckFromDownDiagonal:		  
		mov si,[GPPlace]
        cmp [Board + si + 17],' '    
        je @@GCheckDownEmpty6
        jmp @@Exit
    @@GCheckDownEmpty6:
        cmp [Board + si + 34],'R'    
        je @@CheckWallBeyondDown4
        jmp @@Exit
    @@CheckWallBeyondDown4:
        cmp [Board + si + 51],'W'    
        je @@CheckIfCanMoveDiagonale4
        jmp @@Exit
    @@CheckIfCanMoveDiagonale4:
        cmp [Board + si + 34 - 1],'W'
        je @@CheckOtherDiagonal4    
        cmp [Board + si + 34 - 2],'E'
        jne @@CheckOtherDiagonal4
        mov di,GreenX1
        sub di,22
        push di
        
        mov di,GreenY1
        add di,22
        push di
        call DrawYellow
        
    @@CheckOtherDiagonal4:
		mov si,[GPPlace]
        cmp [Board + si + 34 + 1],'W'
        je @@Exit
        cmp [Board + si + 34 + 2],'E'
        jne @@Exit
        mov di,GreenX1
        add di,22
        push di
        
        mov di,GreenY1
        add di,22
        push di
        call DrawYellow
        jmp @@Exit
@@Exit:
	mov [YellowOn],1
	pop bp
	ret 4
endp DrawGreenYellows

;draws the yellows according to where the player can move
proc DrawRedYellows
	@@RCheckFromRight:
		mov si,[RPPlace]
		cmp [Board + si + 1],' '    
		je @@RCheckRightEmpty
		jmp @@RCheckFromLeft
	@@RCheckRightEmpty:
		cmp [Board + si + 2],'E'    
		je @@RDrawFromRight
		jmp @@RCheckFromLeft
	@@RDrawFromRight:
		mov di,[RedX]
		add di,22
		push di
		push [RedY]
		call DrawYellow
		
	@@RCheckFromLeft:
		cmp [RPPlace],272
		je @@RCheckFromUp
		cmp [RPPlace],238
		je @@RCheckFromUp
		mov si,[RPPlace]
		cmp [Board + si - 1],' '    
		je @@RCheckLeftEmpty
		jmp @@RCheckFromUp
	@@RCheckLeftEmpty:
		cmp [Board + si - 2],'E'    
		je @@RDrawFromLeft
		jmp @@RCheckFromUp
	@@RDrawFromLeft:
		mov di,[RedX]
		sub di,22
		push di
		push [RedY]
		call DrawYellow
		
		
	@@RCheckFromUp:
		mov si,[RPPlace]
		cmp [Board + si - 17],' '    
		je @@RCheckUpEmpty
		jmp @@RCheckFromDown
	@@RCheckUpEmpty:
		cmp [Board + si - 34],'E'    
		je @@RDrawFromUp
		jmp @@RCheckFromDown
	@@RDrawFromUp:
		mov di,[RedY]
		sub di,22
		push [RedX]
		push di
		call DrawYellow
		
	@@RCheckFromDown:
		mov si,[RPPlace]
		cmp [Board + si + 17],' '    
		je @@RCheckDownEmpty
		jmp @@CheckMoveAboveOtherPlayer
	@@RCheckDownEmpty:
		cmp [Board + si + 34],'E'    
		je @@RDrawFromDown
		jmp @@CheckMoveAboveOtherPlayer
	@@RDrawFromDown:
		mov di,[RedY]
		add di,22
		push [RedX]
		push di
		call DrawYellow	
		
@@CheckMoveAboveOtherPlayer:
		
	@@GCheckFromRightAbove:	
		mov si,[RPPlace]
		cmp [Board + si + 1],' '    
		je @@RCheckRightEmpty2
		jmp @@RCheckFromLeftAbove
	@@RCheckRightEmpty2:
		cmp [Board + si + 2],'G'    
		je @@CheckWallBeyondRight
		jmp @@RCheckFromLeftAbove
	@@CheckWallBeyondRight:
		cmp [Board + si + 3],' '    
		je @@RCheckRightEmpty3
		jmp @@RCheckFromLeftAbove
	@@RCheckRightEmpty3:
		cmp [Board + si + 4],'E'    
		je @@RDrawFromRightAbove
		jmp @@RCheckFromLeftAbove
	@@RDrawFromRightAbove:
		mov di,[RedX]
		add di,44
		push di
		push [RedY]
		call DrawYellow

	@@RCheckFromLeftAbove:	
	cmp [RPPlace],272
		je @@RCheckFromUpAbove
		cmp [RPPlace],238
		je @@RCheckFromUpAbove 
		mov si,[RPPlace]
		cmp [Board + si - 1],' '    
		je @@RCheckLeftEmpty2
		jmp @@RCheckFromUpAbove
	@@RCheckLeftEmpty2:
		cmp [Board + si - 2],'G'    
		je @@CheckWallBeyondLeft
		jmp @@RCheckFromUpAbove
	@@CheckWallBeyondLeft:
		cmp [Board + si - 3],' '    
		je @@RCheckLeftEmpty3
		jmp @@RCheckFromUpAbove
	@@RCheckLeftEmpty3:
		cmp [Board + si - 4],'E'    
		je @@RDrawFromLeftAbove
		jmp @@RCheckFromUpAbove
	@@RDrawFromLeftAbove:
		mov di,[RedX]
		sub di,44
		push di
		push [RedY]
		call DrawYellow
		
		@@RCheckFromUpAbove:	
		mov si,[RPPlace]
		cmp [Board + si - 17],' '    
		je @@RCheckUpEmpty2
		jmp @@RCheckFromDownAbove
	@@RCheckUpEmpty2:
		cmp [Board + si - 34],'G'    
		je @@CheckWallBeyondUp
		jmp @@RCheckFromDownAbove
	@@CheckWallBeyondUp:
		cmp [Board + si - 51],' '    
		je @@RCheckUpEmpty3
		jmp @@RCheckFromDownAbove
	@@RCheckUpEmpty3:
		cmp [Board + si - 68],'E'    
		je @@RDrawFromUpAbove
		jmp @@RCheckFromDownAbove
	@@RDrawFromUpAbove:
		mov di,[RedY]
		sub di,44
		push [RedX]
		push di
		call DrawYellow
		
		@@RCheckFromDownAbove:	
		mov si,[RPPlace]
		cmp [Board + si + 17],' '    
		je @@RCheckDownEmpty2
		jmp @@CheckMoveDiagonalToOtherPlayer
	@@RCheckDownEmpty2:
		cmp [Board + si + 34],'G'    
		je @@CheckWallBeyondDown
		jmp @@CheckMoveDiagonalToOtherPlayer
	@@CheckWallBeyondDown:
		cmp [Board + si + 51],' '    
		je @@RCheckDownEmpty3
		jmp @@CheckMoveDiagonalToOtherPlayer
	@@RCheckDownEmpty3:
		cmp [Board + si + 68],'E'    
		je @@RDrawFromDownAbove
		jmp @@CheckMoveDiagonalToOtherPlayer
	@@RDrawFromDownAbove:
		mov di,[RedY]
		add di,44
		push [RedX]
		push di
		call DrawYellow
		
@@CheckMoveDiagonalToOtherPlayer:		
		
	@@CheckFromRightDiagonal:    
        mov si,[RPPlace]
        cmp [Board + si + 1],' '    
        je @@CheckRightEmpty4
        jmp @@CheckFromLeftDiagonal
    @@CheckRightEmpty4:
        cmp [Board + si + 2],'G'    
        je @@CheckWallBeyondRight2
        jmp @@CheckFromLeftDiagonal
    @@CheckWallBeyondRight2:
        cmp [Board + si + 3],'W'    
        je @@CheckIfCanMoveDiagonale
        jmp @@CheckFromLeftDiagonal
    @@CheckIfCanMoveDiagonale:
        cmp [Board + si + 2 - 17],'W'
        je @@CheckOtherDiagonal        
        cmp [Board + si + 2 - 34],'E'
        jne @@CheckOtherDiagonal
		
        mov di,[RedX]
        add di,22
        push di
        
        mov di,[RedY]
        sub di,22
        push di
        call DrawYellow
        
    @@CheckOtherDiagonal:
		mov si,[RPPlace]
        cmp [Board + si + 2 + 17],'W'
        je @@CheckFromLeftDiagonal
        cmp [Board + si + 2 + 34],'E'
        jne @@CheckFromLeftDiagonal
        mov di,[RedX]
        add di,22
        push di
        
        mov di,[RedY]
        add di,22
        push di
        call DrawYellow
        jmp @@Exit
        
        
    @@CheckFromLeftDiagonal:    
		cmp [RPPlace],272
		je @@CheckFromUpDiagonal
		cmp [RPPlace],238
		je @@CheckFromUpDiagonal   
        mov si,[RPPlace]
        cmp [Board + si - 1],' '    
        je @@CheckLeftEmpty4
        jmp @@CheckFromUpDiagonal
    @@CheckLeftEmpty4:
        cmp [Board + si - 2],'G'    
        je @@CheckWallBeyondLeft2
        jmp @@CheckFromUpDiagonal
    @@CheckWallBeyondLeft2:
        cmp [Board + si - 3],'W'    
        je @@CheckIfCanMoveDiagonale2
        jmp @@CheckFromUpDiagonal
    @@CheckIfCanMoveDiagonale2:
        cmp [Board + si - 2 - 17],'W'
        je @@CheckOtherDiagonal2    
        cmp [Board + si - 2 - 34],'E'
        jne @@CheckOtherDiagonal2
        mov di,[RedX]
        sub di,22
        push di
        
        mov di,[RedY]
        sub di,22
        push di
        call DrawYellow
        
    @@CheckOtherDiagonal2:
		mov si,[RPPlace]
        cmp [Board + si - 2 + 17],'W'
        je @@CheckFromUpDiagonal
        cmp [Board + si - 2 + 34],'E'
        jne @@CheckFromUpDiagonal
        mov di,[RedX]
        sub di,22
        push di
        
        mov di,[RedY]
        add di,22
        push di
        call DrawYellow
        jmp @@Exit
    
    @@CheckFromUpDiagonal: 
		mov si,[RPPlace]
        cmp [Board + si - 17],' '    
        je @@CheckUpEmpty5
        jmp @@CheckFromDownDiagonal
    @@CheckUpEmpty5:
        cmp [Board + si - 34],'G'    
        je @@CheckWallBeyondUp3
        jmp @@CheckFromDownDiagonal
    @@CheckWallBeyondUp3:
        cmp [Board + si - 51],'W'    
        je @@CheckIfCanMoveDiagonale3
        jmp @@CheckFromDownDiagonal
    @@CheckIfCanMoveDiagonale3:
        cmp [Board + si - 34 - 1],'W'
        je @@CheckOtherDiagonal3    
        cmp [Board + si - 34 - 2],'E'
        jne @@CheckOtherDiagonal3
        mov di,[RedX]
        sub di,22
        push di
        
        mov di,[RedY]
        sub di,22
        push di
        call DrawYellow
        
    @@CheckOtherDiagonal3:
		mov si,[RPPlace]
        cmp [Board + si - 34 + 1],'W'
        je @@CheckFromDownDiagonal
        cmp [Board + si - 34 + 2],'E'
        jne @@CheckFromDownDiagonal
        mov di,[RedX]
        add di,22
        push di
        
        mov di,[RedY]
        sub di,22
        push di
        call DrawYellow
        jmp @@Exit
		
	@@CheckFromDownDiagonal:		  
		mov si,[RPPlace]
        cmp [Board + si + 17],' '    
        je @@CheckDownEmpty6
        jmp @@Exit
    @@CheckDownEmpty6:
        cmp [Board + si + 34],'G'    
        je @@CheckWallBeyondDown4
        jmp @@Exit
    @@CheckWallBeyondDown4:
        cmp [Board + si + 51],'W'    
        je @@CheckIfCanMoveDiagonale4
        jmp @@Exit
    @@CheckIfCanMoveDiagonale4:
        cmp [Board + si + 34 - 1],'W'
        je @@CheckOtherDiagonal4    
        cmp [Board + si + 34 - 2],'E'
        jne @@CheckOtherDiagonal4
        mov di,[RedX]
        sub di,22
        push di
        
        mov di,[RedY]
        add di,22
        push di
        call DrawYellow
        
    @@CheckOtherDiagonal4:
		mov si,[RPPlace]
        cmp [Board + si + 34 + 1],'W'
        je @@Exit
        cmp [Board + si + 34 + 2],'E'
        jne @@Exit
        mov di,[RedX]
        add di,22
        push di
        
        mov di,[RedY]
        add di,22
        push di
        call DrawYellow
        jmp @@Exit
@@Exit:
	mov [YellowOn],1
	ret
endp DrawRedYellows


;Erase a yellow square with openshowbmp according to the X and Y you push
Xpos equ [bp + 6]
Ypos equ [bp + 4]
proc EraseYellow
	push bp
	mov bp,sp
	push ax
	push dx
	push cx
	push di
	push si
	call HideMouse
	mov ax,Xpos
	mov [BmpLeft],ax
	mov ax,Ypos
	mov [BmpTop],ax
	mov [BmpColSize], PLAYER_WIDTH
	mov [BmpRowSize] ,PLAYER_HEIGHT
	mov dx, offset EmptyName
	call OpenShowBmp 
	call ShowMouse
	pop si
	pop di
	pop cx
	pop dx
	pop ax
	pop bp
	ret 4
endp EraseYellow

;erase the yellows according to where it could have been drawn
proc EraseGreenYellows
	@@GCheckFromRightErase:	
		mov si,[GPPlace]
		cmp [Board + si + 1],' '    
		je @@GCheckRightErase
		jmp @@GCheckFromLeftErase
	@@GCheckRightErase:
		cmp [Board + si + 2],'E'    
		je @@GEraseFromRight
		jmp @@GCheckFromLeftErase
	@@GEraseFromRight:
		mov di,[GreenX]
		add di,22
		push di
		push [GreenY]
		call EraseYellow

	@@GCheckFromLeftErase:
		mov si,[GPPlace]
		cmp [Board + si - 1],' '    
		je @@GCheckLeftErase
		jmp @@GCheckFromUpErase
	@@GCheckLeftErase:
		cmp [Board + si - 2],'E'    
		je @@GEraseFromLeft
		jmp @@GCheckFromUpErase
	@@GEraseFromLeft:
		mov di,[GreenX]
		sub di,22
		push di
		push [GreenY]
		call EraseYellow
		
	@@GCheckFromUpErase:
		mov si,[GPPlace]
		cmp [Board + si - 17],' '    
		je @@GCheckUpEmptyErase
		jmp @@GCheckFromDownErase
	@@GCheckUpEmptyErase:
		cmp [Board + si - 34],'E'    
		je @@GEraseFromUp
		jmp @@GCheckFromDownErase
	@@GEraseFromUp:
		mov di,[GreenY]
		sub di,22
		push [GreenX]
		push di
		call EraseYellow
		
	@@GCheckFromDownErase:
		mov si,[GPPlace]
		cmp [Board + si + 17],' '    
		je @@GCheckDownErase
		jmp @@CheckMoveAboveOtherPlayer
	@@GCheckDownErase:
		cmp [Board + si + 34],'E'    
		je @@GEraseFromDown
		jmp @@CheckMoveAboveOtherPlayer
	@@GEraseFromDown:
		mov di,[GreenY]
		add di,22
		push [GreenX]
		push di
		call EraseYellow
		
@@CheckMoveAboveOtherPlayer:
		
	@@GCheckFromRightAbove:	
		mov si,[GPPlace]
		cmp [Board + si + 1],' '    
		je @@GCheckRightEmpty2
		jmp @@GCheckFromLeftAbove
	@@GCheckRightEmpty2:
		cmp [Board + si + 2],'R'    
		je @@CheckWallBeyondRight
		jmp @@GCheckFromLeftAbove
	@@CheckWallBeyondRight:
		cmp [Board + si + 3],' '    
		je @@GCheckRightEmpty3
		jmp @@GCheckFromLeftAbove
	@@GCheckRightEmpty3:
		cmp [Board + si + 4],'E'    
		je @@GDrawFromRightAbove
		jmp @@GCheckFromLeftAbove
	@@GDrawFromRightAbove:
		mov di,[GreenX]
		add di,44
		push di
		push [GreenY]
		call EraseYellow

	@@GCheckFromLeftAbove:	
		mov si,[GPPlace]
		cmp [Board + si - 1],' '    
		je @@GCheckLeftEmpty2
		jmp @@GCheckFromUpAbove
	@@GCheckLeftEmpty2:
		cmp [Board + si - 2],'R'    
		je @@CheckWallBeyondLeft
		jmp @@GCheckFromUpAbove
	@@CheckWallBeyondLeft:
		cmp [Board + si - 3],' '    
		je @@GCheckLeftEmpty3
		jmp @@GCheckFromUpAbove
	@@GCheckLeftEmpty3:
		cmp [Board + si - 4],'E'    
		je @@GDrawFromLeftAbove
		jmp @@GCheckFromUpAbove
	@@GDrawFromLeftAbove:
		mov di,[GreenX]
		sub di,44
		push di
		push [GreenY]
		call EraseYellow
		
		@@GCheckFromUpAbove:	
		mov si,[GPPlace]
		cmp [Board + si - 17],' '    
		je @@GCheckUpEmpty2
		jmp @@GCheckFromDownAbove
	@@GCheckUpEmpty2:
		cmp [Board + si - 34],'R'    
		je @@CheckWallBeyondUp
		jmp @@GCheckFromDownAbove
	@@CheckWallBeyondUp:
		cmp [Board + si - 51],' '    
		je @@GCheckUpEmpty3
		jmp @@GCheckFromDownAbove
	@@GCheckUpEmpty3:
		cmp [Board + si - 68],'E'    
		je @@GDrawFromUpAbove
		jmp @@GCheckFromDownAbove
	@@GDrawFromUpAbove:
		mov di,[GreenY]
		sub di,44
		push [GreenX]
		push di
		call EraseYellow
		
		@@GCheckFromDownAbove:	
		mov si,[GPPlace]
		cmp [Board + si + 17],' '    
		je @@GCheckDownEmpty2
		jmp @@CheckMoveDiagonalToOtherPlayer
	@@GCheckDownEmpty2:
		cmp [Board + si + 34],'R'    
		je @@CheckWallBeyondDown
		jmp @@CheckMoveDiagonalToOtherPlayer
	@@CheckWallBeyondDown:
		cmp [Board + si + 51],' '    
		je @@GCheckDownEmpty3
		jmp @@CheckMoveDiagonalToOtherPlayer
	@@GCheckDownEmpty3:
		cmp [Board + si + 68],'E'    
		je @@GDrawFromDownAbove
		jmp @@CheckMoveDiagonalToOtherPlayer
	@@GDrawFromDownAbove:
		mov di,[GreenY]
		add di,44
		push [GreenX]
		push di
		call EraseYellow
		
@@CheckMoveDiagonalToOtherPlayer:		
		
	@@GCheckFromRightDiagonal:    
        mov si,[GPPlace]
        cmp [Board + si + 1],' '    
        je @@GCheckRightEmpty4
        jmp @@GCheckFromLeftDiagonal
    @@GCheckRightEmpty4:
        cmp [Board + si + 2],'R'    
        je @@CheckWallBeyondRight2
        jmp @@GCheckFromLeftDiagonal
    @@CheckWallBeyondRight2:
        cmp [Board + si + 3],'W'    
        je @@CheckIfCanMoveDiagonale
        jmp @@GCheckFromLeftDiagonal
    @@CheckIfCanMoveDiagonale:
        cmp [Board + si + 2 - 17],'W'
        je @@CheckOtherDiagonal        
        cmp [Board + si + 2 - 34],'E'
        jne @@CheckOtherDiagonal
		
        mov di,[GreenX]
        add di,22
        push di
        
        mov di,[GreenY]
        sub di,22
        push di
        call EraseYellow
        
    @@CheckOtherDiagonal:
		mov si,[GPPlace]
        cmp [Board + si + 2 + 17],'W'
        je @@GCheckFromLeftDiagonal
        cmp [Board + si + 2 + 34],'E'
        jne @@GCheckFromLeftDiagonal
        mov di,[GreenX]
        add di,22
        push di
        
        mov di,[GreenY]
        add di,22
        push di
        call EraseYellow
        jmp @@Exit
        
        
    @@GCheckFromLeftDiagonal:    
        mov si,[GPPlace]
        cmp [Board + si - 1],' '    
        je @@GCheckLeftEmpty4
        jmp @@GCheckFromUpDiagonal
    @@GCheckLeftEmpty4:
        cmp [Board + si - 2],'R'    
        je @@CheckWallBeyondLeft2
        jmp @@GCheckFromUpDiagonal
    @@CheckWallBeyondLeft2:
        cmp [Board + si - 3],'W'    
        je @@CheckIfCanMoveDiagonale2
        jmp @@GCheckFromUpDiagonal
    @@CheckIfCanMoveDiagonale2:
        cmp [Board + si - 2 - 17],'W'
        je @@CheckOtherDiagonal2    
        cmp [Board + si - 2 - 34],'E'
        jne @@CheckOtherDiagonal2
        mov di,[GreenX]
        sub di,22
        push di
        
        mov di,[GreenY]
        sub di,22
        push di
        call EraseYellow
        
    @@CheckOtherDiagonal2:
		mov si,[GPPlace]
        cmp [Board + si - 2 + 17],'W'
        je @@GCheckFromUpDiagonal
        cmp [Board + si - 2 + 34],'E'
        jne @@GCheckFromUpDiagonal
        mov di,[GreenX]
        sub di,22
        push di
        
        mov di,[GreenY]
        add di,22
        push di
        call EraseYellow
        jmp @@Exit
    
    @@GCheckFromUpDiagonal: 
		mov si,[GPPlace]
        cmp [Board + si - 17],' '    
        je @@GCheckUpEmpty5
        jmp @@GCheckFromDownDiagonal
    @@GCheckUpEmpty5:
        cmp [Board + si - 34],'R'    
        je @@CheckWallBeyondUp3
        jmp @@GCheckFromDownDiagonal
    @@CheckWallBeyondUp3:
        cmp [Board + si - 51],'W'    
        je @@CheckIfCanMoveDiagonale3
        jmp @@GCheckFromDownDiagonal
    @@CheckIfCanMoveDiagonale3:
        cmp [Board + si - 34 - 1],'W'
        je @@CheckOtherDiagonal3   
        cmp [Board + si - 34 - 2],'E'
        jne @@CheckOtherDiagonal3
        mov di,[GreenX]
        sub di,22
        push di
        
        mov di,[GreenY]
        sub di,22
        push di
        call EraseYellow
        
    @@CheckOtherDiagonal3:
		mov si,[GPPlace]
        cmp [Board + si - 34 + 1],'W'
        je @@GCheckFromDownDiagonal
        cmp [Board + si - 34 + 2],'E'
        jne @@GCheckFromDownDiagonal
        mov di,[GreenX]
        add di,22
        push di
        
        mov di,[GreenY]
        sub di,22
        push di
        call EraseYellow
        jmp @@Exit
		
	@@GCheckFromDownDiagonal:		  
		mov si,[GPPlace]
        cmp [Board + si + 17],' '    
        je @@GCheckDownEmpty6
        jmp @@Exit
    @@GCheckDownEmpty6:
        cmp [Board + si + 34],'R'    
        je @@CheckWallBeyondDown4
        jmp @@Exit
    @@CheckWallBeyondDown4:
        cmp [Board + si + 51],'W'    
        je @@CheckIfCanMoveDiagonale4
        jmp @@Exit
    @@CheckIfCanMoveDiagonale4:
        cmp [Board + si + 34 - 1],'W'
        je @@CheckOtherDiagonal4    
        cmp [Board + si + 34 - 2],'E'
        jne @@CheckOtherDiagonal4
        mov di,[GreenX]
        sub di,22
        push di
        
        mov di,[GreenY]
        add di,22
        push di
        call EraseYellow
        
    @@CheckOtherDiagonal4:
		mov si,[GPPlace]
        cmp [Board + si + 34 + 1],'W'
        je @@Exit
        cmp [Board + si + 34 + 2],'E'
        jne @@Exit
        mov di,[GreenX]
        add di,22
        push di
        
        mov di,[GreenY]
        add di,22
        push di
        call EraseYellow
        jmp @@Exit
		
@@Exit:
	mov [YellowOn],0
	ret
endp EraseGreenYellows

;erase the yellows according to where it could have been drawn
proc EraseRedYellows
	@@RCheckFromRightErase:
		mov si,[RPPlace]
		cmp [Board + si + 1],' '    
		je @@RCheckRightErase
		jmp @@RCheckFromLeftErase
	@@RCheckRightErase:
		cmp [Board + si + 2],'E'    
		je @@REraseFromRight
		jmp @@RCheckFromLeftErase
	@@REraseFromRight:
		mov di,[RedX]
		add di,22
		push di
		push [RedY]
		call EraseYellow
		
	@@RCheckFromLeftErase:
		cmp [RPPlace],272
		je @@RCheckFromUpErase
		cmp [RPPlace],238
		je @@RCheckFromUpErase
		mov si,[RPPlace]
		cmp [Board + si - 1],' '    
		je @@RCheckLeftErase
		jmp @@RCheckFromUpErase
	@@RCheckLeftErase:
		cmp [Board + si - 2],'E'    
		je @@REraseFromLeft
		jmp @@RCheckFromUpErase
	@@REraseFromLeft:	
		mov di,[RedX]
		sub di,22
		push di
		push [RedY]
		call EraseYellow
		jmp @@RCheckFromUpErase
	@@RCheckFromUpErase:
		mov si,[RPPlace]
		cmp [Board + si - 17],' '    
		je @@RCheckUpErase
		jmp @@RCheckFromDownErase
	@@RCheckUpErase:
		cmp [Board + si - 34],'E'    
		je @@REraseFromUp
		jmp @@RCheckFromDownErase
	@@REraseFromUp:
		mov di,[RedY]
		sub di,22
		push [RedX]
		push di
		call EraseYellow
		
	@@RCheckFromDownErase:
		mov si,[RPPlace]
		cmp [Board + si + 17],' '    
		je @@RCheckDownErase
		jmp @@CheckMoveAboveOtherPlayer
	@@RCheckDownErase:
		cmp [Board + si + 34],'E'    
		je @@REraseFromDown
		jmp @@CheckMoveAboveOtherPlayer           
	@@REraseFromDown:
		mov di,[RedY]  
		add di,22
		push [RedX]
		push di
		call EraseYellow
		
		
@@CheckMoveAboveOtherPlayer:
		
	@@GCheckFromRightAbove:	
		mov si,[RPPlace]
		cmp [Board + si + 1],' '    
		je @@RCheckRightEmpty2
		jmp @@RCheckFromLeftAbove
	@@RCheckRightEmpty2:
		cmp [Board + si + 2],'G'    
		je @@CheckWallBeyondRight
		jmp @@RCheckFromLeftAbove
	@@CheckWallBeyondRight:
		cmp [Board + si + 3],' '    
		je @@RCheckRightEmpty3
		jmp @@RCheckFromLeftAbove
	@@RCheckRightEmpty3:
		cmp [Board + si + 4],'E'    
		je @@RDrawFromRightAbove
		jmp @@RCheckFromLeftAbove
	@@RDrawFromRightAbove:
		mov di,[RedX]
		add di,44
		push di
		push [RedY]
		call EraseYellow

	@@RCheckFromLeftAbove:	
		cmp [RPPlace],272
		je @@RCheckFromUpAbove
		cmp [RPPlace],238
		je @@RCheckFromUpAbove
		mov si,[RPPlace]
		cmp [Board + si - 1],' '    
		je @@RCheckLeftEmpty2
		jmp @@RCheckFromUpAbove
	@@RCheckLeftEmpty2:
		cmp [Board + si - 2],'G'    
		je @@CheckWallBeyondLeft
		jmp @@RCheckFromUpAbove
	@@CheckWallBeyondLeft:
		cmp [Board + si - 3],' '    
		je @@RCheckLeftEmpty3
		jmp @@RCheckFromUpAbove
	@@RCheckLeftEmpty3:
		cmp [Board + si - 4],'E'    
		je @@RDrawFromLeftAbove
		jmp @@RCheckFromUpAbove
	@@RDrawFromLeftAbove:
		mov di,[RedX]
		sub di,44
		push di
		push [RedY]
		call EraseYellow
		
		@@RCheckFromUpAbove:	
		mov si,[RPPlace]
		cmp [Board + si - 17],' '    
		je @@RCheckUpEmpty2
		jmp @@RCheckFromDownAbove
	@@RCheckUpEmpty2:
		cmp [Board + si - 34],'G'    
		je @@CheckWallBeyondUp
		jmp @@RCheckFromDownAbove
	@@CheckWallBeyondUp:
		cmp [Board + si - 51],' '    
		je @@RCheckUpEmpty3
		jmp @@RCheckFromDownAbove
	@@RCheckUpEmpty3:
		cmp [Board + si - 68],'E'    
		je @@RDrawFromUpAbove
		jmp @@RCheckFromDownAbove
	@@RDrawFromUpAbove:
		mov di,[RedY]
		sub di,44
		push [RedX]
		push di
		call EraseYellow
		
		@@RCheckFromDownAbove:	
		mov si,[RPPlace]
		cmp [Board + si + 17],' '    
		je @@RCheckDownEmpty2
		jmp @@CheckMoveDiagonalToOtherPlayer
	@@RCheckDownEmpty2:
		cmp [Board + si + 34],'G'    
		je @@CheckWallBeyondDown
		jmp @@CheckMoveDiagonalToOtherPlayer
	@@CheckWallBeyondDown:
		cmp [Board + si + 51],' '    
		je @@RCheckDownEmpty3
		jmp @@CheckMoveDiagonalToOtherPlayer
	@@RCheckDownEmpty3:
		cmp [Board + si + 68],'E'    
		je @@RDrawFromDownAbove
		jmp @@CheckMoveDiagonalToOtherPlayer
	@@RDrawFromDownAbove:
		mov di,[RedY]
		add di,44
		push [RedX]
		push di
		call EraseYellow
		
@@CheckMoveDiagonalToOtherPlayer:		
		
	@@CheckFromRightDiagonal:    
        mov si,[RPPlace]
        cmp [Board + si + 1],' '    
        je @@CheckRightEmpty4
        jmp @@CheckFromLeftDiagonal
    @@CheckRightEmpty4:
        cmp [Board + si + 2],'G'    
        je @@CheckWallBeyondRight2
        jmp @@CheckFromLeftDiagonal
    @@CheckWallBeyondRight2:
        cmp [Board + si + 3],'W'    
        je @@CheckIfCanMoveDiagonale
        jmp @@CheckFromLeftDiagonal
    @@CheckIfCanMoveDiagonale:
        cmp [Board + si + 2 - 17],'W'
        je @@CheckOtherDiagonal        
        cmp [Board + si + 2 - 34],'E'
        jne @@CheckOtherDiagonal
		
        mov di,[RedX]
        add di,22
        push di
        
        mov di,[RedY]
        sub di,22
        push di
        call EraseYellow
        
    @@CheckOtherDiagonal:
		mov si,[RPPlace]
        cmp [Board + si + 2 + 17],'W'
        je @@CheckFromLeftDiagonal
        cmp [Board + si + 2 + 34],'E'
        jne @@CheckFromLeftDiagonal
        mov di,[RedX]
        add di,22
        push di
        
        mov di,[RedY]
        add di,22
        push di
        call EraseYellow
        jmp @@Exit
        
        
    @@CheckFromLeftDiagonal:
		cmp [RPPlace],272
		je @@CheckFromUpDiagonal
		cmp [RPPlace],238
		je @@CheckFromUpDiagonal   
        mov si,[RPPlace]
        cmp [Board + si - 1],' '    
        je @@CheckLeftEmpty4
        jmp @@CheckFromUpDiagonal
    @@CheckLeftEmpty4:
        cmp [Board + si - 2],'G'    
        je @@CheckWallBeyondLeft2
        jmp @@CheckFromUpDiagonal
    @@CheckWallBeyondLeft2:
        cmp [Board + si - 3],'W'    
        je @@CheckIfCanMoveDiagonale2
        jmp @@CheckFromUpDiagonal
    @@CheckIfCanMoveDiagonale2:
        cmp [Board + si - 2 - 17],'W'
        je @@CheckOtherDiagonal2    
        cmp [Board + si - 2 - 34],'E'
        jne @@CheckOtherDiagonal2
        mov di,[RedX]
        sub di,22
        push di
        
        mov di,[RedY]
        sub di,22
        push di
        call EraseYellow
        
    @@CheckOtherDiagonal2:
		mov si,[RPPlace]
        cmp [Board + si - 2 + 17],'W'
        je @@CheckFromUpDiagonal
        cmp [Board + si - 2 + 34],'E'
        jne @@CheckFromUpDiagonal
        mov di,[RedX]
        sub di,22
        push di
        
        mov di,[RedY]
        add di,22
        push di
        call EraseYellow
        jmp @@Exit
    
    @@CheckFromUpDiagonal: 
		mov si,[RPPlace]
        cmp [Board + si - 17],' '    
        je @@CheckUpEmpty5
        jmp @@CheckFromDownDiagonal
    @@CheckUpEmpty5:
        cmp [Board + si - 34],'G'    
        je @@CheckWallBeyondUp3
        jmp @@CheckFromDownDiagonal
    @@CheckWallBeyondUp3:
        cmp [Board + si - 51],'W'    
        je @@CheckIfCanMoveDiagonale3
        jmp @@CheckFromDownDiagonal
    @@CheckIfCanMoveDiagonale3:
        cmp [Board + si - 34 - 1],'W'
        je @@CheckOtherDiagonal3  
        cmp [Board + si - 34 - 2],'E'
        jne @@CheckOtherDiagonal3
        mov di,[RedX]
        sub di,22
        push di
        
        mov di,[RedY]
        sub di,22
        push di
        call EraseYellow
        
    @@CheckOtherDiagonal3:
		mov si,[RPPlace]
        cmp [Board + si - 34 + 1],'W'
        je @@CheckFromDownDiagonal
        cmp [Board + si - 34 + 2],'E'
        jne @@CheckFromDownDiagonal
        mov di,[RedX]
        add di,22
        push di
        
        mov di,[RedY]
        sub di,22
        push di
        call EraseYellow
        jmp @@Exit
		
	@@CheckFromDownDiagonal:		  
		mov si,[RPPlace]
        cmp [Board + si + 17],' '    
        je @@CheckDownEmpty6
        jmp @@Exit
    @@CheckDownEmpty6:
        cmp [Board + si + 34],'G'    
        je @@CheckWallBeyondDown4
        jmp @@Exit
    @@CheckWallBeyondDown4:
        cmp [Board + si + 51],'W'    
        je @@CheckIfCanMoveDiagonale4
        jmp @@Exit
    @@CheckIfCanMoveDiagonale4:
        cmp [Board + si + 34 - 1],'W'
        je @@CheckOtherDiagonal4    
        cmp [Board + si + 34 - 2],'E'
        jne @@CheckOtherDiagonal4
        mov di,[RedX]
        sub di,22
        push di
        
        mov di,[RedY]
        add di,22
        push di
        call EraseYellow
        
    @@CheckOtherDiagonal4:
		mov si,[RPPlace]
        cmp [Board + si + 34 + 1],'W'
        je @@Exit
        cmp [Board + si + 34 + 2],'E'
        jne @@Exit
        mov di,[RedX]
        add di,22
        push di
        
        mov di,[RedY]
        add di,22
        push di
        call EraseYellow
        jmp @@Exit
@@Exit:
	mov [YellowOn],0
	ret
endp EraseRedYellows


;checks whare the press accured, and moves the player acoording to it
proc CheckRedYellowPressAndMove
		
	@@CheckRightAbove:			
		mov di,[RedX]
		add di,22
		cmp cx,di
		jae @@CheckY
		jmp @@CheckRightBelow
	@@CheckY:
		mov di,[RedY]
		cmp dx,di
		jb @@MoveRightAbove1
		
	@@CheckRightBelow:
		mov di,[RedX]
		add di,22
		cmp cx,di
		jae @@CheckY2
		jmp @@CheckLeftAbove
	@@CheckY2:
		mov di,[RedY]
		add di,22
		cmp dx,di
		jae @@MoveRightBelow1
		
	@@CheckLeftAbove:
		mov di,[RedX]
		dec di
		cmp cx,di
		jb @@CheckY3
		jmp @@CheckLeftBelow
	@@CheckY3:
		mov di,[RedY]
		cmp dx,di
		jb @@MoveLeftAbove1

	@@CheckLeftBelow:
		mov di,[RedX]
		dec di
		cmp cx,di
		jb @@CheckY4
		jmp @@CheckAbove
	@@CheckY4:
		mov di,[RedY]
		dec di
		add di,22
		cmp dx,di
		jae @@MoveLeftBelow1
		
@@CheckAbove:		
		mov di,[RedX]
		add di,44
		cmp cx,di
		jae @@MoveRPRightAbove
		mov di,[RedX]
		sub di,25
		cmp cx,di
		jle @@MoveRPLeftAbove
		mov di,[RedY]
		sub di,25
		cmp dx,di
		jbe @@MoveRPUpAbove
		mov di,[RedY]
		add di,44
		cmp dx,di
		jae @@MoveRPDownAbove
		jmp @@AboveMidCheck
									@@MoveRightAbove1:
										jmp @@MoveRightAbove
									@@MoveRightBelow1:
										jmp @@MoveRightBelow
									@@MoveLeftAbove1:
										jmp @@MoveLeftAbove
									@@MoveLeftBelow1:
										jmp @@MoveLeftBelow
@@AboveMidCheck:			
		mov di,[RedX]
		add di,22
		cmp cx,di
		jae @@MoveRPRight
		mov di,[RedX]
		dec di
		cmp cx,di
		jb @@MoveRPLeft
		mov di,[RedY]
		cmp dx,di
		jbe @@MoveRPUp
		mov di,[RedY]
		add di,22
		cmp dx,di
		jae @@MoveRPDown
		
						
		jmp @@Exit
		
							
	
		
	@@MoveRPRightAbove:
		mov [Turn],'G'
		call MoveRed2Right
		jmp @@Exit
	@@MoveRPLeftAbove:
		mov [Turn],'G'
		call MoveRed2Left
		jmp @@Exit
	@@MoveRPUpAbove:
		mov [Turn],'G'
		call MoveRed2Up
		jmp @@Exit
	@@MoveRPDownAbove:
		mov [Turn],'G'
		call MoveRed2Down
		jmp @@Exit
	@@MoveRPRight:
		mov [Turn],'G'
		call MoveRedRight
		jmp @@Exit
	@@MoveRPLeft:
		mov [Turn],'G'
		call MoveRedLeft
		jmp @@Exit
	@@MoveRPUp:
		mov [Turn],'G'
		call MoveRedUp
		jmp @@Exit
	@@MoveRPDown:
		mov [Turn],'G'
		call MoveRedDown
		jmp @@Exit
		
	@@MoveRightAbove:
		mov [Turn],'G'
		call MoveRedUpRight
		jmp @@Exit
	@@MoveRightBelow:
		mov [Turn],'G'
		call MoveRedDownRight
		jmp @@Exit
	@@MoveLeftAbove:
		mov [Turn],'G'
		call MoveRedUpLeft
		jmp @@Exit
	@@MoveLeftBelow:
		mov [Turn],'G'
		call MoveRedDownLeft
		jmp @@Exit
@@Exit:
	ret
endp CheckRedYellowPressAndMove

;checks whare the press accured, and moves the player acoording to it
proc CheckGreenYellowPressAndMove

	@@CheckRightAbove:			
		mov di,[GreenX]
		add di,22
		cmp cx,di
		jae @@CheckY
		jmp @@CheckRightBelow
	@@CheckY:
		mov di,[GreenY]
		cmp dx,di
		jb @@MoveRightAbove1
		
	@@CheckRightBelow:
		mov di,[GreenX]
		add di,22
		cmp cx,di
		jae @@CheckY2
		jmp @@CheckLeftAbove
	@@CheckY2:
		mov di,[GreenY]
		add di,22
		cmp dx,di
		jae @@MoveRightBelow1
		
	@@CheckLeftAbove:
		mov di,[GreenX]
		dec di
		cmp cx,di
		jb @@CheckY3
		jmp @@CheckLeftBelow
	@@CheckY3:
		mov di,[GreenY]
		cmp dx,di
		jb @@MoveLeftAbove1

	@@CheckLeftBelow:
		mov di,[GreenX]
		dec di
		cmp cx,di
		jb @@CheckY4
		jmp @@CheckAbove
	@@CheckY4:
		mov di,[GreenY]
		add di,22
		cmp dx,di
		jae @@MoveLeftBelow1
	
@@CheckAbove:	
		mov di,[GreenX]
		add di,44
		cmp cx,di
		jae @@MoveGPRightAbove
		mov di,[GreenX]
		sub di,25
		cmp cx,di
		jle @@MoveGPLeftAbove
		mov di,[GreenY]
		sub di,25
		cmp dx,di
		jle @@MoveGPUpAbove
		mov di,[GreenY]
		add di,44
		cmp dx,di
		jae @@MoveGPDownAbove
		jmp @@AboveMidCheck
									@@MoveRightAbove1:
										jmp @@MoveRightAbove
									@@MoveRightBelow1:
										jmp @@MoveRightBelow
									@@MoveLeftAbove1:
										jmp @@MoveLeftAbove
									@@MoveLeftBelow1:
										jmp @@MoveLeftBelow
@@AboveMidCheck:	
		mov di,[GreenX]
		add di,22
		cmp cx,di
		jae @@MoveGPRight
		mov di,[GreenX]
		dec di
		cmp cx,di
		jb @@MoveGPLeft
		mov di,[GreenY]
		cmp dx,di
		jb @@MoveGPUp
		mov di,[GreenY]
		add di,22
		cmp dx,di
		jae @@MoveGPDown
		
	
		
		jmp @@Exit
		
		
	

	
	@@MoveGPRightAbove:
		mov [Turn],'R'
		call MoveGreen2Right
		jmp @@Exit
	@@MoveGPLeftAbove:
		mov [Turn],'R'
		call MoveGreen2Left
		jmp @@Exit
	@@MoveGPUpAbove:
		mov [Turn],'R'
		call MoveGreen2Up
		jmp @@Exit
	@@MoveGPDownAbove:
		mov [Turn],'R'
		call MoveGreen2Down	
		jmp @@Exit
		
		
	@@MoveGPRight:
		mov [Turn],'R'
		call MoveGreenRight
		jmp @@Exit
	@@MoveGPLeft:
		mov [Turn],'R'
		call MoveGreenLeft
		jmp @@Exit
	@@MoveGPUp:
		mov [Turn],'R'
		call MoveGreenUp
		jmp @@Exit
	@@MoveGPDown:
		mov [Turn],'R'
		call MoveGreenDown
		jmp @@Exit
		
		
	@@MoveRightAbove:
		mov [Turn],'R'
		call MoveGreenUpRight
		jmp @@Exit
	@@MoveRightBelow:
		mov [Turn],'R'
		call MoveGreenDownRight
		jmp @@Exit
	@@MoveLeftAbove:
		mov [Turn],'R'
		call MoveGreenUpLeft
		jmp @@Exit
	@@MoveLeftBelow:
		mov [Turn],'R'
		call MoveGreenDownLeft
		jmp @@Exit
@@Exit:
	ret
endp CheckGreenYellowPressAndMove


proc DrawGreenWallsLeft
	push cx
	mov cx,[GreenWalls]
@@Strt:
	push [GreenWallsLeftX]
	push [GreenWallsLeftY]
	call DemiGreenPWallVertical
	add [GreenWallsLeftX],20
	cmp cx,6
	je @@LayerDown
	jmp @@Loop
@@LayerDown:
	mov [GreenWallsLeftX],215
	add [GreenWallsLeftY],40
@@Loop:
	loop @@Strt
	sub [GreenWallsLeftX],20
	pop cx
	ret
endp DrawGreenWallsLeft

proc EraseGreenWallLeft
	cmp [GreenWalls],4
	je @@LayerUp
	push [GreenWallsLeftX]
	push [GreenWallsLeftY]
	call EraseWallLeft	
	jmp @@Exit
@@LayerUp:
	sub [GreenWallsLeftY],40
	mov [GreenWallsLeftX],295
	push [GreenWallsLeftX]
	push [GreenWallsLeftY]
	call EraseWallLeft
@@Exit:
	sub [GreenWallsLeftX],20
	ret
endp EraseGreenWallLeft

proc EraseRedWallLeft
	cmp [RedWalls],4
	je @@LayerUp
	push [RedWallsLeftX]
	push [RedWallsLeftY]
	call EraseWallLeft	
	jmp @@Exit
@@LayerUp:
	sub [RedWallsLeftY],40
	mov [RedWallsLeftX],295
	push [RedWallsLeftX]
	push [RedWallsLeftY]
	call EraseWallLeft
@@Exit:
	sub [RedWallsLeftX],20
	ret
endp EraseRedWallLeft

proc DrawRedWallsLeft
	push cx
	mov cx,[RedWalls]
@@Strt:
	push [RedWallsLeftX]
	push [RedWallsLeftY]
	call DemiRedPWallVertical
	add [RedWallsLeftX],20
	cmp cx,6
	je @@LayerDown
	jmp @@Loop
@@LayerDown:
	mov [RedWallsLeftX],215
	add [RedWallsLeftY],40
@@Loop:
	loop @@Strt
	sub [RedWallsLeftX],20
	mov [LastWallX],0
	mov [LastWallY],0
	pop cx
	ret
endp DrawRedWallsLeft


;Erases a wall in the right screen
Xpos equ [bp + 6]
Ypos equ [bp + 4]
proc EraseWallLeft
	push bp
	mov bp,sp
	push Xpos
	push Ypos
	push 37
	push 6
	push 248
	call fullrectangle
	pop bp
	ret 4
endp EraseWallLeft



;Moves Red Player right, changes its X and Y accordinaly, and changes the position in the Board variable
proc MoveRedRight
	push si
	call EraseRP
	add [RedX],22
	mov si,[RPPlace]
	mov [Board + si],'E'
	mov [Board + si + 2],'R'
	add [RPPlace],2
	call DrawRP
	pop si
	ret
endp MoveRedRight


;Moves Green Player right, changes its X and Y accordinaly, and changes the position in the Board variable
proc MoveGreenRight
	push si
	call EraseGP
	add [GreenX],22
	mov si,[GPPlace]
	mov [Board + si],'E'
	mov [Board + si + 2],'G'
	add [GPPlace],2
	call DrawGP
	pop si
	ret
endp MoveGreenRight


;Moves Red Player left, changes its X and Y accordinaly, and changes the position in the Board variable
proc MoveRedLeft	
	push si
	call EraseRP
	sub [RedX],22
	mov si,[RPPlace]
	mov [Board + si],'E'
	mov [Board + si - 2],'R'
	sub [RPPlace],2
	call DrawRP
	pop si
	ret
endp MoveRedLeft


;Moves Green Player left, changes its X and Y accordinaly, and changes the position in the Board variable
proc MoveGreenLeft
	push si
	call EraseGP
	sub [GreenX],22
	mov si,[GPPlace]
	mov [Board + si],'E'
	mov [Board + si - 2],'G'
	sub [GPPlace],2
	call DrawGP
	pop si
	ret
endp MoveGreenLeft


;Moves Red Player up, changes its X and Y accordinaly, and changes the position in the Board variable
proc MoveRedUp
	push si
	call EraseRP
	sub [RedY],22
	mov si,[RPPlace]
	mov [Board + si],'E'
	mov [Board + si - 34],'R'
	sub [RPPlace],34
	call DrawRP
	pop si
	ret
endp MoveRedUp


;Moves Green Player up, changes its X and Y accordinaly, and changes the position in the Board variable
proc MoveGreenUp
	push si
	call EraseGP
	sub [GreenY],22
	mov si,[GPPlace]
	mov [Board + si],'E'
	mov [Board + si - 34],'G'
	sub [GPPlace],34
	call DrawGP
	pop si
	ret
endp MoveGreenUp


;Moves Red Player down, changes its X and Y accordinaly, and changes the position in the Board variable
proc MoveRedDown
	push si
	call EraseRP
	add [RedY],22
	mov si,[RPPlace]
	mov [Board + si],'E'
	mov [Board + si + 34],'R'
	add [RPPlace],34
	call DrawRP
	pop si
	ret
endp MoveRedDown


;Moves Green Player down, changes its X and Y accordinaly, and changes the position in the Board variable
proc MoveGreenDown
	push si
	call EraseGP
	add [GreenY],22
	mov si,[GPPlace]
	mov [Board + si],'E'
	mov [Board + si + 34],'G'
	add [GPPlace],34
	call DrawGP
	pop si
	ret
endp MoveGreenDown

;Moves Red Player 2 right, changes its X and Y accordinaly, and changes the position in the Board variable
proc MoveRed2Right
	push si
	call EraseRP
	add [RedX],44
	mov si,[RPPlace]
	mov [Board + si],'E'
	mov [Board + si + 4],'R'
	add [RPPlace],4
	call DrawRP
	pop si
	ret
endp MoveRed2Right


;Moves Green Player 2 right, changes its X and Y accordinaly, and changes the position in the Board variable
proc MoveGreen2Right
	push si
	call EraseGP
	add [GreenX],44
	mov si,[GPPlace]
	mov [Board + si],'E'
	mov [Board + si + 4],'G'
	add [GPPlace],4
	call DrawGP
	pop si
	ret
endp MoveGreen2Right


;Moves Red Player 2 left, changes its X and Y accordinaly, and changes the position in the Board variable
proc MoveRed2Left	
	push si
	call EraseRP
	sub [RedX],44
	mov si,[RPPlace]
	mov [Board + si],'E'
	mov [Board + si - 4],'R'
	sub [RPPlace],4
	call DrawRP
	pop si
	ret
endp MoveRed2Left


;Moves Green Player 2 left, changes its X and Y accordinaly, and changes the position in the Board variable
proc MoveGreen2Left
	push si
	call EraseGP
	sub [GreenX],44
	mov si,[GPPlace]
	mov [Board + si],'E'
	mov [Board + si - 4],'G'
	sub [GPPlace],4
	call DrawGP
	pop si
	ret
endp MoveGreen2Left


;Moves Red Player 2 up, changes its X and Y accordinaly, and changes the position in the Board variable
proc MoveRed2Up
	push si
	call EraseRP
	sub [RedY],44
	mov si,[RPPlace]
	mov [Board + si],'E'
	mov [Board + si - 68],'R'
	sub [RPPlace],68
	call DrawRP
	pop si
	ret
endp MoveRed2Up


;Moves Green Player 2 up, changes its X and Y accordinaly, and changes the position in the Board variable
proc MoveGreen2Up
	push si
	call EraseGP
	sub [GreenY],44
	mov si,[GPPlace]
	mov [Board + si],'E'
	mov [Board + si - 68],'G'
	sub [GPPlace],68
	call DrawGP
	pop si
	ret
endp MoveGreen2Up


;Moves Red Player 2 down, changes its X and Y accordinaly, and changes the position in the Board variable
proc MoveRed2Down
	push si
	call EraseRP
	add [RedY],44
	mov si,[RPPlace]
	mov [Board + si],'E'
	mov [Board + si + 68],'R'
	add [RPPlace],68
	call DrawRP
	pop si
	ret
endp MoveRed2Down


;Moves Green Player 2 down, changes its X and Y accordinaly, and changes the position in the Board variable
proc MoveGreen2Down
	push si
	call EraseGP
	add [GreenY],44
	mov si,[GPPlace]
	mov [Board + si],'E'
	mov [Board + si + 68],'G'
	add [GPPlace],68
	call DrawGP
	pop si
	ret
endp MoveGreen2Down

proc MoveRedUpRight
	push si
	call EraseRP
	sub [RedY],22
	add [RedX],22
	mov si,[RPPlace]
	mov [Board + si],'E'
	mov [Board + si - 32],'R'
	sub [RPPlace],32
	call DrawRP
	pop si
	ret
endp MoveRedUpRight

proc MoveRedUpLeft
	push si
	call EraseRP
	sub [RedY],22
	sub [RedX],22
	mov si,[RPPlace]
	mov [Board + si],'E'
	mov [Board + si - 36],'R'
	sub [RPPlace],36
	call DrawRP
	pop si
	ret
endp MoveRedUpLeft

proc MoveRedDownRight
	push si
	call EraseRP
	add [RedY],22
	add [RedX],22
	mov si,[RPPlace]
	mov [Board + si],'E'
	mov [Board + si + 36],'R'
	add [RPPlace],36
	call DrawRP
	pop si
	ret
endp MoveRedDownRight

proc MoveRedDownLeft
	push si
	call EraseRP
	add [RedY],22
	sub [RedX],22
	mov si,[RPPlace]
	mov [Board + si],'E'
	mov [Board + si + 32],'R'
	add [RPPlace],32
	call DrawRP
	pop si
	ret
endp MoveRedDownLeft

proc MoveGreenUpRight
	push si
	call EraseGP
	sub [GreenY],22
	add [GreenX],22
	mov si,[GPPlace]
	mov [Board + si],'E'
	mov [Board + si - 32],'G'
	sub [GPPlace],32
	call DrawGP
	pop si
	ret
endp MoveGreenUpRight

proc MoveGreenUpLeft
	push si
	call EraseGP
	sub [GreenY],22
	sub [GreenX],22
	mov si,[GPPlace]
	mov [Board + si],'E'
	mov [Board + si - 36],'G'
	sub [GPPlace],36
	call DrawGP
	pop si
	ret
endp MoveGreenUpLeft

proc MoveGreenDownRight
	push si
	call EraseGP
	add [GreenY],22
	add [GreenX],22
	mov si,[GPPlace]
	mov [Board + si],'E'
	mov [Board + si + 36],'G'
	add [GPPlace],36
	call DrawGP
	pop si
	ret
endp MoveGreenDownRight

proc MoveGreenDownLeft
	push si
	call EraseGP
	add [GreenY],22
	sub [GreenX],22
	mov si,[GPPlace]
	mov [Board + si],'E'
	mov [Board + si + 32],'G'
	add [GPPlace],32
	call DrawGP
	pop si
	ret
endp MoveGreenDownLeft
;Draws a horizontal wall with fullrectangle for the green player according to the X and Y you push and the place the player pressed and chenges the board
Xpos equ [bp + 8]
Ypos equ [bp + 6]
Place equ [bp + 4]
proc DrawGreenPWallHorizontal
	push bp
	mov bp,sp
	push si
	push Xpos
	push Ypos
	push 6
	push 37
	push 16
	call fullrectangle
	mov si,Place
	mov [Board + si],'W'
	mov [Board + si + 2],'W'
	dec [GreenWalls]
	pop si 
	pop bp
	ret 6
endp DrawGreenPWallHorizontal

;Draws a vertical wall with fullrectangle for the green player according to the X and Y you push and the place the player pressed and chenges the board
Xpos equ [bp + 8]
Ypos equ [bp + 6]
Place equ [bp + 4]
proc DrawGreenPWallVertical
	push bp
	mov bp,sp
	push si
	push Xpos
	push Ypos
	push 37
	push 6
	push 16
	call fullrectangle
	mov si,Place
	mov [Board + si],'W'
	mov [Board + si + 34],'W'
	dec [GreenWalls]
	pop si 
	pop bp
	ret 6
endp DrawGreenPWallVertical


;Draws a horizontal wall with fullrectangle for the Red player according to the X and Y you push and the place the player pressed and chenges the board
Xpos equ [bp + 8]
Ypos equ [bp + 6]
Place equ [bp + 4]
proc DrawRedPWallHorizontal
	push bp
	mov bp,sp
	push si
	push Xpos
	push Ypos
	push 6
	push 37
	push 15
	call fullrectangle
	mov si,Place
	mov [Board + si],'W'
	mov [Board + si + 2],'W'
	dec [RedWalls]
	pop si 
	pop bp
	ret 6
endp DrawRedPWallHorizontal

;Draws a vertical wall with fullrectangle for the Red player according to the X and Y you push and the place the player pressed and chenges the board
Xpos equ [bp + 8]
Ypos equ [bp + 6]
Place equ [bp + 4]
proc DrawRedPWallVertical
	push bp
	mov bp,sp
	push si
	push Xpos
	push Ypos
	push 37
	push 6
	push 15
	call fullrectangle
	mov si,Place
	mov [Board + si],'W'
	mov [Board + si + 34],'W'
	dec [RedWalls]
	pop si 
	pop bp
	ret 6
endp DrawRedPWallVertical


;Draws a horizontal wall with fullrectangle for the green player according to the X and Y you push without actually changing the board
Xpos equ [bp + 6]
Ypos equ [bp + 4]
proc DemiGreenPWallHorizontal
	push bp
	mov bp,sp
	push si
	push Xpos
	push Ypos
	push 6
	push 37
	push 16
	call fullrectangle
	mov si,Xpos
	mov [LastWallX],si
	mov si,Ypos
	mov [LastWallY],si
	pop si
	pop bp
	ret 4
endp DemiGreenPWallHorizontal

;Draws a vertical wall with fullrectangle for the green player according to the X and Y you push without actually changing the board
Xpos equ [bp + 6]
Ypos equ [bp + 4]
proc DemiGreenPWallVertical
	push bp
	mov bp,sp
	push si
	push Xpos
	push Ypos
	push 37
	push 6
	push 16
	call fullrectangle
	mov si,Xpos
	mov [LastWallX],si
	mov si,Ypos
	mov [LastWallY],si
	pop si
	pop bp
	ret 4
endp DemiGreenPWallVertical


;Draws a horizontal wall with fullrectangle for the Red player according to the X and Y you push without actually changing the board
Xpos equ [bp + 6]
Ypos equ [bp + 4]
proc DemiRedPWallHorizontal
	push bp
	mov bp,sp
	push si
	push Xpos
	push Ypos
	push 6
	push 37
	push 15
	call fullrectangle
	mov si,Xpos
	mov [LastWallX],si
	mov si,Ypos
	mov [LastWallY],si
	pop si
	pop bp
	ret 4
endp DemiRedPWallHorizontal

;Draws a vertical wall with fullrectangle for the Red player according to the X and Y you push without actually changing the board
Xpos equ [bp + 6]
Ypos equ [bp + 4]
proc DemiRedPWallVertical
	push bp
	mov bp,sp
	push si
	push Xpos
	push Ypos
	push 37
	push 6
	push 15
	call fullrectangle
	mov si,Xpos
	mov [LastWallX],si
	mov si,Ypos
	mov [LastWallY],si
	pop si
	pop bp
	ret 4
endp DemiRedPWallVertical


;Erases a horizontal wall with fullrectangle for the green player according to the X and Y you push and the place the player pressed
Xpos equ [bp + 6]
Ypos equ [bp + 4]
proc EraseWallHorizontal
	push bp
	mov bp,sp
	push Xpos
	push Ypos
	push 6
	push 37
	push 6
	call fullrectangle
	pop bp
	ret 4
endp EraseWallHorizontal

;Erases a vertical wall with fullrectangle according to the X and Y you push and the place the player pressed
Xpos equ [bp + 6]
Ypos equ [bp + 4]
proc EraseWallVertical
	push bp
	mov bp,sp
	push Xpos
	push Ypos
	push 37
	push 6
	push 6
	call fullrectangle
	pop bp
	ret 4
endp EraseWallVertical
;Erases The last demi wall draw according to the LastWallX LastWallX and LastWallShape
proc EraseLastDemiWall
	push cx
	push dx
	cmp [LastWallShape],'H' ;check shape
	je @@EraseHorizontal
@@EraseVertical:
	push [LastWallX]
	push [LastWallY] 
	call EraseWallVertical ;erase
	jmp @@Ret
@@EraseHorizontal:
	push [LastWallX]
	push [LastWallY]
	call EraseWallHorizontal ;erase
@@Ret:
	pop dx
	pop cx
	ret
endp EraseLastDemiWall


; checks if a wall is need to be used, if the player pressed a legal place to put a wall in, it places it there, checks if the press was on the right place, and no walls around
proc CheckIfWallPressed
	mov [CheckWallX],20
	mov [CheckWallY],6
	mov di,cx
	mov bx,1
	mov cx,64
					cmp [Turn],'R'
					je @@JmpToRedTurn
					jmp @@StrtCheckPlacesVGP
							@@JmpToRedTurn:
								jmp	@@RedTurn
					
@@StrtCheckPlacesVGP:
	cmp di,[CheckWallX]
	ja @@SecondXGP
	jmp @@ResetGP
@@SecondXGP:
	mov si,[CheckWallX]
	add si,6
	cmp di,si
	jb @@CheckYGP
	jmp @@ResetGP
@@CheckYGP:
	cmp dx,[CheckWallY]
	jae @@SecondYGP
	jmp @@ResetGP
@@SecondYGP:
	mov si,[CheckWallY]
	add si,16
	cmp dx,si
	jb @@CheckIfWallThere
	jmp @@ResetGP
									@@MidLoop:
									jmp @@StrtCheckPlacesVGP

@@CheckIfWallThere:
	cmp [Board + bx],'W'
	je @@ResetGp
	cmp [Board + bx + 34],'W'
	je @@ResetGp
	cmp [Board + bx + 16],'W'
	jne @@PlaceWallGP
	cmp [Board + bx + 18],'W'
	je @@ResetGp
@@PlaceWallGP:   
	call HideMouse
	push [CheckWallX]
	push [CheckWallY]
	push bx
	call DrawGreenPWallVertical
	mov [IsWallPressed],1
	mov [LastWallX],0
	mov [LastWallY],0
	call ShowMouse
	mov [Turn],'R'
	mov [WallButton],0
	call EraseGreenWallLeft
	jmp @@FinishCheck
@@ResetGP:
	add [CheckWallY],22
	cmp [CheckWallY],182
	jne @@LoopGP
	mov [CheckWallY],6
	add [CheckWallX],22
	jmp @@LoopGp2
@@LoopGP:
	add bx,34
	loop @@MidLoop
@@LoopGp2:
	sub bx,236
	loop @@MidLoop

	mov [CheckWallX],4
	mov [CheckWallY],21
	mov cx,64
	mov bx,17
							
									
@@StrtCheckPlacesHGP:
	cmp di,[CheckWallX]
	ja @@SecondX2GP
	jmp @@Reset2GP
@@SecondX2GP:
	mov si,[CheckWallX]
	add si,16
	cmp di,si
	jb @@CheckY2GP
	jmp @@Reset2GP
@@CheckY2GP:
	cmp dx,[CheckWallY]
	jae @@SecondY2GP
	jmp @@Reset2GP
@@SecondY2GP:
	mov si,[CheckWallY]
	add si,6
	cmp dx,si
	jb @@CheckIfWallThere2
	jmp @@Reset2GP	
										@@MidLoop2:
										jmp @@StrtCheckPlacesHGP

@@CheckIfWallThere2:
	cmp [Board + bx],'W'
	je @@Reset2GP
	cmp [Board + bx + 2],'W'
	je @@Reset2GP
	cmp [Board + bx - 16],'W'
	jne @@PlaceWall2GP
	cmp [Board + bx + 18],'W'
	je @@Reset2GP
@@PlaceWall2GP:  
	call HideMouse
	push [CheckWallX]
	push [CheckWallY]
	push bx
	call DrawGreenPWallHorizontal
	mov [IsWallPressed],1
	call ShowMouse
	mov [LastWallX],0
	mov [LastWallY],0
	mov [Turn],'R'
	mov [WallButton],0
	call EraseGreenWallLeft
	jmp @@FinishCheck
@@Reset2GP:
	add [CheckWallX],22
	cmp [CheckWallX],180
	jne @@Loop2GP
	mov [CheckWallX],4
	add [CheckWallY],22
	jmp @@Loop2GP2
@@Loop2GP:
	add bx,2
	loop @@MidLoop2
@@Loop2GP2:
	add bx,20
	loop @@MidLoop2	
	jmp @@FinishCheck
	

@@RedTurn:
	mov [CheckWallX],20
	mov [CheckWallY],6
	mov cx,64
	mov bx,1
@@StrtCheckPlacesVRP:
	cmp di,[CheckWallX]
	ja @@SecondXRP
	jmp @@ResetRP
@@SecondXRP:
	mov si,[CheckWallX]
	add si,6
	cmp di,si
	jb @@CheckYRP
	jmp @@ResetRP																	

@@CheckYRP:
	cmp dx,[CheckWallY]
	jae @@SecondYRP
	jmp @@ResetRP
	
@@SecondYRP:
	mov si,[CheckWallY]
	add si,16
	cmp dx,si
	jb @@CheckIfWallThere3
	jmp @@ResetRP
										@@MidLoop3:
										jmp @@StrtCheckPlacesVRP
@@CheckIfWallThere3:
	cmp [Board + bx],'W'
	je @@ResetRp
	cmp [Board + bx + 34],'W'
	je @@ResetRp
	cmp [Board + bx + 16],'W'
	jne @@PlaceWallRP
	cmp [Board + bx + 18],'W'
	je @@ResetRp
@@PlaceWallRP:   
	call HideMouse
	push [CheckWallX]
	push [CheckWallY]
	push bx
	call DrawRedPWallVertical
	mov [IsWallPressed],1
	call ShowMouse
	mov [LastWallX],0
	mov [LastWallY],0
	mov [Turn],'G'
	mov [WallButton],0
	call EraseRedWallLeft
	jmp @@FinishCheck
@@ResetRP:
	add [CheckWallY],22
	cmp [CheckWallY],182
	jne @@LoopRP
	mov [CheckWallY],6
	add [CheckWallX],22
	jmp @@LoopRP2
@@LoopRP:
	add bx,34
	loop @@MidLoop3
@@LoopRP2:
	sub bx,236
	loop @@MidLoop3



	mov [CheckWallX],4
	mov [CheckWallY],21
	mov cx,64
	mov bx,17
@@StrtCheckPlacesHRP:
	cmp di,[CheckWallX]
	ja @@SecondX2RP
	jmp @@Reset2RP
@@SecondX2RP:
	mov si,[CheckWallX]
	add si,16
	cmp di,si
	jb @@CheckY2RP
	jmp @@Reset2RP

@@CheckY2RP:
	cmp dx,[CheckWallY]
	jae @@SecondY2RP
	jmp @@Reset2RP
@@SecondY2RP:
	mov si,[CheckWallY]
	add si,6
	cmp dx,si
	jb @@CheckIfWallThere4
	jmp @@Reset2RP
									@@MidLoop4:
										jmp @@StrtCheckPlacesHRP
@@CheckIfWallThere4:
	cmp [Board + bx],'W'
	je @@Reset2Rp
	cmp [Board + bx + 2],'W'
	je @@Reset2Rp
	cmp [Board + bx - 16],'W'
	jne @@PlaceWall2RP
	cmp [Board + bx + 18],'W'
	je @@Reset2Rp
										
@@PlaceWall2RP:  
	call HideMouse
	push [CheckWallX]
	push [CheckWallY]
	push bx
	call DrawRedPWallHorizontal
	mov [IsWallPressed],1
	call ShowMouse
	mov [LastWallX],0
	mov [LastWallY],0
	mov [Turn],'G'
	mov [WallButton],0
	call EraseRedWallLeft
	jmp @@FinishCheck
@@Reset2RP:
	add [CheckWallX],22
	cmp [CheckWallX],180
	jne @@Loop2RP
	mov [CheckWallX],4
	add [CheckWallY],22
	jmp @@Loop2RP2
@@Loop2RP:
	add bx,2
	loop @@MidLoop4
@@Loop2RP2:
	add bx,20
	loop @@MidLoop4	
	
@@FinishCheck:
	mov cx,di
ret
endp CheckIfWallPressed


;check if mouse is in place to draw a demi wall and if there is no wall that is interapting to it 
proc DrawDemiWallsForRed
	mov [CheckWallX],20
	mov [CheckWallY],6
	mov di,cx
	mov cx,64
	mov bx,1
	mov [IsDemiWallDrawn],0
@@StrtCheckPlacesVRP:
	cmp di,[CheckWallX]
	ja @@SecondXRP
	jmp @@ResetRP
@@SecondXRP:
	mov si,[CheckWallX]
	add si,6
	cmp di,si
	jb @@CheckYRP
	jmp @@ResetRP
@@CheckYRP:
	cmp dx,[CheckWallY]
	jae @@SecondYRP
	jmp @@ResetRP
@@SecondYRP:
	mov si,[CheckWallY]
	add si,16
	cmp dx,si
	jb @@CheckIfWallThere3
	jmp @@ResetRP		
									@@MidLoop:
									jmp @@StrtCheckPlacesVRP
@@CheckIfWallThere3:
	cmp [Board + bx],'W'
	je @@ResetRP
	cmp [Board + bx + 34],'W'
	je @@ResetRP
	cmp [Board + bx + 16],'W'
	jne @@PlaceDemiWallRP
	cmp [Board + bx + 18],'W'
	je @@ResetRP
@@PlaceDemiWallRP:   
	call HideMouse
	call EraseLastDemiWall
	push [CheckWallX]
	push [CheckWallY]
	call DemiRedPWallVertical
	mov [LastWallShape],'V'
	mov [IsDemiWallDrawn],1
	call ShowMouse
	jmp @@FinishCheck
@@ResetRP:
	add [CheckWallY],22
	cmp [CheckWallY],182
	jne @@LoopRP
	mov [CheckWallY],6
	add [CheckWallX],22
	jmp @@LoopRP2
@@LoopRP:
	add bx,34
	loop @@MidLoop
@@LoopRP2:
	sub bx,236
	loop @@MidLoop

															

	mov [CheckWallX],4
	mov [CheckWallY],21
	mov cx,64
	mov bx,17
@@StrtCheckPlacesHRP:
	cmp di,[CheckWallX]
	ja @@SecondX2RP
	jmp @@Reset2RP
@@SecondX2RP:
	mov si,[CheckWallX]
	add si,16
	cmp di,si
	jb @@CheckY2RP
	jmp @@Reset2RP
@@CheckY2RP:
	cmp dx,[CheckWallY]
	jae @@SecondY2RP
	jmp @@Reset2RP
@@SecondY2RP:
	mov si,[CheckWallY]
	add si,6
	cmp dx,si
	jb @@CheckIfWallThere4
	jmp @@Reset2RP
										@@MidLoop2:
									jmp @@StrtCheckPlacesHRP
@@CheckIfWallThere4:
	cmp [Board + bx],'W'
	je @@Reset2RP
	cmp [Board + bx + 2],'W'
	je @@Reset2RP
	cmp [Board + bx - 16],'W'
	jne @@PlaceDemiWall2RP
	cmp [Board + bx + 18],'W'
	je @@Reset2RP
										
@@PlaceDemiWall2RP:  
	call HideMouse
	call EraseLastDemiWall
	push [CheckWallX]
	push [CheckWallY]
	call DemiRedPWallHorizontal
	mov [LastWallShape],'H'
	mov [IsDemiWallDrawn],1
	call ShowMouse
	jmp @@FinishCheck
@@Reset2RP:
	add [CheckWallX],22
	cmp [CheckWallX],180
	jne @@Loop2RP
	mov [CheckWallX],4
	add [CheckWallY],22
	jmp @@Loop2RP2
@@Loop2RP:
	add bx,2
	loop @@MidLoop2
@@Loop2RP2:
	add bx,20
	loop @@MidLoop2
	
	cmp [IsDemiWallDrawn],1
	je @@FinishCheck
	call HideMouse
	call EraseLastDemiWall
	call ShowMouse
@@FinishCheck:
	ret
endp DrawDemiWallsForRed


;check if mouse is in place to draw a demi wall and if there is no wall that is interapting to it 
proc DrawDemiWallsForGreen
	mov [CheckWallX],20
	mov [CheckWallY],6
	mov di,cx
	mov cx,64
	mov bx,1	
	mov [IsDemiWallDrawn],0
@@StrtCheckPlacesVGP:
	cmp di,[CheckWallX]
	ja @@SecondXGP
	jmp @@ResetGP
@@SecondXGP:
	mov si,[CheckWallX]
	add si,6
	cmp di,si
	jb @@CheckYGP
	jmp @@ResetGP
@@CheckYGP:
	cmp dx,[CheckWallY]
	jae @@SecondYGP
	jmp @@ResetGP
@@SecondYGP:
	mov si,[CheckWallY]
	add si,16
	cmp dx,si
	jb @@CheckIfWallThere
	jmp @@ResetGP
									@@MidLoop:
									jmp @@StrtCheckPlacesVGP
@@CheckIfWallThere:
	cmp [Board + bx],'W'
	je @@ResetGp
	cmp [Board + bx + 34],'W'
	je @@ResetGp
	cmp [Board + bx + 16],'W'
	jne @@PlaceDemiWallGP
	cmp [Board + bx + 18],'W'
	je @@ResetGp
@@PlaceDemiWallGP:   
	call HideMouse
	call EraseLastDemiWall
	push [CheckWallX]
	push [CheckWallY]
	call DemiGreenPWallVertical
	mov [LastWallShape],'V'
	mov [IsDemiWallDrawn],1
	call ShowMouse
	jmp @@FinishCheck
@@ResetGP:
	add [CheckWallY],22
	cmp [CheckWallY],182
	jne @@LoopGP
	mov [CheckWallY],6
	add [CheckWallX],22
	jmp @@LoopGP2
@@LoopGP:
	add bx,34
	loop @@MidLoop
@@LoopGP2:											
	sub bx,236	
	loop @@MidLoop				

	

	mov [CheckWallX],4
	mov [CheckWallY],21
	mov cx,64
	mov bx,17												
@@StrtCheckPlacesHGP:
	cmp di,[CheckWallX]
	ja @@SecondX2GP
	jmp @@Reset2GP
@@SecondX2GP:
	mov si,[CheckWallX]
	add si,16
	cmp di,si
	jb @@CheckY2GP
	jmp @@Reset2GP
@@CheckY2GP:
	cmp dx,[CheckWallY]
	jae @@SecondY2GP
	jmp @@Reset2GP
@@SecondY2GP:
	mov si,[CheckWallY]
	add si,6
	cmp dx,si
	jb @@CheckIfWallThere2
	jmp @@Reset2GP	
											@@MidLoop2:
									jmp @@StrtCheckPlacesHGP
@@CheckIfWallThere2:
	cmp [Board + bx],'W'
	je @@Reset2GP
	cmp [Board + bx + 2],'W'
	je @@Reset2GP
	cmp [Board + bx - 16],'W'
	jne @@PlaceDemiWall2GP
	cmp [Board + bx + 18],'W'
	je @@Reset2GP
@@PlaceDemiWall2GP:  
	call HideMouse
	call EraseLastDemiWall
	push [CheckWallX]
	push [CheckWallY]
	call DemiGreenPWallHorizontal
	mov [LastWallShape],'H'
	mov [IsDemiWallDrawn],1
	call ShowMouse
	jmp @@FinishCheck
@@Reset2GP:
	add [CheckWallX],22
	cmp [CheckWallX],180
	jne @@Loop2GP
	mov [CheckWallX],4
	add [CheckWallY],22
	jmp @@Loop2GP2
@@Loop2GP:
	add bx,2
	loop @@MidLoop2
@@Loop2GP2:
	add bx,20
	loop @@MidLoop2
	
	cmp [IsDemiWallDrawn],1
	je @@FinishCheck
	call HideMouse
	call EraseLastDemiWall
	call ShowMouse
	
@@FinishCheck:

	ret
endp DrawDemiWallsForGreen


proc CheckIfRedPPressed
		cmp cx,[RedX]
		jae @@CheckRPX  ;check if red player was pressed
		jmp @@EraseYellows		
@@CheckRPX:
		mov di,[RedX]
		add di,15
		cmp cx,di
		jb @@CheckRPY
		jmp @@EraseYellows
		
	@@CheckRPY:			
		cmp dx,[RedY]
		jae @@CheckRPY2
		jmp @@EraseYellows		
	@@CheckRPY2:
		mov di,[RedY]
		add di,15
		cmp dx,di
		jbe @@RPPress  ;if so jump and draws the places he can move to
		jmp @@EraseYellows
@@RPPress:	;if got pressed, and he  draw the possible places he can go to
		
		call HideMouse
		call ShowMouse
		mov [WallButton],0
		call DrawRedYellows
		jmp @@Exit
@@EraseYellows:		;if didnt get pressed and the yellows are on, erase them
		cmp [YellowOn],0
		je @@Exit
		call EraseRedYellows
@@Exit:
	ret
endp CheckIfRedPPressed

proc CheckIfGreenPPressed

	cmp cx,[GreenX]
		jae @@CheckGPX  ;check if green player was pressed
		jmp @@EraseYellows
		
	@@CheckGPX: 
		mov di,[GreenX]
		add di,15
		cmp cx,di
		jb @@CheckGPY
		jmp @@EraseYellows
										
	@@CheckGPY:			
		cmp dx,[GreenY]
		jae @@CheckGPY2
		jmp @@EraseYellows
		
	@@CheckGPY2:
		mov di,[GreenY]
		add di,15
		cmp dx,di
		jbe @@GPPress
		jmp @@EraseYellows
@@GPPress: ;if got pressed, and he  draw the possible places he can go to
		call HideMouse
		call ShowMouse
		mov [WallButton],0
		push [GreenX]
		push [GreenY]
		call DrawGreenYellows
		jmp @@Exit

@@EraseYellows: 	;if didnt get pressed and the yellows are on, erase them
		cmp [YellowOn],0
		je @@Exit
		call EraseGreenYellows
@@Exit:
	
	ret
endp CheckIfGreenPPressed


proc CheckMousePressMove  far
		push di
		push si
		push ax
		mov ax,3
		int 33h ;gets mouse position
		shr cx,1 ;divides cx by 2
		cmp bx,1
		je @@CheckPress ;if left mouse click, checks where
		jmp @@CheckMouseMove ;else check the mouse movement
@@CheckPress:
		call HideMouse
		mov ah,0Dh
		mov bh,0
		int 10h ;checks if pressed on yellow
		mov ah,0
		cmp al,252
		je @@MovePlayer ;if so jmp to move the player
		call ShowMouse
		call CheckIfWallButtonPressed ;if not checks if the wall button is pressed
		cmp [WallButton],0 ;if the wall button wasnt pressed or got closed
		je @@CheckPlayerPress ;checks if one of the players got pressed
		call CheckIfWallPressed ; if the wall button did got pressed, or it is turned on, checks if a wall got pressed
		cmp [IsWallPressed],0
		je @@CheckPlayerPress ;if wall didnt got pressed, checks if one of the players got pressed
		jmp @@Exit
	
@@CheckPlayerPress:
		cmp [Turn],'R'
		jne @@GPTurn ;checks if the one whos turn is now got pressed
@@RPTurn:		
		call CheckIfRedPPressed
		jmp @@Exit
		
@@GPTurn:		
		call CheckIfGreenPPressed
		jmp @@Exit
		
		
@@MovePlayer:
		call ShowMouse
		cmp [Turn],'G' ;checks the yellow press of the player which its his turn
		je @@GPMove
		
@@RPMove:
				
		call EraseRedYellows	
		call CheckRedYellowPressAndMove
		jmp @@Exit
		
		
@@GPMove:	

		call EraseGreenYellows		
		call CheckGreenYellowPressAndMove
		jmp @@Exit
		
		
@@CheckMouseMove:
	
	cmp [WallButton],0
	je @@Exit ;if the wall button is not pressed, dont do anything
	cmp [Turn],'R'
	je @@RedTurn ;if it does, check if needs to show a wall for the player whos playing his turn now
@@GreenTurn:		
	call DrawDemiWallsForGreen
	jmp @@Exit
@@RedTurn:
	call DrawDemiWallsForRed
	

	
@@Exit:
	pop ax
	pop si
	pop di
	ret
endp CheckMousePressMove




;Registers the CheckMousePress proc, so every time the left mouse button is clicked it enters it
proc RegisterMousePressMove  

push ds
pop  es	 
mov ax, seg CheckMousePressMove
mov es, ax
mov dx, offset CheckMousePressMove   ; ES:DX ->Far routine
     mov ax,0Ch             ; interrupt number
     mov cx,03h              
     int 33h                
	ret
endp RegisterMousePressMove



;UnRegisters the CheckMousePress proc, so it wont get in to it when the file is closed
proc UnRegisterMousePressMove  

push ds
pop  es	 
mov ax, seg CheckMousePressMove
mov es, ax
mov dx, offset CheckMousePressMove   ; ES:DX ->Far routine
     mov ax,0Ch             ; interrupt number
     mov cx,0h              
     int 33h                
	ret
endp UnRegisterMousePressMove


;Draws the X button
proc DrawXButton
	call HideMouse
	mov [BmpLeft],302
	mov [BmpTop],0
	mov [BmpColSize], 18
	mov [BmpRowSize] ,12
	mov dx, offset XButtonName
	call OpenShowBmp 
	call ShowMouse
	ret
endp DrawXButton


;draws the opening screen
proc DrawOpening
	call HideMouse
	mov [BmpLeft],0
	mov [BmpTop],0
	mov [BmpColSize], 320
	mov [BmpRowSize] ,200
	mov dx, offset Opening
	call OpenShowBmp 
	call ShowMouse
	ret
endp DrawOpening


;draws the "press to start in the beginning
proc printpress
        push ax
        push bx
        push dx
        mov ah, 2
        mov bh, 0
        mov dh, 15;ypos
        mov dl,5 ;xpos
        int 10h
        mov dx,offset presskey
        mov ah,9
        int 21h
        pop dx
        pop bx
        pop ax
        ret
endp printpress


;draws win massege for green player
proc printGPWon
        push ax
        push bx
        push dx
		call HideMouse
		call BlackScreen
        mov ah, 2
        mov bh, 0
        mov dh, 15;ypos
        mov dl,5 ;xpos
        int 10h
        mov dx,offset GPWon
        mov ah,9
        int 21h
		call ShowMouse
		call UnRegisterMousePressMove
		mov ah,1
		int 21h
        pop dx
        pop bx
        pop ax
        ret
endp printGPWon


;draws win massege for red player
proc printRPWon
        push ax
        push bx
        push dx
		call HideMouse
		call BlackScreen
        mov ah, 2
        mov bh, 0
        mov dh, 15;ypos
        mov dl,5 ;xpos
        int 10h
        mov dx,offset RPWon
        mov ah,9
        int 21h
		call ShowMouse
		call UnRegisterMousePressMove
		mov ah,1
		int 21h
        pop dx
        pop bx
        pop ax
        ret
endp printRPWon

proc IsGameOver
	cmp [RPPlace],16
	jbe @@GameOverR  ; check is one of the players reached the last row
	cmp [GPPlace],272
	jae @@GameOverG
@@CheckXButton: ;checks if X button pressed
	mov ax,3
		int 33h ;gets mouse position
		cmp bx,1
		jne @@Exit
		shr cx,1 ;divides cx by 2
		cmp cx,302
		ja @@CheckY
		jmp @@Exit
	@@CheckY:
		cmp dx,12
		jb @@GameOver
		jmp @@Exit
@@GameOverR:
	mov [GameOver],1
	call printRPWon
	jmp @@Exit
@@GameOverG:
	mov [GameOver],1
	call printGPWon
@@GameOver:
	mov [GameOver],1
@@Exit:
ret 
endp IsGameOver
;resets mouse
proc ResetMouse
	mov ax,0
	int 33h
	ret
endp ResetMouse


;Apearing the mouse
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
	mov cx,100
	mov dx,320
	mov di,0
	mov bx,offset BlackMatrix
	mov [matrix],bx
	call putMatrixInScreen
	mov cx,100
	mov dx,320
	mov di,32000
	mov bx,offset BlackMatrix
	mov [matrix],bx
	call putMatrixInScreen
	ret
endp BlackScreen

proc DrawBlock
	mov cx,200
	mov dx,120
	mov di,200
	mov bx,offset GrayMatrix
	mov [matrix],bx
	call putMatrixInScreen
	ret
endp DrawBlock
	



proc  SetGraphic
	mov ax,13h   ; 320 X 200 
				 ;Mode 13h is an IBM VGA BIOS mode. It is the specific standard 256-color mode 
	int 10h
	ret
endp 	SetGraphic
	
proc  SetText
	mov ax,10h   
	int 10h
	ret
endp 	SetText	
	
	
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



	
	
	
END start


