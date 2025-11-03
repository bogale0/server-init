apt install -y postfix dovecot-imapd
VMAIL_DIR=/var/mail/vmail
useradd -d $VMAIL_DIR -m -s /usr/sbin/nologin vmail
chmod 700 $VMAIL_DIR
make-site mail
CERT_PATH=/etc/letsencrypt/live/$DOMAIN

cd /etc/postfix
sed -i -e "s|\(smtpd_tls_cert_file=\).*|\1$CERT_PATH/fullchain.pem|" \
-e "s|\(smtpd_tls_key_file=\).*|\1$CERT_PATH/privkey.pem|" \
-e "s/\(myhostname =\) .*/\1 mail.\$mydomain/" \
-e "s/^\(myorigin =\) .*/\1 \$mydomain/"
-e "s/mydestination = .*/mydomain = ${DOMAIN}/" main.cf
echo "smtpd_use_tls = yes
local_recipient_maps =
virtual_mailbox_base = $VMAIL_DIR
virtual_mailbox_domains = hash:/etc/postfix/domains
virtual_mailbox_maps = hash:/etc/postfix/users
virtual_uid_maps = static:$(id vmail -u)
virtual_gid_maps = static:$(id vmail -g)" >> main.cf
sed -i "/postmaster:/d" ../aliases
echo "$DOMAIN OK" > domains
postmap ../aliases domains

cd /etc/dovecot/conf.d
sed -i -e "s/\!include.*system/#&/" \
-e "s/#\(\!include.*passwdfile\)/\1/" 10-auth.conf
sed -i "s|^\(mail_location =\) .*|\1 maildir:$VMAIL_DIR/%n|" 10-mail.conf
sed -i -e "s|\(ssl_cert =\) .*|\1 <$CERT_PATH/fullchain.pem|" \
-e "s|\(ssl_key =\) .*|\1 <$CERT_PATH/privkey.pem|" 10-ssl.conf
systemctl restart postfix dovecot
