IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------

CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
mov si,1412h
mov di, 2503h
mov ax, si
mov si, di
mov di, ax
mov dl, -120d
mov bp, -5d
mov dh, 'B'
mov cl, 64h
mov ch, 1100100b
;mov bx, 300
;mov ax, bl
; si = 2503h, di = 1412h, ax = לא יעבוד,  dl = -120 , bp = -5, dh = B, cl = 64h , ch = 64h, bl = לא יעבוד
;mov ip,2
mov ax,100
mov es,ax
 


exit:
	mov ax, 4c00h
	int 21h
END start


