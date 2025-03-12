#!/bin/bash
# Initial setup configuration
useradd -m -s /bin/bash radxa
echo "radxa:radxa" | chpasswd
usermod -aG sudo radxa
rm -f /etc/config.sh
sed -i '/\/etc\/config.sh/d' /etc/rc.local
exit 0
