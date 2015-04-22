#!/bin/bash
echo "******************************************"
echo "OCTOBER: http://{IP}/backend admin:admin"
echo "SSH: october:saulus"
echo "******************************************"

# Initialise all, only if not already exists
if [ ! -d /var/www/app/storage/temp/ ]; then
  
  mkdir /var/www/app/storage/temp/
  chown -R www-data:www-data /var/www/app/storage/temp/
  chmod -R 775 /var/www/app/storage/temp/

  #mysql has to be started this way as it doesn't work to call from /etc/init.d
  /usr/bin/mysqld_safe & 
  sleep 10s
  # Here we generate random passwords (thank you pwgen!).
  OCTOBER_DB="october"
  MYSQL_PASSWORD=`pwgen -c -n -1 12`
  OCTOBER_PASSWORD=`pwgen -c -n -1 12`
  #This is so the passwords show up in logs. 
  
  echo mysqluser root password: $MYSQL_PASSWORD
  echo mysqluser october password: $OCTOBER_PASSWORD
  echo $MYSQL_PASSWORD > /mysql-root-pw.txt
  echo $OCTOBER_PASSWORD > /october-db-pw.txt

  sed -e 's/CHANGE_ME!!!/'`pwgen -c -n -1 32`'/' /var/www/app/config/app.php > /var/www/app/config/app.php.temp
  mv /var/www/app/config/app.php.temp /var/www/app/config/app.php

  sed -e "s/=> 'database'/=> '$OCTOBER_DB'/;s/=> 'root'/=> 'october'/;s/'password'\s\s=>\s''/'password' => '$OCTOBER_PASSWORD'/" /var/www/app/config/database.php > /var/www/app/config/database.php.temp
  mv /var/www/app/config/database.php.temp /var/www/app/config/database.php

  mysqladmin -u root password $MYSQL_PASSWORD
  mysql -uroot -p$MYSQL_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'october'@'%' IDENTIFIED BY '$OCTOBER_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES;"
  mysql -uroot -p$MYSQL_PASSWORD -e "CREATE DATABASE "$OCTOBER_DB"; GRANT ALL PRIVILEGES ON "$OCTOBER_DB".* TO 'october'@'localhost' IDENTIFIED BY '$OCTOBER_PASSWORD'; FLUSH PRIVILEGES;"

  cd /var/www/ && php artisan october:up

  chown -R www-data:www-data /var/www/

  killall mysqld
fi

# start all the services
/usr/local/bin/supervisord -n
