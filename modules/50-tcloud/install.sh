apt-get install -y xxd
cd ~/secret
mv tcloud-client ~/.tcloud
curl -L -H "Authorization: token $(cat github)" -o tcloud.tar.gz https://api.github.com/repos/bogale0/Tcloud/tarball/main
tar xf tcloud.tar.gz
rm tcloud.tar.gz
mv *Tcloud* ~/Tcloud
make-site api.$DOMAIN
cd api.$DOMAIN/public_html
rm index.html
mv ~/Tcloud/api tcloud
chown www-data: tcloud/downloads
mv ~/secret/tcloud-api ../secret
chown -R root:www-data ../secret
chmod 640 ../secret/*
crontab-add-task "*/5 * * * * /usr/bin/php $PWD/tcloud/downloads/cleanup.php"
mariadb-create-user tcloud > /dev/null
source restore_backup.sh
rm restore_backup.sh
