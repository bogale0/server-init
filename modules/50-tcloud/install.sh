apt install -y git
eval "$(ssh-agent -s)"
ssh-add .ssh/github
git clone git@github.com:bogale0/Tcloud.git
cd /var/www/api.$DOMAIN/public_html
rm -r tcloud
mv ~/Tcloud/api tcloud
crontab-add-task "*/5 * * * * /usr/bin/php $PWD/tcloud/downloads/cleanup.php"
mv ~/secret ..
mkdir ../storage
chown www-data: ../storage tcloud/downloads
#mariadb-create-user
