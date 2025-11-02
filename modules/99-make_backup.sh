cd ~/backup
BACKUP_FILES=$(cat paths)
rm paths
for path in $BACKUP_FILES; do
    cd ${path%/*}
    FILE=${path##*/}
    tar czf $FILE.tar.gz $FILE
    HASH=$(sha256sum $FILE.tar.gz)
    TAR=${HASH%% *}.tar.gz
    echo $path $TAR >> ~/backup/paths
    mv $FILE.tar.gz $TAR
    mv $TAR ~/backup
done
