import math

def my_log2(p):
    return math.log(p)/math.log(2)

def log_comb(n, k):
    if not hasattr(log_comb, 'dict'):
        log_comb.dict = dict()
    my_dict = log_comb.dict
    vlu = my_dict.get((n,k), -1)
    if vlu < 0:
        my_dict[(n,k)]=vlu=sum([my_log2(n-j)-my_log2(j+1) for j in range(k)])
    return vlu

def compute_truncate_pr(n, p, lb, ub):
    '''
    Compute sum_{lb<=j<=ub}binom{n}{j}p^j (1-p)^{n-j}
    '''
    return sum([2**(log_comb(n, j)+j*my_log2(p)+(n-j)*my_log2(1-p)) for j in range(lb, ub+1)])

def compute_rejection_sampling_pr(n, p, s, t):
    '''
    Compute the ratio of binomial distribution over shifted binomial distribution.
    '''
    log_comb_n_s = log_comb(n, s)
    return 1/sum([2**(log_comb(t, j)+log_comb(n-t, s-j)-log_comb_n_s+(s-2*j)*my_log2(p)+(2*j-s)*my_log2(1-p)) for j in range(s+1)])


def rejection_sampling_rate(N, s, tau, Xi):
    rate_dict = dict()

    lb = int(N*tau)-Xi; ub = int(N*tau)+Xi

    # denominator of truncated binomial distribution density function
    dem_trun_pr = compute_truncate_pr(N, tau, lb, ub)
    for t in range(lb, ub+1):
        # compute the rejection rate for t
        rejection_sampling_pr = compute_rejection_sampling_pr(N,tau,s,t)/dem_trun_pr
        rate_dict[t] = rejection_sampling_pr
    M = max(rate_dict.values())
    return rate_dict, M