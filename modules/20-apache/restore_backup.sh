tcloud download backup/$BACKUP_DATE/sites ~/sites-backup || exit 1
cd ~/sites-backup
rm -r html
for url in *; do
    make-site $url empty
    mv $PWD/$url /var/www
done
rm -r $PWD
