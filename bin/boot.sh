#!/usr/bin/env bash

if [ $MT_ZIP_URL ]; then
  curl -O $MT_ZIP_URL

  zip=${MT_ZIP_URL##*/}
  if [ -f $zip ]; then
    unzip $zip
  fi

  filename=${zip%.*}
  filename=${filename//_/.}
  if [ -d $filename ]; then
    cp -r $filename/* ./
  fi
fi

if [[ ! -f mt.psgi || ! -f mt.cgi ]]; then
  cp -r ./.mt/* ./
fi

if [ ! -f mt-config.cgi ]; then
  ./generate-mt-config.sh
fi

if [ -f index.html ]; then
  mkdir html
  cp index.html html/
  sed -i -e "s/mt\.cgi/\/mt\/mt\.cgi/g" html/index.html
  sed -i -e "s/mt-check\.cgi/\/mt\/mt-check\.cgi/g" html/index.html
fi

perl -Mlib=./local/lib/perl5 ./tools/restore-static-files

perl -Mlib=./local/lib/perl5 ./local/bin/starman --pid ./mt.pid ./mt.psgi &
perl -Mlib=./local/lib/perl5 ./tools/run-periodic-tasks -d &

vendor/bin/heroku-php-apache2 -c ./httpd.conf
