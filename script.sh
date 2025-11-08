if [ -z $DOMAIN ]; then
    NAME=~/modules/setup.sh
    source $NAME
    rm $NAME
    reboot
    exit
fi
cd ~/modules
for module in $(ls [0-9][0-9]-*.sh); do
    read -p "Install module ${module:3:-3}? [Y/n] " result
    if [ "$result" == n ]; then
        break
    fi
    source $module
    cd ~/modules
    rm $module
done
