#!/bin/bash
if [ ! -d /usr/share/nginx/html/app/storage/temp/ ]; then
  
  mkdir /usr/share/nginx/html/app/storage/temp/
  chown -R www-data:www-data /usr/share/nginx/html/app/storage/temp/
  chmod -R 775 /usr/share/nginx/html/app/storage/temp/

  #mysql has to be started this way as it doesn't work to call from /etc/init.d
  /usr/bin/mysqld_safe & 
  sleep 10s
  # Here we generate random passwords (thank you pwgen!).
  OCTOBER_DB="october"
  MYSQL_PASSWORD=`pwgen -c -n -1 12`
  OCTOBER_PASSWORD=`pwgen -c -n -1 12`
  #This is so the passwords show up in logs. 
  
  echo mysql root password: $MYSQL_PASSWORD
  echo october password: $OCTOBER_PASSWORD
  echo $MYSQL_PASSWORD > /mysql-root-pw.txt
  echo $OCTOBER_PASSWORD > /october-db-pw.txt

  sed -e 's/CHANGE_ME!!!/'`pwgen -c -n -1 32`'/' /usr/share/nginx/html/app/config/app.php > /usr/share/nginx/html/app/config/app.php.temp
  mv /usr/share/nginx/html/app/config/app.php.temp /usr/share/nginx/html/app/config/app.php

  sed -e "s/=> 'database'/=> '$OCTOBER_DB'/;s/=> 'root'/=> 'october'/;s/'password' => ''/'password' => '$OCTOBER_PASSWORD'/" /usr/share/nginx/html/app/config/database.php > /usr/share/nginx/html/app/config/database.php.temp
  mv /usr/share/nginx/html/app/config/database.php.temp /usr/share/nginx/html/app/config/database.php

  mysqladmin -u root password $MYSQL_PASSWORD
  mysql -uroot -p$MYSQL_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'october'@'%' IDENTIFIED BY '$OCTOBER_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES;"
  mysql -uroot -p$MYSQL_PASSWORD -e "CREATE DATABASE "$OCTOBER_DB"; GRANT ALL PRIVILEGES ON "$OCTOBER_DB".* TO 'october'@'localhost' IDENTIFIED BY '$OCTOBER_PASSWORD'; FLUSH PRIVILEGES;"

  cd /usr/share/nginx/html/ && php artisan october:up

  chown -R www-data:www-data /usr/share/nginx/html/

  killall mysqld
fi

# start all the services
/usr/local/bin/supervisord -n
