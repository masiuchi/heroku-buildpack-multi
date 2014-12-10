package Heroku::KeepUpHeroku;
use strict;
use warnings;

sub keep_up {
    my $site
        = MT->model('blog')
        ->load( { class => '*' }, { sort => 'created_on', limit => 1 } )
        or return;

    my ($url) = $site->site_url =~ m{^(https?://(?:[^/]+))};
    my $path = MT->config->AdminCGIPath;
    $path =~ s/^\/|\/$//g;
    $url = join '/', ( $url, $path, MT->config->AdminScript );

MT->log( $url );

    `curl $url`;
}

1;
