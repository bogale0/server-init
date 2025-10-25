cd /etc/ssh
sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" sshd_config
sed -i "s/#Port 22/Port 17779/" sshd_config
rm -f sshd_config.d/*
systemctl restart sshd
