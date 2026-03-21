tcloud download backup/$BACKUP_DATE/email ~/email-backup || exit 1
cd /var/mail
rm -r vmail
mv ~/email-backup vmail
