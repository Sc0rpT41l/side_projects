from sympy.ntheory import factorint
from Crypto.PublicKey import RSA
from Crypto.Util.number import inverse

# These were given
n=340282366920938460843936948965011886881
e=65537

# Calculate p and q (n = p x q, with p and q prime numbers => only one possible combination of p and q)
factors = factorint(n)
p, q = list(factors.keys())
print (f"p = {p}")
print (f"q = {q}")

# Calculate phi with p and q
phi = (p - 1) * (q - 1)
print (f"phi = {phi}")

# Calculate d, private key?
d = inverse(e, phi)
print (f"d = {d}")

# Generates a private key with given parameters
private_key = RSA.construct ((n, e, d, p, q))

with open ("private.pem", "wb") as f:
        f.write(private_key.export_key())
