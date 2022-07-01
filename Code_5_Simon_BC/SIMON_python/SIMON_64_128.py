#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Aug 10 19:33:02 2021

@author: swapnil
"""

# =============================================================================
# SIMON block cipher PYTHON code: 64 bit plaintext and 128 bit key scheduling
# implementation
# Date: 10 Aug 2021
# Author: Swapnil Sutar
# Test Vector: | PT: 75 6E 64 20 6C 69 6B 65 |
#              | K : 00 01 02 03 04 05 06 07 08 09 0A 0B 10 11 12 13 18 19 1A 1B |
#              | CT:  7A A0 DF B9 20 FC C8 44 |

# Test vetor in other words i.e. without byte to word conversion or vice versa
# Test Vector: | PT: 65 6b 69 6c 20 64 6e 75|
#              | K : 03 02 01 00 0b 0a 09 08 13 12 11 10 1b 1a 19 18|
#              | CT:  44 c8 fc 20 b9 df a0 7a|
# Ph.D. Acharya Nagarjuna University
# =============================================================================

# ============================================================================
# Key scheduling Algorithm of SIMON (128 bit KSA)
# ============================================================================
rk=[] # first 4 keys
def Key_Schedule(Master_k):
    # print("Master key: {}".format(hex(Master_k)[2:].zfill(32)))

    Constant_c = 0xfffffffc
    Constant_z = 0xfc2ce51207a635db

    rk.append(((Master_k) & (0xffffffff000000000000000000000000))>>(96))
    rk.append(((Master_k) & (0x00000000ffffffff0000000000000000))>>(64))
    rk.append(((Master_k) & (0x0000000000000000ffffffff00000000))>>(32))
    rk.append(((Master_k) & (0x000000000000000000000000ffffffff))>>(00))

    # for i in range(0,4):
    #     print("Round Key {}: {}".format(i,hex(rk[i])[2:].zfill(8)))

    for i in range(4,44):
        state_rotr_3 = ((rk[i-1] & 0xfffffff8)>>3) | ((rk[i-1] & 0x000000007)<<(32-3))
        state_rotr_4 = ((rk[i-1] & 0xfffffff0)>>4) | ((rk[i-1] & 0x00000000f)<<(32-4))
        state_rotr_1 = ((rk[i-3] & 0xfffffffe)>>1) | ((rk[i-3] & 0x000000001)<<(32-1))
        # print(hex(state_rotr_3)[2:].zfill(8))

        rk.append(Constant_c ^ ((Constant_z>>(i-4))&0x1) ^ rk[i-4] ^ state_rotr_3 ^ rk[i-3] ^ state_rotr_4 ^ state_rotr_1)
        # print("Round Key {}: {}".format(i,hex(rk[i])))

# ============================================================================
# SIMON Feistel Round Function
# ============================================================================
def simon_round(msb_32, lsb_32,i):
    # print("{}, {}".format(hex(msb_32),hex(lsb_32)))
    trail_1 = ((msb_32 & 0x7fffffff)<<1) | ((msb_32 & 0x80000000)>>(32-1))
    trail_2 = ((msb_32 & 0x00ffffff)<<8) | ((msb_32 & 0xff000000)>>(32-8))
    tmp_state = trail_1 & trail_2

    trail_1 = ((msb_32 & 0x3fffffff)<<2) | ((msb_32 & 0xc0000000)>>(32-2))
    trail_2 = tmp_state ^ trail_1 ^ lsb_32 ^ rk[i]

    # swapping
    lsb_32 = msb_32
    msb_32 = trail_2

    print("Round_C : {}".format(hex(((msb_32&0xffffffff)<<32)|(lsb_32))[2:].zfill(16)))
    print("--------")
    return ((msb_32&0xffffffff)<<32)|(lsb_32)

# ============================================================================
# main code SIMON encryption
# ============================================================================
Master_Key = 0x030201000b0a0908131211101b1a1918

Plain_Text = 0x656b696c20646e75

R_k = Master_Key


MSB_32 = (Plain_Text & 0xffffffff00000000)>>32
LSB_32 = (Plain_Text & 0xffffffff)
# print(hex(MSB_32))
# print(hex(LSB_32))

R_k= Key_Schedule(R_k)
R_p = simon_round(MSB_32,LSB_32,0)
for i in range(1,44):
    MSB_32=(R_p&0xffffffff00000000)>>32
    LSB_32=(R_p&0xffffffff)

    R_p = simon_round(MSB_32,LSB_32,i)

    print("final round rp : {}".format(hex(R_p)[2:].zfill(16)))