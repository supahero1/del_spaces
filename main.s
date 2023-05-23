section .data
no_arg		db	"You must provide a string argument.", 10
no_arg_len	equ	$ - no_arg
input		db	"Input: "
input_len	equ	$ - input
output		db	"Output: "
output_len	equ	$ - output
newline		db	10
newline_len	equ	$ - newline

section .text
print:
	push	ebp
	mov	ebp, esp
	push	eax

	mov	eax, 4
	mov	ebx, 1
	mov	ecx, [ebp + 8]
	mov	edx, [ebp + 12]
	int	0x80

	pop	eax
	mov	esp, ebp
	pop	ebp
	ret

str_len:
	push	ebp
	mov	ebp, esp

	mov	eax, [ebp + 8]
	mov	ebx, eax
str_len_loop:
	mov	dl, [eax]
	test	dl, dl
	jz	str_len_end
	inc	eax
	jmp	str_len_loop
str_len_end:
	sub	eax, ebx

	mov	esp, ebp
	pop	ebp
	ret

global main
main:
	push	ebp
	mov	ebp, esp

	mov	eax, [ebp + 8]
	mov	ebx, 2
	cmp	eax, ebx
	jne	err_no_arg

	mov	edi, [ebp + 12]
	mov	esi, [edi + 4]

	push	esi
	call	str_len

	push	input_len
	push	input
	call	print

	mov	[esp + 4], eax
	mov	[esp], esi
	call	print

	mov	[esp + 4], dword newline_len
	mov	[esp], dword newline
	call	print

	mov	ebx, esi
	mov	ecx, esi
	xor	edx, edx
loop:
	mov	dl, [ecx]
	mov	eax, edx
	sub	edx, 0x5F
	test	edx, edx
	jz	skip
	mov	[ebx], al
	inc	ebx
skip:
	test	eax, eax
	jz	end
	inc	ecx
	jmp	loop
end:
	mov	[esp], esi
	call	str_len

	mov	[esp + 4], dword output_len
	mov	[esp], dword output
	call	print

	mov	[esp + 4], eax
	mov	[esp], esi
	call	print

	mov	[esp + 4], dword newline_len
	mov	[esp], dword newline
	call	print

	add	esp, 8
return:
	xor	eax, eax
	mov	esp, ebp
	pop	ebp
	ret

err_no_arg:
	push	no_arg_len
	push	no_arg
	call	print
	add	esp, 8
	jmp	return
