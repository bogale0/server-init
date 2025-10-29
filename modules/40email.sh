apt install -y postfix dovecot-imapd
cd /etc/postfix
CERT_PATH="/etc/letsencrypt/live/$DOMAIN"
sed -i "s|^smtpd_tls_cert_file=.*$|smtpd_tls_cert_file=$CERT_PATH/fullchain.pem|" main.cf
sed -i "s|^smtpd_tls_key_file=.*$|smtpd_tls_key_file=$CERT_PATH/privkey.pem|" main.cf
sed -i "s/^myhostname = .*$/myhostname = mail.$DOMAIN/" main.cf
sed -i "s/^myorigin = .*$/myorigin = \$mydomain/" main.cf
sed -i "s/^mydestination = .*$/mydestination = \$myhostname, \$mydomain/" main.cf
echo "mydomain = $DOMAIN
smtpd_use_tls = yes
home_mailbox = Maildir/" >> main.cf
systemctl restart postfix

cd /etc/dovecot/conf.d
sed -i "s/^#auth_username_format = .*$/auth_username_format = mail-%Ln/" 10-auth.conf
sed -i "s|^mail_location = .*$|mail_location = maildir:~/Maildir|" 10-mail.conf
sed -i "s|^ssl_cert = .*$|ssl_cert = <$CERT_PATH/fullchain.pem|" 10-ssl.conf
sed -i "s|^ssl_key = .*$|ssl_key = <$CERT_PATH/privkey.pem|" 10-ssl.conf
systemctl restart dovecot
