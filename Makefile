ASM=nasm
CC=i686-elf-gcc
LD=i686-elf-ld
QEMU=qemu-system-x86_64

CFLAGS=-ffreestanding -nostdlib -m32 -Isrc/include/ -g -c


SRC_DIR=src
BUILD_DIR=build


$(BUILD_DIR)/floppy.img: $(BUILD_DIR)/boot.bin $(BUILD_DIR)/stage2.bin $(BUILD_DIR)/full_kernel.bin
	dd if=/dev/zero of=$@ bs=512 count=2880
	dd if=$(BUILD_DIR)/boot.bin of=$@ conv=notrunc
	dd if=$(BUILD_DIR)/stage2.bin of=$@ bs=512 seek=1 conv=notrunc
	dd if=$(BUILD_DIR)/full_kernel.bin of=$@ bs=512 seek=2 conv=notrunc


#
# Bootloader
#
$(BUILD_DIR)/boot.bin: $(SRC_DIR)/bootloader/boot.asm
	$(ASM) $< -f bin -o $@

$(BUILD_DIR)/stage2.bin: $(SRC_DIR)/bootloader/stage2.asm
	$(ASM) $< -f bin -o $@


#
# Kernel
#
$(BUILD_DIR)/full_kernel.bin: $(BUILD_DIR)/kernel_entry.o $(BUILD_DIR)/kernel.o $(BUILD_DIR)/stdio.o
	$(LD) -T src/linker.ld -o $@ $^ --oformat binary

$(BUILD_DIR)/kernel_entry.o: $(SRC_DIR)/kernel/kernel_entry.asm
	$(ASM) $< -f elf -o $@

$(BUILD_DIR)/kernel.o: $(SRC_DIR)/kernel/kernel.c
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/stdio.o: $(SRC_DIR)/kernel/stdio.c
	$(CC) $(CFLAGS) $< -o $@


clean:
	rm -rf $(BUILD_DIR)/*


run: $(BUILD_DIR)/floppy.img
	$(QEMU) -hda $<
