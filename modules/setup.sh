apt-get update
apt-get install -y zstd
apt-get dist-upgrade -y
cat ~/data/domain bashrc >> ~/.bashrc
rm ~/data/domain bashrc
cd /etc/ssh
(echo PasswordAuthentication no; cat sshd_config) > .sshd_config.tmp
mv .sshd_config.tmp sshd_config
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
echo "/swapfile none swap sw 0 0" >> /etc/fstab
