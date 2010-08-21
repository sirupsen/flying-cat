; =============================================================================
; BareMetal -- a 64-bit OS written in Assembly for x86-64 systems
; Copyright (C) 2008-2010 Return Infinity -- see LICENSE.TXT
;
; Memory functions
; =============================================================================

align 16
db 'DEBUG: MEMORY   '
align 16


; -----------------------------------------------------------------------------
; os_mem_alloc -- Allocates the requested number of 2 MiB blocks
;  IN:	RAX = Number of blocks to allocate
; OUT:	RAX = Starting address
; This function will only allocate continous blocks
os_mem_alloc:

	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_mem_free -- Frees the requested number of 2 MiB blocks
;  IN:	
; OUT:	
os_mem_alloc:

	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_mem_get_free -- Returns the number of 2 MiB blocks that are available
;  IN:	Nothing
; OUT:	RAX = Number of free blocks
os_mem_get_free:

	ret
; -----------------------------------------------------------------------------


; =============================================================================
; EOF
