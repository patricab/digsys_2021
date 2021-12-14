#! /usr/bin/env python3
"""RSA

Attributes:
    b (int): bit size
    message (str): message
    d (int): private decryption key
    e (int): publlic encryption key
    m (int): message convertet to int
    n (int): public modulus
"""

from secrets import randbits
from time import time


# extended euclidian algorithm
def egcd(a, b):
    """Extended Euclidian Algorithm

    Args:
        a (int): integer
        b (int): modulus

    Returns:
        int: Greatest common denominator
        int: modular inverse of a
        int: 0
    """
    x, y, u, v = 0, 1, 1, 0
    while a != 0:
        q, r = b // a, b % a
        m, n = x - u * q, y - v * q
        b, a, x, y, u, v = a, r, u, v, m, n
        gcd = b
    return gcd, x, y


def isPrime(n):
    """Check if prime and larger than e

    Args:
        n (int): possible prime

    Returns:
        bool: True if prime
    """
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
    """Generate coprime of e

    Args:
        b (int): bit size
        e (int): encryption key

    Returns:
        int: Prime
    """
    p = 4
    while not isPrime(p) or (p % e == 1):
        p = 2**b + 2**(b - 1) + 2 * randbits(b - 2) + 1
    return p


def genprimes(k, e):
    """Generate two coprimes of e

    Args:
        k (int): bit size
        e (int): encryption key

    Returns:
        int: two primes
    """
    k /= 2
    k -= 1
    b = int(k)
    p = genprime(b, e)
    q = genprime(b, e)
    return p, q


def gcd(a, b):
    """Finds Greatest common divisor

    Args:
        a (int): number
        b (int): number

    Returns:
        int: greatest common divisor
    """
    if (a == 0):
        return b
    return gcd(b % a, a)


# Euler's totient function
def phi(n):
    """Euler's Totient function Φ(n)

    Args:
        n (int): product of two large primes

    Returns:
        int: number of non factorial integers from 0 to n
    """
    result = 1
    for i in range(2, n):
        if (gcd(i, n) == 1):
            result += 1
    return result


def blakely(a, b, n):
    """Modular multiplication
       Interleaving multiplication and reduction

    p = a * b mod n

    Args:
        a (int): factor
        b (int): factor
        n (int): modulus

    Returns:
        int: congruent
    """
    p = 0
    b = format(b, 'b')
    for i in range(0, len(b)):
        p = 2 * p + a * int(b[i])
        if p >= n:
            p -= n
            if p >= n:
                p -= n
    return p


def MonPro(ā, b̄):
    t = ā * b̄
    m = t * ñ % r
    u = int((t + m * n) / r)
    if (u >= n):
        return u - n
    else:
        return u


def montgomery(M, e, n):
    e = format(e, '0'+ str(b) +'b')
    M̄ = M * r % n
    x̄ = 1 * r % n
    for i in range(0, b):
        x̄ = MonPro(x̄, x̄)
        if (e[i] == '1'):
            x̄ = MonPro(M̄, x̄)
    x = MonPro(x̄, 1)
    return x


"""m-ary method

 s = len(key) / r
64 = 256 / 4


"""
def mary(M, e, n):
    e = format(e, '0' + str(b) + 'b')
    r = 4
    k = len(e)
    s = int(k / r)
    m = [1, M] + [0] * (2**r-2)
    F = [None] * s
    for w in range(2, 2**r):
        m[w] = blakely(m[w-1], M, n)
    for j in range(0, s):
        F[j] = int(e[j*r]+e[j*r+1]+e[j*r+2]+e[j*r+3], 2)
    c = m[F[0]]
    for i in range(1, s): # flipped in string
        for k in range(0, r):
            c = blakely(c, c, n)
        if (F[i] != 0):
            c = blakely(c, m[F[i]], n)
    return c

def rl_binary(m, key, n):
    """Modular exponentiation right to left

    m^key mod n

    Args:
        m (int): base (plain/cipher-text)
        key (int): exponent (key)
        n (int): modulus

    Returns:
        int: product (cipher/plain-text)
    """
    key = format(key, 'b')
    c = 1
    p = m
    for i in range(0, len(key)):
        if (key[-1 - i] == '1'):
            c = blakely(c, p, n)
        p = blakely(p, p, n)
    return c


def lr_binary(m, key, n):
    """Modular exponentioation left to right

    m^key mod n

    Args:
        m (int): base (plain/cipher-text)
        key (int): exponent (en/de-cryption key)
        n (int): modulus (cipher/text)

    Returns:
        int: product (cipher/plain-text)
    """
    key = format(key, 'b')
    c = 1
    if key[-1] == '1':
        c = m
    for i in range(1, len(key)):
        c = blakely(c, c, n)
        if (key[i] == '1'):
            c = blakely(c, m, n)
    return c


b = 256     # bit size of n
b = 12
# e = 65537   # encryption key
e = 17

# p, q = genprimes(b, e)   # randomly generate primes

# p = 1090660992520643446103273789680343
# q = 1162435056374824133712043309728653

p = 61
q = 53

# print(p)
# print(q)

n = p * q   # modulus
# n = 13

# montgomery
# ā = a * r % n
# inv_r * r = 1 % n
# r * inv_r - n * ¨ñ = 1
r = 2**b
(x, inv_r, ñ) = egcd(r, n)
inv_r += n
ñ = r - ñ
#

print(str(len(format(n, 'b'))) + 'bit encryption')

message = "hello world!"    # message
print('input:  ' + message)

m = int.from_bytes(message.encode('utf-8'), 'little')   # message turned to int
print('message# in: ' + str(m))

m = 123

if (m > n):
    print('message to large (max :' + str(n / 8) + 'characters)')

Φ = (p - 1) * (q - 1)  # easy way to find phi(n)

# find e encryption key
# for i in range(2**15, int(Φ / 2)):
#     e = 2 * i + 1
#     if (gcd(e, Φ) == 1):
#         break

print('encryption key: ' + str(e))

# find integer d decryption key
g, d, f = egcd(e, Φ)

while d < 0:
    d += Φ  # make positive integer

print(len(format(d, 'b')))
print('decryption key: ' + str(d))

if (blakely(d, e, Φ) != 1) or (d > n) or (d <= e):
    print('should be equal to 1: ' + str(blakely(d, e, Φ)))
    print(Φ)
    print('creating decryption key failed')
# else:
# c = m**e % n
t0 = time()
c = montgomery(m, e, n)     # encrypt message m
print(c)
t1 = time()
# m = c**d % n
m = montgomery(c, d, n)     # decrypt cipher c
t2 = time()
print('message# out: ' + str(m))

# encode integer to utf-8 string
decrypted = m.to_bytes((m.bit_length() + 7) // 8, 'little').decode('utf-8')

print('output: ' + decrypted)

enc = str((t1-t0)*1000)
dec = str((t2-t1)*1000)
print('encryption: ' + enc + 'ms\n'
      'decryption: ' + dec + 'ms')
