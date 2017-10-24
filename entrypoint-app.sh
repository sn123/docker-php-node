#!/bin/bash
log(){
	while read line ; do
		echo "`date '+%D %T'` $line"
	done
}

set -e
logfile=/home/LogFiles/entrypoint.log
test ! -f $logfile && mkdir -p /home/LogFiles && touch $logfile
exec > >(log | tee -ai $logfile)
exec 2>&1

set_var_if_null(){
	local varname="$1"
	if [ ! "${!varname:-}" ]; then
		export "$varname"="$2"
	fi
}

set -e
echo 'INFO: starting ssh'
service ssh start
test ! -d "$APP_HOME" && echo "INFO: $APP_HOME not found. creating ..." && mkdir -p "$APP_HOME"
chown -R nginx:nginx $APP_HOME
test ! -d "$NGINX_LOG_DIR" && echo "INFO: $NGINX_LOG_DIR not found. creating ..." && mkdir -p "$NGINX_LOG_DIR"
chown -R nginx:nginx $NGINX_LOG_DIR
echo 'INFO: exporting variables'
wp_env.sh
echo 'INFO: starting node'
#done nothing for now
echo 'INFO: started node'
echo 'INFO: starting fpm'
service php7.0-fpm start
echo 'INFO: started FPM'
echo 'INFO: starting nginx'
/usr/sbin/nginx
