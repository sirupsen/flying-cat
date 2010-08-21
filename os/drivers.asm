; =============================================================================
; BareMetal -- a 64-bit OS written in Assembly for x86-64 systems
; Copyright (C) 2008-2010 Return Infinity -- see LICENSE.TXT
;
; Driver Includes
; =============================================================================

align 16
db 'DEBUG: DRIVERS  '
align 16


%include "drivers/hdd.asm"
%include "drivers/fat16.asm"
%include "drivers/pci.asm"


; =============================================================================
; EOF
