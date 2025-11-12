a2enmod proxy_http
systemctl restart apache2
make-site vault.$DOMAIN empty
PORT=38358
sed -i "s|\(DocumentRoot\).*|ProxyPreserveHost On\n\tProxyPass / http://localhost:$PORT/\n\tProxyPassReverse / http://localhost:$PORT/|" $NAME.conf
ssl-cert-update sites

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
