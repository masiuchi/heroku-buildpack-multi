#!/usr/bin/env bash

if [[ "$DATABASE_URL" =~ ^postgres://([^:@/]+):([^:@/]+)@([^:@/]+):([^:@/]+)/([^:@/]+)$ ]]; then
  dbuser=${BASH_REMATCH[1]}
  dbpass=${BASH_REMATCH[2]}
  dbhost=${BASH_REMATCH[3]}
  dbport=${BASH_REMATCH[4]}
  db=${BASH_REMATCH[5]}
fi

cat << _CONFIG_
CGIPath /mt/
StaticWebPath /mt-static
StaticFilePath /app/mt-static

ObjectDriver DBI::postgres
DBHost $dbhost
DBPort $dbport
DBUser $dbuser
DBPassword $dbpass
Database $db

ImageDriver Imager

BaseSitePath /app/html

PIDFilePath /app/mt.pid

TransparentProxyIPs 1
_CONFIG_
