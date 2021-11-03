from bitstring import Bits  # pip install bitstring


def add1(a):
    # Add one, wrap around at overflow
    return Bits(int=(a.int + 1), length=a.length + 1)[1:]


def sub1(a):
    # Sub one, wrap around at overflow
    return Bits(int=(a.int - 1), length=a.length + 1)[1:]


class bit_scanner(object):
    """LSB has highest priority"""

    def __init__(self):
        super(bit_scanner, self).__init__()

    def request_add(self, req):
        return req & add1(~req)

    def request_sub(self, req):
        return req & ~sub1(req)


n = 4
instance = bit_scanner()
for a in range(2**n):
    req = Bits(uint=a, length=n)
    gnt_add = instance.request_add(req)
    gnt_sub = instance.request_sub(req)
    assert gnt_add == gnt_sub
    print('{} -> a:{}, s:{}'.format(req.bin, gnt_add.bin, gnt_sub.bin))
