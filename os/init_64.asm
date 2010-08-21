; =============================================================================
; BareMetal -- a 64-bit OS written in Assembly for x86-64 systems
; Copyright (C) 2008-2010 Return Infinity -- see LICENSE.TXT
;
; INIT_64
; =============================================================================

align 16
db 'DEBUG: INIT_64  '
align 16


init_64:
	xor rdi, rdi 			; create the 64-bit IDT (at linear address 0x0000000000000000) as defined by Pure64

	; Create exception gate stubs (Pure64 has already set the correct gate markers)
	mov rcx, 32
make_exception_gate_stubs:
	mov rax, exception_gate
	call create_gate
	dec rcx
	jnz make_exception_gate_stubs

	; Create interrupt gate stubs (Pure64 has already set the correct gate markers)
	mov rcx, 256-32
make_interrupt_gate_stubs:
	mov rax, interrupt_gate
	call create_gate
	dec rcx
	jnz make_interrupt_gate_stubs

	; Set up the exception gates for all of the CPU exceptions
	mov rcx, 20
	xor rdi, rdi
	mov rax, exception_gate_00
make_exception_gates:
	call create_gate
	inc rdi
	add rax, 16			; The exception gates are aligned at 16 bytes
	dec rcx
	jnz make_exception_gates

	; Set up the IRQ handlers
	mov rdi, 0x21
	mov rax, keyboard
	call create_gate
	mov rdi, 0x22
	mov rax, cascade
	call create_gate
	mov rdi, 0x28
	mov rax, rtc
	call create_gate
	mov rdi, 0x80
	mov rax, ap_wakeup
	call create_gate
	mov rdi, 0x81
	mov rax, ap_reset
	call create_gate

	; Set up RTC
	; Rate defines how often the RTC interrupt is triggered
	; Rate is a 4-bit value from 1 to 15. 1 = 32768Hz, 6 = 1024Hz, 15 = 2Hz
	; RTC value must stay at 32.768KHz or the computer will not keep the correct time
	; http://wiki.osdev.org/RTC
	mov al, 0x0a
	out 0x70, al
	mov al, 00101101b		; RTC@32.768KHz (0010), Rate@8Hz (1101)
	out 0x71, al
	mov al, 0x0b
	out 0x70, al
	mov al, 01000010b		; Periodic(6), 24H clock(2)
	out 0x71, al
	mov al, 0x0C			; Acknowledge the RTC
	out 0x70, al
	in al, 0x71

	; Disable blink
	mov dx, 0x3DA
	in al, dx
	mov dx, 0x3C0
	mov al, 0x30
	out dx, al
	inc dx
	in al, dx
	and al, 0xF7
	dec dx
	out dx, al

	; Make sure that memory range 0x110000 - 0x200000 is cleared
	mov rdi, os_SystemVariables
	xor rcx, rcx
	xor rax, rax
clearmem:
	stosq
	inc rcx
	cmp rcx, 122880	; Clear 960 KiB
	jne clearmem

	; Build the OS memory table
	

	; Grab data from Pure64's infomap
	mov rsi, 0xf000
	xor rax, rax			; For clearing the high 32-bits
	lodsd				; Pure64 records the 2 APIC addresses as 32-bit
	mov [os_LocalAPICAddress], rax	; Save it for BareMetal as a 64-bit value
	lodsd
	mov [os_IOAPICAddress], rax
	mov rsi, 0xf012
	lodsw
	mov [os_NumCores], ax

	; Initialize all AP's to run our reset code. Skip the BSP
	xor rax, rax
	xor rcx, rcx
	mov rsi, 0x000000000000F700	; Location in memory of the Pure64 CPU data

next_ap:
	cmp rcx, 128			; Enable up to this amount of CPUs
	je no_more_aps
	lodsb				; Load the CPU parameters
	bt rax, 0			; Check if the CPU is enabled
	jnc skip_ap
	bt rax, 1			; Test to see if this is the BSP (Do not init!)
	jc skip_ap
	mov rax, rcx
	call os_smp_reset		; Reset the CPU
skip_ap:
	inc rcx
	jmp next_ap

no_more_aps:	

	; Enable specific interrupts
	in al, 0x21
	mov al, 11111001b		; Enable Cascade, Keyboard
	out 0x21, al
	in al, 0xA1
	mov al, 11111110b		; Enable RTC
	out 0xA1, al

	call os_seed_random		; Seed the RNG

	; Reset keyboard and empty the buffer
	mov al, 0xFF
	out 0x60, al
kbd_wait1:
	in al, 0x64
	bt ax, 1
	jc kbd_wait1
	mov al, 0xF4
	out 0x60, al

ret

; create_gate
; rax = address of handler
; rdi = gate to set up
create_gate:
	push rdi
	push rax
	
	shl rdi, 4	; quickly multiply rdi by 16
	stosw		; store the low word (15..0)
	shr rax, 16
	add rdi, 4	; skip the gate marker
	stosw		; store the high word (31..16)
	shr rax, 32
	stosd		; store the high dword (63..32)

	pop rax
	pop rdi
ret


; =============================================================================
; EOF
