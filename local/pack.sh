if [ -z $1 ]; then
    echo "Enter server ip address"
    return 1
fi
CONNECTION=root@$1
cd ~/.ssh
cat tmp.pub server.pub | ssh $CONNECTION "cat > .ssh/authorized_keys" || return 1
cd ~/server
tar -chzf init.tar.gz data secret
scp init.tar.gz $CONNECTION:
rm init.tar.gz
ssh $CONNECTION "tar xf init.tar.gz; source data/install.sh"
printf "ListenPort = "
cat ~/secret/vpn-port
echo $CONNECTION
cat ~/.ssh/tmp
