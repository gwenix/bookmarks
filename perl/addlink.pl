#!/usr/bin/perl

use DBI;
use strict;
use LWP::Simple;

# Getting the URL
my $url = shift(@ARGV);
$url = lc($url);
die "not a URL, please use ./addlinks [url]\n" if ($url !~ /^http/);

# Database connection
my $dbname = 'linkdb';  
my $host = 'localhost';  
my $port = 5432;  
my $dbuser = 'gwen';  
my $dbpw = 'password123';  # yah, will do better passwording later
my $uname = 'gwenix';

my $dbh = DBI -> connect("dbi:Pg:dbname=$dbname;host=$host;port=$port",  
                            $dbuser,
                            $dbpw,
                            {AutoCommit => 0, RaiseError => 1}
                         ) or die $DBI::errstr;

$dbh->trace(1,"trace.log");

# Other vars
my ($tagline, $description, $uid); #Stuff to feed the database

$description = GetInput("Description?");
$tagline = GetInput("Tags (comma to separate)?");

$uid = GetUID($uname);

my $urlid = AddURL($url);

# bookmarks table:
#  urlid | ratingid | description | owned_by | created_at | id 
# -------+----------+-------------+----------+------------+----

# next up, add the bookmark.

# ----------- #
# Subroutines #
# ----------- #

sub AddURL {
  my ($url,$uid) = @_;
  my $query;

  if UrlExists($url) {
    # do nothing at this time
  } else {
    my $name = GetName($url);
    $query = qq(INSERT INTO url (address,name,last_updated,created_by) VALUES ('$url','$name',now(),$uid););
    $dbh->do($query);
    $dbh->commit or die $DBI::errstr;
  }

  my $urlid = $UrlExists($url);
  if ($urlid) {
    return $urlid;
  } else {
    die "URL $url not added.\n";
  }
  return 0; #should not reach here, but just in case...
}

sub UrlExists {
  my $url = shift();

  my $query = qq(SELECT id FROM url WHERE address = "$url";);

  my $sth = $dbh->prepare($query);
  $sth->execute();
  if(my @row = $sth->fetchrow_array) {
    return $row[0];
  }
  return 0;
}

sub GetUID {
  my $user = shift();
  my $id;

  # users table:
  #      name     | username | id 
  # --------------+----------+----

  my $query = qq(SELECT id FROM users WHERE username='$user';);
  my $sth = $dbh->prepare($query);
  $sth->execute();
  if(my @row = $sth->fetchrow_array) {
    #print "ID: @row\n";
    $id=$row[0];
  } else {
    die "No user found: $user\n";
  } 
  $sth->finish();

  return $id;
}

sub GetName {
  my $url = shift();

  # Collecting the data for the link
  my $html = get($url);
  $html =~ m{<TITLE>(.*?)</TITLE>}gism;
  $name = $1;
  $name = Sanitize($name);

  print "Name: $name\n";
  return $name;
}

sub Sanitize {
  my $word = shift();

  $word =~ s/\'//g;

  return $word;
}

sub GetInput {
  my $prompt = shift();
  my $in;

  print "$prompt ";
  $in = <STDIN>;
  chomp($in);
  $in = lc($in);
  
  return $in;
}
