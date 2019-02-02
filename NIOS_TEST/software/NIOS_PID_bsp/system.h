/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'cpu' in SOPC Builder design 'NIOS_Qsys'
 * SOPC Builder design path: C:/Users/Tic-Tac/Desktop/TSP/PFE/PFE_FPGA/NIOS_TEST/NIOS_Qsys.sopcinfo
 *
 * Generated: Thu Jan 24 15:19:28 CET 2019
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_qsys"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x00010820
#define ALT_CPU_CPU_FREQ 50000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "small"
#define ALT_CPU_DATA_ADDR_WIDTH 0x11
#define ALT_CPU_DCACHE_LINE_SIZE 0
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_DCACHE_SIZE 0
#define ALT_CPU_EXCEPTION_ADDR 0x00008020
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 50000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 0
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 32
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 5
#define ALT_CPU_ICACHE_SIZE 2048
#define ALT_CPU_INST_ADDR_WIDTH 0x11
#define ALT_CPU_NAME "cpu"
#define ALT_CPU_RESET_ADDR 0x00008000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x00010820
#define NIOS2_CPU_FREQ 50000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "small"
#define NIOS2_DATA_ADDR_WIDTH 0x11
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_EXCEPTION_ADDR 0x00008020
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 0
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 32
#define NIOS2_ICACHE_LINE_SIZE_LOG2 5
#define NIOS2_ICACHE_SIZE 2048
#define NIOS2_INST_ADDR_WIDTH 0x11
#define NIOS2_RESET_ADDR 0x00008000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SYSID_QSYS
#define __ALTERA_AVALON_TIMER
#define __ALTERA_NIOS2_QSYS


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "Cyclone III"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/jtag_uart"
#define ALT_STDERR_BASE 0x11090
#define ALT_STDERR_DEV jtag_uart
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/jtag_uart"
#define ALT_STDIN_BASE 0x11090
#define ALT_STDIN_DEV jtag_uart
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/jtag_uart"
#define ALT_STDOUT_BASE 0x11090
#define ALT_STDOUT_DEV jtag_uart
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "NIOS_Qsys"


/*
 * hal configuration
 *
 */

#define ALT_MAX_FD 32
#define ALT_SYS_CLK SYS_CLK_TIMER
#define ALT_TIMESTAMP_CLK none


/*
 * jtag_uart configuration
 *
 */

#define ALT_MODULE_CLASS_jtag_uart altera_avalon_jtag_uart
#define JTAG_UART_BASE 0x11090
#define JTAG_UART_IRQ 16
#define JTAG_UART_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_NAME "/dev/jtag_uart"
#define JTAG_UART_READ_DEPTH 64
#define JTAG_UART_READ_THRESHOLD 8
#define JTAG_UART_SPAN 8
#define JTAG_UART_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_WRITE_DEPTH 64
#define JTAG_UART_WRITE_THRESHOLD 8


/*
 * onchip_mem configuration
 *
 */

#define ALT_MODULE_CLASS_onchip_mem altera_avalon_onchip_memory2
#define ONCHIP_MEM_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define ONCHIP_MEM_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define ONCHIP_MEM_BASE 0x8000
#define ONCHIP_MEM_CONTENTS_INFO ""
#define ONCHIP_MEM_DUAL_PORT 0
#define ONCHIP_MEM_GUI_RAM_BLOCK_TYPE "AUTO"
#define ONCHIP_MEM_INIT_CONTENTS_FILE "NIOS_Qsys_onchip_mem"
#define ONCHIP_MEM_INIT_MEM_CONTENT 1
#define ONCHIP_MEM_INSTANCE_ID "NONE"
#define ONCHIP_MEM_IRQ -1
#define ONCHIP_MEM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ONCHIP_MEM_NAME "/dev/onchip_mem"
#define ONCHIP_MEM_NON_DEFAULT_INIT_FILE_ENABLED 0
#define ONCHIP_MEM_RAM_BLOCK_TYPE "AUTO"
#define ONCHIP_MEM_READ_DURING_WRITE_MODE "DONT_CARE"
#define ONCHIP_MEM_SINGLE_CLOCK_OP 0
#define ONCHIP_MEM_SIZE_MULTIPLE 1
#define ONCHIP_MEM_SIZE_VALUE 25000
#define ONCHIP_MEM_SPAN 25000
#define ONCHIP_MEM_TYPE "altera_avalon_onchip_memory2"
#define ONCHIP_MEM_WRITABLE 1


/*
 * pio_encoder configuration
 *
 */

#define ALT_MODULE_CLASS_pio_encoder altera_avalon_pio
#define PIO_ENCODER_BASE 0x11080
#define PIO_ENCODER_BIT_CLEARING_EDGE_REGISTER 0
#define PIO_ENCODER_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PIO_ENCODER_CAPTURE 0
#define PIO_ENCODER_DATA_WIDTH 16
#define PIO_ENCODER_DO_TEST_BENCH_WIRING 0
#define PIO_ENCODER_DRIVEN_SIM_VALUE 0
#define PIO_ENCODER_EDGE_TYPE "NONE"
#define PIO_ENCODER_FREQ 50000000
#define PIO_ENCODER_HAS_IN 1
#define PIO_ENCODER_HAS_OUT 0
#define PIO_ENCODER_HAS_TRI 0
#define PIO_ENCODER_IRQ -1
#define PIO_ENCODER_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PIO_ENCODER_IRQ_TYPE "NONE"
#define PIO_ENCODER_NAME "/dev/pio_encoder"
#define PIO_ENCODER_RESET_VALUE 0
#define PIO_ENCODER_SPAN 16
#define PIO_ENCODER_TYPE "altera_avalon_pio"


/*
 * pio_kd configuration
 *
 */

#define ALT_MODULE_CLASS_pio_kd altera_avalon_pio
#define PIO_KD_BASE 0x11060
#define PIO_KD_BIT_CLEARING_EDGE_REGISTER 0
#define PIO_KD_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PIO_KD_CAPTURE 0
#define PIO_KD_DATA_WIDTH 10
#define PIO_KD_DO_TEST_BENCH_WIRING 0
#define PIO_KD_DRIVEN_SIM_VALUE 0
#define PIO_KD_EDGE_TYPE "NONE"
#define PIO_KD_FREQ 50000000
#define PIO_KD_HAS_IN 0
#define PIO_KD_HAS_OUT 1
#define PIO_KD_HAS_TRI 0
#define PIO_KD_IRQ -1
#define PIO_KD_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PIO_KD_IRQ_TYPE "NONE"
#define PIO_KD_NAME "/dev/pio_kd"
#define PIO_KD_RESET_VALUE 0
#define PIO_KD_SPAN 16
#define PIO_KD_TYPE "altera_avalon_pio"


/*
 * pio_ki configuration
 *
 */

#define ALT_MODULE_CLASS_pio_ki altera_avalon_pio
#define PIO_KI_BASE 0x11050
#define PIO_KI_BIT_CLEARING_EDGE_REGISTER 0
#define PIO_KI_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PIO_KI_CAPTURE 0
#define PIO_KI_DATA_WIDTH 10
#define PIO_KI_DO_TEST_BENCH_WIRING 0
#define PIO_KI_DRIVEN_SIM_VALUE 0
#define PIO_KI_EDGE_TYPE "NONE"
#define PIO_KI_FREQ 50000000
#define PIO_KI_HAS_IN 0
#define PIO_KI_HAS_OUT 1
#define PIO_KI_HAS_TRI 0
#define PIO_KI_IRQ -1
#define PIO_KI_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PIO_KI_IRQ_TYPE "NONE"
#define PIO_KI_NAME "/dev/pio_ki"
#define PIO_KI_RESET_VALUE 0
#define PIO_KI_SPAN 16
#define PIO_KI_TYPE "altera_avalon_pio"


/*
 * pio_kp configuration
 *
 */

#define ALT_MODULE_CLASS_pio_kp altera_avalon_pio
#define PIO_KP_BASE 0x11040
#define PIO_KP_BIT_CLEARING_EDGE_REGISTER 0
#define PIO_KP_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PIO_KP_CAPTURE 0
#define PIO_KP_DATA_WIDTH 10
#define PIO_KP_DO_TEST_BENCH_WIRING 0
#define PIO_KP_DRIVEN_SIM_VALUE 0
#define PIO_KP_EDGE_TYPE "NONE"
#define PIO_KP_FREQ 50000000
#define PIO_KP_HAS_IN 0
#define PIO_KP_HAS_OUT 1
#define PIO_KP_HAS_TRI 0
#define PIO_KP_IRQ -1
#define PIO_KP_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PIO_KP_IRQ_TYPE "NONE"
#define PIO_KP_NAME "/dev/pio_kp"
#define PIO_KP_RESET_VALUE 0
#define PIO_KP_SPAN 16
#define PIO_KP_TYPE "altera_avalon_pio"


/*
 * pio_leds configuration
 *
 */

#define ALT_MODULE_CLASS_pio_leds altera_avalon_pio
#define PIO_LEDS_BASE 0x11020
#define PIO_LEDS_BIT_CLEARING_EDGE_REGISTER 0
#define PIO_LEDS_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PIO_LEDS_CAPTURE 0
#define PIO_LEDS_DATA_WIDTH 10
#define PIO_LEDS_DO_TEST_BENCH_WIRING 0
#define PIO_LEDS_DRIVEN_SIM_VALUE 0
#define PIO_LEDS_EDGE_TYPE "NONE"
#define PIO_LEDS_FREQ 50000000
#define PIO_LEDS_HAS_IN 0
#define PIO_LEDS_HAS_OUT 1
#define PIO_LEDS_HAS_TRI 0
#define PIO_LEDS_IRQ -1
#define PIO_LEDS_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PIO_LEDS_IRQ_TYPE "NONE"
#define PIO_LEDS_NAME "/dev/pio_leds"
#define PIO_LEDS_RESET_VALUE 0
#define PIO_LEDS_SPAN 16
#define PIO_LEDS_TYPE "altera_avalon_pio"


/*
 * pio_reset_pid configuration
 *
 */

#define ALT_MODULE_CLASS_pio_reset_pid altera_avalon_pio
#define PIO_RESET_PID_BASE 0x11030
#define PIO_RESET_PID_BIT_CLEARING_EDGE_REGISTER 0
#define PIO_RESET_PID_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PIO_RESET_PID_CAPTURE 0
#define PIO_RESET_PID_DATA_WIDTH 1
#define PIO_RESET_PID_DO_TEST_BENCH_WIRING 0
#define PIO_RESET_PID_DRIVEN_SIM_VALUE 0
#define PIO_RESET_PID_EDGE_TYPE "NONE"
#define PIO_RESET_PID_FREQ 50000000
#define PIO_RESET_PID_HAS_IN 0
#define PIO_RESET_PID_HAS_OUT 1
#define PIO_RESET_PID_HAS_TRI 0
#define PIO_RESET_PID_IRQ -1
#define PIO_RESET_PID_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PIO_RESET_PID_IRQ_TYPE "NONE"
#define PIO_RESET_PID_NAME "/dev/pio_reset_pid"
#define PIO_RESET_PID_RESET_VALUE 0
#define PIO_RESET_PID_SPAN 16
#define PIO_RESET_PID_TYPE "altera_avalon_pio"


/*
 * pio_setpoint configuration
 *
 */

#define ALT_MODULE_CLASS_pio_setpoint altera_avalon_pio
#define PIO_SETPOINT_BASE 0x11070
#define PIO_SETPOINT_BIT_CLEARING_EDGE_REGISTER 0
#define PIO_SETPOINT_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PIO_SETPOINT_CAPTURE 0
#define PIO_SETPOINT_DATA_WIDTH 10
#define PIO_SETPOINT_DO_TEST_BENCH_WIRING 0
#define PIO_SETPOINT_DRIVEN_SIM_VALUE 0
#define PIO_SETPOINT_EDGE_TYPE "NONE"
#define PIO_SETPOINT_FREQ 50000000
#define PIO_SETPOINT_HAS_IN 0
#define PIO_SETPOINT_HAS_OUT 1
#define PIO_SETPOINT_HAS_TRI 0
#define PIO_SETPOINT_IRQ -1
#define PIO_SETPOINT_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PIO_SETPOINT_IRQ_TYPE "NONE"
#define PIO_SETPOINT_NAME "/dev/pio_setpoint"
#define PIO_SETPOINT_RESET_VALUE 0
#define PIO_SETPOINT_SPAN 16
#define PIO_SETPOINT_TYPE "altera_avalon_pio"


/*
 * sys_clk_timer configuration
 *
 */

#define ALT_MODULE_CLASS_sys_clk_timer altera_avalon_timer
#define SYS_CLK_TIMER_ALWAYS_RUN 0
#define SYS_CLK_TIMER_BASE 0x11000
#define SYS_CLK_TIMER_COUNTER_SIZE 32
#define SYS_CLK_TIMER_FIXED_PERIOD 0
#define SYS_CLK_TIMER_FREQ 50000000
#define SYS_CLK_TIMER_IRQ 1
#define SYS_CLK_TIMER_IRQ_INTERRUPT_CONTROLLER_ID 0
#define SYS_CLK_TIMER_LOAD_VALUE 49999
#define SYS_CLK_TIMER_MULT 0.0010
#define SYS_CLK_TIMER_NAME "/dev/sys_clk_timer"
#define SYS_CLK_TIMER_PERIOD 1
#define SYS_CLK_TIMER_PERIOD_UNITS "ms"
#define SYS_CLK_TIMER_RESET_OUTPUT 0
#define SYS_CLK_TIMER_SNAPSHOT 1
#define SYS_CLK_TIMER_SPAN 32
#define SYS_CLK_TIMER_TICKS_PER_SEC 1000.0
#define SYS_CLK_TIMER_TIMEOUT_PULSE_OUTPUT 0
#define SYS_CLK_TIMER_TYPE "altera_avalon_timer"


/*
 * sysid configuration
 *
 */

#define ALT_MODULE_CLASS_sysid altera_avalon_sysid_qsys
#define SYSID_BASE 0x11098
#define SYSID_ID 0
#define SYSID_IRQ -1
#define SYSID_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYSID_NAME "/dev/sysid"
#define SYSID_SPAN 8
#define SYSID_TIMESTAMP 1548331314
#define SYSID_TYPE "altera_avalon_sysid_qsys"

#endif /* __SYSTEM_H_ */
