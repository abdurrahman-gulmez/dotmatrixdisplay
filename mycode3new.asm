
data segment 
    
; writing text to bios interrupt to get input     
  
str1 db "Enter string: $"

Arr db dup('$') ; define an array to store the input

; the matrix display of the letters
Dots:	
    DB	01111110b, 00010001b, 00010001b, 00010001b, 01111110b  ; A
	DB	01111111b, 01001001b, 01001001b, 01001001b, 00110110b  ; B
	DB	00111110b, 01000001b, 01000001b, 01000001b, 00100010b  ; C
	DB	01111111b, 01000001b, 01000001b, 00100010b, 00011100b  ; D
	DB	01111111b, 01001001b, 01001001b, 01001001b, 01000001b  ; E
	DB	01111111b, 00001001b, 00001001b, 00001001b, 00000001b  ; F
	DB	00111110b, 01000001b, 01001001b, 01001001b, 01111010b  ; G
	DB	01111111b, 00001000b, 00001000b, 00001000b, 01111111b  ; H
	DB  00000000b, 00000000b, 01111111b, 00000000b, 00000000b  ; I
    DB  00100000b, 01000000b, 01000000b, 01000000b, 00111111b  ; J
    DB  01111111b, 00001000b, 00010100b, 00100010b, 01000001b  ; K 
    DB  01111111b, 01000000b, 01000000b, 01000000b, 01000000b  ; L
    DB  01111111b, 00000010b, 00000100b, 00000010b, 01111111b  ; M
    DB  01111111b, 00000010b, 00001000b, 00100000b, 01111111b  ; N 
    DB  00111110b, 01000001b, 01000001b, 01000001b, 00111110b  ; O
    DB  01111111b, 00001001b, 00001001b, 00001001b, 00000110b  ; P
    DB  00111110b, 01000001b, 01000001b, 01100001b, 01111110b  ; Q     
    DB  01111111b, 00001001b, 00001001b, 00001001b, 01110110b  ; R
    DB  00100110b, 01001001b, 01001001b, 01001001b, 00110010b  ; S
    DB  00000001b, 00000001b, 01111111b, 00000001b, 00000001b  ; T
    DB  00111111b, 01000000b, 01000000b, 01000000b, 00111111b  ; U
    DB  00011111b, 00100000b, 01000000b, 00100000b, 00011111b  ; V
    DB  01111111b, 00100000b, 00010000b, 00100000b, 01111111b  ; W 
    DB  01100011b, 00010100b, 00001000b, 00010100b, 01100011b  ; X 
    DB  00000001b, 00000010b, 01111100b, 00000010b, 00000001b  ; Y 
    DB  01100001b, 01010001b, 01001001b, 01000101b, 01000011b  ; Z
ends

stack segment 
    dw 100h dup('$') ; allocate memory from stack of size of 100h
    
ends

; starting codes 
code segment
start proc far:
    
       
; basic definitions
mov ax, @data ; taking address of data segment 
MOV ES, AX
mov ds, ax  

;

lea dx, str1 ; assign offset adress of the str1
; writing text of str1 to bios interrupt
mov ah, 09h
int 21h

mov ah, 10  
lea dx, Arr ; assign offset adress of Arr to dx register
mov Arr, 8
int 21h


; setting cx for loop         
mov ch, 0          
mov cl, Arr[1]  ; assign the length of the input to cl
 
mov si, 2 ; starting index of the input
mov ah, 02h


MOV DX,2000h; first DOT MATRIX digit adress

      
output:
         
          
PUSH DX ; pushing dx to stack 
PUSH CX ; pushing cx to stack

mov dl, Arr[si] ; searching the elements of the input

inc si ; skipping the next element of the input 


; setting place of the index for each element      
mov al, dl  
add al, -61h 
                       
MOV BX, 0            

MOV ch,0
FINDINDEX:
	INC ch
	ADD BX, 5
	CMP ch, al
	JLE FINDINDEX
 
ADD BX, -5h  

POP CX  ; popping cx from stack
POP DX  ; popping dx from stack    


PUSH AX ; pushing ax to stack
PUSH SI ; pushing si to stack


MOV SI, 0
mov ax, 0   

; writing elements of the input to emulation kit
NEXT:
	MOV al,Dots[BX][SI]
	out dx,al
	INC SI
	INC DX

	CMP SI, 5 
	JNE NEXT

POP SI ; popping si from stack
POP AX ; popping si from stack        
          
loop output

MOV AX, 4c00h
int 21h 
 

start endp

ends

end start