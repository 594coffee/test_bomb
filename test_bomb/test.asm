.386					;告訴組譯器使用 80386 或更高版本的指令集
.model flat, stdcall	;flat 表示使用平坦內存模型，stdcall 則表示使用 stdcall 調用慣例。
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;引入的外接函示庫
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

window_title DB "Bomberman",0	;標題
area_width EQU 950				;區域大小寬度
area_height EQU 950				;區域大小長度
area DD 0						;區域起始座標

counter DD 0					;計時器初始為0
counterBomb DD 0				;炸彈計時器初始為0
counterExplosion DD 0			;爆炸計時器初始為0
counterEnemy1 DD 0				;敵人1計時器初始為0
counterEnemy2 DD 0				;敵人2計時器初始為0
counterEnemy3 DD 0				;敵人3計時器初始為0
counterEnemy4 DD 0				;敵人4計時器初始為0
counterEnemy5 DD 0				;敵人5計時器初始為0
counterEnemy6 DD 0				;敵人6計時器初始為0
counterEnemy7 DD 0				;敵人7計時器初始為0
counterEnemy8 DD 0				;敵人8計時器初始為0
counterEnemy_1 DD 0				;敵人1計時器初始為0
counterEnemy_2 DD 0				;敵人2計時器初始為0
counterEnemy_3 DD 0				;敵人3計時器初始為0
counterEnemy_4 DD 0				;敵人4計時器初始為0
counterEnemy_5 DD 0				;敵人5計時器初始為0
counterEnemy_6 DD 0				;敵人6計時器初始為0
counterEnemy_7 DD 0				;敵人7計時器初始為0
counterEnemy_8 DD 0				;敵人8計時器初始為0
counterMap DD 0				;地圖編號初始為0
map_x DD 0
map_y DD 0
door_seed DD 0

arg1 EQU 8						; arg1 - 要顯示的符號（字母或數字）
arg2 EQU 12						; arg2 - 指向像素向量的指針
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

button_up_x EQU area_width - 100	;上按鈕位置
button_up_y EQU area_height - 150

button_left_x EQU area_width - 150	;左按鈕位置
button_left_y EQU area_height - 100

button_down_x EQU area_width - 100	;下按鈕位置
button_down_y EQU area_height - 50

button_right_x EQU area_width - 50	;右按鈕位置
button_right_y EQU area_height - 100

button_bomb_x EQU area_width - 100	;炸彈按鈕位置
button_bomb_y EQU area_height - 100

bomberman_x DD 50		;角色起始位置
bomberman_y DD 50

bomb_check DB 0			;檢查是否可以放置炸彈
bomb_x DD 0				;炸彈位置
bomb_y DD 0	
bombrange DD 2
explosion_check DD 0	;檢查炸彈是否已經爆炸(用於刪除)

enemy1_x DD area_width-100;	;敵人1初始位置
enemy1_y DD area_height-200
enemy1_alive DD 0		;檢查敵人1是否還活著
enemy2_x DD area_width-200	;敵人2初始位置
enemy2_y DD area_height-300;
enemy2_alive DD 0		;檢查敵人2是否還活著
enemy3_x DD area_width-400	;敵人3初始位置
enemy3_y DD area_height-300
enemy3_alive DD 0		;檢查敵人3是否還活著
enemy4_x DD area_width-400	;敵人4初始位置
enemy4_y DD area_height-300
enemy4_alive DD 0		;檢查敵人4是否還活著
enemy5_x DD area_width-400	;敵人5初始位置
enemy5_y DD area_height-300
enemy5_alive DD 0		;檢查敵人5是否還活著
enemy6_x DD area_width-400	;敵人6初始位置
enemy6_y DD area_height-300
enemy6_alive DD 0		;檢查敵人6是否還活著
enemy7_x DD area_width-400	;敵人7初始位置
enemy7_y DD area_height-300
enemy7_alive DD 0		;檢查敵人7是否還活著
enemy8_x DD area_width-400	;敵人8初始位置
enemy8_y DD area_height-300
enemy8_alive DD 0		;檢查敵人8是否還活著

game_over_check DD 0		;檢查玩家是否輸了
pass_wall DD 0              ;檢查是否可以穿牆
lastdoor DD 0               ;儲存人物移動的上一個區塊顏色
lastwall DD 0               ;儲存人物移動的上一個區塊顏色
lasttool1 DD 0              ;儲存人物移動的上一個區塊顏色
lasttool2 DD 0              ;儲存人物移動的上一個區塊顏色
lasttool3 DD 0              ;儲存人物移動的上一個區塊顏色
last DD 0                   ;儲存人物是否站在牆上
door_x DD 0
door_y DD 0

aux DD 0	;輔助變數
aux1 DD 0
aux2 DD 0
random_aux DD 371	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;code
.code
;make_text 程式在給定座標處顯示字母或數字
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

;make_text 程式在給定座標處顯示字母或數字
make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ;將傳入參數 arg1 的值（即要顯示的字符）載入寄存器 eax 中。
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
	mov eax, 26 ;0到25是字母，26是空格
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
	mov edi, [ebp+arg2] ;指向像素數組的指針
	mov eax, [ebp+arg4] ;指向 y 座標的指針
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width														
	mul ebx
	add eax, [ebp+arg3] ;指向 x 座標的指針
	shl eax, 2			;乘以 4，每個像素有一個 DWORD
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

make_image proc ; 畫尼哥圖
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
	mov edi, [ebp+arg2] ;指向像素數組的指針
	mov eax, [ebp+arg4] ;指向 y 座標的指針
	add eax, image_height
	sub eax, ecx
	mov ebx, area_width														
	mul ebx
	add eax, [ebp+arg3] ;指向 x 座標的指針
	shl eax, 2			;乘以 4，每個像素有一個 DWORD
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
make_text_macro macro symbol, drawArea, x, y	;整合呼叫繪製符號的巨集
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

line_horizontal macro x, y, len, color	;畫一條水平線的巨集
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

line_vertical macro x, y, len, color	;畫一條垂直線的巨集
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

draw_square macro x,y, color	;畫一個正方形（使用前面的線）的巨集
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

draw_arrow macro dir,x,y,color	;繪製箭頭的巨集
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

press_button macro x,y,button_x,button_y, diff_x, diff_y	;檢查方向按鈕按下情況的巨集
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
	
	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;遇到敵人1
	cmp dword ptr [eax], 0FF69B4h
	je defeat
	
	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;遇到敵人2
	cmp dword ptr [eax], 00069B4h
	je defeat

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;遇到敵人3
	cmp dword ptr [eax], 0AA00CCh
	je defeat

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;遇到敵人4
	cmp dword ptr [eax], 0F2DB94h
	je defeat

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;遇到敵人5
	cmp dword ptr [eax], 01E0ECh
	je defeat

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;遇到敵人6
	cmp dword ptr [eax], 4C004Ah
	je defeat

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;遇到敵人7
	cmp dword ptr [eax], 0BF9000h
	je defeat

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;遇到敵人8
	cmp dword ptr [eax], 0C42E5Bh
	je defeat

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;遇到門
	cmp dword ptr [eax], 000FF00h
	je to_next

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;遇到道具1
	cmp dword ptr [eax], 0FFFF00h
	je get_tool1

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;遇到道具2
	cmp dword ptr [eax], 073763h
	je get_tool2

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y	;遇到道具3
	cmp dword ptr [eax], 0CAFFE5h
	je get_tool3

	calculate_pozition bomberman_x,bomberman_y,diff_x, diff_y
	cmp pass_wall, 0
	je cantpass
	cmp dword ptr [eax], 0A0522Dh			;遇到牆
	je canpass1
	cmp dword ptr [eax], 0A0522Eh			;遇到牆(門)
	je canpass2
	cmp dword ptr [eax], 0A0522Ch			;遇到牆(道具1)
	je canpass3
	cmp dword ptr [eax], 0A0532Dh			;遇到牆(道具2)
	je canpass4
	cmp dword ptr [eax], 0A0512Dh			;遇到牆(道具3)
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

press_button_bomb macro x,y		;驗證按下炸彈按鈕的巨集
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

calculate_pozition macro x,y,diff_x,diff_y		;根據座標計算位置的巨集
	mov eax, y; eax = y
	add eax, diff_y
	mov ebx, area_width
	mul ebx; eax = y*area_width 
	add eax, x; eax = y*area_width+x
	add eax, diff_x
	shl eax, 2; eax = (y*area_width+x)*4
	add eax, area
endm

tool1 macro                ;獲得道具1的巨集
    inc bombrange
endm

tool2 macro                ;獲得道具2的巨集
    mov pass_wall, 1
endm

tool3 macro                ;獲得道具3的巨集
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

next_level macro            ;切換下一關的巨集
local has_next, nextend
    cmp counterMap, 2
    jne has_next
    win_game
    jmp nextend

    has_next:
    mov bomb_check,0 

    ; 清空當前地圖
    mov eax, area_width
    mov ebx, area_height
    mul ebx
    shl eax, 2
    push eax
    push 0A7A6A5h            ;整個地圖塗成灰色
    push area
    call memset
    add esp, 12

    ; 在這裡添加生成下一關地圖的代碼
    inc counterMap
    call draw

    ; 更新遊戲狀態，表示下一關開始
    mov game_over_check, 0   ; 這裡將遊戲狀態設置為未結束

    nextend:

endm

win_game macro                ;遊戲獲勝的巨集
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
    push 0A7A6A5h            ;整個地圖塗成灰色
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

game_over macro				;遊戲結束的巨集
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
	push 0A7A6A5h			;整個地圖塗成灰色
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

explosion_radius macro x, y, diff_x, diff_y, color        ;受爆炸影響的區域的巨集
local space, unbreakable, explosion_loop, clear_loop, breakable, crate, defeat, enemy1, enemy2, enemy3, enemy4, enemy5, enemy6, enemy7, enemy8, open_door, take_tool1, take_tool2, take_tool3
    mov ESI, bomb_x
    mov aux1, ESI
    mov ESI, bomb_y
    mov aux2, ESI
	mov aux, 0
	mov ecx, color
	cmp ecx, 0FFFFFFh
	je clear_loop
    
    ;根據顏色執行不同的操作
    explosion_loop:
    calculate_pozition x,y, diff_x, diff_y
    cmp dword ptr [eax], 0FF69B4h    ;敵人1
    je enemy1
    cmp dword ptr [eax], 00069B4h    ;敵人2
    je enemy2
	cmp dword ptr [eax], 0AA00CCh    ;敵人3
    je enemy3
	cmp dword ptr [eax], 0F2DB94h    ;敵人4
    je enemy4
	cmp dword ptr [eax], 01E0ECh    ;敵人5
    je enemy5
	cmp dword ptr [eax], 4C004Ah    ;敵人6
    je enemy6
	cmp dword ptr [eax], 0BF9000h    ;敵人7
    je enemy7
	cmp dword ptr [eax], 0C42E5Bh    ;敵人8
    je enemy8
    cmp dword ptr [eax], 0FF0000h    ;玩家
    je defeat
    cmp dword ptr [eax], 0A0522Dh    ;磚
    je crate
	cmp dword ptr [eax], 0A0522Eh    ;磚(有門)
    je open_door
	cmp dword ptr [eax], 0A0522Ch    ;磚(有道具1)
    je take_tool1
	cmp dword ptr [eax], 0A0532Dh    ;磚(有道具2)
    je take_tool2
	cmp dword ptr [eax], 0A0512Dh    ;磚(有道具3)
    je take_tool3
    cmp dword ptr [eax], 0F59B00h    ;爆炸
    je breakable
    cmp dword ptr [eax], 0FFFFFFh    ;路
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
	cmp dword ptr [eax], 0F59B00h    ;爆炸
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

explosion macro x,y, color	;爆炸控制的巨集
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


bomb_mechanism macro		;決定炸彈操作的巨集
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
	
	;按下按鈕
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
	
	explosion bomb_x, bomb_y, 0F59B00h		;爆炸
	
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

create_map macro		;製作地圖的巨集
local done, loop_, wall, crate, road, door, tool1, tool2, tool3, enemy1, enemy2, enemy3, enemy4, enemy5, enemy6, enemy7, enemy8, next
;磚的位置不能同時為100倍(以及50,50、50,100、100,50不要有)
	push ebp
	mov ebp, esp
	pusha

	mov edx, [ebp+arg1] ;將傳入參數 arg1 的值（即要顯示的字符）載入寄存器 edx 中。
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

random_door_seed macro	;決定隨機值 (0-1) 的巨集
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
	;更改edx
	pop edx
	pop ecx
	pop ebx
	pop eax
endm

random macro			;決定隨機值 (0-4) 的巨集
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
	;更改edx
endm

enemy1_movement macro		;決定敵人1行動的巨集
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

enemy2_movement macro		;決定敵人2行動的巨集
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

enemy3_movement macro		;決定敵人3行動的巨集
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

enemy4_movement macro		;決定敵人4行動的巨集
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

enemy5_movement macro		;決定敵人5行動的巨集
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

enemy6_movement macro		;決定敵人6行動的巨集
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

enemy7_movement macro		;決定敵人7行動的巨集
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

enemy8_movement macro		;決定敵人8行動的巨集
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

;繪圖函數 - 每次點擊時都會調用
;或每隔 200 毫秒一次，其中沒有點擊事件
;arg1 - evt（0 - 初始化，1 - 點擊，2 - 未點擊的間隔已過期）
;arg2 - x
;arg3 - y

draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click ;點擊螢幕
	cmp eax, 2
	jz evt_timer ;沒有點擊任何內容
	
	;初始化遊戲區域
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 0A7A6A5h ;將整個地圖塗成灰色00000000h;
	push area
	call memset
	add esp, 12
	
	mov ESI, 50
		
	;繪製垂直和水平白線
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
	
	;完成邊緣
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
	
	;初始化地圖
	create_map
	
	;放置玩家和敵人
	draw_square 50, 50, 0FF0000h
	mov eax, bomberman_x
	add eax, 5
	mov aux, eax
	mov eax, bomberman_y
	add eax, 5
	mov aux1, eax
	make_image_macro "a", area, aux, aux1

	;初始化方向按鈕的區域
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
	;檢查按鈕的按下狀況
	cmp game_over_check,1
	je final_draw
	press_button[ebp+arg2], [ebp+arg3], button_up_x, button_up_y, 0, -50
	press_button [ebp+arg2], [ebp+arg3], button_left_x, button_left_y, -50, 0
	press_button [ebp+arg2], [ebp+arg3], button_down_x, button_down_y, 0, 50
	press_button [ebp+arg2], [ebp+arg3], button_right_x, button_right_y, 50, 0
	press_button_bomb [ebp+arg2], [ebp+arg3]
	
evt_timer:
	;檢查玩家是否輸了
	cmp game_over_check,1
	je final_draw
	
	;檢查炸彈
	inc counter
	bomb_mechanism
	
	;檢查敵人的動向
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
	;為繪圖區分配內存
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	
	;呼叫 BEGIN DRAWING 函數
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;終止程序
	push 0
	call exit
end start