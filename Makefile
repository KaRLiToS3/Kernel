all: os-image

boot.o: boot.s
	as --32 boot.s -o boot.o

kernel.o: kernel.c
	gcc -m32 -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

kernel.bin: kernel.o boot.o linker.ld
	ld -m elf_i386 -T linker.ld kernel.o boot.o -o kernel.bin -nostdlib
	grub-file --is-x86-multiboot kernel.bin

os-image: kernel.bin
	mkdir -p iso/boot/grub
	cp kernel.bin iso/boot/kernel.bin
	echo 'set timeout=0' > iso/boot/grub/grub.cfg
	echo 'set default=0' >> iso/boot/grub/grub.cfg
	echo 'menuentry "My OS" {' >> iso/boot/grub/grub.cfg
	echo '    multiboot /boot/kernel.bin' >> iso/boot/grub/grub.cfg
	echo '}' >> iso/boot/grub/grub.cfg
	grub-mkrescue -o os-image.iso iso

run: os-image
	qemu-system-x86_64 -cdrom os-image.iso -m 512M

clean:
	rm -f *.o *.bin iso/boot/kernel.bin iso/boot/grub/grub