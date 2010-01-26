global setjmp
global longjmp

setjmp:

	push	ebp
	mov		ebp, esp

	push	edi
	mov		edi, [ebp+8]

	mov		[edi], eax
	mov		[edi+4], ebx
	mov		[edi+8], ecx
	mov		[edi+12], edx
	mov		[edi+16], esi

	mov		eax, [ebp-4]
	mov		[edi+20], eax

	mov		eax, [ebp+0]
	mov		[edi+24], eax

	mov		eax, esp
	add		eax, 12
	mov 	[edi+28], eax
	
	mov		eax, [ebp+4]
	mov		[edi+32], eax

	pop		edi
	mov		eax, 0
	leave
	ret

longjmp:
	push	ebp
	mov		ebp, esp

	mov		edi, [ebp+8]
	mov		eax, [ebp+12]
	mov		[edi+0], eax

	mov		ebp, [edi+24]

    cli
	mov		esp, [edi+28]
	
	push	long[edi+32]

	mov	eax, [edi+0]
	mov	ebx, [edi+4]
	mov	ecx, [edi+8]
	mov	edx, [edi+12]
	mov	esi, [edi+16]
	mov	edi, [edi+20]
    sti

	ret
