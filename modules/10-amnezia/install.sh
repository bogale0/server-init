sed -i "1s/^/#/" ~/.ssh/authorized_keys
cd /var/lib/docker/overlay2
NAME=$(ls -d *-init)
cd ${NAME%-*}/diff/opt/amnezia/awg
ln -s $PWD ~/amnezia-conf
speedtest
