package My::DBAuth;
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

  foreach my $l (@lines) {
    my ($key,$value) = split /:/,$l;

    if ($key eq "dbname") {
      $dbname = $value;
    } elsif ($key eq "host") {
      $host = $value;
    } elsif ($key eq "port") {
      $port = $value;
    } elsif ($key eq "dbuser") {
      $dbuser = $value;
    } elsif ($key eq "dbpw") {
      $dbpw = $value;
    } elsif ($key eq "uname") {
      $uname = $value;
    } else {
      print "Invalid key: $key\n";
    }
  }
  return 0 if (!$dbname || !$host || !$port || !$dbuser || !$dbpw || !$uname);

  return ($dbname,$host,$port,$dbuser,$dbpw,$uname);

}
