cd /var/lib/docker/overlay2
WORD=$(ls *-init)
cd ${WORD%-init}/merged/opt/amnezia
ln -s $PWD/awg ~/amnezia-conf
if [ -d ~/awg ]; then
    rm -rf awg
    mv ~/awg .
    docker restart amnezia-awg
fi
