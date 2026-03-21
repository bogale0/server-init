docker stop amnezia-awg
tcloud upload ~/amnezia-conf backup/$(date -I)/vpnconf
docker start amnezia-awg
