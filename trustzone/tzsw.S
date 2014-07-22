/*
 * Copyright (C) 2014 Humberto Naves <hsnaves@gmail.com>
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include "tzsw.h"

/* CPSR Register bits */
.equ CPSR_MASK_ISR,	(1 << 7)
.equ CPSR_MASK_FIQ,	(1 << 6)
.equ CPSR_MASK_MODE,	(0x1F << 0)
.equ CPSR_MODE_MONITOR,	(0x16 << 0)
.equ CPSR_MODE_HYP,	(0x1A << 0)

/* SCR Register bits */
.equ SCR_NS,		(1 << 0)	@ Non-secure bit
.equ SCR_IRQ,		(1 << 1)	@ IRQ taken to monitor mode
.equ SCR_FIQ,		(1 << 2)	@ FIQ taken to monitor mode
.equ SCR_EA,		(1 << 3)	@ External abort to monitor mode
.equ SCR_FW,		(1 << 4)	@ Enable CPSR.F in any security state
.equ SCR_AW,		(1 << 5)	@ Enable CPSR.A in any security state
.equ SCR_nET,		(1 << 6)	@ Disables early termination
.equ SCR_SCD,		(1 << 7)	@ SMC disable
.equ SCR_HCE,		(1 << 8)	@ HVC enable
.equ SCR_SIF,		(1 << 9)	@ Disable fetches from NS memory

/* SCTLR Register bits */
.equ SCTLR_MMU,		(1 << 0)	@ MMU enable

/* TTBR0 Register bits */
.equ TTBR0_SHARE,	(1 << 1)	@ Shareable


/* Values for Ctype fields in CLIDR */
.equ CLIDR_CTYPE_NO_CACHE,		(0)
.equ CLIDR_CTYPE_INSTRUCTION_ONLY,	(1)
.equ CLIDR_CTYPE_DATA_ONLY,		(2)
.equ CLIDR_CTYPE_INSTRUCTION_DATA,	(3)
.equ CLIDR_CTYPE_UNIFIED,		(4)


/* Possible values for DCACHE set/way maintenance operations */
.equ DCACHE_INVAL,			(0)
.equ DCACHE_CLEAN,			(1)
.equ DCACHE_CLEAN_INVAL,		(2)

/* Device memory mapping for exynos */
.equ EXYNOS5_PRO_ID,			(0x10000000)
.equ EXYNOS5_CMU_BASE,			(0x10010000)
.equ EXYNOS5_PMU_BASE,			(0x10040000)
.equ EXYNOS5_DMC_TZASC0_BASE,		(0x10D40000)
.equ EXYNOS5_DMC_TZASC1_BASE,		(0x10D50000)
.equ EXYNOS5_DMC_TZASC_COUNT,		(2)
.equ EXYNOS5_DMC_TZASC_REGIONS,		(9)
.equ EXYNOS5_TZPC_BASE,			(0x100E0000)
.equ EXYNOS5_TZPC11_BASE,		(0x100F0000)
.equ EXYNOS5_TZPC_OFFSET,		(0x00010000)
.equ EXYNOS5_TZPC_COUNT,		(11)		@ count-1 maybe ???
.equ EXYNOS5_GIC_CPU,			(0x10482000)
.equ EXYNOS5_GIC_DIST,			(0x10481000)
.equ EXYNOS5_KEY_UNKNOWN,		(0x101A0000)	@ it generates the key for the AES???
.equ EXYNOS5_DREXI_0,			(0x10C20000)
.equ EXYNOS5_DREXI_1,			(0x10C30000)

/* Some clocks in the CMU */
.equ EXYNOS5_CLKGATE_IP_ACP,		(EXYNOS5_CMU_BASE + 0x08800)
.equ EXYNOS5_CLKGATE_BUS_CDREX,		(EXYNOS5_CMU_BASE + 0x20700)

/* Some DREXI registers */
.equ DREXI_CTRL,			(0x0000)
.equ DREXI_TIME_AUTO_REFRESH,		(0x0030)
.equ DREXI_TIME_ROW,			(0x0034)
.equ DREXI_TIME_DATA,			(0x0038)
.equ DREXI_TIME_POWERMODE,		(0x003C)



/* ACE Registers (defintions found in file:
 * "drivers/crypto/ace_sfr.h" of the linux kernel 3.4,
 * more specifically, branch odroidxu-3.4.y
 * of the official Hardkernel repository)
 */
.equ ACE_FC_INTPEND,			(0x1083000C)
.equ ACE_FC_FIFOCTRL,			(0x10830014)
.equ ACE_FC_BRDMAS,			(0x10830020)
.equ ACE_FC_BRDMAL,			(0x10830024)
.equ ACE_FC_BRDMAC,			(0x10830028)
.equ ACE_FC_BTDMAS,			(0x10830030)
.equ ACE_FC_BTDMAL,			(0x10830034)
.equ ACE_FC_BTDMAC,			(0x10830038)
.equ ACE_AES_CONTROL,			(0x10830200)
.equ ACE_AES_STATUS,			(0x10830204)
.equ ACE_AES_IV1,			(0x10830230)
.equ ACE_AES_IV2,			(0x10830234)
.equ ACE_AES_IV3,			(0x10830238)
.equ ACE_AES_IV4,			(0x1083023C)
.equ ACE_AES_KEY5,			(0x10830290)
.equ ACE_AES_KEY6,			(0x10830294)
.equ ACE_AES_KEY7,			(0x10830298)
.equ ACE_AES_KEY8,			(0x1083029C)
.equ ACE_HASH_CONTROL,			(0x10830400)
.equ ACE_HASH_FIFO_MODE,		(0x10830408)
.equ ACE_HASH_BYTESWAP,			(0x1083040C)
.equ ACE_HASH_STATUS,			(0x10830410)
.equ ACE_HASH_MSGSIZE_LOW,		(0x10830420)
.equ ACE_HASH_MSGSIZE_HIGH,		(0x10830424)
.equ ACE_HASH_PRELEN_LOW,		(0x10830428)
.equ ACE_HASH_PRELEN_HIGH,		(0x1083042C)
.equ ACE_HASH_IN1,			(0x10830430)
.equ ACE_HASH_IN2,			(0x10830434)
.equ ACE_HASH_IN3,			(0x10830438)
.equ ACE_HASH_IN4,			(0x1083043C)
.equ ACE_HASH_IN5,			(0x10830440)
.equ ACE_HASH_HMAC_KEY_IN1,		(0x10830470)
.equ ACE_HASH_HMAC_KEY_IN2,		(0x10830474)
.equ ACE_HASH_HMAC_KEY_IN3,		(0x10830478)
.equ ACE_HASH_HMAC_KEY_IN4,		(0x1083047C)
.equ ACE_HASH_HMAC_KEY_IN5,		(0x10830480)
.equ ACE_HASH_HMAC_KEY_IN6,		(0x10830484)
.equ ACE_HASH_HMAC_KEY_IN7,		(0x10830488)
.equ ACE_HASH_HMAC_KEY_IN8,		(0x1083048C)
.equ ACE_HASH_HMAC_KEY_IN9,		(0x10830490)
.equ ACE_HASH_HMAC_KEY_IN10,		(0x10830494)
.equ ACE_HASH_HMAC_KEY_IN11,		(0x10830498)
.equ ACE_HASH_HMAC_KEY_IN12,		(0x1083049C)
.equ ACE_HASH_HMAC_KEY_IN13,		(0x108304A0)
.equ ACE_HASH_HMAC_KEY_IN14,		(0x108304A4)
.equ ACE_HASH_HMAC_KEY_IN15,		(0x108304A8)
.equ ACE_HASH_HMAC_KEY_IN16,		(0x108304AC)
.equ ACE_HASH_RESULT1,			(0x10830500)
.equ ACE_HASH_RESULT2,			(0x10830504)
.equ ACE_HASH_RESULT3,			(0x10830508)
.equ ACE_HASH_RESULT4,			(0x1083050C)
.equ ACE_HASH_RESULT5,			(0x10830510)
.equ ACE_HASH_RESULT6,			(0x10830514)
.equ ACE_HASH_RESULT7,			(0x10830518)
.equ ACE_HASH_RESULT8,			(0x1083051C)



/* DMC_TZASC - It seems to be a CoreLink TrustZone Address Space
 * Controller. Please refer to the document "ARM DDI 0431C" at
 * http://infocenter.arm.com/help/topic/com.arm.doc.ddi0431c/DDI0431C_tzasc_tzc380_r0p1_trm.pdf
 *
 * Very important: This is a guess, I am not sure if exynos5410 really
 * contains the TZC-380!!!
 */
.equ DMCTZASC_ACTION,			(0x4)
.equ DMCTZASC_LOCKDOWN_RANGE,		(0x8)
.equ DMCTZASC_LOCKDOWN_SELECT,		(0xC)
.equ DMCTZASC_REGION_LOW,		(0x0100)
.equ DMCTZASC_REGION_HIGH,		(0x0104)
.equ DMCTZASC_ATTRIBUTES,		(0x0108)


/* TZPC - TrustZone controller registers (BP147)
 * Please refer to the document "ARM DTO 0015A" at
 * http://infocenter.arm.com/help/topic/com.arm.doc.dto0015a/DTO0015_primecell_infrastructure_amba3_tzpc_bp147_to.pdf
 * This controler has another set of registers, namely
 * DECPROT3, which allows the controler to have 32 = 4 * 8 memory regions,
 * instead of the usual 24 = 3 * 8 (8 bits per register).
 */
.equ TZPC_R0SIZE,			(0x0)
.equ TZPC_DECPROT0STAT,			(0x0800)
.equ TZPC_DECPROT0SET,			(0x0804)
.equ TZPC_DECPROT0CLR,			(0x0808)
.equ TZPC_DECPROT1STAT,			(0x080C)
.equ TZPC_DECPROT1SET,			(0x0810)
.equ TZPC_DECPROT1CLR,			(0x0814)
.equ TZPC_DECPROT2STAT,			(0x0818)
.equ TZPC_DECPROT2SET,			(0x081C)
.equ TZPC_DECPROT2CLR,			(0x0820)
.equ TZPC_DECPROT3STAT,			(0x0824)
.equ TZPC_DECPROT3SET,			(0x0828)
.equ TZPC_DECPROT3CLR,			(0x082C)


/* GIC registers
 * Please refer to the document "ARM IHI 0048B" at
 * http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ihi0048b/index.html
 */
.equ GIC_CPU_CTRL,			(0x0)
.equ GIC_CPU_PRIMASK,			(0x4)
.equ GIC_CPU_BINPOINT,			(0x8)
.equ GIC_DIST_CTRL,			(0x0)
.equ GIC_DIST_IGROUP,			(0x080)
.equ GIC_DIST_ENABLE_CLEAR,		(0x180)
.equ GIC_DIST_ENABLE_SET,		(0x100)



/* Auxiliary macros */
.macro	ld_imm reg, val
	movw	\reg, #:lower16:\val
	movt	\reg, #:upper16:\val
.endm

/* ========================================================================
 *                            Text Section
 * ========================================================================
 */
	.text
	.globl _tzsw_start
_tzsw_start:
	b	init
undefined_instruction:
	b	undefined_instruction
software_interrupt:
	b	handle_smc
prefetch_abort:
	b	prefetch_abort
data_abort:
	b	data_abort
not_used:
	b	not_used
irq:
	b	irq
fiq:
	b	fiq

	/* Misterious magic words ... */
	.word	0x00005410
	.word	0x00010D0E

/* ========================================================================
 *  Offset: 0x00028
 *  void init(int arg);
 * ========================================================================
 */
init:
	/* Save the link register in ip, in case we switch modes */
	mov	ip, lr

	/* Disable interrupts and make sure we're in monitor mode */
	msr	CPSR_c, (CPSR_MASK_ISR | CPSR_MASK_FIQ | CPSR_MODE_MONITOR)

	mrc	15, 0, r5, cr0, cr0, 5			@ read MPIDR
	ubfx	r4, r5, #0, #4				@ CPU# inside cluster
	ubfx	r5, r5, #8, #4				@ Cluster Id

	add	r4, r4, r5, lsl #2			@ combine into CPUid

	/* setup stack = CONFIG_PHY_IRAM_NS_BASE - 1024 * CPUid  */
	ldr	sp, =(CONFIG_PHY_IRAM_NS_BASE)		@ 0x02073000
	sub	sp, sp, r4, lsl #10

	/* r0 -> some misterious argument */
	push	{ip}
	cmp	r0, #2
	beq	handle_arg_case2
	cmp	r0, #1
	beq	handle_arg_case1
	cmp	r0, #0
	beq	handle_arg_case0

	/* freezes the cpu if arg is not 0, 1, or 2 */
invalid_arg:
	b	invalid_arg

handle_arg_case0:
	mrc	15, 0, r4, cr0, cr0, 5			@ read MPIDR
	ands	r4, r4, #3				@ cpu# inside cluster

	bne	not_cpu0
	bl	load_hwinfo

	/* Changes MVBAR to CONFIG_PHY_TZSW_BASE */
	ldr	r0, =(CONFIG_PHY_TZSW_BASE)		@ 0x02030000
	mcr	15, 0, r0, cr12, cr0, 1			@ set MVBAR
	b	end_handle

not_cpu0:
	/* Repeated code? */
	ldr	r0, =(CONFIG_PHY_TZSW_BASE)		@ 0x02030000
	mcr	15, 0, r0, cr12, cr0, 1			@ set MVBAR
	b	end_handle

handle_arg_case1:
	bl	restore_hwstate_secure
	bl	restore_NSACR_MVBAR
	b	end_handle

handle_arg_case2:
	bl	restore_NSACR_MVBAR

end_handle:
	bl	configure_mmu

	/* Configure SCR (NS, FIQ, AW, HCE, SIF, !FW) */
	mrc	15, 0, r0, cr1, cr1, 0			@ read SCR
	bic	r0, r0, #(SCR_FW)
	orr	r0, r0, #(SCR_NS | SCR_FIQ | SCR_AW)
	orr	r0, r0, #(SCR_HCE | SCR_SIF)
	mcr	15, 0, r0, cr1, cr1, 0			@ write SCR

	/* Read CPSR and configure SPSR */
	mrs	r4, CPSR
	bic	r4, r4, #(CPSR_MASK_MODE)
	orr	r4, r4, #(CPSR_MODE_HYP)
	pop	{ip}
	msr	SPSR_fsxc, r4

	/* Return */
	movs	pc, ip


/* ========================================================================
 *  Offset: 0x000D0
 *  void save_NSACR_MVBAR(void);
 * ========================================================================
 */
save_NSACR_MVBAR:
	stmdb	sp, {r0, r1, r2, r3, r4, r5, ip, lr}
	adr	ip, sec_state_memory

	mrc	15, 0, r0, cr0, cr0, 5			@ read MPIDR
	ands	r0, r0, #3				@ mask cpu#
	add	ip, ip, r0, lsl #5
	mrc	15, 0, r1, cr1, cr1, 2			@ read NSACR
	mrc	15, 0, r2, cr12, cr0, 1			@ read MVBAR
	stmia	ip!, {r0, r1, r2, r3, r4, r5}

	/* Restore registers and return */
	ldmdb	sp, {r0, r1, r2, r3, r4, r5, ip, pc}


/* ========================================================================
 *  Offset: 0x000F4
 *  void restore_NSACR_MVBAR(void);
 * ========================================================================
 */
restore_NSACR_MVBAR:
	/* Save registers, and return address */
	stmdb	sp, {r0, r1, r2, r3, r4, r5, ip, lr}
	adr	ip, sec_state_memory

	mrc	15, 0, r0, cr0, cr0, 5			@ read MPIDR
	ands	r0, r0, #3				@ mask cpu#
	add	ip, ip, r0, lsl #5
	ldm	ip!, {r0, r1, r2, r3, r4, r5}

	mcr	15, 0, r1, cr1, cr1, 2			@ set NSACR
	mcr	15, 0, r2, cr12, cr0, 1			@ set MVBAR

	/* Restores register and return */
	ldmdb	sp, {r0, r1, r2, r3, r4, r5, ip, pc}
	nop
	nop

/* Offset: 0x00120
 * This memory location keeps the secure state for
 * save_ and restore_NSACR_MVBAR.
 */
sec_state_memory:
	.skip	128, 0


/* ========================================================================
 *  Offset: 0x001A0
 *  void configure_mmu(void);
 * ========================================================================
 */
configure_mmu:
	/* Set MANAGER for memory domain 0, and no access for the rest */
	mov	r0, #3
	mcr	15, 0, r0, cr3, cr0, 0			@ set DACR

	ldr	r0, =(translation_table0)		@ 0x02034000
	ldr	r1, =(0x3FFF)
	bic	r0, r0, r1
	mov	r1, #(TTBR0_SHARE)
	orr	r0, r0, r1

	/* Change Translation Table Base registers */
	mcr	15, 0, r0, cr2, cr0, 0			@ set TTBR0

	/* Enable MMU */
	mrc	15, 0, r0, cr1, cr0, 0			@ read SCTLR
	orr	r0, r0, #(SCTLR_MMU)
	mcr	15, 0, r0, cr1, cr0, 0			@ set SCTLR

	dsb	sy
	isb	sy

	/* Return */
	mov	pc, lr

	.ltorg


/* ========================================================================
 *  Offset: 0x001F0
 *  void load_hwinfo(int discarded, u32 *ptr);
 *
 *  Information:
 *  o ptr points to some structure.
 *  o typicall value of ptr = 0x02073800
 *  o Offsets accessed:  0 -> expected to be 0x10000
 *                      32 -> expected to be 0x5410
 *                      64 -> conf1??? (typically 0x40000000)
 *                      68 -> conf2??? (typically 0x80000000)
 *                      72 -> conf3??? (typically 0xBFE00000)
 *                      76 -> conf4??? (typically 0x00200000)
 *                      80 -> expected to be 0x49534C53
 * ========================================================================
 */
	.globl	load_hwinfo
	.align	4
	.type	load_hwinfo, %function
load_hwinfo:
	str	fp, [sp, #-4]!			@ push {sp}

	add	fp, sp, #0
	sub	sp, sp, #12

	/* Local variables in stack */
	.equ	discarded,	-8
	.equ	ptr,		-12

	str	r0, [fp, #discarded]
	str	r1, [fp, #ptr]

	/* Read PRO_ID */
	mov	r3, #(EXYNOS5_PRO_ID)
	ldr	r3, [r3]
	uxtb	r2, r3
	ld_imm	r3, prod_id
	str	r2, [r3]

	/* Some sort of sanity checking for ptr */
	ldr	r3, [fp, #ptr]
	ldr	r3, [r3]
	cmp	r3, #0x10000
	bne	1f

	ldr	r3, [fp, #ptr]
	ldr	r2, [r3, #80]
	ld_imm	r3, 0x49534C53
	cmp	r2, r3
	beq	2f

1:	/* Freezes if it does not pass the test */
 	b	1b

2:	/* Continue */
	ldr	r3, [fp, #ptr]
	ldr	r2, [r3, #32]
	movw	r3, #0x5410
	cmp	r2, r3
	beq	4f

3:	/* Freezes again */
	b	3b

4:	/* Continue */
	/* Save some configuration parameters in memory */
	ldr	r3, [fp, #ptr]
	ldr	r2, [r3, #64]			@ 0x40
	ld_imm	r3, configuration
	str	r2, [r3]

	ldr	r3, [fp, #ptr]
	ldr	r2, [r3, #68]			@ 0x44
	ld_imm	r3, configuration
	str	r2, [r3, #confparam2]

	ldr	r3, [fp, #ptr]
	ldr	r2, [r3, #72]			@ 0x48
	ld_imm	r3, configuration
	str	r2, [r3, #confparam3]

	ldr	r3, [fp, #ptr]
	ldr	r2, [r3, #76]			@ 0x4C
	ld_imm	r3, configuration
	str	r2, [r3, #confparam4]


	/* Configure DMC_TZASC */
	ld_imm	r3, hwinfo
	ld_imm	r2, EXYNOS5_DMC_TZASC0_BASE
	str	r2, [r3, #dmc_tzascs]

	ld_imm	r3, hwinfo
	ld_imm	r2, EXYNOS5_DMC_TZASC1_BASE
	str	r2, [r3, #(dmc_tzascs + 4)]

	ld_imm	r3, hwinfo
	mov	r2, #EXYNOS5_DMC_TZASC_COUNT
	str	r2, [r3, #num_dmc_tzascs]

	ld_imm	r3, hwinfo
	mov	r2, #EXYNOS5_DMC_TZASC_REGIONS
	str	r2, [r3, #tzasc_num_regions]

	/* Configure TZPC for TrustZone */
	ld_imm	r3, hwinfo
	ld_imm	r2, EXYNOS5_TZPC_BASE
	str	r2, [r3, #tzpc_base]

	ld_imm	r3, hwinfo
	mov	r2, #(EXYNOS5_TZPC_OFFSET)
	str	r2, [r3, #tzpc_offset]

	ld_imm	r3, hwinfo
	mov	r2, #(EXYNOS5_TZPC_COUNT)
	str	r2, [r3, #tzpc_count]

	/* Configure GIC */
	ld_imm	r3, hwinfo
	ld_imm	r2, EXYNOS5_GIC_CPU
	str	r2, [r3, #gic_cpu_base]

	ld_imm	r3, hwinfo
	ld_imm	r2, EXYNOS5_GIC_DIST
	str	r2, [r3, #gic_dist_base]

	ld_imm	r3, hwinfo
	mov	r2, #0x100
	str	r2, [r3, #gic_num_interrupts]

	/* return 0 */
	mov	r3, #0
	mov	r0, r3
	add	sp, fp, #0
	pop	{fp}
	bx	lr
	.size	load_hwinfo, .-load_hwinfo


/* ========================================================================
 *  Offset: 0x00378
 *  int handle_smc(int arg1, int arg2, int arg3, int arg4);
 * ========================================================================
 */
handle_smc:
	cmn	r0, #101
	beq	smc_cmd_reg
	cmn	r0, #1
	beq	smc_cmd_init
	cmn	r0, #2
	beq	smc_cmd_info
	cmn	r0, #3
	beq	smc_cmd_sleep
	cmn	r0, #6
	beq	smc_cmd_save_state
	cmn	r0, #7
	beq	smc_cmd_standby
	cmn	r0, #26
	beq	smc_cmd_unknown
	cmn	r0, #1024
	beq	smc_cmd_disable_tzpc
	cmn	r0, #2048
	beq	smc_cmd_memcpy
	cmn	r0, #4096
	beq	smc_cmd_invoke
	bne	smc_return_minus1

/* Offset: 0x003B4 */
smc_cmd_reg:
	and	r0, r1, #0xC0000000
	cmp	r0, #0x40000000
	beq	reg_sfr_w
	cmp	r0, #0xC0000000
	beq	reg_sfr_r

reg_cp15:
	ldr	r0, =(0x00000401)
	cmp	r0, r1
	mcreq	15, 0, r2, cr1, cr0, 1		@ write ACTLR
	beq	smc_return0
	ldr	r0, =(0x00002482)
	cmp	r0, r1
	mcreq	15, 1, r2, cr9, cr0, 2		@ write L2CTLR
	beq	smc_return0
	mov	r0, #0x3C80
	cmp	r0, r1
	mcreq	15, 1, r2, cr15, cr0, 0		@ write L2ACTLR
	beq	smc_return0
	ldr	r0, =(0x3C83)
	cmp	r0, r1
	mcreq	15, 1, r2, cr15, cr0, 3		@ write L2PFR
	beq	smc_return0
	/* Souldn't we jump to smc_return_minus1 here? */

/* Offset: 0x00408 */
reg_sfr_w:
	/* DRAM controller (DREXI) stuff */
	lsl	r1, r1, #2
	ldr	r0, =(EXYNOS5_DREXI_0 + DREXI_CTRL)
	cmp	r0, r1
	streq	r2, [r0]
	beq	smc_return0
	ldr	r0, =(EXYNOS5_DREXI_1 + DREXI_CTRL)
	cmp	r0, r1
	streq	r2, [r0]
	beq	smc_return0
	ldr	r0, =(EXYNOS5_DREXI_0 + DREXI_TIME_AUTO_REFRESH)
	cmp	r0, r1
	streq	r2, [r0]
	beq	smc_return0
	ldr	r0, =(EXYNOS5_DREXI_1 + DREXI_TIME_AUTO_REFRESH)
	cmp	r0, r1
	streq	r2, [r0]
	beq	smc_return0
	ldr	r0, =(EXYNOS5_DREXI_0 + DREXI_TIME_ROW)
	cmp	r0, r1
	streq	r2, [r0]
	beq	smc_return0
	ldr	r0, =(EXYNOS5_DREXI_1 + DREXI_TIME_ROW)
	cmp	r0, r1
	streq	r2, [r0]
	beq	smc_return0
	ldr	r0, =(EXYNOS5_DREXI_0 + DREXI_TIME_DATA)
	cmp	r0, r1
	streq	r2, [r0]
	beq	smc_return0
	ldr	r0, =(EXYNOS5_DREXI_1 + DREXI_TIME_DATA)
	cmp	r0, r1
	streq	r2, [r0]
	beq	smc_return0
	ldr	r0, =(EXYNOS5_DREXI_0 + DREXI_TIME_POWERMODE)
	cmp	r0, r1
	streq	r2, [r0]
	beq	smc_return0
	ldr	r0, =(EXYNOS5_DREXI_1 + DREXI_TIME_POWERMODE)
	cmp	r0, r1
	streq	r2, [r0]
	beq	smc_return0
	ldr	r0, =(0x02020028)		@ ???
	cmp	r0, r1
	streq	r2, [r0]
	beq	smc_return0
	/* Souldn't we jump to smc_return_minus1 here? */

/* Offset: 0x004BC */
reg_sfr_r:
	lsl	r1, r1, #2
	lsr	r3, r1, #16
	ldr	r0, =(EXYNOS5_DREXI_0 >> 16)
	cmp	r0, r3
	ldreq	r2, [r1]
	beq	smc_return0
	ldr	r0, =(EXYNOS5_DREXI_1 >> 16)
	cmp	r0, r3
	ldreq	r2, [r1]
	beq	smc_return0
	b	smc_return_minus1

/* Offset: 0x004E8 */
smc_cmd_init:
	b	smc_return


/* Offset: 0x004EC */
smc_cmd_info:
	mov	r0, #0
	mov	r1, #1
	mov	r2, #2
	mov	r3, #3
	b	smc_return

/* Offset: 0x00500 */
smc_cmd_sleep:
	push	{r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
	bl	save_NSACR_MVBAR
	bl	save_hwstate_secure

	/* PMU Controller stuff */
	/* The actual meaning of the registers is a wild guess
	 * based on the manual of S5PC110.
	 */
	ldr	r0, =(EXYNOS5_PMU_BASE + 0x0800)	@ ???
	ldr	r1, =(0x02073008)
	ldr	r1, [r1]
	str	r1, [r0]

	ldr	r0, =(EXYNOS5_PMU_BASE + 0x0804)	@ ???
	ldr	r1, =(0x0207300C)
	ldr	r1, [r1]
	str	r1, [r0]

	ldr	r0, =(EXYNOS5_CLKGATE_IP_ACP)
	mov	r1, #0x254		@ gate all gates for SSS, ID_REMAPPER, SMMUG2D, ???
	ldr	r2, [r0]
	orr	r2, r2, r1
	str	r2, [r0]

	/* TZPC11_BASE */
	ldr	r0, =(EXYNOS5_TZPC11_BASE)
	mov	r1, #0x40
	ldr	r5, [r0, #TZPC_DECPROT1STAT]
	and	r5, r5, r1
	str	r1, [r0, #TZPC_DECPROT1CLR]

	ldr	r0, =(EXYNOS5_TZPC11_BASE)
	mov	r1, #1
	ldr	r6, [r0, #TZPC_DECPROT2STAT]
	and	r6, r6, r1
	str	r1, [r0, #TZPC_DECPROT2CLR]

	bl	encrypt_iram
	cmp	r0, #0
	bne	sleep_fail

	ldr	r0, =(EXYNOS5_CLKGATE_BUS_CDREX)
	ldr	r1, [r0]
	bic	r1, r1, #0xC0				@ which clocks are these?
	str	r1, [r0]

	/* Some PMU register? */
	ldr	r0, =(EXYNOS5_PMU_BASE + 0x091C)	@ ???
1:
	ldr	r1, [r0]
	ands	r1, r1, #6
	bne	1b

	mvn	r1, #0
	ldr	r0, =(EXYNOS5_PMU_BASE + 0x0004)	@ ???
	str	r1, [r0]

	ldr	r0, =(EXYNOS5_PMU_BASE + 0x0008)	@ ???
	str	r1, [r0]

	ldr	r0, =(EXYNOS5_PMU_BASE + 0x000C)	@ ???
	str	r1, [r0]

	ldr	r0, =(EXYNOS5_PMU_BASE + 0x159C)	@ ???
	str	r1, [r0]

	ldr	r0, =(EXYNOS5_PMU_BASE + 0x15A0)	@ ???
	str	r1, [r0]

	ldr	r0, =(EXYNOS5_PMU_BASE + 0x15A4)	@ ???
	str	r1, [r0]

	ldr	r0, =(EXYNOS5_PMU_BASE + 0x3000)	@ ???
	mov	r1, #0
	str	r1, [r0]

	ldr	r0, =(EXYNOS5_PMU_BASE + 0x3004)	@ ???
2:
	ldr	r1, [r0]
	ands	r1, r1, #0x10000
	beq	2b

	/* This is strange... maybe the CPUs are talking to each other? */
	ldr	r0, =(0x02020028)
	mov	r1, #0
	str	r1, [r0]
	dsb	sy
	wfi

	ldr	r0, =(0x02020028)
	ldr	r1, =(0xFCBA0D10)
	str	r1, [r0]

	ldr	r0, =(EXYNOS5_PMU_BASE + 0x3000)	@ ???
	mov	r1, #1
	str	r1, [r0]

	ldr	r0, =(EXYNOS5_PMU_BASE + 0x3004)	@ ???
3:
	ldr	r1, [r0]
	ands	r1, r1, #1
	beq	3b

	mov	r1, #0x7000
	ldr	r0, =(EXYNOS5_PMU_BASE + 0x0004)	@ ???
	str	r1, [r0]

	mov	r1, #0x30
	ldr	r0, =(EXYNOS5_PMU_BASE + 0x0008)	@ ???
	str	r1, [r0]

	mov	r1, #0
	ldr	r0, =(EXYNOS5_PMU_BASE + 0x000C)	@ ???
	str	r1, [r0]

	ldr	r0, =(EXYNOS5_PMU_BASE + 0x159C)	@ ???
	str	r1, [r0]

	ldr	r0, =(EXYNOS5_PMU_BASE + 0x15A0)	@ ???
	str	r1, [r0]

	ldr	r0, =(EXYNOS5_PMU_BASE + 0x15A4)	@ ???
	str	r1, [r0]

	ldr	r0, =(EXYNOS5_CLKGATE_BUS_CDREX)
	ldr	r1, [r0]
	orr	r1, r1, #0xC0				@ same clocks
	str	r1, [r0]

	ldr	r0, =(EXYNOS5_PMU_BASE + 0x091C)	@ ???
4:
	ldr	r1, [r0]
	and	r1, r1, #6
	cmp	r1, #6
	bne	4b

sleep_fail:
	ldr	r0, =(EXYNOS5_PMU_BASE + 0x0800)	@ ???
	mov	r1, #0
	str	r1, [r0]

	ldr	r0, =(EXYNOS5_PMU_BASE + 0x0804)	@ ???
	str	r1, [r0]

	/* TZPC11_BASE */
	ldr	r0, =(EXYNOS5_TZPC11_BASE)
	str	r5, [r0, #TZPC_DECPROT1SET]

	ldr	r0, =(EXYNOS5_TZPC11_BASE)
	str	r6, [r0, #TZPC_DECPROT2SET]

	pop	{r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
	mvn	r0, #0
	mov	r1, #0
	mov	r2, #0
	mov	r3, #0
	b	smc_return

/* Offset: 0x006BC */
label_6bc:	/* This label is never called!!! */
	ldr	r1, =(0x02023408)
	ldr	r1, [r1]
	str	r1, [r0]
	sev
	b	smc_return0

/* Offset: 0x006D0 */
label_6d0:	/* This label is never called!!! */
	push	{lr}
	bl	save_NSACR_MVBAR
	pop	{lr}
	ldr	r2, =(0x0202340C)
	ldr	r2, [r2]
	str	r2, [r0]
	ldr	r2, =(0x02073020)
	ldr	r2, [r2]
	str	r2, [r1]
	dsb	sy
	wfi
	b	smc_return0

/* Offset: 0x00700 */
smc_cmd_save_state:
	push	{lr}
	bl	save_NSACR_MVBAR
	pop	{lr}
	b	smc_return0

/* Offset: 0x00710 */
/* Params: r1 -> if 1, then broadcast message to all other processors.
 * Return value:
 */
smc_cmd_standby:
	push	{r4, lr}
	mov	r4, r1

	mrc	15, 0, r0, cr1, cr1, 0		@ read SCR
	bic	r0, r0, #1			@ clear NS mode
	mcr	15, 0, r0, cr1, cr1, 0		@ set SCR

	mrc	15, 0, r0, cr1, cr0, 0		@ read SCTLR
	bic	r0, r0, #5			@ disable CACHE and MMU
	mcr	15, 0, r0, cr1, cr0, 0		@ set SCTLR
	dsb	sy
	isb	sy

	bl	invalidate_icache_all

	mov	r0, #0				@ level
	mov	r1, #DCACHE_CLEAN_INVAL
	bl	maint_dcache_level_setway

	ldr	r1, =(EXYNOS5_PMU_BASE + 0x0800)
	mrc	15, 0, r0, cr1, cr0, 1		@ read ACTLR
	bic	r0, r0, #0x40			@ disables SMP cache maintenance operations
	ldr	r1, [r1]
	and	r1, r1, #0
	orr	r0, r0, r1
	mcr	15, 0, r0, cr1, cr0, 1		@ write ACTLR
	dsb	sy
	isb	sy

	cmp	r4, #1
	bne	go_idle

	mov	r0, #1				@ level
	mov	r1, #DCACHE_CLEAN_INVAL
	bl	maint_dcache_level_setway

	/* Talk to the other processors? */
	ldr	r1, =(0x02073028)
	mov	r2, #0
1:
	ldr	r0, [r1, r2, lsl #2]
	bic	r0, r0, #32
	str	r0, [r1, r2, lsl #2]
	add	r2, r2, #1
	cmp	r2, #4
	bne	1b

	/* Notify all the other processors */
	dsb	sy
	isb	sy
	sev

go_idle:
	wfi

	ldr	r1, =(EXYNOS5_PMU_BASE + 0x0800)
	mrc	15, 0, r0, cr1, cr0, 1		@ read ACTLR
	orr	r0, r0, #0x40			@ enables SMP
	ldr	r1, [r1]
	and	r1, r1, #0
	orr	r0, r0, r1
	mcr	15, 0, r0, cr1, cr0, 1		@ write ACTLR
	dsb	sy
	isb	sy

	mrc	15, 0, r0, cr1, cr0, 0		@ read SCTLR
	orr	r0, r0, #5			@ enables CACHE and MMU
	mcr	15, 0, r0, cr1, cr0, 0		@ set SCTLR
	dsb	sy
	isb	sy

	mrc	15, 0, r0, cr1, cr1, 0		@ read SCR
	orr	r0, r0, #1			@ set NS mode
	mcr	15, 0, r0, cr1, cr1, 0		@ set SCR
	pop	{r4, lr}
	b	smc_return_minus1


/* Offset: 0x007FC */
/* Which command is this? */
smc_cmd_unknown:
	ldr	r0, =(EXYNOS5_CLKGATE_BUS_CDREX)
	ldr	r1, [r0]
	bic	r1, r1, #0xC0			@ again the same clocks
	str	r1, [r0]

	/* Wait for something? */
	mov	r0, #0x3000
1:
	subs	r0, r0, #1
	bne	1b

	/* Now start playing with DREXI */
	ldr	r0, =(EXYNOS5_DREXI_0 + DREXI_TIME_ROW)	@ DREXI_0 TimingRow
	ldr	r1, =(EXYNOS5_DREXI_1 + DREXI_TIME_ROW)	@ DREXI_1 TimingRow
	ldr	r2, =(0xD05A8692)
	str	r2, [r0]
	str	r2, [r1]

	ldr	r0, =(EXYNOS5_DREXI_0 + 0x0010)
	ldr	r1, =(EXYNOS5_DREXI_1 + 0x0010)
	mov	r2, #0x01000000			@ DirectCmd Precharge ALL
	mov	r3, #0x01100000			@ ???
	str	r2, [r0]
	str	r3, [r0]
	str	r2, [r1]
	str	r3, [r1]

	mov	r2, #0x04000000			@ ???
	mov	r3, #0x04100000			@ ???
	str	r2, [r0]
	str	r3, [r0]
	str	r2, [r1]
	str	r3, [r1]


	ldr	r0, =(EXYNOS5_PMU_BASE + 0x3000)		@ ???
	mov	r1, #0
	str	r1, [r0]

	ldr	r0, =(EXYNOS5_PMU_BASE + 0x3004)		@ ???
1:
	ldr	r1, [r0]
	ands	r1, r1, #0x10000
	beq	1b

	ldr	r0, =(EXYNOS5_PMU_BASE + 0x000C)		@ ???
	mov	r1, #3
	str	r1, [r0]

	ldr	r0, =(EXYNOS5_PMU_BASE + 0x0400)		@ ???
	mov	r1, #1
	str	r1, [r0]
2:
	isb	sy
	b	2b
3:
	b	3b


smc_cmd_disable_tzpc: /* Disables all the TZPC */
	push	{lr}
	bl	disable_tzpc
	pop	{lr}
	b	smc_return0

smc_cmd_memcpy:	/* Copies from one memory region to another */
1:
	/* R1 = dst, R2 = src, R3 = len */
	ldr	r0, [r2], #4
	str	r0, [r1], #4
	subs	r3, r3, #4
	bge	1b
	b	smc_return0

smc_cmd_invoke:	/* Jumps to another memory location */
	push	{lr}
	blx	r1		@ jump target
	pop	{lr}
	b	smc_return



/* Offset: 0x008A4 */
smc_return_minus1:
	mvn	r0, #0
	movs	pc, lr

/* Offset: 0x008AC */
smc_return0:
	mov	r0, #0

/* Offset: 0x008B0 */
smc_return:
	movs	pc, lr


/* ========================================================================
 *  Offset: 0x008B4
 *  void invalidate_icache_all(void);
 * ========================================================================
 */
	.globl	invalidate_icache_all
	.align	2
	.type	invalidate_icache_all, %function

invalidate_icache_all:
	/* Invalidate all instruction caches to PoU */
	mcr	15, 0, sl, cr7, cr5, 0		@ set ICIALLU
	dsb	sy
	isb	sy
	bx	lr

	.size	invalidate_icache_all, .-invalidate_icache_all


/* ========================================================================
 *  Offset: 0x008C4
 *  void maint_dcache_level_setway(u32 level, u32 operation);
 *
 *  Silimar to v7_maint_dcache_level_setway for cache maintenance, as
 *    defined in the file "arch/arm/cpu/armv7/cache_v7.c"
 * ========================================================================
 */
	.globl	maint_dcache_level_setway
	.align	2
	.type	maint_dcache_level_setway, %function

maint_dcache_level_setway:
	push	{r4, r5, r6, r7, r8, r9, sl, fp}
	dsb	sy

	lsl	sl, r0, #1
	mrc	15, 1, r0, cr0, cr0, 1		@ read CLIDR
	add	r2, sl, sl, lsr #1
	lsr	r3, r0, r2
	and	r3, r3, #7

	/* if it is NO_CACHE or INSTRUCTION_ONLY, we may skip */
	cmp	r3, #(CLIDR_CTYPE_DATA_ONLY)
	blt	.Ldcache_return

	/* It selects the level and CSSELR_IND_DATA_UNIFIED */
	mcr	15, 2, sl, cr0, cr0, 0		@ set CSSELR
	isb	sy

	mrc	15, 1, r3, cr0, cr0, 0		@ read CCSIDR
	and	r2, r3, #7			@ LINE_SIZE_MASK
	add	r2, r2, #4

	ldr	r4, =(0x000003FF)		@ ASSOCIATIVITY_MASK
	ands	r4, r4, r3, lsr #3		@ ASSOCIATIVITY_OFFSET

	clz	r5, r4
	ldr	r7, =(0x00007FFF)		@ NUM_SETS_MAS
	ands	r7, r7, r3, lsr #13		@ NUM_SETS_OFFSET

	/* r2 -> log2_line_len, r4 -> num_ways, r7 -> num_sets */
.Ldcache_outer:
	mov	r9, r4

.Ldcache_inner:
	orr	fp, sl, r9, lsl r5
	lsl	r6, r9, r5
	orr	fp, sl, r6
	orr	fp, fp, r7, lsl r2
	lsl	r6, r7, r2
	orr	fp, fp, r6

	cmp	r1, #DCACHE_INVAL
	mcreq	15, 0, fp, cr7, cr6, 2		@ set DCISW
	beq	.Ldcache_inner_next

	cmp	r1, #DCACHE_CLEAN
	mcreq	15, 0, fp, cr7, cr10, 2		@ set DCCSW
	beq	.Ldcache_inner_next

	/* If DCACHE_CLEAN_INVAL */
	mcr	15, 0, fp, cr7, cr14, 2		@ set DCCISW

.Ldcache_inner_next:
	subs	r9, r9, #1
	bge	.Ldcache_inner

	subs	r7, r7, #1
	bge	.Ldcache_outer

.Ldcache_return:
	mov	sl, #0
	mcr	15, 2, sl, cr0, cr0, 0		@ write CSSELR
	dsb	sy
	isb	sy

	pop	{r4, r5, r6, r7, r8, r9, sl, fp}
	bx	lr

	.size	maint_dcache_level_setway, .-maint_dcache_level_setway
	.ltorg


/* ========================================================================
 *  Offset: 0x00A1C
 *  int generate_key(u32 *out1, u32 *out2, u32 salt);
 *
 *  Generate key using SHA256 function with salt...
 *
 *  Description of parameters:
 *   out1 -> pointer to u32[4] to hold the first 4 words of output
 *   out2 -> pointer to u32[4] to hold the last 4 words of output
 *   salt -> integer to hash
 *
 *  Return value:
 *    0 -> success
 *   -1 -> failure
 * ========================================================================
 */
	.globl	generate_key
	.align	2
	.type	generate_key, %function

generate_key:
	str	fp, [sp, #-4]!			@ push {fp}
	add	fp, sp, #0
	sub	sp, sp, #28

	/* Local variables in stack */
	.equ	out1,		-16
	.equ	out2,		-20
	.equ	salt,		-24
	.equ	temp,		-8
	.equ	curptr,		-12

	str	r0, [fp, #out1]
	str	r1, [fp, #out2]
	str	r2, [fp, #salt]

	ld_imm	r3, ACE_HASH_FIFO_MODE
	mov	r2, #0				@ ACE_HASH_FIFO_OFF
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_MSGSIZE_LOW
	mov	r2, #20				@ size = 20 bytes
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_MSGSIZE_HIGH
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_PRELEN_LOW
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_PRELEN_HIGH
	mov	r2, #0
	str	r2, [r3]


	mov	r3, #20				@ ACE_HASH_STARTBIT_ON | ACE_HASH_ENGSEL_SHA256HASH
	str	r3, [fp, #temp]

	ld_imm	r3, ACE_HASH_CONTROL
	ldr	r2, [fp, #temp]
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_STATUS
	ldr	r3, [r3]
	str	r3, [fp, #temp]

	ldr	r3, [fp, #temp]
	and	r3, r3, #1			@ ACE_HASH_BUFRDY_MASK
	cmp	r3, #0				@ ACE_HASH_BUFRDY_OFF
	bne	1f

	/* return -1 */
	mvn	r3, #0
	b	.Lgenkey_return

1:
	ld_imm	r3, ACE_HASH_IN1
	ld_imm	r2, (EXYNOS5_KEY_UNKNOWN)
	ldr	r2, [r2]			@ ???
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_IN2
	ld_imm	r2, (EXYNOS5_KEY_UNKNOWN + 4)
	ldr	r2, [r2]			@ ???
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_IN3
	ld_imm	r2, (EXYNOS5_KEY_UNKNOWN + 8)
	ldr	r2, [r2]			@ ???
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_IN4
	ld_imm	r2, (EXYNOS5_KEY_UNKNOWN + 12)
	ldr	r2, [r2]			@ ???
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_IN5
	ldr	r2, [fp, #salt]			@ load salt
	str	r2, [r3]

	/* Wait until it is done */
2:
	ld_imm	r3, ACE_HASH_STATUS
	ldr	r3, [r3]
	str	r3, [fp, #temp]

	ldr	r3, [fp, #temp]
	and	r3, r3, #0x40			@ ACE_HASH_MSGDONE_MASK
	cmp	r3, #0				@ ACE_HASH_MSGDONE_OFF
	beq	2b

	ld_imm	r3, ACE_HASH_STATUS
	mov	r2, #0x40
	str	r2, [r3]			@ store ACE_HASH_MSGDONE_ON on ACE_HASH_STATUS

	ldr	r3, [fp, #out1]
	str	r3, [fp, #curptr]		@ out1 -> current pointer

	ld_imm	r3, ACE_HASH_RESULT1
	ldr	r2, [r3]
	ldr	r3, [fp, #curptr]
	str	r2, [r3]

	ldr	r3, [fp, #curptr]
	add	r2, r3, #4
	ld_imm	r3, ACE_HASH_RESULT2
	ldr	r3, [r3]
	str	r3, [r2]

	ldr	r3, [fp, #curptr]
	add	r2, r3, #8
	ld_imm	r3, ACE_HASH_RESULT3
	ldr	r3, [r3]
	str	r3, [r2]

	ldr	r3, [fp, #curptr]
	add	r2, r3, #12
	ld_imm	r3, ACE_HASH_RESULT4
	ldr	r3, [r3]
	str	r3, [r2]

	ldr	r3, [fp, #out2]
	str	r3, [fp, #curptr]		@ out2 -> current pointer

	ld_imm	r3, ACE_HASH_RESULT5
	ldr	r2, [r3]
	ldr	r3, [fp, #curptr]
	str	r2, [r3]

	ldr	r3, [fp, #curptr]
	add	r2, r3, #4
	ld_imm	r3, ACE_HASH_RESULT6
	ldr	r3, [r3]
	str	r3, [r2]

	ldr	r3, [fp, #curptr]
	add	r2, r3, #8
	ld_imm	r3, ACE_HASH_RESULT7
	ldr	r3, [r3]
	str	r3, [r2]

	ldr	r3, [fp, #curptr]
	add	r2, r3, #12
	ld_imm	r3, ACE_HASH_RESULT8
	ldr	r3, [r3]
	str	r3, [r2]

	/* return 0 */
	mov	r3, #0

.Lgenkey_return:
	mov	r0, r3
	add	sp, fp, #0
	pop	{fp}
	bx	lr

	.size	generate_key, .-generate_key


/* ========================================================================
 *  Offset: 0x00C40
 *  int encrypt_iram(void);
 *
 *  Encrypts the iram memory region 0x02030000 - 0x02070000
 * ========================================================================
 */
	.globl	encrypt_iram
	.align	2
	.type	encrypt_iram, %function

encrypt_iram:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #56

	/* Local variables in stack */
	.equ	inbuf,		-8
	.equ	outbuf,		-12
	.equ	outhash,	-16
	.equ	size,		-20
	.equ	temp,		-24
	.equ	key1,		-40
	.equ	key2,		-56

	/* Setup local variables */
	ld_imm	r3, 0x02030000			@ start of memory region
	str	r3, [fp, #inbuf]

	ld_imm	r3, configuration
	ldr	r3, [r3, #confparam3]
	str	r3, [fp, #outbuf]

	ld_imm	r3, configuration
	ldr	r3, [r3, #confparam3]
	add	r3, r3, #0x40000		@ 256 Kb
	str	r3, [fp, #outhash]

	mov	r3, #0x40000
	str	r3, [fp, #size]

	/* Pointers to key1, and key2, respectively */
	sub	r2, fp, #40
	sub	r3, fp, #56

	/* Generate the key for AES */
	mov	r0, r2
	mov	r1, r3
	ld_imm	r2, 0xFFFF0001
	bl	generate_key

	mov	r3, r0
	cmp	r3, #0
	beq	1f

	/* return -1 because of error */
	mvn	r3, #0
	b	.Lencrypt_return
1:
	ld_imm	r3, ACE_AES_STATUS
	ldr	r3, [r3]
	str	r3, [fp, #temp]

	ldr	r3, [fp, #temp]
	and	r3, r3, #4			@ ACE_AES_BUSY_MASK
	cmp	r3, #0				@ ACE_AES_BUSY_OFF
	beq	2f

	/* return -1 because of error */
	mvn	r3, #0
	b	.Lencrypt_return
2:
 	ld_imm	r3, ACE_HASH_STATUS
	ldr	r3, [r3]
	str	r3, [fp, #temp]

	ldr	r3, [fp, #temp]
	and	r3, r3, #1			@ ACE_HASH_BUFRDY_MASK
	cmp	r3, #0				@ ACE_HASH_BUFRDY_OFF
	bne	3f

	/* return -1 because of error */
	mvn	r3, #0
	b	.Lencrypt_return
3:
	/* Configure parameters of AES */
	ld_imm	r3, ACE_FC_BRDMAC
	mov	r2, #1				@ ACE_FC_BRDMACFLUSH_ON
	str	r2, [r3]

	ld_imm	r3, ACE_FC_BTDMAC
	mov	r2, #1				@ ACE_FC_BTDMACFLUSH_ON
	str	r2, [r3]

	ld_imm	r3, ACE_FC_FIFOCTRL
	mov	r2, #1				@ ACE_FC_SELHASH_BCIN | ACE_FC_SELBC_AES
	str	r2, [r3]

	mov	r3, #2				@ ACE_AES_OPERMODE_CBC
	str	r3, [fp, #temp]

	ldr	r3, [fp, #temp]
	orr	r3, r3, #8			@ ACE_AES_FIFO_ON
	str	r3, [fp, #temp]

	ldr	r3, [fp, #temp]
	orr	r3, r3, #0x280			@ ACE_AES_KEYSIZE_128 | ACE_AES_SWAPKEY_ON | ACE_AES_SWAPKEY_ON
	str	r3, [fp, #temp]

	ldr	r3, [fp, #temp]
	orr	r3, r3, #0xC00			@ ACE_AES_SWAPDO_ON | ACE_AES_SWAPDI_ON | ACE_AES_COUNTERSIZE_128
	str	r3, [fp, #temp]

	ld_imm	r3, ACE_AES_CONTROL
	ldr	r2, [fp, #temp]
	str	r2, [r3]

	mov	r3, #12				@ ACE_HASH_SWAPDI_ON | ACE_HASH_SWAPDO_ON
	str	r3, [fp, #temp]

	ldr	r3, [fp, #temp]
	orr	r3, r3, #3			@ ACE_HASH_SWAPIV_ON | ACE_HASH_SWAPKEY_ON
	str	r3, [fp, #temp]

	ld_imm	r3, ACE_HASH_BYTESWAP
	ldr	r2, [fp, #temp]
	str	r2, [r3]

	/* Load the generated keys into AES crypto engine */
	ld_imm	r3, ACE_AES_KEY5
	ldr	r2, [fp, #key1]
	str	r2, [r3]

	ld_imm	r3, ACE_AES_KEY6
	ldr	r2, [fp, #(key1 + 4)]
	str	r2, [r3]

	ld_imm	r3, ACE_AES_KEY7
	ldr	r2, [fp, #(key1 + 8)]
	str	r2, [r3]

	ld_imm	r3, ACE_AES_KEY8
	ldr	r2, [fp, #(key1 + 12)]
	str	r2, [r3]

	ld_imm	r3, ACE_AES_IV1
	ldr	r2, [fp, #key2]
	str	r2, [r3]

	ld_imm	r3, ACE_AES_IV2
	ldr	r2, [fp, #(key2 + 4)]
	str	r2, [r3]

	ld_imm	r3, ACE_AES_IV3
	ldr	r2, [fp, #(key2 + 8)]
	str	r2, [r3]

	ld_imm	r3, ACE_AES_IV4
	ldr	r2, [fp, #(key2 + 12)]
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_HMAC_KEY_IN1
	ldr	r2, [fp, #key1]
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_HMAC_KEY_IN2
	ldr	r2, [fp, #(key1 + 4)]
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_HMAC_KEY_IN3
	ldr	r2, [fp, #(key1 + 8)]
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_HMAC_KEY_IN4
	ldr	r2, [fp, #(key1 + 12)]
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_HMAC_KEY_IN5
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_HMAC_KEY_IN6
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_HMAC_KEY_IN7
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_HMAC_KEY_IN8
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_HMAC_KEY_IN9
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_HMAC_KEY_IN10
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_HMAC_KEY_IN11
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_HMAC_KEY_IN12
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_HMAC_KEY_IN13
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_HMAC_KEY_IN14
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_HMAC_KEY_IN15
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_HMAC_KEY_IN16
	mov	r2, #0
	str	r2, [r3]

	/* Configure parameters of SHA256 */
	ld_imm	r3, ACE_HASH_FIFO_MODE
	mov	r2, #1				@ ACE_HASH_FIFO_ON
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_MSGSIZE_LOW
	ldr	r2, [fp, #size]
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_MSGSIZE_HIGH
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_PRELEN_LOW
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_PRELEN_HIGH
	mov	r2, #0
	str	r2, [r3]

	mov	r3, #21				@ ACE_HASH_ENGSEL_SHA256HMAC | ACE_HASH_STARTBIT_ON
	str	r3, [fp, #temp]

	ld_imm	r3, ACE_HASH_CONTROL
	ldr	r2, [fp, #temp]
	str	r2, [r3]

	/* Configure IN- and OUT- DMAs */
	ld_imm	r3, ACE_FC_BTDMAS
	ldr	r2, [fp, #outbuf]
	str	r2, [r3]			@ (out-buffer pointer)

	ld_imm	r3, ACE_FC_BTDMAL
	ldr	r2, [fp, #size]
	str	r2, [r3]			@ (out-buffer length)

	ld_imm	r3, ACE_FC_BRDMAS
	ldr	r2, [fp, #inbuf]
	str	r2, [r3]			@ (in-buffer pointer)

	ld_imm	r3, ACE_FC_BRDMAL
	ldr	r2, [fp, #size]
	str	r2, [r3]			@ (in-buffer length)

.Lencrypt_ready1:
	ld_imm	r3, ACE_FC_INTPEND
	ldr	r3, [r3]
	str	r3, [fp, #temp]

	ldr	r3, [fp, #temp]
	and	r3, r3, #4			@ ACE_FC_BTDMA
	cmp	r3, #0
	beq	.Lencrypt_ready1

	ld_imm	r3, ACE_FC_INTPEND
	mov	r2, #12				@ ACE_FC_BTDMA | ACE_FC_BRDMA
	str	r2, [r3]

	/* AES is done, so reset the keys */
	ld_imm	r3, ACE_AES_KEY5
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_AES_KEY6
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_AES_KEY7
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_AES_KEY8
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_AES_IV1
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_AES_IV2
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_AES_IV3
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_AES_IV4
	mov	r2, #0
	str	r2, [r3]

.Lencrypt_ready2:
	ld_imm	r3, ACE_HASH_STATUS
	ldr	r3, [r3]
	str	r3, [fp, #temp]

	ldr	r3, [fp, #temp]
	and	r3, r3, #0x40			@ ACE_HASH_MSGDONE_MASK
	cmp	r3, #0				@ ACE_HASH_MSGDONE_OFF
	beq	.Lencrypt_ready2

	ld_imm	r3, ACE_HASH_STATUS
	mov	r2, #0x40			@ ACE_HASH_MSGDONE_ON
	str	r2, [r3]

	/* SHA256 is also done! */

	ld_imm	r3, ACE_HASH_HMAC_KEY_IN1
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_HMAC_KEY_IN2
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_HMAC_KEY_IN3
	mov	r2, #0
	str	r2, [r3]

	ld_imm	r3, ACE_HASH_HMAC_KEY_IN4
	mov	r2, #0
	str	r2, [r3]

	/* Copy the results of SHA256 into outhash */
	ld_imm	r3, ACE_HASH_RESULT1
	ldr	r2, [r3]
	ldr	r3, [fp, #outhash]
	str	r2, [r3]

	ldr	r3, [fp, #outhash]
	add	r2, r3, #4
	ld_imm	r3, ACE_HASH_RESULT2
	ldr	r3, [r3]
	str	r3, [r2]

	ldr	r3, [fp, #outhash]
	add	r2, r3, #8
	ld_imm	r3, ACE_HASH_RESULT3
	ldr	r3, [r3]
	str	r3, [r2]

	ldr	r3, [fp, #outhash]
	add	r2, r3, #12
	ld_imm	r3, ACE_HASH_RESULT4
	ldr	r3, [r3]
	str	r3, [r2]

	ldr	r3, [fp, #outhash]
	add	r2, r3, #16
	ld_imm	r3, ACE_HASH_RESULT5
	ldr	r3, [r3]
	str	r3, [r2]

	ldr	r3, [fp, #outhash]
	add	r2, r3, #20
	ld_imm	r3, ACE_HASH_RESULT6
	ldr	r3, [r3]
	str	r3, [r2]

	ldr	r3, [fp, #outhash]
	add	r2, r3, #24
	ld_imm	r3, ACE_HASH_RESULT7
	ldr	r3, [r3]
	str	r3, [r2]

	ldr	r3, [fp, #outhash]
	add	r2, r3, #28
	ld_imm	r3, ACE_HASH_RESULT8
	ldr	r3, [r3]
	str	r3, [r2]

	/* return 0 */
	mov	r3, #0
.Lencrypt_return:
	mov	r0, r3
	sub	sp, fp, #4
	pop	{fp, pc}

	.size	encrypt_iram, .-encrypt_iram


/* ========================================================================
 *  Offset: 0x011A8
 *  int save_dmc_secure(u32 *settings);
 *
 *  Parameters: settings[30]
 * ========================================================================
 */
	.globl	save_dmc_secure
	.align	2
	.type	save_dmc_secure, %function

save_dmc_secure:
	str	fp, [sp, #-4]!			@ push {fp}
	add	fp, sp, #0
	sub	sp, sp, #20

	/* Local variables in stack */
	.equ	idx,		-8
	.equ	dmc,		-12
	.equ	settings,	-16

	str	r0, [fp, #settings]

	/* Load DMC_TZASC configuration into local variables */
	ld_imm	r3, hwinfo
	ldr	r3, [r3, #dmc_tzascs]
	str	r3, [fp, #dmc]

	mov	r3, #0
	str	r3, [fp, #idx]

	/* Save some registers??? */
	ldr	r3, [fp, #dmc]
	add	r3, r3, #DMCTZASC_ACTION
	ldr	r2, [r3]
	ldr	r3, [fp, #settings]
	str	r2, [r3]			@ settings[0]

	ldr	r3, [fp, #dmc]
	add	r3, r3, #DMCTZASC_LOCKDOWN_RANGE
	ldr	r2, [r3]
	ldr	r3, [fp, #settings]
	str	r2, [r3, #4]			@ settings[1]

	ldr	r3, [fp, #dmc]
	add	r3, r3, #DMCTZASC_LOCKDOWN_SELECT
	ldr	r2, [r3]
	ldr	r3, [fp, #settings]
	str	r2, [r3, #8]			@ settings[2]

	/* Set idx = 0 and start the loop */
	mov	r3, #0
	str	r3, [fp, #idx]
	b	.Ldmcsav_next1
.Ldmcsav_loop1:
	ldr	r3, [fp, #idx]
	lsl	r3, r3, #4
	mov	r2, r3
	ldr	r3, [fp, #dmc]
	add	r3, r2, r3
	add	r3, r3, #DMCTZASC_REGION_LOW
	ldr	r2, [r3]			@ DMCTZASC_REGION_LOW + 16 * idx

	ldr	r0, [fp, #settings]
	ldr	r3, [fp, #idx]
	add	r1, r3, #2
	mov	r3, #4
	lsl	r1, r1, #2
	add	r1, r0, r1
	add	r3, r1, r3
	str	r2, [r3]			@ settings[3 + idx]

	ldr	r3, [fp, #idx]
	lsl	r3, r3, #4
	mov	r2, r3
	ldr	r3, [fp, #dmc]
	add	r3, r2, r3
	add	r3, r3, #DMCTZASC_REGION_HIGH
	ldr	r1, [r3]			@ DMCTZASC_REGION_HIGH + 16 * idx

	ldr	r3, [fp, #settings]
	ldr	r2, [fp, #idx]
	add	r2, r2, #12
	str	r1, [r3, r2, lsl #2]		@ settings[12 + idx]

	ldr	r3, [fp, #idx]
	lsl	r3, r3, #4
	mov	r2, r3
	ldr	r3, [fp, #dmc]
	add	r3, r2, r3
	add	r3, r3, #DMCTZASC_ATTRIBUTES
	ldr	r2, [r3]			@ DMCTZASC_ATTRIBUTES + 16 * idx

	ldr	r0, [fp, #settings]
	ldr	r3, [fp, #idx]
	add	r1, r3, #20
	mov	r3, #4
	lsl	r1, r1, #2
	add	r1, r0, r1
	add	r3, r1, r3
	str	r2, [r3]			@settings[21 + idx]

	/* Increment index of loop */
	ldr	r3, [fp, #idx]
	add	r3, r3, #1
	str	r3, [fp, #idx]
.Ldmcsav_next1:
	ldr	r2, [fp, #idx]

	/* Is it the last one? */
	ld_imm	r3, hwinfo
	ldr	r3, [r3, #tzasc_num_regions]
	cmp	r2, r3
	bcc	.Ldmcsav_loop1

	/* return 0 */
	mov	r3, #0
	mov	r0, r3
	add	sp, fp, #0
	pop	{fp}
	bx	lr

	.size	save_dmc_secure, .-save_dmc_secure

/* ========================================================================
 *  Offset: 0x012F4
 *  void restore_dmc_secure(u32 *settings);
 *
 *  Parameters: settings[30]
 * ========================================================================
 */
	.globl	restore_dmc_secure
	.align	2
	.type	restore_dmc_secure, %function

restore_dmc_secure:
	str	fp, [sp, #-4]!			@ push {fp}
	add	fp, sp, #0
	sub	sp, sp, #28

	/* Local variables in stack */
	.equ	idx1,		-8
	.equ	idx2,		-12
	.equ	dmc,		-16
	.equ	settings,	-24

	str	r0, [fp, #settings]

	/* idx1 -> index of the DMA_TZASC controller (outer loop) */
	mov	r3, #0
	str	r3, [fp, #idx1]

	/* idx2 -> index of the memory region inside controller (inner loop) */
	mov	r3, #0
	str	r3, [fp, #idx2]

	mov	r3, #0
	str	r3, [fp, #idx1]
	b	.Ldmcres_outer_next

.Ldmcres_outer:
	ld_imm	r3, hwinfo
	ldr	r2, [fp, #idx1]
	ldr	r3, [r3, r2, lsl #2]		@ dmc_tzascs[idx1]
	str	r3, [fp, #dmc]

	ldr	r3, [fp, #dmc]
	add	r3, r3, #DMCTZASC_ACTION
	ldr	r2, [fp, #settings]
	ldr	r2, [r2]			@ settings[0]
	str	r2, [r3]

	ldr	r3, [fp, #dmc]
	add	r3, r3, #DMCTZASC_LOCKDOWN_RANGE
	ldr	r2, [fp, #settings]
	ldr	r2, [r2, #4]			@ settings[1]
	str	r2, [r3]

	ldr	r3, [fp, #dmc]
	add	r3, r3, #DMCTZASC_LOCKDOWN_SELECT
	ldr	r2, [fp, #settings]
	ldr	r2, [r2, #8]			@ settings[2]
	str	r2, [r3]

	/* Set idx2 = 0 and go fo inner loop */
	mov	r3, #0
	str	r3, [fp, #idx2]
	b	.Ldmcres_inner_next

.Ldmcres_inner:
	ldr	r3, [fp, #idx2]
	lsl	r3, r3, #4
	mov	r2, r3
	ldr	r3, [fp, #dmc]
	add	r3, r2, r3
	add	r3, r3, #DMCTZASC_REGION_LOW

	ldr	r0, [fp, #settings]
	ldr	r2, [fp, #idx2]
	add	r1, r2, #2
	mov	r2, #4
	lsl	r1, r1, #2
	add	r1, r0, r1
	add	r2, r1, r2
	ldr	r2, [r2]			@ settings[3 + idx2]
	str	r2, [r3]			@ DMCTZASC_REGION_LOW + 16 * idx2

	ldr	r3, [fp, #idx2]
	lsl	r3, r3, #4
	mov	r2, r3
	ldr	r3, [fp, #dmc]
	add	r3, r2, r3
	add	r3, r3, #DMCTZASC_REGION_HIGH

	ldr	r2, [fp, #settings]
	ldr	r1, [fp, #idx2]
	add	r1, r1, #12
	ldr	r2, [r2, r1, lsl #2]		@ settings[12 + idx2]
	str	r2, [r3]			@ DMCTZASC_REGION_HIGH + 16 * idx2

	ldr	r3, [fp, #idx2]
	lsl	r3, r3, #4
	mov	r2, r3
	ldr	r3, [fp, #dmc]
	add	r3, r2, r3
	add	r3, r3, #DMCTZASC_ATTRIBUTES

	ldr	r0, [fp, #settings]
	ldr	r2, [fp, #idx2]
	add	r1, r2, #20
	mov	r2, #4
	lsl	r1, r1, #2
	add	r1, r0, r1
	add	r2, r1, r2
	ldr	r2, [r2]			@ settings[21 + idx2]
	str	r2, [r3]			@ DMCTZASC_ATTRIBUTES + 16 * idx2

	/* Increment idx2, and iterate inner loop */
	ldr	r3, [fp, #idx2]
	add	r3, r3, #1
	str	r3, [fp, #idx2]

.Ldmcres_inner_next:
	ldr	r2, [fp, #idx2]
	ld_imm	r3, hwinfo
	ldr	r3, [r3, #tzasc_num_regions]
	cmp	r2, r3
	bcc	.Ldmcres_inner

	/* Increment idx1, and iterate outer loop */
	ldr	r3, [fp, #idx1]
	add	r3, r3, #1
	str	r3, [fp, #idx1]

.Ldmcres_outer_next:
	ldr	r2, [fp, #idx1]
	ld_imm	r3, hwinfo
	ldr	r3, [r3, #num_dmc_tzascs]
	cmp	r2, r3
	bcc	.Ldmcres_outer

	/* return 0 */
	mov	r3, #0
	mov	r0, r3
	add	sp, fp, #0
	pop	{fp}
	bx	lr

	.size	restore_dmc_secure, .-restore_dmc_secure


/* ========================================================================
 *  Offset: 0x0147C
 *  int save_tzpc_secure(u32 *settings);
 *
 *  Parameters: settings[1 + 4 * 12] = settings[49]
 * ========================================================================
 */
	.globl	save_tzpc_secure
	.align	2
	.type	save_tzpc_secure, %function

save_tzpc_secure:
	str	fp, [sp, #-4]!			@ push {fp}
	add	fp, sp, #0
	sub	sp, sp, #28

	/* Local variables in stack */
	.equ	tzpc,		-8
	.equ	idx,		-12
	.equ	tzpc_off,	-16
	.equ	settings,	-24

	str	r0, [fp, #settings]

	/* Load TZPC configuration into local variables */
	ld_imm	r3, hwinfo
	ldr	r3, [r3, #tzpc_base]
	str	r3, [fp, #tzpc]

	ld_imm	r3, hwinfo
	ldr	r3, [r3, #tzpc_offset]
	str	r3, [fp, #tzpc_off]

	mov	r3, #0
	str	r3, [fp, #idx]

	ldr	r3, [fp, #tzpc]
	ldr	r2, [r3]			@ R0SIZE
	ldr	r3, [fp, #settings]
	str	r2, [r3]			@ settings[0]

	/* Loop to set DECPROT<0,1,2,3> for all controllers */
	mov	r3, #0
	str	r3, [fp, #idx]
	b	.Ltzpcsav_next1
.Ltzpcsav_loop1:
	ldr	r3, [fp, #tzpc]
	add	r3, r3, #TZPC_DECPROT0STAT
	ldr	r2, [r3]

	ldr	r0, [fp, #settings]
	ldr	r1, [fp, #idx]
	mov	r3, #4
	lsl	r1, r1, #4
	add	r1, r0, r1
	add	r3, r1, r3
	str	r2, [r3]			@ settings[1 + 4 * idx]

	ldr	r3, [fp, #tzpc]
	add	r3, r3, #TZPC_DECPROT0STAT
	add	r3, r3, #(TZPC_DECPROT1STAT - TZPC_DECPROT0STAT)
	ldr	r2, [r3]

	ldr	r0, [fp, #settings]
	ldr	r1, [fp, #idx]
	mov	r3, #8
	lsl	r1, r1, #4
	add	r1, r0, r1
	add	r3, r1, r3
	str	r2, [r3]			@ settings[2 + 4 * idx]

	ldr	r3, [fp, #tzpc]
	add	r3, r3, #TZPC_DECPROT1SET
	add	r3, r3, #(TZPC_DECPROT2STAT - TZPC_DECPROT1SET)
	ldr	r2, [r3]

	ldr	r0, [fp, #settings]
	ldr	r1, [fp, #idx]
	mov	r3, #12
	lsl	r1, r1, #4
	add	r1, r0, r1
	add	r3, r1, r3
	str	r2, [r3]			@settings[3 + 4 * idx]

	ldr	r3, [fp, #tzpc]
	add	r3, r3, #TZPC_DECPROT2CLR
	add	r3, r3, #(TZPC_DECPROT3STAT - TZPC_DECPROT2CLR)
	ldr	r2, [r3]

	ldr	r0, [fp, #settings]
	ldr	r1, [fp, #idx]
	mov	r3, #16
	lsl	r1, r1, #4
	add	r1, r0, r1
	add	r3, r1, r3
	str	r2, [r3]			@settings[4 + 4 * idx]

	/* Move to the next controller */
	ldr	r2, [fp, #tzpc]
	ldr	r3, [fp, #tzpc_off]
	add	r3, r2, r3
	str	r3, [fp, #tzpc]

	/* Increment index of loop */
	ldr	r3, [fp, #idx]
	add	r3, r3, #1
	str	r3, [fp, #idx]
.Ltzpcsav_next1:
	ldr	r2, [fp, #idx]

	/* Is it the last controller? */
	ld_imm	r3, hwinfo
	ldr	r3, [r3, #tzpc_count]
	cmp	r2, r3
	bcc	.Ltzpcsav_loop1

	/* return 0 */
	mov	r3, #0
	mov	r0, r3
	add	sp, fp, #0
	pop	{fp}
	bx	lr

	.size	save_tzpc_secure, .-save_tzpc_secure


/* ========================================================================
 *  Offset: 0x015C4
 *  int restore_tzpc_secure(u32 *settings);
 *
 *  Parameters: settings[1 + 4 * 12] = settings[49]
 * ========================================================================
 */
	.globl	restore_tzpc_secure
	.align	2
	.type	restore_tzpc_secure, %function

restore_tzpc_secure:
	str	fp, [sp, #-4]!			@ push {fp}
	add	fp, sp, #0
	sub	sp, sp, #28

	/* Local variables in stack */
	.equ	tzpc,		-8
	.equ	idx,		-12
	.equ	tzpc_off,	-16
	.equ	settings,	-24

	str	r0, [fp, #settings]

	/* Load TZPC configuration into local variables */
	ld_imm	r3, hwinfo
	ldr	r3, [r3, #tzpc_base]
	str	r3, [fp, #tzpc]

	ld_imm	r3, hwinfo
	ldr	r3, [r3, #tzpc_offset]
	str	r3, [fp, #tzpc_off]

	mov	r3, #0
	str	r3, [fp, #idx]

	ldr	r3, [fp, #tzpc]
	ldr	r2, [fp, #settings]
	ldr	r2, [r2]			@ settings[0]
	str	r2, [r3]			@ R0SIZE

	/* Loop to set DECPROT<0,1,2,3> for all controllers */
	mov	r3, #0
	str	r3, [fp, #idx]
	b	.Ltzpcres_next1
.Ltzpcres_loop1:
	/* Clear all security bits for DECPROT0 */
	ldr	r3, [fp, #tzpc]
	add	r3, r3, #TZPC_DECPROT0STAT
	add	r3, r3, #(TZPC_DECPROT0CLR - TZPC_DECPROT0STAT)
	mvn	r2, #0
	str	r2, [r3]

	ldr	r3, [fp, #tzpc]
	add	r3, r3, #TZPC_DECPROT0STAT
	add	r3, r3, #(TZPC_DECPROT0SET - TZPC_DECPROT0STAT)

	ldr	r0, [fp, #settings]
	ldr	r1, [fp, #idx]
	mov	r2, #4
	lsl	r1, r1, #4
	add	r1, r0, r1
	add	r2, r1, r2
	ldr	r2, [r2]			@ settings[1 + 4 * idx]
	str	r2, [r3]

	/* Clear all security bits for DECPROT1 */
	ldr	r3, [fp, #tzpc]
	add	r3, r3, #TZPC_DECPROT1SET
	add	r3, r3, #(TZPC_DECPROT1CLR - TZPC_DECPROT1SET)
	mvn	r2, #0
	str	r2, [r3]

	ldr	r3, [fp, #tzpc]
	add	r3, r3, #TZPC_DECPROT1SET

	ldr	r0, [fp, #settings]
	ldr	r1, [fp, #idx]
	mov	r2, #8
	lsl	r1, r1, #4
	add	r1, r0, r1
	add	r2, r1, r2
	ldr	r2, [r2]			@ settings[2 + 4 * idx]
	str	r2, [r3]

	/* Clear all security bits for DECPROT2 */
	ldr	r3, [fp, #tzpc]
	add	r3, r3, #TZPC_DECPROT2CLR
	mvn	r2, #0
	str	r2, [r3]

	ldr	r3, [fp, #tzpc]
	add	r3, r3, #TZPC_DECPROT1SET
	add	r3, r3, #(TZPC_DECPROT2SET - TZPC_DECPROT1SET)

	ldr	r0, [fp, #settings]
	ldr	r1, [fp, #idx]
	mov	r2, #12
	lsl	r1, r1, #4
	add	r1, r0, r1
	add	r2, r1, r2
	ldr	r2, [r2]			@ settings[3 + 4 * idx]
	str	r2, [r3]

	/* Clear all security bits for DECPROT3 */
	ldr	r3, [fp, #tzpc]
	add	r3, r3, #TZPC_DECPROT2CLR
	add	r3, r3, #(TZPC_DECPROT3CLR - TZPC_DECPROT2CLR)
	mvn	r2, #0

	str	r2, [r3]
	ldr	r3, [fp, #tzpc]
	add	r3, r3, #TZPC_DECPROT2CLR
	add	r3, r3, #(TZPC_DECPROT3SET - TZPC_DECPROT2CLR)

	ldr	r0, [fp, #settings]
	ldr	r1, [fp, #idx]
	mov	r2, #16
	lsl	r1, r1, #4
	add	r1, r0, r1
	add	r2, r1, r2
	ldr	r2, [r2]			@ settings[4 + 4 * idx]
	str	r2, [r3]

	/* Move to the next controller */
	ldr	r2, [fp, #tzpc]
	ldr	r3, [fp, #tzpc_off]
	add	r3, r2, r3
	str	r3, [fp, #tzpc]

	/* Increment index of loop */
	ldr	r3, [fp, #idx]
	add	r3, r3, #1
	str	r3, [fp, #idx]
 .Ltzpcres_next1:
	ldr	r2, [fp, #idx]

	/* Is it the last controller? */
	ld_imm	r3, hwinfo
	ldr	r3, [r3, #tzpc_count]
	cmp	r2, r3
	bcc	.Ltzpcres_loop1

	/* return 0 */
	mov	r3, #0
	mov	r0, r3
	add	sp, fp, #0
	pop	{fp}
	bx	lr

	.size	restore_tzpc_secure, .-restore_tzpc_secure


/* ========================================================================
 *  (Additional function)
 *  int disable_tzpc(void);
 * ========================================================================
 */
	.globl	disable_tzpc
	.align	2
	.type	disable_tzpc, %function

disable_tzpc:
	str	fp, [sp, #-4]!			@ push {fp}
	add	fp, sp, #0
	sub	sp, sp, #20

	/* Local variables in stack */
	.equ	tzpc,		-8
	.equ	idx,		-12
	.equ	tzpc_off,	-16


	/* Load TZPC configuration into local variables */
	ld_imm	r3, hwinfo
	ldr	r3, [r3, #tzpc_base]
	str	r3, [fp, #tzpc]

	ld_imm	r3, hwinfo
	ldr	r3, [r3, #tzpc_offset]
	str	r3, [fp, #tzpc_off]

	/* Set R0SIZE = 0 for the first controller */
	ldr	r3, [fp, #tzpc]
	mov	r2, #0
	str	r2, [r3]			@ R0SIZE

	/* Loop to set DECPROT<0,1,2,3> for all controllers */
	mov	r3, #0
	str	r3, [fp, #idx]
	b	.Ltzpcdis_next1
.Ltzpcdis_loop1:
	/* Set all security bits for DECPROT0 */
	ldr	r3, [fp, #tzpc]
	add	r3, r3, #TZPC_DECPROT0STAT
	add	r3, r3, #(TZPC_DECPROT0SET - TZPC_DECPROT0STAT)
	mvn	r2, #0
	str	r2, [r3]

	/* Set all security bits for DECPROT1 */
	ldr	r3, [fp, #tzpc]
	add	r3, r3, #TZPC_DECPROT0STAT
	add	r3, r3, #(TZPC_DECPROT1SET - TZPC_DECPROT0STAT)
	mvn	r2, #0
	str	r2, [r3]

	/* Set all security bits for DECPROT2 */
	ldr	r3, [fp, #tzpc]
	add	r3, r3, #TZPC_DECPROT0STAT
	add	r3, r3, #(TZPC_DECPROT2SET - TZPC_DECPROT0STAT)
	mvn	r2, #0
	str	r2, [r3]

	/* Set all security bits for DECPROT3 */
	ldr	r3, [fp, #tzpc]
	add	r3, r3, #TZPC_DECPROT2CLR
	add	r3, r3, #(TZPC_DECPROT3SET - TZPC_DECPROT2CLR)
	mvn	r2, #0
	str	r2, [r3]

	/* Move to the next controller */
	ldr	r2, [fp, #tzpc]
	ldr	r3, [fp, #tzpc_off]
	add	r3, r2, r3
	str	r3, [fp, #tzpc]

	/* Increment index of loop */
	ldr	r3, [fp, #idx]
	add	r3, r3, #1
	str	r3, [fp, #idx]
 .Ltzpcdis_next1:
	ldr	r2, [fp, #idx]

	/* Is it the last controller? */
	ld_imm	r3, hwinfo
	ldr	r3, [r3, #tzpc_count]
	cmp	r2, r3
	bcc	.Ltzpcdis_loop1

	/* return 0 */
	mov	r3, #0
	mov	r0, r3
	add	sp, fp, #0
	pop	{fp}
	bx	lr

	.size	disable_tzpc, .-disable_tzpc


/* ========================================================================
 *  Offset: 0x01758
 *  int save_gic_secure(u32 *settings);
 *
 *  Parameters: settings[20]
 * ========================================================================
 */
	.globl	save_gic_secure
	.align	2
	.type	save_gic_secure, %function

save_gic_secure:
	str	fp, [sp, #-4]!			@ push {fp}
	add	fp, sp, #0
	sub	sp, sp, #28

	/* Local variables in stack */
	.equ	idx,		-8
	.equ	cpu_base,	-12
	.equ	dist_base,	-16
	.equ	nint, 		-20
	.equ	settings,	-24

	str	r0, [fp, #settings]

	/* Load GIC configuration into local variables */
	ld_imm	r3, hwinfo
	ldr	r3, [r3, #gic_cpu_base]
	str	r3, [fp, #cpu_base]

	ld_imm	r3, hwinfo
	ldr	r3, [r3, #gic_dist_base]
	str	r3, [fp, #dist_base]

	ld_imm	r3, hwinfo
	ldr	r3, [r3, #gic_num_interrupts]

	/* Divide by 32 and round up */
	add	r3, r3, #31
	lsr	r3, r3, #5
	str	r3, [fp, #nint]

	mov	r3, #0
	str	r3, [fp, #idx]

	/* Load CPU_CTRL, CPU_PRIMASK, and CPU_BINPOINT */
	ldr	r3, [fp, #cpu_base]
	ldr	r2, [r3]
	ldr	r3, [fp, #settings]		@ settings[0]
	str	r2, [r3]			@ GIC_CPU_CTRL

	ldr	r3, [fp, #cpu_base]
	add	r3, r3, #GIC_CPU_PRIMASK
	ldr	r2, [r3]
	ldr	r3, [fp, #settings]
	str	r2, [r3, #4]			@ settings[1]

	ldr	r3, [fp, #cpu_base]
	add	r3, r3, #GIC_CPU_BINPOINT
	ldr	r2, [r3]
	ldr	r3, [fp, #settings]
	str	r2, [r3, #8]			@ settings[2]


	/* Now read GIC_DIST_CTRL according into settings */
	ldr	r3, [fp, #dist_base]
	ldr	r2, [r3]			@ GIC_DIST_CTRL
	ldr	r3, [fp, #settings]
	str	r2, [r3, #12]			@ settings[3]

	/* Loop to read GIC_DIST_IGROUP */
	mov	r3, #0
	str	r3, [fp, #idx]
	b	.Lgicsav_next1
.Lgicsav_loop1:
	ldr	r3, [fp, #idx]
	lsl	r3, r3, #2
	mov	r2, r3

	ldr	r3, [fp, #dist_base]
	add	r3, r2, r3
	add	r3, r3, #GIC_DIST_IGROUP

	ldr	r1, [r3]			@ ICDISR<idx>
	ldr	r3, [fp, #settings]
	ldr	r2, [fp, #idx]
	add	r2, r2, #4
	str	r1, [r3, r2, lsl #2]		@ settings[4 + idx]

	/* Increment idx (the loop counter) */
	ldr	r3, [fp, #idx]
	add	r3, r3, #1
	str	r3, [fp, #idx]
.Lgicsav_next1:
	ldr	r2, [fp, #idx]
	ldr	r3, [fp, #nint]
	cmp	r2, r3
	blt	.Lgicsav_loop1

	/* Loop to load enabled interrupts */
	mov	r3, #0
	str	r3, [fp, #idx]
	b	.Lgicsav_next2
.Lgicsav_loop2:
	ldr	r3, [fp, #idx]
	lsl	r3, r3, #2
	mov	r2, r3

	ldr	r3, [fp, #dist_base]
	add	r3, r2, r3
	add	r3, r3, #GIC_DIST_ENABLE_SET

	ldr	r1, [r3]			@ ICDISER <idx>
	ldr	r3, [fp, #settings]
	ldr	r2, [fp, #idx]
	add	r2, r2, #12
	str	r1, [r3, r2, lsl #2]		@ settings[12 + idx]

	/* Increment idx (the loop counter) */
	ldr	r3, [fp, #idx]
	add	r3, r3, #1
	str	r3, [fp, #idx]
.Lgicsav_next2:
	ldr	r2, [fp, #idx]
	ldr	r3, [fp, #nint]
	cmp	r2, r3
	blt	.Lgicsav_loop2

	/* return 0 */
	mov	r3, #0
	mov	r0, r3
	add	sp, fp, #0
	pop	{fp}
	bx	lr

	.size	save_gic_secure, .-save_gic_secure


/* ========================================================================
 *  Offset: 0x018AC
 *  int restore_gic_secure(u32 *settings);
 *
 *  Parameters: settings[20]
 * ========================================================================
 */
	.globl	restore_gic_secure
	.align	2
	.type	restore_gic_secure, %function

restore_gic_secure:
	str	fp, [sp, #-4]!			@ push {fp}
	add	fp, sp, #0
	sub	sp, sp, #28

	/* Local variables in stack */
	.equ	idx,		-8
	.equ	cpu_base,	-12
	.equ	dist_base,	-16
	.equ	nint, 		-20
	.equ	settings,	-24

	str	r0, [fp, #settings]

	/* Load GIC configuration into local variables */
	ld_imm	r3, hwinfo
	ldr	r3, [r3, #gic_cpu_base]
	str	r3, [fp, #cpu_base]

	ld_imm	r3, hwinfo
	ldr	r3, [r3, #gic_dist_base]
	str	r3, [fp, #dist_base]

	ld_imm	r3, hwinfo
	ldr	r3, [r3, #gic_num_interrupts]

	/* Divide by 32 and round up */
	add	r3, r3, #31
	lsr	r3, r3, #5
	str	r3, [fp, #nint]

	mov	r3, #0
	str	r3, [fp, #idx]

	/* Set CPU_CTRL, CPU_PRIMASK, and CPU_BINPOINT */
	ldr	r3, [fp, #cpu_base]
	ldr	r2, [fp, #settings]
	ldr	r2, [r2]			@ settings[0]
	str	r2, [r3]			@ GIC_CPU_CTRL

	ldr	r3, [fp, #cpu_base]
	add	r3, r3, #GIC_CPU_PRIMASK
	ldr	r2, [fp, #settings]
	ldr	r2, [r2, #4]			@ settings[1]
	str	r2, [r3]

	ldr	r3, [fp, #cpu_base]
	add	r3, r3, #GIC_CPU_BINPOINT
	ldr	r2, [fp, #settings]
	ldr	r2, [r2, #8]			@ settings[2]
	str	r2, [r3]

	/* Now set GIC_DIST_CTRL according to settings */
	ldr	r3, [fp, #dist_base]
	ldr	r2, [fp, #settings]
	ldr	r2, [r2, #12]			@ settings[3]
	str	r2, [r3]			@ GIC_DIST_CTRL

	/* Loop to set GIC_DIST_IGROUP */
	mov	r3, #0
	str	r3, [fp, #idx]
	b	.Lgicres_next1
.Lgicres_loop1:
	ldr	r3, [fp, #idx]
	lsl	r3, r3, #2
	mov	r2, r3

	ldr	r3, [fp, #dist_base]
	add	r3, r2, r3
	add	r3, r3, #GIC_DIST_IGROUP

	ldr	r2, [fp, #settings]
	ldr	r1, [fp, #idx]
	add	r1, r1, #4
	ldr	r2, [r2, r1, lsl #2]		@ settings[4 + idx]
	str	r2, [r3]			@ ICDISR<idx>

	/* Increment idx (the loop counter) */
	ldr	r3, [fp, #idx]
	add	r3, r3, #1
	str	r3, [fp, #idx]
.Lgicres_next1:
	ldr	r2, [fp, #idx]
	ldr	r3, [fp, #nint]
	cmp	r2, r3
	blt	.Lgicres_loop1


	/* Loop to configure the enabled interrupts */
	mov	r3, #0
	str	r3, [fp, #idx]
	b	.Lgicres_next2
.Lgicres_loop2:
	ldr	r3, [fp, #idx]
	lsl	r3, r3, #2
	mov	r2, r3

	ldr	r3, [fp, #dist_base]
	add	r3, r2, r3
	add	r3, r3, #GIC_DIST_ENABLE_CLEAR

	/* Disables all interrupts */
	mvn	r2, #0
	str	r2, [r3]			@ ICDICER <idx> = -1

	ldr	r3, [fp, #idx]
	lsl	r3, r3, #2
	mov	r2, r3

	ldr	r3, [fp, #dist_base]
	add	r3, r2, r3
	add	r3, r3, #GIC_DIST_ENABLE_SET

	ldr	r2, [fp, #settings]
	ldr	r1, [fp, #idx]
	add	r1, r1, #12
	ldr	r1, [r2, r1, lsl #2]		@ settings[12 + idx]

	ldr	r2, [fp, #settings]
	ldr	r0, [fp, #idx]
	add	r0, r0, #4
	ldr	r2, [r2, r0, lsl #2]		@ settings[4 + n]

	/* ((~settings[4 + n]) & settings[12 + n] */
	mvn	r2, r2
	and	r2, r1, r2

	/* Enables only the secure and enabled interrupts */
	str	r2, [r3]			@ ICDISER <idx>

	/* Increment idx (the loop counter) */
	ldr	r3, [fp, #idx]
	add	r3, r3, #1
	str	r3, [fp, #idx]
.Lgicres_next2:
	ldr	r2, [fp, #idx]
	ldr	r3, [fp, #nint]
	cmp	r2, r3
	blt	.Lgicres_loop2

	/* return 0 */
	mov	r3, #0
	mov	r0, r3
	add	sp, fp, #0
	pop	{fp}
	bx	lr

	.size	restore_gic_secure, .-restore_gic_secure

/* ========================================================================
 *  Offset: 0x01A38
 *  int save_hwstate_secure(void);
 * ========================================================================
 */
	.globl	save_hwstate_secure
	.align	2
	.type	save_hwstate_secure, %function

save_hwstate_secure:
	push	{fp, lr}
	add	fp, sp, #4

	ld_imm	r0, dmc_savebuf
	bl	save_dmc_secure

	ldr	r0, =(tzpc_savebuf)
	bl	save_tzpc_secure

	ldr	r0, =(gic_savebuf)
	bl	save_gic_secure

	mov	r3, #0
	mov	r0, r3
	pop	{fp, pc}

	.size	save_hwstate_secure, .-save_hwstate_secure
	.ltorg

/* ========================================================================
 *  Offset: 0x01A70
 *  int restore_hwstate_secure(int unused);
 * ========================================================================
 */
	.globl	restore_hwstate_secure
	.align	2
	.type	restore_hwstate_secure, %function

restore_hwstate_secure:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	str	r0, [fp, #-8]

	ld_imm	r0, dmc_savebuf
	bl	restore_dmc_secure

	ldr	r0, =(tzpc_savebuf)
	bl	restore_tzpc_secure

	ldr	r0, =(gic_savebuf)
	bl	restore_gic_secure

	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #4
	pop	{fp, pc}

	.size	restore_hwstate_secure, .-restore_hwstate_secure
	.ltorg

/* ========================================================================
 *                             Data section
 * ========================================================================
 */
	.data
	.align	14

	/* Include the auto-generated file with the translation table */
	/* Plese run "generate_table" to reconstruct the file */
	.include	"tzsw_table.S"


/* ========================================================================
 *                              Structures
 * ========================================================================
 */

	.struct	0
hwinfo_start:

dmc_tzascs:
        .struct	dmc_tzascs + 32
num_dmc_tzascs:
        .struct	num_dmc_tzascs + 4
tzasc_num_regions:
        .struct	tzasc_num_regions + 4
tzpc_base:
	.struct	tzpc_base + 4
tzpc_offset:
	.struct	tzpc_offset + 4
tzpc_count:
	.struct	tzpc_count + 4
gic_cpu_base:
	.struct	gic_cpu_base + 4
gic_dist_base:
	.struct	gic_dist_base + 4
gic_num_interrupts:
	.struct	gic_num_interrupts + 4

hwinfo_end:
hwinfo_length = hwinfo_end - hwinfo_start


	.struct	0
configuration_start:

confparam1:
	.struct	confparam1 + 4
confparam2:
	.struct	confparam2 + 4
confparam3:
	.struct	confparam3 + 4
confparam4:
	.struct	confparam4 + 4

configuration_end:
configuration_length = configuration_end - configuration_start

/* ========================================================================
 *                             BSS section
 * ========================================================================
 */
	.bss
hwinfo:
	.space	hwinfo_length

configuration:
	.space	configuration_length

dmc_savebuf:
	.space	120
tzpc_savebuf:
	.space	196
gic_savebuf:
	.space	80
prod_id:
	.space	4
