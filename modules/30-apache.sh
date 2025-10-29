apt install -y apache2 php php-fpm certbot python3-certbot-apache php-mysql mariadb-server mariadb-client
PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
a2dismod php$PHP_VERSION mpm_prefork
a2enmod mpm_event proxy_fcgi http2
a2enconf php$PHP_VERSION-fpm
a2dissite 000-default.conf

cd /etc/apache2
sed -i "s/Indexes FollowSymLinks/-Indexes/" apache2.conf
cd sites-available
cp 000-default.conf $DOMAIN.conf
sed -i "s/^#ServerName .*$/ServerName $DOMAIN/" $DOMAIN.conf
sed -i "s|^DocumentRoot .*$|Redirect permanent / http://www.$DOMAIN|" $DOMAIN.conf
a2ensite $DOMAIN
systemctl restart apache2

certbot register --agree-tos --eff-email -m postmaster@$DOMAIN
certbot --apache -d $DOMAIN
make-site www
mariadb-secure-installation
