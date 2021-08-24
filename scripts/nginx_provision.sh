#!/bin/sh
# REMINDER: no reboot within scripts
if [ -z "$1" ]
then
      echo "\$1 is empty"
      export mydomain="your_domain"
else
      echo "\$1 is NOT empty"
      export mydomain=$1
fi

if [ -z "$2" ]
then
      echo "\$2 is empty"
      export myuser="vagrant"
else
      echo "\$2 is NOT empty"
      export myuser=$2
fi

# APT im nichtinteraktiven Modus starten
export DEBIAN_FRONTEND=noninteractive

echo "... starting nginx provision"
# source: https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-20-04-de
apt-get -y install nginx

echo "... adjusting and enabling firewall"
ufw allow "Nginx HTTP"
ufw allow ssh
ufw --force enable
ufw status

echo "... adding server block, default website and ownership"
# default /var/www/html
mkdir -p /var/www/$mydomain/html
# server block configuration
sed 's/your_domain/'$mydomain'/g' /vagrant_data/configs/your_domain.conf > /etc/nginx/sites-available/$mydomain
# linking
ln -s /etc/nginx/sites-available/$mydomain /etc/nginx/sites-enabled/
# activation
sed -i 's/# server_names_hash_bucket_size/server_names_hash_bucket_size/' /etc/nginx/nginx.conf
systemctl restart nginx

echo "... default index.html and cloning docuserver files"
# heredoc format
cat <<EOF > /var/www/$mydomain/html/index.html
<html>
    <head>
        <title>Welcome to $mydomain!</title>
    </head>
    <body>
        <h1>Success! The $mydomain server block is working for owner $myuser!</h1>
        <a href="docuserver/index.html">Zur Doku-Wiki</a>
        <br />
    </body>
</html>
EOF
cd /var/www/$mydomain/html
git clone https://github.com/mavost/docuserver/

#optional
#adduser -g 'Nginx www user' -D $myuser
chown -R $myuser:$myuser /var/www/$mydomain
chmod -R 755 /var/www/$mydomain
echo "... nginx provision successful"

