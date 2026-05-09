export DEBIAN_FRONTEND=noninteractive
MODULES_DIR=~/server-init/modules
cd $MODULES_DIR
if [ -z $DOMAIN ]; then
    NAME=$PWD/setup.sh
    source $NAME
    rm $NAME
    reboot
    exit
fi
for target in $(ls [0-9][0-9]-*/install.sh); do
    read -p "Install module ${target:3:-11}? [Y/n] " result
    if [ "$result" = n ]; then
        return
    fi
    cd ${target%/*}
    source install.sh
    cd $MODULES_DIR
    rm $target
done
