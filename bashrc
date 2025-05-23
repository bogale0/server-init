make-site() {
    local name=$DOMAIN
    local replace="Redirect permanent / http://www.$name"
    if [ -n "$1" ]; then
        name=$1.$name
        replace="DocumentRoot \/var\/www\/$name\/public_html"
        cd /var/www
        if [ -e "$name" ]; then
            echo "Сайт уже существует"
            return 1
        fi
        mkdir $name
        cp -r html $name/public_html
    fi
    cd /etc/apache2/sites-available
    cp 000-default.conf $name.conf
    sed -i "s/#ServerName www.example.com/ServerName $name/" $name.conf
    sed -i "s/DocumentRoot \/var\/www\/html/$replace/" $name.conf
    a2ensite $name
    systemctl reload apache2
    certbot --apache -d $name
}
