if [ -z $DOMAIN ]; then
    NAME=~/modules/setup.sh
    source $NAME
    rm $NAME
    reboot
    exit
fi
cd ~/modules
for module in $(ls [0-9][0-9]-*/install.sh); do
    read -p "Install module ${module:3:-11}? [Y/n] " result
    if [ "$result" = n ]; then
        continue
    fi
    cd ${module%/*}
    source install.sh
    cd ~/modules
    rm $module
done
