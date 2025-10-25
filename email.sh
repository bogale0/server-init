apt install -y postfix
cd /etc/postfix
sed -i "s|^smtpd_tls_cert_file=.*$|smtpd_tls_cert_file=/etc/letsencrypt/live/$DOMAIN/fullchain.pem|" main.cf
sed -i "s|^smtpd_tls_key_file=.*$|smtpd_tls_key_file=/etc/letsencrypt/live/$DOMAIN/privkey.pem|" main.cf
echo "smtpd_use_tls = yes
local_recipient_maps = hash:/etc/postfix/valid_recipients
home_mailbox = Maildir/" >> main.cf
read -s -p "Пароль для postmaster: " PASSWORD
echo
mailuseradd postmaster $PASSWORD
sed -i "/^postmaster:/d" /etc/aliases
newaliases
systemctl restart postfix

apt install -y dovecot-imapd
cd /etc/dovecot/conf.d
sed -i "s/^#auth_username_format = .*$/auth_username_format = %n/" 10-auth.conf
sed -i "s|^mail_location = .*$|mail_location = maildir:~/Maildir|" 10-mail.conf
sed -i "s|^ssl_cert = .*$|ssl_cert = </etc/letsencrypt/live/$DOMAIN/fullchain.pem|" 10-ssl.conf
sed -i "s|^ssl_key = .*$|ssl_key = </etc/letsencrypt/live/$DOMAIN/privkey.pem|" 10-ssl.conf
systemctl restart dovecot
