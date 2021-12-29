%include "asm_io.inc"
%define _malloc  malloc
extern	_malloc

segment .data
	getInputArray_not_implemented		db	"getInputArray not implemented!", 0
	findFirstIndex_not_implemented		db	"findFirstIndex not implemented!", 0
	findAllIndices_not_implemented		db	"findAllIndices not implemented!", 0

segment .text

global getInputArray
global findFirstIndex
global findAllIndices

;;;  Helper function to allocate memory         ;;;
;;;   - arg#1: number of bytes to allocate      ;;;
;;;  returns a pointer to allocated memory zone ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

allocate_memory:
	enter   4,0
	pusha
	pushf

	push    dword [ebp+8]
	call    _malloc
	pop     ecx
	mov     [ebp-4], eax

	popf
	popa
	mov     eax, [ebp-4]
	leave
	ret


;;;  getInputArray function (TO BE IMPLEMENTED)  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

getInputArray:
	enter	0, 0									; size of array in [ebp+8]
	push	ebx
	push	ecx
	push	edx
	
	call	read_int
	mov		ebx, [ebp+8]							; load the int address as a pointer
	mov		[ebx], eax								; save the int
	mov		ebx, eax								; load the int into the register to use for looping
	push	eax										; place the int on the stack for _malloc to use
	call	allocate_memory							; call _malloc to allocate heap for (int) number of bytes
	mov		[esp], dword 0							; clear the stack value for security
	inc		esp										; remove the int from the stack now that we are done using it
	mov		ecx, eax								; load the heap's address as a pointer and keep for reference
	mov		edx, eax								; load the heap's address to use 
gIA_load_loop:
	call	read_int
	mov		[edx], eax								; write the value to the heap
	dec		ebx										; decrement the counter for the loop
	inc		edx										; move to the next heap address in the array
	cmp		ebx, 1									; checking to see if all values have been traversed
	jge		gIA_load_loop							; loop if they haven't
	mov		eax, ecx								; load the heap's starting address as the return value

	pop		ebx
	pop		ecx
	pop		edx
	leave
	ret

;;;  findFirstIndex function (TO BE IMPLEMENTED)  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

findFirstIndex:
	enter	0, 0									; address of the array [ebp+8]
													; size of array in [ebp+12]
													; address of fun [ebp+16]
	push	ebx
	push	ecx
	push	edx

	mov		ebx, [ebp+12]
	mov		ecx, [ebp+8]
	mov		edx, [ebp+16]
fFI_array_loop:
	mov		al, [ecx]								; load the index'd array value into the register
	movzx	eax, al									; format the value to be the correct size
	push	eax										; place the int on the stack to pass to the func
	call	edx										; call the func
	mov		[esp], dword 0							; clear the stack value for security
	inc		esp										; remove the int from the stack
	cmp		eax, 1									; check to see if the func returned 1
	jz		fFI_found								; set the index as the return value and exit if it did
	dec		ebx										; else decrement the counter for the loop
	inc		ecx										; move to the next head address in the array
	cmp		ebx, 1									; check to see if all values have been traversed
	jge		fFI_array_loop							; loop if they haven't
	mov		eax, -1									; set the return value to -1 if they have
	jmp		fFI_end									; exit the subprogram with a return of -1

fFI_found:
	mov		eax, [ebp+12]							; determine the index value where the success occured
	sub		eax, ebx								; and set the index as the return value

fFI_end:
	pop		ebx
	pop		ecx
	pop		edx
	leave
	ret

;;;  findAllIndices function (TO BE IMPLEMENTED)  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

findAllIndices:
	enter	0, 0

	mov	eax, findAllIndices_not_implemented
	call	print_string
	call	print_nl
	mov	eax, -42

	leave
	ret	
