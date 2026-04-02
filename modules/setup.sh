apt-get update
rm -r /etc/ssh/sshd_config.d
apt-get purge -y openssh-server
apt-get install -y zstd openssh-server
apt-get upgrade -y
cd ~/server-init/modules
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
