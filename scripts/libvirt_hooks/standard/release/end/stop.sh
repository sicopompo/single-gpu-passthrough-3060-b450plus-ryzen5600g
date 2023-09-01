#!/bin/bash
set -x
  
# Re-Bind GPU to Nvidia Driver
virsh nodedev-reattach pci_0000_01_00_1
virsh nodedev-reattach pci_0000_01_00_0

# remove kernel driver
rmmod vfio-pci

# Reload nvidia modules
modprobe nvidia
modprobe nvidia_modeset
modprobe nvidia_uvm
modprobe nvidia_drm

# Rebind VT consoles
echo "echo 1 > /sys/class/vtconsole/vtcon0/bind"
echo 0 > /sys/class/vtconsole/vtcon0/bind
# Some machines might have more than 1 virtual console. Add a line for each corresponding VTConsole
echo "echo 1 > /sys/class/vtconsole/vtcon1/bind"
echo 0 > /sys/class/vtconsole/vtcon1/bind

echo "nvidia-xconfig --query-gpu-info > /dev/null 2>&1"
nvidia-xconfig --query-gpu-info > /dev/null 2>&1
echo "echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind" 
echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

# Restart Display Manager
systemctl restart lightdm.service
