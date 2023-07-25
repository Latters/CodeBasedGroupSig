from sage.all import *
import sys
import hashlib
import random
import math

# security level parameter
params_id = sys.argv[1]

key_id = '0'
if len(sys.argv) > 2:
    key_id = sys.argv[2]

# load libraries
lib_path = './lib/'
load(lib_path + 'common.sage')
load(lib_path + 'keygen_impl.sage')

# load parameters
load('params' + params_id + '.sage')
print ('parameters n=%d, u=%d, w=%d, tau=%.8f, Xi=%d' % (n, u, w, tau, Xi))

pk, sk = keygen(n, u, seed)

data_path = './data/' + params_id + '/'
key_suffix = params_id + '_' + key_id


filename = data_path + 'sk' + key_suffix
print('secret key saved in file ' + filename + '.sobj')
save(sk, filename)

filename = data_path + 'pk' + key_suffix
print ('public key saved in file ' + filename + '.sobj')
save(pk, filename)
