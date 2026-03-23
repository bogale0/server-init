tcloud download backup/email/$BACKUP_DATE ~/email-backup || exit 1
cd /var/mail
rm -rf vmail
mv ~/email-backup vmail
mariadb < vmail/mail.sql
rm vmail/mail.sql
