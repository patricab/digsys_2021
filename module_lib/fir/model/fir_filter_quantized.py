# -*- coding: utf-8 -*-

# *****************************************************************************
#
# Author: Øystein Gjermundnes
#
# Purpose:
#   FIR filter
#
# *****************************************************************************
import matplotlib.pyplot as plt
import numpy as np


class fir_filter:

    def __init__(self, filter_coeff):
        self.h = filter_coeff
        self.N = len(filter_coeff)

    # ****************************************************************************
    #
    #          N
    #         ---
    #         \
    # y[n] =   | h[k]x[n-k]
    #         /
    #         ---
    #         k=0
    #
    # ****************************************************************************
    def filter_input(self, x):
        y = []
        # for n in range(len(x) + self.N - 1):  # used if all samples are to be
        # pushed out..
        for n in range(len(x)):
            s = 0
            for k in range(self.N):
                if (n - k) in range(len(x)):  # Zero if out of bounds
                    s += self.h[k] * x[n - k]
            y.append(s)
        return y

# Integer coefficients - 16 bit - converted by
# http://spiral.ece.cmu.edu/mcm/gen.html
h = np.array([101, 1065, 880, -309, -2301, -3185, -771, 5485, 13358,
              18855, 18855, 13358, 5485, -771, -3185, -2301, -309, 880, 1065, 101])

c = fir_filter(h)

n = np.arange(500)
omega = 0.01
noisy_omega = 0.4
x = 0.9 * np.sin(omega * np.pi * n) + 0.1 * np.sin(noisy_omega * np.pi * n)
y = c.filter_input(x)

plt.plot(n, x * 2.0**16, n, y)
plt.show()
