### Requirements

- [Mainsail OS](https://docs-os.mainsail.xyz/)
- Raspberry Pi
- Octopus Pro F446
- BTT U2C
- BTT EBB36

### Fix Mainsail OS Locale

```
sudo wget 'https://raw.githubusercontent.com/jvandervyver/Voron-2.4can-Config/main/downloads/locale.config' -O '/etc/default/locale'
```

### Flash candlelight_FW

```bash
mkdir ~/firmwares
cd ~/firmwares
git clone https://github.com/candle-usb/candleLight_fw.git
cd candleLight_fw
```

[Follow build instructions](https://github.com/candle-usb/candleLight_fw#building)


### Add Can network adapter

```
sudo wget 'https://raw.githubusercontent.com/jvandervyver/Voron-2.4can-Config/main/downloads/can0.config' -O '/etc/network/interfaces.d/can0'
sudo reboot now
```

### Flash CanBoot

```bash
mkdir ~/firmwares
cd ~/firmwares
git clone https://github.com/Arksine/CanBoot.git
make clean
make menuconfig
```

![Klipper Octopus Menuconfig](https://raw.githubusercontent.com/jvandervyver/Voron-2.4can-Config/main/downloads/canboot_ebb36.png)

[Follow the rest of the insturctions for flashing](https://maz0r.github.io/klipper_canbus/toolhead/ebb36-42_v1.1.html) CanBoot in DFU mode.

### Klipper firmware setup

Setup firmware build repos

```bash
mkdir ~/firmwares
cd ~/firmwares

git clone https://github.com/Klipper3d/klipper.git

```

### Setup menu config for Raspberry Pi

```bash
cd ~/firmwares/klipper
make clean KCONFIG_CONFIG=config.rpi
make menuconfig KCONFIG_CONFIG=config.rpi
make flash KCONFIG_CONFIG=config.rpi
```

![Klipper Octopus Menuconfig](https://raw.githubusercontent.com/jvandervyver/Voron-2.4can-Config/main/downloads/klipper_mcu.png)

```bash
sudo wget '' -O '/etc/systemd/system/klipper-mcu.service'
sudo systemctl enable klipper-mcu.service
sudo service klipper-mcu start
```

### Setup menu config for Octopus F446

```bash
cd ~/firmwares/klipper
make clean KCONFIG_CONFIG=config.octopus_f446
make menuconfig KCONFIG_CONFIG=config.octopus_f446
```

![Klipper Octopus Menuconfig](https://raw.githubusercontent.com/jvandervyver/Voron-2.4can-Config/main/downloads/klipper_octopus.png)

### Setup menu config for EBB36

```bash
cd ~/firmwares/klipper
make clean KCONFIG_CONFIG=config.ebb_36
make menuconfig KCONFIG_CONFIG=config.ebb_36
```

![Klipper Octopus Menuconfig](https://raw.githubusercontent.com/jvandervyver/Voron-2.4can-Config/main/downloads/klipper_ebb36.png)

