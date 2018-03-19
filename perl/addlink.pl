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

# Other vars
my ($tagline, $name, $description); #Stuff to feed the database

# Collecting the data for the link
print "Adding $url ... \n";
my $html = get($url);
$html =~ m{<TITLE>(.*?)</TITLE>}gism;
$name = $1;
print "Name: $title\n";

# url table:
#  id | address | name | last_updated | created | created_by 
# ----+---------+------+--------------+---------+------------



#$name = GetInput("Name?");
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
