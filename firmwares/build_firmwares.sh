#!/usr/bin/env bash

FIRMWARES_DIR="${HOME}/firmwares"
KLIPPER_DIR="${FIRMWARES_DIR}/klipper"

SKIP_MENUCONFIG='true'
EBB_SPI_PATCH='true'

while [[ $# -gt 0 ]]; do
  # Check if the current argument is a parameter flag
  case "$1" in
    --skip-menuconfig=*)
      MAKE_MENUCONFIG="${1#*=}"
      shift
      ;;
    --ebb-spi-patch=*)
      EBB_SPI_PATCH="${1#*=}"
      shift
      ;;
    *)
      shift
      ;;
  esac
done

SKIP_MENUCONFIG=$(echo "${SKIP_MENUCONFIG}" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')
if [ "${SKIP_MENUCONFIG}" != "true" ]; then
  if [ "${SKIP_MENUCONFIG}" != "false" ]; then
  	echo '--skip-menuconfig must be either either "true" or "false"'
  	exit 1
  fi
fi

EBB_SPI_PATCH=$(echo "${EBB_SPI_PATCH}" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')
if [ "${EBB_SPI_PATCH}" != "true" ]; then
  if [ "${EBB_SPI_PATCH}" != "false" ]; then
  	echo '--ebb-spi-patch must be either either "true" or "false"'
  	exit 1
  fi
fi

rm "${FIRMWARES_DIR}/btt_octopus_f446_klipper.bin"
rm "${FIRMWARES_DIR}/btt_ebb36_klipper.bin"

cd "${KLIPPER_DIR}"

make clean KCONFIG_CONFIG=config.rpi
make clean KCONFIG_CONFIG=config.octopus_f446
make clean KCONFIG_CONFIG=config.ebb_36

git reset --hard
git pull

######### Build Raspberry Pi firmware

make clean KCONFIG_CONFIG=config.rpi
if [ "${SKIP_MENUCONFIG}" != "true" ]; then
  make menuconfig KCONFIG_CONFIG=config.rpi
fi
make flash KCONFIG_CONFIG=config.rpi

######### Build Octopus Pro firmware

make clean KCONFIG_CONFIG=config.octopus_f446
if [ "${SKIP_MENUCONFIG}" != "true" ]; then
  make menuconfig KCONFIG_CONFIG=config.octopus_f446
fi
make KCONFIG_CONFIG=config.octopus_f446
cp "${KLIPPER_DIR}/out/klipper.bin" "${FIRMWARES_DIR}/btt_octopus_f446_klipper.bin"
chmod 664 "${FIRMWARES_DIR}/btt_octopus_f446_klipper.bin"
#make flash KCONFIG_CONFIG=config.octopus_pro FLASH_DEVICE='/dev/serial/by-id/usb-Klipper_stm32f446xx_2A0026000D50315939343520-if00'

######### Build EBB 36 firmware

make clean KCONFIG_CONFIG=config.ebb_36

# Patch for spi2b
if [ "${EBB_SPI_PATCH}" = "true" ]; then
  mv "${KLIPPER_DIR}/src/stm32/spi.c" "${KLIPPER_DIR}/src/stm32/spi.c.old"
  wget 'https://raw.githubusercontent.com/Klipper3d/klipper/ddf63fb47950e90ce402f3f0a9356514a533ccc8/src/stm32/spi.c' -O "${KLIPPER_DIR}/src/stm32/spi.c"
fi

if [ "${SKIP_MENUCONFIG}" != "true" ]; then
  make menuconfig KCONFIG_CONFIG=config.ebb_36
fi

make KCONFIG_CONFIG=config.ebb_36
cp "${KLIPPER_DIR}/out/klipper.bin" "${FIRMWARES_DIR}/btt_ebb36_klipper.bin"
chmod 664 "${FIRMWARES_DIR}/btt_ebb36_klipper.bin"
#python3 ~/CanBoot/scripts/flash_can.py -i can0 -f '~/firmware/btt_ebb36.bin' -u '2d20be116df9'

# Undo patch
if [ "${EBB_SPI_PATCH}" = "true" ]; then
  mv "${KLIPPER_DIR}/src/stm32/spi.c.old" "${KLIPPER_DIR}/src/stm32/spi.c"
fi

# General cleanup

make clean KCONFIG_CONFIG=config.rpi
make clean KCONFIG_CONFIG=config.octopus_f446
make clean KCONFIG_CONFIG=config.ebb_36

