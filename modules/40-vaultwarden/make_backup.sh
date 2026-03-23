docker stop vaultwarden
tcloud upload /home/vaultwarden/data backup/vwdata/$(date -I)
docker start vaultwarden
