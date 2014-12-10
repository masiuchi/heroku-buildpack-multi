package Heroku::KeepUpHeroku;
use strict;
use warnings;

use URI::Split qw/ uri_split uri_join /;

sub keep_up {
    my $site
        = MT->model('blog')
        ->load( { class => '*' }, { sort => 'created_on', limit => 1 } )
        or return;

    my ( $schema, $auth ) = uri_split( $site->site_url );
    my $url = uri_join(
        $schema, $auth,
        MT->config->AdminCGIPath,
        MT->config->AdminScript,
    );

MT->log( 'AdminCGIPath: '. MT->config->AdminCGIPath );
MT->log( 'AdminScript: ' . MT->config->AdminScript );
MT->log( 'url: ' . $url );

    `curl $url`;
}

1;
