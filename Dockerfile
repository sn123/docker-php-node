FROM goavega/docker-nginx-fpm-node
LABEL MAINTAINER Goavega Docker Maintainers
RUN sed -i -E "s/;*clear_env\s*=\s*(yes|no)/clear_env=no/g" $fpm_pool
COPY ./wp_env.sh /usr/local/bin/
COPY ./entrypoint-app.sh /usr/local/bin/
RUN chmod u+x /usr/local/bin/entrypoint-app.sh
RUN chmod u+x /usr/local/bin/wp_env.sh

CMD ["entrypoint-app.sh"]
