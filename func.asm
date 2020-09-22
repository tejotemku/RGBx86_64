section	.text
global  _func, func

_func:
func:
	push rbp
	mov	rbp, rsp
	sub rsp, 200
	push rbx
color:
	; r8 - Ymin
	mov r9, rcx ; r9 - Ymax iterator
	mov r10, rdx ; r10 - right deltas pointer
	mov r11, rsi ; r11 - left deltas pointer
	call vertical_loop
exit:
  	pop rbx
  	add rsp, 200
   	mov rax, rdi
	pop rbp
	ret

vertical_loop:
	;lX
	mov eax, [r11]
	mov ebx, [r11+4]
	sub rax, rbx
	mov [r11], eax
	;address
	mov ebx, [r11]
	mov rax, r9                
	call calc_address
	;lRed
	mov eax, [r11+8]
	mov ebx, [r11+12]
	sub rax, rbx
	mov [r11+8], eax
	;lGreen
	mov eax, [r11+16]
	mov ebx, [r11+20]
	sub rax, rbx
	mov [r11+16], eax
	;lBlue
	mov eax, [r11+24]
	mov ebx, [r11+28]
	sub rax, rbx
	mov [r11+24], eax
        ;rX
        mov eax, [r10]
        mov ebx, [r10+4]
        sub rax, rbx
	mov [r10], eax
        ;rRed
        mov eax, [r10+8]
	mov ebx, [r10+12]
	sub rax, rbx
	mov [r10+8], eax
        ;rGreen
        mov eax, [r10+16]      	
	mov ebx, [r10+20]
        sub rax, rbx
        mov [r10+16], eax
        ;rBlue
        mov eax, [r10+24]
        mov ebx, [r10+28]
        sub rax, rbx
        mov [r10+24], eax


	;pRed
	mov eax, [r11+8]		
	sar eax, 8
	mov edx, [r10+8]
	sar edx, 8
	mov ecx, [r10]
	sar ecx, 8
	mov ebx, [r11]
	sar ebx, 8
	call calc_func
	mov [rbp-16], ebx ;pRed
	mov [rbp-24], eax ;pRedDelta 
	
	;pGreen
        mov eax, [r11+16]
        sar eax, 8
        mov edx, [r10+16]
        sar edx, 8
        mov ecx, [r10]
        sar ecx, 8
        mov ebx, [r11]
        sar ebx, 8
        call calc_func
        mov [rbp-32], ebx ;pGreen
        mov [rbp-40], eax ;pGreenDelta
	
	;pBlue
        mov eax, [r11+24]
        sar eax, 8
        mov edx, [r10+24]
        sar edx, 8
        mov ecx, [r10]
        sar ecx, 8
        mov ebx, [r11]
        sar ebx, 8
        call calc_func
        mov [rbp-48], ebx ;pBlue
        mov [rbp-56], eax ;pBlueDelta
	mov eax, [r11]
	mov [rbp-64], rax
horizontal_loop:
	add rsi, 3
	
	;pBlue 
	mov rax, [rbp-48]
	mov rbx, [rbp-56]
	sub rax, rbx
	mov [rbp-48], rax
	shr rax, 8
	mov [rsi], al
	
	;pGreen
	mov rax, [rbp-32]
	mov rbx, [rbp-40]
	sub rax, rbx
	mov [rbp-32], rax
	shr rax, 8
	mov [rsi+1], al

	;pRed
	mov rax, [rbp-16]
	mov rbx, [rbp-24]
	sub rax, rbx
	mov [rbp-16], rax
	shr rax, 8
	mov [rsi+2], al
	
	mov rax, [rbp-64]
	add rax, 256
	mov [rbp-64], rax
	mov ebx, [r10]	
	cmp rax, rbx
	jle horizontal_loop
	dec r9
	cmp r9, r8
	jge vertical_loop
	ret



 

calc_func:
	sub rcx, rbx
   	mov rbx, 0
	cmp rcx, rbx
    	je if_divider_is_zero
    	mov rbx, rax
    	sal rbx, 8
    	sub rax, rdx
    	sal rax, 8
    	mov rdx, 0
    	cmp rax, 0
    	jge calc_ok
	mov rdx, 0xffffffffffffffff
calc_ok:
    	idiv rcx
    	add rbx, rax
    	ret
if_divider_is_zero:
    	mov rbx, rax
    	sal rbx, 8
    	mov rax, 0
    	ret

calc_address:
    	sal rax, 8
	shr rbx, 8
    	add rax, rbx
    	mov rbx, rax
    	sal rax, 1
    	add rax, rbx
    	add rax, rdi
    	sub rax, 3
    	mov rsi, rax
	ret
