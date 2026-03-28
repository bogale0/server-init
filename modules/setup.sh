for i in {1..3}; do
    openssl enc -aes-128-cbc -pbkdf2 -d -in secret.enc -out secret.tar.gz && break
done
tar xzf secret.tar.gz || exit 1
rm secret.tar.gz init.tar.gz secret.enc
chown -R root: secret
cd secret
mv tcloud-client ~/.tcloud
cd ~/modules
cat domain bashrc >> ~/.bashrc
rm domain bashrc
source ~/.bashrc
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
cd /etc/ssh
(echo PasswordAuthentication no; cat sshd_config) > .sshd_config.tmp
mv .sshd_config.tmp sshd_config
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
echo "/swapfile none swap sw 0 0" >> /etc/fstab
