if [ -z "$DOMAIN" ]; then
    read -p "Введите домен: " DOMAIN || exit
    printf "\nDOMAIN=$DOMAIN\n\n" >> ~/.bashrc
fi
if [[ ! -d "include" || -z "$(ls include)" ]]; then
    rm -rf include script
    exit
fi
cd include
echo "Выберите модули для установки / конфигурации"
for module in $(ls *.sh); do
    read -p "${module:3:-3}? y/N  " result
    if [ "$result" = "y" ]; then
        START_PATH=$PWD
        source $module
        cd $START_PATH
        rm $module
    fi
done
