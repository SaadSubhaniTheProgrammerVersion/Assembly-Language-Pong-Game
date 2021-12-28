.model small

.data


title1 DB'        ____  ____  _      _____$'
title2 DB'       /  __\/  _ \/ \  /|/  __/$'
title3 DB'       |  \/|| / \|| |\ ||| |  _$'
title4 DB'       |  __/| \_/|| | \||| |_//$'
title5 DB'       \_/   \____/\_/  \|\____\$'


BlueWin1 DB'  ___ _           __      ___         $'         
BlueWin2 DB' | _ ) |_  _ ___  \ \    / (_)_ _  ___$'
BlueWin3 DB' | _ \ | || / -_)  \ \/\/ /| |   \(_-<$'
BlueWin4 DB' |___/_|\_,_\___|   \_/\_/ |_|_||_/__/$'

RedWin1 DB'   ___        _  __      _____         $'         
RedWin2 DB'  | _ \___ __| | \ \    / /_ _|_ _  ___$'
RedWin3 DB'  |   / -_) _` |  \ \/\/ / | ||   \(_-<$'
RedWin4 DB'  |_|_\___\__,_|   \_/\_/ |___|_||_/__/$'
                                                
                         
space1 DB '                                  $'
option1 DB'          1. Play Game            $'
option2 DB'          2. What are the controls?$'
option3 DB'          3. Exit Game             $' 

instruction1 DB'   Press q and a to move the blue paddle (left one) UP and DOWN$'
instruction2 DB'   Press i and k to move the red paddle  (right one) UP and DOWN$'
instruction3 DB'   Press esc to quit game while playing$'


Red_Lives DB 5d
Blue_Lives DB 5d;integer form of the score

Red_Lives_String DB '5$';string form of score to be printed
Blue_Lives_String DB '5$'

Ball_x DW 95h ;balls x axis
Ball_y DW 60H ;balls y axis 
Ball_size DW 05h
Ball_xvelocity DW 05h
Ball_yvelocity DW 02h

initial_Ball_xvelocity DW 05h
initial_Ball_yvelocity DW 02h;initial velocity to be saved for use

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

lea dx, title1;lea is basically moving the offset of the string to be printed in dx
mov ah, 09h;int 21h function to print string
int 21h
mov dl, 10        ;PRINTING NEW LINE
mov ah, 02h;int 21h function to print a character (new line)
int 21h 

lea dx, title2
mov ah, 09h;print string
int 21h
mov dl, 10        
mov ah, 02h;print new line char
int 21h

lea dx, title3
mov ah, 09h;print string
int 21h
mov dl, 10
mov ah, 02h;print new line char
int 21h

lea dx, title4
mov ah, 09h;print string
int 21h
mov dl, 10
mov ah, 02h;print new line character
int 21h

lea dx, title5
mov ah, 09h;print string
int 21h
mov dl, 10
mov ah, 02h;print new line character
int 21h

lea dx, space1
mov ah, 09h;print string
int 21h
mov dl, 10
mov ah, 02h;print new line character
int 21h

lea dx, space1
mov ah, 09h;print string
int 21h
mov dl, 10
mov ah, 02h;print new line character
int 21h

lea dx, space1
mov ah, 09h;print string
int 21h
mov dl, 10
mov ah, 02h;print new line character
int 21h

lea dx, option1
mov ah, 09h;print string
int 21h
mov dl, 10
mov ah, 02h
int 21h

lea dx, option2
mov ah, 09h;print string
int 21h
mov dl, 10
mov ah, 02h;print new line character
int 21h

lea dx, option3
mov ah, 09h;print string
int 21h
mov dl, 10
mov ah, 02h;print new line character
int 21h

again:
mov ah,00h
int 16h
cmp al,31h  ;ascii check for key 1
    je start;start the game

cmp al,33h ;ascii check for key 3
    jne firstskip;go to next check if not equal
        call Exit;otherwise exit
firstskip:    
cmp al,32h ;ascii check for the key 2
    jne again;notequal then take inpput again



lea dx, space1
mov ah, 09h;print string
int 21h
mov dl, 10
mov ah, 02h;print new line character
int 21h


lea dx, instruction1
mov ah, 09h;print string
int 21h
mov dl, 10
mov ah, 02h;print new line character
int 21h

lea dx, instruction2
mov ah, 09h;print string
int 21h
mov dl, 10
mov ah, 02h;print new line character
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

jmp again;after printitng instructions ask for input again




start:;lets start game
call delay
call DrawBall
call DrawPaddleRight
call DrawPaddleLeft;draw everything initially

GameLoop:;main game LOOP

    call Motion;call all procedures again and again so that the game keeps running
    call DrawBall
    call Move_left_Paddle
    call Move_right_Paddle
    call DrawPaddleLeft
    call DrawPaddleRight
    call Update_blue_lives;first update lives
    call Update_red_lives
    call Lives;then print the lives

    cmp Red_Lives,0;if at anytime lives of red becomes 0 end game and blue wins
        jg continue1
    call Blue_wins
        
continue1:

    cmp Blue_Lives,0;if at anytime lives of blue becomes 0,end game and blue wins
        jg continue2
    call Red_wins
        
continue2:;if no one currently wins then continue to next checkcs

    mov ah,01h
    int 16h
    cmp al,27d;checks for the escape key
    jne firstskip1
        call Exit;so if during runtime of game esc is pressed, then game exits
    firstskip1:
    mov ax, 0
    call clear_keyboard_buffer;clear key buffer so that keyboard can takke the next input

jmp GameLoop


MAIN ENDP

Exit proc
    mov ah, 4ch;terminates program
    int 21h
Exit endp

Motion proc
mov cx,Ball_x;column x position
mov dx,Ball_y;column y position

    add ax,Ball_xvelocity
    add bx,Ball_yvelocity
    add Ball_x,ax;add xveloxity to current x position (in order to move)
    add Ball_y,bx;add yveoctiy to crrent y postiion (in order to move)
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
    jg norestore;skip if not
     call RestoreBall;otherwise restore the ball
     call delay
     call delay
     call delay
     call delay
     dec Blue_Lives 
     
     jmp endmotion

norestore:

    mov ax,Display_width;ballx pos greater than width means out of bound right
    cmp Ball_x,ax
    jl norestore2;continue to the next check if ball is not on right bound

     call RestoreBall;if ball is at right bound then restore
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
    cmp Ball_x,ax;x position of ball same as x postion of the right paddle
    
    je next
            jmp nopaddle;paddle not found you so no collison
    next:
    cmp Ball_y,bx;top bound of right paddle
    
    jge next2
            jmp nopaddle;if less than top bound of right paddle means right paddle not found
    next2:;otherwise check next
    
    cmp Ball_y,cx;cx=Paddle_y+length i.e. lower bound
    
    jle success;if less than lower bound as well then collosion with right paddle is successful
            jmp nopaddle

    success:
            jmp Xcollide
            


nopaddle:;if right paddle not found then start checkng for left paddle
    
    mov ax,0
    mov bx,0
    mov cx,0

    mov ax,Paddle_Left_x
    add ax,Paddle_Width
    mov bx,Paddle_Left_y

    mov cx,Paddle_Left_y
    add cx,Paddle_Length
    cmp Ball_x,ax;Ball x is same as that of the paddle left x

    je next3;if yes then go to next checl
            jmp nopaddle2
    next3:
    cmp Ball_y,bx;bx has paddle left y + paddle width i.e top corner of the left paddle
    
    jge next4;if greater than top point then check for next position
            jmp nopaddle2
    next4:
    
    cmp Ball_y,cx;cx has paddle y + paddle length, i.e. lower corner of left paddle
    
    jle success2;if less then lower point then success
            jmp nopaddle2;otherwise paddle again not found

    success2:
            jmp Xcollide;success then collisio


nopaddle2:
    cmp Ball_y,00h;ball y positon less than 0 means top boundary location
    jl Ycollide

    mov ax,Display_height
    cmp Ball_y,ax
    jge Ycollide ;bally position greater than display height means ball collisin with lower bound

    ret

    Xcollide:
        NEG Ball_xvelocity;negate the x veclity and ball will be refected
        mov ax,Ball_xvelocity;mov the new veocities to registers
        mov bx,Ball_yvelocity
        dec Paddle_Length;decrese paddle lenght on every successful hit
       
        ret
    Ycollide:
        NEG Ball_yvelocity;negate y veloctiy for top and bottom bounds
        ret
    
    
    
endmotion:  
    

RET

Motion ENDP

Lives PROC;deals with printing o string lives

    mov ah,02h;set cursor position of int10h
    mov bh,00h;page number
    mov dh,04h;x pos
    mov dl,06h;y pos
    int 10h

    mov ah,09h;write strinf of int21h
    lea dx,Blue_Lives_String
    int 21h

    mov ah,02h;set cursor position of int10h
    mov bh,00h;page number
    mov dh,04h;x pos
    mov dl,1Fh;y pos
    int 10h

    mov ah,09h;write string function of int21h
    lea dx,Red_Lives_String
    int 21h

    mov ax,0
    mov bx,0
  
    ret

Lives endp

Update_red_lives proc;update string of red lives using the integer of red lives

mov ax,0
mov al,Red_Lives ;red lives is a byte or int so we need to convert it into a string and store 
;it into Red_lives_string so for that we need Ascii 
;we get Ascii value by adding 30h
add al,30h

mov [Red_Lives_String],al;string updated

ret
Update_red_lives endp

Update_blue_lives proc;upadte the blue lives string using the blue lives integer

mov ax,0
mov al,Blue_Lives ;red lives is a byte or int so we need to convert it into a string and store 
;it into Red_lives_string so for that we need Ascii 
;we get Ascii value by adding 30h
add al,30h

mov [Blue_Lives_String],al;string updated


ret
Update_blue_lives endp


RestoreBall PROC;ball out of bound then restore
mov ax,CentreX
mov bx,CentreY;ball centre positions

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

;now random position is one of the four starting positions
;1. Towards bottor right
;2. Towards top right
;3. Towards top left
;4. Towards bottom left

;direction depends upon the sign of the ball x and y velotiy which we are changing ranomly


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
    NEG ax ;negate one sign
    jmp done
r2:
    NEG bx;randomly negating the direction after restoring the ball
    jmp done
r3:
    NEG ax;negate both the signs
    NEG bx
   


done:

mov Ball_xvelocity,ax
mov Ball_yvelocity,bx;move new negated values to x and y velocity variables

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
    cmp ax,Ball_size;if cx(current) -ballx(final) is less than ball size then continue the loop otherwise break;
    jl DrawHorizontal 


    mov cx,Ball_x

    DrawVertical:
    inc dx;move to next line
    mov ax,dx
    mov bx,Ball_y
    sub ax,bx
    cmp ax,Ball_size; if ax= bx(current)-Ball_y is less than Ball size then continue to next line and go to horizontal drawing again
    ;to print lines as many times as we have size of the ball otherwise you have printed pixels successfulyy and proceeed
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
    cmp ax,Paddle_Length;if ax=bx(current y pos)-Paddle_right_y is less than Paddle length then go to horizontal again
    ;if eaqual then we have printed until the lenght of the paddle
    jl DrawHorizontal1

    mov ax,Paddle_Right_y

    cmp ax,-10d;if paddle right's y positon is less than -10d(-10 to give some room in corner)
    ;then paddle is out of boudn and restore it
    jl restorepaddle

    mov ax,Paddle_Right_y
    mov dx,Display_height
    sub dx,0Fh;paddle greater than display height means out of screen. So restore
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
    cmp ax,Paddle_Length;if ax=bx(current y pos)-Paddle_left_y is less than Paddle length then go to horizontal again
    ;if eaqual then we have printed until the lenght of the paddle
    jl DrawHorizontal2

    
      mov ax,Paddle_Left_y

    cmp ax,-10d;same conditions for restoring 
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
    
    sub bx,Paddle_speed;if q is pressed then subtract y pos with paddle speed to move it up
    mov Paddle_Left_y,bx
    call delay
    jmp skip2
    
skip1:

mov ah,01h
int 16h
cmp al,97d;checks for the a key
jne skip


    add bx,Paddle_speed;if a is pressed then add paddle speed to y postion so that it moves down
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
    mov Paddle_Right_y,bx;i key for right paddle up
    call delay
    jmp skip4
    
skip3:

mov ah,01h
int 16h
cmp al,107d;checks for the k key
jne fullskip


    add bx,Paddle_speed;k key for the right paddle down
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


;stack overflow
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
mov Paddle_Right_x,ax;move initial paddle positons to current postions and thne again print the paddle
mov Paddle_Right_y,bx

call DrawPaddleRight

mov ax,0
mov bx,0

ret
Restore_Paddle_Right endp

Restore_Paddle_Left proc

mov ax,Restore_Paddle_Left_x
mov bx,Restore_Paddle_Left_y
mov Paddle_Left_x,ax;move initial paddle positons to current postions and thne again print the paddle
mov Paddle_Left_y,bx

call DrawPaddleLeft

mov ax,0
mov bx,0

ret

Restore_Paddle_Left endp


Red_wins proc

 ;setting video mode and background again so that ball does not leave trail behind
    mov ah,00h ;video mode
    mov al,13h;256 bit color mode
    INT 10h;interrupt

    mov ah,0bh;background mode
    mov bh,00h;choose backgroud
    mov bl,00h;black color
    INT 10h

;printing the winnin screen
lea dx,RedWin1
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h

lea dx, RedWin2
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h

lea dx,RedWin3
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h

lea dx, RedWin4
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h

call Exit


ret
Red_wins endp

Blue_wins proc

;setting video mode and background again so that ball does not leave trail behind
    mov ah,00h ;video mode
    mov al,13h;256 bit color mode
    INT 10h;interrupt

    mov ah,0bh;background mode
    mov bh,00h;choose backgroud
    mov bl,00h;black color
    INT 10h


;printing the winning screen
lea dx,BlueWin1
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h

lea dx, BlueWin2
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h

lea dx,BlueWin3
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h

lea dx, BlueWin4
mov ah, 09h
int 21h
mov dl, 10
mov ah, 02h
int 21h


call Exit

ret
Blue_wins endp


END MAIN
