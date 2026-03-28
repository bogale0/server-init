if [ -z $DOMAIN ]; then
    NAME=~/modules/setup.sh
    source $NAME
    rm $NAME
    reboot
    exit
fi
cd ~/modules
for target in $(ls [0-9][0-9]-*/install.sh); do
    read -p "Install module ${target:3:-11}? [Y/n] " result
    if [ "$result" = n ]; then
        return
    fi
    cd ${target%/*}
    source install.sh
    cd ~/modules
    rm $target
done
