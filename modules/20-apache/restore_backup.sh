cd ~/backup/www
rm -r html
for file in $(ls); do
    make-site $file empty
    mv ~/backup/www/$file /var/www
done
rm -r ~/backup/www
ssl-cert-update sites