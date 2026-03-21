PORT=39447
NAME=vault.$DOMAIN
make-site $NAME proxy / http://localhost:$PORT/
mkdir /home/vaultwarden
cd /home/vaultwarden
chmod 700 .
mv ~/modules/40-vaultwarden/vw.env .env
read -sp "Admin token: " TOKEN
echo -e "DOMAIN=https://$NAME\nADMIN_TOKEN=$TOKEN" >> .env
docker pull vaultwarden/server:latest
docker run -d --name vaultwarden -v $PWD/data:/data --env-file .env \
--restart unless-stopped -p 127.0.0.1:$PORT:80 vaultwarden/server:latest
