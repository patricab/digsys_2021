-- p and q are large primes
-- n = p * q
-- n > M
-- C = M^e
-- M = C^d

gcd : process (a, b, reset, clock)
begin
	if (reset = '1') then

	elsif (rising_edge(clock)) then
		if (a == 0) then
			gcd := b;
		else
			next_b := a mod b;
			next_a := b;
		end if;
	end if;
	a := next_a;
	b := next_b;
end process gcd;

M := 50

M^e mod n

C := 1
P := M

for i=0 to k-1
	if ei = 1
		C := C*P
	P := P*P
return C



A * B mod n

P = 0
for i=0 to k-1
	P = 2*P + A*B[k1-i]
	if P >= N
		P = P - N
	if P >= N
		P = P - N
	return P