from sage.all import *
import sys
import hashlib
import random
import math
from sage.coding.linear_code import AbstractLinearCode
from sage.coding.encoder import Encoder
from sage.coding.decoder import Decoder
from sys import getsizeof as getsize

def gen_binom_vec(n, tau, field):
    v= [1 if random.random()<tau else 0 for _ in range(n)]
    v = vector(field,v)
    return v

def random_word(n, field):
    """
    Return a random vector of length ``n`` belonging to the 
    finite field ``field``
    
    INPUT:
        - ``n`` -- length
        - ``field``-- finite field
    """
    v = []

    while len(v) != n:
        v = v + [choice(field.list())]

    word = vector(field, v)
    
    return word
    
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

def algoritmo_euclides_extendido(self, other):
    delta = self.degree()

    if other.is_zero():
        ring = self.parent()
        return self, R.one(), R.zero()

    ring = self.parent()
    a = self
    b = other

    s = ring.one()
    t = ring.zero()

    resto0 = a
    resto1 = b

    while true:
        cociente,resto_auxiliar = resto0.quo_rem(resto1)
        resto0 = resto1
        resto1 = resto_auxiliar

        s = t
        t = s - t*cociente

        if resto1.degree() <= floor((delta-1)/2) and resto0.degree() <= floor((delta)/2):
             break

    V = (resto0-a*s)//b
    coeficiente_lider = resto0.leading_coefficient()

    return resto0/coeficiente_lider, s/coeficiente_lider, V/coeficiente_lider


def descomponer_polinomio(p):

    Phi1 = p.parent()

    p0 = Phi1([sqrt(c) for c in p.list()[0::2]])
    p1 = Phi1([sqrt(c) for c in p.list()[1::2]])
    return (p0,p1)

def inversa_g(p,g):
    (d,u,v) = xgcd(p,g)
    return u.mod(g)

def _norm(a, b,X):
    # This is the way in which Bernstein indicates
    # the norm of a member of the lattice is
    # to be defined.
    return 2 ** ((a ** 2 + X * b ** 2).degree());

def _lattice_basis_reduce(s,g,X):
    t = g.degree();

    a = [];
    a.append(0);
    b = [];
    b.append(0);
    (q, r) = g.quo_rem(s);
    (a[0], b[0]) = simplify((g - q * s, 0 - q))

    # If the norm is already small enough, we
    # are done. Otherwise, intialize the base
    # case of the recursive process.
    if _norm(a[0], b[0],X) > 2 ** t:
        a.append(0);
        b.append(0);
        (q, r) = s.quo_rem(a[0]);
        (a[1], b[1]) = (r, 1 - q * b[0]);
    else:
        return (a[0], b[0]);

    # Continue subtracting integer multiples of
    # the shorter vector from the longer until
    # the produced vector has a small enough norm.
    i = 1;
    while _norm(a[i], b[i],X) > 2 ** t:
        a.append(0);
        b.append(0);
        (q, r) = a[i - 1].quo_rem(a[i]);
        (a[i + 1], b[i + 1]) = (r, b[i - 1] - q * b[i]);
        i += 1;

    return (a[i], b[i]);
 
def get_weight(c):
    """
    Return the weight of ``c``
    
    INPUT:
        - ``c`` -- a vector
    """
    w = 0
    
    for elem in c:
        if elem != 0:
            w += 1
    
    return w

def decodePatterson(y,g,X,SyndromeCalculator,L):

    synd = SyndromeCalculator * y.transpose();
    syndrome_poly = 0;
    for i in range(synd.nrows()):
        syndrome_poly += synd[i, 0] * X ** i

    vector_g = descomponer_polinomio(g)
    w = ((vector_g[0])*inversa_g(vector_g[1],g)).mod(g)
    vector_t = descomponer_polinomio(inversa_g(syndrome_poly,g) + X)

    R = (vector_t[0]+(w)*(vector_t[1])).mod(g)

 # Perform lattice basis reduction.
    (alpha, beta) = _lattice_basis_reduce(R,g,X);

    # Construct the error-locator polynomial.
    sigma = (alpha * alpha) + (beta * beta) * X;

    # For every root of the error polynomial,
    # correct the error induced at the corresponding index.
    for i in range(len(L)):
        if sigma(L[i]) == 0:
            y[0, i] += 1;
    return y;

def wt(x):
    x = vector(x)
    count = 0
    for i in range(len(x)):
        if x[i] != 0:
            count = count + 1
    return count

def gen_random_fix_vec(n, w):
    vec = [1]*w+(n-w)*[0]
    random.shuffle(vec)
    return vec

    
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
    
def DecodeNiederreiter(c,_S,_P,_H,g,X,SyndromeCalculator,L):
    
#         show(c * (self._S).inverse().transpose())
    word = (_H).solve_right(c * (_S).inverse().transpose())
#         show(word)
#         word = c * self._P.transpose()
    word_mat = matrix(K_,word)
#         yd = decodePatterson(word_mat,g1,X,SyndromeCalculator,L)
    word_prime = decodePatterson(word_mat,g1,X,SyndromeCalculator,L)
#         show(word_prime)
    word_prime = vector(K_,word_prime.list())
    message = word - word_prime
    message = message * _P
#         show(message)
    return message

        

