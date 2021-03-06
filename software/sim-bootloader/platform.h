/* Copyright (c) 2018 SiFive, Inc */
/* SPDX-License-Identifier: Apache-2.0 */
/* SPDX-License-Identifier: GPL-2.0-or-later */
/* See the file LICENSE for further information */

#ifndef _SIFIVE_PLATFORM_H
#define _SIFIVE_PLATFORM_H

//#define ED25519_DIR

#include "const.h"
#include "devices/sha3.h"
#include "devices/ed25519.h"
#include "devices/aes.h"
#include "devices/random.h"
#include "devices/uart.h"

#define CLINT_CTRL_ADDR _AC(0x2000000,UL)
#define CLINT_CTRL_SIZE _AC(0x10000,UL)
#define SHA3_CTRL_ADDR   _AC(0x64003000,UL)
#define SHA3_CTRL_SIZE   _AC(0x1000,UL)
#define ED25519_CTRL_ADDR   _AC(0x64004000,UL)
#define ED25519_CTRL_SIZE   _AC(0x1000,UL)
#define AES_CTRL_ADDR   _AC(0x64007000,UL)
#define AES_CTRL_SIZE   _AC(0x1000,UL)
#define USB11HS_CTRL_ADDR   _AC(0x64008000,UL)
#define USB11HS_CTRL_SIZE   _AC(0x1000,UL)
#define RANDOM_CTRL_ADDR   _AC(0x64009000,UL)
#define RANDOM_CTRL_SIZE   _AC(0x1000,UL)
#define UART0_CTRL_ADDR   _AC(0x64000000,UL)
#define UART0_CTRL_SIZE   _AC(0x1000,UL)


// Helper functions
#define _REG64(p, i) (*(volatile uint64_t *)((p) + (i)))
#define _REG32(p, i) (*(volatile uint32_t *)((p) + (i)))
#define _REG16(p, i) (*(volatile uint16_t *)((p) + (i)))

// Bulk set bits in `reg` to either 0 or 1.
// E.g. SET_BITS(MY_REG, 0x00000007, 0) would generate MY_REG &= ~0x7
// E.g. SET_BITS(MY_REG, 0x00000007, 1) would generate MY_REG |= 0x7
#define SET_BITS(reg, mask, value) if ((value) == 0) { (reg) &= ~(mask); } else { (reg) |= (mask); }

#define SHA3_REG(offset) _REG32(SHA3_CTRL_ADDR, offset)
#define SHA3_REG64(offset) _REG64(SHA3_CTRL_ADDR, offset)
#define ED25519_REG(offset) _REG32(ED25519_CTRL_ADDR, offset)
#define ED25519_REG64(offset) _REG64(ED25519_CTRL_ADDR, offset)
#define AES_REG(offset) _REG32(AES_CTRL_ADDR, offset)
#define AES_REG64(offset) _REG64(AES_CTRL_ADDR, offset)
#define RANDOM_REG(offset) _REG32(RANDOM_CTRL_ADDR, offset)
#define RANDOM_REG64(offset) _REG64(RANDOM_CTRL_ADDR, offset)
#define UART0_REG(offset) _REG32(UART0_CTRL_ADDR, offset)
#define UART0_REG64(offset) _REG64(UART0_CTRL_ADDR, offset)

// Helpers for getting and setting individual bit fields, shifting the values
// for you.
#define GET_FIELD(reg, mask) (((reg) & (mask)) / ((mask) & ~((mask) << 1)))
#define SET_FIELD(reg, mask, val) (((reg) & ~(mask)) | (((val) * ((mask) & ~((mask) << 1))) & (mask)))

#endif /* _SIFIVE_PLATFORM_H */
