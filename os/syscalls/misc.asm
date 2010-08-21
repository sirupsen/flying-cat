; =============================================================================
; BareMetal -- a 64-bit OS written in Assembly for x86-64 systems
; Copyright (C) 2008-2010 Return Infinity -- see LICENSE.TXT
;
; Misc Functions
; =============================================================================

align 16
db 'DEBUG: MISC     '
align 16


; -----------------------------------------------------------------------------
; Display Core activity with flashing blocks on screen
; Blocks flash every quarter of a second
system_status:
	push rsi
	push rdi
	push rcx
	push rax

	mov ax, 0x8720			; 0x87 for dark grey background/white foreground, 0x20 for space (blank) character
	mov rdi, 0x00000000000B8000
	mov rcx, 80
	rep stosw

	mov rdi, 0x00000000000B8000
	mov al, '['
	stosb
	add rdi, 1			; Skip the attribute byte
	mov ax, 0x8F63			; 'c'
	stosw
	mov ax, 0x8F70			; 'p'
	stosw
	mov ax, 0x8F75			; 'u'
	stosw
	mov ax, 0x8F3A			; ':'
	stosw	
	add rdi, 2			; Skip to the next char

	xor ecx, ecx
	mov rsi, cpustatus
system_status_cpu_next:
	cmp cx, 256
	je system_status_cpu_done
	add rcx, 1
	lodsb
	bt ax, 0			; Check to see if the Core is Present
	jnc system_status_cpu_next	; If not then check the next
	ror ax, 8			; Exchange AL and AH
	mov al, 0xFE			; Ascii block character
	stosb				; Put the block character on the screen
	rol ax, 8			; Exchange AL and AH
	bt ax, 1			; Check to see if the Core is Ready or Busy
	jc system_status_cpu_busy	; Jump if it is Busy.. otherwise fall through for Idle
	mov al, 0x80			; Black on Dark Gray (Idle Core)
	jmp system_status_cpu_color

system_status_cpu_busy:
	mov rax, [os_ClockCounter]
	bt rax, 0			; Check bit 0. Store bit 0 in CF
	jc system_status_cpu_flash_hi
	mov al, 0x87			; Light Gray on Dark Gray (Active Core Low)
	jmp system_status_cpu_color
system_status_cpu_flash_hi:
	mov al, 0x8F			; White on Dark Gray (Active Core High)
system_status_cpu_color:
	stosb				; Store the color (attribute) byte
	jmp system_status_cpu_next	; Check the next Core

system_status_cpu_done:
	mov al, ']'
	stosb
	add rdi, 1

;	add rdi, 4
;	mov al, '['
;	stosb
;	add rdi, 1
;	mov rax, 0x8F3A8F6D8F658F6D	; 'mem:'
;	stosq
;	add rdi, 2
;
;system_status_mem_next:
;	mov al, 0xFE			; Ascii block character
;	stosb				; Put the block character on the screen
;	mov al, 0x8F			; Light Gray on Blue
;	stosb				; Put the block character on the screen
;	mov al, 0xFE			; Ascii block character
;	stosb				; Put the block character on the screen
;	mov al, 0x87			; Light Gray on Blue
;	stosb				; Put the block character on the screen
;	mov al, 0xFE			; Ascii block character
;	stosb				; Put the block character on the screen
;	mov al, 0x87			; Light Gray on Blue
;	stosb				; Put the block character on the screen
;	mov al, 0xFE			; Ascii block character
;	stosb				; Put the block character on the screen
;	mov al, 0x87			; Light Gray on Blue
;	stosb				; Put the block character on the screen
;	mov al, 0xFE			; Ascii block character
;	stosb				; Put the block character on the screen
;	mov al, 0x87			; Light Gray on Blue
;	stosb				; Put the block character on the screen
;	mov al, 0xFE			; Ascii block character
;	stosb				; Put the block character on the screen
;	mov al, 0x87			; Light Gray on Blue
;	stosb				; Put the block character on the screen
;	mov al, 0xFE			; Ascii block character
;	stosb				; Put the block character on the screen
;	mov al, 0x87			; Light Gray on Blue
;	stosb				; Put the block character on the screen
;	mov al, 0xFE			; Ascii block character
;	stosb				; Put the block character on the screen
;	mov al, 0x87			; Light Gray on Blue
;	stosb				; Put the block character on the screen
;	mov al, ']'
;	stosb
;	add rdi, 1
;
;	add rdi, 4
;	mov al, '['
;	stosb
;	add rdi, 1
;	mov rax, 0x8F3A8F6F8F2F8F69	; 'i/o:'
;	stosq
;	add rdi, 2
;	mov al, '0'
;	stosb
;	add rdi, 1
;
;	mov al, ']'
;	stosb
;	add rdi, 1

	mov rdi, 0x00000000000B8080
	mov rsi, system_status_header
	mov rcx, 16
headernext:
	lodsb
	stosb
	inc rdi
	dec rcx
	cmp rcx, 0
	jne headernext

	pop rax
	pop rcx
	pop rdi
	pop rsi
	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_delay -- Delay by X eights of a second
; IN:	RAX = Time in eights of a second
; OUT:	All registers preserved
; A value of 8 in RAX will delay 1 second and a value of 1 will delay 1/8 of a second
; This function depends on the RTC (IRQ 8) so interrupts must be enabled.
os_delay:
	push rcx
	push rax

	mov rcx, [os_ClockCounter]	; Grab the initial timer counter. It increments 8 times a second
	add rax, rcx			; Add RCX so we get the end time we want
os_delay_loop:
	cmp qword [os_ClockCounter], rax	; Compare it against our end time
	jle os_delay_loop		; Loop if RAX is still lower

	pop rax
	pop rcx
	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_seed_random -- Seed the RNG based on the current date and time
; IN:	Nothing
; OUT:	All registers preserved
os_seed_random:
	push rdx
	push rbx
	push rax

	xor rbx, rbx
	mov al, 0x09		; year
	out 0x70, al
	in al, 0x71
	mov bl, al
	shl rbx, 8
	mov al, 0x08		; month
	out 0x70, al
	in al, 0x71
	mov bl, al
	shl rbx, 8
	mov al, 0x07		; day
	out 0x70, al
	in al, 0x71
	mov bl, al
	shl rbx, 8
	mov al, 0x04		; hour
	out 0x70, al
	in al, 0x71
	mov bl, al
	shl rbx, 8
	mov al, 0x02		; minute
	out 0x70, al
	in al, 0x71
	mov bl, al
	shl rbx, 8
	mov al, 0x00		; second
	out 0x70, al
	in al, 0x71
	mov bl, al
	shl rbx, 16
	rdtsc			; Read the Time Stamp Counter in EDX:EAX
	mov bx, ax		; Only use the last 2 bytes

	mov [os_RandomSeed], rbx	; Seed will be something like 0x091229164435F30A

	pop rax
	pop rbx
	pop rdx
	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_get_random -- Return a random integer
; IN:	Nothing
; OUT:	RAX = Random number
;	All other registers preserved
os_get_random:
	push rdx
	push rbx

	mov rax, [os_RandomSeed]
	mov rdx, 0x23D8AD1401DE7383	; The magic number (random.org)
	mul rdx				; RDX:RAX = RAX * RDX
	mov [os_RandomSeed], rax

	pop rbx
	pop rdx
	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_get_random_integer -- Return a random integer between Low and High (incl)
; IN:	RAX = Low integer
;	RBX = High integer
; OUT:	RCX = Random integer
os_get_random_integer:
	push rdx
	push rbx
	push rax

	sub rbx, rax		; We want to look for a number between 0 and (High-Low)
	call os_get_random
	mov rdx, rbx
	add rdx, 1
	mul rdx
	mov rcx, rdx

	pop rax
	pop rbx
	pop rdx
	add rcx, rax		; Add the low offset back
	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_get_argc -- Return the number arguments passed to the program
; IN:	Nothing
; OUT:	AL = Number of arguments
os_get_argc:
	xor eax, eax
	mov al, [cli_args]
	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_get_argv -- Get the value of an argument that was passed to the program
; IN:	AL = Argument number
; OUT:	RSI = Start of numbered argument string
os_get_argv:
	push rcx
	push rax
	mov rsi, cli_temp_string
	cmp al, 0x00
	je os_get_argv_end
	mov cl, al

os_get_argv_nextchar:
	lodsb
	cmp al, 0x00
	jne os_get_argv_nextchar
	dec cl
	cmp cl, 0
	jne os_get_argv_nextchar
	
os_get_argv_end:
	pop rax
	pop rcx
	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_get_timecounter -- Get the current RTC clock couter value
; IN:	Nothing
; OUT:	RAX = Time in eights of a second since clock started
; This function depends on the RTC (IRQ 8) so interrupts must be enabled.
os_get_timecounter:
	mov rax, [os_ClockCounter]	; Grab the timer counter value. It increments 8 times a second
	ret
; -----------------------------------------------------------------------------

	
; =============================================================================
; EOF
