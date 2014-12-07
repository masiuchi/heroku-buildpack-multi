#!/usr/bin/env bash

if [[ "$DATABASE_URL" =~ ^postgres://([^:@/]+):([^:@/]+)@([^:@/]+):([^:@/]+)/([^:@/]+)$ ]]; then
  dbuser=${BASH_REMATCH[1]}
  dbpass=${BASH_REMATCH[2]}
  dbhost=${BASH_REMATCH[3]}
  dbport=${BASH_REMATCH[4]}
  db=${BASH_REMATCH[5]}
fi

cat << _CONFIG_ > /app/.mt/mt-config.cgi
CGIPath /mt/
StaticWebPath /mt-static
StaticFilePath /app/.mt/mt-static

ObjectDriver DBI::postgres
DBHost $dbhost
DBPort $dbport
DBUser $dbuser
DBPassword $dbpass
Database $db

ImageDriver Imager

PIDFilePath /app/.mt/mt.pid
_CONFIG_
