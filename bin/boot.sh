#!/usr/bin/env bash

if [ $mt_zip_url ]; then
  curl $mt_zip_url
  mt_zip=${mt_zip_url##*/}
  if [ -f $mt_zip ]; then
    unzip $mt_zip
  fi
fi

if [[ ! -f mt.psgi || ! -f mt.cgi ]]; then
  cp -r ./.mt/* ./
fi

if [ ! -f mt-config.cgi ]; then
  ./generate-mt-config.sh
fi

mkdir html
cp index.html html/
sed -i -e "s/mt\.cgi/\/mt\/mt\.cgi/g" html/index.html
sed -i -e "s/mt-check\.cgi/\/mt\/mt-check\.cgi/g" html/index.html

perl -Mlib=./local/lib/perl5 ./local/bin/starman --pid ./mt.pid ./mt.psgi &

vendor/bin/heroku-php-apache2 -c ./httpd.conf
