#!/bin/sh
echo "... setting up sample database"
export MYSQL_DB=example_database
export MYSQL_TABLE=example_table
export MYSQL_USER=example_user
export MYSQL_USER_PASSWORD=kolibri123
mysql --user=root <<_EOF_
CREATE DATABASE $MYSQL_DB;
CREATE USER $MYSQL_USER@'%' IDENTIFIED WITH mysql_native_password BY '$MYSQL_USER_PASSWORD';
GRANT ALL ON $MYSQL_DB.* TO $MYSQL_USER@'%';
CREATE TABLE $MYSQL_DB.$MYSQL_TABLE ( item_id INT AUTO_INCREMENT, content VARCHAR(255), PRIMARY KEY(item_id) );
INSERT INTO $MYSQL_DB.$MYSQL_TABLE (content) VALUES ("Apple");
INSERT INTO $MYSQL_DB.$MYSQL_TABLE (content) VALUES ("Eggs");
INSERT INTO $MYSQL_DB.$MYSQL_TABLE (content) VALUES ("Bread");
SELECT * FROM $MYSQL_DB.$MYSQL_TABLE;
_EOF_
