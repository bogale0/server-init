cd /var/www
mv ~/local/mariadb.users .
mariadb-backup-db wordpress > wordpress.sql
tcloud upload . backup/sites/$(date -I)
rm wordpress.sql
mv mariadb.users ~/local
