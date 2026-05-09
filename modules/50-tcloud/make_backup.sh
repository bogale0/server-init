cd /var/www/api.$DOMAIN
mkdir backup
mariadb-backup-db tcloud > backup/db.sql
cp -r storage backup
tcloud upload backup backup/tcloud/$(date -I)
tar -cf backup.tar.zst --zstd backup
openssl rand -out backup.enc 16
openssl enc -aes-256-cbc -in backup.tar.zst -K $(xxd -p -c 32 ~/.tcloud/key) -iv $(xxd -p backup.enc) >> backup.enc
rm -r backup backup.tar.zst
GITHUB_TOKEN=$(cat ~/secret/github)
export $(curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/bogale0/Tcloud/releases/latest |
php -r '$res = json_decode(file_get_contents("php://stdin"), true);
echo "UPLOAD_URL=" . strstr($res["upload_url"], "{", true) . "?name=backup.enc ASSET_URL=";
foreach ($res["assets"] as $asset) {
    if ($asset["name"] === "backup.enc") {
        echo $asset["url"];
        break;
    }
}')
if [ -n "$ASSET_URL" ]; then
    curl -X DELETE -H "Authorization: token $GITHUB_TOKEN" $ASSET_URL
fi
curl -X POST -H "Authorization: token $GITHUB_TOKEN" -H "Content-Type: application/octet-stream" --data-binary @backup.enc $UPLOAD_URL
rm backup.enc
