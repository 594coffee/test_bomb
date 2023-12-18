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
counterEnemy3 DD 0				;�ĤH3�p�ɾ���l��0
counterEnemy4 DD 0				;�ĤH4�p�ɾ���l��0
counterEnemy5 DD 0				;�ĤH5�p�ɾ���l��0
counterEnemy6 DD 0				;�ĤH6�p�ɾ���l��0
counterEnemy7 DD 0				;�ĤH7�p�ɾ���l��0
counterEnemy8 DD 0				;�ĤH8�p�ɾ���l��0
counterEnemy_1 DD 0				;�ĤH1�p�ɾ���l��0
counterEnemy_2 DD 0				;�ĤH2�p�ɾ���l��0
counterEnemy_3 DD 0				;�ĤH3�p�ɾ���l��0
counterEnemy_4 DD 0				;�ĤH4�p�ɾ���l��0
counterEnemy_5 DD 0				;�ĤH5�p�ɾ���l��0
counterEnemy_6 DD 0				;�ĤH6�p�ɾ���l��0
counterEnemy_7 DD 0				;�ĤH7�p�ɾ���l��0
counterEnemy_8 DD 0				;�ĤH8�p�ɾ���l��0
counterMap DD 0				;�a�Ͻs����l��0
map_x DD 0
map_y DD 0
door_seed DD 0

arg1 EQU 8						; arg1 - �n��ܪ��Ÿ��]�r���μƦr�^
arg2 EQU 12						; arg2 - ���V�����V�q�����w
arg3 EQU 16						; arg3 - pos_x
arg4 EQU 20						; arg4 - pos_y

image_width EQU 40
image_height EQU 40

symbol_width EQU 10
symbol_height EQU 20

include digits.inc
include letters.inc
include bomber_man_map.inc
include picture.inc
include image.inc

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
bombrange DD 2
explosion_check DD 0	;�ˬd���u�O�_�w�g�z��(�Ω�R��)

enemy1_x DD area_width-100;	;�ĤH1��l��m
enemy1_y DD area_height-200
enemy1_alive DD 0		;�ˬd�ĤH1�O�_�٬���
enemy2_x DD area_width-200	;�ĤH2��l��m
enemy2_y DD area_height-300;
enemy2_alive DD 0		;�ˬd�ĤH2�O�_�٬���
enemy3_x DD area_width-400	;�ĤH3��l��m
enemy3_y DD area_height-300
enemy3_alive DD 0		;�ˬd�ĤH3�O�_�٬���
enemy4_x DD area_width-400	;�ĤH4��l��m
enemy4_y DD area_height-300
enemy4_alive DD 0		;�ˬd�ĤH4�O�_�٬���
enemy5_x DD area_width-400	;�ĤH5��l��m
enemy5_y DD area_height-300
enemy5_alive DD 0		;�ˬd�ĤH5�O�_�٬���
enemy6_x DD area_width-400	;�ĤH6��l��m
enemy6_y DD area_height-300
enemy6_alive DD 0		;�ˬd�ĤH6�O�_�٬���
enemy7_x DD area_width-400	;�ĤH7��l��m
enemy7_y DD area_height-300
enemy7_alive DD 0		;�ˬd�ĤH7�O�_�٬���
enemy8_x DD area_width-400	;�ĤH8��l��m
enemy8_y DD area_height-300
enemy8_alive DD 0		;�ˬd�ĤH8�O�_�٬���

game_over_check DD 0		;�ˬd���a�O�_��F
pass_wall DD 0              ;�ˬd�O�_�i�H����
lastdoor DD 0               ;�x�s�H�����ʪ��W�@�Ӱ϶��C��
lastwall DD 0               ;�x�s�H�����ʪ��W�@�Ӱ϶��C��
lasttool1 DD 0              ;�x�s�H�����ʪ��W�@�Ӱ϶��C��
lasttool2 DD 0              ;�x�s�H�����ʪ��W�@�Ӱ϶��C��
lasttool3 DD 0              ;�x�s�H�����ʪ��W�@�Ӱ϶��C��
last DD 0                   ;�x�s�H���O�_���b��W
door_x DD 0
door_y DD 0

aux DD 0	;���U�ܼ�
aux1 DD 0
aux2 DD 0
random_aux DD 371	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;code
.code
;make_text �{���b���w�y�гB��ܦr���μƦr
make_color proc
	cmp byte ptr [esi], 0
	je image_red
	cmp byte ptr [esi], 2
	je image_lightblue
	cmp byte ptr [esi], 3
	je image_skincolor
	cmp byte ptr [esi], 4
	je image_white
	cmp byte ptr [esi], 5
	je image_pink
	cmp byte ptr [esi], 6
	je image_enemy1color
	cmp byte ptr [esi], 7
	je image_yellow
	cmp byte ptr [esi], 8
	je image_tool1color
	cmp byte ptr [esi], 9
	je image_gray
	cmp byte ptr [esi], 10
	je image_tool2color
	cmp byte ptr [esi], 11
	je image_light_purple
	cmp byte ptr [esi], 12
	je image_morelightpurple
	cmp byte ptr [esi], 13
	je image_darkskin
	cmp byte ptr [esi], 14
	je image_tool3color
	cmp byte ptr [esi], 15
	je image_doorcolor
	cmp byte ptr [esi], 16
	je image_brown
	cmp byte ptr [esi], 17
	je image_enemy2color
	cmp byte ptr [esi], 18
	je image_black
	cmp byte ptr [esi], 19
	je image_lightgreen
	cmp byte ptr [esi], 20
	je image_enemy3_color
	cmp byte ptr [esi], 21
	je image_orange
	mov dword ptr [edi], 0
	jmp color_end

	image_orange:
		mov dword ptr [edi], 0ee6622h
		jmp color_end	
	image_enemy3_color:
		mov dword ptr [edi], 0AA00CCh
		jmp color_end	
	image_lightgreen:
		mov dword ptr [edi], 99ee22h
		jmp color_end			
	image_black:
		mov dword ptr [edi], 000000h
		jmp color_end	
	image_enemy2color:
		mov dword ptr [edi], 00069B4h
		jmp color_end																																																			
	image_brown:
		mov dword ptr [edi], 0AA5522h
		jmp color_end
	image_doorcolor:
		mov dword ptr [edi], 0A0522Eh
		jmp color_end	
	image_tool2color:
		mov dword ptr [edi], 0A0532Dh
		jmp color_end	
	image_gray:
		mov dword ptr [edi], 0A7A6A5h
		jmp color_end	
	image_tool1color:
		mov dword ptr [edi], 0A0522Ch
		jmp color_end
	image_yellow:
		mov dword ptr [edi], 0ffdd33h
		jmp color_end
	image_red:
		mov dword ptr [edi], 0ff0000h
		jmp color_end
	image_lightblue:
		mov dword ptr [edi], 66FFFFh
		jmp color_end
	image_skincolor:
		mov dword ptr [edi], 0FFDD77h
		jmp color_end
	image_white:
		mov dword ptr [edi], 0ffffffh
		jmp color_end
	image_pink:
		mov dword ptr [edi], 0ff44cch
		jmp color_end
	image_enemy1color:
		mov dword ptr [edi], 0FF69B4h
		jmp color_end
	image_light_purple:
		mov dword ptr [edi], 8866bbh
		jmp color_end
	image_morelightpurple:
		mov dword ptr [edi], 0cccceeh
		jmp color_end
	image_darkskin:
		mov dword ptr [edi], 0ddcccch
		jmp color_end
	image_tool3color:
		mov dword ptr [edi], 0A0512Dh
		jmp color_end
	color_end:
		ret
make_color endp

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
	jne make_done
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
	mov dword ptr [edi],0A7A6A5h
simbol_pixel_next:
	inc esi
	add edi, 4
	loop cycle_symbol_row
	pop ecx
	loop cycle_symbol_col
	popa
	mov esp, ebp
	pop ebp
make_done:
	ret
make_text endp

make_image proc ; �e������
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 'i'
	jg draw_big_image
	sub eax, 'a'
	lea esi, image
	jmp draw_image
draw_image:
	mov ebx, image_width
	mul ebx
	mov ebx, image_height
	mul ebx
	add esi, eax
	mov ecx, image_height
	jmp cycle_image_col
draw_big_image:
	
cycle_image_col:
	mov edi, [ebp+arg2] ;���V�����Ʋժ����w
	mov eax, [ebp+arg4] ;���V y �y�Ъ����w
	add eax, image_height
	sub eax, ecx
	mov ebx, area_width														
	mul ebx
	add eax, [ebp+arg3] ;���V x �y�Ъ����w
	shl eax, 2			;���H 4�A�C�ӹ������@�� DWORD
	add edi, eax
	push ecx
	mov ecx, image_width
cycle_image_row:
	call make_color
image_pixel_next:
	inc esi
	add edi, 4
	loop cycle_image_row
	pop ecx
	loop cycle_image_col
	popa
	mov esp, ebp
	pop ebp
make_done:
	ret
make_image endp
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

make_image_macro macro image, drawArea, x, y
	push y
	push x
	push drawArea
	push image
	call make_image
	add esp, 16
endm

line_horizontal macro x, y, len, color	;�e�@�������u������
local loop_line
	push eax
	push ebx
	mov eax, y; eax = y
	mov ebx, area_width
	mul ebx; eax = y*area_width
	add eax, x; eax = y*area_width+x
	shl eax, 2; eax = (y*area_width+x)*4
	add eax, area
	
	mov ecx, len
loop_line:
	mov dword ptr [eax], color
	add eax,4
loop loop_line
pop ebx
pop eax
endm

line_vertical macro x, y, len, color	;�e�@�������u������
local loop_line
	push eax
	push ebx
	mov eax, y; eax = y
	mov ebx, area_width
	mul ebx; eax = y*area_width
	add eax, x; eax = y*area_width+x
	shl eax, 2; eax = (y*area_width+x)*4
	add eax, area
	
	mov ecx, len
loop_line:
	mov dword ptr [eax], color
	add eax,area_width*4
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
local button_fail, bomb_case, defeat, to_next, get_tool1, road, get_tool2, cantpass, canpass1, canpass2, canpass3, canpass4, iswall, drawdoor, drawwall, drawtool1, drawtool2, get_tool3, canpass5, drawtool3
	mov eax, x
	cmp eax, button_x
	jl button_fail
	cmp eax, button_x+50
	jg button_fail
	mov eax, y
	cmp eax, button_y
	jl button_fail
	cmp eax, button_y+50
	jg button_fail
	
	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;�J��ĤH1
	cmp dword ptr [eax], 0FF69B4h
	je defeat
	
	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;�J��ĤH2
	cmp dword ptr [eax], 00069B4h
	je defeat

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;�J��ĤH3
	cmp dword ptr [eax], 0AA00CCh
	je defeat

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;�J��ĤH4
	cmp dword ptr [eax], 0F2DB94h
	je defeat

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;�J��ĤH5
	cmp dword ptr [eax], 01E0ECh
	je defeat

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;�J��ĤH6
	cmp dword ptr [eax], 4C004Ah
	je defeat

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;�J��ĤH7
	cmp dword ptr [eax], 0BF9000h
	je defeat

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;�J��ĤH8
	cmp dword ptr [eax], 0C42E5Bh
	je defeat

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;�J���
	cmp dword ptr [eax], 000FF00h
	je to_next

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;�J��D��1
	cmp dword ptr [eax], 0FFFF00h
	je get_tool1

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;�J��D��2
	cmp dword ptr [eax], 073763h
	je get_tool2

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;�J��D��3
	cmp dword ptr [eax], 0CAFFE5h
	je get_tool3

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y
	cmp pass_wall, 0
	je cantpass
	cmp dword ptr [eax], 0A0522Dh			;�J����
	je canpass1
	cmp dword ptr [eax], 0A0522Eh			;�J����(��)
	je canpass2
	cmp dword ptr [eax], 0A0522Ch			;�J����(�D��1)
	je canpass3
	cmp dword ptr [eax], 0A0532Dh			;�J����(�D��2)
	je canpass4
	cmp dword ptr [eax], 0A0512Dh			;�J����(�D��3)
	je canpass5
	cmp last, 1
	je iswall
	jmp cantpass
	
	canpass1:
	mov last, 1
	mov bomb_check, 1
	mov lastwall, 1
	jmp road

	canpass2:
	mov last, 1
	mov bomb_check, 1
	mov lastdoor, 1
	jmp road

	canpass3:
	mov last, 1
	mov bomb_check, 1
	mov lasttool1, 1
	jmp road

	canpass4:
	mov last, 1
	mov bomb_check, 1
	mov lasttool2, 1
	jmp road

	canpass5:
	mov last, 1
	mov bomb_check, 1
	mov lasttool3, 1
	jmp road

	cantpass:
	cmp dword ptr [eax], 0FFFFFFh
	jne button_fail

	
	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y
	cmp dword ptr [eax], 0h
	je bomb_case

	road:
	draw_square bomberman_x, bomberman_y, 0FFFFFFh
	jmp bomb_case

	iswall:
	cmp dword ptr [eax], 0FFFFFFh
	jne button_fail
	mov last, 0
	mov bomb_check, 0
	cmp lastwall, 1
	je drawwall
	cmp lastdoor, 1
	je drawdoor
	cmp lasttool1, 1
	je drawtool1
	cmp lasttool2, 1
	je drawtool2
	cmp lasttool3, 1
	je drawtool3
	jmp bomb_case
	
	drawdoor:
	draw_square bomberman_x, bomberman_y, 0A0522Eh
	mov lastdoor, 0
	jmp bomb_case

	drawwall:
	draw_square bomberman_x, bomberman_y, 0A0522Dh
	mov lastwall, 0
	jmp bomb_case

	drawtool1:
	draw_square bomberman_x, bomberman_y, 0A0522Ch
	mov lasttool1, 0
	jmp bomb_case

	drawtool2:
	draw_square bomberman_x, bomberman_y, 0A0532Dh
	mov lasttool2, 0
	jmp bomb_case

	drawtool3:
	draw_square bomberman_x, bomberman_y, 0A0512Dh
	mov lasttool3, 0
	jmp bomb_case

	bomb_case:
	add bomberman_y, diff_y
	add bomberman_x, diff_x
	draw_square bomberman_x, bomberman_y, 0FF0000h
	mov eax, bomberman_x
	add eax, 5
	mov aux, eax
	mov eax, bomberman_y
	add eax, 5
	mov aux1, eax
	make_image_macro "a", area, aux, aux1

	jmp button_fail
	
	defeat:
	game_over
	jmp button_fail
	
	to_next:
	next_level
	jmp button_fail

	get_tool1:
		tool1
		jmp road

	get_tool2:
		tool2
		jmp road

	get_tool3:
		tool3
		jmp road

	button_fail:
endm

press_button_bomb macro x,y		;���ҫ��U���u���s������
local button_fail
	mov eax, x
	cmp eax, button_bomb_x
	jl button_fail
	cmp eax, button_bomb_x+50
	jg button_fail
	mov eax, y
	cmp eax, button_bomb_y
	jl button_fail
	cmp eax, button_bomb_y+50
	jg button_fail
	
	cmp bomb_check, 0
	jne button_fail
	
	draw_square bomberman_x, bomberman_y, 0h
	mov bomb_check,1 
	mov eax, bomberman_x
	mov bomb_x, eax
	mov eax, bomberman_y
	mov bomb_y, eax
	
	button_fail:
endm

calculate_pozition macro x,y,diff_x,diff_y		;�ھڮy�Эp���m������
	mov eax, y; eax = y
	add eax, diff_y
	mov ebx, area_width
	mul ebx; eax = y*area_width 
	add eax, x; eax = y*area_width+x
	add eax, diff_x
	shl eax, 2; eax = (y*area_width+x)*4
	add eax, area
endm

tool1 macro                ;��o�D��1������
    inc bombrange
endm

tool2 macro                ;��o�D��2������
    mov pass_wall, 1
endm

tool3 macro                ;��o�D��3������
    draw_square door_x, door_y, 000FF00h
	push edx
	push aux
	push aux1
	mov edx, door_x
	add edx, 5
	mov aux, edx
	mov edx, door_y
	add edx, 5
	mov aux1, edx
	make_image_macro "f", area, aux, aux1
	pop aux1
	pop aux
	pop edx
endm

next_level macro            ;�����U�@��������
local has_next, nextend
    cmp counterMap, 2
    jne has_next
    win_game
    jmp nextend

    has_next:
    mov bomb_check,0 

    ; �M�ŷ�e�a��
    mov eax, area_width
    mov ebx, area_height
    mul ebx
    shl eax, 2
    push eax
    push 0A7A6A5h            ;��Ӧa�϶�Ǧ�
    push area
    call memset
    add esp, 12

    ; �b�o�̲K�[�ͦ��U�@���a�Ϫ��N�X
    inc counterMap
    call draw

    ; ��s�C�����A�A��ܤU�@���}�l
    mov game_over_check, 0   ; �o�̱N�C�����A�]�m��������

    nextend:

endm

win_game macro                ;�C����Ӫ�����
    mov enemy1_alive,0
    mov enemy2_alive,0
	mov enemy3_alive,0
	mov enemy4_alive,0
    mov enemy5_alive,0
	mov enemy6_alive,0
	mov enemy7_alive,0
    mov enemy8_alive,0
    mov bomb_check,0 

    mov eax, area_width
    mov ebx, area_height
    mul ebx
    shl eax, 2
    push eax
    push 0A7A6A5h            ;��Ӧa�϶�Ǧ�
    push area
    call memset
    add esp, 12

    make_text_macro 'V', area, area_width/2-30, area_height/2
	make_text_macro 'I', area, area_width/2-20, area_height/2
	make_text_macro 'C', area, area_width/2-10, area_height/2
	make_text_macro 'T', area, area_width/2, area_height/2
	make_text_macro 'O', area, area_width/2+10, area_height/2
	make_text_macro 'R', area, area_width/2+20, area_height/2
	make_text_macro 'Y', area, area_width/2+30, area_height/2

    mov game_over_check, 1


endm

game_over macro				;�C������������
	mov enemy1_alive,0
	mov enemy2_alive,0
	mov enemy3_alive,0
	mov enemy4_alive,0
    mov enemy5_alive,0
	mov enemy6_alive,0
	mov enemy7_alive,0
    mov enemy8_alive,0
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
local space, unbreakable, explosion_loop, clear_loop, breakable, crate, defeat, enemy1, enemy2, enemy3, enemy4, enemy5, enemy6, enemy7, enemy8, open_door, take_tool1, take_tool2, take_tool3
    mov ESI, bomb_x
    mov aux1, ESI
    mov ESI, bomb_y
    mov aux2, ESI
	mov aux, 0
	mov ecx, color
	cmp ecx, 0FFFFFFh
	je clear_loop
    
    ;�ھ��C����椣�P���ާ@
    explosion_loop:
    calculate_pozition x,y, diff_x, diff_y
    cmp dword ptr [eax], 0FF69B4h    ;�ĤH1
    je enemy1
    cmp dword ptr [eax], 00069B4h    ;�ĤH2
    je enemy2
	cmp dword ptr [eax], 0AA00CCh    ;�ĤH3
    je enemy3
	cmp dword ptr [eax], 0F2DB94h    ;�ĤH4
    je enemy4
	cmp dword ptr [eax], 01E0ECh    ;�ĤH5
    je enemy5
	cmp dword ptr [eax], 4C004Ah    ;�ĤH6
    je enemy6
	cmp dword ptr [eax], 0BF9000h    ;�ĤH7
    je enemy7
	cmp dword ptr [eax], 0C42E5Bh    ;�ĤH8
    je enemy8
    cmp dword ptr [eax], 0FF0000h    ;���a
    je defeat
    cmp dword ptr [eax], 0A0522Dh    ;�j
    je crate
	cmp dword ptr [eax], 0A0522Eh    ;�j(����)
    je open_door
	cmp dword ptr [eax], 0A0522Ch    ;�j(���D��1)
    je take_tool1
	cmp dword ptr [eax], 0A0532Dh    ;�j(���D��2)
    je take_tool2
	cmp dword ptr [eax], 0A0512Dh    ;�j(���D��3)
    je take_tool3
    cmp dword ptr [eax], 0F59B00h    ;�z��
    je breakable
    cmp dword ptr [eax], 0FFFFFFh    ;��
    jne unbreakable

    breakable:
    add x, diff_x
    add y, diff_y
    draw_square x, y, color
    inc aux
	mov edx, bombrange
    cmp aux, edx
    jne explosion_loop
    jmp unbreakable

	take_tool1:
	add x, diff_x
    add y, diff_y
    draw_square x, y, 0FFFF00h
	push edx
	push aux
	push aux1
	mov edx, x
	add edx, 5
	mov aux, edx
	mov edx, y
	add edx, 5
	mov aux1, edx
	make_image_macro "c", area, aux, aux1
	pop aux1
	pop aux
	pop edx
    jmp unbreakable

	take_tool2:
	add x, diff_x
    add y, diff_y
    draw_square x, y, 073763h
	push edx
	push aux
	push aux1
	mov edx, x
	add edx, 5
	mov aux, edx
	mov edx, y
	add edx, 5
	mov aux1, edx
	make_image_macro "e", area, aux, aux1
	pop aux1
	pop aux
	pop edx
    jmp unbreakable

	take_tool3:
	add x, diff_x
    add y, diff_y
    draw_square x, y, 0CAFFE5h
	push edx
	push aux
	push aux1
	mov edx, x
	add edx, 5
	mov aux, edx
	mov edx, y
	add edx, 5
	mov aux1, edx
	make_image_macro "d", area, aux, aux1
	pop aux1
	pop aux
	pop edx
    jmp unbreakable

    defeat:
    game_over
    jmp unbreakable

    crate:
    jmp space

    open_door:
	add x, diff_x
    add y, diff_y
    draw_square x, y, 000FF00h
	push edx
	push aux
	push aux1
	mov edx, x
	add edx, 5
	mov aux, edx
	mov edx, y
	add edx, 5
	mov aux1, edx
	make_image_macro "f", area, aux, aux1
	pop aux1
	pop aux
	pop edx
    jmp unbreakable

    enemy1:
    mov enemy1_alive,0
    jmp space

    enemy2:
    mov enemy2_alive,0
	jmp space

	enemy3:
    mov enemy3_alive,0
	jmp space

	enemy4:
    mov enemy4_alive,0
	jmp space

	enemy5:
    mov enemy5_alive,0
	jmp space

	enemy6:
    mov enemy6_alive,0
	jmp space

	enemy7:
    mov enemy7_alive,0
	jmp space

	enemy8:
    mov enemy8_alive,0
	jmp space

	space:
	add x, diff_x
    add y, diff_y
    draw_square x, y, 0FFFFFFh
	jmp unbreakable

	clear_loop:
    calculate_pozition x, y, diff_x, diff_y
	cmp dword ptr [eax], 0F59B00h    ;�z��
	jne unbreakable
    add x, diff_x
    add y, diff_y
    draw_square x, y, color
    inc aux
	mov edx, bombrange
    cmp aux, edx
    jne clear_loop

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
	
	mov eax, bomberman_x
	cmp bomb_x, eax
	jne no_defeat
	mov eax, bomberman_y
	cmp bomb_y, eax
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
local canbomb
	cmp counterBomb, 0
	jne canbomb
	cmp counterExplosion, 0
	jne explosion_timer
	cmp last, 0
	jne no_bomb

	
	cmp explosion_check,1
	je explosion_timer
	
	cmp bomb_check,1
	jne no_bomb
	
	;���U���s
	canbomb:
	calculate_pozition bomb_x,bomb_y, 0, 0
	cmp dword ptr [eax], 0h
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
local done, loop_, wall, crate, road, door, tool1, tool2, tool3, enemy1, enemy2, enemy3, enemy4, enemy5, enemy6, enemy7, enemy8, next
;�j����m����P�ɬ�100��(�H��50,50�B50,100�B100,50���n��)
	push ebp
	mov ebp, esp
	pusha

	mov edx, [ebp+arg1] ;�N�ǤJ�Ѽ� arg1 ���ȡ]�Y�n��ܪ��r�š^���J�H�s�� edx ���C
	lea ESI, bomber_man_map
	mov eax, counterMap
	mov ebx, 361
	mul ebx
	add ESI, eax

	loop_:
	cmp byte ptr [esi],0
	je door
	cmp byte ptr [esi],1
	je wall
	cmp byte ptr [esi],2
	je crate
	cmp byte ptr [esi],3
	je road
	cmp byte ptr [esi],4
	je tool1
	cmp byte ptr [esi],5
	je tool2
	cmp byte ptr [esi],6
	je tool3
	cmp byte ptr [esi],7
	je enemy1
	cmp byte ptr [esi],8
	je enemy2
	cmp byte ptr [esi],9
	je enemy3
	cmp byte ptr [esi],10
	je enemy4
	cmp byte ptr [esi],11
	je enemy5
	cmp byte ptr [esi],12
	je enemy6
	cmp byte ptr [esi],13
	je enemy7
	cmp byte ptr [esi],14
	je enemy8
	

	door:
	draw_square map_x, map_y, 0A0522Eh
	mov edx, map_x
	mov door_x, edx
	mov edx, map_y
	mov door_y, edx
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
	
	tool1:
	draw_square map_x, map_y, 0A0522Ch
	jmp next

	tool2:
	draw_square map_x, map_y, 0A0532Dh
	jmp next
	
	tool3:
	draw_square map_x, map_y, 0A0512Dh
	jmp next

	enemy1:
	mov enemy1_alive, 1
	mov eax,map_x
	mov enemy1_x, eax
	mov eax,map_y
	mov enemy1_y, eax
	draw_square map_x, map_y, 0FF69B4h
	mov eax, map_x
	add eax, 5
	mov aux, eax
	mov eax, map_y
	add eax, 5
	mov aux1, eax
	make_image_macro "b", area, aux, aux1
	jmp next
	
	enemy2:
	mov enemy2_alive, 1
	mov eax,map_x
	mov enemy2_x, eax
	mov eax,map_y
	mov enemy2_y, eax
	draw_square map_x, map_y, 00069B4h
	jmp next

	enemy3:
	mov enemy3_alive, 1
	mov eax,map_x
	mov enemy3_x, eax
	mov eax,map_y
	mov enemy3_y, eax
	draw_square map_x, map_y, 0AA00CCh
	jmp next

	enemy4:
	mov enemy4_alive, 1
	mov eax,map_x
	mov enemy4_x, eax
	mov eax,map_y
	mov enemy4_y, eax
	draw_square map_x, map_y, 0F2DB94h
	jmp next

	enemy5:
	mov enemy5_alive, 1
	mov eax,map_x
	mov enemy5_x, eax
	mov eax,map_y
	mov enemy5_y, eax
	draw_square map_x, map_y, 01E0ECh
	jmp next

	enemy6:
	mov enemy6_alive, 1
	mov eax,map_x
	mov enemy6_x, eax
	mov eax,map_y
	mov enemy6_y, eax
	draw_square map_x, map_y, 4C004Ah
	jmp next

	enemy7:
	mov enemy7_alive, 1
	mov eax,map_x
	mov enemy7_x, eax
	mov eax,map_y
	mov enemy7_y, eax
	draw_square map_x, map_y, 0BF9000h
	jmp next

	enemy8:
	mov enemy8_alive, 1
	mov eax,map_x
	mov enemy8_x, eax
	mov eax,map_y
	mov enemy8_y, eax
	draw_square map_x, map_y, 0C42E5Bh
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
done:
	mov bomberman_x, 50
	mov bomberman_y, 50
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
	mov eax, random_aux
	mul bomberman_y
	add eax, bomberman_x
	mov aux1,773	
	mov edx, 0
	div aux1
	mov random_aux, edx
	
	mov eax, random_aux
	mov ebx,2
	mov edx,0
	div ebx
	mov door_seed, edx
	;���edx
	pop edx
	pop ecx
	pop ebx
	pop eax
endm

random macro			;�M�w�H���� (0-4) ������
	mov eax, random_aux
	mul bomberman_y
	add eax, bomberman_x
	mov aux1,773	
	mov edx, 0
	div aux1
	mov random_aux, edx
	
	mov eax, random_aux
	mov ebx, 5;5
	mov edx, 0
	div ebx
	;���edx
endm

enemy1_movement macro		;�M�w�ĤH1��ʪ�����
local up,left,down,right, skip, defeat, reroll, no_movement, reset, kill
	
	inc counterEnemy1
	cmp counterEnemy1, 5
	jne no_movement

	reroll:	
	random
	mov counterEnemy1, 0
	inc counterEnemy_1
	cmp counterEnemy_1, 30
	je no_movement

	cmp edx, 0
	je up
	cmp edx, 1
	je left
	cmp edx, 2
	je down
	cmp edx, 3
	je right
	cmp edx, 4
	je no_movement
	
	up:
	mov aux, 0
	mov aux1, -50
	calculate_pozition enemy1_x,enemy1_y,aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	left:
	mov aux, -50
	mov aux1, 0
	calculate_pozition enemy1_x,enemy1_y,aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	right:
	mov aux, 50
	mov aux1, 0
	calculate_pozition enemy1_x, enemy1_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	down:
	mov aux, 0
	mov aux1, 50
	calculate_pozition enemy1_x, enemy1_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	
	skip:
	mov counterEnemy1, 0
	calculate_pozition enemy1_x, enemy1_y, aux, aux1
	cmp dword ptr [eax], 0FF0000h
	je defeat
	cmp dword ptr [eax], 0F59B00h
	je kill

	calculate_pozition enemy1_x, enemy1_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	
	reset:
	draw_square enemy1_x, enemy1_y, 0FFFFFFh

	mov eax, aux
	add enemy1_x, eax
	mov eax, aux1
	add enemy1_y, eax
	draw_square enemy1_x, enemy1_y, 0FF69B4h
	mov eax, enemy1_x
	add eax, 5
	mov aux, eax
	mov eax, enemy1_y
	add eax, 5
	mov aux1, eax
	make_image_macro "b", area, aux, aux1
	jmp no_movement
	
	defeat:
	game_over
	
	kill:
	calculate_pozition enemy1_x, enemy1_y, aux, aux1
	mov enemy1_alive, 0
	draw_square enemy1_x, enemy1_y, 0FFFFFFh

	no_movement:
	mov counterEnemy_1, 0
endm

enemy2_movement macro		;�M�w�ĤH2��ʪ�����
local up,left,down,right, skip, defeat, reroll, no_movement, reset, kill
	
	inc counterEnemy2
	cmp counterEnemy2, 3
	jne no_movement

	reroll:	
	random
	mov counterEnemy2, 0
	inc counterEnemy_2
	cmp counterEnemy_2, 30
	je no_movement

	cmp edx, 0
	je up
	cmp edx, 1
	je left
	cmp edx, 2
	je down
	cmp edx, 3
	je right
	cmp edx, 4
	je no_movement
	
	up:
	mov aux, 0
	mov aux1, -50
	calculate_pozition enemy2_x,enemy2_y,aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	left:
	mov aux, -50
	mov aux1, 0
	calculate_pozition enemy2_x,enemy2_y,aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	right:
	mov aux, 50
	mov aux1, 0
	calculate_pozition enemy2_x, enemy2_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	down:
	mov aux, 0
	mov aux1, 50
	calculate_pozition enemy2_x, enemy2_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	
	skip:
	mov counterEnemy2, 0
	calculate_pozition enemy2_x, enemy2_y, aux, aux1
	cmp dword ptr [eax], 0FF0000h
	je defeat
	cmp dword ptr [eax], 0F59B00h
	je kill

	calculate_pozition enemy2_x, enemy2_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	
	reset:
	draw_square enemy2_x, enemy2_y, 0FFFFFFh

	mov eax, aux
	add enemy2_x, eax
	mov eax, aux1
	add enemy2_y, eax
	draw_square enemy2_x, enemy2_y, 00069B4h
	mov eax, enemy2_x
	add eax, 5
	mov aux, eax
	mov eax, enemy2_y
	add eax, 5
	mov aux1, eax
	make_image_macro "g", area, aux, aux1
	jmp no_movement
	
	defeat:
	game_over
	
	kill:
	calculate_pozition enemy2_x, enemy2_y, aux, aux1
	mov enemy2_alive, 0
	draw_square enemy2_x, enemy2_y, 0FFFFFFh

	no_movement:
	mov counterEnemy_2, 0
endm

enemy3_movement macro		;�M�w�ĤH3��ʪ�����
local up,left,down,right, skip, defeat, reroll, no_movement, reset, kill
	
	inc counterEnemy3
	cmp counterEnemy3, 7
	jne no_movement

	reroll:	
	random
	mov counterEnemy3, 0
	inc counterEnemy_3
	cmp counterEnemy_3, 5
	je no_movement

	cmp edx, 0
	je up
	cmp edx, 1
	je left
	cmp edx, 2
	je down
	cmp edx, 3
	je right
	cmp edx, 4
	je no_movement
	
	up:
	mov aux, 0
	mov aux1, -50
	calculate_pozition enemy3_x,enemy3_y,aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	left:
	mov aux, -50
	mov aux1, 0
	calculate_pozition enemy3_x,enemy3_y,aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	right:
	mov aux, 50
	mov aux1, 0
	calculate_pozition enemy3_x, enemy3_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	down:
	mov aux, 0
	mov aux1, 50
	calculate_pozition enemy3_x, enemy3_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	
	skip:
	mov counterEnemy3, 0
	calculate_pozition enemy3_x, enemy3_y, aux, aux1
	cmp dword ptr [eax], 0FF0000h
	je defeat
	cmp dword ptr [eax], 0F59B00h
	je kill

	calculate_pozition enemy3_x, enemy3_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	
	reset:
	draw_square enemy3_x, enemy3_y, 0FFFFFFh

	mov eax, aux
	add enemy3_x, eax
	mov eax, aux1
	add enemy3_y, eax
	draw_square enemy3_x, enemy3_y, 0AA00CCh
	mov eax, enemy3_x
	add eax, 5
	mov aux, eax
	mov eax, enemy3_y
	add eax, 5
	mov aux1, eax
	make_image_macro "h", area, aux, aux1
	jmp no_movement
	
	defeat:
	game_over
	
	kill:
	calculate_pozition enemy3_x, enemy3_y, aux, aux1
	mov enemy3_alive, 0
	draw_square enemy3_x, enemy3_y, 0FFFFFFh

	no_movement:
	mov counterEnemy_3, 0
endm

enemy4_movement macro		;�M�w�ĤH4��ʪ�����
local up,left,down,right, skip, defeat, reroll, no_movement, reset, kill
	
	inc counterEnemy4
	cmp counterEnemy4, 2
	jne no_movement

	reroll:	
	random
	mov counterEnemy4, 0
	inc counterEnemy_4
	cmp counterEnemy_4, 30
	je no_movement

	cmp edx, 0
	je up
	cmp edx, 1
	je left
	cmp edx, 2
	je down
	cmp edx, 3
	je right
	cmp edx, 4
	je no_movement
	
	up:
	mov aux, 0
	mov aux1, -50
	calculate_pozition enemy4_x,enemy4_y,aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	left:
	mov aux, -50
	mov aux1, 0
	calculate_pozition enemy4_x,enemy4_y,aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	right:
	mov aux, 50
	mov aux1, 0
	calculate_pozition enemy4_x, enemy4_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	down:
	mov aux, 0
	mov aux1, 50
	calculate_pozition enemy4_x, enemy4_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	
	skip:
	mov counterEnemy4, 0
	calculate_pozition enemy4_x, enemy4_y, aux, aux1
	cmp dword ptr [eax], 0FF0000h
	je defeat
	cmp dword ptr [eax], 0F59B00h
	je kill

	calculate_pozition enemy4_x, enemy4_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	
	reset:
	draw_square enemy4_x, enemy4_y, 0FFFFFFh

	mov eax, aux
	add enemy4_x, eax
	mov eax, aux1
	add enemy4_y, eax
	draw_square enemy4_x, enemy4_y, 0F2DB94h
	mov eax, enemy4_x
	add eax, 5
	mov aux, eax
	mov eax, enemy4_y
	add eax, 5
	mov aux1, eax
	make_image_macro "b", area, aux, aux1
	jmp no_movement
	
	defeat:
	game_over
	
	kill:
	calculate_pozition enemy4_x, enemy4_y, aux, aux1
	mov enemy4_alive, 0
	draw_square enemy4_x, enemy4_y, 0FFFFFFh

	no_movement:
	mov counterEnemy_4, 0
endm

enemy5_movement macro		;�M�w�ĤH5��ʪ�����
local up,left,down,right, skip, defeat, reroll, no_movement, reset, kill
	
	inc counterEnemy5
	cmp counterEnemy5, 5
	jne no_movement

	reroll:	
	random
	mov counterEnemy5, 0
	inc counterEnemy_5
	cmp counterEnemy_5, 10
	je no_movement

	cmp edx, 0
	je up
	cmp edx, 1
	je left
	cmp edx, 2
	je down
	cmp edx, 3
	je right
	cmp edx, 4
	je no_movement
	
	up:
	mov aux, 0
	mov aux1, -50
	calculate_pozition enemy5_x,enemy5_y,aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	left:
	mov aux, -50
	mov aux1, 0
	calculate_pozition enemy5_x,enemy5_y,aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	right:
	mov aux, 50
	mov aux1, 0
	calculate_pozition enemy5_x, enemy5_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	down:
	mov aux, 0
	mov aux1, 50
	calculate_pozition enemy5_x, enemy5_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	
	skip:
	mov counterEnemy5, 0
	calculate_pozition enemy5_x, enemy5_y, aux, aux1
	cmp dword ptr [eax], 0FF0000h
	je defeat
	cmp dword ptr [eax], 0F59B00h
	je kill

	calculate_pozition enemy5_x, enemy5_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	
	reset:
	draw_square enemy5_x, enemy5_y, 0FFFFFFh

	mov eax, aux
	add enemy5_x, eax
	mov eax, aux1
	add enemy5_y, eax
	draw_square enemy5_x, enemy5_y, 01E0ECh
	mov eax, enemy5_x
	add eax, 5
	mov aux, eax
	mov eax, enemy5_y
	add eax, 5
	mov aux1, eax
	make_image_macro "g", area, aux, aux1
	jmp no_movement
	
	defeat:
	game_over
	
	kill:
	calculate_pozition enemy5_x, enemy5_y, aux, aux1
	mov enemy5_alive, 0
	draw_square enemy5_x, enemy5_y, 0FFFFFFh

	no_movement:
	mov counterEnemy_5, 0
endm

enemy6_movement macro		;�M�w�ĤH6��ʪ�����
local up,left,down,right, skip, defeat, reroll, no_movement, reset, kill
	
	inc counterEnemy6
	cmp counterEnemy6, 3
	jne no_movement

	reroll:	
	random
	mov counterEnemy6, 0
	inc counterEnemy_6
	cmp counterEnemy_6, 5
	je no_movement

	cmp edx, 0
	je up
	cmp edx, 1
	je left
	cmp edx, 2
	je down
	cmp edx, 3
	je right
	cmp edx, 4
	je no_movement
	
	up:
	mov aux, 0
	mov aux1, -50
	calculate_pozition enemy6_x,enemy6_y,aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	left:
	mov aux, -50
	mov aux1, 0
	calculate_pozition enemy6_x,enemy6_y,aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	right:
	mov aux, 50
	mov aux1, 0
	calculate_pozition enemy6_x, enemy6_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	down:
	mov aux, 0
	mov aux1, 50
	calculate_pozition enemy6_x, enemy6_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	
	skip:
	mov counterEnemy6, 0
	calculate_pozition enemy6_x, enemy6_y, aux, aux1
	cmp dword ptr [eax], 0FF0000h
	je defeat
	cmp dword ptr [eax], 0F59B00h
	je kill

	calculate_pozition enemy6_x, enemy6_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	
	reset:
	draw_square enemy6_x, enemy6_y, 0FFFFFFh

	mov eax, aux
	add enemy6_x, eax
	mov eax, aux1
	add enemy6_y, eax
	draw_square enemy6_x, enemy6_y, 4C004Ah
	mov eax, enemy6_x
	add eax, 5
	mov aux, eax
	mov eax, enemy6_y
	add eax, 5
	mov aux1, eax
	make_image_macro "h", area, aux, aux1
	jmp no_movement
	
	defeat:
	game_over
	
	kill:
	calculate_pozition enemy6_x, enemy6_y, aux, aux1
	mov enemy6_alive, 0
	draw_square enemy6_x, enemy6_y, 0FFFFFFh

	no_movement:
	mov counterEnemy_6, 0
endm

enemy7_movement macro		;�M�w�ĤH7��ʪ�����
local up,left,down,right, skip, defeat, reroll, no_movement, reset, kill
	
	inc counterEnemy7
	cmp counterEnemy7, 5
	jne no_movement

	reroll:	
	random
	mov counterEnemy7, 0
	inc counterEnemy_7
	cmp counterEnemy_7, 30
	je no_movement

	cmp edx, 0
	je up
	cmp edx, 1
	je left
	cmp edx, 2
	je down
	cmp edx, 3
	je right
	cmp edx, 4
	je no_movement
	
	up:
	mov aux, 0
	mov aux1, -50
	calculate_pozition enemy7_x,enemy7_y,aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	left:
	mov aux, -50
	mov aux1, 0
	calculate_pozition enemy7_x,enemy7_y,aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	right:
	mov aux, 50
	mov aux1, 0
	calculate_pozition enemy7_x, enemy7_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	down:
	mov aux, 0
	mov aux1, 50
	calculate_pozition enemy7_x, enemy7_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	
	skip:
	mov counterEnemy7, 0
	calculate_pozition enemy7_x, enemy7_y, aux, aux1
	cmp dword ptr [eax], 0FF0000h
	je defeat
	cmp dword ptr [eax], 0F59B00h
	je kill

	calculate_pozition enemy7_x, enemy7_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	
	reset:
	draw_square enemy7_x, enemy7_y, 0FFFFFFh

	mov eax, aux
	add enemy7_x, eax
	mov eax, aux1
	add enemy7_y, eax
	draw_square enemy7_x, enemy7_y, 0BF9000h
	mov eax, enemy7_x
	add eax, 5
	mov aux, eax
	mov eax, enemy7_y
	add eax, 5
	mov aux1, eax
	make_image_macro "g", area, aux, aux1
	jmp no_movement
	
	defeat:
	game_over
	
	kill:
	calculate_pozition enemy7_x, enemy7_y, aux, aux1
	mov enemy7_alive, 0
	draw_square enemy7_x, enemy7_y, 0FFFFFFh

	no_movement:
	mov counterEnemy_7, 0
endm

enemy8_movement macro		;�M�w�ĤH8��ʪ�����
local up,left,down,right, skip, defeat, reroll, no_movement, reset, kill
	
	inc counterEnemy8
	cmp counterEnemy8, 5
	jne no_movement

	reroll:	
	random
	mov counterEnemy8, 0
	inc counterEnemy_8
	cmp counterEnemy_8, 2
	je no_movement

	cmp edx, 0
	je up
	cmp edx, 1
	je left
	cmp edx, 2
	je down
	cmp edx, 3
	je right
	cmp edx, 4
	je no_movement
	
	up:
	mov aux, 0
	mov aux1, -50
	calculate_pozition enemy8_x,enemy8_y,aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	left:
	mov aux, -50
	mov aux1, 0
	calculate_pozition enemy8_x,enemy8_y,aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	right:
	mov aux, 50
	mov aux1, 0
	calculate_pozition enemy8_x, enemy8_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	jmp skip
	
	down:
	mov aux, 0
	mov aux1, 50
	calculate_pozition enemy8_x, enemy8_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	
	skip:
	mov counterEnemy8, 0
	calculate_pozition enemy8_x, enemy8_y, aux, aux1
	cmp dword ptr [eax], 0FF0000h
	je defeat
	cmp dword ptr [eax], 0F59B00h
	je kill

	calculate_pozition enemy8_x, enemy8_y, aux, aux1
	cmp dword ptr [eax], 0FFFFFFh
	jne reroll
	
	reset:
	draw_square enemy8_x, enemy8_y, 0FFFFFFh

	mov eax, aux
	add enemy8_x, eax
	mov eax, aux1
	add enemy8_y, eax
	draw_square enemy8_x, enemy8_y, 0C42E5Bh
	mov eax, enemy8_x
	add eax, 5
	mov aux, eax
	mov eax, enemy8_y
	add eax, 5
	mov aux1, eax
	make_image_macro "b", area, aux, aux1
	jmp no_movement
	
	defeat:
	game_over
	
	kill:
	calculate_pozition enemy8_x, enemy8_y, aux, aux1
	mov enemy8_alive, 0
	draw_square enemy8_x, enemy8_y, 0FFFFFFh

	no_movement:
	mov counterEnemy_8, 0
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
	mov eax, bomberman_x
	add eax, 5
	mov aux, eax
	mov eax, bomberman_y
	add eax, 5
	mov aux1, eax
	make_image_macro "a", area, aux, aux1

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
	jne enemy3
	enemy2_movement
	cmp enemy2_alive,1
	jne enemy3
	enemy2_movement
	jmp enemy3
	
	enemy3:
	cmp enemy3_alive,1
	jne enemy4
	enemy3_movement

	enemy4:
	cmp enemy4_alive,1
	jne enemy5
	enemy4_movement

	enemy5:
	cmp enemy5_alive,1
	jne enemy6
	enemy5_movement

	enemy6:
	cmp enemy6_alive,1
	jne enemy7
	enemy6_movement

	enemy7:
	cmp enemy7_alive,1
	jne enemy8
	enemy7_movement

	enemy8:
	cmp enemy8_alive,1
	jne final_draw
	enemy8_movement
	jmp final_draw

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