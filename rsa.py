# %%
import math

def phi(p, q):
    return (p-1)*(q-1)

def e_gcd(p):
    e = 2
    while (math.gcd(e, p) != 1):
        if (e < 1 or e > p):
            return 0
        e = e + 1
    return e

def ext_euclid(a, b):
    if a == 0:
        return (b, 0, 1)
    else:
        g, y, x = ext_euclid(b % a, a)
        return (g, x - (b // a) * y, y)

def modinv(a, m):
    g, x, y = ext_euclid(a, m)
    if g != 1:
        raise Exception('modular inverse does not exist')
    else:
        return x % m

def lr_binary(M, e, n):
    k = len(format(e, 'b'))

    C = M if format(e, 'b')[k-1] == '1' else 1

    for i in range(k-2, -1, -1):
        # C = (C * C) % n
        C = mod_mult(C, C, n)
        if (format(e, 'b')[i] == '1'):
            # C = (C * M) % n
            C = mod_mult(C, M, n)
    return C

def mod_mult(a, b, n):
# P = a * b (mod n) // Interleaving multiplication and reduction
    k = 32
    P = 0
    B = '{:032b}'.format(b)
    for i in range(0, k):
        P = 2*P + a * int(B[k-1-i])
        P = P % n
    return P

p = 11
q = 13
# plaintext = "Test"
# data = [ord(i) for i in plaintext]
data = [50]

n = p * q
print ("n: " + str(n))

ph = phi(p, q)
print ("phi: " + str(ph))

# e = e_gcd(ph)
e = 17
print ("e: " + str(e))

d = modinv(e, ph)
print ("d: " + str(d))

C = lr_binary(data[0], e, n)
print ("Cryptotext: " + str(C) + " == " + chr(C))

M = lr_binary(C, d, n)
print ("Plaintext: " + str(M)  + " == " + chr(M) + "\n")

if (M == data[0]):
    print("Encryption succesful")
else:
    print("Encryption not succesful")