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
from math import floor


def find_d(n, e):
    """Find decryption key

    Args:
        n (int): modulus
        e (int): encryption key

    Returns:
        int: decryption key
    """
    d = 0
    k = 1
    while d < n:
        d = floor((k * Φ + 1) / e)
        k += 1
        if (modmult(d, e, Φ) == 1):
            return d


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
    notprime = True
    while notprime or (gcd(e, p - 1) != 1):
        p = 2**b + 2**(b - 1) + 2 * randbits(b - 2) + 1
        notprime = not isPrime(p)
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


def modmult(a, b, n):
    """Modular multiplication

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


def modexp(m, key, n):
    """Modular exponentiation

    Args:
        m (int): base (text/cipher)
        key (int): exponent (key)
        n (int): modulus

    Returns:
        int: product (cipher/text)
    """
    key = format(key, 'b')
    c = 1
    p = m
    for i in range(0, len(key)):
        if (key[-1 - i] == '1'):
            c = modmult(c, p, n)
        p = modmult(p, p, n)
    return c


b = 256     # bit size of n

e = 65537   # encryption key

(p, q) = genprimes(b, e)   # randomly generate primes

# p = 1090660992520643446103273789680343
# q = 1162435056374824133712043309728653

print(p)
print(q)

n = p * q   # modulus

print(str(len(format(n, 'b'))) + 'bit encryption')

message = "hello world!"    # message
print('input:  ' + message)

m = int.from_bytes(message.encode('utf-8'), 'little')   # message turned to int
print('message# in: ' + str(m))

if (m > n):
    print('message to large (max :' + str(n/8) + 'characters)')

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
    c = modexp(m, e, n)     # encrypt message m

    # m = c**d % n
    m = modexp(c, d, n)     # decrypt cipher c

    print('message# out: ' + str(m))

    # encode integer to utf-8 string
    decrypted = m.to_bytes((m.bit_length() + 7) // 8, 'little').decode('utf-8')

    print('output: ' + decrypted)
