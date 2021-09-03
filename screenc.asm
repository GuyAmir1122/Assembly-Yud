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
mov ax, 0B800h
mov es,ax
mov di,0
mov ah,00000000
mov al,' '
mov cx,2000
erase:

mov [es:di] ,ax  
add di,2

loop erase

mov ax, 0B800h
mov es,ax
mov ah,10000001b
mov al,'G'
mov di,1996
mov [es:di],ax
mov ah,10000010b
mov al,'u'
mov di,1998
mov [es:di],ax
mov ah,10000101b
mov al,'y'
mov di,2000
mov [es:di],ax
mov ah,00011001b
mov al, 'I'
mov di,3810
mov [es:di],ax
mov ah,00011001b
mov al, 'm'
mov di,3812
mov [es:di],ax
mov ah,00011001b
mov al, ' '
mov di,3814
mov [es:di],ax
mov ah,00011001b
mov al, 'u'
mov di,3816
mov [es:di],ax
mov ah,00011001b
mov al, 's'
mov di,3818
mov [es:di],ax
mov ah,00011001b
mov al, 'i'
mov di,3820
mov [es:di],ax
mov ah,00011001b
mov al, 'n'
mov di,3822
mov [es:di],ax
mov ah,00011001b
mov al, 'g'
mov di,3824
mov [es:di],ax
mov ah,00011001b
mov al, ' '
mov di,3826
mov [es:di],ax
mov ah,00011001b
mov al, 'B'
mov di,3828
mov [es:di],ax
mov ah,00011001b
mov al, '8'
mov di,3830
mov [es:di],ax
mov ah,00011001b
mov al, '0'
mov di,3832
mov [es:di],ax
mov ah,00011001b
mov al, '0'
mov di,3834
mov [es:di],ax
mov ah,00100100b
mov al,'A'
mov di,3690
mov [es:di],ax
mov ah,00100100b
mov al,'t'
mov di,3692
mov [es:di],ax
mov ah,00100100b
mov al,'t'
mov di,3694
mov [es:di],ax
mov ah,00100100b
mov al,'a'
mov di,3696
mov [es:di],ax
mov ah,00100100b
mov al,'c'
mov di,3698
mov [es:di],ax
mov ah,00100100b
mov al,'k'
mov di,3700
mov [es:di],ax
exit:
	mov ax, 4c00h
	int 21h
END start


