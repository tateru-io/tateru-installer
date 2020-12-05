.DELETE_ON_ERROR:
.PHONY: all clean qemu

all: build/out/installer.iso

.iid: Dockerfile $(shell find profile -type f)
	[ -s .iid ] && docker rmi --force $(shell cat .iid) || true
	rm -f .iid
	docker build profile -f Dockerfile --iidfile .iid

.cid: .iid
	[ -s .cid ] && docker rm $(shell cat .cid) || true
	rm -f .cid
	docker run --privileged --cidfile .cid -ti \
		$(shell cat .iid) /usr/bin/mkarchiso -v /profile

build/.dummy: .cid
	rm -fr build
	mkdir build
	docker export $(shell cat .cid) | tar -xf - -C build out/ work/iso/arch/boot
	touch $@

build/out/installer.iso: build/.dummy
	cp build/out/installer-*.iso $@

clean:
	\rm -fr .iid .cid build/

qemu: build/out/installer.iso
	qemu-system-x86_64 \
		-m 1024 \
		-name installer,process=deploy_installer \
		-device virtio-scsi-pci,id=scsi0 \
		-device "scsi-cd,bus=scsi0.0,drive=cdrom0" \
		-drive "id=cdrom0,if=none,format=raw,media=cdrom,readonly=on,file=build/out/installer.iso" \
		-kernel build/work/iso/arch/boot/x86_64/vmlinuz-linux \
		-initrd build/work/iso/arch/boot/x86_64/initramfs-linux.img \
		-append "cow_spacesize=768M console=ttyS0 archisobasedir=arch archisolabel=INSTALLER svc=http://10.0.2.2:7708/" \
		-device virtio-net-pci,romfile=,netdev=net0 \
		-netdev user,hostfwd=tcp::5555-:22,id=net0 \
		-machine type=q35,smm=on,accel=kvm,usb=on \
		-serial mon:stdio \
		-no-reboot \
		-nographic

