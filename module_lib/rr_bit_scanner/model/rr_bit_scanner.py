from bitstring import BitArray, Bits  # pip install bitstring


def add1(a):
    # Add one, wrap around at overflow
    return Bits(int=(a.int + 1), length=a.length + 1)[1:]


def sub1(a):
    # Sub one, wrap around at overflow
    return Bits(int=(a.int - 1), length=a.length + 1)[1:]


def or_reduce(a):
    return reduce(lambda x, y: x | y, a)


def create_mask(a):
    # Creates a mask where all bits left of the bit set in the input is set
    # Example for n=4:
    #   0000 -> 0000
    #   0001 -> 1110
    #   0010 -> 1100
    #   0100 -> 1000
    #   1000 -> 0000
    b = BitArray(a.length)  # Mutable..
    for i in xrange(a.length - 1, 0, -1):
        b[i - 1] = b[i] | a[i]
    return b


class rr_bit_scanner(object):
    """Round robin bit scanner where LSB has highest priority."""

    def __init__(self, width):
        super(rr_bit_scanner, self).__init__()
        self.gnt_d1 = Bits(width)
        self.n = width

    def request_mux(self, req):
        # Regular bit scanner (LSB highest priority)
        gnt_umasked = req & add1(~req)
        # Masked version of request
        req_masked = req & create_mask(self.gnt_d1)
        # Regular bit scanner working on masked request
        gnt_masked = req_masked & add1(~req_masked)
        # Choose masked version if any grants given there, else unmasked (i.e.
        # starting over again)
        gnt = gnt_masked if or_reduce(req_masked) else gnt_umasked
        self.gnt_d1 = gnt
        return gnt

    def request_no_mux(self, req):
        # Request concatenated(+) with masked version of request
        # (2n bit wide)
        req_masked = req + (req & create_mask(self.gnt_d1))
        # Regular bit scanner working on masked request
        # (2n bit wide)
        gnt_masked = req_masked & add1(~req_masked)
        # Oring upper(unmasked) and lower(masked) part of grant to
        # get n bit wide gnt.
        gnt = gnt_masked[:self.n] | gnt_masked[self.n:]
        self.gnt_d1 = gnt
        return gnt


n = 4
instance = rr_bit_scanner(n)
for a in range(2**n):
    req = Bits(uint=a, length=n)
    gnt = instance.request_mux(req)
    print('{} -> {}'.format(req.bin, gnt.bin))
