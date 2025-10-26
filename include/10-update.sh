cat bashrc >> ~/.bashrc
source bashrc
rm bashrc
update
apt install -y speedtest-cli
speedtest-cli
cd /etc/ssh
WORD="PasswordAuthentication"
sed -i "s/#$WORD yes/$WORD no/" sshd_config
rm -f sshd_config.d/*
systemctl restart sshd
