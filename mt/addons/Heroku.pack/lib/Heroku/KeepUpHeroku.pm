package Heroku::KeepUpHeroku;
use strict;
use warnings;

sub keep_up {
    my $site
        = MT->model('blog')
        ->load( { class => '*' }, { sort => 'created_on', limit => 1 } )
        or return;

    my ($url) = $site->site_url =~ m{^(https?://(?:[^/]+))};
    my $path = MT->config->CGIPath;
    $path =~ s/^\/|\/$//g;
    $url = join '/', ( $url, $path, 'mt-keeup-up-heroku.cgi' );

    my $ret = `curl $url`;
    return $ret =~ m/Not Found/;
}

1;
