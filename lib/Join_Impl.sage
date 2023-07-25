import sys
from sage.all import *


#成员加入过程
#成员加入过程
def Join(U,B,A,_S,_P,_H,g,X,SyndromeCalculator,L,n,l,sigma_1,U_i):
#     #random.seed(seed)
 
    
    X_1 = matrix(K_, n, l)
    X_2 = matrix(K_, n, l)
    for j in range(l):
        flag = 0
        while flag == 0:
            u_j = vector(K_,U[:,j].list())
            x_1j = gen_binom_vec(n, sigma_1,K_)
            v_j = u_j + x_1j * B.transpose()
            v_j = vector(K_,v_j)
            x_2j = DecodeNiederreiter(v_j,_S,_P,_H,g,X,SyndromeCalculator,L)
    #         show(x_2j)
            if (v_j ==  x_2j * A.transpose()):
                flag = 1
#                 print(get_weight(x_2j))
    #             show(message_random)
    #             show(message3)
                X_1[:,j] = x_1j
                X_2[:,j] = x_2j
#                 show(X_2[:,j].transpose().str())
#    show(X_1.str())
        
    
    return B*X_1,(X_1,X_2)
        
    
    
    

    
   
        
    
    
    

    
   