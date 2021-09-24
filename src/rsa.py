#!/usr/bin/env python3
from secrets import randbits


def isPrime(n):
    if (n % 2 == 0 or n % 3 == 0):
        return False
    i = 5
    while(i * i <= n):
        if (n % i == 0 or n % (i + 2) == 0):
            return False
        i = i + 6
        return True


def genprime(b):
    p = 4
    notprime = True
    while notprime:
        p = 2**b + 2**(b - 1) + 2 * randbits(b - 2) + 1
        notprime = isPrime(p)
    return p


def genprimes(k):
    k /= 2
    k -= 1
    b = int(k)
    p = genprime(b)
    q = genprime(b)
    return p, q


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


def modmult(a, b, n):
    p = 0
    b = format(b, 'b')
    for i in range(0, len(b)):
        p = 2 * p + a * int(b[i])
        if p >= n:
            p -= n
        if p >= n:
            p -= n
    return p


def modexp(m, key, n):
    key = format(key, 'b')
    c = 1
    p = m
    for i in range(0, len(key)):
        if (key[-1 - i] == '1'):
            c = modmult(c, p, n)
        p = modmult(p, p, n)
    return c


# n, e, d 256bit
b = 256

k = 1  # any integer

e = 0
d = 0.1

# check if prime (randomly generate)
(p, q) = genprimes(b)

# p = 6795469  # large prime
# q = 6799291  # large prime

n = p * q

print(str(len(format(n, 'b'))) + 'bit encryption')

message = "a"
print('input:  ' + message)
m = int.from_bytes(message.encode('utf-8'), 'little')
print('message# in: ' + str(m))

if (m > n):
    print('message to large')

Φ = (p - 1) * (q - 1)  # easy way to find phi(n)

for i in range(2**15 - 1, int(Φ / 2)):
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
    # c = m**e % n
    c = modexp(m, e, n)

    # m = c**d % n
    m = modexp(c, d, n)

    print('message# out: ' + str(m))

    decrypted = m.to_bytes((m.bit_length() + 7) // 8, 'little').decode('utf-8')

    print('output: ' + decrypted)
