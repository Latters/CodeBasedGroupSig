from sage.all import *
import sys
import hashlib
import random
import math
from itertools import chain

n = 2048
k = 1696
l = 170
sigma_1 = 0.009
sigma_2 = 0.013
w = 17
xi = 20
r = 1696
m = 2048
tau = 0.09
N = 2 ** 6

lib_path = './lib/'
load(lib_path + 'common.sage')
load(lib_path + 'sign_impl.sage')
load(lib_path + 'goppacode.sage')
load(lib_path + 'rejection_sampling.py')

key_id = '0'
lib_path = './data/'
key_suffix = '80' + '_' + key_id
# gmsk = load(data_path + 'sk' + key_suffix)
pk = load(data_path + 'pk')
gpklst = load(data_path + 'gpklst'+ key_suffix)
gsklst = load(data_path + 'gsklst'+ key_suffix)


gpk_i = gpklst[user_i]
gsk_i = gsklst[user_i]

msg = 'INK'
sig = sign(msg,n,k,l,w,sigma_1,sigma_2,tau,xi,pk,gsk_i,GF(2))

key_id = '0'
lib_path = './data/'
key_suffix = '80' + '_' + key_id


filename = data_path + 'sig' + key_suffix
print('secret key saved in file ' + filename + '.sobj')
save(sig, filename)

