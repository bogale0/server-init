tcloud download backup/sites/$BACKUP_DATE ~/sites-backup || exit 1
cd ~/sites-backup
mariadb < wordpress.sql
mv mariadb.users ~/local
rm -r html wordpress.sql
mariadb-create-user wordpress all
for url in *; do
    make-site $url empty
    mv ~/sites-backup/$url /var/www
done
rm -r ~/sites-backup
