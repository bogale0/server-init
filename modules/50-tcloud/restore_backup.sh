GITHUB_TOKEN=$(cat ~/secret/github)
export $(curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/bogale0/Tcloud/releases/latest |
php -r '$res = json_decode(file_get_contents("php://stdin"), true);
echo "ASSET_URL=";
foreach ($res["assets"] as $asset) {
    if ($asset["name"] === "backup.enc") {
        echo $asset["url"];
        break;
    }
}')
cd /var/www/api.$DOMAIN
curl -L -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/octet-stream" -o backup.enc $ASSET_URL
tail -c +17 backup.enc > backup-iv.enc
openssl enc -aes-256-cbc -d -in backup-iv.enc -out backup.tar.zst -K $(xxd -p -c 32 ~/.tcloud/key) -iv $(xxd -p -l 16 backup.enc)
tar xf backup.tar.zst
mariadb < backup/db.sql
mv backup/storage storage
chown -R www-data: storage
rm -r backup*
