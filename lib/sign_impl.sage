import random

def sign( msg,n,k,l, w,sigma_1,sigma_2, tau,xi,pk,gsk,field):
#     random.seed(msg)
    X_i1 = gsk[0]
    X_i2 = gsk[1]
#     U = pk[0]
    B = pk[1]
    A = pk[2]
    G_pub = pk[3]
    
#     R=PolynomialRing(GF(2), 'x', implementation='NTL');x=R.gen();S=R.quotient(x^n-1, 'a');a = S.gen()
#     h = S(pk)
#     s1_lst, s2_lst = sk
#     s1 = S(s1_lst); s2 = S(s2_lst)
    counter = 0
    eta_1 = 0.5 * (1-(1-2*sigma_1)**w)
    eta_2 = 0.5 * (1-(1-2*sigma_2)**w)
    zeta_1 = tau + eta_1 - 2 * tau * eta_1
    zeta_2 = tau + eta_2 - 2 * tau * eta_2
    a_1 = n * zeta_1 - xi
    b_1 = n * zeta_1 + xi
    a_2 = n * zeta_2 - xi
    b_2 = n * zeta_2 + xi
    print(a_1,b_1,a_2,b_2)
    while True:
        counter = counter + 1
#         if counter > 5000:
#             print ('Run signing too many times')
        
        e1 = gen_binom_vec(n, tau,field)
        e2 = gen_binom_vec(n, tau,field)
        y1 = e1 * B.transpose()
        y2 = e1 * B.transpose() + e2 * A.transpose()
        c1 = hash_function_1(l, y1, msg,field)
        r  = random_word(k - l, field)
        err = random_error(n, 32, field)
        t = vector(chain(r,c1)) * G_pub + err
        c2 = hash_function_2(l,w,t, y2, msg,field)
        z1 = e1 + c2 * X_i1.transpose()
        z2 = e2 + c2 * X_i2.transpose()
        wt_z1 = get_weight(z1)
        wt_z2 = get_weight(z2)
        print(wt_z1,wt_z2)
 
        
        # compute rejection rate
        rate_dict1, M1 = rejection_sampling_rate(n, get_weight(c2 * X_i1.transpose()), zeta_1, xi)
        rate_dict2, M2 = rejection_sampling_rate(n, get_weight(c2 * X_i2.transpose()), zeta_2, xi)
        

        if wt_z1 < int(a_1) or wt_z1 > int(b_1) or wt_z2 < int(a_2) or wt_z2 > int(b_2):
            continue

        if random.random() < rate_dict1[wt_z1]/M1 and random.random() < rate_dict2[wt_z2]/M2:
            print(counter)
            return (t, y2, z1, z2, msg)

