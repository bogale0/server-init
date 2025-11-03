cd /var/lib/docker/overlay2
WORD=$(ls -d *-init)
cd ${WORD%-init}/merged/opt/amnezia
ln -s $PWD ~/amnezia-conf
