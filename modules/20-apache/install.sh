apt-get install -y apache2 php php-fpm php-curl php-mysql certbot python3-certbot-dns-cloudflare mariadb-server mariadb-client
PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION . '.' . PHP_MINOR_VERSION;")
a2dismod php$PHP_VERSION mpm_prefork
a2enmod mpm_event proxy_fcgi proxy_http http2 ssl
a2enconf php$PHP_VERSION-fpm
a2dissite 000-default.conf
sed -i "s/<domain>/$DOMAIN/" default-ssl.conf
mv *default*.conf /etc/apache2/sites-available
cd /etc/apache2/sites-available
sed -i "s/\(Indexes\) \(FollowSymLinks\)/-\1 +\2/" ../apache2.conf
systemctl restart apache2
certbot register --agree-tos --eff-email -m postmaster@$DOMAIN
certbot certonly --dns-cloudflare --dns-cloudflare-credentials ~/secret/cf.ini -d $DOMAIN -d "*.$DOMAIN"
make-site $DOMAIN empty
sed -i "s|DocumentRoot.*|Redirect permanent / https://www.$DOMAIN/|" $DOMAIN-ssl.conf
printf '\n\nn\n\n\n\n\n' | mariadb-secure-installation
