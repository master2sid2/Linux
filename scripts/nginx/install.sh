#!/bin/sh

DB_PASS=V4Eh2pj28pjEt6rK

sites=( tmp1.com tmp2.com)



for site in "${sites[@]}"; do

        mkdir /var/www/$site
        cp -R word_press/* /var/www/$site/
        chown -R nginx:nginx /var/www/$site
        chmod -R 774 /var/www/$site

        # generate nginx cnfig
        sed "s/SITE_NAME/server_name $site www.$site;/g" default.conf > tmp.dif
        sed "s/ROOT_PATH/root \/var\/www\/$site;/g" tmp.dif > /etc/nginx/conf.d/$site.conf
        rm -f tmp.dif

        #Create database and user
        tmp=`echo $site | sed 's/-/_/g'`
        tmp2=`echo $tmp | sed 's/\./_/g'`
        echo $tmp2
        mysql -p'Unix_gjllth;rf' -e "create user $tmp2@'%'"
        echo " create user "
        mysql -p'Unix_gjllth;rf' -e "create database $tmp2"
        echo " create database"
        mysql -p'Unix_gjllth;rf' -e "grant all privileges on $tmp2.* to $tmp2@'%' identified by '$DB_PASS'"
        echo " set previleges"

done

service nginx reload

