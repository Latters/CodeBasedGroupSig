import sys
from sage.all import *

# security level parameter
params_id = sys.argv[1]

# load libraries
lib_path = './lib/'
load(lib_path + 'rejection_sampling.py')

# load parameters
load('params' + params_id + '.sage')

# N is the code length, U is the secret key weight, s is the weight of shifted vector.
N=2*n; U=2*u; s=2*u*w
# print parameters
print ('parameters n=%d, u=%d, w=%d, tau=%.8f, Xi=%d' % (n, u, w, tau, Xi))

# compute rejection rate
rate_dict, M = rejection_sampling_rate(N, s, tau, Xi)
print ('The maximal rejection rate = %.8f' % (M))


# save the rejection rate to local file
data_path = './data/' + params_id + '/'
filename = data_path + 'precomp_data' + params_id
save([rate_dict, M], filename)
print ('precomputation saved in file %s.sobj' %(filename))