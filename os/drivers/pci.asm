; =============================================================================
; BareMetal -- a 64-bit OS written in Assembly for x86-64 systems
; Copyright (C) 2008-2010 Return Infinity -- see LICENSE.TXT
;
; PCI Functions. http://wiki.osdev.org/PCI
; =============================================================================

align 16
db 'DEBUG: PCI      '
align 16


init_pci:
	xor rcx, rcx

;poo123:
;	xor rax, rax
;	xor rdx, rdx
;	mov eax, [address]
;	mov dx, PCI_CONFIG_PORT_ADDRESS ;0x0CF8
;	out dx, eax
;	add eax, 4
;	mov [address], eax
;	xor rax, rax
;	mov dx, PCI_CONFIG_PORT_DATA
;	in eax, dx
;	call os_dump_rax
;	call os_print_newline
;	inc rcx
;	cmp rcx, 20
;	jne poo123

	xor rdx, rdx
nextdevice:
	cmp rcx, 32
	je pci_End
	inc rcx
	xor rax, rax
	mov eax, [address]
	mov dx, PCI_CONFIG_PORT_ADDRESS
	out dx, eax
	add eax, 0x0800 ; to get the next device
	mov [address], eax
	xor rax, rax
	mov dx, PCI_CONFIG_PORT_DATA
	in eax, dx
	cmp eax, 0xFFFFFFFF	; no device there.. skip it!
	je nextdevice
	shr eax, 24
;	call os_dump_rax
pcicheck00:
	cmp eax, 0
	jne pcicheck01
	mov rsi, pciclass00
	call os_print_string
	jmp nextdevice
pcicheck01:
	cmp eax, 1
	jne pcicheck02
	mov rsi, pciclass01
	call os_print_string
	jmp nextdevice
pcicheck02:
	cmp eax, 2
	jne pcicheck03
	mov rsi, pciclass02
	call os_print_string
	jmp nextdevice
pcicheck03:
	cmp eax, 3
	jne pcicheck04
	mov rsi, pciclass03
	call os_print_string
	jmp nextdevice
pcicheck04:
	cmp eax, 4
	jne pcicheck05
	mov rsi, pciclass05
	call os_print_string
	jmp nextdevice
pcicheck05:
	cmp eax, 5
	jne pcicheck06
	mov rsi, pciclass05
	call os_print_string
	jmp nextdevice
pcicheck06:
	cmp eax, 6
	jne nextdevice
	mov rsi, pciclass06
	call os_print_string
	jmp nextdevice




	jmp nextdevice
	
pci_End:

ret

address dd 10000000000000000000000000001000b
;          /\     /\      /\   /\ /\    /\
;        E    Res    Bus    Dev  F  Reg   0
; Bits
; 31		Enable bit = set to 1
; 30 - 24	Reserved = set to 0
; 23 - 16	Bus number = 256 options
; 15 - 11	Device number = 32 options
; 10 - 8	Function number = will leave at 0 (8 options)
; 7 - 2		Register number = will leave at 0 (64 options) 64 x 4 bytes = 256 bytes worth of accessible registers
; 1 - 0		Set to 0
;


; ---------------------------------------------------------------
; al = busnumber
; bl = devnumber
; cl = func number
; dl = reg number
os_pci_read_reg:

ret
; ---------------------------------------------------------------


; ---------------------------------------------------------------
os_pci_write_reg:

ret
; ---------------------------------------------------------------


; ---------------------------------------------------------------
; eax = device and vendor ID (ie: 0x70008086)
;return = bus and device num
os_pci_find_device:

ret
; ---------------------------------------------------------------


;Configuration Mechanism One has two IO port rages associated with it.
;The address port (0xcf8-0xcfb) and the data port (0xcfc-0xcff).
;A configuration cycle consists of writing to the address port to specify which device and register you want to access and then reading or writing the data to the data port.
;

PCI_CONFIG_PORT_ADDRESS	EQU	0x0CF8
PCI_CONFIG_PORT_DATA	EQU	0x0CFC
pciclass00 db '[Unclassified] ', 0
pciclass01 db '[Mass Storage] ', 0
pciclass02 db '[Network     ] ', 0
pciclass03 db '[Display     ] ', 0
pciclass04 db '[Multimedia  ] ', 0
pciclass05 db '[Memory      ] ', 0
pciclass06 db '[Bridge      ] ', 0


; =============================================================================
; EOF
