read -p "Enter domain name (default: '$DOMAIN'): " CONNECTION
if [ -z "$CONNECTION" ]; then
    DOMAIN_NAME=$DOMAIN
else
    DOMAIN_NAME=$CONNECTION
fi
CONNECTION=root@$DOMAIN_NAME
printf "\nDOMAIN=$DOMAIN_NAME\n\n" > modules/domain
tar czf init.tar.gz backup modules script.sh
cd ~/.ssh
cat temp.pub server.pub | ssh $CONNECTION "cat > .ssh/authorized_keys"
cd -
scp init.tar.gz $CONNECTION:
rm init.tar.gz modules/domain
ssh $CONNECTION "tar xzf init.tar.gz; source script.sh"
echo $CONNECTION
cat ~/.ssh/temp
