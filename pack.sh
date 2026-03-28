read -p "Enter domain name (default: '$DOMAIN'): " CONNECTION
if [ -z "$CONNECTION" ]; then
    DOMAIN_NAME=$DOMAIN
else
    DOMAIN_NAME=$CONNECTION
fi
CONNECTION=root@$DOMAIN_NAME
cd ~/.ssh
cat temp.pub server.pub | ssh $CONNECTION "cat > .ssh/authorized_keys" || exit 1
cd -
printf "\nDOMAIN=$DOMAIN_NAME\n\n" > modules/domain
tar czf init.tar.gz secret.enc modules script.sh
scp init.tar.gz $CONNECTION:
rm init.tar.gz modules/domain
ssh $CONNECTION "tar xzf init.tar.gz; source script.sh"
echo $CONNECTION
cat ~/.ssh/temp
