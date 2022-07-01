#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jun 22 10:20:08 2021

@author: swapnil
"""

# =============================================================================
# SBOX, PBOX, BLOCK_SIZE & NO_OF_ROUND Declaration
# =============================================================================
s_box = [0x2,0x9,0x7,0xe,0x1,0xc,0xa,0x0,0x4,0x3,0x8,0xd,0xf,0x6,0x5,0xb]

p_layer_order = [20,16,28,24,17,21,25,29,22,18,30,26,19,23,27,31,11,15,3,7,14,10,6,2,9,13,1,5,12,8,4,0]

NO_OF_ROUND = 30 # implies 31 round cipher starting from 0

# =============================================================================
# SBOX OPERATION ON n BYTE
# =============================================================================
def sbox(hex_value,N):
    """
    Parameters
    ----------
    hex_value : Value to be substituted with new value as per sbox.

    Returns
    -------
    New substituted value.
    """
    sub_value=[]
    for i in hex_value.zfill(N):
        # print(i)
        sub_value.append(((hex(s_box[int(i,16)])).strip("0x")).zfill(1))
    return "".join(sub_value)
# =============================================================================
# Permutation Operation
# =============================================================================
def p_box(D_value):
    """


    Parameters
    ----------
    D_value : TYPE
        DESCRIPTION.

    Returns
    -------
    t : TYPE
        DESCRIPTION.

    """
    t=0
    for m in range(32):
        t|= ((D_value >> m)&0x1)<<p_layer_order[m]
    return t

# =============================================================================
# 128 bit key scheduling algorithm
# =============================================================================
def key_schedule(m_key,rc_i):
    """
    Block Cipher ANU: 128 bit key scheduling

    Parameters
    ----------
    m_key : 128 bit master secret key.
    rc_i : round_counter or round Constant (0-25).

    Returns
    -------
    rk : Single round key of 128 bit for each iteration

    """
    key_state = [1 if i == '1' else 0 for i in format(m_key,'0128b')]
    state_rot13 = key_state[13:]+key_state[:13]
    state_rot13 = ("".join(map(str,state_rot13)))

    sub_byte = hex((int(state_rot13,2)) & (0xff))[2:]
    sub_byte = sbox(sub_byte, 2)
    state_sub = (hex(int(state_rot13,2)&(0xffffffffffffffffffffffffffffff00) | int(sub_byte,16))[2:]).zfill(32)

    state_5bit = hex(int(state_sub[16:],16) ^ (rc_i<<59))[2:].zfill(16)

    rk = (int(state_sub[0:16],16)<<64 | (int(state_sub[16:],16)&0) | int(state_5bit,16))
    m_key=rk

    print("{}".format(hex(rk)[2:].zfill(32)))
    return rk
# =============================================================================
# Round function defination
# =============================================================================
def round_function(msbyte,lsbyte,r_key):

    msbyte = hex(msbyte)[2:].zfill(8)
    print("\n\tPlaintext:\t{} {}".format(msbyte,lsbyte))
    state = sbox(msbyte,8)
    print("\tF1| Sbox:\t{}".format(hex(int(state,16))[2:].zfill(8)))
    t1 = ((int(state,16) & 0x01ffffff)<<7) | ((int(state,16) & 0xfe000000)>>(32-7)) 
    print("\tF1| <<<7:\t{}".format((hex(t1)[2:]).zfill(8)))
    t2 = ((int(state,16) & 0x1fffffff)<<3) | ((int(state,16) & 0xe0000000)>>(32-3))
    print("\tF1| <<<3:\t{}".format((hex(t2)[2:]).zfill(8)))
    lsbyte = t1^t2^lsbyte # final LSB before permutation
    print("\tF1_out^lsb:\t{}".format(hex(lsbyte)[2:].zfill(8)))
    
    
    lsbyte = hex(lsbyte)[2:].zfill(8)
    state = sbox(lsbyte,8)
    print("\n\tF2 Sbox:\t{}".format(hex(int(state,16))[2:].zfill(8)))
    t1 = ((int(state,16) & 0xffffff80)>>7) | ((int(state,16) & 0x0000007f)<<(32-7))
    print("\tF2| >>>7:\t{}".format((hex(t1)[2:]).zfill(8)))
    t2 = ((int(state,16) & 0xfffffff8)>>3) | ((int(state,16) & 0x00000007)<<(32-3))
    print("\tF2| >>>3:\t{}".format((hex(t2)[2:]).zfill(8)))
    msbyte = t1^t2^int(msbyte,16)^(r_key & 0xffffffff) # final MSB before permutation
    print("\tF2_out^msb:\t{} rk:\t{}".format(hex(msbyte)[2:].zfill(8),hex((r_key & 0xffffffff))[2:].zfill(8)))
    
    # print("LCS3 : {}".format(hex(lcsp_3)[2:].zfill(8)))
    # sub_p3 = hex(lcsp_3)[2:].zfill(8)
    # sub_p3 = sbox(sub_p3, 8) # trail_1 done
    # print("subbyte_lcs3 : {}".format(sub_p3))

    # rcsp_8 = ((msbyte & 0xffffff00)>>8) | ((msbyte & 0x000000ff)<<(32-8))
    # print("RCS8 : {}".format(hex(rcsp_8)[2:].zfill(8)))
    # sub_p8 = hex(rcsp_8)[2:].zfill(8)
    # sub_p8 = sbox(sub_p8, 8) # trail_2 done
    # print("subbyte_rcs : {}".format(sub_p8))

    # print("Round Key : {}".format(hex(r_key&0xffffffff)[2:]))
    # trail2 = (int(sub_p3,16) ^ int(sub_p8,16) ^ lsbyte ^ r_key)
    # print("xor result : {}".format(hex(trail2)[2:].zfill(8)))

    # ptrail2 = p_box(trail2)
    # print("pbox_trails : {}".format(hex(ptrail2)[2:].zfill(8)))
    # ptrail1 = p_box(msbyte)
    # print("msbyte_trails : {}".format(hex(ptrail1)[2:].zfill(8)))

    # # swap
    t1= msbyte
    # lsbyte = hex(lsbyte)[2:].zfill(8)
    msbyte = p_box(int(lsbyte,16))
    lsbyte = p_box(t1)
    print("Round_C : {}".format(hex(((msbyte&0xffffffff)<<32)|(lsbyte))[2:].zfill(16)))
    # print("--------")
    return ((msbyte&0xffffffff)<<32)|(lsbyte)

# =============================================================================
# Main code to call entire encryption
# =============================================================================

master_key = 0x0123456789abcdef0123456789abcdef
plain_text = 0x0123456789abcdef

r_k = master_key

msb=(plain_text&0xffffffff00000000)>>32
lsb=(plain_text&0xffffffff)
r_p = round_function(msb, lsb, r_k)

for l in range(NO_OF_ROUND):
    r_k=key_schedule(r_k, l)

    msb=(r_p&0xffffffff00000000)>>32
    lsb=(r_p&0xffffffff)
    r_p = round_function(msb, lsb, r_k)
    print("final round rp : {}".format(hex(r_p)[2:].zfill(16)))

