PORT=39447
NAME=vault.$DOMAIN
make-site $NAME proxy / http://localhost:$PORT/
mkdir -m 700 /home/vaultwarden
cd /home/vaultwarden
mv ~/modules/40-vaultwarden/vw.env .env
(echo "DOMAIN=https://$NAME"; cat ~/secret/vw.token) >> .env
docker pull vaultwarden/server:latest
docker run -d --name vaultwarden -v $PWD/data:/data --env-file .env \
--restart unless-stopped -p 127.0.0.1:$PORT:80 vaultwarden/server:latest
