apt install -y postfix dovecot-imapd
groupadd -g 5000 vmail
useradd -u 5000 -g vmail -d /var/mail/vmail -m -s /usr/sbin/nologin vmail
CERT_PATH="/etc/letsencrypt/live/$DOMAIN"

cd /etc/postfix
sed -i -e "s|\(smtpd_tls_cert_file=\).*|\1$CERT_PATH/fullchain.pem|" \
-e "s|\(smtpd_tls_key_file=\).*|\1$CERT_PATH/privkey.pem|" \
-e "s/\(myhostname =\) .*/mydomain = ${DOMAIN}\n\1 mail.\$mydomain/" \
-e "s/^\(myorigin =\) .*/\1 \$mydomain/" \
-e "s/\(mydestination =\) .*/\1 \$myhostname, \$mydomain/" main.cf
echo "smtpd_use_tls = yes
home_mailbox = Maildir/" >> main.cf

cd /etc/dovecot/conf.d
sed -i -e "s/\!include.*system/#&/" \
-e "s/#\(\!include.*passwdfile\)/\1/" 10-auth.conf
sed -i "s|^\(mail_location =\) .*|\1 maildir:/var/mail/vmail/%Lu/Maildir|" 10-mail.conf
sed -i -e "s|\(ssl_cert =\) .*|\1 <$CERT_PATH/fullchain.pem|" \
-e "s|\(ssl_key =\) .*|\1 <$CERT_PATH/privkey.pem|" 10-ssl.conf
systemctl restart postfix dovecot
