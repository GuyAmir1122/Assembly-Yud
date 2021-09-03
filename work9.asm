IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
FirstName db "John"

LastName db "Averbooh"

myArray db 100 dup('B')
CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
mov al,[FirstName]

mov ah,[LastName + 2 ]

mov bx , offset LastName
; value of al will be - 4Ah = J
; value of ah will be - 65h = e
; value of bx will be - 0004h = offset of LastName
exit:
	mov ax, 4c00h
	int 21h
END start


