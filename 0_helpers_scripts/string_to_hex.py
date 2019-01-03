#!/usr/bin/python
import sys

if len(sys.argv) != 2:
	print "Outputs the given string in reverse hex by 4 bytes\n"
	print "Usage: " + sys.argv[0] + " <string>"
	exit(0)

input = sys.argv[1]

print 'String length : ' +str(len(input)) + '\n'

print "Converted [{opcode} {0x hex} ; {reversed string}] format"
stringList = [input[i:i+4] for i in range(0, len(input), 4)]
for item in stringList[::-1] :
	print 'push 0x' + str(item[::-1].encode('hex')) + ' ; ' + item[::-1]

