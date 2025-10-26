apt install -y postfix dovecot-imapd
cd /etc/postfix
WORD="smtpd_tls_cert_file"
CERT_PATH="/etc/letsencrypt/live"
sed -i "s|^$WORD=.*$|$WORD=$CERT_PATH/$DOMAIN/fullchain.pem|" main.cf
WORD="smtpd_tls_key_file"
sed -i "s|^$WORD=.*$|$WORD=$CERT_PATH/$DOMAIN/privkey.pem|" main.cf
echo "smtpd_use_tls = yes
local_recipient_maps = hash:/etc/postfix/valid_recipients
home_mailbox = Maildir/" >> main.cf
read -s -p "Пароль для postmaster: " PASSWORD
echo
mailuseradd postmaster $PASSWORD
sed -i "/^postmaster:/d" /etc/aliases
newaliases
systemctl restart postfix

cd /etc/dovecot/conf.d
WORD="auth_username_format ="
sed -i "s/^#$WORD .*$/$WORD %n/" 10-auth.conf
WORD="mail_location ="
sed -i "s|^$WORD .*$|$WORD maildir:~/Maildir|" 10-mail.conf
WORD="ssl_cert = "
sed -i "s|^$WORD.*$|$WORD<$CERT_PATH/$DOMAIN/fullchain.pem|" 10-ssl.conf
WORD="ssl_key = "
sed -i "s|^$WORD.*$|$WORD<$CERT_PATH/$DOMAIN/privkey.pem|" 10-ssl.conf
systemctl restart dovecot
