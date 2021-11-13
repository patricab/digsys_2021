# -*- coding: utf-8 -*-
from sys import argv

def rl_binary(m, key, n):
	key = format(key, '08b')[::-1]
	print('key: ' + key)
	c = 1
	p = m
	print('step 1.')
	print('c: ' +format(c, '0x') + '\tp: ' + format(p, '0x'))
	print('step 2.')
	for i in range(0, len(key)):
		if (key[i] == '1'):
			c = blakely(c, p, n)
		p = blakely(p, p, n)
		print(str(i)+ '\t' + key[i] + '\tc: ' +format(c, '0x') + '\tp: ' + format(p, '0x'))
	return c

def blakely(a, b, n):
	p = 0
	b = format(b, '08b')
	for i in range(0, len(b)):
		p = 2 * p + a * int(b[i])
		if p >= n:
			p -= n
			if p >= n:
				p -= n
		print(format(p, '02x'), end=' ')
	print()
	return p

# m   = 0x26
# key = 0x37
# n   = 0x79

rl_binary(int(argv[1], base=16), int(argv[2], base=16), int(argv[3], base=16))

