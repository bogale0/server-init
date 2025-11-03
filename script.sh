if [ -z "$DOMAIN" ]; then
    cd backup
    source domain
    cat domain >> ~/.bashrc
    rm domain ~/init.tar.gz
fi
cd ~/modules
for module in $(ls [0-9][0-9]-*.sh); do
    read -p "Install module ${module:3:-3}? [Y/n] " result
    if [ "$result" != n ]; then
        source $module
        cd ~/modules
        rm $module
    fi
done
