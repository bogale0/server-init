a2enmod proxy_http
systemctl restart apache2
PORT=38358
make-site vault.$DOMAIN proxy / http://localhost:$PORT/
sed -i "s|ProxyPass |ProxyPreserveHost On\n\t&|" $NAME.conf
systemctl reload apache2

mkdir /home/vaultwarden
cd /home/vaultwarden
chmod 700 .
mv ~/modules/vaultwarden.env .env
echo "DOMAIN=https://$NAME" >> .env

docker pull vaultwarden/server:latest
PASSWORD=$(password-gen)
docker run -d --name vaultwarden -v $PWD/data:/data --env-file .env \
-e ADMIN_TOKEN=$PASSWORD --restart unless-stopped -p 127.0.0.1:$PORT:80 \
vaultwarden/server:latest
echo "Admin token: $PASSWORD"
