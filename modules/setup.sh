apt-get update
apt-get install -y zstd
echo "openssh-server openssh-server/sshd_config select keep the local version currently installed" | debconf-set-selections
apt-get dist-upgrade -y
cat ~/domain bashrc >> ~/.bashrc
rm ~/domain bashrc
source ~/.bashrc
cd /etc/ssh
(echo PasswordAuthentication no; cat sshd_config) > .sshd_config.tmp
mv .sshd_config.tmp sshd_config
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
echo "/swapfile none swap sw 0 0" >> /etc/fstab
