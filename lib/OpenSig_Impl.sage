def openSig(sig,pk,gpklst,g,X,SyndromeCalculator,L,G_Goppa,S,P,l,w,N,field):  
    t = sig[0]
    y2 = sig[1]
    z1 = sig[2]
    z2 = sig[3]
    msg = sig[4]
    B = pk[1]
    
    word = t * P.transpose()
    word_mat = matrix(K_,word)
#         yd = decodePatterson(word_mat,g1,X,SyndromeCalculator,L)
    word_prime = decodePatterson(word_mat,g,X,SyndromeCalculator,L)
    word_prime = vector(K_,word_prime.list())
    m = G_Goppa.solve_left(word_prime)
    m = m * S.inverse()
    
    c1 = m[1696-170:]
    c1 = vector(field,c1)
    c2 = hash_function_2(l,w,t, y2, msg,field)
    
    for i in range(N):
        G_i = gpklst[i]
        if c1 == hash_function_1(l,z1*B.transpose()-c2*G_i.transpose(), msg,field):
            return i
    
    return -1
    
    
    