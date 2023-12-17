.386					;�i�D��Ķ���ϥ� 80386 �Χ󰪪��������O��
.model flat, stdcall	;flat ��ܨϥΥ��Z���s�ҫ��Astdcall �h��ܨϥ� stdcall �եκD�ҡC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;�ޤJ���~����ܮw
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc												

includelib canvas.lib
extern BeginDrawing: proc

public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;data
.data

window_title DB "Bomberman",0	;���D
area_width EQU 950				;�ϰ�j�p�e��
area_height EQU 950				;�ϰ�j�p����
area DD 0						;�ϰ�_�l�y��

counter DD 0					;�p�ɾ���l��0
counterBomb DD 0				;���u�p�ɾ���l��0
counterExplosion DD 0			;�z���p�ɾ���l��0
counterEnemy1 DD 0				;�ĤH1�p�ɾ���l��0
counterEnemy2 DD 0				;�ĤH2�p�ɾ���l��0
counterMap DD 0					;�a�Ͻs����l��0
map_x DD 0
map_y DD 0
door_seed DD 0

arg1 EQU 8						; arg1 - �n��ܪ��Ÿ��]�r���μƦr�^
arg2 EQU 12						; arg2 - ���V�����V�q�����w
arg3 EQU 16						; arg3 - pos_x
arg4 EQU 20						; arg4 - pos_y

symbol_width EQU 10
symbol_height EQU 20
symbol_object_width EQU 50
symbol_object_height EQU 50
include digits.inc
include letters.inc
include object.inc
include bomber_man_map.inc
include picture.inc
button_up_x EQU area_width - 100	;�W���s��m
button_up_y EQU area_height - 150

button_left_x EQU area_width - 150	;�����s��m
button_left_y EQU area_height - 100

button_down_x EQU area_width - 100	;�U���s��m
button_down_y EQU area_height - 50

button_right_x EQU area_width - 50	;�k���s��m
button_right_y EQU area_height - 100

button_bomb_x EQU area_width - 100	;���u���s��m
button_bomb_y EQU area_height - 100

bomberman_x DD 50		;����_�l��m
bomberman_y DD 50

bomb_check DB 0			;�ˬd�O�_�i�H��m���u
bomb_x DD 0				;���u��m
bomb_y DD 0	
explosion_check DD 0	;�ˬd���u�O�_�w�g�z��(�Ω�R��)

;enemy_num DD 2								;�ĤH�`��
enemy1_x DD area_width-100;,area_width-500	;�ĤH1��l��m
enemy1_y DD area_height-200;,area_width-500
enemy1_alive DD 1, 1						;�ˬd�ĤH1�O�_�٬���
enemy2_x DD area_width-200;,area_width-500	;�ĤH2��l��m
enemy2_y DD area_height-300;,area_width-500
enemy2_alive DD 1, 1						;�ˬd�ĤH2�O�_�٬���
game_over_check DD 0						;�ˬd���a�O�_��F


aux DD 0			;���U�ܼ�
aux1 DD 0
aux2 DD 0
random_aux DD 371	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;code
.code
;make_text �{���b���w�y�гB��ܦr���μƦr
make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ;�N�ǤJ�Ѽ� arg1 ���ȡ]�Y�n��ܪ��r�š^���J�H�s�� eax ���C
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	cmp eax, ' '
	jne make_object
	mov eax, 26 ;0��25�O�r���A26�O�Ů�
	lea esi, letters
	jmp draw_text
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
	jmp cycle_symbol_col
cycle_symbol_col:
	mov edi, [ebp+arg2] ;���V�����Ʋժ����w
	mov eax, [ebp+arg4] ;���V y �y�Ъ����w
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width														
	mul ebx
	add eax, [ebp+arg3] ;���V x �y�Ъ����w
	shl eax, 2			;���H 4�A�C�ӹ������@�� DWORD
	add edi, eax
	push ecx
	mov ecx, symbol_width
cycle_symbol_row:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0A7A6A5h
simbol_pixel_next:
	inc esi
	add edi, 4
	loop cycle_symbol_row
	pop ecx
	loop cycle_symbol_col
	popa
	mov esp, ebp
	pop ebp
	jmp make_done
make_object:
	cmp eax, 'AA'	;��
	je object_done
	cmp eax, 'AB'	;�j
	je object_done
	cmp eax, 'AC'	;��
	je object_done
	cmp eax, 'AD'	;��
	je object_done
	cmp eax, 'AE'	;���a
	je object_done
	cmp eax, 'AF'	;�ĤH
	je object_done
	jmp make_done
object_done:
	sub eax,'AA'
	lea esi, object;picture;
	jmp draw_object
draw_object:
	mov ebx, symbol_object_width
	mul ebx
	mov ebx, symbol_object_height
	mul ebx
	add esi,eax
	mov ecx, symbol_object_height
	jmp cycle_symbol_object_col
cycle_symbol_object_col:
	mov edi, [ebp+arg2] ;���V�����Ʋժ����w
	mov eax, [ebp+arg4] ;���V y �y�Ъ����w
	add eax, symbol_object_height
	sub eax, ecx
	mov ebx, area_width														
	mul ebx
	add eax, [ebp+arg3] ;���V x �y�Ъ����w
	shl eax, 2			;���H 4�A�C�ӹ������@�� DWORD
	add edi, eax
	push ecx
	mov ecx, symbol_object_width
cycle_symbol_object_row:
	cmp byte ptr [esi], 0
	je simbol_object_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_object_pixel_next
simbol_object_pixel_alb:
	mov dword ptr [edi], 0A7A6A5h
simbol_object_pixel_next:
	inc esi
	add edi, 4
	loop cycle_symbol_object_row
	pop ecx
	loop cycle_symbol_object_col
	popa
	mov esp, ebp
	pop ebp
	jmp make_done
make_done:
	ret
make_text endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;macro
make_text_macro macro symbol, drawArea, x, y	;��X�I�sø�s�Ÿ�������
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm

line_horizontal macro x, y, len, color	;�e�@�������u������
local loop_line
	push eax
	push ebx
	mov eax, y; EAX = y
	mov ebx, area_width
	mul ebx; EAX = y*area_width
	add EAX, x; EAX = y*area_width+x
	shl eax, 2; EAX = (y*area_width+x)*4
	add EAX, area
	
	mov ECX, len
loop_line:
	mov dword ptr [eax], color
	add EAX,4
loop loop_line
pop ebx
pop eax
endm

line_vertical macro x, y, len, color	;�e�@�������u������
local loop_line
	push eax
	push ebx
	mov eax, y; EAX = y
	mov ebx, area_width
	mul ebx; EAX = y*area_width
	add EAX, x; EAX = y*area_width+x
	shl eax, 2; EAX = (y*area_width+x)*4
	add EAX, area
	
	mov ECX, len
loop_line:
	mov dword ptr [eax], color
	add EAX,area_width*4
loop loop_line
pop ebx
pop eax
endm

draw_square macro x,y, color	;�e�@�ӥ���Ρ]�ϥΫe�����u�^������
local square_loop
	push esi
	push edi
	mov EDI, y
	mov ESI, 0
	
	square_loop:
	line_horizontal x, EDI, 50, color
	inc ESI
	inc EDI
	cmp ESI, 50
	jne square_loop
	pop edi
	pop esi
endm

draw_arrow macro dir,x,y,color	;ø�s�b�Y������
local up, left, down, right, finish
	mov aux1, dir
	mov ESI, 50
	mov EDI, x
	mov aux, y
	
	cmp aux1, 1
	je up
	cmp aux1, 2
	je left
	cmp aux1, 3
	je down
	cmp aux1, 4
	je right
	
	down:
	line_horizontal EDI, aux, ESI, color
	inc EDI
	sub ESI, 2
	inc aux
	cmp ESI, 0
	jne down
	jmp finish
	
	up:
	line_horizontal EDI, aux, ESI, color
	inc EDI
	sub ESI, 2
	dec aux
	cmp ESI, 0
	jne up
	jmp finish
	
	left:
	line_vertical EDI, aux, ESI, color
	dec EDI
	sub ESI, 2
	inc aux
	cmp ESI, 0
	jne left
	jmp finish
	
	right:
	line_vertical EDI, aux, ESI, color
	inc EDI
	sub ESI, 2
	inc aux
	cmp ESI, 0
	jne right
	
	finish:
endm

press_button macro x,y,button_x,button_y, diff_x, diff_y	;�ˬd��V���s���U���p������
local button_fail, bomb_case, defeat
	mov EAX, x
	cmp EAX, button_x
	jl button_fail
	cmp EAX, button_x+50
	jg button_fail
	mov EAX, y
	cmp EAX, button_y
	jl button_fail
	cmp EAX, button_y+50
	jg button_fail
	
	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;�J��ĤH1
	cmp dword ptr [EAX], 0FF69B4h
	je defeat
	
	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;�J��ĤH2
	cmp dword ptr [EAX], 00069B4h
	je defeat

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y
	cmp dword ptr [EAX], 0FFFFFFh
	jne button_fail
	
	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y
	cmp dword ptr [EAX], 0h
	je bomb_case
	
	draw_square bomberman_x, bomberman_y, 0FFFFFFh
	bomb_case:
	add bomberman_y, diff_y
	add bomberman_x, diff_x
	draw_square bomberman_x, bomberman_y, 0FF0000h
	jmp button_fail
	
	defeat:
	game_over
	
	button_fail:
endm

press_button_bomb macro x,y		;���ҫ��U���u���s������
local button_fail
	mov EAX, x
	cmp EAX, button_bomb_x
	jl button_fail
	cmp EAX, button_bomb_x+50
	jg button_fail
	mov EAX, y
	cmp EAX, button_bomb_y
	jl button_fail
	cmp EAX, button_bomb_y+50
	jg button_fail
	
	cmp bomb_check, 0
	jne button_fail
	
	draw_square bomberman_x, bomberman_y, 0h
	mov bomb_check,1 
	mov EAX, bomberman_x
	mov bomb_x, EAX
	mov EAX, bomberman_y
	mov bomb_y, EAX
	
	button_fail:
endm

calculate_pozition macro x,y,diff_x,diff_y		;�ھڮy�Эp���m������
	mov EAX, y; EAX = y
	add EAX, diff_y
	mov EBX, area_width
	mul EBX; EAX = y*area_width 
	add EAX, x; EAX = y*area_width+x
	add EAX, diff_x
	shl EAX, 2; EAX = (y*area_width+x)*4
	add EAX, area
endm

game_over macro				;�C������������
	mov enemy1_alive,0
	mov enemy2_alive,0
	mov bomb_check,0 

	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 0A7A6A5h			;��Ӧa�϶�Ǧ�
	push area
	call memset
	add esp, 12
	
	make_text_macro 'D', area, area_width/2-25, area_height/2
	make_text_macro 'E', area, area_width/2-15, area_height/2
	make_text_macro 'F', area, area_width/2-5, area_height/2
	make_text_macro 'E', area, area_width/2+5, area_height/2
	make_text_macro 'A', area, area_width/2+15, area_height/2
	make_text_macro 'T', area, area_width/2+25, area_height/2
	
	mov game_over_check, 1
	
	
endm

explosion_radius macro x, y, diff_x, diff_y, color        ;���z���v�T���ϰ쪺����
local unbreakable, explosion_loop, breakable, crate, defeat, enemy1, enemy2, open_door
    mov ESI, bomb_x
    mov aux1, ESI
    mov ESI, bomb_y
    mov aux2, ESI

    mov aux, 0
    ;�ھ��C����椣�P���ާ@
    explosion_loop:
    calculate_pozition x,y, diff_x, diff_y
    cmp dword ptr [EAX], 0FF69B4h    ;�ĤH1
    je enemy1
    cmp dword ptr [EAX], 00069B4h    ;�ĤH2
    je enemy2
    cmp dword ptr [EAX], 0FF0000h    ;���a
    je defeat
    cmp dword ptr [EAX], 0A0522Dh    ;�j
    je crate
	cmp dword ptr [EAX], 0A0522Eh    ;�j(����)
    je open_door
    cmp dword ptr [EAX], 0F59B00h    ;�z��
    je breakable
    cmp dword ptr [EAX], 0FFFFFFh    ;��
    jne unbreakable
    breakable:
    add x, diff_x
    add y, diff_y
    draw_square x, y, color
    inc aux
    cmp aux, 4
    jne explosion_loop
    jmp unbreakable

    defeat:
    game_over
    jmp unbreakable

    crate:
    add x, diff_x
    add y, diff_y
    ;random_door_seed
    ;cmp door_seed, 0
    ;je open_door
    draw_square x, y, 0FFFFFFh
    jmp unbreakable

    open_door:
	add x, diff_x
    add y, diff_y
    draw_square x, y, 000FF00h
    jmp unbreakable

    enemy1:
    add x, diff_x
    add y, diff_y
    draw_square x, y, 0FFFFFFh
    mov enemy1_alive,0
    jmp unbreakable

    enemy2:
    add x, diff_x
    add y, diff_y
    draw_square x, y, 0FFFFFFh
    mov enemy2_alive,0

    unbreakable:

    mov ESI, aux1
    mov bomb_x, ESI
    mov ESI, aux2
    mov bomb_y,ESI

endm

explosion macro x,y, color	;�z���������
local no_defeat, finish
	
	explosion_radius x, y, 50, 0, color
	explosion_radius x, y, -50, 0, color
	explosion_radius x, y, 0, -50, color
	explosion_radius x, y, 0, 50, color
	
	mov EAX, bomberman_x
	cmp bomb_x, EAX
	jne no_defeat
	mov EAX, bomberman_y
	cmp bomb_y, EAX
	jne no_defeat
	game_over
	jmp finish
	
	no_defeat:
	calculate_pozition bomb_x,bomb_y,0,0
	cmp dword ptr [eax], 0FFFFFFh
	jne finish
	draw_square bomb_x,bomb_y, color
	finish:
endm


bomb_mechanism macro		;�M�w���u�ާ@������
	cmp explosion_check,1
	je explosion_timer
	
	cmp bomb_check,1
	jne no_bomb
	
	;���U���s
	calculate_pozition bomb_x,bomb_y, 0, 0
	cmp dword ptr [EAX], 0h
	jne black
	draw_square bomb_x, bomb_y, 0F59B00h
	jmp off
	black:
	draw_square bomb_x, bomb_y, 0h
	off:
	
	cmp counterBomb, 10
	jne no_explosion
	
	mov counterBomb, 0
	
	mov explosion_check,1
	
	explosion bomb_x, bomb_y, 0F59B00h		;�z��
	
	explosion_timer:
	inc counterExplosion
	cmp counterExplosion, 5
	jne no_bomb
	explosion bomb_x, bomb_y, 0FFFFFFh
	draw_square bomb_x,bomb_y, 0FFFFFFh
	mov counterExplosion, 0
	mov explosion_check,0
	mov bomb_check, 0
	
	jmp no_bomb
	
	no_explosion:
	inc counterBomb
	
	no_bomb:
endm

create_map macro		;�s�@�a�Ϫ�����
local done, m0, m1, m2, m3, loop_, done, wall, crate, road, door
random
;�j����m����P�ɬ�100��(�H��50,50�B50,100�B100,50���n��)
	push ebp
	mov ebp, esp
	pusha
	
	mov EDX, [ebp+arg1] ;�N�ǤJ�Ѽ� arg1 ���ȡ]�Y�n��ܪ��r�š^���J�H�s�� edx ���C
	lea ESI, bomber_man_map
	mov EAX, counterMap
	mov EBX, 361
	mul EBX
	add ESI, EAX

	loop_:
	cmp byte ptr [esi],0
	je door
	cmp byte ptr [esi],1
	je wall
	cmp byte ptr [esi],2
	je crate
	cmp byte ptr [esi],3
	je road

	door:
	draw_square map_x, map_y, 0A0522Eh
	jmp next

	wall:
	draw_square map_x, map_y, 0A7A6A5h
	jmp next

	crate:
	draw_square map_x, map_y, 0A0522Dh
	jmp next

	road:
	draw_square map_x, map_y, 0FFFFFFh
	jmp next

	next:
	add esi, 1
	add map_x, 50
	cmp map_x, 950 
	jne loop_
	add map_y, 50
	cmp map_y, 950
	je done
	mov map_x, 0
	jmp loop_
	
m0:
	cmp edx, 0
	jne m1
	;�j����m(�ȮɩT�w)
	draw_square 150, 500, 0A0522Dh
	draw_square 250, 200, 0A0522Dh
	draw_square 200, 250, 0A0522Dh
	draw_square 500, 350, 0A0522Dh
	draw_square 350, 50, 0A0522Dh
	draw_square 400, 650, 0A0522Dh
	draw_square 700, 650, 0A0522Dh
	draw_square 500, 650, 0A0522Dh
	draw_square 500, 850, 0A0522Dh
	draw_square 700, 250, 0A0522Dh
	draw_square 100, 450, 0A0522Dh
	jmp done
m1:
	cmp edx, 1
	jne m2
	;�j����m(�ȮɩT�w)
	draw_square 150, 500, 0A0522Dh
	draw_square 250, 200, 0A0522Dh
	draw_square 200, 250, 0A0522Dh
	draw_square 500, 350, 0A0522Dh
	draw_square 350, 50, 0A0522Dh
	draw_square 400, 650, 0A0522Dh
	draw_square 700, 650, 0A0522Dh
	draw_square 500, 650, 0A0522Dh
	draw_square 500, 850, 0A0522Dh
	draw_square 700, 250, 0A0522Dh
	draw_square 100, 450, 0A0522Dh
	jmp done
m2:
	cmp edx, 2
	jne m3
	;�j����m(�ȮɩT�w)
	draw_square 50, 450, 0A0522Dh
	draw_square 250, 250, 0A0522Dh
	draw_square 250, 750, 0A0522Dh
	draw_square 500, 350, 0A0522Dh
	draw_square 350, 50, 0A0522Dh
	draw_square 400, 650, 0A0522Dh
	draw_square 700, 650, 0A0522Dh
	draw_square 500, 650, 0A0522Dh
	draw_square 500, 850, 0A0522Dh
	draw_square 700, 250, 0A0522Dh
	draw_square 100, 450, 0A0522Dh
	jmp done
m3:
	;�j����m(�ȮɩT�w)
	draw_square 150, 500, 0A0522Dh
	draw_square 250, 200, 0A0522Dh
	draw_square 200, 250, 0A0522Dh
	draw_square 500, 350, 0A0522Dh
	draw_square 350, 50, 0A0522Dh
	draw_square 400, 650, 0A0522Dh
	draw_square 700, 650, 0A0522Dh
	draw_square 500, 650, 0A0522Dh
	draw_square 500, 850, 0A0522Dh
	draw_square 700, 250, 0A0522Dh
	draw_square 100, 450, 0A0522Dh
done:
	mov map_x, 0
	mov map_y, 0
	mov esp, ebp
	pop ebp
endm

random_door_seed macro	;�M�w�H���� (0-1) ������
	push eax
	push ebx
	push ecx
	push edx
	mov EAX, random_aux
	mul bomberman_y
	add EAX, bomberman_x
	mov aux1,773	
	mov EDX, 0
	div aux1
	mov random_aux, EDX
	
	mov EAX, random_aux
	mov EBX,2
	mov EDX,0
	div EBX
	mov door_seed, edx
	;���EDX
	pop edx
	pop ecx
	pop ebx
	pop eax
endm

random macro			;�M�w�H���� (0-3) ������
	mov EAX, random_aux
	mul bomberman_y
	add EAX, bomberman_x
	mov aux1,773	
	mov EDX, 0
	div aux1
	mov random_aux, EDX
	
	mov EAX, random_aux
	mov EBX,4
	mov EDX,0
	div EBX
	;���EDX
endm

enemy1_movement macro		;�M�w�ĤH1��ʪ�����
local up,left,down,right, skip, defeat, reroll, no_movement, reset
	inc counterEnemy1
	cmp counterEnemy1, 5
	jne no_movement
	
	reroll:	
	random
	
	cmp EDX,0
	je up
	cmp EDX, 1
	je left
	cmp EDX, 2
	je down
	cmp EDX, 3
	je right
	
	up:
	mov aux, 0
	mov aux1, -50
	jmp skip
	
	left:
	mov aux, -50
	mov aux1, 0
	jmp skip
	
	right:
	mov aux, 50
	mov aux1, 0
	jmp skip
	
	down:
	mov aux, 0
	mov aux1, 50
	jmp skip
	
	skip:
	mov counterEnemy1,0
	calculate_pozition enemy1_x,enemy1_y,aux, aux1
	cmp dword ptr [EAX], 0FF0000h
	je defeat
	
	calculate_pozition enemy1_x,enemy1_y,aux,aux1
	cmp dword ptr [EAX], 0FFFFFFh
	jne reroll
	
	reset:
	draw_square enemy1_x, enemy1_y, 0FFFFFFh
	
	mov EAX, aux
	add enemy1_x, EAX
	mov EAX, aux1
	add enemy1_y, EAX
	draw_square enemy1_x, enemy1_y, 0FF69B4h
	jmp no_movement
	
	defeat:
	game_over
	
	no_movement:
	
endm

enemy2_movement macro		;�M�w�ĤH2��ʪ�����
local up,left,down,right, skip, defeat, reroll, no_movement, reset
	inc counterEnemy2
	cmp counterEnemy2, 5
	jne no_movement
	
	reroll:	
	random
	
	cmp EDX, 0
	je up
	cmp EDX, 1
	je left
	cmp EDX, 2
	je down
	cmp EDX, 3
	je right
	
	up:
	mov aux, 0
	mov aux1, -50
	jmp skip
	
	left:
	mov aux, -50
	mov aux1, 0
	jmp skip
	
	right:
	mov aux, 50
	mov aux1, 0
	jmp skip
	
	down:
	mov aux, 0
	mov aux1, 50
	jmp skip
	
	skip:
	mov counterEnemy2,0
	calculate_pozition enemy2_x,enemy2_y,aux, aux1
	cmp dword ptr [EAX], 0FF0000h
	je defeat
	
	calculate_pozition enemy2_x,enemy2_y,aux,aux1
	cmp dword ptr [EAX], 0FFFFFFh
	jne reroll
	
	reset:
	draw_square enemy2_x, enemy2_y, 0FFFFFFh
	
	mov EAX, aux
	add enemy2_x, EAX
	mov EAX, aux1
	add enemy2_y, EAX
	draw_square enemy2_x, enemy2_y, 00069B4h
	jmp no_movement
	
	defeat:
	game_over
	
	no_movement:
	
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;procedure

;ø�Ϩ�� - �C���I���ɳ��|�ե�
;�ΨC�j 200 �@��@���A�䤤�S���I���ƥ�
;arg1 - evt�]0 - ��l�ơA1 - �I���A2 - ���I�������j�w�L���^
;arg2 - x
;arg3 - y

draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click ;�I���ù�
	cmp eax, 2
	jz evt_timer ;�S���I�����󤺮e
	
	;��l�ƹC���ϰ�
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 0A7A6A5h ;�N��Ӧa�϶�Ǧ�00000000h;
	push area
	call memset
	add esp, 12
	
	mov ESI, 50
		
	;ø�s�����M�����սu
	horizontal_white:
	line_horizontal 0, ESI, area_width*50, 0FFFFFFh	
	add ESI, 100
	cmp ESI, area_height - 50
	jl horizontal_white
	
	mov EDI, 50
	
	vertical_white2:
	mov ESI, area_height-51
	vertical_white1:
	line_horizontal EDI, ESI, 50, 0FFFFFFh
	dec ESI
	cmp ESI, 50
	jne vertical_white1
	add EDI, 100
	cmp EDI, area_width-50
	jl vertical_white2
	
	mov ESI, area_height-50
	
	;������t
	left_border:
	line_horizontal 0, ESI, 50, 0A7A6A5h
	dec ESI
	cmp ESI, 0
	jne left_border
	
	mov ESI, area_height-50
	
	right_border:
	line_horizontal area_height-50, ESI, 50, 0A7A6A5h	
	dec ESI
	cmp ESI, 0
	jne right_border
	
	;��l�Ʀa��
	create_map

	;��m���a�M�ĤH
	draw_square 50, 50, 0FF0000h
	draw_square area_width-100, area_height-200, 0FF69B4h
	draw_square area_width-200, area_height-300, 00069B4h
	
	;��l�Ƥ�V���s���ϰ�
	draw_square area_width-100, area_height-100, 0A7A6A5h 
	draw_square area_width-100, area_height-150, 0A7A6A5h
	draw_square area_width-150, area_height-100, 0A7A6A5h
	
	draw_arrow 1, area_width-100, area_height-110, 0h
	draw_arrow 3, area_width-100, area_height-40, 0h
	draw_arrow 2, area_width-110, area_height-100, 0h
	draw_arrow 4, area_width-40, area_height-100, 0h
	
	make_text_macro 'B', area, area_width-96, area_height-86
	make_text_macro 'O', area, area_width-86, area_height-86
	make_text_macro 'M', area, area_width-76, area_height-86
	make_text_macro 'B', area, area_width-66, area_height-86
	;make_text_macro 'AB', area, area_width-300, area_height-300
	
	jmp final_draw
	
evt_click:
	;�ˬd���s�����U���p
	cmp game_over_check,1
	je final_draw
	press_button[ebp+arg2], [ebp+arg3], button_up_x, button_up_y, 0, -50
	press_button [ebp+arg2], [ebp+arg3], button_left_x, button_left_y, -50, 0
	press_button [ebp+arg2], [ebp+arg3], button_down_x, button_down_y, 0, 50
	press_button [ebp+arg2], [ebp+arg3], button_right_x, button_right_y, 50, 0
	press_button_bomb [ebp+arg2], [ebp+arg3]
	
evt_timer:
	;�ˬd���a�O�_��F
	cmp game_over_check,1
	je final_draw
	
	;�ˬd���u
	inc counter
	bomb_mechanism
	
	;�ˬd�ĤH���ʦV
	enemy1:
	cmp enemy1_alive,1
	jne enemy2
	enemy1_movement

	enemy2:
	cmp enemy2_alive,1
	jne final_draw
	enemy2_movement
	;jmp final_draw

	;count:
	;sub enemy_num, 1 
	;cmp enemy_num, 0
	;jmp final_draw

	final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret

draw endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Main
start:
	;��ø�ϰϤ��t���s
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	
	;�I�s BEGIN DRAWING ���
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;�פ�{��
	push 0
	call exit
end start
