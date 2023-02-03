#!/usr/bin/python
import sys

if len(sys.argv) != 3:
	print("Outputs the given string in reverse ASM hex\n")
	print("Usage: " + sys.argv[0] + " <string> <encoding_char>")
	exit(0)

input = str(sys.argv[1])
enc_byte = str(sys.argv[2])

if len(enc_byte) > 1:
	print("Only use a single character for the encoding byte, exiting...")
	exit(0)

# Function used from https://stackoverflow.com/questions/36242887/how-to-xor-two-strings-in-python/36242949
def xor_two_str(a,b):
    xored = []
    for i in range(max(len(a), len(b))):
        xored_value = ord(a[i%len(a)]) ^ ord(b[i%len(b)])
        xored.append(hex(xored_value)[2:])
    return ''.join(xored)

print('String length: ' + str(len(input)) + ': excluding NULL-terminator\n')
print("Encoding byte: " + enc_byte + " = 0x" + enc_byte.encode().hex() + '\n') 
print("ASM XOR encoded hex [0x01, 0x02, ...] format")

stringList = input
asmList = []
asmList.append('0x' + enc_byte.encode().hex())

try:
	for item in stringList[::-1] :
		xor = xor_two_str(item,enc_byte)
		asmList.append('0x' + xor)
except:
	print("Given encoding character causes errors, try another character.")

asmList = reversed(asmList)
print((", ".join(str(i) for i in asmList)))

