tar czf init.tar.gz backup modules script.sh
read -p "Enter domain (default: $DOMAIN): " CONNECTION
if [ -z "$CONNECTION" ]; then
    CONNECTION=$CONNECTION_SSH
else
    CONNECTION=root@$CONNECTION
fi
scp init.tar.gz $CONNECTION:
rm init.tar.gz
ssh $CONNECTION
