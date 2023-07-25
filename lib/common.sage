import hashlib


def gen_random_fix_vec(n, w):
    vec = [1]*w+(n-w)*[0]
    random.shuffle(vec)
    return vec

def gen_binom_vec(n, tau):
    return [1 if random.random()<tau else 0 for _ in range(n)]

def wt(poly):
    return poly.list().count(1)

def hash_function(n, w, msg, y):
    r = int(hashlib.sha512((msg+str(y)).encode('utf-8')).hexdigest(), base=16)
    s = set()
    while len(s) < w and r != 0:
        s.add(r%n)
        r = r//n
    if len(s) >= w:
        lst = n*[0]
        for ele in s:
            lst[ele] = 1
        return lst
    else:
        print ('Error in hash function')

def hash_function_1(n, y,msg,field):
    r = int(hashlib.sha512((str(y)+msg).encode('utf-8')).hexdigest(), base=16)
#     s = set()
    lst = n*[0]
    lst = vector(field,lst)
    while r != 0:
        ele = r%n
        r = r//n
        lst[ele] = lst[ele] + 1
    return lst

def hash_function_2(n, w, t, y, msg, field):
    r = int(hashlib.sha512((str(t)+str(y)+msg).encode('utf-8')).hexdigest(), base=16)
    s = set()
    while len(s) < w and r != 0:
        s.add(r%n)
        r = r//n
    if len(s) >= w:
        lst = n*[0]
        for ele in s:
            lst[ele] = 1
        lst = vector(field,lst)
        return lst
    else:
        print ('Error in hash function')
