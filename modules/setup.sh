for i in {1..3}; do
    openssl enc -aes-128-cbc -pbkdf2 -d -in secret.enc -out secret.tar.gz && break
done
tar xzf secret.tar.gz || exit 1
rm secret.tar.gz init.tar.gz secret.enc
cd secret
mv tcloud-client ~/.tcloud
mv github ~/.ssh
cd ~/modules
cat domain bashrc >> ~/.bashrc
rm domain bashrc
source ~/.bashrc
update
cd /etc/ssh
sed -i "s/#\(PasswordAuthentication\).*/\1 no/" sshd_config
rm -f sshd_config.d/*
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
echo "/swapfile none swap sw 0 0" >> /etc/fstab
