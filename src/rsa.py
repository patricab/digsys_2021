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


message = "a"
print('input:  ' + message)

p = 11
q = 13

M = int.from_bytes(message.encode('utf-8'), 'little')
print(M)
n = p * q

if (M > n):
    print('message to large')

Φ = (p - 1) * (q - 1)

e = phi(Φ) - 1
if (gcd(e, Φ) != 1):
    print('creating e failed')

d = 1
for d in range(2, Φ):
    if (d * e % Φ == 1):
        break
print(d)

C = M**e % n
M = C**d % n

print(M)

decrypted = M.to_bytes((M.bit_length() + 7) // 8, 'little').decode('utf-8')

print('output: ' + decrypted)
