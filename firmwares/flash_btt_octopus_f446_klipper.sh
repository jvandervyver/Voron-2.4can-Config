#!/usr/bin/env bash

set -x

FIRMWARES_DIR="${HOME}/firmwares"
PRINTER_CONFIG="${HOME}/printer_data/config/printer.cfg"
OCTOPUS_PATH=`cat "${PRINTER_CONFIG}" | grep -A 2 '\[mcu Octopus\]' | grep 'serial:' | cut -d ' ' -f 2 | tr -d '[:space:]'`

sudo python3 "${HOME}/klipper/scripts/flash_usb.py" -t 'stm32f446xx' -d "${OCTOPUS_PATH}" -s '0x8008000' "${FIRMWARES_DIR}/btt_octopus_f446_klipper.bin"

#sleep 2
#sudo dfu-util -d ,0483:df11 -R -a 0 -s 0x8008000:leave -D "${FIRMWARES_DIR}/btt_octopus_f446_klipper.bin"
