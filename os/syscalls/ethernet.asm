; =============================================================================
; BareMetal -- a 64-bit OS written in Assembly for x86-64 systems
; Copyright (C) 2008-2010 Return Infinity -- see LICENSE.TXT
;
; Ethernet Functions
; =============================================================================

align 16
db 'DEBUG: ETHERNET '
align 16


; Ethernet Type II Frame (64 - 1518 bytes)
; MAC Header (14 bytes)
;	Destination MAC Address (6 bytes)
;	Source MAC Address (6 bytes)
;	EtherType (2 bytes) - BareMetal will use 0x9000
; Payload (46 - 1500 bytes)
; CRC (4 bytes)
; Network card handles the Preamble (8 bytes) and Interframe Gap (12 bytes) ???


; -----------------------------------------------------------------------------
; os_ethernet_rx -- Polls the ethernet card for received data
; IN:	RDI = Memory location where packet will be stored
; OUT:	Carry set if file was not found
os_ethernet_rx:

; Call the poll function of the ethernet card driver

; Was it a multicast packet?
; Was it meant for this computer? If not then dump it (Switching error)
; Strip off the headers

ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_ethernet_tx -- Transmit a packet via ethernet
; IN:	RSI = Memory location where packet is stored
; OUT:	Carry set if file was not found
os_ethernet_tx:

; Call the send function of the ethernet card driver

ret
; -----------------------------------------------------------------------------


; =============================================================================
; EOF
