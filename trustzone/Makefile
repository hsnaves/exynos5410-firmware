PREFIX   := arm-linux-gnueabihf-
CC       := $(PREFIX)gcc
AS       := $(PREFIX)gcc
LD       := $(PREFIX)ld
AR       := $(PREFIX)ar
STRIP    := $(PREFIX)strip

INCDIR   := .
CFLAGS   := -Os -g -fno-common -ffixed-r8 -fno-builtin -ffreestanding -nostdinc -mfloat-abi=hard -mfpu=vfpv3 -marm -mno-thumb-interwork -mabi=aapcs-linux -march=armv7-a -mno-unaligned-access -fPIC -Wall -Wl,--build-id=none $(addprefix -I,$(INCDIR))
ASFLAGS  := $(CFLAGS)

LIBDIR   := .
LDFLAGS  := $(addprefix -L,$(LIBDIR)) -nostartfiles -T trustzone.lds -nostdlib
LIBS :=


all: tzsw.bin


%.bin: %.o 
	$(LINK.c) $^ $(LIBS) -o $*.elf
	$(STRIP) -s -O binary $*.elf -o $*.bin


clean:
	-rm -f tzsw.bin *.o *.elf
