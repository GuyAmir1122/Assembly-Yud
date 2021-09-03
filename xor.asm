IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------

msg db 'I am Guy$'
;key - 11010101

CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------

;Encryption
xor [msg], 11010101
xor [msg + 1],11010101
xor [msg + 2],11010101
xor [msg + 3],11010101
xor [msg + 4],11010101
xor [msg + 5],11010101
xor [msg + 6],11010101
xor [msg + 7],11010101
xor [msg + 8],11010101

; print msg
mov	dx, offset msg
mov	ah, 9h
int	21h
mov	ah, 2	
; new line
mov	dl, 10	
int	21h	
mov	dl, 13
int	21h

;deciphering
xor [msg],11010101
xor [msg + 1],11010101
xor [msg + 2],11010101
xor [msg + 3],11010101
xor [msg + 4],11010101
xor [msg + 5],11010101
xor [msg + 6],11010101
xor [msg + 7],11010101
xor [msg + 8],11010101

; print msg
mov	dx, offset msg
mov	ah, 9h
int	21h
mov	ah, 2	
; new line
mov	dl, 10	
int	21h	
mov	dl, 13
int	21h


exit:
	mov ax, 4c00h
	int 21h
END start


