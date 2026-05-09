read -p "Enter domain name (default: '$DOMAIN'): " DOMAIN_NAME
if [ -z "$DOMAIN_NAME" ]; then
    DOMAIN_NAME=$DOMAIN
fi
CONNECTION=root@$DOMAIN_NAME
cd ~/.ssh
rm known_hosts*
cat tmp.pub server.pub | ssh $CONNECTION "cat > .ssh/authorized_keys" || exit 1
cd ~/server
printf "\nDOMAIN=$DOMAIN_NAME\n\n" > domain
tar czf init.tar.gz secret install.sh domain
scp init.tar.gz $CONNECTION:
rm init.tar.gz domain
ssh $CONNECTION "tar xzf init.tar.gz; source install.sh"
cd ~/.ssh
rm known_hosts*
echo ListenPort = 32488
echo $CONNECTION
cat tmp
