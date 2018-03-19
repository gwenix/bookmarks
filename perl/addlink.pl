#!/usr/bin/perl

use DBI;
use strict;

# Getting the URL
my $url = shift(@ARGV);
$url = lc($url);
die "not a URL, please use ./addlinks [url]\n" if ($url !~ /^http/);

# Database connection
my $dbname = 'linkdb';  
my $host = 'localhost';  
my $port = 5432;  
my $username = 'gwen';  
my $password = 'woodwell'; 

my $dbh = DBI -> connect("dbi:Pg:dbname=$dbname;host=$host;port=$port",  
                            $username,
                            $password,
                            {AutoCommit => 0, RaiseError => 1}
                         ) or die $DBI::errstr;

# Other vars
my ($tagline, $name, $description);

# Collecting the data
print "Adding $url ... \n";
$name = GetInput("Name?");
$description = GetInput("Description?");
$tagline = GetInput("Tags (comma to separate)?");


# Separating the tags

sub GetInput {
  my $prompt = shift();
  my $in;

  print "$prompt ";
  $in = <STDIN>;
  chomp($in);
  $in = lc($in);
  
  return $in;
}
