tcloud download backup/vpnconf/$BACKUP_DATE ~/vpnconf-backup || return 1
docker stop amnezia-awg
cd -P ~/amnezia-conf/..
rm -r awg
mv ~/vpnconf-backup awg
docker start amnezia-awg
