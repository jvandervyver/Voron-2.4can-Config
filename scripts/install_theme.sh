#!/usr/bin/env bash

THEME_DIRECTORY="${HOME}/printer_data/config/.theme"

mkdir "${THEME_DIRECTORY}"

wget 'https://raw.githubusercontent.com/jvandervyver/Voron-2.4can-Config/main/downloads/voron_logos/favicon-16x16.png' -O "${THEME_DIRECTORY}/favicon-16x16.png"
wget 'https://raw.githubusercontent.com/jvandervyver/Voron-2.4can-Config/main/downloads/voron_logos/favicon-32x32.png' -O "${THEME_DIRECTORY}/favicon-32x32.png"
wget 'https://raw.githubusercontent.com/jvandervyver/Voron-2.4can-Config/main/downloads/voron_logos/sidebar-logo.png' -O "${THEME_DIRECTORY}/sidebar-logo.png"