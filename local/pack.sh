DOMAIN_NAME=$DOMAIN
read -p "Enter domain name (default: '$DOMAIN_NAME'): " DOMAIN_NAME
ADDRESS=DOMAIN_NAME
read -p "Enter ip address (default: '$ADDRESS'): " ADDRESS
CONNECTION=root@$ADDRESS
unset ADDRESS
cd ~/.ssh
cat tmp.pub server.pub | ssh $CONNECTION "cat > .ssh/authorized_keys" || return
cd ~/server
printf "\nDOMAIN=$DOMAIN_NAME\n\n" > domain
unset DOMAIN_NAME 
tar czf init.tar.gz secret install.sh domain
scp init.tar.gz $CONNECTION:
rm init.tar.gz domain
ssh $CONNECTION "tar xzf init.tar.gz; source install.sh"
printf "ListenPort = "
cat secret/vpn-port
echo $CONNECTION
cat ~/.ssh/tmp
