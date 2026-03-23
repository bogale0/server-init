cd /var/mail/vmail
mariadb-backup-db mail > mail.sql
tcloud upload . backup/email/$(date -I)
rm mail.sql
