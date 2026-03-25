apt install -y apache2 php php-fpm php-curl certbot python3-certbot-dns-cloudflare php-mysql mariadb-server mariadb-client
PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
a2dismod php$PHP_VERSION mpm_prefork
a2enmod mpm_event proxy_fcgi proxy_http http2 ssl
a2enconf php$PHP_VERSION-fpm
a2dissite 000-default.conf
sed -i "s/<domain>/$DOMAIN/" default-ssl.conf
cd /etc/apache2
sed -i "s/\(Indexes\) \(FollowSymLinks\)/-\1 +\2/" apache2.conf
cd sites-available
mv ~/modules/20-apache/*default*.conf .
make-site $DOMAIN empty
sed -i "s|DocumentRoot.*|Redirect permanent / https://www.$DOMAIN/|" $DOMAIN-ssl.conf
systemctl restart apache2
printf '\n\nn\n\n\n\n\n' | mariadb-secure-installation
certbot register --agree-tos --eff-email -m postmaster@$DOMAIN
certbot certonly --dns-cloudflare --dns-cloudflare-credentials ~/secret/cf.ini -d $DOMAIN -d "*.$DOMAIN"
