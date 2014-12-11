package Heroku::StopTaskLog;
use strict;
use warnings;

use MT::App;
use MT::TaskMgr;

sub override {
    my $run_tasks  = \&MT::TaskMgr::run_tasks;
    my $mt_log     = \&MT::log;
    my $mt_app_log = \&MT::App::log;

    no warnings 'redefine';
    *MT::TaskMgr::run_tasks = sub {
        local *MT::log      = sub { _new_log->( $mt_log,     @_ ) };
        local *MT::App::log = sub { _new_log->( $mt_app_log, @_ ) };
        $run_tasks->(@_);
    };
}

sub _new_log {
    my ( $original, $app, $msg ) = @_;
    return
           if ref $msg eq 'HASH'
        && $msg->{message}
        && $msg->{message} eq $app->translate("Scheduled Tasks Update");
    $original->( $app, $msg );
}

1;
