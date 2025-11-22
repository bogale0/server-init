apt install -y postfix postfix-mysql dovecot-imapd dovecot-mysql
VMAIL_DIR=/var/mail/vmail
useradd -d $VMAIL_DIR -m -s /usr/sbin/nologin vmail
chmod 700 $VMAIL_DIR
VMAIL_UID=$(id vmail -u)
VMAIL_GID=$(id vmail -g)
CERT_PATH=/etc/letsencrypt/live/certs
PASSWORD=$(mariadb-create-user mail)
mariadb -e "use mail;
create table aliases (
    id int auto_increment primary key,
    source varchar(255) unique not null,
    destination varchar(255) not null
);
create table domains (
    id int auto_increment primary key,
    domain varchar(64) unique not null
);
create table users (
    id int auto_increment primary key,
    username varchar(190) not null,
    password varchar(255) not null,
    domain_id int not null references domains(id) on delete cascade,
    unique (username, domain_id)
);"
mail-add-user me@$DOMAIN

cd /etc/postfix
sed -i -e "s|\(smtpd_tls_cert_file=\).*|\1$CERT_PATH/fullchain.pem|" \
-e "s|\(smtpd_tls_key_file=\).*|\1$CERT_PATH/privkey.pem|" \
-e "s/\(smtp_tls_security_level\).*/\1=encrypt/" \
-e "s/\(myhostname =\).*/\1 mail.$DOMAIN/" \
-e "s/\(myorigin =\).*/\1 localhost/" \
-e "s/\(mydestination =\).*/\1/" \
-e "s/\(relayhost =\).*/\1 [smtp.resend.com]:2587/" main.cf
echo "local_recipient_maps =
smtp_use_tls = yes
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/smtp_sasl
smtp_sasl_security_options = noanonymous
smtpd_use_tls = yes
smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_security_options = noanonymous
virtual_mailbox_base = $VMAIL_DIR
virtual_mailbox_domains = mysql:/etc/postfix/domains.cf
virtual_mailbox_maps = mysql:/etc/postfix/users.cf
virtual_alias_maps = mysql:/etc/postfix/aliases.cf
virtual_uid_maps = static:$VMAIL_UID
virtual_gid_maps = static:$VMAIL_GID" >> main.cf

read -p "Enter resend.com api key: " API_KEY
echo "[smtp.resend.com]:2587 resend:$API_KEY" > smtp_sasl
chmod 600 smtp_sasl
postmap smtp_sasl
sed -i -e "s/#\(submission \)/\1/" \
-e "s/#\(.*smtpd_tls_security_level=\)/\1/" \
-e "0,/#\(.*smtpd_sasl_auth_enable=\)/s//\1/" \
-e "0,/#\(.*smtpd_reject_unlisted_recipient=\)/s//\1/" \
-e "0,/#\(.*smtpd_recipient_restrictions=\)/s//\1/" master.cf
QUERY="aliases.cf domains.cf users.cf"
echo "hosts = 127.0.0.1
dbname = mail
user = mail
password = $PASSWORD" | tee $QUERY > /dev/null
chmod 640 $QUERY
chown root:postfix $QUERY
QUERY="query = select"
echo "$QUERY destination from aliases where source='%s'" >> aliases.cf
echo "$QUERY 'OK' from domains where domain='%s'" >> domains.cf
echo "$QUERY concat(domain,'/',username,'/') from users inner join domains on domain_id=domains.id where username='%u' and domain='%d'" >> users.cf

cd /etc/dovecot/conf.d
sed -i -e "s/\!include.*system/#&/" \
-e "s/#\(\!include.*sql\)/\1/" 10-auth.conf
sed -i -e "s|^\(mail_location =\).*|\1 maildir:~/%d/%n|" \
-e "s/#\(mail_uid =\).*/\1 $VMAIL_UID/" \
-e "s/#\(mail_gid =\).*/\1 $VMAIL_GID/" 10-mail.conf
sed -i "/unix_listener.*postfix/,/}/ s/#//" 10-master.conf
sed -i -e "s|\(ssl_cert =\).*|\1 <$CERT_PATH/fullchain.pem|" \
-e "s|\(ssl_key =\).*|\1 <$CERT_PATH/privkey.pem|" 10-ssl.conf
sed -i -e "s/#\(driver =\).*/\1 mysql/" \
-e "s/#\(connect =\).*/\1 host=127.0.0.1 dbname=mail user=mail password=$PASSWORD/" \
-e "s/#\(default_pass_scheme =\).*/\1 BLF-CRYPT/" ../dovecot-sql.conf.ext
echo "password_query = select username, domain, password from users inner join domains on domain_id = domains.id where username = '%n' and domain = '%d'
user_query = select '$VMAIL_DIR' as home" >> ../dovecot-sql.conf.ext
systemctl restart postfix dovecot
