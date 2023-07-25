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
#load(lib_path + 'verify_impl.sage')
load(lib_path + 'goppacode.sage')

key_id = '0'
lib_path = './data/'
key_suffix = '80' + '_' + key_id
pk = load(data_path + 'pk')

sign_filename = data_path +  'sign' + key_suffix

signatures = load(sign_filename)


signatures = load(sign_filename)

if verify(sig,pk,n,k,l,w,sigma_1,sigma_2,tau,xi,GF(2)):
    print ('verification succeeds for message "%s"' %(msg))
else:
    print ('verification fails for message "%s"' %(msg))

