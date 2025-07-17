# Build the bootloader binary
boot.bin: boot.asm
	nasm -f bin boot.asm -o boot.bin

# Run the bootloader in QEMU
run: boot.bin
	qemu-system-x86_64 boot.bin

# Clean generated files
clean:
	rm -f boot.bin