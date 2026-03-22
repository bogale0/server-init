apt install -y git
eval "$(ssh-agent -s)"
ssh-add .ssh/github-key
git clone git@github.com:bogale0/Tcloud.git
mariadb -e "source Tcloud/api/db.sql"
make-site api.$DOMAIN
cd api.$DOMAIN/public_html
rm index.html
mv ~/Tcloud/api tcloud
echo "*/5 * * * * /usr/bin/php $PWD/tcloud/downloads/cleanup.php" | crontab -
mv ~/secret ..
mkdir ../storage
chown www-data: ../storage
#mariadb-create-user
