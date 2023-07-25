from sage.all import *
import sys
import hashlib
import random
import math

# n is the ring degree
# n is the ring degree
# n is the ring degree
def random_error(n, num_errors, field):
    """
    Return a random vector of length ``n`` with maximum weight 
    ``num_errors`` belonging to the finite field ``field``
    
    INPUT:
        - ``n`` -- length
        - ``num_errors`` -- maximum weight
        - ``field`` -- finite field
    """
    v = [0] * n
    i = 0
    
    while i < num_errors:
        m = randint(0, len(v)-1)
        v[m] = choice(field.list())
        i += 1

    e = vector(field, v)
    
    return e

def keygen(k,n,l,r,m,t):
    #random.seed(seed)
    U = random_matrix(GF(2), n-k,l)
    B = random_matrix(GF(2), n-k,n)
    show(U)
    show(B)
   
    #constructing trapdoor A
    
    preparse("K1_ =  GF(2, 'a_0')")
    K1_ = GF(2, 'a_0')
    preparse("F1 =  GF(n, 'a')")
    F1 = GF(n, 'a')
    
    preparse("PR1.<X> = PolynomialRing(F1)")
    PR1 = PolynomialRing(F1, names=('X',))
    #PR = PolynomialRing(F,'X')
    X = PR1.gen()
    a_0 = K1_.gen()
    a = F1.gen() # define the generator of the field F
    L1 = [F1(a**i) for i in range(2048)]
   

    # Irreducible polynomial generation

    while True:
        irr_poly = PR1.random_element(t-1)
        irr_poly += X**t
        if irr_poly.is_irreducible():
            break
    g1 = irr_poly
    show(g1)

    h = PR1(1)
    for a_i in L1:
        h = h * (X - a_i);

    gamma = [];

    for a_i in L1:
        gamma.append((h * ((X - a_i).inverse_mod(g1))).mod(g1));
        
    H_check_poly = matrix(F1, t, n);
    for i in range(n):
        coeffs = list(gamma[i]);
        for j in range(t):
            # Check to make sure the coefficient exists
            # (It may not if the polynomial is not of
            # degree t)
            if j < len(coeffs):
                H_check_poly[j, i] = coeffs[j];
            else:
                H_check_poly[j, i] = F1(0);

      # Construct the binary parity-check matrix for the Goppa code.
        # Do so by converting each element of F_2**m to its binary
        # representation.
    H_Goppa_A = matrix(K1_, 11 * H_check_poly.nrows(), H_check_poly.ncols());
    for i in range(H_check_poly.nrows()):
        for j in range(H_check_poly.ncols()):
            be = bin(eval(H_check_poly[i, j]._int_repr()))[2:];
#             be = bin(eval(H[i,j]._int_repr()))[2:];
            be = '0'*(11 - len(be)) + be;
            be = list(be);
            H_Goppa_A[11 * i:11 * (i + 1), j] = vector(map(int, be));

        # Construct the generator matrix for our code by computing
        # a basis for the null-space of H_Goppa_A. The null-space is,
        # by definition, the codewords of our code.
        
        #G_Goppa = H_Goppa_A.right_kernel().basis_matrix();
     
    print("Irreducible polynomial g(x):", g1)
    S_A = random_matrix(GF(2), H_Goppa_A.nrows())
    while (S_A.determinant()==0):
        S_A = random_matrix(GF(2), H_Goppa_A.nrows())

    rng = range(n)

    P_A = matrix(GF(2),n);

    for i in range(n):
        p = floor(len(rng)*random.random());
        P_A[i,rng[p]]=1;
        rng=[*rng[:p], *rng[p+1:]];
    
    A = S_A*H_Goppa_A*P_A
    
    # random permutation matrix
    columns = list(range(n))
    P3 = matrix(K_, n)

    for i in range(n):
        tt = randint(0, len(columns)-1)
        j = columns[tt]
        P3[i,j] = 1
        columns.remove(j)
    
    U = matrix(K_, n-k,l)
    B = matrix(K_, n-k,n)
    # A = NIE.get_public_key()
    B = A * P3
    for j in range(l):
        e_j = random_error(2048, 10, K1_)
        c_j = e_j * A.transpose()
        U[:,j] = c_j
   
   
    preparse("K_ =  GF(2, 'b')")
    K_ = GF(2, 'b')
    preparse("F = GF(m, 'b')")
    F = GF(m, 'b')
    preparse("PR.<Y> = PolynomialRing(F)")
    PR = PolynomialRing(F, names=('Y',))
    #PR = PolynomialRing(F,'X')
    Y = PR.gen()
    b = F.gen() # define the generator of the field F
    L = [F(b**i) for i in range(2048)]
    flag=0
   # Irreducible polynomial generation

        
        while True:
            irr_poly = PR.random_element(t-1)
            irr_poly += Y**t
            if irr_poly.is_irreducible():
                break
        g = irr_poly
        show(g)


    #     # Key generation
    #     T = matrix(F,rango,rango)
    #     for i in range(rango):
    #         count = rango - i
    #         for j in range(rango):
    #             if i > j:
    #                 T[i,j]=g.list()[count]
    #                 count = count + 1
    #             if i < j:
    #                 T[i,j] = 0
    #             if i == j:
    #                 T[i,j] = 1

    #     D = diagonal_matrix([1/g(L[i]) for i in range(N)])
    #     H = T*V*D
    #     H_Goppa_K = matrix(K_, 11*H.nrows(),H.ncols())
    #     #print ("Matriz H_Goppa_K inicial: ")
    #     show(H_Goppa_K)


    h = PR(1)
    for a_i in L:
        h = h * (Y - a_i);

    gamma = [];

    for a_i in L:
        gamma.append((h * ((Y - a_i).inverse_mod(g))).mod(g));

    H_check_poly = matrix(F, t, m);
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

    # Construct the generator matrix for our code by computing
    # a basis for the null-space of H_Goppa. The null-space is,
    # by definition, the codewords of our code.
    G_Goppa = H_Goppa.right_kernel().basis_matrix();
    show(G_Goppa)
    show(H_Goppa)

    print("Irreducible polynomial g(x):", g)
    S = random_matrix(GF(2), r)
    while (S.determinant()==0):
        S = random_matrix(GF(2), r)

    rng = range(m)

    P = matrix(GF(2),m);

    for i in range(m):
        p = floor(len(rng)*random.random());
        P[i,rng[p]]=1;
        rng=[*rng[:p], *rng[p+1:]];
   
    G_pub = S*G_Goppa*P


    return (U,B,A,G_pub),(S_A,P_A,a_0,a,g1,S,P,b,g)

