 [ORG 0x7C00]
    mov ah, 0x02
    mov al, 0x01
    mov ch, 0x00
    mov cl, 0x02
    mov dh, 0x01
    mov es, [EXTENSION]
    mov bx, 0x00
    int 13h
    jmp PRINT
	 
MSG: db  'Welcome to my OS',0xa,13,10,0x00

times 510-($-$$) db 0
db 0x55
db 0xAA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EXTENSION:
mov ah, 0x00; Contains the type of function
	mov al, 0x13
	int 0x10
;     PARAMETERS
    mov al, 0x01 ; The pixel color
	mov bh, 0x00 ; The page number 
	mov cx, 0x00 ; X Position
	mov dx, 0x00 ; Y Position

	
LOOP:
    mov ah, 0x0C
	int 0x10 ; Video function
	je RESETCOLLOR
	inc cx ; Advance to the right pixel
	cmp cx, 0x0140 ; Checks if it is 320
	jne LOOP ;  Continued if not 320
	mov cx, 0x00 ; Returns to position 0 of the X axis
	inc dx ;  Advance to the next line
	cmp dx, 0xC8 ; Checks if it reached the last line 
	jne LOOP 
	mov dx, 0x00  ; Back to the first line
	inc al ; Jump to the next color 
	cmp al, 0xFF ; Check if it is the last color
	je RESETCOLLOR
	jmp LOOP
RESETCOLLOR:
    mov al, 0x00 ; Collor reset
    jmp LOOP
PRINT:
    xor ax, ax    ; Reset acumulator
	mov ds, ax
	mov si, MSG
CHAR_PRINT: lodsb
    or al, al ; Checks if the value is 0
	jz WAITNG  ; Loop until you turn off the computer
	mov ah, 0x0E 
	int 0x10
	jmp CHAR_PRINT ; Jump to the next character
WAITNG:
    jmp WAITNG
