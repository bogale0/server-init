if [ -z "$DOMAIN" ]; then
    read -p "Enter domain name: " DOMAIN
    printf "\nDOMAIN=$DOMAIN\n\n" >> ~/.bashrc
fi
MODULES=[0-9][0-9]-*.sh
if [[ ! -d modules || -z "$(ls modules/$MODULES)" ]]; then
    rm -rf modules script.sh
    exit
fi
cd modules
for module in $(ls $MODULES); do
    read -p "Install module ${module:3:-3}? y/N " result
    if [ "$result" = "y" ]; then
        START_PATH=$PWD
        source $module
        cd $START_PATH
        rm $module
    fi
done
