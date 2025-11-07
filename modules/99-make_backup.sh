cd ~/backup
for path in $(cat paths.bak); do
    cp -r $path .
done
