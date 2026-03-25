apt install -y xxd
cd
curl -L -H "Authorization: token $(cat ~/secret/github)" -o tcloud.tar.gz https://api.github.com/repos/bogale0/Tcloud/tarball/main
mkdir tmp
tar xzf tcloud.tar.gz -C tmp
mv tmp/* Tcloud
rm -r tmp tcloud.tar.gz
make-site api.$DOMAIN
cd api.$DOMAIN/public_html
rm index.html
mv ~/Tcloud/api tcloud
mkdir ../storage
chown www-data: ../storage tcloud/downloads
mv ~/secret/tcloud-api ../secret
chown -R root:www-data ../secret
crontab-add-task "*/5 * * * * /usr/bin/php $PWD/tcloud/downloads/cleanup.php"
mariadb-create-user tcloud
