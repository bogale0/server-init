chown -R root: data secret
cat <<EOF > /etc/sysctl.d/99-disable-ipv6.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF
sysctl -p /etc/sysctl.d/99-disable-ipv6.conf
curl -L -H "Authorization: token $(cat secret/github)" -o server-init.tar.gz https://api.github.com/repos/bogale0/server-init/tarball/main
tar xf server-init.tar.gz
rm server-init.tar.gz init.tar.gz
mv *server-init* server-init
source server-init/script.sh
