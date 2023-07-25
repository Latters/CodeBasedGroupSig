def verify(sig,pk,n,k,l,w,sigma_1,sigma_2,tau,xi,field):
    t = sig[0]
    y2 = sig[1]
    z1 = sig[2]
    z2 = sig[3]
    msg = sig[4]
    U = pk[0]
    B = pk[1]
    A = pk[2]
    eta_1 = 0.5 * (1-(1-2*sigma_1)**w)
    eta_2 = 0.5 * (1-(1-2*sigma_2)**w)
    zeta_1 = tau + eta_1 - 2 * tau * eta_1
    zeta_2 = tau + eta_2 - 2 * tau * eta_2
    a_1 = n * zeta_1 - xi
    b_1 = n * zeta_1 + xi
    a_2 = n * zeta_2 - xi
    b_2 = n * zeta_2 + xi
    
#     y2 = vector(field,y2)
    c2 = hash_function_2(l,w,t, y2, msg,field)
    y2_prime = z1 * B.transpose() + z2 * A.transpose() - c2 * U.transpose()
#     y2_prime = vector(field,y2_prime)
    c2_prime = hash_function_2(l,w,t, y2_prime, msg,field)
    
    wt_z1 = get_weight(z1)
    wt_z2 = get_weight(z2)
#     print(y2_prime == y2)
#     print(c2_prime != c2)
    if wt_z1 < int(a_1) or wt_z1 > int(b_1) or wt_z2 < int(a_2) or wt_z2 > int(b_2) or c2_prime != c2:
        return 0
    
    return 1
    