package Gwen::Auth;
use strict;
use warnings;

use Exporter qw(import);

our @EXPORT_OK = qw(ReadAuth);

sub ReadAuth {
  my $f = shift();
  my ($dbname,$host,$port,$dbuser,$dbpw,$uname);

  open (F, "$f") or die "Cannot read $f: $!";
  my @lines = <F>;
  close (F);
  my %db;

  foreach my $l (@lines) {
    chomp($l);
    my ($key,$value) = split /:/,$l;

    if ($key eq "dbname") {
      $db{name} = $value;
    } elsif ($key eq "host") {
      $db{host} = $value;
    } elsif ($key eq "port") {
      $db{port} = $value;
    } elsif ($key eq "dbuser") {
      $db{user} = $value;
    } elsif ($key eq "dbpw") {
      $db{pw} = $value;
    } elsif ($key eq "uname") {
      $db{uname} = $value;
    } else {
      print "Invalid key: $key\n";
    }
  }
  die "Missing credentials.\n" if (!$db{name} || !$db{host} || !$db{port} || !$db{user} || !$db{pw});
  return \%db;
}
