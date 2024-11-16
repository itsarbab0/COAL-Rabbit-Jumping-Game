;proj5
; implementing 3rd phase
;proj6 ; making the rabbit stick to the bottom brick
;proj7 moving lower brick down and out of screen
;proj8 adding new platform, reducing size of rabbit and platforms
;proj10, proj8+ random color, carrot, blue brick



[org 0x0100]

MOV AX,0013H
INT 10H 
 
; ;320px wide, 200px tall, 1 byte per pixel. 
; mov ax, 79 ; color palette 
; MOV BX,0A000H ;
; MOV ES,BX ; ES set to start of VGA
; MOV BX,32000 ; BX set to pixel offset 0
; MOV CX, 6400

 
 
  ; mov dl, 'Y'
; mov ah, 6h
; int 21h

 jmp start
 

 exit:
 
 mov ax, 0x4c00
 int 0x21

 
 
  
 

movscrn2:
  push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 push dx
 
 
 call PRINT_THIRD
 
 
 
mov ax,[platform3index]
cmp ax, [platform3rightbound]
jae platform3left
cmp ax, [platform3leftbound]
jbe platform3right

platform3here:
mov ax, [platform3directionflag]
cmp ax, 0
je moveplatform3left
jmp moveplatform3right

printplatform3:

mov bx, [jumpflag]
cmp bx, 0
jne MOVE_PLATFORM3
mov ax, [platform3index]
jmp DONT_MOVE_PLATFORM3

PLATFORM3_COMPLETE:

jmp DONT_MOVE_PLATFORM3


MOVE_PLATFORM3:
mov ax, [platform3index]
cmp ax, [platformoriginalindex]
je PLATFORM3_COMPLETE
add ax, 1600
mov [platform3index], AX
mov ax, [platform3rightbound]
add ax, 1600
mov [platform3rightbound], ax
mov ax, [platform3leftbound]
add ax, 1600
mov [platform3leftbound], ax
jmp DONT_MOVE_PLATFORM3

DONT_MOVE_PLATFORM3:
mov ax, [platform3color]
push ax
mov ax,[platform3index]
push AX
call DRAW_PLATFORM


 ;for lower platform --- platform1
 mov ax, [platformindex]
 mov bx, [platformrightbound]
 cmp ax, bx
jae platformleft
mov bx, [platformleftbound]
 cmp ax, bx
jbe platformright

platformhere:
mov ax, [platformdirectionflag]
cmp ax, 0
je moveplatformleft
jmp moveplatformright
printplatform:

 mov bx, [jumpflag]
 cmp bx, 0
 jne MOVE_LOWER_PLATFORM ; 1 means jump
mov ax, [platformindex]
jmp DONT_MOVE_PLATFORM


MOVE_LOWER_PLATFORM:
mov bx, [lowerflag]
cmp bx, 1
je DONT_MOVE_PLATFORM ; if lower part animation is complete, jump
mov dx, [lowerprogress]
cmp dx, 1
je LOWER_COMPLETE
mov bx, [platformindex]
add bx, 1600
mov [platformindex], bx
mov bx, [platformrightbound]
add bx, 1600
mov [platformrightbound], bx
mov bx, [platformleftbound]
add bx, 1600
mov [platformleftbound], bx
inc dx
mov [lowerprogress], dx
mov ax, [platformindex]
jmp DONT_MOVE_PLATFORM







MOVE_PLATFORM: ; for jump effect for uppper platform platform 2
 mov dx, [jumpprogress]
 cmp dx, 5
; mov ax, [platform2index]
; cmp ax, [platform3originalindex]
je JUMP_COMPLETE
mov bx, [platform2index]
add bx, 1600
mov [platform2index], bx
mov bx, [platform2rightbound]
add bx, 1600
mov [platform2rightbound], bx
mov bx, [platform2leftbound]
add bx, 1600
mov [platform2leftbound], bx
inc dx
mov [jumpprogress], dx
jmp DONT_MOVE_PLATFORM2


LOWER_COMPLETE:
mov dx, 0
mov [lowerprogress], dx
mov byte [lowerflag],0
mov bx, 61300
mov [platformrightbound], BX
mov bx, 61180
mov [platformleftbound], bx


jmp DONT_MOVE_PLATFORM




JUMP_COMPLETE:

call CHECK_LANDING
mov word[bluetime], 0
mov word[prevbluetime], 0
mov dx, 0
mov [jumpprogress], dx
mov [jumpflag], dx
mov bx,[platform3index]
add bx, 1280 
mov [platformindex], bx
mov [platform3index], bx
mov bx, 50300
mov [platform3leftbound], BX
mov bx, 50420
mov [platform3rightbound], BX
mov bx, [platform2index]
;add bx,  320
mov [platform3index], BX
mov bx, 61300
mov [platformrightbound], bx
mov bx, 61180
mov [platformleftbound], bx
;random function here for random index of new platform on top, platform2
call getrandomindex ; getrandom index puts a random index for platform2 in prn
;mov dx, 42360
mov dx, [randomindex]
mov [platform2index], dx


mov bx, 42420
mov [platform2rightbound], bx
mov bx, 42300
mov [platform2leftbound], BX

mov bx, [platform3color]
mov [platformcolor], bx
cmp bx, 11 ;blue color
jz blueplatform
jnz notblue
blueplatform:
mov word[blueplatformflag], 1 ; landed on a blue platform
notblue:
mov word [blueplatformflag], 0
mov bx, [platform2color]
mov [platform3color], bx
call getrandomcolor
mov bx, [randomcolor]
mov [platform2color], bx
mov bx, [platform3directionflag]
mov [platformdirectionflag], bx
mov [rabbitdirectionflag], bx
mov bx, [platform2directionflag]
mov [platform3directionflag], BX
add bx, 0
jz makeitone
mov bx, 0
mov [platform2directionflag], bx




jmp DONT_MOVE_PLATFORM2

makeitone:
mov bx, 1
mov [platform2directionflag], bx
jmp DONT_MOVE_PLATFORM2




DONT_MOVE_PLATFORM:
mov ax, [platformcolor]
push ax
mov ax, [platformindex]
push ax
call DRAW_PLATFORM
 
 
 
 
; for upper platform-- platform2

mov ax, [platform2index]
mov bx, [platform2rightbound]
cmp ax, bx
jae platform2left
mov bx, [platform2leftbound]
cmp ax, bx
jbe platform2right
platform2here:
mov ax, [platform2directionflag]
cmp ax, 0
je moveplatform2left
jmp moveplatform2right
printplatform2:

 mov bx, [jumpflag]
 cmp bx, 0
 jne MOVE_PLATFORM
 
 
 
 DONT_MOVE_PLATFORM2:
mov ax, [platform2color]
push ax
mov ax, [platform2index]
push ax
call DRAW_PLATFORM
 
 
 
 
 
 
 
 ;for rabbit
 
 
 mov ax, [jumpflag]
 cmp ax, 0
 jne printrabbit
mov ax, [platformindex]
mov bx, [platformrightbound]
cmp ax, bx
;cmp ax, 49460
je rabbitleft
;cmp ax, 49380
mov bx, [platformleftbound]
cmp ax, BX
je rabbitright
rabbithere:
mov ax, [rabbitdirectionflag]
cmp ax, 0
je moverabbitleft
jmp moverabbitright
printrabbit:

 call DRAW_RABBIT
 call DRAW_CARROT
 call CHECK_EAT
 call CHECK_BLUE_PLATFORM
 
 
 
 pop dx
 pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 
 
 
 CHECK_BLUE_PLATFORM:
 push AX
 push BX
 
 
 mov ax, [cs:bluetime]
 mov bx, [cs:prevbluetime]
 sub ax, BX
 cmp ax, 72
 jae timepassed
 jmp timenotpassed
 
 timepassed:
 jmp exit
 

 
 timenotpassed:
 
 pop BX
 pop AX
 ret
 
 
 
 
timer:

push ax

mov ax, [cs:platformcolor]
cmp ax, 11
je platformisblue
jmp platformisnotblue
platformisblue:
inc word [cs:bluetime]; increment tick count
call CHECK_BLUE_PLATFORM ; print tick count
jmp blueplatformhere

platformisnotblue:
mov word[cs:bluetime], 0
mov word [cs:prevbluetime], 0
blueplatformhere:
mov al, 0x20
out 0x20, al ; end of interrupt

pop AX
jmp far [cs:oldisr]




 
 
 CHECK_EAT:
 ;54616C68612041686D65642041776169732041616D6972
 push AX
 push BX
 
 mov ax, [rabbitindex]
 mov bx, [carrotindex]
 cmp bx, ax
 jb notdoneeat
 add ax, 15
 cmp bx, AX
 ja notdoneeat
 
 
 
 doneeat:
 mov word[carrotflag], 0
 
 notdoneeat:
 
 pop BX
 pop AX
 
 
 
 
 DRAW_CARROT:
 ;getting a random value from 0-50 if the value is 5 then we print carrot
  push AX
 push dx
 push cx
 push di
 
 
 mov ax, [carrotflag]
 cmp ax, 1
 je printcarrot
 
 MOV     AH, 00h   ; interrupt to get system timer in CX:DX 
INT     1AH
mov     [PRN], dx
call    CalcNew   ; -> AX is a random number
xor     dx, dx
mov     cx, 100
div     cx        ; here dx contains the remainder - from 0 to 9
 
 cmp dx, 3
 jne dontprintcarrot
 mov word[carrotflag], 1
  call getrandomcarrot

 
 
 
 printcarrot:

 mov di, [carrotindex]
 mov al, 4
 mov cx, 5
rep stosb
add di, 316
mov cx, 3
rep stosb
add di, 318
mov cx, 1
rep stosb 

 
 
 
 ;call    CalcNew 
 
 dontprintcarrot:

pop di
pop cx
pop dx
pop AX

ret



 getrandomcarrot:
 push AX
 push dx
 push cx
 
 MOV     AH, 00h   ; interrupt to get system timer in CX:DX 
INT     1AH
mov     [PRN], dx
call    CalcNew   ; -> AX is a random number
xor     dx, dx
mov     cx, 70
div     cx        ; here dx contains the remainder - from 0 to 9
add dx, 53440+140
;add     dl, '0'   ; to ascii from '0' to '9'
; mov     ah, 02h   ; call interrupt to display a value in DL
; int     21h    
mov [carrotindex], dx
call    CalcNew   ; -> AX is another random number

pop cx
pop dx
pop AX

ret
 
 
 
 
 
getrandomindex:
push AX
push dx
push cx
 
 MOV     AH, 00h   ; interrupt to get system timer in CX:DX 
INT     1AH
mov     [PRN], dx
call    CalcNew   ; -> AX is a random number
xor     dx, dx
mov     cx, 120
div     cx        ; here dx contains the remainder - from 0 to 9
add dx, 42300
;add     dl, '0'   ; to ascii from '0' to '9'
; mov     ah, 02h   ; call interrupt to display a value in DL
; int     21h    
mov [randomindex], dx
call    CalcNew   ; -> AX is another random number

pop cx
pop dx
pop AX

ret

; ----------------
; inputs: none  (modifies PRN seed variable)
; clobbers: DX.  returns: AX = next random number
CalcNew:
    mov     ax, 25173          ; LCG Multiplier
    mul     word  [PRN]     ; DX:AX = LCG multiplier * seed
    add     ax, 13849          ; Add LCG increment value
    ; Modulo 65536, AX = (multiplier*seed+increment) mod 65536
    mov     [PRN], ax          ; Update seed = return value
    ret
	
	
	
	 getrandomcolor:
 push AX
 push dx
 push cx
 
 MOV     AH, 00h   ; interrupt to get system timer in CX:DX 
INT     1AH
mov     [PRN], dx
call    CalcNew1   ; -> AX is a random number
xor     dx, dx
mov     cx, 4
div     cx        ; here dx contains the remainder - from 0 to 9
  
cmp dx, 0
je color1
cmp dx, 1
je color2
cmp dx, 2
je color3
cmp dx, 3
je color4

randomclrback:
call    CalcNew1   ; -> AX is another random number

pop cx
pop dx
pop AX

ret
color1:
mov ax, 14
mov [randomcolor], ax
jmp randomclrback
color2:
mov ax, 12
mov [randomcolor], ax
jmp randomclrback
color3:
mov ax, 13
mov [randomcolor], ax
jmp randomclrback
color4:
mov ax, 11
mov [randomcolor], ax
jmp randomclrback


; ----------------
; inputs: none  (modifies PRN seed variable)
; clobbers: DX.  returns: AX = next random number
CalcNew1:
    mov     ax, 25173          ; LCG Multiplier
    mul     word  [PRN]     ; DX:AX = LCG multiplier * seed
    add     ax, 13849          ; Add LCG increment value
    ; Modulo 65536, AX = (multiplier*seed+increment) mod 65536
    mov     [PRN], ax          ; Update seed = return value
    ret
	
	
	
	
	
	
 
 CHECK_LANDING:
 
push bp
mov bp, sp
push AX
push BX
push DI

mov ax, 0A000H
mov es, ax
cld

mov bx, [rabbitindex]
add bx, 6400 ;  takes to foot of rabbit






mov ax, [platform3index]
sub ax, 10
cmp bx, ax
jb exit
mov ax, [platform3index]
add ax, [platformlength]
cmp bx, ax
ja exit


mov ax, [platformspeed]
inc AX
mov [platformspeed], ax
jmp CHECK_LANDING_return



CHECK_LANDING_return:


pop DI
pop BX
pop AX
pop bp
ret




 
 
 movscrn:
 
  push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 push dx
 push ds
 
 
 mov ax, 0A000H
 mov es, AX
 mov ds, ax
 
 
 ;2nd part move left

 mov cx, 5
 cld
 mov si, 17921
 mov di, 17920
 
 infloop1:
 push cx
 
 mov cx, 319
 mov al, [es:di]

rep movsb

mov [es:di], Al
inc SI
inc di

pop cx

loop infloop1

 mov cx, 3
 cld
 mov si, 28481
 mov di, 28480
 
 infloop2:
 push cx
 
 mov cx, 319
 mov al, [es:di]

rep movsb

mov [es:di], Al
inc SI
inc di

pop cx

loop infloop2


 mov cx, 5
 cld
 mov si, 38721
 mov di, 38720
 
 infloop3:
 push cx
 
 mov cx, 319
 mov al, [es:di]

rep movsb

mov [es:di], Al
inc SI
inc di

pop cx

loop infloop3



;first part move screen right
mov si, 318
mov di, 319
std
mov al, 4



mov cx, 56
movouterloop:
push cx

mov al, [es:di]

mov cx, 319


rep movsb


mov [es:di], al
add si, 639
add di, 639

pop cx
loop movouterloop




 ; CALL DRAW_RABBIT
cld
 pop ds
 pop dx
 pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 
 

 ;jump function - this function checks if key is pressed and if its up key, if yes then it scrolls up 
 JUMP_BUNNY:
 
 push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 push dx
 push ds
 
 mov ah, 01h
 int 16h
 jz EXIT_JUMP_BUNNY
 
 mov ah, 00h
 int 16h
 
 CMP AL, 77h
 JNE EXIT_JUMP_BUNNY
 
 W_PRESSED: ; w key is pressed
 ;jmp exit
 mov ax, 1
 mov [jumpflag], AX
 

 
 EXIT_JUMP_BUNNY:
 pop ds
 pop dx
 pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 
 
 
 
 

 
 
 
 
 delay:
 
 push bp
 push CX
 push AX
 
 mov cx, 1000
 
 delayloop:
  mov ax, 1
  loop delayloop
 
 pop AX
 pop CX
 pop bp
 ret
 
 
 
 
 printscrn:
 
 

 
  push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 
 
 
  
 
  call sky
 
 mov ax, 28 ;color bp+8
 push AX
 mov ax, 0 ; base offset - bp+6
 push AX
 mov ax, 40 ; size in pixel - bp+4
 push ax
 
 call mountain
 
 mov ax, 27 ;color bp+8
 push AX
 mov ax, 50; base offset - bp+6
 push AX
 mov ax, 50 ; size in pixel - bp+4
 push ax
 call mountain
 
  mov ax, 28 ;color bp+8
 push AX
 mov ax, 100; base offset - bp+6
 push AX
 mov ax, 45 ; size in pixel - bp+4
 push ax
 call mountain
 
  mov ax, 27 ;color bp+8
 push AX
 mov ax, 150; base offset - bp+6
 push AX
 mov ax, 30 ; size in pixel - bp+4
 push ax
 call mountain
 
  mov ax, 28 ;color bp+8
 push AX
 mov ax, 200; base offset - bp+6
 push AX
 mov ax, 42 ; size in pixel - bp+4
 push ax
 call mountain
 
  mov ax, 27 ;color bp+8
 push AX
 mov ax, 250; base offset - bp+6
 push AX
 mov ax, 35 ; size in pixel - bp+4
 push ax
 call mountain
 
 
 
 call road
 
 mov ax, 40
 push AX
 mov ax, 22080
 push ax
 CALL printcar
 
 mov ax, 200
 push AX
 mov ax, 30120
 push ax
 CALL printcar
 
 ;CALL PRINT_THIRD
 
; mov ax, [rabbitindex]
; cmp ax, 49520
; je rabbitleft
; cmp ax, 49220
; je rabbitright
; mov ax, [rabbitdirectionflag]
; cmp ax, 0
; je moverabbitright
; jmp moverabbitleft
; printrabbit:

 ; call DRAW_RABBIT
 
 pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 
 
 rabbitleft:
 mov ax, 0
 mov [rabbitdirectionflag], AX
 jmp rabbithere
 
 rabbitright:
 mov ax, 1
 mov [rabbitdirectionflag], AX
 jmp rabbithere
 
 moverabbitleft:
 mov ax, [rabbitindex]
 mov bx, [platformspeed]
 sub ax, bx
 mov [rabbitindex], AX
 jmp printrabbit
 
  moverabbitright:
 mov ax, [rabbitindex]
  mov bx, [platformspeed]
 add ax, bx
 
 mov [rabbitindex], AX
 jmp printrabbit
 
 platformleft:
 mov ax, 0
 mov [platformdirectionflag], AX
 mov [rabbitdirectionflag], AX
 jmp platformhere
 
 platformright:
 mov ax, 1
 mov [platformdirectionflag], AX
 mov [rabbitdirectionflag], AX
 jmp platformhere
 
 moveplatformleft:
 mov ax, [platformindex]
 mov bx, [platformspeed]
 sub ax, bx
 mov [platformindex], AX
 jmp printplatform
 
  moveplatformright:
 mov ax, [platformindex]
 mov bx, [platformspeed]
 add ax, bx
 ;inc ax
 mov [platformindex], AX
 jmp printplatform
 
 
 
  platform2left:
 mov ax, 0
 mov [platform2directionflag], AX
 jmp platform2here
 
 platform2right:
 mov ax, 1
 mov [platform2directionflag], AX
 jmp platform2here
 
 moveplatform2left:
 mov ax, [platform2index]
 mov bx, [platformspeed]
 sub ax, bx
 mov [platform2index], AX
 jmp printplatform2
 
  moveplatform2right:
 mov ax, [platform2index]
 mov bx, [platformspeed]
 add ax, bx
 mov [platform2index], AX
 jmp printplatform2
 
 platform3left:
 
 mov ax, 0
 mov [platform3directionflag], AX
 jmp platform3here
 
 platform3right:
  mov ax,1
 mov [platform3directionflag], AX
 jmp platform3here
 
  moveplatform3left:
 mov ax, [platform3index]
 mov bx, [platformspeed]
 sub ax, bx
 mov [platform3index], AX
 jmp printplatform3
 
  moveplatform3right:
 mov ax, [platform3index]
 mov bx, [platformspeed]
 add ax, bx
 mov [platform3index], AX
 jmp printplatform3

 ;end of printscreen function
 
 PRINT_THIRD:
  push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 push dx
 

mov ax, 0A000H
 mov es, AX
 MOV DI, [startofthird]
MOV CX, 78
 MOV AX, 102
 
 THIRDLOOP:
 PUSH CX
 
 MOV CX, 320

 REP STOSB
 
 POP CX
 LOOP THIRDLOOP
 

 pop dx
  pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 
 
 DRAW_PLATFORM:
  push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 



 mov di, [bp+4]
 MOV AX, [bp+6]
 MOV CX, [platformthickness]
 
 PLATFORMLOOP:
 cmp di, 21120
 jbe DONT_PRINT_PLATFORM
 PUSH CX
 MOV CX, [platformlength]



 rep stosb
 ADD DI, 320
 SUB DI, [platformlength]
 POP CX

 LOOP PLATFORMLOOP
 
DONT_PRINT_PLATFORM:
 
  pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 4

 
 
 
 DRAW_RABBIT:
  push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 
 
 mov di, [rabbitindex]

mov al ,13



mov cx, 5
push di
rabbit1:
push cx
mov cx, 3
rep stosb
add di, 320
sub di, 3
pop cx
loop rabbit1

pop di
add di, 11

mov cx, 5
rabbit2:
push cx
mov cx, 3
rep stosb
add di, 320
sub di, 3
pop cx
loop rabbit2

;mov di, 2560
;add di, [rabbitindex]
sub di, 10
sub di, 3
mov cx, 7
mov al, 7
rabbit3:
push cx
mov cx, 18
rep stosb
add di, 320
sub di, 18
pop cx
loop rabbit3

mov al, 23
;mov di, 5120
;add di, [rabbitindex]
sub di, 3
mov cx, 13

rabbit4:
push cx
mov cx, 23
rep stosb
add di, 320
sub di, 23
pop cx
loop rabbit4

MOV AL, 28
;MOV DI, 10880
;ADD DI, [rabbitindex]
sub di, 320
add di, 4
push di

MOV CX, 2
RABBIT5:
PUSH CX
MOV CX, 5 
REP STOSB
ADD DI, 320
SUB DI, 5
POP CX
LOOP RABBIT5

pop DI
add di, 10
MOV CX, 2 
RABBIT6:
PUSH CX
MOV CX, 5
REP STOSB
ADD DI, 320
SUB DI, 5
POP CX
LOOP RABBIT6

  pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 

 
 
 
 
 mountain: ;takes 3 parametes. 1. color, 2. starting offset of mountain base, 3. height of mountain in pixels
 push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 
 
 mov cx, [bp+4]
 mov bx, [baseoffirst]
 add bx, [bp+6]
  mov [num1], bx
 mov dx, 0
 mov ax, CX
 shl ax, 1
 mov [num2], AX
 mov ax, [bp+8];color
 
 loop1:
 
 cmp bx, [num3]
 jae loop2
 MOV [ES:BX],AX
 inc dx
 add bx, 1

 cmp dx, [num2]
 je loop2
 jmp loop1
 
 loop2:
 sub word [num2] , 2
 mov dx, 0
 mov bx, [num1]
 sub bx, 320
 inc BX
 mov [num1], BX
 sub cx, 1
 jnz loop1
 
 
 pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 6
 ;end of mountain function
 
 
 
 
 
 
 sky:
 push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 
 
mov ax, [skycolor] ; color palette 
MOV BX,0A000H ;
MOV ES,BX ; ES set to start of VGA
MOV BX, 0 ; BX set to pixel offset 0
MOV CX, [baseoffirst]

 ClrLoop: ; Repeat
 MOV [ES:BX],AX ; Memory[ES:BX] := Color
 INC BX ; BX := BX + 1
LOOP ClrLoop ; CX := CX – 1
 ; Until CX = 0 
 
 
 pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 
  ret
  ;end of sky function
  
  
  
  
  
  road:
 push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 
 

MOV BX,0A000H ;
MOV ES,BX ; ES set to start of VGA
MOV BX, [startofsecond] ; BX set to pixel offset 0
MOV CX, [baseoffirst]

 ;printing upper curb
 call printcurb

; printing road
 MOV CX, [roadwidth]
 mov ax, [roadcolor]
 roadloop:
MOV [ES:BX], AX
INC BX
loop roadloop
;endof roadloop

call printcurb


 mov ax, 0
 push AX
 call printstripes
  mov ax, 64
 push AX
 call printstripes
  mov ax, 128
 push AX
 call printstripes
  mov ax, 192
 push AX
 call printstripes
   mov ax, 256
 push AX
 call printstripes



pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 
  ret
  
   ; MOV CX, [roadwidth]
 ; mov ax, 2
 ; roadloop:
; MOV [ES:BX], AX
; INC BX
; loop roadloop

jmp exit
  ;end of road function
  
 
  printcurb:
  push bp
 mov bp, sp
 push AX
 push CX
 
 
 
 mov dx, [curbwidth]
 maincurbloop: ; outer loop 
  
 MOV CX, [curbcolorlength]
 mov ax, [curbcolorone]
 firstcolorcurbloop:;inner first loop for first color
 MOV [ES:BX], AX
 INC BX
 LOOP firstcolorcurbloop
  MOV CX, [curbcolorlength]
  mov ax, [curbcolortwo]
 secondcolorcurbloop: ;inner second loop for second color
 MOV [ES:BX], AX
 INC BX
 LOOP secondcolorcurbloop
 
 dec DX
 jnz maincurbloop ;end of outer loop
 


  pop CX
 pop AX
 pop bp
 
 ret
 ;end of printcurb function
 
 printstripes:
 push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 
 
 ;to print road lanes
mov bx, [startofsecond]
add bx, 10560 ;;middle of road
add bx, [bp+4]
mov ax, 15 ; white color
mov cx, [stripewidth]
mov dx, [stripelength]

stripeouterloop: ;will run width of stipe times

stripeinnerloop: ; will run length of stripe times

mov [es:bx], ax
inc bx
sub dx,1
jnz stripeinnerloop

add bx, 320
sub bx, [stripelength]
mov dx, [stripelength]
loop stripeouterloop


 pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 2
 ;end of printstripes function------------
 
 
 
 printcar:
  push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 push ES
 push dx
 
 


MOV BX,0A000H ;
MOV ES,BX ; ES set to start of VGA

mov bx, [bp+4] ; to give 22080 as a paremeter
;mov bx, 22080
;add bx, [carlocation]
mov ax, [bp+6]
add bx, ax; to give carlocation as a paremeter
mov si, bx

mov ax, [carwindowcolor]
mov bx, [carwindowwidth]
mov dx, 0
mov cx, 0

carwindowloop:


carwindowloopinner:
mov [es:si], AX
inc si
inc dx
cmp bx, dx
jne carwindowloopinner
inc cx
add bx, 2

sub si, dx
add si, 320
sub si, 1
mov dx, 0
cmp cx, [carwindowheight]
jne carwindowloop


carbody:
mov ax, [carwindowwidth]
shr ax, 1
sub si, AX


mov cx, [carbodyheight]
mov dx, [carbodywidth]
mov ax, [carbodycolor]


carbodyloop:

carbodyloopinner:
mov [es:si], AX
inc si
dec dx
jnz carbodyloopinner

mov dx, [carbodywidth]
sub si, [carbodywidth]
add si, 320
loop carbodyloop




mov ax, 7
push AX
call cartyres
mov ax, 45
push AX
call cartyres


pop dx
pop ES
 pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 4
 
 ;end of printcar function-------------


cartyres:

 push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 push dx
 
 

mov ax, [cartyrecolor]
mov bx, [tyrewidth]
mov dx, 0
mov cx, [tyreheight]
add si, [bp+4]

tyreloop:

tyreloopinner:
mov [es:si], AX
inc SI
inc dx
cmp dx, BX
jne tyreloopinner

inc cx
sub bx,2
jz here

sub si, dx
add si, 320
inc SI
mov dx, 0
dec cx
jnz tyreloop


here:

pop dx
 pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 2


 

 num1: dw 0
 num2: dw 0
 num3: dw 32320
 

 skycolor: dw 11 ;79, 102, 11
 Color: db 0x07
 baseoffirst: dw 17920
 startofsecond: dw 17920
 curbwidth: dw 40
 curbcolorlength : dw 20
 roadwidth: dw 19200 ; 320* 60
 roadcolor: dw 21;from color palette 256
 stripelength: dw 30
 stripewidth: dw 2
 roadmiddle: dw 10560 ;+ 17920
 carlocation: dw 100
 carwindowwidth: dw 17
 carwindowheight: dw 7
carframecolor: dw 5
carwindowcolor: dw 3
carbodyheight: dw 9
carbodywidth: dw 57
carbodycolor: dw 12
cartyrecolor: dw 0
tyrewidth: dw 6
tyreheight: dw 25
curbcolorone: dw 15
curbcolortwo: dw 45
startofthird: dw 40320
platformx: dw 120
platformy: dw 59200
platformoriginalindex: dw 61120+120 
platformindex: dw 61120+120 
platformrightbound: dw 61300 ; 59360
platformleftbound: dw 61180  ;59280
platform2index: dw 42360
platform2rightbound: dw 42420; 44640
platform2leftbound: dw 42300 ; 44560
platform3index: dw 50360
platform3originalindex: dw 50360
platform3leftbound: dw 50300
platform3rightbound: dw 50420
platformthickness: dw 5
platformlength: dw 70
scoremessage: db 'Your Score: '
rabbitindex: dw 53440+140
jumpflag: dw 0
rabbitdirectionflag: dw 0
platformdirectionflag: dw 0
platform2directionflag: dw 0
platform3directionflag: dw 1
platformcolor: dw 46
platform2color: dw 69
platform3color: dw 84
randomcolor: dw 0
platformspeed: dw 1
prevtime: db 0
jumpprogress: dw 0
lowerprogress: dw 0
lowerflag: db 0 
carrotindex: dw 0
carrotflag: dw 0
blueplatformflag: dw 0
prevbluetime: dw 0
bluetime: dw 0
PRN: dw 0
randomindex: dw 0
oldisr: dd 0

;54616C68612041686D65642041776169732041616D6972




start:

xor ax, ax
mov es, ax ; point es to IVT base
mov ax, [es:8*4]
mov [oldisr], ax ; save offset of old routine
mov ax, [es:8*4+2]
mov [oldisr+2], ax ; save segment of old routine
cli ; disable interrupts
mov word [es:8*4], timer ; store offset at n*4
mov [es:8*4+2], cs ; store segment at n*4+2
sti ; enable interrupts








 ; xor ax, ax
; mov es, ax ; point es to IVT base
; cli ; disable interrupts
; mov word [es:8*4], timer; store offset at n*4
; mov [es:8*4+2], cs ; store segment at n*4+2
; sti

;54616C68612041686D65642041776169732041616D6972

 call printscrn
 
mov cx, 0
 inflop:

 call movscrn
 mov ah, 2ch
 int 21h
 
  cmp dl, [prevtime]
  je inflop
 CALL JUMP_BUNNY
 call movscrn2 ; this functions handles printing of the third part, bunny, platform. this function prints bunny platform and then incremets index
 
 mov [prevtime], dl
 jmp inflop
 

 loop inflop
 

 jmp exit
 ;54616C68612041686D65642041776169732041616D6972