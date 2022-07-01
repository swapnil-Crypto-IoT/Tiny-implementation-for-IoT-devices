#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jun 22 10:20:08 2021

@author: swapnil
"""

# =============================================================================
# SBOX, PBOX, BLOCK_SIZE & NO_OF_ROUND Declaration
# =============================================================================
s_box = [0xE,0x7,0x8,0x4,0x1,0x9,0x2,0xF,0x5,0xA,0xB,0x0,0x6,0xC,0xD,0x3]

p_layer_order = [15,11,7,3,2,14,10,6,5,1,13,9,8,4,0,12]

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
    for m in range(16):
        t|= ((D_value >> m)&0x1)<<p_layer_order[m]
    return t

# =============================================================================
# 128 bit key scheduling algorithm
# =============================================================================
def key_schedule(m_key,rc_i):
    """
    Block Cipher NUX: 128 bit key scheduling

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
# print function to convert hex with appended 0
# =============================================================================
def hex_with_zeroes(int_value,n): # n is number of zeroes to be appended
    return(format(hex(int_value)[2:].zfill(n)))
# =============================================================================
# Round function defination
# =============================================================================
def round_function(msbyte,lsbyte,r_key):
    # msbyte = hex(msbyte)[2:].zfill(8)
    # lsbyte = hex(lsbyte)[2:].zfill(8)
    print("\n\tPlaintext:\t{} {}".format(hex_with_zeroes(msbyte,8),hex_with_zeroes(lsbyte, 8)))
    # seperating 32 bits into 16 bits group
    msb_1  = ((msbyte & 0xffff0000)>>16)
    msb_2 = (msbyte & 0xffff)
    lsb_3  = ((lsbyte & 0xffff0000)>>16)
    lsb_4 = (lsbyte & 0xffff)
    print("\textracted positions\n \t{} {} {} {}".format(hex_with_zeroes(msb_1, 4),hex_with_zeroes(msb_2, 4),hex_with_zeroes(lsb_3, 4), hex_with_zeroes(lsb_4, 4)))
    # msb side operations
    state = ((msb_2 &0xfff8)>>3) | ((msb_2&0x0007)<<(16-3))
    state = sbox(hex_with_zeroes(state,4),4)
    print("\tsbox[rcs_3(msb_2)]: {}".format(state))
    
    tmpstate = ((msb_1&0x00ff)<<8) |((msb_1&0xff00)>>(16-8))
    print("\tlcs_8(msb_1): {}".format(hex_with_zeroes(tmpstate, 4)))
    state = int(state,16) ^ tmpstate ^ ((r_key&0xffff0000)>>16)
    print("\tpbox input (state): {}".format(hex_with_zeroes(state, 4)))
    state = p_box(state)
    print("\tpbox(state): {}".format(hex_with_zeroes(state, 4)))
    tmpstate = p_box(msb_2)
    lsbyte = (state<<16) | tmpstate # swaping 1
    print("\tout_lsb_3&4: {}".format(hex_with_zeroes(lsbyte, 8)))
    
    print("--")
    # lsb side operations
    state = ((lsb_3&0x00ff)<<8) |((lsb_3&0xff00)>>(16-8))
    state = sbox(hex_with_zeroes(state,4),4)
    print("\tsbox[lcs_8(lsb_3)]: {}".format(state))
    
    tmpstate = ((lsb_4&0xfff8)>>3) | ((lsb_4&0x0007)<<(16-3))
    state  = int(state,16)^tmpstate^(r_key&0xffff)
    state = p_box(state)
    tmpstate = p_box(lsb_3)
    msbyte = (tmpstate<<16) | state # swapping 2
    # tmpstate = ((msb_1&0x00ff)<<8) |((msb_1&0xff00)>>(16-8))
    # print("\tlcs_8(msb_1): {}".format(hex_with_zeroes(tmpstate, 4)))
    # state = int(state,16) ^ tmpstate ^ ((r_key&0xffff0000)>>16)
    # print("\tpbox input (state): {}".format(hex_with_zeroes(state, 4)))
    # state = p_box(state)
    # print("\tpbox(state): {}".format(hex_with_zeroes(state, 4)))
    # tmpstate = p_box(msb_2)
    # lsbyte = (state<<16) | tmpstate
    # print("\tout_lsb_3&4: {}".format(hex_with_zeroes(lsbyte, 8)))
    
    # # swap
    # t1= msbyte
    # msbyte = p_box(int(lsbyte,16))
    # lsbyte = p_box(t1)
    print("\tRound_C : {}".format(hex(((msbyte&0xffffffff)<<32)|(lsbyte))[2:].zfill(16)))
    # # print("--------")
    return ((msbyte&0xffffffff)<<32)|(lsbyte)

# =============================================================================
# Main code to call entire encryption
# =============================================================================

master_key = 0x00000000000000000000000000000000
plain_text = 0x0000000000000000

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

