cat bashrc >> ~/.bashrc
source bashrc
rm bashrc
update
apt install -y speedtest-cli
speedtest

cd /etc/ssh
WORD="PasswordAuthentication"
sed -i "s/#$WORD yes/$WORD no/" sshd_config
rm -f sshd_config.d/*
systemctl restart sshd

read -p "Enter swap size: " SWAP_SIZE
fallocate -l ${SWAP_SIZE} /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab
