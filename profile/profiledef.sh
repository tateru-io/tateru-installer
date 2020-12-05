#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="installer"
iso_label="INSTALLER"
iso_publisher="Internet Randoms"
iso_application="Deployment Installer"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/rc.installer"]="0:0:755"
)
