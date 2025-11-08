cd ~/modules
cat domain bashrc >> ~/.bashrc
rm domain bashrc ~/init.tar.gz
source ~/.bashrc
update
apt install -y speedtest-cli
cd /etc/ssh
sed -i "s/#\(PasswordAuthentication\).*/\1 no/" sshd_config
rm -f sshd_config.d/*
printf "Enter swap size: "
read SWAP_SIZE
fallocate -l ${SWAP_SIZE} /swapfile
chmod 600 /swapfile
mkswap /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab
grep Port ~/backup/awg/wg0.conf
