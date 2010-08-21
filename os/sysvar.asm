; =============================================================================
; BareMetal -- a 64-bit OS written in Assembly for x86-64 systems
; Copyright (C) 2008-2010 Return Infinity -- see LICENSE.TXT
;
; System Variables
; =============================================================================

align 16
db 'DEBUG: SYSVAR   '
align 16

; Constants
hextable: 		db '0123456789ABCDEF'

; Strings
system_status_header:	db 'BareMetal v0.4.8', 0
readymsg:		db 'BareMetal is ready.', 0
prompt:			db '> ', 0
space:			db ' ', 0
newline:		db 13, 0
appextension:		db '.APP', 0

; Memory addresses
stackbase:		equ 0x0000000000050400	; Address for the base of the stacks (1 KiB in)
hdbuffer0:		equ 0x0000000000070000	; 32768 bytes = 0x70000 -> 0x77FFF
hdbuffer1:		equ 0x0000000000078000	; 32768 bytes = 0x78000 -> 0x7FFFF
cli_temp_string:	equ 0x0000000000080000	; 1024 bytes = 0x80000 -> 0x803FF
os_temp_string:		equ 0x0000000000080400	; 1024 bytes = 0x80400 -> 0x807FF
secbuffer0:		equ 0x0000000000080800	; 512 bytes = 0x80800 -> 0x809FF
secbuffer1:		equ 0x0000000000080A00	; 512 bytes = 0x80A00 -> 0x80BFF
os_KernelStart:		equ 0x0000000000100000	; Location of Kernel Start
os_SystemVariables:	equ 0x0000000000110000	; Location of System Variables (64 KiB in from 1 MiB)
cpustatus:		equ 0x00000000001FEF00	; Location of CPU status data (256 bytes) Bit 0 = Avaiable, Bit 1 = Free/Busy
cpuqueue:		equ 0x00000000001FF000	; Location of CPU Queue. Each queue item is 8 bytes. (4KB before the 2MB mark)
programlocation:	equ 0x0000000000200000	; Location in memory where programs are loaded (the start of 2M)

; DQ
os_LocalAPICAddress:	equ os_SystemVariables + 0
os_IOAPICAddress:	equ os_SystemVariables + 8
os_ClockCounter:	equ os_SystemVariables + 16
os_RandomSeed:		equ os_SystemVariables + 24	; Seed for RNG
screen_cursor_offset:	equ os_SystemVariables + 32
hd1_maxlba:		equ os_SystemVariables + 40	; 64-bit value since at most it will hold a 48-bit value

; DD
cpu_speed:		equ os_SystemVariables + 128	; in MHz
hd1_size:		equ os_SystemVariables + 132	; Size in MiB

; DW
ram_amount:		equ os_SystemVariables + 256	; in MiB
os_NumCores:		equ os_SystemVariables + 258
cpuqueuestart:		equ os_SystemVariables + 260
cpuqueuefinish:		equ os_SystemVariables + 262
os_QueueLen:		equ os_SystemVariables + 264
os_QueueLock:		equ os_SystemVariables + 266	; Bit 0 clear for unlocked, set for locked.

; DB
cursorx:		equ os_SystemVariables + 384	; cursor row location
cursory:		equ os_SystemVariables + 385	; cursor column location
scancode:		equ os_SystemVariables + 386
key:			equ os_SystemVariables + 387
key_shift:		equ os_SystemVariables + 388
screen_cursor_x:	equ os_SystemVariables + 389
screen_cursor_y:	equ os_SystemVariables + 390
hd1_enable:		equ os_SystemVariables + 391	; 1 if the drive is there and enabled
hd1_lba48:		equ os_SystemVariables + 392	; 1 if LBA48 is allowed

os_MemMap:		equ os_SystemVariables + 1024

cpuqueuemax:		dw 256
screen_rows: 		db 25 ; x
screen_cols: 		db 80 ; y
os_show_sysstatus:	db 1

; Function variables
os_debug_dump_reg_stage:	db 0x00

; File System
fat16_FatStart:			dd 0x00000000
fat16_TotalSectors:		dd 0x00000000
fat16_DataStart:		dd 0x00000000
fat16_RootStart:		dd 0x00000000
fat16_PartitionOffset:		dd 0x00000000
fat16_ReservedSectors:		dw 0x0000
fat16_RootDirEnts:		dw 0x0000
fat16_SectorsPerFat:		dw 0x0000
fat16_BytesPerSector:		dw 0x0000
fat16_SectorsPerCluster:	db 0x00
fat16_Fats:			db 0x00


keylayoutlower:
db 0, 0, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 0x0e, 0, 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', 0x1c, 0, 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', 0, '`', 0, 0, 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0, 0, 0, ' ', 0
keylayoutupper:
db 0, 0, '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', 0x0e, 0, 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', 0x1c, 0, 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':', 0, '~', 0, 0, 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '<', '>', '?', 0, 0, 0, ' ', 0
; 0e = backspace
; 1c = enter

os_debug_dump_reg_string00:	db '  A:', 0
os_debug_dump_reg_string01:	db '  B:', 0
os_debug_dump_reg_string02:	db '  C:', 0
os_debug_dump_reg_string03:	db '  D:', 0
os_debug_dump_reg_string04:	db ' SI:', 0
os_debug_dump_reg_string05:	db ' DI:', 0
os_debug_dump_reg_string06:	db ' BP:', 0
os_debug_dump_reg_string07:	db ' SP:', 0
os_debug_dump_reg_string08:	db '  8:', 0
os_debug_dump_reg_string09:	db '  9:', 0
os_debug_dump_reg_string0A:	db ' 10:', 0
os_debug_dump_reg_string0B:	db ' 11:', 0
os_debug_dump_reg_string0C:	db ' 12:', 0
os_debug_dump_reg_string0D:	db ' 13:', 0
os_debug_dump_reg_string0E:	db ' 14:', 0
os_debug_dump_reg_string0F:	db ' 15:', 0
os_debug_dump_reg_string10:	db ' RF:', 0

os_debug_dump_flag_string0:	db ' C:', 0
os_debug_dump_flag_string1:	db ' Z:', 0
os_debug_dump_flag_string2:	db ' S:', 0
os_debug_dump_flag_string3:	db ' D:', 0
os_debug_dump_flag_string4:	db ' O:', 0


cli_command_string:	times 14 db 0
cli_args:		db 0

align 16
this_is_the_end:	db 'This is the end.'

;------------------------------------------------------------------------------

SYS64_CODE_SEL	equ 8		; defined by Pure64

; =============================================================================
; EOF
