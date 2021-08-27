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

# start APT in non-interactive Mode
export DEBIAN_FRONTEND=noninteractive

echo "... starting LAMP provision - Apache web server"
# source: https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-20-04
apt-get -y install apache2

echo "... adjusting and enabling firewall"
ufw allow in "Apache"
ufw allow ssh
ufw --force enable
ufw status

echo "... continuing LAMP provision - MySQL database"
apt-get -y install mysql-server
export MYSQL_ROOT_PASSWORD=kolibri
# source: https://bertvv.github.io/notes-to-self/2015/11/16/automating-mysql_secure_installation/
# first line needed update
# add the following line if root password should be mandatory for login 
# UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE User = 'root';
# this is deprecated since v.8.0
# UPDATE mysql.user SET authentication_string = PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User='root';
# now using ALTER USER
mysql --user=root <<_EOF_
ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '$MYSQL_ROOT_PASSWORD';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
_EOF_

echo "... continuing LAMP provision - PHP interpreter"
apt-get -y install php libapache2-mod-php php-mysql

echo "... adding server block, default website and ownership"
# default /var/www/html
mkdir -p /var/www/$mydomain
# server block configuration
sed 's/your_domain/'$mydomain'/g' /vagrant_data/configs/your_domain_apache.conf > /etc/apache2/sites-available/$mydomain.conf
# linking
a2ensite $mydomain
# optional - disable default website
a2dissite 000-default

# activation # apache works without restart
systemctl reload apache2

echo "... generating basic index.html"
# heredoc format
cat <<_EOF_ > /var/www/$mydomain/index.html
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
_EOF_

echo "... generating basic index.php"
cat <<_EOF_ > /var/www/$mydomain/index.php
<?php 
    phpinfo();
?>
_EOF_

echo "... cloning docuserver files"
cd /var/www/$mydomain
git clone https://github.com/mavost/docuserver/


echo "... setting up sample database"
export MYSQL_DB=example_database
export MYSQL_TABLE=example_table
export MYSQL_USER=example_user
export MYSQL_USER_PASSWORD=kolibri123
mysql --user=root <<_EOF_
CREATE DATABASE $MYSQL_DB;
CREATE USER $MYSQL_USER@'%' IDENTIFIED WITH mysql_native_password BY $MYSQL_USER_PASSWORD;
GRANT ALL ON $MYSQL_DB.* TO $MYSQL_USER@'%';
CREATE TABLE $MYSQL_DB.$MYSQL_TABLE ( item_id INT AUTO_INCREMENT, content VARCHAR(255), PRIMARY KEY(item_id) );
INSERT INTO $MYSQL_DB.$MYSQL_TABLE (content) VALUES ("Apple");
INSERT INTO $MYSQL_DB.$MYSQL_TABLE (content) VALUES ("Eggs");
INSERT INTO $MYSQL_DB.$MYSQL_TABLE (content) VALUES ("Bread");
SELECT * FROM $MYSQL_DB.$MYSQL_TABLE;
_EOF_

echo "... setting up dynamic shopping_list.php"
cat <<_EOF_ > /var/www/$mydomain/shopping_list.php
<?php
  \$database = $MYSQL_DB;
  \$table = $MYSQL_TABLE;
  \$user = $MYSQL_USER;
  \$password = $MYSQL_USER_PASSWORD
  echo "Accessing the DB using PHP/PDO<br/>"
  echo "Shopping List:<br/>"
  try {
    \$db = new PDO("mysql:host=localhost;dbname=\$database", \$user, \$password);
    echo "<h2>TODO</h2><ol>";
    foreach(\$db->query("SELECT content FROM \$table") as \$row) {
      echo "<li>" . \$row['content'] . "</li>";
    }
    echo "</ol>";
  } catch (PDOException \$e) {
    print "Error!: " . \$e->getMessage() . "<br/>";
    die();
  }
?>
_EOF_

echo "... changing ownership of hosting content"
chown -R $myuser:$myuser /var/www/$mydomain
chmod -R 755 /var/www/$mydomain
echo "... LAMP provision completed"

