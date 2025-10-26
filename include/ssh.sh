START_PATH=$PWD
cd /etc/ssh
WORD=PasswordAuthentication
sed -i "s/#$WORD yes/$WORD no/" sshd_config
#sed -i "s/#Port 22/Port 17779/" sshd_config
rm -f sshd_config.d/*
systemctl restart sshd
cd $START_PATH
rm ssh.sh
