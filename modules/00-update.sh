cat bashrc >> ~/.bashrc
source bashrc
rm bashrc
update
apt install -y speedtest-cli
speedtest

cd /etc/ssh
sed -i "s/#\(PasswordAuthentication\).*/\1 no/" sshd_config
rm -f sshd_config.d/*

read -p "Enter swap size: " SWAP_SIZE
fallocate -l ${SWAP_SIZE} /swapfile
chmod 600 /swapfile
mkswap /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab

cat ~/backup/awg/wg0.conf | grep Port
reboot
