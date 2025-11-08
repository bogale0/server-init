cd /var/lib/docker/overlay2
NAME=$(ls -d *-init)
cd ${NAME%-*}/merged/opt/amnezia
ln -s $PWD ~/amnezia-conf
rm -r awg
mv ~/backup/awg .
docker restart amnezia-awg > /dev/null
