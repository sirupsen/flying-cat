; =============================================================================
; BareMetal -- a 64-bit OS written in Assembly for x86-64 systems
; Copyright (C) 2008-2010 Return Infinity -- see LICENSE.TXT
;
; COMMAND LINE INTERFACE
; =============================================================================

align 16
db 'DEBUG: CLI      '
align 16


os_command_line:
	mov rsi, prompt			; Prompt for input
	mov bl, 0x0C			; Black background, Light Red text
	call os_print_string_with_color

	mov rdi, cli_temp_string
	mov rcx, 250			; Limit the input to 250 characters
	call os_input_string
	call os_print_newline		; The user hit enter so print a new line
	jrcxz os_command_line		; os_input_string stores the number of charaters received in RCX

	mov rsi, rdi
	call os_string_parse		; Remove extra spaces
	jrcxz os_command_line		; os_string_parse stores the number of words in RCX
	mov byte [cli_args], cl		; Store the number of words in the string

; Copy the first word in the string to a new string. This is the command/application to run
	xor rcx, rcx
	mov rsi, cli_temp_string
	mov rdi, cli_command_string
	push rdi			; Push the command string
nextbyte:
	inc rcx
	lodsb
	cmp al, ' '	; End of the word
	je endofcommand
	cmp al, 0x00	; End of the string
	je endofcommand
	cmp rcx, 13	; More than 12 bytes
	je endofcommand
	stosb
	jmp nextbyte
endofcommand:
	mov al, 0x00
	stosb		; Terminate the string

; At this point cli_command_string holds at least "a" and at most "abcdefgh.ijk"

	; Break the contents of cli_temp_string into individual strings
	mov rsi, cli_temp_string
	mov al, 0x20
	mov bl, 0x00
	call os_string_change_char

	pop rsi				; Pop the command string
	call os_string_uppercase	; Convert to uppercase for comparison

	mov rdi, cls_string		; 'CLS' entered?
	call os_string_compare
	jc near clear_screen

	mov rdi, dir_string		; 'DIR' entered?
	call os_string_compare
	jc near dir

	mov rdi, ver_string		; 'VER' entered?
	call os_string_compare
	jc near print_ver

	mov rdi, date_string		; 'DATE' entered?
	call os_string_compare
	jc near date

	mov rdi, exit_string		; 'EXIT' entered?
	call os_string_compare
	jc near exit

	mov rdi, help_string		; 'HELP' entered?
	call os_string_compare
	jc near print_help

	mov rdi, time_string		; 'TIME' entered?
	call os_string_compare
	jc near time

	mov rdi, debug_string		; 'DEBUG' entered?
	call os_string_compare
	jc near debug

	mov rdi, reboot_string		; 'REBOOT' entered?
	call os_string_compare
	jc near reboot

	mov rdi, testzone_string	; 'TESTZONE' entered?
	call os_string_compare
	jc near testzone

; At this point it is not one of the built-in CLI functions. Prepare to check the filesystem.
	mov al, '.'
	call os_string_find_char	; Check for a '.' in the string
	cmp rax, 0
	jne full_name			; If there was a '.' then a suffix is present

; No suffix was present so we add the default application suffix of ".APP"
add_suffix:
	call os_string_length
	cmp rcx, 8
	jg fail				; If the string is longer than 8 chars we can't add a suffix

	mov rdi, cli_command_string
	mov rsi, appextension		; '.APP'
	call os_string_append		; Append the extension to the command string

; cli_command_string now contains a full filename
full_name:
	mov rsi, cli_command_string
	mov rdi, programlocation	; We load the program to this location in memory (currently 0x00100000 : at the 2MB mark)
	call os_file_read		; Read the file into memory
	jc fail				; If carry is set then the file was not found

;	mov rbx, [clock_counter]	; Grab the start time
;	mov [clockval], rbx		; Save it

;	call programlocation		; 0x00100000 : at the 2MB mark

	mov rax, programlocation	; 0x00100000 : at the 2MB mark
	xor rbx, rbx			; No arguements required (The app can get them with os_get_argc and os_get_argv)
	call os_smp_enqueue		; Queue the application to run on the next available core
	jmp exit			; The CLI can quit now. IRQ 8 will restart it when the program is finished

;	mov rax, [clock_counter]	; Grab the finish time
;	mov rbx, [clockval]		; Grab the start time
;	sub rax, rbx			; RAX = RAX - RBX
;	shr rax, 3			; Divide by 8

;	mov rdi, cli_temp_string	; Convert time difference to string
;	mov rsi, rdi
;	call os_int_to_string
;	call os_print_string		; Print it
;	call os_print_newline

;	jmp os_command_line		; After the program is finished we go back to the start of the CLI

fail:					; We didn't get a valid command or program name
	mov rsi, not_found_msg
	call os_print_string
	jmp os_command_line

print_help:
	mov rsi, help_text
	call os_print_string
	jmp os_command_line

clear_screen:
	call os_clear_screen
	mov ax, 0x0018
	call os_move_cursor
	jmp os_command_line

print_ver:
	mov rsi, version_msg
	call os_print_string
	jmp os_command_line

dir:
	mov rdi, cli_temp_string
	mov rsi, rdi
	call os_file_get_list
	call os_print_string
	jmp os_command_line

date:
	mov rdi, cli_temp_string
	mov rsi, rdi
	call os_get_date_string
	call os_print_string
	call os_print_newline
	jmp os_command_line

time:
	mov rdi, cli_temp_string
	mov rsi, rdi
	call os_get_time_string
	call os_print_string
	call os_print_newline
	jmp os_command_line

align 16
testzone:
;	xchg bx, bx			; Bochs Magic Breakpoint

;	mov rax, 0x0123456789ABCDEF
;	call os_debug_dump_rax
;	call os_print_newline
;	call os_debug_dump_eax
;	call os_print_newline
;	call os_debug_dump_ax
;	call os_print_newline
;	call os_debug_dump_al
	
;	mov rdi, cli_temp_string
;	mov rcx, 50
;	call os_input_string
;	mov rax, rcx
;	call os_dump_rax
;	call os_print_newline
;	mov rsi, rdi
;	call os_string_parse
;	mov rax, rcx
;	call os_dump_rax
;	call os_print_newline

;	xor rdx, rdx
;loopy:
;	mov rax, 0
;	mov rbx, 10
;	call os_get_random_integer
;
;	mov rdi, cli_temp_string
;	mov rsi, rdi
;	mov rax, rcx
;	call os_int_to_string
;	call os_print_string
;	mov al, ' '
;	call os_print_char
;	add rdx, 1
;	cmp rdx, 100
;	jne loopy
;	call os_print_newline

; Test creation of file
;	mov rdi, cli_temp_string		; Get string from user
;	mov rsi, rdi
;	mov rcx, 12			; Limit the capture of characters to 12
;	call os_input_string
;	call os_print_newline
;	mov rsi, 0x0000000000100000	; Just dump the kernel to the new file
;	mov rdi, cli_temp_string
;	mov rcx, 2048			; Create a 2KiB file
;	call os_file_write

; Test deletion of file
;	mov rdi, cli_temp_string		; Get string from user
;	mov rsi, rdi
;	mov rcx, 12			; Limit the capture of characters to 12
;	call os_input_string
;	call os_print_newline
;	call os_file_delete


;	jc meh
;	mov rsi, rdi
;	call os_print_string
;meh:
;	mov al, '!'
;	call os_print_char

;	mov ax, 0x0050
;	mov rsi, 0x0000000000000000
;	call os_fat16_write_cluster

;	call os_fat16_file_create
;	mov rsi, programlocation
;	call os_fat16_file_write
	
;	call int_filename_convert
;	mov rsi, rdi
	
;	call os_string_parse
;	call os_print_string
;	mov al, '!'
;	call os_print_char
;	call os_print_newline
;
;	mov rax, rcx
;	call os_dump_rax
;	call os_print_newline
;	mov al, 65
;	call os_print_char

;	mov al, 65
;	call os_serial_send

;	mov al, '5'
;	call os_print_char
;	mov rax, 8
;	call os_delay
;	mov al, '4'
;	call os_print_char
;	mov rax, 8
;	call os_delay
;	mov al, '3'
;	call os_print_char
;	mov rax, 8
;	call os_delay
;	mov al, '2'
;	call os_print_char
;	mov rax, 8
;	call os_delay
;	mov al, '1'
;	call os_print_char
;	mov rax, 8
;	call os_delay
;	call os_speaker_beep
;	call os_print_newline

;	ud2
;	xor rax, rax
;	xor rbx, rbx
;	xor rcx, rcx
;	xor rdx, rdx
;	div rax
;	mov rsi, taskdata
;	mov rcx, 256
;	call os_dump_mem
;	call os_print_newline
	jmp os_command_line

;testzone_ap:
;	push rsi
;
;	pop rsi
;	ret

reboot:
	in al, 0x64
	test al, 00000010b	; Wait for an empty Input Buffer
	jne reboot
	mov al, 0xFE
	out 0x64, al		; Send the reboot call to the keyboard controller
	jmp reboot

debug:
	call os_get_argc	; Check the argument number
	cmp al, 1
	je debug_dump_reg	; If it is only one then do a register dump
	mov rcx, 16	
	cmp al, 3		; Did we get at least 3?
	jl noamount		; If not no amount was specified
	mov al, 2
	call os_get_argv	; Get the amount of bytes to display
	call os_string_to_int	; Convert to an integer
	mov rcx, rax
noamount:
	mov al, 1
	call os_get_argv	; Get the starting memory address
	call os_hex_string_to_int
	mov rsi, rax
debug_default:
	call os_debug_dump_mem
	call os_print_newline
	
	jmp os_command_line

debug_dump_reg:
	call os_debug_dump_reg
	jmp os_command_line

exit:
	ret

; Strings
	help_text		db 'Built-in commands: CLS, DATE, DEBUG, DIR, HELP, REBOOT, TIME, VER', 13, 0
	not_found_msg		db 'Command or program not found', 13, 0
	version_msg		db 'BareMetal OS ', BAREMETALOS_VER, 13, 0

	cls_string		db 'CLS', 0
	dir_string		db 'DIR', 0
	ver_string		db 'VER', 0
	date_string		db 'DATE', 0
	exit_string		db 'EXIT', 0
	help_string		db 'HELP', 0
	time_string		db 'TIME', 0
	debug_string		db 'DEBUG', 0
	reboot_string		db 'REBOOT', 0
	testzone_string		db 'TESTZONE', 0


; =============================================================================
; EOF
