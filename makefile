CC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy

CFLAGS = -mcpu=cortex-m0plus -mthumb -O0 -ffreestanding -Iinclude
LDFLAGS = -T linker/pico_memmap.ld -nostdlib -lgcc

SRC = \
application/main.c \
boot/boot2.c \
boot/reset_hdr.c \
boot/vector_tbl.c \
kernel/syslib.c

OBJ = $(SRC:.c=.o)

all: kernel.uf2

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.S: %.c
	$(CC) $(CFLAGS) -S $< -o $@

kernel.elf: $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) $(LDFLAGS) -o $@

kernel.bin: kernel.elf
	$(OBJCOPY) -O binary $< $@

kernel.uf2: kernel.elf
	./elf2uf2/elf2uf2 $< $@

clean:
	rm *.bin *.elf application/*.o boot/*.o *.uf2 application/*.S boot/*.S
