#!/usr/bin/env bash

if [ $MT_ZIP ]; then
  curl $MT_ZIP
else
  mv ./.mt/* ./
fi

./generate-mt-config.sh

perl -Mlib=./local/lib/perl5 ./local/bin/starman --pid ./mt.pid ./mt.psgi &

vendor/bin/heroku-php-apache2 -c ./httpd.conf
