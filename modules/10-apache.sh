apt install -y apache2 php php-fpm certbot python3-certbot-apache php-mysql mariadb-server mariadb-client
PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
a2dismod php$PHP_VERSION mpm_prefork
a2enmod mpm_event proxy proxy_fcgi http2
a2enconf php$PHP_VERSION-fpm
a2dissite 000-default.conf

cd /etc/apache2
sed -i "s/\(Indexes\) FollowSymLinks/-\1/" apache2.conf
cd sites-available
cp 000-default.conf $DOMAIN.conf
sed -i -e "s|DocumentRoot .*|Redirect permanent / http://www.$DOMAIN|" \
-e "s/#\(ServerName\) .*/\1 $DOMAIN/" $DOMAIN.conf
a2ensite $DOMAIN
systemctl restart apache2

( set -e
certbot register --agree-tos --eff-email -m postmaster@$DOMAIN
certbot --apache -d $DOMAIN
make-site www )
mariadb-secure-installation
