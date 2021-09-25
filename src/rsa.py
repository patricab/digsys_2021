#! /usr/bin/env python3

from secrets import randbits
from math import floor


def find_d(n, e):
    d = 0
    k = 1
    while d < n:
        d = floor((k * Φ + 1) / e)
        k += 1
        if (modmult(d, e, Φ) == 1):
            return d


def egcd(a, b):
    x, y, u, v = 0, 1, 1, 0
    while a != 0:
        q, r = b // a, b % a
        m, n = x - u * q, y - v * q
        b, a, x, y, u, v = a, r, u, v, m, n
        gcd = b
    return gcd, x, y


def isPrime(n):
    if (n <= 65537):
        return False
    if (n % 2 == 0 or n % 3 == 0):
        return False
    i = 5
    while(i * i <= n):
        if (n % i == 0 or n % (i + 2) == 0):
            return False
        i = i + 6
        return True


def genprime(b, e):
    p = 4
    notprime = True
    while notprime or (gcd(e, p - 1) != 1):
        p = 2**b + 2**(b - 1) + 2 * randbits(b - 2) + 1
        notprime = not isPrime(p)
    return p


def genprimes(k, e):
    k /= 2
    k -= 1
    b = int(k)
    p = genprime(b, e)
    q = genprime(b, e)
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


b = 256     # n, e, d 256bit

e = 65537

(p, q) = genprimes(b, e)   # randomly generate primes
# p = 1090660992520643446103273789680343
# q = 1162435056374824133712043309728653

print(p)
print(q)

n = p * q

print(str(len(format(n, 'b'))) + 'bit encryption')

message = "hello world!"
print('input:  ' + message)
m = int.from_bytes(message.encode('utf-8'), 'little')
print('message# in: ' + str(m))

if (m > n):
    print('message to large')

Φ = (p - 1) * (q - 1)  # easy way to find phi(n)

# find e encryption key
# for i in range(2**15, int(Φ / 2)):
#     e = 2 * i + 1
#     if (gcd(e, Φ) == 1):
#         break

print('encryption key: ' + str(e))

# find integer d decryption key
d = find_d(n, e)

if d is None:
    g, d, f = egcd(e, Φ)


if (modmult(d, e, Φ) != 1) or (d > n) or (d <= e):
    g, d, f = egcd(e, Φ)

print(len(format(d, 'b')))
print('decryption key: ' + str(d))

if (modmult(d, e, Φ) != 1) or (d > n) or (d <= e):
    print('should be equal to 1: ' + str(modmult(d, e, Φ)))
    print(Φ)
    print('creating decryption key failed')
else:
    # c = m**e % n
    c = modexp(m, e, n)

    # m = c**d % n
    m = modexp(c, d, n)

    print('message# out: ' + str(m))

    decrypted = m.to_bytes((m.bit_length() + 7) // 8, 'little').decode('utf-8')

    print('output: ' + decrypted)
