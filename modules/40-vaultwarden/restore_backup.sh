tcloud download backup/vwdata/$BACKUP_DATE ~/vwdata-backup || exit 1
docker stop vaultwarden
cd /home/vaultwarden
rm -r data
mv ~/vwdata-backup data
docker start vaultwarden
