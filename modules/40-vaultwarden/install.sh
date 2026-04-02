PORT=39447
NAME=vault.$DOMAIN
mkdir -m 700 /home/vaultwarden
mv vw.env /home/vaultwarden/.env
make-site $NAME proxy / http://localhost:$PORT/
cd /home/vaultwarden
(echo "DOMAIN=https://$NAME"; cat ~/secret/vw.token) >> .env
docker pull vaultwarden/server:latest
docker run -d --name vaultwarden -v $PWD/data:/data --env-file .env \
--restart unless-stopped -p 127.0.0.1:$PORT:80 vaultwarden/server:latest
