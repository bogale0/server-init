docker stop vaultwarden
tcloud upload /home/vaultwarden/data backup/$(date -I)/vwdata
docker start vaultwarden
