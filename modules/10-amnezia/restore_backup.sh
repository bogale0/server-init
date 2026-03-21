tcloud download backup/$BACKUP_DATE/vpnconf ~/vpnconf-backup || exit 1
docker stop amnezia-awg
cd -P ~/amnezia-conf/..
rm -r awg
mv ~/vpnconf-backup awg
docker start amnezia-awg
