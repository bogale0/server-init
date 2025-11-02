cd /var/lib/docker/overlay2
WORD=$(ls -d *-init)
cd ${WORD%-init}/merged/opt/amnezia
ln -s $PWD ~/amnezia-conf
cd $START_PATH/../backup
for file in $(ls *.tar.gz); do
    tar xzf $file
    rm $file
done
