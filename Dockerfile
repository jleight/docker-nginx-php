FROM jleight/nginx:1.7.10
MAINTAINER Jonathon Leight <jonathon.leight@jleight.com>

RUN set -x \
  && apt-get update \
  && apt-get install -y php5 php5-fpm \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

RUN set -x \
  && sed 's|;\(cgi.fix_pathinfo\)=1|\1=0|g' \
    -i /etc/php5/fpm/php.ini \
  && sed 's|\(listen = \)127\.0\.0\.1:9000|\1/var/run/php5-fpm.sock|g' \
    -i /etc/php5/fpm/pool.d/www.conf \
  && sed 's|www-data|nginx|g' \
    -i /etc/php5/fpm/pool.d/www.conf \
  && sed 'x;/./{x;/#location/,+6s/#//;b};x;/#location/h' \
    -i /etc/nginx/conf.d/default.conf \
  && sed -E 's|(root\s+)html|\1/usr/share/nginx/html|g' \
    -i /etc/nginx/conf.d/default.conf \
  && sed 's|127.0.0.1:9000|unix:/var/run/php5-fpm.sock|g' \
    -i /etc/nginx/conf.d/default.conf \
  && sed 's|/scripts|$document_root|g' \
    -i /etc/nginx/conf.d/default.conf \
  && sed 's|index\.html|index.php index.html|g' \
    -i /etc/nginx/conf.d/default.conf \
  && sed 's/exec/sv start php5-fpm || exit 1\nexec/g' \
    -i /etc/service/nginx/run

ADD php5-fpm-service.sh /etc/service/php5-fpm/run