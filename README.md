# rand_code_sign
This is a proof of concept implementation of the paper [LXY20].

The implementation is tested on Linux with SageMath version 8.2. 

The parameters for 80-bit and 128-bit security are defined. Below we assume 80-bit parameters are used.

(i) Precompute the rejection rate for rejection sampling.  
$ sage precomp.sage 80  
parameters n=66467, u=49, w=6, tau=0.23925000, Xi=70  
The maximal rejection rate = 48.98963821 precomputation saved in file ./data/80/precomp_data80.sobj  

(ii) Generate pk and sk for 80-bit and key id 'keyid1'  
$ sage keygen.sage 80 keyid1  
parameters n=66467, u=49, w=6, tau=0.23925000, Xi=70  
secret key saved in file ./data/80/sk80_keyid1.sobj  
public key saved in file ./data/80/pk80_keyid1.sobj  

(iii) Sign for 80-bit, key id 'keyid1' and message 'msg'  
$ sage sign.sage 80 keyid1 msg  
parameters n=66467, u=49, w=6, tau=0.23925000, Xi=70  
signature for "msg" saved in file ./data/80/sign80_keyid1_msg.sobj  

(iv) Verify signature for 80-bit, key id 'keyid1' and message 'msg'  
$ sage verify.sage 80 keyid1 msg  
parameters n=66467, u=49, w=6, tau=0.23925000, Xi=70  
verification succeeds for message "msg"  


LXY20. Zhe Li, Chaoping Xing and Sze Ling Yeo. A New Code Based Signature Scheme without Trapdoors, eprint [2020/1250](https://eprint.iacr.org/2020/1250).
