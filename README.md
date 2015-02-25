nginx-php
=========

The nginx-php image runs [nginx](http://nginx.org/) and [php](http://php.net/)
on top of the
[phusion/baseimage](https://registry.hub.docker.com/u/phusion/baseimage/)
container.


Usage
-----

You can get a simple php application server up and running by using the
following command:

```bash
$ docker run
  --name nginx \
  -p 0.0.0.0:80:80
  -v /some/php/app:/usr/share/nginx/html:ro
  jleight/nginx-php
```