#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Aug 18 07:10:15 2021

@author: swapnil
"""


# =============================================================================
# PRESENT block cipher PYTHON code: 64 bit plaintext and 128 bit key scheduling
# implementation
# Date: 18 Aug 2021
# Author: Swapnil Sutar
# Test Vector: | PT: 01 23 45 67 89 AB CD EF |
#              | K : 01 23 45 67 89 AB CD EF 01 23 45 67 89 AB CD EF|
#              | CT:  0E 9D 28 68 5E 67 1D D6 |
# Ph.D. Acharya Nagarjuna University
# =============================================================================
# =============================================================================
# SBOX, PBOX
# =============================================================================
s_box = [0xc,5,6,0xb,9,0,0xa,0xd,3,0xe,0xf,8,4,7,1,2]

p_layer_order = [0,16,32,48,1,17,33,49,2,18,34,50,3,19,35,51,4,20,36,52,5,21,37,53,6,22,38,54,7,23,39,55,8,
24,40,56,9,25,41,57,10,26,42,58,11,27,43,59,12,28,44,60,13,29,45,61,14,30,46,62,15,31,47,63]

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
    for m in range(64):
        t|= ((D_value >> m)&0x1)<<p_layer_order[m]
    return t


# =============================================================================
# Key update
# =============================================================================
rk=[]
def key_schedule(m_key):
    
    key_high = (m_key & 0xffffffffffffffff0000000000000000)>>64
    key_low  = (m_key & 0xffffffffffffffff)
    rk.append(key_high)
    for i in range(0,32):
        temp = key_low
        key_low = ((key_low<<61) | key_high>>(64-61)) & 0xffffffffffffffff
        key_high = (((key_high)<<61)|(temp>>(64-61))) & 0xffffffffffffffff
       

        m=0
        for i1 in range(0,2):
           m|=int(sbox(hex(((key_high >> 56)&0xff)>>(i1*4)&0xf)[2:],1),16)<<(i1*4)
        # print("{} :: {}".format(hex(key_high),hex(m<<56)))
        
        key_high &= (0x00ffffffffffffff);  
        key_high |= (((m<<56)&0xff00000000000000));
        key_low ^= ( ( (i+1) & 0x03 ) << 62 );			
        key_high ^= (  (i+1)  >> 2);
        
        rk.append(key_high)

# =============================================================================
# PRESENT round function
# =============================================================================
def present_round(state,l):
    if(l<=30):
        state ^= rk[l]
        state = sbox(hex(state)[2:], 16)
        state = int(state,16)
        state = p_box(state)
        return(state)
    else:
        state ^= rk[l]
        return(state)
    
        
# =============================================================================
# Main code to call entire encryption
# =============================================================================

master_key = 0x0000000000000000000000000000000
plain_text = 0x0000000000000000


msb=(plain_text&0xffffffff00000000)>>32
lsb=(plain_text&0xffffffff)
# r_p = round_function(msb, lsb, r_k)

key_schedule(master_key)
ct = plain_text
for l in range(0,32):
     ct = present_round(ct, l)
     print("\u2767 {} :: {}".format(hex(ct)[2:].zfill(16),hex(rk[l])))