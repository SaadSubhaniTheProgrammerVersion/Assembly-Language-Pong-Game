.model small

.data
Ball_x DW 95h ;balls x axis
Ball_y DW 60H ;balls y axis 
Ball_size DW 05h
Ball_xvelocity DW 05h
Ball_yvelocity DW 02h

initial_Ball_xvelocity DW 05h
initial_Ball_yvelocity DW 02h

Paddle_Right_x DW 135h
Paddle_Right_y DW 50H
Paddle_Left_x DW 04h
Paddle_Left_y DW 60H

Paddle_speed DW 0Fh

Paddle_Width DW 05h
Paddle_Length DW 28h
Restore_Paddle_Length DW 28h

CentreX DW 95h
CentreY DW 60H

Display_width DW 13Ah ;320px
Display_height DW 0C6h ;200px
.code
MAIN PROC
mov ax, @data
mov ds, ax 

    mov ah,00h ;video mode
    mov al,13h;256 bit color mode
    INT 10h;interrupt

    mov ah,0bh;background mode
    mov bh,00h;choose backgroud
    mov bl,00h;black color
    INT 10h


call DrawBall
call DrawPaddleRight
call DrawPaddleLeft
L1:

call Motion
call DrawBall
call Move_left_Paddle
call Move_right_Paddle
call DrawPaddleLeft
call DrawPaddleRight


mov ah,01h
int 16h
cmp al,27d;checks for the escape key
je Exit
mov ax, 0
call clear_keyboard_buffer

jmp L1



Exit:
    mov ah, 4ch;terminates program
    int 21h

MAIN ENDP

Motion proc
mov cx,Ball_x;column x position
mov dx,Ball_y;column y position

    add ax,Ball_xvelocity
    add bx,Ball_yvelocity
    add Ball_x,ax
    add Ball_y,bx
    call delay

    ;setting video mode and background again so that ball does not leave trail behind
    mov ah,00h ;video mode
    mov al,13h;256 bit color mode
    INT 10h;interrupt

    mov ah,0bh;background mode
    mov bh,00h;choose backgroud
    mov bl,00h;black color
    INT 10h
 

    cmp Ball_x,00h;ball x position is less than 0 it means out of bound left side
    jg norestore
     call RestoreBall
     call delay
     call delay
     jmp endmotion

norestore:

    mov ax,Display_width;ballx pos greater than width means out of bound right
    cmp Ball_x,ax
    jl norestore2

     call RestoreBall
     call delay
     call delay
     jmp endmotion

norestore2:


   
    mov ax,0
    mov ax,Paddle_Right_x
    mov bx,Paddle_Right_y

    mov cx,Paddle_Right_y
    add cx,Paddle_Length
    cmp Ball_x,ax
    
    je next
            jmp nopaddle
    next:
    cmp Ball_y,bx
    
    jge next2
            jmp nopaddle
    next2:
    
    cmp Ball_y,cx
    
    jle success
            jmp nopaddle

    success:
            jmp Xcollide


nopaddle:
    
    mov ax,0
    mov bx,0
    mov cx,0

    mov ax,Paddle_Left_x
    add ax,Paddle_Width
    mov bx,Paddle_Left_y

    mov cx,Paddle_Left_y
    add cx,Paddle_Length
    cmp Ball_x,ax

    je next3
            jmp nopaddle2
    next3:
    cmp Ball_y,bx
    
    jge next4
            jmp nopaddle2
    next4:
    
    cmp Ball_y,cx
    
    jle success2
            jmp nopaddle2

    success2:
            jmp Xcollide


nopaddle2:
    cmp Ball_y,00h;ball y positon less than 0 means top boundary location
    jl Ycollide

    mov ax,Display_height
    cmp Ball_y,ax
    jge Ycollide ;bally position greater than display height means ball collisin with lower bound

    ret

    Xcollide:
        NEG Ball_xvelocity
        dec Paddle_Length
       
        ret
    Ycollide:
        NEG Ball_yvelocity
        ret
    
    
    
endmotion:  
    

RET

Motion ENDP


RestoreBall PROC
mov ax,CentreX
mov bx,CentreY

mov Ball_x,ax
mov Ball_y,bx

mov ax,initial_Ball_xvelocity
mov bx,initial_Ball_yvelocity

mov Ball_xvelocity,ax
mov Ball_yvelocity,bx

mov ax,Restore_Paddle_Length
mov Paddle_Length,ax

mov ax,0
mov bx,0



ret
RestoreBall endp

DrawBall proc
    
    mov cx,Ball_x;column x position
    mov dx,Ball_y;column y position
    
    DrawHorizontal:
    mov ah,0ch ;set the config to write a pixel
    mov al,02h ;choose green pixel
    mov bh,00h;set page number
    INT 10h
    INC cx

    mov bx,Ball_x
    mov ax,cx
    sub ax,bx
    cmp ax,Ball_size;if cx-ballx is less than ball size then continue the loop otherwise break;
    jl DrawHorizontal 


    mov cx,Ball_x

    DrawVertical:
    inc dx;move to next line
    mov ax,dx
    mov bx,Ball_y
    sub ax,bx
    cmp ax,Ball_size
    jl DrawHorizontal

    mov ax,0
    mov bx,0
    mov cx,0

ret
DrawBall endp


delay proc
mov ah, 86h
mov dx, 0
mov cx, 1
int 15h
ret
delay endp

DrawPaddleRight proc

mov cx,Paddle_Right_x;column x position
    mov dx,Paddle_Right_y;column y position
    
    DrawHorizontal1:
    mov ah,0ch ;set the config to write a pixel
    mov al,04h ;choose red pixel
    mov bh,00h;set page number
    INT 10h
    INC cx

    mov bx,Paddle_Right_x
    mov ax,cx
    sub ax,bx
    cmp ax,Paddle_Width;if cx-paddlex is less than paddle width then continue the loop otherwise break;
    jl DrawHorizontal1


    mov cx,Paddle_Right_x

    DrawVertical1:
    inc dx;move to next line
    mov ax,dx
    mov bx,Paddle_Right_y
    sub ax,bx
    cmp ax,Paddle_Length
    jl DrawHorizontal1

    mov ax,0
    mov bx,0
    mov cx,0


RET
DrawPaddleRight Endp


DrawPaddleLeft proc

    mov cx,Paddle_Left_x;column x position
    mov dx,Paddle_Left_y;column y position
    
    DrawHorizontal2:
    mov ah,0ch ;set the config to write a pixel
    mov al,01h ;choose red pixel
    mov bh,00h;set page number
    INT 10h
    INC cx

    mov bx,Paddle_Left_x
    mov ax,cx
    sub ax,bx
    cmp ax,Paddle_Width;if cx-paddlex is less than paddle width then continue the loop otherwise break;
    jl DrawHorizontal2


    mov cx,Paddle_Left_x

    DrawVertical2:
    inc dx;move to next line
    mov ax,dx
    mov bx,Paddle_Left_y
    sub ax,bx
    cmp ax,Paddle_Length
    jl DrawHorizontal2

    mov ax,0
    mov bx,0
    mov cx,0


RET
DrawPaddleLeft Endp


Move_left_Paddle proc
    mov ax,Paddle_Left_x
    mov bx,Paddle_Left_y

mov ah,01h
int 16h
cmp al,113d;checks for the q key
jne skip1
    
    sub bx,Paddle_speed
    mov Paddle_Left_y,bx
    call delay
    jmp skip2
    
skip1:

mov ah,01h
int 16h
cmp al,97d;checks for the a key
jne skip


    add bx,Paddle_speed
    mov Paddle_Left_y,bx
    call delay


skip2:    

     ;setting video mode and background again so that ball does not leave trail behind
    mov ah,00h ;video mode
    mov al,13h;256 bit color mode
    INT 10h;interrupt

    mov ah,0bh;background mode
    mov bh,00h;choose backgroud
    mov bl,00h;black color
    INT 10h


skip:

ret
Move_left_Paddle endp

Move_right_Paddle proc
    mov ax,Paddle_Right_x
    mov bx,Paddle_Right_y

mov ah,01h
int 16h
cmp al,105d;checks for the i key
jne skip3
    
    sub bx,Paddle_speed
    mov Paddle_Right_y,bx
    call delay
    jmp skip4
    
skip3:

mov ah,01h
int 16h
cmp al,107d;checks for the k key
jne fullskip


    add bx,Paddle_speed
    mov Paddle_Right_y,bx
    call delay


skip4:    

     ;setting video mode and background again so that ball does not leave trail behind
    mov ah,00h ;video mode
    mov al,13h;256 bit color mode
    INT 10h;interrupt

    mov ah,0bh;background mode
    mov bh,00h;choose backgroud
    mov bl,00h;black color
    INT 10h


fullskip:

ret
Move_right_Paddle endp

clear_keyboard_buffer proc
push ax
push es
mov ax, 0000h
mov es, ax
mov es:[041ah], 041eh
mov es:[041ch], 041eh
pop es
pop ax
ret
clear_keyboard_buffer endp

END MAIN
