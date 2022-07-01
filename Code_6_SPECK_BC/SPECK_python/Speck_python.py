#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Aug 13 06:33:27 2021

@author: swapnil
"""


# =============================================================================
# SIMON block cipher PYTHON code: 64 bit plaintext and 128 bit key scheduling
# implementation
# Date: 10 Aug 2021
# Author: Swapnil Sutar
# Test Vector: | PT: 2d 43 75 74 74 65 72 3b |
#              | K : 00 01 02 03 08 09 0a 0b 10 11 12 13 18 19 1a 1b |
#              | CT:  8b 02 4e 45 48 a5 6f 8c |

# Test vetor in other words i.e. without byte to word conversion or vice versa
# Test Vector: | PT: 3b 72 65 74 74 75 43 2d |
#              | K : 1b 1a 19 18 13 12 11 10 0b 0a 09 08 03 02 01 00 |
#              | CT:  8c 6f a5 48 45 4e 02 8b |
# Ph.D. Acharya Nagarjuna University
# =============================================================================

# =================================================================================================
# Speck key scheduling for 128 bit input
# Note: Speck follows similar function for both KSA and round function
# i.e. Key_plus_encryption_speck() calls in both KSA and round function
# =================================================================================================
round_key=[]
def Key_plus_encryption_speck(x,y,i):
    x  = ((x&0xffffff00)>>8)|((x&0x000000ff)<<(32-8))
    x += (y & 0xffffffff)
    x ^=i
    t1 = (x & 0xffffffff)
    y  = ((y&0x1fffffff)<<3)|((y&0xe0000000)>>(32-3))
    y ^= (x & 0xffffffff)
    t2 = (y & 0xffffffff)
    return(t1,t2)
def Key_Schedule(Master_key):
    d = ((Master_key) & (0xffffffff000000000000000000000000))>>(96)
    c = ((Master_key) & (0x00000000ffffffff0000000000000000))>>(64)
    b = ((Master_key) & (0x0000000000000000ffffffff00000000))>>(32)
    a = ((Master_key) & (0x000000000000000000000000ffffffff))

    for i in range(0,26,3):
        if(i==0):
            round_key.append(a)

        b,a = Key_plus_encryption_speck(b,a,i)
        round_key.append(a)

        c,a = Key_plus_encryption_speck(c,a,i+1)
        round_key.append(a)

        d,a = Key_plus_encryption_speck(d,a,i+2)
        round_key.append(a)

# ============================================================================
# speck Feistel Round Function
# ============================================================================
def speck_round(msb_bits,lsb_bits,i):
    msb_bits,lsb_bits = Key_plus_encryption_speck(msb_bits,lsb_bits,round_key[i])
    return(((msb_bits&0xffffffff)<<32)|(lsb_bits))


# ============================================================================
# main code speck engine
# ============================================================================
Master_Key = 0x1b1a1918131211100b0a090803020100

Plain_Text = 0x3b7265747475432d

R_k = Master_Key


# MSB_32 = (Plain_Text & 0xffffffff00000000)>>32
# LSB_32 = (Plain_Text & 0xffffffff)
# print(hex(MSB_32))
# print(hex(LSB_32))

R_k= Key_Schedule(R_k)

# for c,i in enumerate(round_key):
    # print("{}: {}".format(c,hex(i)[2:].zfill(8)))
# R_p = speck_round(MSB_32,LSB_32,0)
for i in range(0,27):
    MSB_32=(Plain_Text&0xffffffff00000000)>>32
    LSB_32=(Plain_Text&0xffffffff)

    Plain_Text = speck_round(MSB_32,LSB_32,i)

    print("final round rp : {}".format(hex(Plain_Text)[2:].zfill(16)))