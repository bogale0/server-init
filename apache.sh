apt install -y apache2 php php-fpm certbot python3-certbot-apache mariadb-server php-mysql mariadb-client
PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
a2dismod php$PHP_VERSION mpm_prefork
a2enmod mpm_event proxy_fcgi http2
a2enconf php$PHP_VERSION-fpm
a2dissite 000-default.conf

cd /etc/apache2
sed -i "s/Indexes FollowSymLinks/-Indexes/" apache2.conf
cd sites-available
cp 000-default.conf $DOMAIN.conf
sed -i "s/#ServerName www.example.com/ServerName $DOMAIN/" $DOMAIN.conf
sed -i "s|DocumentRoot /var/www/html|Redirect permanent / http://www.$DOMAIN|" $DOMAIN.conf
a2ensite $DOMAIN
systemctl restart apache2

certbot register --agree-tos -m postmaster@$DOMAIN
certbot --apache -d $DOMAIN
make-site www
make-site mail
mariadb-secure-installation
