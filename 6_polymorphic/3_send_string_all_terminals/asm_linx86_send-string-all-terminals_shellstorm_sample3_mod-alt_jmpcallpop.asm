global _start
section .text

; execve("/bin//sh", ["/bin//sh", "-c", "echo HODORHODORHODOR! | wall"], [/* 0 vars */])

_start:
	; sys_execve 0x0b
	; int execve(const char *filename, char *const argv[], char *const envp[]);
	push   0xb			; sys_execve call 0x0b
	pop    eax			; Put into EAX
	cdq    				; Convert double to quad word, extends signbit of EAX into EDX
	;push   edx			; Put NULL onto stack for string termination
	;push   0x6c6c6177		; 'wall'
	;push   0x207c2021		; '! | '
	;push 0x524f444f 		; RODO
	;push 0x48524f44 		; HROD
	;push 0x4f48524f 		; OHRO
	;push 0x444f4820 		; DOH 
	;push   0x6f686365		; 'echo'
	;mov    esi,esp			; Put reference for string pointing by stackpointer, into ESI
	jmp argument

append:
	pop esi
	push   edx			; Terminate string with NULL
	push word  0x632d		; '-c'
	mov    ecx,esp			; Put reference for string pointing by stackpointer, into ECX
	push   edx			; Terminate string with NULL
	push   0x68732f2f		; '//sh'
	push   0x6e69622f		; '/bin'
	mov    ebx,esp			; Put reference for string pointing by stackpointer, into EBX
	push   edx			; Terminate string with NULL
	push   esi			; Push sh argument
	push   ecx			; Push '-c' string
	push   ebx			; Push '//bin/sh' string
	mov    ecx,esp			; Put reference to all strings into ECX, pointed by stackpointer
	int    0x80			; syscall

argument:
	call append
	stringy: db "echo HODORHODORHODOR! | wall"

