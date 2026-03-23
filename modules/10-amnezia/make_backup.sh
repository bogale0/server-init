docker stop amnezia-awg
tcloud upload ~/amnezia-conf backup/vpnconf/$(date -I)
docker start amnezia-awg
