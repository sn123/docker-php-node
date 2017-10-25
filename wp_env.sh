#!/bin/bash
#setup all env variables needed
set_var_if_null(){
        local varname="$1"
        if [ ! "${!varname:-}" ]; then
                export "$varname"="$2"
        fi
}

update_settings(){
      set_var_if_null "DB_NAME" "www"
      set_var_if_null "DB_USER" "db_user"
      set_var_if_null "DB_PWD" "!"
      set_var_if_null "DB_HOST" "localhost"
      set_var_if_null "NGINX_HOST" "_"
}

set -ex
update_settings
#for var in `printenv | cut -f1 -d=`; do if [ "${!var}" != *\!* ] && [[ "$var" =~ [A-Z] ]]; then echo "$var=\"${!var}\"" >> /etc/environment; fi; done;
#for var in `printenv | cut -f1 -d=`; do if [ "${!var}" != *\!* ] && [[ "$var" =~ [A-Z] ]]; then echo "$var=\"${!var}\"" >> /etc/environment; fi; done;
#sed -i 's/location ~ \\.php$ {/location ~ \\.php$ {\n\tfastcgi_param HELLO "WORLD";/g' ./testfile'''''
for var in `printenv | cut -f1 -d=`; do if [ "${!var}" != *\!* ] && [[ "$var" =~ [A-Z] ]]; then echo "fastcgi_param $var \"${!var}\";" >> ./enx; fi; done;
sed -i '/location ~ \\.php$ {/ r enx' /etc/nginx/conf.d/default.conf
#remove !
sed -i -e "s/!//g" ${fpm_pool}
sed -i -e "s/server_name _/server_name ${NGINX_HOST}/g" /etc/nginx/conf.d/default.conf
