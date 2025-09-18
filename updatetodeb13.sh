cat <<EOF >/etc/apt/sources.list
deb http://ftp.debian.org/debian trixie main contrib non-free non-free-firmware
deb http://ftp.debian.org/debian trixie-updates main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
deb http://ftp.debian.org/debian trixie-backports main contrib non-free non-free-firmware
EOF

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confold" dist-upgrade -y

# Disable services that break in LXC / containers (harmless if not present)
systemctl disable --now systemd-networkd-wait-online.service || true
systemctl disable --now systemd-networkd.service || true
systemctl disable --now ifupdown-wait-online || true

# Install ifupdown2 (better networking stack for LXC/VMs)
apt-get install -y ifupdown2

# Cleanup
apt-get autoremove --purge -y
apt-get clean

reboot
