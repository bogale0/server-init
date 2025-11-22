sed -i "1s/^/#/" ~/.ssh/authorized_keys
cd /var/lib/docker/overlay2
NAME=$(ls -d *-init)
cd ${NAME%-*}/merged/opt/amnezia
ln -s $PWD/awg ~/amnezia-conf
rm -r awg
mv ~/backup/awg .
docker restart amnezia-awg
speedtest
