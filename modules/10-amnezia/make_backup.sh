docker stop amnezia-awg2
tcloud upload ~/amnezia-conf backup/vpnconf/$(date -I)
docker start amnezia-awg2
