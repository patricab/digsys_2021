#!/usr/bin/env python3

# from math import ceil

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


def ModExpOp(m, key, n):
    c = 0
    key = format(key, 'b')
    print(key)
    if (key[-1] == 1):
        c = m
    else:
        c = 1
    print(c)

    for i in range(len(key) - 2, -1, -1):
        c = c * c % n
        print(c)
        if (key[i] == 1):
            c = c * m % n
            print(c)
    return c


# n, e, d 256bit
e = 0
d = 0.1


message = "a"
print('input:  ' + message)

p = 673982395699  # large prime
q = 773982392009  # large prime
# check if prime (randomly generate)
# sqrt(p)
k = 1   # any integer

M = int.from_bytes(message.encode('utf-8'), 'little')
print('message# in: ' + str(M))
n = p * q
print(len(format(n, 'b')))

if (M > n):
    print('message to large')

Φ = (p - 1) * (q - 1)  # easy way to find phi(n)

for i in range(int(Φ / 2**32), int(Φ / 2)):
    e = 2 * i + 1
    if (gcd(e, Φ) == 1):
        break

print('encryption key: ' + str(e))

# find integer d decryption key
while (d != int(d) & int(d) < n):
    d = (k * Φ + 1) / e
    k += 1
d = int(d)  # turn d into integer

print('decryption key: ' + str(d))
if ((d * e) % Φ != 1) | (d > n):
    print((d * e) % Φ)
    # print(n - d)
    print('creating decryption key failed')
else:
    # C = M**e % n
    C = pow(M, e, n)

    # M = C**d % n
    M = pow(C, d, n)

    print('message# out: ' + str(M))

    decrypted = M.to_bytes((M.bit_length() + 7) // 8, 'little').decode('utf-8')

    print('output: ' + decrypted)
