IMG=ubuntu-22.04.3-preinstalled-server-arm64+raspi.img.xz
URL_IMG=https://cdimage.ubuntu.com/releases/22.04.03/release/${IMG}
# REPLACE WITH YOUR USB (`lsblk`)
USB=/dev/sdb
SYSTEM_BOOT_MOUNT=/tmp/pi-disk
USER_DATA_NODES=user-data-SSD-partition

.EXPORT_ALL_VARIABLES:

img/${IMG}:
	wget ${URL_IMG} -O img/${IMG}

.PHONY: wipe-disk
wipe-disk:
	sudo wipefs -a -f ${USB}

.PHONY: burn-image
burn-image:
	# `-d` decompress `<` redirect $FILE contents to expand `|` sending the output to `dd` to copy directly to $USB
	xz -d < img/${IMG} - | sudo dd bs=100M of=${USB}

.PHONY: mount-system-boot
mount-system-boot:
	sudo mkdir ${SYSTEM_BOOT_MOUNT}

.PHONY: prepare-gateway
prepare-gateway:
	sudo mount ${USB}1 ${SYSTEM_BOOT_MOUNT} 
	sudo cp cloud-init/gateway/user-data ${SYSTEM_BOOT_MOUNT}
	sudo cp cloud-init/gateway/network-config ${SYSTEM_BOOT_MOUNT}
	sudo umount ${SYSTEM_BOOT_MOUNT}
