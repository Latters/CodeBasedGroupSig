n = 2048
l = 170
sigma_1 = 0.16
U = pk[0]
B = pk[1]
A = pk[2]

S_A = gmsk[0]
P_A = gmsk[1]
a_0 = gmsk[2]
a = gmsk[3]
g1 = gmsk[4]
#     show(U)
#     show(B)
#     show(A)
#     show(g1)

F = a.parent()
PR = g1.parent()
X = PR.gen()
K_ = a_0.parent()
L = [F(a**i) for i in range(2048)]
SyndromeCalculator = matrix(PR, 1, len(L));
for i in range(len(L)):
    SyndromeCalculator[0, i] = (X - L[i]).inverse_mod(g1);

h = PR(1)
for a_i in L:
    h = h * (X - a_i);
gamma = [];

for a_i in L:
    gamma.append((h * ((X - a_i).inverse_mod(g1))).mod(g1));

t = 32    
H_check_poly = matrix(F, t, n);
for i in range(n):
    coeffs = list(gamma[i]);
    for j in range(t):
        # Check to make sure the coefficient exists
        # (It may not if the polynomial is not of
        # degree t)
        if j < len(coeffs):
            H_check_poly[j, i] = coeffs[j];
        else:
            H_check_poly[j, i] = F(0);

# Construct the binary parity-check matrix for the Goppa code.
# Do so by converting each element of F_2**m to its binary
# representation.
H_Goppa = matrix(K_, 11 * H_check_poly.nrows(), H_check_poly.ncols());
for i in range(H_check_poly.nrows()):
    for j in range(H_check_poly.ncols()):
        be = bin(eval(H_check_poly[i, j]._int_repr()))[2:];
#             be = bin(eval(H[i,j]._int_repr()))[2:];
        be = '0'*(11 - len(be)) + be;
        be = list(be);
        H_Goppa[11 * i:11 * (i + 1), j] = vector(map(int, be));