cd /var/lib/docker/overlay2
WORD=$(find . -maxdepth 1 -name "*-init")
cd ${WORD%-init}/merged/opt/amnezia
rm -rf awg
mv ~/awg .
docker restart amnezia-awg
