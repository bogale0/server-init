make-site() {
    local name=$1.$DOMAIN
    cd /var/www
    if [ -e "$name" -o -z "$1" ]; then
        echo "Сайт уже существует"
        return 1
    fi
    mkdir $name
    cp -r html $name/public_html
    cd /etc/apache2/sites-available
    cp 000-default.conf $name.conf
    sed -i "s/#ServerName www.example.com/ServerName $name/" $name.conf
    sed -i "s/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/$name\/public_html/" $name.conf
    a2ensite $name
    systemctl reload apache2
	 certbot --apache --expand -d $(ls /var/www | grep $DOMAIN | tr "\n" ",")$DOMAIN
}
