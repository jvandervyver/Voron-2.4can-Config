#!/usr/bin/env bash

set -x

PRINTER_CONFIG="${HOME}/printer_data/config/printer.cfg"

CANBUS_UUID=`cat "${PRINTER_CONFIG}" | grep -A 2 '\[mcu EBB\]' | grep 'canbus_uuid:' | cut -d ' ' -f 2 | tr -d '[:space:]'`
CANBUS_INTERFACE=`cat "${PRINTER_CONFIG}" | grep -A 2 '\[mcu EBB\]' | grep 'canbus_interface:' | cut -d ' ' -f 2 | tr -d '[:space:]'`

python3 "${HOME}/CanBoot/scripts/flash_can.py" -i "${CANBUS_INTERFACE}" -f "${HOME}/firmwares/btt_ebb36_klipper.bin" -u "${CANBUS_UUID}"
