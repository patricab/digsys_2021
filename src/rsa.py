#!/usr/bin/env python3

# greatest common divisor
def gcd(a, b):
    if (a == 0):
        return b
    return gcd(b % a, a)


# Euler's totient function
def phi(n):
    result = 1
    for i in range(2, n):
        if (gcd(i, n) == 1):
            result += 1
    return result


e = 0
d = 0

message = "a"
print('input:  ' + message)
# check if prime (randomly generate)
# sqrt(p)
p = 53
q = 59
k = 5

M = int.from_bytes(message.encode('utf-8'), 'little')
print('message# in: ' + str(M))
n = p * q

if (M > n):
    print('message to large')

Φ = (p - 1) * (q - 1)

for i in range(1, int(Φ / 2)):
    e = 2 * i + 1
    if (gcd(e, Φ) == 1):
        break

print('encryption key: ' + str(e))

# print('creating encryption key failed')

d = int((k * Φ + 1) / e)
if (d * e % Φ != 1):
    print('creating decryption key failed')

print('decryption key: ' + str(d))
# break

C = M**e % n
M = C**d % n

print('message# out: ' + str(M))

decrypted = M.to_bytes((M.bit_length() + 7) // 8, 'little').decode('utf-8')

print('output: ' + decrypted)
