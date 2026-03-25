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
cd /tmp
curl -L -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/octet-stream" -o backup.enc $ASSET_URL
tail -c +17 backup.enc > backup-iv.enc
openssl enc -aes-256-cbc -d -in backup-iv.enc -out backup.tar.gz -K $(xxd -p -c 32 ~/.tcloud/key) -iv $(xxd -p -l 16 backup.enc)
tar xzf backup.tar.gz
mariadb < backup.sql
rm backup*
