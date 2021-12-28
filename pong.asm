.model small

.data


; title1 DB '        __     ___           ____ $'  
; title2 DB '       |__|   |   |  |\  |  |     $'
; title3 DB '       |      |   |  | \ |  |  ___$'
; title4 DB '       |      |___|  |  \|  |____|$'

title1 DB'        ____  ____  _      _____$'
title2 DB'       /  __\/  _ \/ \  /|/  __/$'
title3 DB'       |  \/|| / \|| |\ ||| |  _$'
title4 DB'       |  __/| \_/|| | \||| |_//$'
title5 DB'       \_/   \____/\_/  \|\____\$'
                         
space1 DB '                                  $'
option1 DB'          1. Play Game            $'
option2 DB'          2. What are the controls?$'
option3 DB'          3. Exit Game             $' 

instruction1 DB'   Press q and a to move the blue paddle (left one) UP and DOWN$'
instruction2 DB'   Press i and k to move the red paddle  (right one) UP and DOWN$'
instruction3 DB'   Press esc to quit game while playing$'


Red_Lives DW 5d
Blue_Lives DW 5d

Ball_x DW 95h ;balls x axis
Ball_y DW 60H ;balls y axis 
Ball_size DW 05h
Ball_xvelocity DW 05h
Ball_yvelocity DW 02h

initial_Ball_xvelocity DW 05h
initial_Ball_yvelocity DW 02h

Paddle_Right_x DW 135h
Restore_Paddle_Right_x DW 135h
Paddle_Right_y DW 50H
Restore_Paddle_Right_y DW 50H
Paddle_Left_x DW 04h
Restore_Paddle_Left_x DW 04h
Paddle_Left_y DW 60H
Restore_Paddle_Left_y DW 60H

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

lea dx, title1
mov ah, 09h
int 21h
mov dl, 10        ;PRINTING NEW LINE
mov ah, 02h
int 21h 

lea dx, title2
mov ah, 09h
int 21h
mov dl, 10        
mov ah, 02h
int 21h

lea dx, title3
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h

lea dx, title4
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h

lea dx, title5
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h

lea dx, space1
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h

lea dx, space1
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h

lea dx, space1
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h

lea dx, option1
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h

lea dx, option2
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h

lea dx, option3
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h

again:
mov ah,00h
int 16h
cmp al,31h  ;ascii check for key 1
    je start

cmp al,33h ;ascii check for key 3
    je Exit
    
cmp al,32h ;ascii check for the key 2
    jne again



lea dx, space1
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h


lea dx, instruction1
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h

lea dx, instruction2
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h

lea dx, space1
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h

lea dx, instruction3
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h

jmp again




start:
call delay
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
call Lives


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
     call delay
     call delay
     dec Blue_Lives 
     
     jmp endmotion

norestore:

    mov ax,Display_width;ballx pos greater than width means out of bound right
    cmp Ball_x,ax
    jl norestore2

     call RestoreBall
     call delay
     call delay
     call delay
     call delay
     dec Red_Lives
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
        mov ax,Ball_xvelocity
        mov bx,Ball_yvelocity
        dec Paddle_Length
       
        ret
    Ycollide:
        NEG Ball_yvelocity
        ret
    
    
    
endmotion:  
    

RET

Motion ENDP

Lives PROC
    mov dl,5h;x point of score
    mov dh,01h;y point of score

    mov bh,00h
    mov ah,02h;codes in assembly
    int 10h

    mov ax,Blue_Lives
    call printax

    mov dl,255d;x point of score
    mov dh,00h;y point of score

    mov bh,00h
    mov ah,02h;codes in assembly
    int 10h
    mov ax,Red_Lives
    call printax

    mov ax,0
    mov bx,0
  
    ret

Lives endp


RestoreBall PROC
mov ax,CentreX
mov bx,CentreY

mov Ball_x,ax
mov Ball_y,bx


mov dx, 0
;Random number generator
mov ah, 2ch;get system time
int 21h
;i now have random value in dl

;now I have to manually divide to get the random value in the range of 4 


Divide:
sub dl,4d

cmp dl,4d
jle breakloop

Loop Divide



breakloop:

;now dl is successfully randomly between 1 and 4

mov ax,0
mov bx,0

mov ax,initial_Ball_xvelocity
mov bx,initial_Ball_yvelocity

cmp dl,1
je done

cmp dl,2
je r1

cmp dl,3
je r2

cmp dl,4
je r3

jmp done
r1:
    NEG ax 
    jmp done
r2:
    NEG bx;randomly negating the direction after restoring the ball
    jmp done
r3:
    NEG ax
    NEG bx
   


done:

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


delay proc;stack overflow
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

    mov ax,Paddle_Right_y

    cmp ax,-10d
    jl restorepaddle

    mov ax,Paddle_Right_y
    mov dx,Display_height
    sub dx,0Fh
    cmp ax,dx

    jg restorepaddle

    mov ax,0
    mov bx,0
    mov cx,0
    mov dx,0
    ret

    restorepaddle:
    call Restore_Paddle_Right
    ret


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

    
      mov ax,Paddle_Left_y

    cmp ax,-10d
    jl restorepaddle1

    mov ax,Paddle_Left_y
    mov dx,Display_height
    sub dx,0Fh
    cmp ax,dx

    jg restorepaddle1

    mov ax,0
    mov bx,0
    mov cx,0
    mov dx,0
    ret

    restorepaddle1:
    call Restore_Paddle_Left
    ret


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

Restore_Paddle_Right proc

mov ax,Restore_Paddle_Right_x
mov bx,Restore_Paddle_Right_y
mov Paddle_Right_x,ax
mov Paddle_Right_y,bx

call DrawPaddleRight

mov ax,0
mov bx,0

ret
Restore_Paddle_Right endp

Restore_Paddle_Left proc

mov ax,Restore_Paddle_Left_x
mov bx,Restore_Paddle_Left_y
mov Paddle_Left_x,ax
mov Paddle_Left_y,bx

call DrawPaddleLeft

mov ax,0
mov bx,0

ret

Restore_Paddle_Left endp

printax proc
    mov cx, 0
    mov bx, 10
@@loophere:
    mov dx, 0
    div bx                         
    push ax
    add dl, '0'                    
    pop ax                         
    push dx                        
    inc cx                         
    cmp ax, 0                      
jnz @@loophere
    mov ah, 2                     
@@loophere2:
    pop dx                         
    int 21h                        
    loop @@loophere2
    ret
printax endp

END MAIN
