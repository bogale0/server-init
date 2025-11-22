cd ~/backup
for path in $(cat paths.bak); do
    ln -s $path .
done
cd ~
tar chzf backup.tar.gz backup
