### Requirements

- [Mainsail OS](https://docs-os.mainsail.xyz/)
- Raspberry Pi
- Octopus Pro F446
- BTT U2C
- BTT EBB36

### Initial setup

Become root
```bash
sudo su -
```

Update Pi user so that password is not required to sudo
```bash
vi /etc/sudoers.d/010_pi-nopasswd
```

Update APT sources
```bash
vi /etc/apt/sources.list
```

Update apt sources to use local server, comment old server
```
# deb http://raspbian.raspberrypi.org/raspbian/ bullseye main contrib non-free rpi
deb http://raspbian.mirror.ac.za/raspbian/ bullseye main contrib non-free rpi
```

Update
```bash
apt clean all
apt update -y
apt dist-upgrade -y
```

Better editor
```bash
apt install vim
select-editor
apt purge nano
```

Update NTP server
```bash
vi /etc/systemd/timesyncd.conf
```

Update locale using `sudo raspi-config` to `en_US.UTF-8` then run
```bash
vi /etc/default/locale
```

Paste:
```conf
LANGUAGE=en_US.UTF-8
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8
LC_CTYPE=en_US.UTF-8
```

Reboot
```bash
reboot now
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
sudo wget 'https://raw.githubusercontent.com/jvandervyver/Voron-2.4can-Config/main/downloads/klipper-mcu.service' -O '/etc/systemd/system/klipper-mcu.service'
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

### Install config

```bash
cd ~
git clone https://github.com/jvandervyver/Voron-2.4can-Config.git

ln -s ~/Voron-2.4can-Config/config/klippy.conf ~/printer_data/config/klippy.conf
ln -s ~/Voron-2.4can-Config/config/printer ~/printer_data/config/printer

mkdir ~/printer_data/config/macros
ln -s ~/moonraker-timelapse/klipper_macro ~/printer_data/config/macros/timelapse

mkdir ~/printer_data/config/macros/mainsail
ln -s ~/mainsail-config/mainsail.cfg ~/printer_data/config/macros/mainsail/mainsail.cfg

rm ~/printer_data/config/timelapse.cfg
rm ~/printer_data/config/mainsail.cfg
```

Update klipper environment to use klippy.conf
```bash
vi ~/printer_data/systemd/klipper.env
```
