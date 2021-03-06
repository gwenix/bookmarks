#!/usr/bin/perl

use DBI;
use strict;
use WWW::Mechanize;

use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname(dirname abs_path $0) . '/perl/lib';

use Gwen::Auth qw(ReadAuth);

$ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = 0;

# Getting the URL
my $url = shift(@ARGV);
$url = lc($url);
die "not a URL, please use ./addlinks [url]\n" if ($url !~ /^http/);

# Get auth credential info
my $authf = "cred";
my %cred = %{ ReadAuth($authf) };

my $dbh = DBI -> connect("dbi:Pg:dbname=$cred{name};host=$cred{host};port=$cred{port}",  
                            $cred{user},
                            $cred{pw},
                            {AutoCommit => 0, RaiseError => 1}
                         ) or die $DBI::errstr;

$dbh->trace(1,"trace.log");

# Other vars
my ($tagline, $description, $uid); #Stuff to feed the database

$description = GetInput("Description?");
$tagline = GetInput("Tags (comma to separate)?");

# Get the UID of the user in use. (At the immediate moment, that's just me)

my $query = qq(SELECT id FROM users WHERE username='$cred{uname}';);
my $sth = $dbh->prepare($query);
$sth->execute();
if(my @row = $sth->fetchrow_array) {
  print "ID: @row\n";
  $uid=$row[0];
} else {
  # should not get here. If we do, something is wrong.
  die "No user found: $cred{uname}\n";
} 
$sth->finish();

# check to see if the URL already exists.

my $urlexists=0;

$query = qq(
  select id
  from url
  where address='$url';
);
my $sth = $dbh->prepare($query);
$sth->execute();
if(my @row = $sth->fetchrow_array) {
  print "URL Exists, adding it.\n";
  $urlexists=1;
}
$sth->finish();

# if it did exist, check to see if this user already has a bookmark: add if not.
if ($urlexists) {
  print "not yet implemented.\n";


# If it does not, add the URL and the bookmark
} else {
  # find the url name
  my $mech = WWW::Mechanize->new();
  $mech->get( $url );
  my $title = $mech->title();

  $query = qq(
    INSERT INTO url
    (address, name, last_updated, created, created_by)
    VALUES
    (\'$url\', \'$title\', now(), now(), $uid);
  );
  print $query;
  print "Adding the URL...\n";
  $sth = $dbh->prepare($query);
  $sth->execute();
  $sth->finish();
  $query = qq(
    select *
    from url
    where address=\'$url\';
  );
  print "Added, found: ";
  $sth = $dbh->prepare($query);
  $sth->execute();
  if(my @row = $sth->fetchrow_array) {
    my $str = join (",",@row);
    print "URL added: $str\n";
  }
  $sth->finish();
}


# Update the tags.

# Clean up and exit

$dbh->disconnect();
exit(1);

# ----------- #
# Subroutines #
# ----------- #

sub GetInput {
  my $prompt = shift();
  my $in;

  print "$prompt ";
  $in = <STDIN>;
  chomp($in);
  $in = lc($in);
  
  return $in;
}
