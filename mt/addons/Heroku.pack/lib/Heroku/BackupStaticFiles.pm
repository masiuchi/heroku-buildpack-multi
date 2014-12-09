package Heroku::BackupStaticFiles;
use strict;
use warnings;

use File::Spec;
use IO::All;

use MT::Session;

sub backup {
  my $temp_dir = MT->config->TempDir;
  my $backup_file = File::Spec->catfile( $temp_dir, 'backup.tar.gz' );
  `tar zcvf $backup_file /app/html/*`;
  my $backup = io($backup_file)->binary->all;

  MT::Session->remove({ kind => 'BK' });
  my $bk_sess = MT::Session->new;
  $bk_sess->set_values({
    id    => __PACKAGE__ . '::' . time,
    start => time,
    kind  => 'BK',
    data  => $backup,
  });
  $bk_sess->save or die $bk_sess->errstr;

  1;
}

sub restore {
  my $temp_dir = MT->config->TempDir;
  my $backup_file = File::Spec->catfile( $temp_dir, 'backup.tar.gz' );

  my $bk_sess = MT::Session->load({ kind => 'BK' }) or return;
  io($backup_file)->binary < $bk_sess;
  `tar xzf $backup_file -C /app/html/`
}

1;
