read -p "Enter domain name (default: '$DOMAIN'): " CONNECTION
if [ -z "$CONNECTION" ]; then
    DOMAIN_NAME=$DOMAIN
else
    DOMAIN_NAME=$CONNECTION
fi
CONNECTION=root@$DOMAIN_NAME
printf "\nDOMAIN=$DOMAIN_NAME\n\n" > backup/domain
tar czf init.tar.gz backup modules script.sh
scp init.tar.gz $CONNECTION:
rm init.tar.gz backup/domain
ssh $CONNECTION
