#!/usr/bin/env bash
perl -Mlib=./local/lib/perl5 ./tools/restore-static-files

perl -Mlib=./local/lib/perl5 ./local/bin/starman --pid ./mt.pid ./app.psgi &
perl -Mlib=./local/lib/perl5 ./tools/run-periodic-tasks -d &

vendor/bin/heroku-php-apache2 -c ./httpd.conf
