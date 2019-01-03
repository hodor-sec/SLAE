/*
Filename: aes-128-cbc_enc.c
Author: hodorsec
Description: Encrypts a file as input with a given password and outputs in C hex
Compile with: gcc -fno-stack-protector -z execstack -fno-pie -o aes-128-cbc_enc aes-128-cbc_enc.c  -lcrypto -I /usr/include/openssl -L /usr/lib/
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/aes.h>

/* Output encrypted and decrypted */
void print_data(const char *title, const void* data, int len);

/* Read contents of a file as argument */
char *readFile(char *filename);

/* Filesize, global variable across functions */
int fileSize = 0;

/* Do the actual work */
int main(int argc, char **argv)
{
	// Variables
	int lenBits = 128;				// AES bits
	char *shell_in;					// Entered input
	int lenShell;					// Length of shellcode

	// Check args
	if (argc < 2) {
		printf("Usage: %s <shellcode_as_file>\n", argv[0]);
		printf("Enter shellcode as filename argument and password as regular input.\n\n");
		exit(-1);
	}

	// Input
	if (!(shell_in = readFile(argv[1]))) {		// If file does not exist, exit
		printf("Unable to read given file, does it exist?\n\n");
		exit(-1);
	}
	
	lenShell = fileSize;				// Filesize variable
	
	char *enterPass = "Enter password to encrypt: ";
	unsigned char *key = (char*)getpass(enterPass);
	int lenKey = strlen(key);

	// IV
	unsigned char ivEnc[AES_BLOCK_SIZE] = "HODORHODORHODOR!"; // 16 bytes

	// Buffers and padding for encryption and decryption
	const size_t lenEnc = ((lenShell + AES_BLOCK_SIZE) / AES_BLOCK_SIZE) * AES_BLOCK_SIZE;
	unsigned char shell_enc[lenEnc];
	memset(shell_enc, 0, sizeof(shell_enc));

	// Initialize keys
	AES_KEY encKey;
	
	// Encrypt
	// int AES_set_encrypt_key(const unsigned char *userKey, const int bits, AES_KEY *key);
	AES_set_encrypt_key(key, lenBits, &encKey);
	// void AES_cbc_encrypt(const unsigned char *in, unsigned char *out, size_t length, const AES_KEY *key, unsigned char *ivec, const int enc);	
	AES_cbc_encrypt(shell_in, shell_enc, lenEnc, &encKey, ivEnc, AES_ENCRYPT); // AES_ENCRYPT == 1 from <openssl/aes.h>

	// Output
	print_data("\nORIGINAL", shell_in, lenShell);
	print_data("\nENCRYPTED", shell_enc, sizeof(shell_enc));
	printf("\n");
	return 0;
}

char *readFile(char *fileName) {
    FILE *file = fopen(fileName, "r");
    char *code;
    size_t n = 0;
    int c;

    if (file == NULL) return NULL;
    fseek(file, 0, SEEK_END);
    long f_size = ftell(file);
    fseek(file, 0, SEEK_SET);
    code = malloc(f_size);

    while ((c = fgetc(file)) != EOF) {
        code[n++] = (char)c;
	fileSize++;
    }

    code[n] = '\0';        

    return code;
}

void print_data(const char *title, const void* data, int len)
{
	printf("%s:",title);
	const unsigned char * p = (const unsigned char*)data;
	const unsigned char * q = (const unsigned char*)data;
	int i = 0;		// Counter
	int n = 16;		// Print a newline every N char
	
	printf("\nOneliner:\n\"");

	for (; i < len; ++i) {
		if (*p != '\0') {
			printf("\\x%02X", *p++);
		} else
			break;
	}
	printf("\";\n");
	i = 0;
	printf("\n16-byte newline delimiter:\n\"");

	for (; i < len; ++i) {
		if (*q != '\0') {
			if (i % 16 == 0 && i != 0) {
				printf("\"\\\n\"");
			}
			printf("\\x%02X", *q++);
		} else
			break;
	}
	printf("\";\n");
}

