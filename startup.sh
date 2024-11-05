#!/usr/bin/bash

export APP_SECRET=sekr3t

cd /var/www/registrar
# apache2-foreground
php -S 0.0.0.0:80 -t public/

