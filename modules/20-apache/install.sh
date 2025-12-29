apt install -y apache2 php php-fpm certbot python3-certbot-dns-cloudflare php-mysql mariadb-server mariadb-client
PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
a2dismod php$PHP_VERSION mpm_prefork
a2enmod mpm_event proxy_fcgi proxy_http http2 ssl
a2enconf php$PHP_VERSION-fpm
a2dissite 000-default.conf
cd /etc/apache2
sed -i "s/\(Indexes\) \(FollowSymLinks\)/-\1 +\2/" apache2.conf
cd sites-available
mv ~/modules/20-apache/*default*.conf .
sed -i "s/<domain>/$DOMAIN/" default-ssl.conf
cp 000-default.conf $DOMAIN.conf
cp default-ssl.conf $DOMAIN-ssl.conf
sed -i -e "s|DocumentRoot.*|Redirect permanent / https://www.$DOMAIN/|" \
-e "s/<domain_name>/$DOMAIN/" $DOMAIN-ssl.conf
a2ensite $DOMAIN.conf $DOMAIN-ssl.conf
systemctl restart apache2
mariadb-secure-installation
certbot register --agree-tos --eff-email -m postmaster@$DOMAIN
read -s -p "Enter Cloudflare API Token: " CF_API_TOKEN
echo
cat <<EOF > ~/local/cf.ini
dns_cloudflare_api_token = $CF_API_TOKEN
EOF
unset CF_API_TOKEN
chmod 600 ~/local/cf.ini
certbot certonly --dns-cloudflare --dns-cloudflare-credentials ~/local/cf.ini -d $DOMAIN -d "*.$DOMAIN"