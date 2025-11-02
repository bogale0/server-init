for line in $(cat ~/backup/paths); do
    FILE_PATH=${line% *}
    TAR=${line##* }
    rm -rf $FILE_PATH
    mv $TAR $FILE_PATH
done
