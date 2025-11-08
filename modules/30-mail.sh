apt install -y postfix postfix-mysql dovecot-imapd dovecot-mysql
VMAIL_DIR=/var/mail/vmail
useradd -d $VMAIL_DIR -m -s /usr/sbin/nologin vmail
chmod 700 $VMAIL_DIR
VMAIL_UID=$(id vmail -u)
VMAIL_GID=$(id vmail -g)
CERT_PATH=/etc/letsencrypt/live/certs
PASSWORD=$(mariadb-create-user mail)
mariadb -e "use mail;
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
mail-add-user postmaster@$DOMAIN

cd /etc/postfix
sed -i -e "s|\(smtpd_tls_cert_file=\).*|\1$CERT_PATH/fullchain.pem|" \
-e "s|\(smtpd_tls_key_file=\).*|\1$CERT_PATH/privkey.pem|" \
-e "s/\(myhostname =\).*/\1 mail.$DOMAIN/" \
-e "s/\(myorigin =\).*/\1 localhost/" \
-e "s/\(mydestination =\).*/\1/" main.cf
echo "local_recipient_maps =
smtpd_use_tls = yes
virtual_mailbox_base = $VMAIL_DIR
virtual_mailbox_domains = mysql:/etc/postfix/domains.cf
virtual_mailbox_maps = mysql:/etc/postfix/users.cf
virtual_uid_maps = static:$VMAIL_UID
virtual_gid_maps = static:$VMAIL_GID" >> main.cf
echo "hosts = 127.0.0.1
dbname = mail
user = mail
password = $PASSWORD" | tee domains.cf users.cf > /dev/null
chmod 640 domains.cf users.cf
chown root:postfix domains.cf users.cf
echo "query = select 'OK' from domains where domain = '%s'" >> domains.cf
echo "query = select concat(domain, '/', username, '/') from users inner join domains on domain_id = domains.id where username = '%u' and domain = '%d'" >> users.cf

cd /etc/dovecot/conf.d
sed -i -e "s/\!include.*system/#&/" \
-e "s/#\(\!include.*sql\)/\1/" 10-auth.conf
sed -i -e "s|^\(mail_location =\).*|\1 maildir:~/%d/%n|" \
-e "s/#\(mail_uid =\).*/\1 $VMAIL_UID/" \
-e "s/#\(mail_gid =\).*/\1 $VMAIL_GID/" 10-mail.conf
sed -i -e "s|\(ssl_cert =\).*|\1 <$CERT_PATH/fullchain.pem|" \
-e "s|\(ssl_key =\).*|\1 <$CERT_PATH/privkey.pem|" 10-ssl.conf
sed -i -e "s/#\(driver =\).*/\1 mysql/" \
-e "s/#\(connect =\).*/\1 host=127.0.0.1 dbname=mail user=mail password=$PASSWORD/" \
-e "s/#\(default_pass_scheme =\).*/\1 BLF-CRYPT/" ../dovecot-sql.conf.ext
echo "password_query = select username, domain, password from users inner join domains on domain_id = domains.id where username = '%n' and domain = '%d'
user_query = select '$VMAIL_DIR' as home" >> ../dovecot-sql.conf.ext
systemctl restart postfix dovecot
