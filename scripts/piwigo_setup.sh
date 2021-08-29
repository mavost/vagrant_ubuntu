#!/bin/sh
# to be run interactively after copying script to guest machine

export yourdomain=mydomain
export wwwowner=www-data
export myip=192.168.178.30
# test that /var/www/$yourdomain is writable, i.e. owned by www-user
if [ "$(stat -c "%U" "/var/www/$yourdomain")" = "$wwwowner" ]
then
    echo "/var/www/$yourdomain is owned by $wwwowner"
else
    echo "/var/www/$yourdomain is not owned by $wwwowner - changing owner"
    chown -R $wwwowner:$wwwowner /var/www/$yourdomain
fi

# install piwigo prerequisites
#apt-get -y install php libapache2-mod-php php-mysql php-imagick php-gd php-mbstring

# get piwigo netinstaller
#curl -fsSLo /var/www/$yourdomain/piwigo-netinstall.php https://piwigo.org/download/dlcounter.php?code=netinstall

# get piwigo Import Tree script - https://piwigo.org/ext/extension_view.php?eid=606
curl -fsSLo /var/www/$yourdomain/piwigo_import_tree.zip https://piwigo.org/ext/download.php?rid=4941 && \
  unzip /var/www/$yourdomain/piwigo_import_tree.zip && \
  chown www-data:www-data /var/www/$yourdomain/piwigo_import_tree.pl && \
  rm -f /var/www/$yourdomain/piwigo_import_tree.zip
# install piwigo Import Tree prerequisites
#apt-get -y install libio-all-lwp-perl libjson-perl


# install mount SMB (edit target)
#export smbserver=<server>
#export smbshare=<share>
#apt-get install -y cifs-utils
#mkdir -p /mnt/$smbshare
#mount -t cifs //$smbserver/$smbshare /mnt/$smbshare

# run installer in webbrowser
# firefox http://$myip/piwigo-netinstall.php
# run data import
perl /var/www/$yourdomain/piwigo_import_tree.pl --base_url=http://$myip/piwigo-gallery --user=admin --password=admin --directory=/mnt/$smbshare

# edit folder problem
#my $filepath = $params{dir}.'/.piwigo_import_tree.txt';
#  should be changed to
#my $filepath = $opt{directory}.'/.piwigo_import_tree.txt';
# disable strict 
#use strict;
nano /var/www/$yourdomain/piwigo_import_tree.pl

# edit maxuploadsize  --> upload_max_filesize = 8M
nano /etc/php/7.4/apache2/php.ini
systemctl reload apache2.service