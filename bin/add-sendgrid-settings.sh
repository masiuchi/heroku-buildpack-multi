#!/usr/bin/env bash

cat << _SENDGRID_

MailTransfer smtp
SMTPAuth ssl
SMTPServer smtp.sendgrid.net
SMTPUser $SENDGRID_USERNAME
SMTPPassword $SENDGRID_PASSWORD
_SENDGRID_
