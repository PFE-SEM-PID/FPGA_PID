/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include <stdint.h>
#include "io.h"
#include "alt_types.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_irq.h"
#include "system.h"
#include <unistd.h>

int main()
{
  printf("Nios II Started\n");
  IOWR_ALTERA_AVALON_PIO_DIRECTION(PIO_SETPOINT_BASE, 0b1111111111);
  IOWR_ALTERA_AVALON_PIO_DIRECTION(PIO_KP_BASE, 0b1111111111);
  IOWR_ALTERA_AVALON_PIO_DIRECTION(PIO_KI_BASE, 0b1111111111);
  IOWR_ALTERA_AVALON_PIO_DIRECTION(PIO_KD_BASE, 0b1111111111);
  IOWR_ALTERA_AVALON_PIO_DIRECTION(PIO_SETPOINT_BASE, 0b0000000000000000);
  IOWR_ALTERA_AVALON_PIO_DIRECTION(PIO_RESET_PID_BASE, 0);
  IOWR_ALTERA_AVALON_PIO_DIRECTION(PIO_LEDS_BASE, 0b1111111111);
  usleep(500000);

  IOWR_ALTERA_AVALON_PIO_DATA(PIO_SETPOINT_BASE, 0);
  IOWR_ALTERA_AVALON_PIO_DATA(PIO_KP_BASE, 163);
  IOWR_ALTERA_AVALON_PIO_DATA(PIO_KI_BASE, 20);
  IOWR_ALTERA_AVALON_PIO_DATA(PIO_KD_BASE, 140);
  IOWR_ALTERA_AVALON_PIO_DATA(PIO_RESET_PID_BASE, 1);
  IOWR_ALTERA_AVALON_PIO_DATA(PIO_LEDS_BASE, 0b1111111111);

  int16_t last_cod=IORD_ALTERA_AVALON_PIO_DATA(PIO_ENCODER_BASE);
  while(1)
  {
	  int16_t cod=IORD_ALTERA_AVALON_PIO_DATA(PIO_ENCODER_BASE);
	  if(cod==last_cod) continue;
	  IOWR_ALTERA_AVALON_PIO_DATA(PIO_LEDS_BASE, cod&0b0011111111);
	  printf("Cod:%d\n", cod);
	  last_cod=cod;
  }
  return 0;
}
